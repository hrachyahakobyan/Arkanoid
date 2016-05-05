//
//  brickObject.h
//  Arkanoid
//
//  Created by Admin on 25.02.15.
//  Copyright (c) 2015 Hrach. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BrickObject : NSObject

@property CGRect rect;
@property NSInteger life;
@property CGPoint topLeftCorner;
@property CGPoint topRightCorner;
@property CGPoint bottomLeftCorner;
@property CGPoint bottomRightCorner;

-(instancetype)initWithRect:(CGRect) rect life:(NSInteger) life;

@end
