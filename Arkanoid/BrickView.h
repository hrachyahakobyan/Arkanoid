//
//  BrickView.h
//  Arkanoid
//
//  Created by Admin on 11.03.15.
//  Copyright (c) 2015 Hrach. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BrickView : UIView

-(instancetype)initWithFrame:(CGRect)frame image:(UIImage*) image;

// changes the images of the view
-(void)changeImage:(UIImage*) newImage;

// animates an explosion and hides the view
-(void)explode:(NSMutableArray*) explosionImages;

@end
