//
//  BallView.m
//  Arkanoid
//
//  Created by Admin on 11.03.15.
//  Copyright (c) 2015 Hrach. All rights reserved.
//

#import "BallView.h"

@implementation BallView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if( self )
    {
        // round the corners
        self.layer.cornerRadius = self.frame.size.width/2;
        // do additional customization here
        UIImage* ballImage = [self imageWithImage:[UIImage imageNamed:@"ball"] scaledToSize:self.frame.size];
        [self setBackgroundColor:[UIColor colorWithPatternImage:ballImage]];
        
    }
    return self;
}

// moves the enter of the ball to new center
-(void)moveToCenter:(CGPoint)aNewCenter
{
    self.frame = CGRectMake(aNewCenter.x - self.frame.size.width/2, aNewCenter.y - self.frame.size.height/2, self.frame.size.width, self.frame.size.height);
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
@end
