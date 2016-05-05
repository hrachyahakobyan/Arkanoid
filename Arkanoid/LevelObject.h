//
//  levelObject.h
//  Arkanoid
//
//  Created by Admin on 04.03.15.
//  Copyright (c) 2015 Hrach. All rights reserved.
//

#import <Foundation/Foundation.h>

/* the level object contains information about the current level
 it contains a 2D array of specified rows and columns. Each element of the array is a an integer which specifies the number of lifes of the brick, if it is 0, then there is no brick at that position */

@interface LevelObject : NSObject

@property NSMutableArray* arrayOfBricks;
@property NSInteger rows;
@property NSInteger columns;

-(instancetype)initWithArray:(NSMutableArray*) array rows:(NSInteger) rows columns:(NSInteger) cols;

@end
