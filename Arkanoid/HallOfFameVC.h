//
//  HallOfFameVC.h
//  Arkanoid
//
//  Created by Admin on 10.03.15.
//  Copyright (c) 2015 Hrach. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HallOfFameVC;

@protocol  HallOfFameControllerDelegate <NSObject>

- (void)hallOfFameDidCancel:(HallOfFameVC*)vc;

@end

@interface HallOfFameVC : UIViewController

// delegate to the ViewController it has been modally displayed by
@property (weak) id <HallOfFameControllerDelegate> delegate;

@end

