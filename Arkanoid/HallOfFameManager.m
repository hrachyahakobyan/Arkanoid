//
//  HallOfFameManager.m
//  Arkanoid
//
//  Created by Admin on 11.03.15.
//  Copyright (c) 2015 Hrach. All rights reserved.
//

#import "HallOfFameManager.h"

static HallOfFameManager* sharedManager = nil;

@implementation HallOfFameManager

+(HallOfFameManager*)sharedManager
{
    if(!sharedManager)
    {
        sharedManager = [[HallOfFameManager alloc]init];
    }
    return sharedManager;
}

-(instancetype)init
{
    self = [super init];
    if(self)
    {
        _datasource = [[FileManager sharedManager] hallOfFame];
    }
    return  self;
}

-(void)newElementUsername:(NSString *)name score:(NSNumber*)score level:(NSNumber*)level
{
    //create a new element of the hall of fame
    NSDictionary* newElement = @{keyUsername : name,
                                 keyScore : score,
                                 keyLevel : level};
    
    // if the hall of fame is initially empty, insert the new element
    if( _datasource.count == 0)
    {
        [_datasource addObject:newElement];
    }
    
    //otherwise, find the place for the new element, the elements are ordered by their score in an ascending order
    else
    {
        NSInteger newScore = [score integerValue];
        BOOL newElementInserted = NO;
        for ( int i = 0; i < _datasource.count; i++)
        {
            NSDictionary* currentElement = _datasource[i];
            NSNumber* currentNumber = currentElement[keyScore];
            NSInteger currentScore = [currentNumber integerValue];
            
            //if the score of the new element is bigger than the current one, isnert the element in its place and shift the array to the right ( done automatically)
            if ( newScore >= currentScore)
                
            {
                [_datasource insertObject:newElement atIndex:i];
                
                //if after the shift the array is larger than the defined size, remove the last element
                if( _datasource.count > HALLOFFAME_LENGTH)
                        [_datasource removeLastObject];
                newElementInserted = YES;
                break;
                
            }
        }
        
        if ( _datasource.count < HALLOFFAME_LENGTH && !newElementInserted )
            [_datasource addObject:newElement];
    }
    
    // save the new hall of fame to the file
    [[FileManager sharedManager] saveHallOfFame:_datasource];
}

-(void)emptyHallOfFame
{
    [_datasource removeAllObjects];
    [[FileManager sharedManager] emptyHallOfFame];
}
@end
