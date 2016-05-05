//
//  platformObject.m
//  Arkanoid
//
//  Created by Admin on 25.02.15.
//  Copyright (c) 2015 Hrach. All rights reserved.
//

#import "PlatformObject.h"

@implementation PlatformObject

-(instancetype)initWithRect:(CGRect)rect
{
    self = [super init];
    if(self)
    {
        _rect = rect;
        _center.x = rect.origin.x + rect.size.width/2;
        _center.y = rect.origin.y + rect.size.height/2;
    }
    return self;
}

-(void)setNewCenter:(CGPoint)newCenter
{
    _center = newCenter;
    _rect = CGRectMake(newCenter.x - _rect.size.width/2, newCenter.y - _rect.size.height/2, _rect.size.width, _rect.size.height);
}

@end
