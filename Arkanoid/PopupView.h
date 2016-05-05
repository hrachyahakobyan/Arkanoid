//
//  PopupView.h
//  Arkanoid
//
//  Created by Admin on 09.03.15.
//  Copyright (c) 2015 Hrach. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PopupDelegate <NSObject>

-(void)startButtonPressed;

@end



@interface PopupView : UIView

-(instancetype)initWithFrame:(CGRect)frame;
// called by ViewController
-(void)displayWithLevel:(NSInteger) level;
// delegate to inform ViewController about start being pressed
@property (weak) id <PopupDelegate> delegate;


@end
