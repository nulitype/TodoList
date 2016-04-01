//
//  TableViewPinchToAdd.m
//  FakeClear
//
//  Created by WongEric on 16/3/31.
//  Copyright © 2016年 WongEric. All rights reserved.
//

#import "TableViewPinchToAdd.h"
#import "TableView.h"
#import "TableViewCell.h"
#import "StrikethroughLabel.h"

struct TouchPoints {
    CGPoint upper;
    CGPoint lower;
};
typedef struct TouchPoints TouchPoints;

@implementation TableViewPinchToAdd {
    TableView *_tableView;
    TableViewCell *_placeholderCell;
    int _pointOneCellindex;
    int _pointTwoCellindex;
    
    TouchPoints _initialTouchPoints;
    
    BOOL _pinchInProgress;
    BOOL _pinchExceededRequiredDistance;
    
}



- (instancetype)initWithTableView:(TableView *)tableView {
    if (self = [super init]) {
        _placeholderCell = [[TableViewCell alloc] init];
        _placeholderCell.backgroundColor = [UIColor redColor];
        _tableView = tableView;
        
        UIGestureRecognizer *recognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
        [_tableView addGestureRecognizer:recognizer];
    }
    return self;
}

- (void)handlePinch:(UIPinchGestureRecognizer *)recognizer {
    //TO do
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        [self pinchStarted:recognizer];
    }
    if (recognizer.state == UIGestureRecognizerStateChanged && _pinchInProgress && recognizer.numberOfTouches == 2) {
        [self pinchChanged:recognizer];
    }
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        [self pinchEnded:recognizer];
    }
}

- (void)pinchStarted:(UIPinchGestureRecognizer *)recognizer {
    // Todo
    _initialTouchPoints = [self getNormalisedTouchPoints:recognizer];
    
    _pointOneCellindex = -100;
    _pointTwoCellindex = -100;
    NSArray *visibleCells = _tableView.visibleCells;
    for (int i = 0; i < visibleCells.count; i++) {
        UIView *cell = (UIView *)visibleCells[i];
        if ([self viewContainsPoint:cell withPoint:_initialTouchPoints.upper]) {
            _pointOneCellindex = i;
            cell.backgroundColor = [UIColor purpleColor];
        }
        if ([self viewContainsPoint:cell withPoint:_initialTouchPoints.lower]) {
            _pointTwoCellindex = i;
            cell.backgroundColor = [UIColor purpleColor];
        }
    }
    if (abs(_pointOneCellindex - _pointTwoCellindex) == 1) {
        _pinchInProgress = YES;
        _pinchExceededRequiredDistance = NO;
        
        TableView *precedingCell = (TableView *)(_tableView.visibleCells)[_pointOneCellindex];
        _placeholderCell.frame = CGRectOffset(precedingCell.frame, 0.0f, SHC_ROW_HEIGHT / 2.0f);
        [_tableView.scrollView insertSubview:_placeholderCell atIndex:0];
    }
    
    
}

- (void)pinchChanged:(UIPinchGestureRecognizer *)recognizer {
    TouchPoints currentTouchPoints = [self getNormalisedTouchPoints:recognizer];
    
    float upperDelta = currentTouchPoints.upper.y - _initialTouchPoints.upper.y;
    float lowerDelta = currentTouchPoints.lower.y - currentTouchPoints.lower.y;
    float delta = -MIN(0, MIN(upperDelta, lowerDelta));
    
    NSArray *visibleCells = _tableView.visibleCells;
    for (int i = 0; i <visibleCells.count; i++) {
        UIView *cell = (UIView *)visibleCells[i];
        if (i <= _pointOneCellindex) {
            cell.transform = CGAffineTransformMakeTranslation(0, -delta);
        }
        if (i >= _pointTwoCellindex) {
            cell.transform = CGAffineTransformMakeTranslation(0, delta);
        }
    }
    float gapSize = delta * 2;
    float cappedGapSize = MIN(gapSize, SHC_ROW_HEIGHT);
    _placeholderCell.transform = CGAffineTransformMakeScale(1.0f, cappedGapSize / SHC_ROW_HEIGHT);
    _placeholderCell.label.text = gapSize > SHC_ROW_HEIGHT ? @"Release to Add Item" : @"Pull to Add Item";
    _placeholderCell.alpha = MIN(1.0f, gapSize / SHC_ROW_HEIGHT);
    _pinchExceededRequiredDistance = gapSize > SHC_ROW_HEIGHT;
}

- (void)pinchEnded:(UIPinchGestureRecognizer *)recognizer {
    _pinchInProgress = false;
    
    _placeholderCell.transform = CGAffineTransformIdentity;
    [_placeholderCell removeFromSuperview];
    
    if (_pinchExceededRequiredDistance) {
        int indexOffset = floor(_tableView.scrollView.contentOffset.y / SHC_ROW_HEIGHT);
        [_tableView.dataSource itemAddedAtIndex:_pointTwoCellindex + indexOffset];
    } else {
        [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            NSArray *visibleCells = _tableView.visibleCells;
            for (TableViewCell *cell in visibleCells) {
                cell.transform = CGAffineTransformIdentity;
            }
        } completion:nil];
    }
}

-(TouchPoints)getNormalisedTouchPoints: (UIGestureRecognizer*) recognizer {
    CGPoint pointOne = [recognizer locationOfTouch:0 inView:_tableView];
    CGPoint pointTwo = [recognizer locationOfTouch:1 inView:_tableView];
    // offset based on scroll
    pointOne.y += _tableView.scrollView.contentOffset.y;
    pointTwo.y += _tableView.scrollView.contentOffset.y;
    // ensure pointOne is the top-most
    if (pointOne.y > pointTwo.y) {
        CGPoint temp = pointOne;
        pointOne = pointTwo;
        pointTwo = temp;
    }
    TouchPoints points = {pointOne, pointTwo};
    return points;
}

- (BOOL)viewContainsPoint:(UIView *)view withPoint:(CGPoint)point {
    CGRect frame = view.frame;
    return (frame.origin.y < point.y) && (frame.origin.y + frame.size.height) > point.y;
}

@end
