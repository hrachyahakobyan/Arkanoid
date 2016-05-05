//
//  ViewController.h
//  Arkanoid
//
//  Created by Admin on 24.02.15.
//  Copyright (c) 2015 Hrach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Engine.h"
#import "BoardView.h"
#import "PopupView.h"
#import "Config.h"
#import "SharedDataManager.h"

#import "GameOverVC.h"
#import "SoundManager.h"

@interface ViewController : UIViewController <EngineDelegate, PopupDelegate>

-(void)gameEnteredBackground;
-(void)gameEnteredForeground;

@end

