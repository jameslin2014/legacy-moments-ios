//
//  CaptureViewController.m
//  moments-test
//
//  Created by Douglas Bumby on 2014-11-29.
//  Copyright (c) 2014 Cosmic. All rights reserved.
//

#import "MOCaptureViewController.h"
#import "AFAmazonS3Manager.h"
#import "AFAmazonS3RequestSerializer.h"
#import "JGProgressHUD.h"
#import "SSKeychain.h"
@implementation MOCaptureViewController

- (BOOL)isSessionRunningAndDeviceAuthorized {
    return [[self session] isRunning] && [self isDeviceAuthorized];
}

+ (NSSet *)keyPathsForValuesAffectingSessionRunningAndDeviceAuthorized {
    return [NSSet setWithObjects:@"session.running", @"deviceAuthorized", nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Create the AVCaptureSession
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    [self setSession:session];
    [[self previewView] setSession:session];
    [self checkDeviceAuthorizationStatus];
    
    self.flashButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.flashButton addTarget:self action:@selector(flashButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.flashButton];
    
    dispatch_queue_t sessionQueue = dispatch_queue_create("session queue", DISPATCH_QUEUE_SERIAL);
    [self setSessionQueue:sessionQueue];
    
    dispatch_async(sessionQueue, ^{
        [self setBackgroundRecordingID:UIBackgroundTaskInvalid];
        
        NSError *error = nil;
    
        MOCaptureViewController *videoDevice = [MOCaptureViewController deviceWithMediaType:AVMediaTypeVideo preferringPosition:AVCaptureDevicePositionBack];
        AVCaptureDeviceInput *videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
        
        if (error) {
            NSLog(@"%@", error);
        }
        
        if ([session canAddInput:videoDeviceInput]) {
            [session addInput:videoDeviceInput];
            [self setVideoDeviceInput:videoDeviceInput];
            
        }
        
        AVCaptureDevice *audioDevice = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio] firstObject];
        AVCaptureDeviceInput *audioDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:audioDevice error:&error];
        
        if (error) {
            NSLog(@"%@", error);
        }
        
        if ([session canAddInput:audioDeviceInput]) {
            [session addInput:audioDeviceInput];
        }
        
        AVCaptureMovieFileOutput *movieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
        if ([session canAddOutput:movieFileOutput]) {
            [session addOutput:movieFileOutput];
            AVCaptureConnection *connection = [movieFileOutput connectionWithMediaType:AVMediaTypeVideo];
            if ([connection isVideoStabilizationSupported])
                [connection setPreferredVideoStabilizationMode:AVCaptureVideoStabilizationModeAuto];
            
            [self setMovieFileOutput:movieFileOutput];
        }
        
    });
}

- (void)viewWillAppear:(BOOL)animated {
    dispatch_async([self sessionQueue], ^{
        [self addObserver:self forKeyPath:@"sessionRunningAndDeviceAuthorized" options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew) context:SessionRunningAndDeviceAuthorizedContext];
        [self addObserver:self forKeyPath:@"movieFileOutput.recording" options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew) context:RecordingContext];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subjectAreaDidChange:) name:AVCaptureDeviceSubjectAreaDidChangeNotification object:[[self videoDeviceInput] device]];
        
        __weak MOCaptureViewController *weakSelf = self;
        [self setRuntimeErrorHandlingObserver:[[NSNotificationCenter defaultCenter] addObserverForName:AVCaptureSessionRuntimeErrorNotification object:[self session] queue:nil usingBlock:^(NSNotification *note) {
            MOCaptureViewController *strongSelf = weakSelf;
            dispatch_async([strongSelf sessionQueue], ^{
                // Manually restarting the session since it must have been stopped due to an error.
                [[strongSelf session] startRunning];
                [[strongSelf recordButton] setTitle:NSLocalizedString(@"Record", @"Recording button record title") forState:UIControlStateNormal];
            });
        }]];
        [[self session] startRunning];
    });
}

- (void)viewDidDisappear:(BOOL)animated {
    dispatch_async([self sessionQueue], ^{
        [[self session] stopRunning];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVCaptureDeviceSubjectAreaDidChangeNotification object:[[self videoDeviceInput] device]];
        [[NSNotificationCenter defaultCenter] removeObserver:[self runtimeErrorHandlingObserver]];
        
        [self removeObserver:self forKeyPath:@"sessionRunningAndDeviceAuthorized" context:SessionRunningAndDeviceAuthorizedContext];
        [self removeObserver:self forKeyPath:@"movieFileOutput.recording" context:RecordingContext];
    });
}

