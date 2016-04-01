//
//  TableViewCell.h
//  FakeClear
//
//  Created by WongEric on 16/3/31.
//  Copyright © 2016年 WongEric. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewCellDelegate.h"

@class ToDoItem, StrikethroughLabel;

@interface TableViewCell : UITableViewCell 

@property (nonatomic, strong) ToDoItem *todoItem;

@property (nonatomic, weak) id<TableViewCellDelegate> delegate;

@property (nonatomic, strong,readonly) StrikethroughLabel *label;

@end
