//
//  boardView.m
//  Arkanoid
//
//  Created by Admin on 25.02.15.
//  Copyright (c) 2015 Hrach. All rights reserved.
//

#import "BoardView.h"
#import "Engine.h"
#import "BrickObject.h"
#import "BrickView.h"
#import "PlatformView.h"
#import "BallView.h"


@interface BoardView ()

@property BallView* ball;
@property PlatformView* platform;
@property NSMutableArray* bricks;
@property UIImageView* animationView;


@end

@implementation BoardView
{
    // array of brick images of different colors
    NSMutableArray* brickColors;
    // array of images for lightning animation
    NSMutableArray* animationViewImages;

    // the positions of the ball and the platform when they are first drawn
    CGPoint ballInitialPosition;
    CGPoint platformInitialPosition;

}
// constructs the Boardview and initializes the ball, platform and bricks based on the data of their models
-(instancetype)initWithFrame:(CGRect) frame platform:(CGRect) platform ball:(CGRect) ball bricks:(NSArray*) brickobjects;
{
    self = [super initWithFrame:frame];
    if(self)
    {
        // set initial positions of ball and platform
        ballInitialPosition = CGPointMake(ball.origin.x + ball.size.width/2, ball.origin.y + ball.size.height/2);
        platformInitialPosition = CGPointMake(platform.origin.x + platform.size.width/2, platform.origin.y + platform.size.height/2);
        
        // screate the array of BrickColors
        brickColors = [[NSMutableArray alloc]init];
        brickColors[0] = [[NSMutableArray alloc]init];

        [brickColors addObject:[UIImage imageNamed:@"blueBrick"]];
        [brickColors addObject:[UIImage imageNamed:@"redBrick"]];
        [brickColors addObject:[UIImage imageNamed:@"greenBrick"]];
        [brickColors addObject:[UIImage imageNamed:@"orangeBrick"]];
        [brickColors addObject:[UIImage imageNamed:@"purpleBrick"]];
        [brickColors addObject:[UIImage imageNamed:@"yellowBrick"]];
        
        // get the images for lightning animation
        for( int i = 1; i <= NUMBER_OF_EXPL_IMAGES; i++)
        {
            // construct the name of the image
            NSString *imageName = [NSString stringWithFormat:@"e%li.png", (long)i];
            //get the path to the image
            NSString *path = [[NSBundle mainBundle] pathForResource:imageName
                                                             ofType:nil];
            // construct the image
            UIImage *image = [UIImage imageWithContentsOfFile:path];
            [brickColors[0] addObject:(id)image.CGImage];
            
        }
        
        // a little self customization
        self.backgroundColor = [UIColor blackColor];
        self.layer.borderColor = [UIColor blueColor].CGColor;
        self.layer.borderWidth = 3.0f;
        
        // create the platform and the ball views
        _ball = [[BallView alloc] initWithFrame: ball];
        _platform = [[PlatformView alloc] initWithFrame:platform];
        [self addSubview:_ball];
        [self addSubview:_platform];
        
        // create the brick views
        _bricks = [[NSMutableArray alloc]init];
        
        if (brickobjects)
        {
            [self updateBrickViews:brickobjects];
        }
        
        
        // construct the animationImageView
        CGFloat animationImageOriginX = 0;
        CGFloat animationImageOriginY = self.frame.size.height * ( 1 - LIGHTNING_ANIM_SIZE_BOARD_RATIO) / 2.0;
        CGFloat animationImageWidth = self.frame.size.width;
        CGFloat animationImageHeight = self.frame.size.height * LIGHTNING_ANIM_SIZE_BOARD_RATIO;
        
        CGRect animationImageRect = CGRectMake(animationImageOriginX, animationImageOriginY, animationImageWidth, animationImageHeight);
        
        _animationView = [[UIImageView alloc]initWithFrame:animationImageRect];
        [self addSubview:_animationView];
        
        // add the animation image arrays to animation imageviews
        animationViewImages = [[NSMutableArray alloc]init];
        
       for( int i = 1; i <= NUMBER_OF_ANIM_IMAGES; i++)
        {
            // construct the names of the images
            NSString *imageName1 = [NSString stringWithFormat:@"l%li.png", (long)i];
            //get the paths to the images
            NSString *path1 = [[NSBundle mainBundle] pathForResource:imageName1 ofType:nil];
            // construct the images
            UIImage *image1 = [UIImage imageWithContentsOfFile:path1];
            [animationViewImages addObject:(id)image1.CGImage];

        }
        
        
    }
    return self;
}

