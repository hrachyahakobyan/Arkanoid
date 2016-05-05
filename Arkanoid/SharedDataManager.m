//
//  sharedDataManager.m
//  Arkanoid
//
//  Created by Admin on 09.03.15.
//  Copyright (c) 2015 Hrach. All rights reserved.
//

#import "SharedDataManager.h"

static SharedDataManager* sharedManager = nil;

@implementation SharedDataManager

+(SharedDataManager*)sharedManager
{
    if(!sharedManager)
    {
        sharedManager = [[SharedDataManager alloc] init];
        
    }
    return sharedManager;
}

-(instancetype)init
{
    self = [super init];
    if(self)
    {
        // get the array of saved data
        NSMutableArray* gameData = [[FileManager sharedManager] savedData];

        if (  gameData.count > 0)
        {
            // get the dictionary
            NSDictionary* dict = gameData[0];
            // load saved data
            _levelNumber = [[dict objectForKey:@"levelNumber"] integerValue];
            _lifes = [[dict objectForKey:@"lifes"] integerValue];
            _score = [[dict objectForKey:@"score"] integerValue];
            _level = [[LevelObject alloc]initWithArray: [dict objectForKey:@"levelBricks"] rows:[[dict objectForKey:@"levelRows"] integerValue] columns:[[dict objectForKey:@"levelColumns"] integerValue]];

        }
        else
            [self reset];
    }
    
    return self;
}

-(void)reset
{

    _levelNumber = _score = _lifes = 0;
    _level = nil;
 
    [[FileManager sharedManager] emptyGameData];
    

}

-(void)save
{
    // if there is not anything to be saved
    if( !_level )
        return;
    
    NSMutableArray* gameData = [[NSMutableArray alloc]init];
    NSDictionary* dict = @{@"levelNumber" : [[NSNumber alloc]initWithInteger:_levelNumber],
                           @"levelBricks" : _level.arrayOfBricks,
                           @"levelRows" : [[NSNumber alloc]initWithInteger: _level.rows],
                           @"levelColumns" : [[NSNumber alloc]initWithInteger: _level.columns],
                           @"lifes" : [[NSNumber alloc]initWithInteger:_lifes],
                           @"score": [[NSNumber alloc]initWithInteger:_score]};
                           
    gameData[0] = dict;
    [[FileManager sharedManager] saveGameData:gameData];
}

-(BOOL)empty
{
  
    if( [[FileManager sharedManager] savedData].count > 0)
    {
 
        return NO;
    }

    return YES;
}
@end
