//
//  MainMenuVC.m
//  Arkanoid
//
//  Created by Admin on 11.03.15.
//  Copyright (c) 2015 Hrach. All rights reserved.
//

#import "MainMenuVC.h"

@interface MainMenuVC ()

@end

@implementation MainMenuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage* backImage = [self imageWithImage:[UIImage imageNamed: @"back5"] scaledToSize:self.view.frame.size];
    self.view.backgroundColor = [UIColor colorWithPatternImage:backImage];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// delegate method of Hall Of Fame VC. Dismisses the modal view.
-(void)hallOfFameDidCancel:(HallOfFameVC *)vc
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

   if([segue.identifier isEqualToString:@"hallOfFameSegue"])
   {

       HallOfFameVC* vc = ((HallOfFameVC*)(segue.destinationViewController));
       vc.delegate = self;
   }
}


@end