// changes the center of the platform based on the change of the slider value
-(void)movePlatformBy:(CGFloat)sliderValue
{
    CGPoint aNewCenter = _platform.center;
    aNewCenter.x = _platform.frame.size.width/2 + sliderValue * (self.frame.size.width - _platform.frame.size.width);
    [_platform moveToCenter:aNewCenter];
}

-(void)moveBallToCenter:(CGPoint) aNewCenter
{
    [_ball moveToCenter:aNewCenter];
    
}

// returns the center of the platform
-(CGPoint)platformPosition
{
    return [_platform position];
}

-(void)moveBallAndPlatformInitialPosition
{
    [_ball moveToCenter:ballInitialPosition];
    [_platform moveToCenter:platformInitialPosition];

}

-(void)redrawBricks:(NSMutableArray *)collidedBricks
{
    for ( NSValue* val in collidedBricks)
    {
        CGPoint brick = [val CGPointValue];
        NSInteger brickLife = brick.y;
        NSInteger brickIndex = brick.x;
        UIColor* newColor;
        
        // if the life of the brick is 0, explode it
        if( brickLife == 0)
            [_bricks[brickIndex] explode:brickColors[0]];
        // otherwise set the new color
        else
        {
            newColor = brickColors[brickLife];
            [_bricks[brickIndex] changeImage:brickColors[brickLife]];
        }
    }
}

-(void)updateBrickViews:(NSMutableArray *)newBricks
{
    // first remove the old views form superview
    for( BrickView* brickView in _bricks)
    {
        [brickView removeFromSuperview];
    }
    
    // empty the array
    [_bricks removeAllObjects];
    
    for( BrickObject* brickObject in newBricks)
    {
        NSInteger life = brickObject.life;
        UIImage* brickImage;
        
        if( life == 0)
            brickImage = nil;
        else
            brickImage = brickColors[life];
        
        BrickView* brickView = [[BrickView alloc]initWithFrame:brickObject.rect image:brickImage];
        [self addSubview:brickView];
        [_bricks addObject:brickView];
    }
    
}

// called by ViewController
-(void)animateShooting
{
    [self animateLightning];
    [self animateTiltonView:self];
}
// Uses CAAnimation 
-(void)animateLightning
{

    _animationView.alpha = 1.0;
    
    CAKeyframeAnimation *keyframeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
    
    [keyframeAnimation setValue:@"lightning" forKey:@"id"];
    
    keyframeAnimation.values = animationViewImages;
    
    keyframeAnimation.repeatCount = LIGHTNING_ANIM_REPEAT_COUNT;
    keyframeAnimation.duration = LIGHTNING_ANIM_DURATION;
    
    keyframeAnimation.delegate = self;
    
    keyframeAnimation.removedOnCompletion = NO;
    keyframeAnimation.fillMode = kCAFillModeForwards;
    
    CALayer *layer = _animationView.layer;
    
    [layer addAnimation:keyframeAnimation
                 forKey:@"lightningAnimation"];
}

// does a tilt animation on the view
-(void)animateTiltonView:(UIView*) view
{
    CGFloat posLength = TILT_ANIM_LENGTH;
    CGFloat negLength = -posLength;
    CAKeyframeAnimation * anim = [ CAKeyframeAnimation animationWithKeyPath:@"transform" ] ;
    anim.values = @[ [ NSValue valueWithCATransform3D:CATransform3DMakeTranslation(negLength, negLength, negLength) ], [ NSValue valueWithCATransform3D:CATransform3DMakeTranslation(posLength, posLength, posLength) ] ] ;
    anim.autoreverses = YES ;
    anim.repeatCount = TILT_ANIM_REPEAT ;
    anim.duration = TILT_ANIM_DURATION ;
    
    [view.layer addAnimation:anim forKey:nil] ;
}

// resizes the image to fit into the frame's sizes
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
#pragma mark - CAAnimationDelegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if ([[anim valueForKey:@"id"] isEqual:@"lightning"])
    {
       _animationView.alpha = 0.0;
        [_animationView.layer removeAnimationForKey:@"lightningAnimation"];  // just in case
    }
    
}

@end
