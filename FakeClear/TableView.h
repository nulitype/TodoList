//
//  TableView.h
//  FakeClear
//
//  Created by WongEric on 16/3/31.
//  Copyright © 2016年 WongEric. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewDataSource.h"

#define SHC_ROW_HEIGHT 50.0f
@interface TableView : UIView <UIScrollViewDelegate>

@property (nonatomic, weak) id<TableViewDataSource> dataSource;

@property (nonatomic, assign, readonly) UIScrollView *scrollView;

@property (nonatomic, weak) id<UIScrollViewDelegate> delegate;

- (UIView *)dequeueReusableCell;

- (void)registerClassForCells:(Class)cellClass;

- (NSArray *)visibleCells;

- (void)reloadData;

@end
