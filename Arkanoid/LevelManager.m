//
//  LevelManager.m
//  Arkanoid
//
//  Created by Admin on 07.03.15.
//  Copyright (c) 2015 Hrach. All rights reserved.
//

#import "LevelManager.h"
#import "FileManager.h"

static LevelManager* sharedLevelManager = nil;

@implementation LevelManager

+(LevelManager*)sharedLevelManager
{
    if(!sharedLevelManager)
    {
        sharedLevelManager = [[LevelManager alloc] init];
    }
    
    return sharedLevelManager;
}

-(LevelObject*)levelNumber:(NSInteger)number
{
    // get the levelString from the filemanager
    NSString* levelString =  [[FileManager sharedManager] loadlevelStringNumber:number-1];
    // separate the string by space
    NSMutableArray* levelArray = [[NSMutableArray alloc] initWithArray:[levelString componentsSeparatedByString:@" "]];
    
    // get the row and col, the first two elements of the string
    NSInteger rows = [levelArray[0] intValue];
    NSInteger cols = [levelArray[1] intValue];
    
    
    [levelArray removeObjectAtIndex:0];
    [levelArray removeObjectAtIndex:0];

    // convert the rest elements of the string to NSNumber
    for ( int i = 0; i < levelArray.count; i++)
    {
        levelArray[i] =[[NSNumber alloc] initWithInt:[((NSString*)levelArray[i]) intValue]];
    }
    
    // construct the level
    
    LevelObject* level = [[LevelObject alloc]initWithArray:levelArray rows:rows columns:cols];
    
    return level;
}
@end
