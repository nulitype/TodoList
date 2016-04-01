//
//  TableViewDelegate.h
//  FakeClear
//
//  Created by WongEric on 16/3/31.
//  Copyright © 2016年 WongEric. All rights reserved.
//

@class ToDoItem;
@class TableViewCell;

@protocol TableViewCellDelegate <NSObject>

- (void)toDoItemDeleted:(ToDoItem *)todoItem;

-(void)cellDidBeginEditing:(TableViewCell*)cell;

-(void)cellDidEndEditing:(TableViewCell*)cell;

@end
