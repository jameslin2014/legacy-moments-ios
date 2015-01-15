//
//  CaptureViewController.m
//  moments-test
//
//  Created by Douglas Bumby on 2014-11-29.
//  Copyright (c) 2014 Cosmic. All rights reserved.
//

#import "MOCaptureViewController.h"
#import "MomentsAPIUtilities.h"

@implementation MOCaptureViewController{
	BOOL shouldCancel;
	NSTimer	*progressTimer;
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ([[MPMusicPlayerController systemMusicPlayer] playbackState] == MPMusicPlaybackStatePlaying) {
        [[MPMusicPlayerController systemMusicPlayer] pause];
        self.recordButton.enabled = YES;
        self.cameraButton.enabled = YES;
        self.flashButton.enabled = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
	shouldCancel = NO;
	
	self.progressView.hidden = YES;
    self.progressView.tintColor = [UIColor whiteColor];
    self.progressView.frame = CGRectMake(0, 557, self.view.frame.size.width, 10);
    self.progressView.trackTintColor = [UIColor clearColor];
    
	[self.recordButton setImage:[UIImage cameraButton] forState:UIControlStateNormal];
	
	[self.cancelButton setImage:[[UIImage circleCancelButton] imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
	self.cancelButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    // Create the AVCaptureSession
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    [self setSession:session];
    [[self previewView] setSession:session];
    [self checkDeviceAuthorizationStatus];
	
    dispatch_queue_t sessionQueue = dispatch_queue_create("session queue", DISPATCH_QUEUE_SERIAL);
    [self setSessionQueue:sessionQueue];
    
    dispatch_async(sessionQueue, ^{
        [self setBackgroundRecordingID:UIBackgroundTaskInvalid];
        
        NSError *error = nil;
    
		AVCaptureDevice *videoDevice = [MOCaptureViewController deviceWithMediaType:AVMediaTypeVideo preferringPosition:AVCaptureDevicePositionBack];
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

- (BOOL)prefersStatusBarHidden{
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
	return UIStatusBarStyleLightContent;
}

- (BOOL)isSessionRunningAndDeviceAuthorized {
    return [[self session] isRunning] && [self isDeviceAuthorized];
}

+ (NSSet *)keyPathsForValuesAffectingSessionRunningAndDeviceAuthorized {
    return [NSSet setWithObjects:@"session.running", @"deviceAuthorized", nil];
}

- (void)viewWillAppear:(BOOL)animated {
    dispatch_async([self sessionQueue], ^{
        [self addObserver:self forKeyPath:@"sessionRunningAndDeviceAuthorized" options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew) context:SessionRunningAndDeviceAuthorizedContext];
        [self addObserver:self forKeyPath:@"movieFileOutput.recording" options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew) context:RecordingContext];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subjectAreaDidChange:) name:AVCaptureDeviceSubjectAreaDidChangeNotification object:[[self videoDeviceInput] device]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(signOut:) name:@"signOut" object:nil];
        
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

- (void)viewWillDisappear:(BOOL)animated {
    dispatch_async([self sessionQueue], ^{
        [[self session] stopRunning];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVCaptureDeviceSubjectAreaDidChangeNotification object:[[self videoDeviceInput] device]];
        [[NSNotificationCenter defaultCenter] removeObserver:[self runtimeErrorHandlingObserver]];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"signOut" object:nil];
        
        [self removeObserver:self forKeyPath:@"sessionRunningAndDeviceAuthorized" context:SessionRunningAndDeviceAuthorizedContext];
        [self removeObserver:self forKeyPath:@"movieFileOutput.recording" context:RecordingContext];
    });
}

- (void)signOut:(id)sender {
    [self viewWillDisappear:NO];
}

- (BOOL)shouldAutorotate {
    return ![self lockInterfaceRotation];
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (IBAction)flashButtonAction:(UIButton *)sender {
    self.flash = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    if ([self.flash isTorchAvailable] && [self.flash isTorchModeSupported:AVCaptureTorchModeOn]) {
        BOOL success = [self.flash lockForConfiguration:nil];
        
        if (success) {
            if ([self.flash isTorchActive]) {
				self.cameraButton.enabled = true;
                [self.flash setTorchMode:AVCaptureTorchModeOff];
				sender.tintColor = [UIColor whiteColor];
				[sender setTitle:@"Off" forState:UIControlStateNormal];
				self.cameraButton.enabled = true;
            } else {
				self.cameraButton.enabled = false;
                [self.flash setTorchMode:AVCaptureTorchModeOn];
				sender.tintColor = [UIColor yellowColor];
				[sender setTitle:@"On" forState:UIControlStateNormal];
				self.cameraButton.enabled = NO;
				if ([[[self videoDeviceInput] device]position] == AVCaptureDevicePositionFront){
					[self changeCamera:self];
					self.cameraButton.enabled = false;
				}
            }
            [self.flash unlockForConfiguration];
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
    dispatch_async([self sessionQueue], ^{
        if (![[self movieFileOutput] isRecording]) {
			
			dispatch_async(dispatch_get_main_queue(), ^{
				[self.recordingFlashView show];
				self.progressView.hidden = NO;
				self.progressView.progress = 0;
				progressTimer = [NSTimer scheduledTimerWithTimeInterval:0.15 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
				self.cancelButton.hidden = NO;
				self.recordButton.imageView.animationImages = [UIImage transitionButtonImages:NO];
				self.recordButton.imageView.animationDuration = 0.25;
				self.recordButton.imageView.animationRepeatCount = 1;
				[self.recordButton setImage:[UIImage recordButton] forState:UIControlStateNormal];
				[self.recordButton.imageView startAnimating];
			});
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
			
			dispatch_async(dispatch_get_main_queue(), ^{
				self.cancelButton.hidden = YES;
				self.progressView.hidden = YES;
				[progressTimer invalidate];
				[self.recordingFlashView hide];
				self.recordButton.imageView.animationImages = [UIImage transitionButtonImages:YES];
				self.recordButton.imageView.animationDuration = 0.25;
				self.recordButton.imageView.animationRepeatCount = 1;
				[self.recordButton setImage:[UIImage cameraButton] forState:UIControlStateNormal];
				[self.recordButton.imageView startAnimating];
			});
            [[self movieFileOutput] stopRecording];
        }
    });
}

- (void)updateTimer{
	if(self.progressView.progress >= 1.0f)
	{
		//Invalidate timer when time reaches 0
		[progressTimer invalidate];
		[self toggleMovieRecording:self];
	}
	else
	{
		self.progressView.progress += 0.01;
	}
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
			if (videoDevice.flashActive == NO){
				self.flashButton.tintColor = [UIColor whiteColor];
				[self.flashButton setTitle:@"Off" forState:UIControlStateNormal];
			}
            [[self cameraButton] setEnabled:YES];
            [[self recordButton] setEnabled:YES];
        });
    });
}

- (IBAction)cancelRecording{
	shouldCancel = YES;
	[self toggleMovieRecording:nil];
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
- (void)postVideoWithURL: (NSURL *) videoURL{
	SCNView *v = [[SCNView alloc] initWithFrame:self.view.bounds];
	v.scene = [[EDSpinningBoxScene alloc] init];
	v.alpha = 0.0;
	v.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
	[self.view addSubview:v];
	[UIView animateWithDuration:0.2 delay:0.1 options:0 animations:^{
		v.alpha = 1.0;
	} completion:nil];
	[[UIApplication sharedApplication] beginIgnoringInteractionEvents];
	NSString *user = [NSString stringWithFormat:@"%@.mp4", [MomentsAPIUtilities sharedInstance].user.name];
	AVAsset *firstVid = [AVAsset assetWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://s3.amazonaws.com/pickmoments/videos/%@",user]]];
	AVAsset *secondVid = [AVAsset assetWithURL:videoURL];
	NSArray *assets = @[firstVid, secondVid];
	AVMutableComposition *mutableComposition = [AVMutableComposition composition];
	AVMutableCompositionTrack *videoCompositionTrack = [mutableComposition addMutableTrackWithMediaType:AVMediaTypeVideo
																					   preferredTrackID:kCMPersistentTrackID_Invalid];
	AVMutableCompositionTrack *audioCompositionTrack = [mutableComposition addMutableTrackWithMediaType:AVMediaTypeAudio
																					   preferredTrackID:kCMPersistentTrackID_Invalid];
	
	NSMutableArray *instructions = [NSMutableArray new];
	CGSize size = CGSizeMake([assets[1] naturalSize].height, [assets[1] naturalSize].width);
	
	
	CMTime time = kCMTimeZero;
	for (AVAsset *asset in assets) {
		AVAssetTrack *assetTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] firstObject];
		AVAssetTrack *audioAssetTrack = [[asset tracksWithMediaType:AVMediaTypeAudio] firstObject];
		
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
	
	//    AVPlayer *player = [AVPlayer playerWithPlayerItem:pi];
	AVAssetExportSession *exportSession =  [AVAssetExportSession exportSessionWithAsset:pi.asset presetName:AVAssetExportPresetMediumQuality];
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *path = [documentPaths[0] stringByAppendingPathComponent:@"merged2.mp4"];
	NSURL *movieURL = [NSURL fileURLWithPath:path];
	exportSession.outputURL = movieURL;
	exportSession.outputFileType = AVFileTypeMPEG4;
	[exportSession exportAsynchronouslyWithCompletionHandler:^{
		NSLog(@"done");
		NSLog(@"%@",exportSession.outputURL);
		
		[self setLockInterfaceRotation:NO];
		
		//        UIBackgroundTaskIdentifier backgroundRecordingID = [self backgroundRecordingID];
		[self setBackgroundRecordingID:UIBackgroundTaskInvalid];
		
        MOS3APIUtilities *s3ApiUtilities = [MOS3APIUtilities sharedInstance];
        [s3ApiUtilities initManager];
        AFAmazonS3Manager *s3Manager = s3ApiUtilities.s3;
        
        MomentsAPIUtilities *apiUtilities = [MomentsAPIUtilities sharedInstance];
		
		NSString *user = [NSString stringWithFormat:@"/videos/%@.mp4", apiUtilities.user.name];
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
            [apiUtilities recordPostForUser:apiUtilities.user.name];
            [UIView animateWithDuration:0.2 animations:^{
                v.alpha = 0.0;
            } completion:^(BOOL finished) {
                [v removeFromSuperview];
            }];
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            [self.navigationController.view setUserInteractionEnabled:true];
            NSLog(@"success");
		} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
			NSLog(@"Error uploading %@", error);
		}];
		[s3Manager.operationQueue addOperation:operation];
	}];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
	
	NSURL *videoURL = info[UIImagePickerControllerMediaURL];
	
	NSData *videoData = [NSData dataWithContentsOfURL:videoURL];
	NSArray *documentsPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *tempPath = [documentsPaths[0] stringByAppendingPathComponent:@"merged2.mp4"];
	
	if ([videoData writeToFile:tempPath atomically:YES]){
		[self postVideoWithURL:[NSURL fileURLWithPath:tempPath]];
	}
	
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error {
	if (shouldCancel){
		shouldCancel = NO;
		return;
	}
    if (error) {
        NSLog(@"%@", error);
    }

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *documentsPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [documentsPaths[0] stringByAppendingPathComponent:@"merged2.mp4"];
    [fileManager removeItemAtPath:filePath error:&error];
	
	[self postVideoWithURL:outputFileURL];
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
