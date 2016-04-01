//
//  TableView.m
//  FakeClear
//
//  Created by WongEric on 16/3/31.
//  Copyright © 2016年 WongEric. All rights reserved.
//

#import "TableView.h"
#import "TableViewCell.h"

@implementation TableView {
    UIScrollView *_scrollView;
    NSMutableSet *_reuseCells;
    Class _cellClass;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        _reuseCells = [[NSMutableSet alloc] init];
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectNull];
        [self addSubview:_scrollView];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.delegate = self;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)layoutSubviews {
    //[super layoutSubviews];
    _scrollView.frame = self.frame;
    [self refreshView];
}



- (void)refreshView {
    if (CGRectIsNull(_scrollView.frame)) {
        return;
    }
    
    _scrollView.contentSize = CGSizeMake(_scrollView.bounds.size.width, [_dataSource numberOfRows] * SHC_ROW_HEIGHT);
    for (UIView *cell in [self cellSubviews]) {
        if (cell.frame.origin.y + cell.frame.size.height < _scrollView.contentOffset.y) {
            [self recycleCell:cell];
        }
        
        if (cell.frame.origin.y > _scrollView.contentOffset.y + _scrollView.frame.size.height) {
            [self recycleCell:cell];
        }
    }
    int firstVisbleIndex = MAX(0, floor(_scrollView.contentOffset.y / SHC_ROW_HEIGHT));
    int lastVisibleIndex = MIN([_dataSource numberOfRows], firstVisbleIndex
                               + 1 + ceil(_scrollView.frame.size.height / SHC_ROW_HEIGHT));
    for (int row = firstVisbleIndex; row < lastVisibleIndex; row++) {
        UIView *cell = [self cellForRow:row];
        if (!cell) {
            UIView *cell = [_dataSource cellForRow:row];
            float topEdgeForRow = row * SHC_ROW_HEIGHT;
            cell.frame = CGRectMake(0, topEdgeForRow, _scrollView.frame.size.width, SHC_ROW_HEIGHT);
            [_scrollView insertSubview:cell atIndex:0];
        }
    }
}

- (void)recycleCell:(UIView *)cell {
    [_reuseCells addObject:cell];
    [cell removeFromSuperview];
}

- (UIView *)cellForRow:(NSInteger)row {
    float topEdgeForRow = row * SHC_ROW_HEIGHT;
    for (UIView *cell in [self cellSubviews]) {
        if (cell.frame.origin.y == topEdgeForRow) {
            return cell;
        }
    }
    return nil;
}

- (NSArray *)cellSubviews {
    NSMutableArray *cells = [[NSMutableArray alloc] init];
    for (UIView *subView in _scrollView.subviews) {
        if ([subView isKindOfClass:[TableViewCell class]]) {
            [cells addObject:subView];
        }
    }
    return cells;
}

- (void)registerClassForCells:(Class)cellClass {
    _cellClass = cellClass;
}

- (UIView *)dequeueReusableCell {
    UIView *cell = [_reuseCells anyObject];
    if (cell) {
        [_reuseCells removeObject:cell];
    }
    if (!cell) {
        cell = [[_cellClass alloc] init];
    }
    return cell;
}

- (NSArray *)visibleCells {
    NSMutableArray *cells = [[NSMutableArray alloc] init];
    for (UIView *subView in [self cellSubviews]) {
        [cells addObject:subView];
    }
    NSArray *sortedCells = [cells sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        UIView *view1 = (UIView *)obj1;
        UIView *view2 = (UIView *)obj2;
        float result = view2.frame.origin.y - view1.frame.origin.y;
        if (result > 0.0) {
            return NSOrderedAscending;
        } else if (result < 0.0) {
            return NSOrderedDescending;
        } else {
            return NSOrderedSame;
        }
    }];
    return sortedCells;
}

- (void)reloadData {
    [[self cellSubviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self refreshView];
}

- (void)setDataSource:(id<TableViewDataSource>)dataSource {
    _dataSource = dataSource;
    [self refreshView];
    
}

-(UIScrollView *)scrollView {
    return _scrollView;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self refreshView];
    
    if ([self.delegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [self.delegate scrollViewDidScroll:scrollView];
    }
}

#pragma mark - UIScrollViewDelegate forwarding

- (BOOL)respondsToSelector:(SEL)aSelector {
    if ([self.delegate respondsToSelector:aSelector]) {
        return YES;
    }
    return [super respondsToSelector:aSelector];
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    if ([self.delegate respondsToSelector:aSelector]) {
        return self.delegate;
    }
    return [super forwardingTargetForSelector:aSelector];
}



@end
