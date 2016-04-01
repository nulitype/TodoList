//
//  TableViewDragAddNew.m
//  FakeClear
//
//  Created by WongEric on 16/3/31.
//  Copyright © 2016年 WongEric. All rights reserved.
//

#import "TableViewDragAddNew.h"
#import "TableViewCell.h"
#import "StrikethroughLabel.h"
#import "TableView.h"

@implementation TableViewDragAddNew {
    TableViewCell *_placeholderCell;
    BOOL _pullDownInProgress;
    TableView *_tableView;
}

- (instancetype)initWithTableView:(TableView *)tableView {
    if (self = [super init]) {
        _placeholderCell = [[TableViewCell alloc] init];
        _placeholderCell.backgroundColor = [UIColor redColor];
        _tableView = tableView;
        _tableView.delegate = self;
    }
    return self;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _pullDownInProgress = scrollView.contentOffset.y <= 0.0f;
    if (_pullDownInProgress) {
        [_tableView insertSubview:_placeholderCell atIndex:0];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //[super scrollViewDidScroll:scrollView];
    
    if (_pullDownInProgress && _tableView.scrollView.contentOffset.y <= 0.0f) {
        _placeholderCell.frame = CGRectMake(0, -_tableView.scrollView.contentOffset.y - SHC_ROW_HEIGHT, _tableView.frame.size.width, SHC_ROW_HEIGHT);
        _placeholderCell.label.text = -_tableView.scrollView.contentOffset.y / SHC_ROW_HEIGHT ? @"Release to Add Item" : @"Pull to Add Item";
        _placeholderCell.alpha = MIN(1.0f, -_tableView.scrollView.contentOffset.y / SHC_ROW_HEIGHT);
    } else {
        _pullDownInProgress = false;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (_pullDownInProgress && -_tableView.scrollView.contentOffset.y > SHC_ROW_HEIGHT) {
        //To do
        [_tableView.dataSource itemAdded];
    }
    _pullDownInProgress = false;
    [_placeholderCell removeFromSuperview];
}

@end
