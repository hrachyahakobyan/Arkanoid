//
//  sharedDataManager.h
//  Arkanoid
//
//  Created by Admin on 09.03.15.
//  Copyright (c) 2015 Hrach. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileManager.h"
#import "levelObject.h"
#import "Config.h"

// Manages the saving and loading game data when the game is paused/terminated.
@interface SharedDataManager : NSObject

+(SharedDataManager*) sharedManager;

// deletes the saved game data
-(void)reset;
// saves game data
-(void)save;
// returns true if there is any data saved
-(BOOL)empty;

@property NSInteger levelNumber;
@property NSInteger lifes;
@property NSInteger score;
@property LevelObject* level;


@end
