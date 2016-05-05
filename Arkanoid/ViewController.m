//
//  ViewController.m
//  Arkanoid
//
//  Created by Admin on 24.02.15.
//  Copyright (c) 2015 Hrach. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

@class ballObject;
@class platformObject;

@interface ViewController ()

@property UISlider* mySlider;
@property UILabel* lifesLabel;
@property UILabel* levelLabel;
@property UILabel* scoreLabel;
@property BoardView* myBoardView;
@property PopupView* myPopupView;
@property NSInteger level;
@property NSInteger score;
@property NSInteger lifes;

@end

@implementation ViewController

{
    Engine* engine;
    SharedDataManager* manager;

    BOOL loadedWithSavedData;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    engine = [Engine sharedEngine];
    manager = [SharedDataManager sharedManager];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.myViewController = self;
   
    // set the delegate
    engine.delegate = self;
    
    if( ![manager empty])
    {
        _level = manager.levelNumber;
        _lifes = manager.lifes ;
        _score = manager.score ;
        [engine resetWithSavedData:YES toLevel:0];
        loadedWithSavedData = YES;
    }
    
    UIImage* backImage = [self imageWithImage:[UIImage imageNamed:@"back5"] scaledToSize:self.view.frame.size];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:backImage];
    
    // get the application frame to build the views on it
    CGRect appFrame = [[UIScreen mainScreen] applicationFrame];
    CGFloat appFrameWidth = appFrame.size.width;
    CGFloat appFrameHeight = appFrame.size.height;
    
    
    CGFloat boardWidth = [engine boardSizes].x;
    CGFloat boardHeight = [engine boardSizes].y;
    
    CGFloat sliderHeight;
    CGFloat labelsWidth = boardWidth/3.0;
    CGFloat labelsHeight = sliderHeight = ((1.0 - BOARD_HEIGHT_TO_SCREEN_RATIO)/2.0) * appFrameHeight;
    
    CGFloat lifesLabelOriginX = (appFrameWidth - boardWidth)/2.0;
    CGFloat lifesLabelOriginY = appFrame.origin.y;
    
    CGRect lifesLabelRect = CGRectMake(lifesLabelOriginX, lifesLabelOriginY, labelsWidth, labelsHeight);
    
    CGRect levelLabelRect = CGRectMake(lifesLabelRect.origin.x + labelsWidth, lifesLabelOriginY, labelsWidth, labelsHeight);
    
    CGRect scoreLabelRect = CGRectMake(levelLabelRect.origin.x + labelsWidth, lifesLabelOriginY, labelsWidth, labelsHeight);
    
    CGRect boardRect = CGRectMake( ((1-BOARD_WIDTH_TO_SCREEN_RATIO)/2.0)*appFrameWidth, lifesLabelRect.origin.y + labelsHeight, boardWidth, boardHeight);
    
    CGRect sliderRect = CGRectMake(boardRect.origin.x, boardRect.origin.y + boardRect.size.height, boardRect.size.width, labelsHeight);
    
    CGFloat popupWidth = boardRect.size.width * POPUP_WIDTH_TO_BOARD_RATIO;
    CGFloat popupHeight = boardRect.size.height * POPUP_HEIGHT_TO_BOARD_RATIO;
    
    // construct the boardView
    _myBoardView = [[BoardView alloc] initWithFrame:boardRect platform:[engine platformObjectFrame] ball:[engine ballObjectFrame] bricks:[engine brickObjectsFrames]];
    
    // construct the pop up
     CGRect popupRect = CGRectMake(_myBoardView.center.x - popupWidth/2.0, _myBoardView.center.y - popupHeight/2.0, popupWidth, popupHeight);
    
    _myPopupView = [[PopupView alloc] initWithFrame:popupRect];
    _myPopupView.delegate = self;
    
    [self.view addSubview:_myBoardView];
    [self.view addSubview:_myPopupView];
    
    // construct and customize the slider
    
    _mySlider = [[UISlider alloc]initWithFrame:sliderRect];
    
    // set the values of the slider
    _mySlider.minimumValue = SLIDER_MIN_VAL;
    _mySlider.maximumValue = SLIDER_MAX_VAL;
    _mySlider.value = (SLIDER_MIN_VAL + SLIDER_MAX_VAL)/2.0;
    _mySlider.continuous = YES;

    _mySlider.backgroundColor = [UIColor clearColor];
    [_mySlider setMaximumTrackImage:[[UIImage alloc]init] forState:UIControlStateNormal];
    [_mySlider setMinimumTrackImage:[[UIImage alloc]init] forState:UIControlStateNormal];
    [_mySlider setThumbImage:[UIImage imageNamed:@"thumb"] forState:UIControlStateNormal];
    
    [_mySlider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_mySlider];

    
    
    // construct and customize the labels
    
    
    _lifesLabel = [[UILabel alloc]initWithFrame:lifesLabelRect];
    UIImage* labelImage = [self imageWithImage:[UIImage imageNamed:@"mainLabel"] scaledToSize:_lifesLabel.frame.size];
    _lifesLabel.backgroundColor = [UIColor colorWithPatternImage:labelImage];
    _lifesLabel.textAlignment = NSTextAlignmentCenter;
    _lifesLabel.font =  [UIFont fontWithName:@"Helvetica-Bold" size:LABEL_FONT_SIZE];
    _lifesLabel.textColor = [UIColor whiteColor];
    _lifesLabel.adjustsFontSizeToFitWidth = YES;
    _levelLabel = [[UILabel alloc]initWithFrame:levelLabelRect];
    _levelLabel.backgroundColor = [UIColor colorWithPatternImage:labelImage];
    _levelLabel.textAlignment = NSTextAlignmentCenter;
    _levelLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:LABEL_FONT_SIZE];
    _levelLabel.textColor = [UIColor whiteColor];
    _levelLabel.adjustsFontSizeToFitWidth = YES;
    _scoreLabel = [[UILabel alloc]initWithFrame:scoreLabelRect];
    _scoreLabel.backgroundColor = [UIColor colorWithPatternImage:labelImage];
    _scoreLabel.textAlignment = NSTextAlignmentCenter;
    _scoreLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:LABEL_FONT_SIZE];
    _scoreLabel.textColor = [UIColor whiteColor];
    _scoreLabel.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:_lifesLabel];
    [self.view addSubview:_levelLabel];
    [self.view addSubview:_scoreLabel];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userTap:)];
    [_myBoardView addGestureRecognizer:tap];

    
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _myBoardView.userInteractionEnabled = NO;
    _mySlider.enabled = NO;
    // if the game was not loaded with saved data, it should start a new game with level 1
    if( !loadedWithSavedData )
    {
        
        _level = 1;
        _score = 0;
        manager.levelNumber = _level;
        manager.score = _score;
        _lifes = INITIAL_LIFES;
        manager.lifes = _lifes;
        [engine resetWithSavedData:NO toLevel:_level];
        [_myBoardView updateBrickViews:[engine brickObjectsFrames]];
        
    }
    
    _scoreLabel.text = [NSString stringWithFormat:@"Score %li", (long)_score];
    _levelLabel.text = [NSString stringWithFormat:@"Level %li", (long)_level];
    _lifesLabel.text = [NSString stringWithFormat:@"Lifes %li", (long)_lifes];
    
    [_myPopupView displayWithLevel:_level];
    
    
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"gameOverSegue"])
    {
    GameOverVC *vc = segue.destinationViewController;
    vc.levelNumber = _level;
    vc.score = _score;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)sliderAction:(id) sender
{
    [_myBoardView movePlatformBy:((UISlider*)sender).value];
}


