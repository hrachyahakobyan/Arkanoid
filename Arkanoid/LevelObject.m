//
//  levelObject.m
//  Arkanoid
//
//  Created by Admin on 04.03.15.
//  Copyright (c) 2015 Hrach. All rights reserved.
//

#import "LevelObject.h"

@implementation LevelObject

-(instancetype)initWithArray:(NSMutableArray *)array rows:(NSInteger)rows columns:(NSInteger)cols
{
    self = [super init];
    
    if(self)
    {
        _arrayOfBricks = array;
        _rows = rows;
        _columns = cols;
    }
    return self;
}

@end
