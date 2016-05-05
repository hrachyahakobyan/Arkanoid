//
//  ballObject.h
//  Arkanoid
//
//  Created by Admin on 25.02.15.
//  Copyright (c) 2015 Hrach. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface BallObject : NSObject

@property CGRect rect;
@property CGPoint center;
@property CGFloat radius;
@property CGFloat xvelocity;
@property CGFloat yvelocity;


-(instancetype)initWithRect:(CGRect) rect xvelocity:(CGFloat) x yvelocity:(CGFloat) y;

// moves the ball to the new center
-(void)setNewCenter:(CGPoint) newCenter;
// moves the ball by xvelocity along x-axis and yvelocity by y-axis
-(void)move;

@end
