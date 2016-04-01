//
//  ToDoItem.m
//  FakeClear
//
//  Created by WongEric on 16/3/31.
//  Copyright © 2016年 WongEric. All rights reserved.
//

#import "ToDoItem.h"

@implementation ToDoItem

-(instancetype)initWithText:(NSString*)text {
    if (self = [super init]) {
        self.text = text;
    }
    return self;
}

+(instancetype)toDoItemWithText:(NSString *)text {
    return [[ToDoItem alloc] initWithText:text];
}


@end
