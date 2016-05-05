//
//  Engine.m
//  Arkanoid
//
//  Created by Admin on 25.02.15.
//  Copyright (c) 2015 Hrach. All rights reserved.
//

#import "Engine.h"
#import "Config.h"


static Engine* sharedEngine = nil;

@implementation Engine

{
    // keeps the previous (center) position of the ball
    CGPoint prevBallPosition;
    // the corners of the border. Used in collision detection
    CGPoint boardTopLeftCorner;
    CGPoint boardTopRightCorner;
    CGPoint boardBottomLeftCorner;
    CGPoint boardBottomRightCorner;
    // the positions of the ball and the platform when the game starts
    CGPoint platformInitialCenter;
    CGPoint ballInitialCenter;
    /* the end-of-game line. If the ball's y-coordinate is greater than this, than the ball is out of game */
    CGFloat gameOverLine;
    /* the height of the lowest existing brick, used in detecting the collision of the ball with the bricks */
    CGFloat lowestBrickHeight;
    // array of NSValue object that contain a CGPoint. The first member of the CGPoint is the index of the collided brick, the other one is the life of the brick after collision
    NSMutableArray* collidedBrickIndeces;
    // the number of bricks that were destroyed
    NSInteger destroyedBricksNumber;
    // the number of bricks remaining
    NSInteger bricksLeftNumber;
    // indicates what type of collision occured
    Collision collisionObject;
}

+(Engine*)sharedEngine
{
    if(!sharedEngine)
        
    {
        sharedEngine = [[Engine alloc] init];
        
    }
    return sharedEngine;
}

-(instancetype)init
{
    self = [super init];
    if(self)
    {
        CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
        
        
        // constructs the board Rectangle based on the application frame sizes and defined ratios
        _board = CGRectMake(0, 0, screenRect.size.width*BOARD_WIDTH_TO_SCREEN_RATIO, screenRect.size.height*BOARD_HEIGHT_TO_SCREEN_RATIO);
        
        CGFloat platformWidth = _board.size.width * PLATFORM_WIDTH_TO_BOARD_RATIO;
        CGFloat platformHeight = _board.size.height * PLATFORM_HEIGHT_TO_WIDTH_RATIO;
        CGFloat platformOriginx = _board.size.width/2 - platformWidth/2;
        CGFloat platformOriginy = _board.size.height*(1.0 - GAMEOVERLINE_TO_BOARD_HEIGHT_RATIO) - platformHeight;

        boardBottomLeftCorner = CGPointMake(0, _board.size.height);
        boardBottomRightCorner = CGPointMake(_board.size.width, _board.size.height);
        boardTopLeftCorner = CGPointMake(0, 0);
        boardTopRightCorner = CGPointMake(_board.size.width,0);
        
        gameOverLine = _board.size.height * ( 1 - GAMEOVERLINE_TO_BOARD_HEIGHT_RATIO);
        
       
        
        CGRect platformRect = CGRectMake(platformOriginx, platformOriginy, platformWidth, platformHeight);
        _platform = [[PlatformObject alloc] initWithRect:platformRect];
        
        CGFloat ballSize = platformWidth * BALL_SIZE_TO_PLATFORM_RATIO;

        CGFloat ballOriginx = platformOriginx + platformWidth/2 - ballSize/2;
        
        CGFloat ballOriginy = platformOriginy - ballSize;
        CGRect ballRect = CGRectMake(ballOriginx, ballOriginy, ballSize, ballSize);       
        
        _ball = [[BallObject alloc] initWithRect:ballRect xvelocity:0 yvelocity:0];
       
        platformInitialCenter = _platform.center;
        ballInitialCenter = _ball.center;
        

        collidedBrickIndeces = [[NSMutableArray alloc] init];
    }
    return self;
}



