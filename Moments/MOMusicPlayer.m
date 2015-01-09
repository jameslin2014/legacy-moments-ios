//
//  MOMusicPlayer.m
//  Onboarding
//
//  Created by Damon Jones on 12/28/14.
//  Copyright (c) 2014 Xappox, LLC. All rights reserved.
//

#import "MOMusicPlayer.h"

@interface MOMusicPlayer()

@property (nonatomic, strong) AVAudioEngine *engine;

@property (nonatomic, strong) AVAudioPlayerNode *player1;
@property (nonatomic, strong) AVAudioPlayerNode *player2;
@property (nonatomic, strong) AVAudioPlayerNode *player3;

@end

@implementation MOMusicPlayer

static const float kPlayer1Volume = 0.66;
static const float kPlayer2Volume = 1.00;
static const float kPlayer3Volume = 1.00;
static const float kSampleRate = 44100.00;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.engine = [[AVAudioEngine alloc] init];
        
        // Can be used to make any timing adjustments between tracks
        AVAudioTime *time1 = [AVAudioTime timeWithSampleTime:0.10 * kSampleRate atRate:kSampleRate];
        AVAudioTime *time2 = [AVAudioTime timeWithSampleTime:0.10 * kSampleRate atRate:kSampleRate];
        AVAudioTime *time3 = [AVAudioTime timeWithSampleTime:0.05 * kSampleRate atRate:kSampleRate];
        
        self.player1 = [self createPlayerWithFilename:@"Funk 2 - 100 - P1"
                                            extension:@"wav"
                                               engine:self.engine
                                                 time:time1];
        self.player2 = [self createPlayerWithFilename:@"Funk 2 - 100 - P2"
                                            extension:@"wav"
                                               engine:self.engine
                                                 time:time2];
        self.player3 = [self createPlayerWithFilename:@"Funk 2 - 100 - P3"
                                            extension:@"wav"
                                               engine:self.engine
                                                 time:time3];
    }
    
    return self;
}

- (void)start {
    self.player1.volume = 1.00 * kPlayer1Volume; // full
    self.player2.volume = 0.00; // off
    self.player3.volume = 0.00; // off
    
    NSError *error = nil;
    [self.engine startAndReturnError:&error];
    
    [self.player1 play];
    [self.player2 play];
    [self.player3 play];
}

- (void)stop {
    // TODO: Fade out audio with a timer?
    [self.player1 stop];
    [self.player2 stop];
    [self.player3 stop];
    
    [self.engine stop];
}

- (AVAudioPlayerNode *)createPlayerWithFilename:(NSString *)filename extension:(NSString *)extension engine:(AVAudioEngine *)engine time:(AVAudioTime *)time {
    NSError *error = nil;
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:filename withExtension:extension];
    AVAudioFile *file = [[AVAudioFile alloc] initForReading:url error:&error];
    AVAudioFrameCount fileLength = (AVAudioFrameCount) file.length;
    AVAudioPCMBuffer *buffer = [[AVAudioPCMBuffer alloc] initWithPCMFormat:file.processingFormat frameCapacity:fileLength];
    AVAudioPlayerNode *player = [[AVAudioPlayerNode alloc] init];
    
    [engine attachNode:player];
    [engine connect:player to:[engine mainMixerNode] format:file.processingFormat];
    [file readIntoBuffer:buffer error:&error];
    [player scheduleBuffer:buffer atTime:time options:AVAudioPlayerNodeBufferLoops completionHandler:nil];
    
    return player;
}

- (void)setPage:(int)page fade:(float)fade {
    switch (page) {
        case 0:
            self.player1.volume = kPlayer1Volume; // full
            self.player2.volume = fade * kPlayer2Volume; // fade
            self.player3.volume = 0.00; // off
            break;
        case 1:
            self.player1.volume = kPlayer1Volume; // full
            self.player2.volume = kPlayer2Volume; // full
            self.player3.volume = fade * kPlayer3Volume; // fade
            break;
        case 2:
            self.player1.volume = (1.00 - fade) * kPlayer1Volume; // inverse fade
            self.player2.volume = 0.80 + (1.00 - fade) * 0.20 * kPlayer2Volume; // Inverse fade to 80%
            self.player3.volume = 0.25 + (1.00 - fade) * 0.75 * kPlayer3Volume; // Inverse fade to 25%
            break;
        case 3:
            self.player1.volume = 0.00; // off
            self.player2.volume = 0.80 * kPlayer2Volume; // 80%
            self.player3.volume = 0.25; // 25%
            break;
        default:
            break;
    }
}

@end
