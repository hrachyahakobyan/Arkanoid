//
//  SoundManager.h
//  Arkanoid
//
//  Created by Admin on 12.03.15.
//  Copyright (c) 2015 Hrach. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Config.h"

@interface SoundManager : NSObject

+(SoundManager*)sharedManager;
-(void)playSound:(Collision) item;
@end
