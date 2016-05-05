//
//  GameOverVC.h
//  Arkanoid
//
//  Created by Admin on 10.03.15.
//  Copyright (c) 2015 Hrach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HallOfFameManager.h"
#import "HallOfFameVC.h"

@interface GameOverVC : UIViewController <HallOfFameControllerDelegate, UITextFieldDelegate>

@property NSInteger levelNumber;
@property NSInteger score;
@end