-(void)update
{
  
    // the movement and collision detection is done on a separate thread
    
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // keep the previous center
        
        prevBallPosition = _ball.center;
        // empty the collided bricks array
        [collidedBrickIndeces removeAllObjects];
        // set the number of destroyed bricks to 0
        destroyedBricksNumber = 0;
        collisionObject = -1;
        // move by the current velocity
        [_ball move];
        
        // check for collision with the platform and adjust the ball speed and movement direction
        [self checkForCollisionWithPLatform];
        
        // check for collision with the borders and adjust the ball's direction
        [self checkForCollisionWithBorders];
        
        // check for collision with bricks
        [self checkForCollisionWithBricks];
        
        
        [self saveData];
        
        // the actions that need to be executed on the main thread
        dispatch_async( dispatch_get_main_queue(), ^{
            // draw visual
            [self render];
            // check for game over state
            [self checkForGameOver];
            
            // check for a new level condition
            [self checkForNewLevel];
            // save the ball's and platform's position and ball's speed to sharedDataManager
        });
    });
    

}


-(void)render
{
    
    // redraws the ball
    if([_delegate respondsToSelector:@selector(moveBallToCenter:)])
        [_delegate moveBallToCenter:_ball.center];
    
    // redraws the collided bricks and updates the score
    if( collidedBrickIndeces.count > 0)
    {
        if([_delegate respondsToSelector:@selector(redrawCollidedBricks:)] )
        [_delegate redrawCollidedBricks:collidedBrickIndeces];
    
        if([_delegate respondsToSelector:@selector(updateScoreBy:)])
        [_delegate updateScoreBy:destroyedBricksNumber];
    }
    // informs about the type of collision to implement any animations/sounds
    if([_delegate respondsToSelector:@selector(ballDidCollideWith:)])
        [_delegate ballDidCollideWith:collisionObject];
    
    
    
}

/* checks if the ball is below the gameOverLine
 If it is, sets the platform and ball to their initial positions and informs the view controller
about the game over state */
-(void)checkForGameOver
{
    if ( _ball.center.y + _ball.radius >= gameOverLine)
    {
       if( [_delegate respondsToSelector:@selector(gameOver)])
           [_delegate gameOver];
        [_ball setNewCenter:ballInitialCenter];
        [_platform setNewCenter:platformInitialCenter];
    }
}

/* checks if there are still bricks left. If no, sets the platform and ball to their initial positions and informs the view controller about the new level state */
-(void)checkForNewLevel
{
    if( bricksLeftNumber == 0)
    {
        if ( [_delegate respondsToSelector:@selector(newLevel)])
            [_delegate newLevel];
        [_ball setNewCenter:ballInitialCenter];
        [_platform setNewCenter:platformInitialCenter];
    }
}
#pragma mark - Collision checking

-(void)checkForCollisionWithPLatform
{
    // check if the ball is below the platform, do the rest of the algorithm, to avoid redundant calculations
    if( _ball.center.y + _ball.radius >=  _platform.rect.origin.y)
    {
        // get the current position of the platform
        
        if([_delegate respondsToSelector:@selector(platformPosition)])
        {
            [_platform setNewCenter:[_delegate platformPosition]];
        }
        
        // the bottom part of the ball where the ball first can intersect with the platform
        CGPoint endpoint = CGPointMake(_ball.center.x, _ball.center.y + _ball.radius);
        CGPoint startpoint = CGPointMake(prevBallPosition.x, prevBallPosition.y + _ball.radius);
        CGPoint platformRightCorner = CGPointMake(_platform.rect.origin.x + _platform.rect.size.width, _platform.rect.origin.y);
        

        NSValue* intersectValue = [self intersectionOfLineFrom:startpoint to:endpoint withLineFrom:_platform.rect.origin to:platformRightCorner];
       
        // check if the ball intersected
        if (intersectValue  )
        {
            CGPoint intersect = [intersectValue CGPointValue];
            // set the collision enum
            collisionObject = Platform;

            CGPoint newCenter = CGPointMake(intersect.x, intersect.y -_ball.radius);
            // update the ball's center
            
            [_ball setNewCenter:newCenter];
            
            CGFloat angle;
            // the speed of the ball
            CGFloat ballspeed = sqrt(_ball.xvelocity*_ball.xvelocity + _ball.yvelocity * _ball.yvelocity);
            
            CGFloat speedMultiplier = (abs(_platform.center.x - _ball.center.x) / (_platform.rect.size.width/2.0)) * BALL_MAX_SPEED_INCREASE_MULTIPLIER;
            
            
            // if the ball hit the left part of the platform
            if ( _ball.center.x < _platform.center.x)
            {
                angle = 90 + ((_platform.center.x - _ball.center.x)/(_platform.rect.size.width/2.0)) *MAXIMUM_ANGLE_FROM_PLATFORM ;
                
                [self setBallAngle:angle speed:ballspeed speedIncrement:speedMultiplier];
            }
            // the ball hit the right part of the platform
            else if (_ball.center.x > _platform.center.x)
            {
                angle = 90 - (-_platform.center.x + _ball.center.x)/(_platform.rect.size.width/2.0) *MAXIMUM_ANGLE_FROM_PLATFORM;
                
                [self setBallAngle:angle speed:ballspeed speedIncrement:speedMultiplier];
            }
            
            // if the ball hit the middle
            else
            {
                
                _ball.yvelocity *= -1;
            }
        }
    }
}

