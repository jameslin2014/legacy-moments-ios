//
// AVCamPreviewView.h
// Copyright (C) 2014 Apple Inc. All Rights Reserved.
//

#import <UIKit/UIKit.h>

@class AVCaptureSession;

@interface AVCamPreviewView : UIView

@property (nonatomic) AVCaptureSession *session;

@end
