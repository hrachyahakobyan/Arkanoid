//
//  SoundManager.m
//  Arkanoid
//
//  Created by Admin on 12.03.15.
//  Copyright (c) 2015 Hrach. All rights reserved.
//

#import "SoundManager.h"
#import  <AVFoundation/AVFoundation.h>

static SoundManager* sharedManager = nil;

@interface SoundManager()

@property (assign) SystemSoundID boardCollisionSound;
@property (assign) SystemSoundID platformCollisionSound;
@property (assign) SystemSoundID brickCollisionSound;
@property (assign) SystemSoundID ballShootSound;
@property (assign) SystemSoundID ballDidFallSound;

@end

@implementation SoundManager


+(SoundManager*)sharedManager
{
    if(!sharedManager)
    {
        sharedManager = [[SoundManager alloc]init];
    }
    return sharedManager;
}

-(instancetype)init
{
    self = [super init];
    if(self)
    {
        [self configureSounds];
        
    }
    return self;
}

// creates the sounds.
-(void)configureSounds
{
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"HIT_BORDERS" ofType:@"WAV"];
    NSURL *soundURL = [NSURL fileURLWithPath:soundPath];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundURL, &_boardCollisionSound);
    

    soundPath = [[NSBundle mainBundle] pathForResource:@"HIT_BRICKS" ofType:@"WAV"];
    soundURL = [NSURL fileURLWithPath:soundPath];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundURL, &_brickCollisionSound);

    soundPath = [[NSBundle mainBundle] pathForResource:@"HIT_PLATFORM" ofType:@"WAV"];
    soundURL = [NSURL fileURLWithPath:soundPath];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundURL, &_platformCollisionSound);

    soundPath = [[NSBundle mainBundle] pathForResource:@"BALL_SHOOT" ofType:@"WAV"];
    soundURL = [NSURL fileURLWithPath:soundPath];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundURL, &_ballShootSound);

    soundPath = [[NSBundle mainBundle] pathForResource:@"BALL_FELL" ofType:@"WAV"];
    soundURL = [NSURL fileURLWithPath:soundPath];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundURL, &_ballDidFallSound);

}

-(void)playSound:(Collision)item
{
    switch (item) {
        case Border:
                AudioServicesPlaySystemSound(self.boardCollisionSound);

            break;
        
        case BrickTouch:
                AudioServicesPlaySystemSound(self.brickCollisionSound);

            break;
        
        case Platform:
                AudioServicesPlaySystemSound(self.platformCollisionSound);

            break;
        
        case BallDidShoot:
                AudioServicesPlaySystemSound(self.ballShootSound);

            break;
        
        case BallDidFall:
                    AudioServicesPlaySystemSound(self.ballDidFallSound);

            break;
            
        default:
            break;
    }
}


@end
