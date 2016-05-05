//
//  FileManager.h
//  Arkanoid
//
//  Created by Admin on 06.03.15.
//  Copyright (c) 2015 Hrach. All rights reserved.
//

#import <Foundation/Foundation.h>
// Manages data input and output from plist and files
static NSString *saveGameData = @"savedData";
static NSString *hallOfFame = @"hallOfFame";
static NSString *levels = @"levels";

@interface FileManager : NSObject

+(FileManager*)sharedManager;
// gets the string representation of the level
-(NSString*)loadlevelStringNumber:(NSInteger) number;
// gets the saved data of the game
-(NSMutableArray*)savedData;
// updates the saved data
-(void)saveGameData:(NSMutableArray*) gameData;
// deletes the saved game data
-(void)emptyGameData;
// gets the array of hall of fame
-(NSMutableArray*)hallOfFame;
// updates the array of hall of famme
-(void)saveHallOfFame:(NSMutableArray*) hallOfFame;
// deletes the contents of hall of fame
-(void)emptyHallOfFame;
@end
