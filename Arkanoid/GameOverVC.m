//
//  GameOverVC.m
//  Arkanoid
//
//  Created by Admin on 10.03.15.
//  Copyright (c) 2015 Hrach. All rights reserved.
//

#import "GameOverVC.h"



@interface GameOverVC ()
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UIButton *hallOfFameButton;
@property (weak, nonatomic) IBOutlet UIButton *startNewGameButton;

@end

@implementation GameOverVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage* backImage = [self imageWithImage:[UIImage imageNamed:@"back5"] scaledToSize:self.view.frame.size];
    self.view.backgroundColor = [UIColor colorWithPatternImage:backImage];
    
    _levelLabel.backgroundColor = [UIColor clearColor];
    _scoreLabel.backgroundColor = [UIColor clearColor];
    
    _usernameTextField.delegate = self;
    // Do any additional setup after loading the view.
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _levelLabel.text = [NSString stringWithFormat:@"%li", (long)_levelNumber];
    _scoreLabel.text = [NSString stringWithFormat:@"%li", (long)_score];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// closes the keyboard
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
// pops to root view controller to start a new game, updates the hall of fame
- (IBAction)newGameAction:(id)sender
{
    [self updateHallOfFame];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

// updates the hall of fame before performing a segue to hall of fame
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"hallOfFameSegue"] )
    {
        HallOfFameVC* vc = ((HallOfFameVC*)(segue.destinationViewController));
        vc.delegate = self;
        [self updateHallOfFame];
    }
}

// sends new user information to Hall of Fame manager
-(void)updateHallOfFame
{
    if ( ![_usernameTextField.text isEqualToString:@""] )
    {
        NSNumber* scoreNumber = [[NSNumber alloc] initWithInteger:_score];
        NSNumber* levelNumber = [[NSNumber alloc] initWithInteger:_levelNumber];
        NSLog(@"hall of fame is updating");
        [[HallOfFameManager sharedManager] newElementUsername:_usernameTextField.text score:scoreNumber level:levelNumber];
    }
}

// delegate method of Hall Of Fame. Dismisses modal view and pops to root controller
-(void)hallOfFameDidCancel:(HallOfFameVC *)vc
{
    [self dismissViewControllerAnimated:NO completion:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