- (BOOL)shouldAutorotate {
    return ![self lockInterfaceRotation];
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (IBAction)flashButtonAction:(UIButton *)sender {
    AVCaptureDevice *flash = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    if ([flash isTorchAvailable] && [flash isTorchModeSupported:AVCaptureTorchModeOn]) {
        BOOL success = [flash lockForConfiguration:nil];
        
        if (success) {
            if ([flash isTorchActive]) {
                [flash setTorchMode:AVCaptureTorchModeOff];
				sender.tintColor = [UIColor whiteColor];
            } else {
                [flash setTorchMode:AVCaptureTorchModeOn];
				sender.tintColor = [UIColor yellowColor];
				sender.titleLabel.text = @"On";
            }
            [flash unlockForConfiguration];
        }
    }
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [[(AVCaptureVideoPreviewLayer *)[[self previewView] layer] connection] setVideoOrientation:(AVCaptureVideoOrientation)toInterfaceOrientation];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context == RecordingContext) {
        BOOL isRecording = [change[NSKeyValueChangeNewKey] boolValue];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (isRecording) {
                [[self cameraButton] setEnabled:NO];
                [[self recordButton] setTitle:NSLocalizedString(@"Stop", @"Recording button stop title") forState:UIControlStateNormal];
                [[self recordButton] setEnabled:YES];
                
            } else {
                
                [[self cameraButton] setEnabled:YES];
                [[self recordButton] setTitle:NSLocalizedString(@"Record", @"Recording button record title") forState:UIControlStateNormal];
                [[self recordButton] setEnabled:YES];
            }
        });
        
    } else if (context == SessionRunningAndDeviceAuthorizedContext) {
        BOOL isRunning = [change[NSKeyValueChangeNewKey] boolValue];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (isRunning) {
                [[self cameraButton] setEnabled:YES];
                [[self recordButton] setEnabled:YES];
            } else {
                [[self cameraButton] setEnabled:NO];
                [[self recordButton] setEnabled:NO];
            }
        });
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark Actions
- (IBAction)toggleMovieRecording:(id)sender {
    [[self recordButton] setEnabled:NO];
    
    dispatch_async([self sessionQueue], ^{
        if (![[self movieFileOutput] isRecording]) {
            [self setLockInterfaceRotation:YES];
            
            if ([[UIDevice currentDevice] isMultitaskingSupported]) {
                [self setBackgroundRecordingID:[[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil]];
            }
            
            // Update the orientation on the movie file output video connection before starting recording.
            [[[self movieFileOutput] connectionWithMediaType:AVMediaTypeVideo] setVideoOrientation:AVCaptureVideoOrientationPortrait];
            
            // Turning OFF flash for video recording
            [MOCaptureViewController setFlashMode:AVCaptureFlashModeOff forDevice:[[self videoDeviceInput] device]];
            
            // Start recording to a temporary file.
            NSString *outputFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:[@"movie" stringByAppendingPathExtension:@"mov"]];
            [[self movieFileOutput] startRecordingToOutputFileURL:[NSURL fileURLWithPath:outputFilePath] recordingDelegate:self];
        } else {
            [[self movieFileOutput] stopRecording];
        }
    });
}

