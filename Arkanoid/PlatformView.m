//
//  PlatformView.m
//  Arkanoid
//
//  Created by Admin on 11.03.15.
//  Copyright (c) 2015 Hrach. All rights reserved.
//

#import "PlatformView.h"

@implementation PlatformView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self)
    {
        // do additional customization here
        UIImage* image = [self imageWithImage:[UIImage imageNamed:@"platform"] scaledToSize:self.frame.size];
        self.backgroundColor = [UIColor colorWithPatternImage:image];
    }
    
    return self;
}

// returns the center of the platform
-(CGPoint)position
{
    return self.center;
}
// moves platform to a new center
-(void)moveToCenter:(CGPoint)aNewCenter
{
    self.center = aNewCenter;
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
