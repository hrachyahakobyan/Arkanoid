//
//  InstructionsVC.m
//  Arkanoid
//
//  Created by Admin on 11.03.15.
//  Copyright (c) 2015 Hrach. All rights reserved.
//

#import "InstructionsVC.h"

@interface InstructionsVC ()

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIImageView *platformImageView;
@property (weak, nonatomic) IBOutlet UIImageView *bricksImageView;
@property (weak, nonatomic) IBOutlet UITextView *firstTextView;
@property (weak, nonatomic) IBOutlet UITextView *secondTextView;

@end

@implementation InstructionsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage* backImage = [self imageWithImage:[UIImage imageNamed:@"back5"] scaledToSize:self.view.frame.size];
    self.view.backgroundColor = [UIColor colorWithPatternImage:backImage];
    
    UIImage* platformImage = [self imageWithImage:[UIImage imageNamed:@"platformImage"] scaledToSize: _platformImageView.frame.size];
    
    UIImage* bricksImage = [self imageWithImage:[UIImage imageNamed:@"bricksImage"] scaledToSize:_bricksImageView.frame.size];
    _platformImageView.layer.borderColor = [UIColor blueColor].CGColor;
    _platformImageView.layer.borderWidth = 2.0f;
    
    _bricksImageView.layer.borderColor = [UIColor blueColor].CGColor;
    _bricksImageView.layer.borderWidth = 2.0f;
    
    [_platformImageView setImage:platformImage];
    [_bricksImageView setImage:bricksImage];
    
    _firstTextView.backgroundColor = [UIColor clearColor];
    _secondTextView.backgroundColor = [UIColor clearColor];

    _firstTextView.layer.borderColor = [UIColor blueColor].CGColor;
    _firstTextView.layer.borderWidth = 2.0f;
    
    _secondTextView.layer.borderColor = [UIColor blueColor].CGColor;
    _secondTextView.layer.borderWidth = 2.0f;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backAction:(id)sender
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