- (IBAction)changeCamera:(id)sender {
    [[self cameraButton] setEnabled:NO];
    [[self recordButton] setEnabled:NO];
	
    dispatch_async([self sessionQueue], ^{
        AVCaptureDevice *currentVideoDevice = [[self videoDeviceInput] device];
        AVCaptureDevicePosition preferredPosition = AVCaptureDevicePositionUnspecified;
        AVCaptureDevicePosition currentPosition = [currentVideoDevice position];
        
        switch (currentPosition) {
            case AVCaptureDevicePositionUnspecified:
                preferredPosition = AVCaptureDevicePositionBack;
                break;
            case AVCaptureDevicePositionBack:
                preferredPosition = AVCaptureDevicePositionFront;
                break;
            case AVCaptureDevicePositionFront:
                preferredPosition = AVCaptureDevicePositionBack;
                break;
        }
        
        AVCaptureDevice *videoDevice = [MOCaptureViewController deviceWithMediaType:AVMediaTypeVideo preferringPosition:preferredPosition];
        AVCaptureDeviceInput *videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:nil];
        
        [[self session] beginConfiguration];
        
        [[self session] removeInput:[self videoDeviceInput]];
        if ([[self session] canAddInput:videoDeviceInput]) {
            [[NSNotificationCenter defaultCenter] removeObserver:self name:AVCaptureDeviceSubjectAreaDidChangeNotification object:currentVideoDevice];
            
            [MOCaptureViewController setFlashMode:AVCaptureFlashModeAuto forDevice:videoDevice];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subjectAreaDidChange:) name:AVCaptureDeviceSubjectAreaDidChangeNotification object:videoDevice];
            
            [[self session] addInput:videoDeviceInput];
            [self setVideoDeviceInput:videoDeviceInput];
            
        } else {
            [[self session] addInput:[self videoDeviceInput]];
        }
        
        [[self session] commitConfiguration];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[self cameraButton] setEnabled:YES];
            [[self recordButton] setEnabled:YES];
        });
    });
}



- (IBAction)focusAndExposeTap:(UIGestureRecognizer *)gestureRecognizer {
    CGPoint devicePoint = [(AVCaptureVideoPreviewLayer *)[[self previewView] layer] captureDevicePointOfInterestForPoint:[gestureRecognizer locationInView:[gestureRecognizer view]]];
    [self focusWithMode:AVCaptureFocusModeAutoFocus exposeWithMode:AVCaptureExposureModeAutoExpose atDevicePoint:devicePoint monitorSubjectAreaChange:YES];
}

- (void)subjectAreaDidChange:(NSNotification *)notification {
    CGPoint devicePoint = CGPointMake(.5, .5);
    [self focusWithMode:AVCaptureFocusModeContinuousAutoFocus exposeWithMode:AVCaptureExposureModeContinuousAutoExposure atDevicePoint:devicePoint monitorSubjectAreaChange:NO];
}

