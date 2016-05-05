//
//  ballObject.m
//  Arkanoid
//
//  Created by Admin on 25.02.15.
//  Copyright (c) 2015 Hrach. All rights reserved.
//

#import "BallObject.h"

@implementation BallObject


-(instancetype)initWithRect:(CGRect)rect xvelocity:(CGFloat)x yvelocity:(CGFloat)y
{
    self = [super init];
    if(self)
    {
        _rect = rect;
        _radius = rect.size.height / 2;
        _center.x = rect.origin.x + _radius;
        _center.y = rect.origin.y + _radius;
        _xvelocity = x;
        _yvelocity = y;
        
    }
    return self;
}

-(void)setNewCenter:(CGPoint) newCenter
{
    _center = newCenter;
    _rect = CGRectMake(_center.x - _radius, _center.y - _radius, 2*_radius, 2*_radius);
}

-(void)move
{
    _center.x += _xvelocity;
    _center.y += _yvelocity;
    _rect = CGRectMake(_center.x - _radius, _center.y - _radius, 2*_radius, 2*_radius);
}

@end