-(void)userTap:(UITapGestureRecognizer*) recognizer
{
    if(recognizer.state == UIGestureRecognizerStateRecognized)
    {

        CGPoint tappedPoint = [recognizer locationInView:recognizer.view];
        _myBoardView.userInteractionEnabled = NO;
        [engine calculateBallInitialDirection:tappedPoint];
        [engine start];
        [_myBoardView animateShooting];
        [[SoundManager sharedManager] playSound:BallDidShoot];
        _mySlider.enabled = YES;
        _myBoardView.userInteractionEnabled = NO;
    }
}

-(void)gameEnteredForeground
{

    
    if( ![manager empty])
    {

        _level = manager.levelNumber;
        _lifes = manager.lifes;
        _score = manager.score;
        [_myPopupView displayWithLevel:_level];
        [engine resetWithSavedData:YES toLevel:0];
        loadedWithSavedData = YES;
    }

}
-(void)gameEnteredBackground
{
    [_myBoardView moveBallAndPlatformInitialPosition];
    [engine pause];
    [manager save];
}

// used to resize the image to fit in the frame
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - Popup Delegate Methods
-(void)startButtonPressed
{
    _myBoardView.userInteractionEnabled = YES;
}


#pragma mark - Engine Delegate Methods


-(void)ballDidCollideWith:(Collision)item
{
    [[SoundManager sharedManager] playSound:item];
}

