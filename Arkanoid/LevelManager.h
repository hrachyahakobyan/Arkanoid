//
//  LevelManager.h
//  Arkanoid
//
//  Created by Admin on 07.03.15.
//  Copyright (c) 2015 Hrach. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LevelObject.h"
#import "FileManager.h"

// Gets level data from FileManager. Returns LevelObject*.
@interface LevelManager : NSObject

+(LevelManager*) sharedLevelManager;
-(LevelObject*) levelNumber:(NSInteger) number;

@end
