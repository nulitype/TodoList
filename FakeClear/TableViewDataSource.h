//
//  TableViewDataSource.h
//  FakeClear
//
//  Created by WongEric on 16/3/31.
//  Copyright © 2016年 WongEric. All rights reserved.
//



@protocol TableViewDataSource <NSObject>

- (NSInteger)numberOfRows;

- (UITableViewCell *)cellForRow:(NSInteger)row;

- (void)itemAdded;

- (void)itemAddedAtIndex:(NSInteger)index;

@end