/* checks for collision with the border and reverses the appropriate velocity of the ball. In case the new position of the ball is out of the border, sets a new position for the ball */
-(void)checkForCollisionWithBorders
{
    // the ball crossed the left border
    if ( _ball.rect.origin.x <= 0 )
    {
        collisionObject = Border;
        // invert the x velocity
        _ball.xvelocity *= -1;
        CGPoint endpoint = CGPointMake(_ball.center.x - _ball.radius, _ball.center.y);
        // get the intersection point of the ball with the left border
        CGPoint startpoint = CGPointMake(prevBallPosition.x - _ball.radius, prevBallPosition.y);
        CGPoint intersect = [[self intersectionOfLineFrom:startpoint to:endpoint withLineFrom:boardTopLeftCorner to:boardBottomLeftCorner] CGPointValue];
        // set the new center of the ball
        CGPoint newCenter = CGPointMake(intersect.x + _ball.radius, intersect.y);
        [_ball setCenter:newCenter];
        
        
    }
  
    // ball intersects the right border
    else if ( _ball.rect.size.width + _ball.rect.origin.x >=_board.size.width )
    {
        collisionObject = Border;
        
        _ball.xvelocity *= -1;
        CGPoint endpoint = CGPointMake(_ball.center.x + _ball.radius, _ball.center.y);
        CGPoint startpoint = CGPointMake(prevBallPosition.x + _ball.radius, prevBallPosition.y);
        CGPoint intersect = [[self intersectionOfLineFrom:startpoint to:endpoint withLineFrom:boardTopRightCorner to:boardBottomRightCorner] CGPointValue];
        // set the new center of the ball
        CGPoint newCenter = CGPointMake(intersect.x - _ball.radius, intersect.y);
        [_ball setCenter:newCenter];
        
    }
    // the ball crossed the top border
    if ( _ball.rect.origin.y <= 0)
    {
        collisionObject = Border;
        // invert the y velocity
        _ball.yvelocity *= -1;
        CGPoint endpoint = CGPointMake(_ball.center.x, _ball.center.y - _ball.radius);
        // get the intersection point of the ball with the top border
        CGPoint startpoint = CGPointMake(prevBallPosition.x, prevBallPosition.y - _ball.radius);
        CGPoint intersect = [[self intersectionOfLineFrom:endpoint to:startpoint withLineFrom:boardTopRightCorner to:boardTopLeftCorner] CGPointValue];
        // set the new center of the ball
        CGPoint newCenter = CGPointMake(intersect.x, intersect.y + _ball.radius);
        [_ball setCenter:newCenter];
    }
    // ball intersects the bottom corner
    else if ( _ball.rect.size.height + _ball.rect.origin.y >=  _board.size.height  )
    {
        collisionObject = Border;
        
        _ball.yvelocity *= -1;
        CGPoint endpoint = CGPointMake(_ball.center.x, _ball.center.y + _ball.radius);
        CGPoint startpoint = CGPointMake(prevBallPosition.x, prevBallPosition.y + _ball.radius);
        CGPoint intersect = [[self intersectionOfLineFrom:startpoint to:endpoint withLineFrom:boardBottomLeftCorner to:boardBottomRightCorner] CGPointValue];
        // set the new center of the ball
        CGPoint newCenter = CGPointMake(intersect.x, intersect.y - _ball.radius);
        [_ball setCenter:newCenter];
    }
    
}