// returns to the Engine the current position of the platform
-(CGPoint)platformPosition
{
    
    return [_myBoardView platformPosition];
}

// redraws the ball to a new position
-(void)moveBallToCenter:(CGPoint)aNewCenter
{
    [_myBoardView moveBallToCenter:aNewCenter];
}

// tells the boardview to recolor the bricks
-(void)redrawCollidedBricks:(NSMutableArray *)collidedBricks
{
    [_myBoardView redrawBricks:collidedBricks];
}

// updates the score by the number of destroyed bricks
-(void)updateScoreBy:(NSInteger)destroyedBricksNumber
{
    _score += destroyedBricksNumber;
    manager.score =  _score;
    _scoreLabel.text = [NSString stringWithFormat:@"Score %li", (long)_score];
}

// implements game over condition
-(void)gameOver
{
    // stops the engine
    [engine pause];
    
    [[SoundManager sharedManager] playSound:BallDidFall];
    
    //decrease lifes
    _lifes--;
    
    _mySlider.enabled = NO;
    
    _mySlider.value = (SLIDER_MAX_VAL + SLIDER_MIN_VAL)/2.0;
    
    manager.lifes = _lifes;
    
   _myBoardView.userInteractionEnabled = YES;
    [_myBoardView moveBallAndPlatformInitialPosition];
    
    
    // if there are still lifes left
    if ( _lifes > 0)
    {

        // update the life label text
        _lifesLabel.text = [NSString stringWithFormat:@"Lifes %li", (long)_lifes];
        // tell the boardview to put the ball and platform to their intitial positions
        
    }
    else
    {
        [manager reset];
        [self performSegueWithIdentifier:@"gameOverSegue" sender:self];
    }
    
}

// implements the new level condition
-(void)newLevel
{
    // stop engine from updating
    [engine pause];
    // update the level and level label
    _level++;
    manager.levelNumber = _level;
    _levelLabel.text = [NSString stringWithFormat:@"Level %li", (long)_level];
    // tell the board view to put the ball and platform to initial positions
    [_myBoardView moveBallAndPlatformInitialPosition];
    // update the slider value
    _mySlider.value = (SLIDER_MAX_VAL + SLIDER_MIN_VAL)/2.0;
    // disable the slider and the board
    _mySlider.enabled = NO;
    _myBoardView.userInteractionEnabled = NO;
    [_myPopupView displayWithLevel:_level];
    // tell the engine to get the next level bricks
    [engine resetWithSavedData:NO toLevel:_level];
    // tell the board view to update the brick views
    [_myBoardView updateBrickViews:[engine brickObjectsFrames]];
    
    
}
@end
