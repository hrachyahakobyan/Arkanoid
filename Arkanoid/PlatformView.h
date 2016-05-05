//
//  PlatformView.h
//  Arkanoid
//
//  Created by Admin on 11.03.15.
//  Copyright (c) 2015 Hrach. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlatformView : UIView

// returns the center of the view
-(CGPoint)position;
// redraws the view by moving to a new center
-(void)moveToCenter:(CGPoint) aNewCenter;

@end