-(void)checkForCollisionWithBricks
{
    // if the ball is below the lowest brick, do not check
   if( _ball.rect.origin.y > lowestBrickHeight)
     {
         return;
     }
    
    // the top, bottom, left and right points of the ball and previous ball
    CGPoint startpointLeft = CGPointMake(prevBallPosition.x - _ball.radius, prevBallPosition.y);
    CGPoint startpointBot = CGPointMake(prevBallPosition.x, prevBallPosition.y + _ball.radius);
    CGPoint endpointLeft = CGPointMake(_ball.center.x - _ball.radius, _ball.center.y);
    CGPoint endpointBot = CGPointMake(_ball.center.x , _ball.center.y + _ball.radius);
    CGPoint startpointRight = CGPointMake(prevBallPosition.x + _ball.radius, prevBallPosition.y);
    CGPoint startpointTop = CGPointMake(prevBallPosition.x, prevBallPosition.y - _ball.radius);
    CGPoint endpointRight = CGPointMake(_ball.center.x + _ball.radius, _ball.center.y);
    CGPoint endpointTop = CGPointMake(_ball.center.x, _ball.center.y - _ball.radius);
    // intersected1 - vertical intersection, intersected2 - horizontal intersection
    NSValue* intersected1, *intersected2;
    
    NSInteger rows = _level.rows;
    NSInteger cols = _level.columns;
    CGFloat rad = _ball.radius;
    // iterate through the array of bricks, consider bricks that have life greater than 0
    for (int row = 0; row < rows; row++)
    {
        for( int col = 0; col < cols; col++)
            
        {
        BrickObject* brick = _bricks[row*cols + col];
        intersected1 = intersected2 = nil;
            
        if( brick.life > 0 && [self ballIsInsideExtendedRectangle:brick.rect] )
        {
            
            /* determines in which quadrant of the brick is the previous ball in. The plane is divided into 8 quadrants by the edges of the brick. */
            
            int quadrant = [self quadrantOfballWithCenter:prevBallPosition radius:_ball.radius ofBrick:brick];
            
            // booleans indicate the existence of neighbors
            BOOL topNeighbor, bottomNeighbor, leftNeighbor, rightNeighbor;
            topNeighbor = bottomNeighbor = leftNeighbor = rightNeighbor = NO;
            
                
                BrickObject* neighborBrick;
                
                // checking top neighbor
                if ( row - 1 > -1 )
                {
                    neighborBrick = _bricks[(row - 1)* cols + col];
                    
                    if ( neighborBrick.life > 0)
                        topNeighbor = YES;
                }
                
                // checking bottom neighbor
                if ( row + 1 < rows)
                    
                {
                    neighborBrick = _bricks[(row + 1)* cols + col];
                    
                    if ( neighborBrick.life > 0)
                        bottomNeighbor = YES;
                    
                }
                
                //checking left neighbor
                if( col - 1 > -1)
                {
                    neighborBrick = _bricks[row* cols + col - 1];
                    
                    if ( neighborBrick.life > 0)
                        leftNeighbor = YES;
                }
                
                // checking right neighbor
                if( col + 1 < cols )
                {
                    neighborBrick = _bricks[row* cols + col + 1];
                    
                    if ( neighborBrick.life > 0)
                        rightNeighbor = YES;
                }
            
            
            // how much should the intersection point be shifted to obtain the ball's final position
            CGPoint diff;
            // the changes in the direction of the ball
            CGPoint dxdy;
            // the previous position is in the 1st quadrant
            if( quadrant == 1 )
            {
                if(!topNeighbor)
                // the intersection to the top edge of the brick
                intersected1 = [self intersectionOfLineFrom:startpointBot to:endpointBot withLineFrom:brick.topRightCorner to:brick.topLeftCorner];
                if(!rightNeighbor)
                // the intersection to the right edge of the brick
                intersected2 = [self intersectionOfLineFrom:startpointLeft to:endpointLeft withLineFrom:brick.topRightCorner to:brick.bottomRightCorner];
                
                diff.x = rad;
                diff.y = -rad;
                
                if( _ball.yvelocity > 0 )
                    dxdy.y = -1;
                if( _ball.xvelocity < 0 )
                    dxdy.x = -1;
                
            }
            // the previous position is in the 2nd quadrant
            else if (quadrant == 2 )
            {
                // the intersection to the top edge of the brick
                intersected1 = [self intersectionOfLineFrom:startpointBot to:endpointBot withLineFrom:brick.topRightCorner to:brick.topLeftCorner];
                diff.x = 0;
                diff.y = -rad;
                dxdy.x = 1;
                if( _ball.yvelocity > 0)
                    dxdy.y = -1;
            }
            // the previous position is in the 3rd quadrant
            else if( quadrant == 3)
            {
                if(!topNeighbor)
                // the intersection to the top edge of the brick
                intersected1 = [self intersectionOfLineFrom:startpointBot to:endpointBot withLineFrom:brick.topRightCorner to:brick.topLeftCorner];
                if(!leftNeighbor)
                // the intersection to the left edge of the brick
                intersected2 = [self intersectionOfLineFrom:startpointRight to:endpointRight withLineFrom:brick.topLeftCorner to:brick.bottomLeftCorner];
 
                diff.x = -rad;
                diff.y = -rad;
                if( _ball.xvelocity > 0)
                    dxdy.x = -1;
                if( _ball.yvelocity > 0)
                    dxdy.y = -1;
                
            }
            // the previous position is in the 4th quadrant
            else if (quadrant == 4)
            {
                // the intersection to the left edge of the brick
                intersected2 = [self intersectionOfLineFrom:startpointRight to:endpointRight withLineFrom:brick.topLeftCorner to:brick.bottomLeftCorner];
                diff.x = -rad;
                diff.y = 0;
                if( _ball.xvelocity > 0)
                    dxdy.x = -1;
                dxdy.y = 1;
            }
            // the previous position is in the 5th quadrant
            else if( quadrant == 5 )
            {
                if(!bottomNeighbor)
                // the intersection to the bottom edge of the brick
                intersected1 = [self intersectionOfLineFrom:startpointTop to:endpointTop withLineFrom:brick.bottomRightCorner to:brick.bottomLeftCorner];
                if(!leftNeighbor)
                // the intersection to the left edge
                intersected2 = [self intersectionOfLineFrom:startpointRight to:endpointRight withLineFrom:brick.topLeftCorner to:brick.bottomLeftCorner];
              
                diff.x = -rad;
                diff.y = rad;
                if( _ball.yvelocity < 0)
                    dxdy.y = -1;
                if( _ball.xvelocity > 0)
                    dxdy.x = -1;
                
            }
            // the previous ball is in the 6th quadrant
            else if (quadrant == 6)
            {
                // the intersection to the bottom edge
                intersected1 = [self intersectionOfLineFrom:startpointTop to:endpointTop withLineFrom:brick.bottomLeftCorner to:brick.bottomRightCorner];
                diff.x = 0;
                diff.y = rad;
                dxdy.x = 1;
                if( _ball.yvelocity < 0)
                    dxdy.y = -1;
            }
            // the previous ball is in the 7th quadrant
            else if( quadrant == 7 )
            {
                // the intersection to the bottom edge
                if( !bottomNeighbor)
                    intersected1 = [self intersectionOfLineFrom:startpointTop to:endpointTop withLineFrom:brick.bottomRightCorner to:brick.bottomLeftCorner];
                if( !rightNeighbor)
                // the intersection to the right edge
                intersected2 = [self intersectionOfLineFrom:startpointLeft to:endpointLeft withLineFrom:brick.topRightCorner to:brick.bottomRightCorner];

                diff.x = rad;
                diff.y = rad;
                if( _ball.xvelocity < 0)
                    dxdy.x = -1;
                if( _ball.yvelocity < 0)
                    dxdy.y = -1;
                
            }
            // the previous ball is in the 8th quadrant
            else if (quadrant == 8)
            {
                // the intersection to the right edge
                intersected2 = [self intersectionOfLineFrom:startpointLeft to:endpointLeft withLineFrom:brick.bottomRightCorner to:brick.topRightCorner];
                diff.x = rad;
                diff.y = 0;
                if(_ball.xvelocity < 0)
                    dxdy.x = -1;
                dxdy.y = 1;
            }

           // in case intersection1 took place
            if ( intersected1 )
            {
                collisionObject = BrickTouch;
                CGPoint intersection = [intersected1 CGPointValue];
                CGPoint newCenter = CGPointMake(intersection.x + diff.x, intersection.y + diff.y);
                
                [_ball setNewCenter:newCenter];
                _ball.yvelocity *= dxdy.y;
                [self ballCollidedWithBrickAtIndex:row*cols + col];
               }
            // in case intersection 2 took place
            else if ( intersected2 )
            {
                collisionObject = BrickTouch;
                CGPoint intersection = [intersected2 CGPointValue];
                CGPoint newCenter = CGPointMake(intersection.x + diff.x, intersection.y + diff.y);
                [_ball setNewCenter:newCenter];
                _ball.xvelocity *= dxdy.x;
                [self ballCollidedWithBrickAtIndex:row*cols + col];
             
            }
            
            // the case when the ball must have intersected with the corner
            else
            {
                

                // determine the closest corner to the previous position, which will show which corner was passed through
                CGFloat distFromBottomLeftCorner = [self distFrom:prevBallPosition to:brick.bottomLeftCorner];
                CGFloat distFromBottomRightCorner = [self distFrom:prevBallPosition to:brick.bottomRightCorner];
                CGFloat distFromTopLeftCorner = [self distFrom:prevBallPosition to:brick.topLeftCorner];
                CGFloat distFromTopRightCorner = [self distFrom:prevBallPosition to:brick.topRightCorner];
                
                CGFloat min = MIN( MIN(distFromBottomLeftCorner, distFromBottomRightCorner), MIN(distFromTopLeftCorner, distFromTopRightCorner));
         
                // if the closest point is the bottom left point, check if the ball has entered it
                if ( (min == distFromBottomLeftCorner && !leftNeighbor && !bottomNeighbor) || ( min == distFromBottomRightCorner && !rightNeighbor && !bottomNeighbor) || ( min == distFromTopRightCorner && !rightNeighbor && !topNeighbor) || ( min == distFromTopLeftCorner && !topNeighbor && !leftNeighbor) )
                {

                    collisionObject = BrickTouch;
                    [_ball setNewCenter:prevBallPosition];
                    // invert the direction of the ball
                    _ball.xvelocity *= -1;
                    _ball.yvelocity *= -1;
                    [self ballCollidedWithBrickAtIndex:row*cols + col];
                }

            }
             // the ball can intersect at most with 4 bricks
            if( collidedBrickIndeces.count == 4)
                return;
            
        }
    }
}
}

