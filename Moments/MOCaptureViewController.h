//
//  CaptureViewController.h
//  moments-test
//
//  Created by Douglas Bumby on 2014-11-29.
//  Copyright (c) 2014 Cosmic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "AVCamPreviewView.h"
#import "EDRecordingFlashingView.h"

static void *RecordingContext = &RecordingContext;
static void *SessionRunningAndDeviceAuthorizedContext = &SessionRunningAndDeviceAuthorizedContext;

@interface MOCaptureViewController : UIViewController <AVCaptureFileOutputRecordingDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (strong, nonatomic) IBOutlet EDRecordingFlashingView *recordingFlashView;

// For use in the storyboards.
@property (nonatomic, weak) IBOutlet AVCamPreviewView *previewView;
@property (nonatomic, weak) IBOutlet UIButton *recordButton;
@property (nonatomic, weak) IBOutlet UIButton *cameraButton;
@property (nonatomic, weak) IBOutlet UIButton *flashButton;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutlet UIProgressView *progressView;

- (IBAction)toggleMovieRecording:(id)sender;
- (IBAction)changeCamera:(id)sender;
- (IBAction)focusAndExposeTap:(UIGestureRecognizer *)gestureRecognizer;

// Session management.
// Communicate with the session and other session objects on this queue.
@property (nonatomic) dispatch_queue_t sessionQueue;
@property (nonatomic) AVCaptureSession *session;
@property (nonatomic) AVCaptureDeviceInput *videoDeviceInput;
@property (nonatomic) AVCaptureMovieFileOutput *movieFileOutput;

// Utilities.
@property (nonatomic) UIBackgroundTaskIdentifier backgroundRecordingID;
@property (nonatomic, getter = isDeviceAuthorized) BOOL deviceAuthorized;
@property (nonatomic, readonly, getter = isSessionRunningAndDeviceAuthorized) BOOL sessionRunningAndDeviceAuthorized;
@property (nonatomic) BOOL lockInterfaceRotation;
@property (nonatomic) id runtimeErrorHandlingObserver;

@end