#pragma mark File Output Delegate

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error {
    if (error) {
        NSLog(@"%@", error);
    }
    JGProgressHUD *HUD = [[JGProgressHUD alloc] initWithStyle:JGProgressHUDStyleLight];
    [HUD showInView:self.view animated:YES];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"merged2.mp4"];
    [fileManager removeItemAtPath:filePath error:&error];
    NSString *user = [NSString stringWithFormat:@"%@.mp4",[SSKeychain passwordForService:@"moments" account:@"username"]];
    AVAsset *firstVid = [AVAsset assetWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://s3.amazonaws.com/moments-videos/%@",user]]];
    AVAsset *secondVid = [AVAsset assetWithURL:outputFileURL];
    NSArray *assets = @[firstVid, secondVid];
    AVMutableComposition *mutableComposition = [AVMutableComposition composition];
    AVMutableCompositionTrack *videoCompositionTrack = [mutableComposition addMutableTrackWithMediaType:AVMediaTypeVideo
                                                                                       preferredTrackID:kCMPersistentTrackID_Invalid];
    AVMutableCompositionTrack *audioCompositionTrack = [mutableComposition addMutableTrackWithMediaType:AVMediaTypeAudio
                                                                                       preferredTrackID:kCMPersistentTrackID_Invalid];
    
    NSMutableArray *instructions = [NSMutableArray new];
    CGSize size = CGSizeMake([[assets objectAtIndex:1] naturalSize].height, [[assets objectAtIndex:1] naturalSize].width);

    
    CMTime time = kCMTimeZero;
    for (AVAsset *asset in assets) {
        AVAssetTrack *assetTrack = [asset tracksWithMediaType:AVMediaTypeVideo].firstObject;
        AVAssetTrack *audioAssetTrack = [asset tracksWithMediaType:AVMediaTypeAudio].firstObject;
        
        NSError *error;
        [videoCompositionTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, assetTrack.timeRange.duration)
                                       ofTrack:assetTrack
                                        atTime:time
                                         error:&error];
        if (error) {
            NSLog(@"Error - %@", error.debugDescription);
        }
        
        [audioCompositionTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, assetTrack.timeRange.duration)
                                       ofTrack:audioAssetTrack
                                        atTime:time
                                         error:&error];
        if (error) {
            NSLog(@"Error - %@", error.debugDescription);
        }
        
        AVMutableVideoCompositionInstruction *videoCompositionInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
        videoCompositionInstruction.timeRange = CMTimeRangeMake(time, assetTrack.timeRange.duration);
        videoCompositionInstruction.layerInstructions = @[[AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoCompositionTrack]];
        [instructions addObject:videoCompositionInstruction];
        CGAffineTransform rotation = CGAffineTransformMakeRotation(M_PI_2);
        CGAffineTransform translateToCenter = CGAffineTransformMakeTranslation(640, 480);
        CGAffineTransform mixedTransform = CGAffineTransformConcat(rotation, translateToCenter);
        AVMutableVideoCompositionLayerInstruction *FirstlayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoCompositionTrack];
        [videoCompositionTrack setPreferredTransform:CGAffineTransformConcat(rotation,translateToCenter)];
        time = CMTimeAdd(time, assetTrack.timeRange.duration);
        
        if (CGSizeEqualToSize(size, CGSizeZero)) {
            size = assetTrack.naturalSize;;
        }
    }
    
    AVMutableVideoComposition *mutableVideoComposition = [AVMutableVideoComposition videoComposition];
    mutableVideoComposition.instructions = instructions;
    
    // Set the frame duration to an appropriate value (i.e. 30 frames per second for video).
    mutableVideoComposition.frameDuration = CMTimeMake(1, 30);
    mutableVideoComposition.renderSize = size;

    AVPlayerItem *pi = [AVPlayerItem playerItemWithAsset:mutableComposition];
    pi.videoComposition = mutableVideoComposition;
    
    AVPlayer *player = [AVPlayer playerWithPlayerItem:pi];
    AVAssetExportSession *exportSession =  [AVAssetExportSession exportSessionWithAsset:pi.asset presetName:AVAssetExportPresetMediumQuality];
    NSString* documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* path = [documentPath stringByAppendingPathComponent:@"merged2.mp4"];
    NSURL* movieURL = [NSURL fileURLWithPath: path];
    exportSession.outputURL = movieURL;
    exportSession.outputFileType = AVFileTypeMPEG4;
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        NSLog(@"done");
        NSLog(@"%@",exportSession.outputURL);
        
        [self setLockInterfaceRotation:NO];
        
        UIBackgroundTaskIdentifier backgroundRecordingID = [self backgroundRecordingID];
        [self setBackgroundRecordingID:UIBackgroundTaskInvalid];
        
        AFAmazonS3Manager *s3Manager =
        [[AFAmazonS3Manager alloc] initWithAccessKeyID:@"AKIAIVV5BPQF5DZFC26Q"
                                                secret:@"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"];
        s3Manager.requestSerializer.region = AFAmazonS3USStandardRegion;
        s3Manager.requestSerializer.bucket = @"moments-videos";
        
        
        NSString *user = [NSString stringWithFormat:@"%@.mp4",[SSKeychain passwordForService:@"moments" account:@"username"]];
        NSURL *url = [s3Manager.baseURL URLByAppendingPathComponent:user];
        NSMutableURLRequest *originalRequest = [[NSMutableURLRequest alloc] initWithURL:url];
        originalRequest.HTTPMethod = @"PUT";
        originalRequest.HTTPBody = [NSData dataWithContentsOfURL:movieURL];
        [originalRequest setValue:@"video/mp4" forHTTPHeaderField:@"Content-Type"];
        NSURLRequest *request = [s3Manager.requestSerializer
                                 requestBySettingAuthorizationHeadersForRequest:originalRequest
                                 error:nil];
        
        
        AFHTTPRequestOperation *operation = [s3Manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
            // Success!
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error uploading %@", error);
        }];
        [s3Manager.operationQueue addOperation:operation];
        
        
        AFAmazonS3Manager *s3Manager2 =
        [[AFAmazonS3Manager alloc] initWithAccessKeyID:@"AKIAIVV5BPQF5DZFC26Q"
                                                secret:@"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"];
        s3Manager2.requestSerializer.region = AFAmazonS3USStandardRegion;
        s3Manager2.requestSerializer.bucket = @"moments-videos";
        
        AVAsset *asset = [AVAsset assetWithURL:movieURL];
        AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc]initWithAsset:asset];
        CMTime time3 = CMTimeMake(1, 0);
        CGImageRef imageRef = [imageGenerator copyCGImageAtTime:asset.duration actualTime:&time3 error:NULL];
        UIImage *thumbnail = [UIImage imageWithCGImage:imageRef];
        CGImageRef imageRef2 = CGImageCreateWithImageInRect([thumbnail CGImage], CGRectMake(0, 0, 200, 200));
        UIImage *cropped = [UIImage imageWithCGImage:imageRef];
        CGImageRelease(imageRef2);
        
        NSString *user2 = [NSString stringWithFormat:@"%@.jpg",[SSKeychain passwordForService:@"moments" account:@"username"]];
        NSURL *url2 = [s3Manager.baseURL URLByAppendingPathComponent:user2];
        NSMutableURLRequest *originalRequest2 = [[NSMutableURLRequest alloc] initWithURL:url2];
        originalRequest2.HTTPMethod = @"PUT";
        originalRequest2.HTTPBody = UIImageJPEGRepresentation(cropped, 0.2f);
        [originalRequest2 setValue:@"image/jpg" forHTTPHeaderField:@"Content-Type"];
        
        NSURLRequest *request2 = [s3Manager2.requestSerializer
                                  requestBySettingAuthorizationHeadersForRequest:originalRequest2
                                  error:nil];
        
        
        AFHTTPRequestOperation *operation2 = [s3Manager2 HTTPRequestOperationWithRequest:request2 success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [HUD dismissAnimated:YES];
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            [self.navigationController.view setUserInteractionEnabled:true];
            NSLog(@"success");
            NSLog(@"%@",operation.request.allHTTPHeaderFields);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error uploading %@", error);
        }];
        [s3Manager2.operationQueue addOperation:operation2];
    }];
    
}
#pragma mark Device Configuration

