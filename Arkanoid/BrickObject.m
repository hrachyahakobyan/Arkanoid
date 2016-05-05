//
//  brickObject.m
//  Arkanoid
//
//  Created by Admin on 25.02.15.
//  Copyright (c) 2015 Hrach. All rights reserved.
//

#import "BrickObject.h"
#import "Config.h"

@implementation BrickObject

-(instancetype)initWithRect:(CGRect)rect life:(NSInteger)life
                                                
{
    self = [super init];
    if(self)
    {
         _rect = rect;
        _life = life;
        _topLeftCorner = _rect.origin;
        _topRightCorner = CGPointMake(_topLeftCorner.x + _rect.size.width, _topLeftCorner.y);
        _bottomLeftCorner = CGPointMake(_topLeftCorner.x, _topLeftCorner.y + _rect.size.height);
        _bottomRightCorner = CGPointMake(_bottomLeftCorner.x + _rect.size.width, _bottomLeftCorner.y);
    }
    return self;
}

@end
