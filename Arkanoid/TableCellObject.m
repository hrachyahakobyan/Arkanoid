//
//  TableCellObject.m
//  Arkanoid
//
//  Created by Admin on 11.03.15.
//  Copyright (c) 2015 Hrach. All rights reserved.
//

#import "TableCellObject.h"

@implementation TableCellObject

-(instancetype)initWithName:(NSString *)name score:(NSInteger)score level:(NSInteger)level

{
    self = [super init];
    
    if(self)
    {
        _level = [NSString stringWithFormat:@"%li", (long)level];
        _score = [NSString stringWithFormat:@"%li", (long)score];
        _name = name;
    }
    return self;
}

@end
