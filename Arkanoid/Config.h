//
//  Config.h
//  Arkanoid
//
//  Created by Admin on 24.02.15.
//  Copyright (c) 2015 Hrach. All rights reserved.
//

#ifndef Arkanoid_Config_h
#define Arkanoid_Config_h


#define BALL_INITIIAL_VECTOR_MAGNITUDE 3 // recommended for ipad mini 6, for iphone5 3, ipad2 5, iphone6 3
#define RANDOM_ANGLE 179
#define BALL_MAX_SPEED_INCREASE_MULTIPLIER 0.2 /* the ball's speed is at most increased by 0.2 times the initial speed */
#define BALL_TOP_SPEED_COEFF 2.0 /* the ball's top speed is at most twice the initial speed */
#define MAXIMUM_ANGLE_FROM_PLATFORM 70.0 /* the maximum angle the ball's direction will be changed to when the ball hits the corner of the platform */

#define FPS 50 /* How many times Engine's update is called per second */

/* Main Board Customization constants */
#define PLAT_DIST_BOARD_RATIO 19/20 /* how far is the platform from the board's bottom edge */
#define BOARD_WIDTH_TO_SCREEN_RATIO 1.0 /* board's width/height ratio to the application's screen */
#define LABEL_FONT_SIZE 40
#define BOARD_HEIGHT_TO_SCREEN_RATIO 0.9
#define PLATFORM_WIDTH_TO_BOARD_RATIO 0.5   /* platform's width to board's width ratio */
#define PLATFORM_HEIGHT_TO_WIDTH_RATIO 1/30
#define BRICK_HEIGHT_TO_WIDTH_RATIO 0.5
#define BALL_SIZE_TO_PLATFORM_RATIO 0.065
#define POPUP_WIDTH_TO_BOARD_RATIO 1/3
#define POPUP_HEIGHT_TO_BOARD_RATIO 1/4
#define GAMEOVERLINE_TO_BOARD_HEIGHT_RATIO 0.1 /* the point at which a game over condition takes place */

#define INITIAL_LIFES 1
#define HALLOFFAME_LENGTH 10 /* how many names can the hall of fame hold */
#define SLIDER_MIN_VAL 0.0
#define SLIDER_MAX_VAL 1.0

// animation constants
#define NUMBER_OF_EXPL_IMAGES 16
#define NUMBER_OF_ANIM_IMAGES 23
#define EXPL_ANIM_DURATION 0.3
#define EXPL_ANIM_REPEAT_COUNT 1.0f
#define LIGHTNING_ANIM_DURATION 0.8
#define LIGHTNING_ANIM_REPEAT_COUNT 1.0f
#define TILT_ANIM_REPEAT 5.0f
#define TILT_ANIM_DURATION 0.07f
#define TILT_ANIM_LENGTH 5.0f
#define LIGHTNING_ANIM_SIZE_BOARD_RATIO 0.15
#define ROTATION_ANIM_DURATION 0.1
#define ROTATION_ANIM_REPEAT 10
#define ROTATION_ANIM_ROTATIONS 1.0
#endif

typedef NS_ENUM(NSUInteger, Collision) {
    Border,
    Platform,
    BrickTouch,
    BrickExplode,
    BallDidFall,
    BallDidShoot,
};