//
//  TableCellObject.h
//  Arkanoid
//
//  Created by Admin on 11.03.15.
//  Copyright (c) 2015 Hrach. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TableCellObject : NSObject
// contains the data which is used to construct TableView cells
-(instancetype)initWithName:(NSString*) name score:(NSInteger) score level:(NSInteger) level;
@property NSString* name;
@property NSString* level;
@property NSString* score;


@end
