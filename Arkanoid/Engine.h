//
//  Engine.h
//  Arkanoid
//
//  Created by Admin on 25.02.15.
//  Copyright (c) 2015 Hrach. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BallObject.h"
#import "PlatformObject.h"
#import "BrickObject.h"
#import "LevelObject.h"
#import "LevelManager.h"
#import "SharedDataManager.h"

@protocol EngineDelegate <NSObject>
//requests the current position of the platform object from the ViewController at the moment of detection of collision with the platform
-(CGPoint)platformPosition;
// moves the ball view to the new center
-(void)moveBallToCenter:(CGPoint) aNewCenter;
// changes the color of the bricks that collided with the ball
-(void)redrawCollidedBricks:(NSMutableArray*) collidedBricks;
// updates the score by the number of bricks that have been destroyed
-(void)updateScoreBy:(NSInteger) destroyedBricksNumber;
// informs the ViewControll that the ball has dropped below the platform
-(void)gameOver;
// informs the ViewController that there are no more bricks left
-(void)newLevel;
// informs the ViewController about a collision and it's type
-(void)ballDidCollideWith:(Collision) item;
@end

@interface Engine : NSObject

+(Engine*)sharedEngine;
// starts the engine
-(void)start;
// pauses the engine
-(void)pause;
// resets the Engine. If savedData = YES, then the engine uses the previously saved data, otherwise, it resets
// the parameters and constructs a new level number "levelNumber"
-(void)resetWithSavedData:(BOOL) savedData toLevel:(NSInteger) levelNumber;
// returns the sizes of the board
-(CGPoint)boardSizes;
// returns the rectangle of the ball to construct the view based on it
-(CGRect)ballObjectFrame;
// returns the rectangle of the platform to construct the view based on it
-(CGRect)platformObjectFrame;
// returns an array of brick rectangles to construct the views
-(NSArray*)brickObjectsFrames;
// updates the game state
// gets the coordinates of user tap to calculate the initial ball direction
-(void)calculateBallInitialDirection:(CGPoint) tappedPoint;

@property NSTimer* myTimer;
@property BallObject* ball;
@property PlatformObject* platform;
// the board the Engine will work on
@property CGRect board;
// a level object that the engine get's from LevelManager. It contains information about the bricks
@property LevelObject* level;
// array of brick objects
@property NSMutableArray* bricks;
// delegate for the ViewController. It acts also as a datasource to get the position of the platform.
@property (weak) id <EngineDelegate> delegate;

@end
