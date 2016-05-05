//
//  PopupView.m
//  Arkanoid
//
//  Created by Admin on 09.03.15.
//  Copyright (c) 2015 Hrach. All rights reserved.
//

#import "PopupView.h"


@interface PopupView ()

@property UILabel* levelLabel;
@property UIButton* startButton;

@end

@implementation PopupView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if( self)
    {
        CGFloat labelWidth = self.frame.size.width;
        CGFloat labelHeight = self.frame.size.height/2.0;
        
        CGRect labelRect = CGRectMake(0, 0, labelWidth, labelHeight);
        CGRect buttonRect = CGRectMake(0, labelRect.size.height, labelWidth, labelHeight);
        
        _levelLabel = [[UILabel alloc]initWithFrame:labelRect];
        _startButton = [[UIButton alloc]initWithFrame:buttonRect];
        
        [_startButton addTarget:self
                     action:@selector(buttonAction:)
           forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_levelLabel];
        [self addSubview:_startButton];
        
        // customization
        
        UIImage* labelImage = [self imageWithImage:[UIImage imageNamed:@"mainLabel"] scaledToSize:_levelLabel.frame.size];
        UIImage* buttonImage = [self imageWithImage:[UIImage imageNamed:@"mainLabel"] scaledToSize:_startButton.frame.size];
        [_startButton setTitle:@"Start" forState:UIControlStateNormal];
        [_startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _startButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:36];
        _startButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        _startButton.titleLabel.textColor = [UIColor whiteColor];
        _startButton.titleLabel.textAlignment = NSTextAlignmentCenter;
      
        _levelLabel.backgroundColor = [UIColor colorWithPatternImage:labelImage];
        _startButton.backgroundColor = [UIColor colorWithPatternImage:buttonImage];
        _levelLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:36];
        _levelLabel.adjustsFontSizeToFitWidth = YES;
        _levelLabel.textAlignment = NSTextAlignmentCenter;
        _levelLabel.textColor = [UIColor whiteColor];
        
        self.backgroundColor = [UIColor clearColor];
        
        self.hidden = YES;
    }
    return self;
}

-(void)displayWithLevel:(NSInteger)level
{
    _levelLabel.text = [NSString stringWithFormat:@"Level %li", (long)level];
    self.hidden = NO;
}

-(void)buttonAction:(id)sender
{
    if ( (UIButton*)(sender) == _startButton)
    {
        self.hidden = YES;
        if ([_delegate respondsToSelector:@selector(startButtonPressed)])
            [_delegate startButtonPressed];
    }
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
