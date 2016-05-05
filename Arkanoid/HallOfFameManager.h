//
//  HallOfFameManager.h
//  Arkanoid
//
//  Created by Admin on 11.03.15.
//  Copyright (c) 2015 Hrach. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileManager.h"
#import "Config.h"
// manages the Hall Of fame data input and ouput
static NSString *keyUsername = @"username";
static NSString *keyScore = @"score";
static NSString *keyLevel = @"level";

@interface HallOfFameManager : NSObject

+(HallOfFameManager*) sharedManager;
// gets new player information from GameOverVC
-(void)newElementUsername:(NSString*) name score:(NSNumber*) score level:(NSNumber*) level;
// empties Hall of Fame data
-(void)emptyHallOfFame;

@property NSMutableArray* datasource;

@end
