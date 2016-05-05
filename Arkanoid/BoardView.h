//
//  boardView.h
//  Arkanoid
//
//  Created by Admin on 25.02.15.
//  Copyright (c) 2015 Hrach. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BoardView : UIView

-(instancetype)initWithFrame:(CGRect) frame platform:(CGRect) platform ball:(CGRect) ball bricks:(NSArray*) bricks;
// returns the current position of the platform
-(CGPoint)platformPosition;
// moves the ball's center to newCenter
-(void)moveBallToCenter:(CGPoint) aNewCenter;
// moves platform in accordance to the slider value
-(void)movePlatformBy:(CGFloat) sliderValue;
// changes the colors of the bricks
-(void)redrawBricks:(NSMutableArray*) collidedBricks;
// sets the platform and ball to initial positions
-(void)moveBallAndPlatformInitialPosition;
// removes the old brickviews and constructs new ones
-(void)updateBrickViews:(NSArray*) newBricks;
-(void)animateShooting;

@end