/* the method decreases the life of the brick by one, updates the level object of the Engine
 adds the brick to the array of collided bricks and updates the number of destroyed bricks and number of bricks left in case the brick was destroyed */

-(void)ballCollidedWithBrickAtIndex:(NSInteger) brickIndex
{
    ((BrickObject*)(_bricks[brickIndex])).life--;
    
    NSInteger newLife = ((BrickObject*)(_bricks[brickIndex])).life;
    [_level.arrayOfBricks replaceObjectAtIndex:brickIndex withObject:[[NSNumber alloc] initWithInteger:newLife]];
    
    CGPoint collidedBrick = CGPointMake(brickIndex, newLife);
    
    if ( newLife == 0)
    {
        destroyedBricksNumber++;
        bricksLeftNumber--;
    }
    [collidedBrickIndeces addObject:[NSValue valueWithCGPoint:collidedBrick] ];
}

// checks if the ball is inside the extended rectangle. The extended rectangle is the rectangle of the brick extended by the ball's diameter
-(BOOL)ballIsInsideExtendedRectangle:(CGRect) rect
{
    // construct the topleft and bottomright corners of the extended rectangle
    CGPoint extendedRectTopleftCorner = CGPointMake(rect.origin.x - 2*_ball.radius, rect.origin.y - 2*_ball.radius);
    CGPoint extendedRectBottomRightCorner = CGPointMake(rect.origin.x + rect.size.width + 2*_ball.radius, rect.origin.y + rect.size.height + 2*_ball.radius);
    
    // check if the ball is inside the extended rectangle
    if( _ball.rect.origin.x >= extendedRectTopleftCorner.x && _ball.rect.origin.x + _ball.rect.size.width <= extendedRectBottomRightCorner.x && _ball.rect.origin.y >= extendedRectTopleftCorner.y && _ball.rect.origin.y + _ball.rect.size.height <= extendedRectBottomRightCorner.y)
        return YES;
    
    return NO;
}
#pragma mark - Methods called by ViewController

