//
//  ViewController.h
//  FakeClear
//
//  Created by WongEric on 16/3/31.
//  Copyright © 2016年 WongEric. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableView.h"
#import "TableViewCellDelegate.h"

@class TableViewDragAddNew;

@interface ViewController : UIViewController <TableViewCellDelegate, TableViewDataSource>

@property (weak, nonatomic) IBOutlet TableView *tableView;


@end

