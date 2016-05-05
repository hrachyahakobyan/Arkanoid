//
//  FileManager.m
//  Arkanoid
//
//  Created by Admin on 06.03.15.
//  Copyright (c) 2015 Hrach. All rights reserved.
//

#import "FileManager.h"

static FileManager* sharedManager = nil;

@implementation FileManager

+(FileManager*)sharedManager
{
    if(!sharedManager)
    {
        sharedManager = [[FileManager alloc]init];
        
        
    }
    return sharedManager;
}

-(instancetype)init
{
    self = [super init];
    if(self)
    {
        
        /* get the dictionary of saved game data. The dictionary contains two sections - HallOfFame and savedData */
        
        NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithContentsOfFile:[sharedManager filePath]];
        
        if(!dict)
        {
            // If there was no dictionary saved, create one
            dict = [[NSMutableDictionary alloc]init];
            [dict setObject:[[NSMutableArray alloc]init] forKey:saveGameData];
            [dict setObject:[[NSMutableArray alloc]init] forKey:hallOfFame];
            [dict writeToFile:[sharedManager filePath] atomically:YES];
        }
    }
    return self;
}

-(NSString*)loadlevelStringNumber:(NSInteger)number
{
    // get the dictionary of my plist
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"myplist" ofType:@"plist"]];
     // get the array of level strings
    NSArray* arrayoflevels = [dict objectForKey:levels];
    
    // get the level string number levelNumber
    
    NSString* levelString = [arrayoflevels objectAtIndex:number];

    return levelString;
    
}

// returns the dictionary with saved game data
-(NSMutableArray*)savedData
{
    
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithContentsOfFile:[self filePath]];
 
    return [dict objectForKey:saveGameData];
}

// saves new game data
-(void)saveGameData:(NSMutableArray *)gameData
{

    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithContentsOfFile:[self filePath]];
 
    [dict removeObjectForKey:saveGameData];
    [dict setObject:gameData forKey:saveGameData];

    [dict writeToFile:[self filePath] atomically:YES];

}

// deletes saved game data
-(void)emptyGameData
{
 
     NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithContentsOfFile:[self filePath]];
    
    [dict[saveGameData] removeAllObjects];


    [dict writeToFile:[self filePath] atomically:YES];
    
}

// returns the array of dictionaries for hall of fame
-(NSMutableArray*)hallOfFame
{
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithContentsOfFile:[self filePath]];
    

    return dict[hallOfFame];
    
    
}
// saves hall of fame information
-(void)saveHallOfFame:(NSMutableArray*)hallOfFameArray
{

    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithContentsOfFile:[self filePath]];

    [dict removeObjectForKey:hallOfFame];
    [dict setObject:hallOfFameArray forKey:hallOfFame];

    [dict writeToFile:[self filePath] atomically:YES];
  

}
// deletes hall of fame inforamtion
-(void)emptyHallOfFame
{
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithContentsOfFile:[self filePath]];
    
        [dict[hallOfFame] removeAllObjects];
    
    
        [dict writeToFile:[self filePath] atomically:YES];
}

// returns the path to the file
-(NSString*)filePath
{
  
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory =  [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"myfile"];

    return filePath;
    
}

@end