-(void)resetWithSavedData:(BOOL) savedData toLevel:(NSInteger) levelNumber
{
    
    if(savedData)
    {
        // get the level object from sahred data manager
        SharedDataManager* manager = [SharedDataManager sharedManager];
        _level = manager.level;

    }
    else
    {
        // gets the new level from level manager and constructs it
        _level = [[LevelManager sharedLevelManager] levelNumber:levelNumber];
        [self saveData];
    }
    // resets the positions of the ball and platform
    [_ball setNewCenter:ballInitialCenter];
    [_platform setNewCenter:platformInitialCenter];
     _ball.xvelocity = _ball.yvelocity = 0;
    //construct the bricks by the current level object
    [self constructLevel];
    
}
-(CGRect)ballObjectFrame
{
    return _ball.rect;
}

-(CGRect)platformObjectFrame
{
    return _platform.rect;
}

-(CGPoint)boardSizes
{
    CGPoint point;
    point.x = _board.size.width;
    point.y = _board.size.height;
    return point;
}

-(NSArray*)brickObjectsFrames
{
    return _bricks;
}
// if the angle is less than 0 or greater than 180, the ball is shot at a random angle
-(void)calculateBallInitialDirection:(CGPoint)point
{
    
    CGFloat angle = atan2( - point.y + ballInitialCenter.y, point.x - ballInitialCenter.x);
    if ( angle <= 0 || angle >= 180)
    {
        // shoot at a random angle defined by RANDOM_ANGLE
        [self setBallAngle:arc4random_uniform(RANDOM_ANGLE) + 1 speed:BALL_INITIIAL_VECTOR_MAGNITUDE speedIncrement:0];
    }
    
    else
        [self setBallAngle:angle * 180 / M_PI speed:BALL_INITIIAL_VECTOR_MAGNITUDE speedIncrement:0];
    
}