- (void)focusWithMode:(AVCaptureFocusMode)focusMode exposeWithMode:(AVCaptureExposureMode)exposureMode atDevicePoint:(CGPoint)point monitorSubjectAreaChange:(BOOL)monitorSubjectAreaChange {
    dispatch_async([self sessionQueue], ^{
        AVCaptureDevice *device = [[self videoDeviceInput] device];
        NSError *error = nil;
        if ([device lockForConfiguration:&error]) {
            
            if ([device isFocusPointOfInterestSupported] && [device isFocusModeSupported:focusMode]) {
                [device setFocusMode:focusMode];
                [device setFocusPointOfInterest:point];
            }
            
            if ([device isExposurePointOfInterestSupported] && [device isExposureModeSupported:exposureMode]) {
                [device setExposureMode:exposureMode];
                [device setExposurePointOfInterest:point];
            }
            
            [device setSubjectAreaChangeMonitoringEnabled:monitorSubjectAreaChange];
            [device unlockForConfiguration];
        } else {
            NSLog(@"%@", error);
        }
    });
}

+ (void)setFlashMode:(AVCaptureFlashMode)flashMode forDevice:(AVCaptureDevice *)device {
    if ([device hasFlash] && [device isFlashModeSupported:flashMode]) {
        NSError *error = nil;
        if ([device lockForConfiguration:&error]) {
            [device setFlashMode:flashMode];
            [device unlockForConfiguration];
        } else {
            NSLog(@"%@", error);
        }
    }
}

+ (AVCaptureDevice *)deviceWithMediaType:(NSString *)mediaType preferringPosition:(AVCaptureDevicePosition)position {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:mediaType];
    AVCaptureDevice *captureDevice = [devices firstObject];
    
    for (AVCaptureDevice *device in devices) {
        
        if ([device position] == position) {
            captureDevice = device;
            break;
        }
    }
    
    return captureDevice;
}

#pragma mark -- User Interface
- (void)checkDeviceAuthorizationStatus {
    NSString *mediaType = AVMediaTypeVideo;
    
    [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
        if (granted) {
            
            //Granted access to mediaType
            [self setDeviceAuthorized:YES];
            
        } else {
            
            //Not granted access to mediaType
            dispatch_async(dispatch_get_main_queue(), ^{
                [[[UIAlertView alloc] initWithTitle:@"No Access"
                                            message:@"Moments doesn't have permission to use Camera, please change privacy settings"
                                           delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil] show];
                [self setDeviceAuthorized:NO];
            });
        }
    }];
}

@end
