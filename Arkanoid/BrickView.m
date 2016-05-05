//
//  BrickView.m
//  Arkanoid
//
//  Created by Admin on 11.03.15.
//  Copyright (c) 2015 Hrach. All rights reserved.
//

#import "BrickView.h"
#import "Config.h"

@implementation BrickView


-(instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image
{
    self = [super initWithFrame:frame];
    if(self)
    {
        // if there is no image, then the brick should be hidden
        if(!image)
            self.alpha = 0.0;
        else
            [self changeImage:image];
        self.layer.borderColor = [UIColor blackColor].CGColor;
        // do additional customization here
    }
    return self;
}

// change the image
-(void)changeImage:(UIImage *)newImage
{
    UIImage* backImage = [self imageWithImage:newImage scaledToSize:self.frame.size];
    self.backgroundColor = [UIColor colorWithPatternImage:backImage];
    
    // does a rotation animation
    [self animateSpinOnView:self duration:ROTATION_ANIM_DURATION rotations:ROTATION_ANIM_ROTATIONS repeat:ROTATION_ANIM_REPEAT];
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

// explosion animation
// uses CAAnimation to animate explosion cloud
-(void)explode:(NSMutableArray *)explosionImages
{

        CAKeyframeAnimation *keyframeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
        keyframeAnimation.values = explosionImages;
        
        keyframeAnimation.repeatCount = EXPL_ANIM_REPEAT_COUNT;
        keyframeAnimation.duration = EXPL_ANIM_DURATION;
        
        keyframeAnimation.delegate = self;
        
        //    keyframeAnimation.removedOnCompletion = YES;
        keyframeAnimation.removedOnCompletion = NO;
        keyframeAnimation.fillMode = kCAFillModeForwards;
        
        CALayer *layer = self.layer;
        
        [layer addAnimation:keyframeAnimation
                     forKey:@"explosionAnimation"];
}

// does a rotation animation on the bric view
- (void)animateSpinOnView:(UIView*)view duration:(CGFloat)duration rotations:(CGFloat)rotations repeat:(float)repeat;
{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 /* full rotation*/ * rotations * duration ];
    rotationAnimation.duration = duration;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = repeat;
    [rotationAnimation setValue:@"rotation" forKey:@"id"];
    [view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

#pragma mark - CAAnimationDelegate
    
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
        if (flag)
        {
            self.alpha = 0.0;
            [self.layer removeAnimationForKey:@"explosionAnimation"];
        }
}


@end