-(void)start
{
    // start the timer
    _myTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/FPS target:self selector:@selector(update) userInfo:nil repeats:YES];
}

-(void)pause
{
            [_myTimer invalidate];
            _myTimer = nil;
}
#pragma mark - Auxilarry methods

// saves the information to sharedDataManager
-(void)saveData
{
    SharedDataManager* manager = [SharedDataManager sharedManager];
    manager.level = _level;
    
}
// constructs the current level of the engine
-(void)constructLevel
{
    bricksLeftNumber = 0;
    [collidedBrickIndeces removeAllObjects];
    //calculate the brick dimensions
   CGFloat brickWidth = _board.size.width / _level.columns;
   CGFloat brickHeight = brickWidth * BRICK_HEIGHT_TO_WIDTH_RATIO;
    
    // the array of brick objects
    _bricks = [[NSMutableArray alloc] init];
    
    // construct the array of brick objects
    for (int i = 0; i < _level.rows; i++)
        for( int j = 0; j < _level.columns; j++)
            
        {
            // get the life from the level object's array
            NSInteger lifes = [_level.arrayOfBricks[i * _level.columns + j] integerValue];
            // construct the brick's rect based on the column and row
            CGRect brickRect = CGRectMake(j*brickWidth, i*brickHeight, brickWidth, brickHeight);
            // add the brick object to the bricks array
            [_bricks addObject:[[BrickObject alloc] initWithRect:brickRect life:lifes]];
            // if it is not an empty brick
            if( lifes > 0)
            {
                bricksLeftNumber++;
                lowestBrickHeight = brickHeight * i + brickHeight;
            }
        }
    
}

-(void)setBallAngle:(CGFloat) angle speed:(CGFloat) speed speedIncrement:(CGFloat) multiplier
{
    // increase the speed by the initial speed times multiplier
    speed += BALL_INITIIAL_VECTOR_MAGNITUDE* multiplier;
    
    // if the speed is over the defined maximal, set it to maximal
    if( speed > BALL_INITIIAL_VECTOR_MAGNITUDE * BALL_TOP_SPEED_COEFF)
        speed = BALL_TOP_SPEED_COEFF * BALL_INITIIAL_VECTOR_MAGNITUDE;
    
    CGFloat newXvelocity = speed * cos(angle * M_PI / 180.0);
    CGFloat newYvelocity = speed * sin(angle* M_PI / 180.0);
    
    // since the y-axis is inverted, multiply by -1
    _ball.yvelocity = -newYvelocity;
    _ball.xvelocity = newXvelocity;
}

