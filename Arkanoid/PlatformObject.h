//
//  platformObject.h
//  Arkanoid
//
//  Created by Admin on 25.02.15.
//  Copyright (c) 2015 Hrach. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PlatformObject : NSObject

@property CGRect rect;
@property CGPoint center;

-(instancetype)initWithRect:(CGRect) rect;
// moves the platform to a new center
-(void)setNewCenter:(CGPoint) newCenter;

@end
