//
//  ToDoItem.h
//  FakeClear
//
//  Created by WongEric on 16/3/31.
//  Copyright © 2016年 WongEric. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ToDoItem : NSObject

@property (nonatomic, copy) NSString *text;

@property (nonatomic, assign) BOOL completed;

- (instancetype)initWithText:(NSString *)text;
+ (instancetype)toDoItemWithText:(NSString *)text;


@end