// determines if two line segments intersect and returns the intersection point
- (NSValue *)intersectionOfLineFrom:(CGPoint)p1 to:(CGPoint)p2 withLineFrom:(CGPoint)p3 to:(CGPoint)p4
{
    
    CGFloat d = (p3.x - p4.x)*(p2.y - p1.y) - (p3.y - p4.y)*(p2.x - p1.x);
    if( d== 0)
        return nil;
    CGFloat s = ((p2.x - p4.x)*(p2.y - p1.y) + (p2.y - p4.y)*(p1.x - p2.x))/d;
    
    CGFloat t = ((p2.x - p4.x)*(p4.y - p3.y) + (p2.y - p4.y)*(p3.x - p4.x))/d;
    
    if (s < 0.0 || s > 1.0)
    {
        return nil; // intersection point not between p1 and p2
    }
    if (t < 0.0 || t > 1.0)
    {
        return nil; // intersection point not between p1 and p2
    }
    CGPoint intersection;
    
    intersection.x = t*p1.x + (1-t)*p2.x;
    intersection.y = t*p1.y + (1-t)*p2.y;
    
    return [NSValue valueWithCGPoint:intersection];
}


-(CGFloat)distFrom:(CGPoint) x to:(CGPoint) y
{
    return ((x.x - y.x)*(x.x - y.x) + (x.y - y.y)*(x.y-y.y));
}

// determines which of the 8 quadrants the ball belongs to
-(int)quadrantOfballWithCenter:(CGPoint) center radius:(CGFloat) radius ofBrick:(BrickObject*) brick
{
    CGFloat xconstraint1, yconstraint1, xconstraint2, yconstraint2;
    
    
    xconstraint1 = brick.topRightCorner.x - radius;
    yconstraint1 = brick.topRightCorner.y + radius;
    if ( center.x - radius > xconstraint1 && center.y + radius < yconstraint1)
        return 1;
    
    xconstraint1 = brick.topRightCorner.x + radius;
    xconstraint2 = brick.topLeftCorner.x - radius;
    yconstraint1 = brick.topRightCorner.y;
    if ( center.x - radius >= xconstraint2 && center.x + radius <= xconstraint1 && center.y + radius < yconstraint1)
        return 2;
    
    xconstraint1 = brick.topLeftCorner.x + radius ;
    yconstraint1 = brick.topLeftCorner.y + radius;
    
    if ( center.x + radius < xconstraint1 && center.y + radius < yconstraint1)
        return 3;
    
    xconstraint1 = brick.topLeftCorner.x;
    yconstraint1 = brick.topLeftCorner.y - radius;
    yconstraint2 = brick.bottomLeftCorner.y + radius;
    
    if( center.x + radius < xconstraint1 && center.y - radius > yconstraint1 && center.y + radius < yconstraint2)
        return 4;
    
    xconstraint1 = brick.bottomLeftCorner.x + radius;
    yconstraint1 = brick.bottomLeftCorner.y - radius;
    
    if( center.x < xconstraint1 && center.y > yconstraint1)
        return 5;
    
    xconstraint1 = brick.bottomLeftCorner.x - radius;
    xconstraint2 = brick.bottomRightCorner.x + radius;
    yconstraint1 = brick.bottomRightCorner.y;
    
    if ( center.x - radius > xconstraint1 && center.x + radius < xconstraint2 && center.y - radius > yconstraint1)
        return 6;
    
    xconstraint1 = brick.bottomRightCorner.x - radius;
    yconstraint1 = brick.bottomRightCorner.y - radius;
    
    if( center.x - radius > xconstraint1 && center.y - radius > yconstraint1)
        return 7;
    
    xconstraint1 = brick.bottomRightCorner.x;
    yconstraint1 = brick.bottomRightCorner.y + radius;
    yconstraint2 = brick.topRightCorner.y - radius;
    
    if ( center.x - radius > xconstraint1 && center.y + radius <= yconstraint1 && center.y - radius >= yconstraint2)
        return 8;
    
    return 0;
}

@end
