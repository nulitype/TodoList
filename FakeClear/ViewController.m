//
//  ViewController.m
//  FakeClear
//
//  Created by WongEric on 16/3/31.
//  Copyright © 2016年 WongEric. All rights reserved.
//

#import "ViewController.h"
#import "ToDoItem.h"
#import "TableViewCell.h"
#import "TableViewDragAddNew.h"
#import "StrikethroughLabel.h"
#import "TableViewPinchToAdd.h"


@interface ViewController ()

@property (nonatomic, strong) NSMutableArray *toDoItems;

@end

@implementation ViewController {
    float _editingOffset;
    TableViewDragAddNew *_dragAddNew;
    TableViewPinchToAdd *_pinchAddNew;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClassForCells:[TableViewCell class]];
    //[self.tableView registerClassForCells:[TableViewCell class]];
    //self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor blackColor];
    
    _dragAddNew = [[TableViewDragAddNew alloc] initWithTableView:self.tableView];
    _pinchAddNew = [[TableViewPinchToAdd alloc] initWithTableView:self.tableView];
    
    //self.tableView.rowHeight = 50;
    if (self.toDoItems.count > 0) {
        return;
    }
    self.toDoItems = [[NSMutableArray alloc] init];
    [self.toDoItems addObject:[ToDoItem toDoItemWithText:@"Feed the cat"]];
    [self.toDoItems addObject:[ToDoItem toDoItemWithText:@"Buy eggs"]];
    [self.toDoItems addObject:[ToDoItem toDoItemWithText:@"Pack bags for WWDC"]];
    [self.toDoItems addObject:[ToDoItem toDoItemWithText:@"Rule the web"]];
    [self.toDoItems addObject:[ToDoItem toDoItemWithText:@"Buy a new iPhone"]];
    [self.toDoItems addObject:[ToDoItem toDoItemWithText:@"Find missing socks"]];
    [self.toDoItems addObject:[ToDoItem toDoItemWithText:@"Write a new tutorial"]];
    [self.toDoItems addObject:[ToDoItem toDoItemWithText:@"Master Objective-C"]];
    [self.toDoItems addObject:[ToDoItem toDoItemWithText:@"Remember your wedding anniversary!"]];
    [self.toDoItems addObject:[ToDoItem toDoItemWithText:@"Drink less beer"]];
    [self.toDoItems addObject:[ToDoItem toDoItemWithText:@"Learn to draw"]];
    [self.toDoItems addObject:[ToDoItem toDoItemWithText:@"Take the car to the garage"]];
    [self.toDoItems addObject:[ToDoItem toDoItemWithText:@"Sell things on eBay"]];
    [self.toDoItems addObject:[ToDoItem toDoItemWithText:@"Learn to juggle"]];
    [self.toDoItems addObject:[ToDoItem toDoItemWithText:@"Give up"]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIColor *)colorForIndex:(NSInteger)index {
    NSUInteger itemCount = _toDoItems.count - 1;
    float val = ((float)index / (float)itemCount) * 0.6;
    return [UIColor colorWithRed:1.0 green:val blue:0.0 alpha:1.0];
}

#pragma mark - datasource

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return self.toDoItems.count;
//}
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 1;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    static NSString *id = @"cell";
//    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:id forIndexPath:indexPath];
//    ToDoItem *item = self.toDoItems[indexPath.row];
//    //cell.textLabel.text = item.text;
//    cell.textLabel.backgroundColor = [UIColor clearColor];
//    cell.delegate = self;
//    cell.todoItem = item;
//    return cell;
//}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [self colorForIndex:indexPath.row];
}

#pragma mark - TableViewDelegate

- (void)toDoItemDeleted:(ToDoItem *)todoItem {
//    NSUInteger index = [_toDoItems indexOfObject:todoItem];
//    [self.tableView beginUpdates];
//    [_toDoItems removeObject:todoItem];
//    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
//    [self.tableView endUpdates];
    
    float delay = 0.0;
    
    [_toDoItems removeObject:todoItem];
    
    NSArray *visibleCells = [self.tableView visibleCells];
    
    UIView *lastView = [visibleCells lastObject];
    BOOL startAnimating = false;
    
    for (TableViewCell *cell in visibleCells) {
        if (startAnimating) {
            [UIView animateWithDuration:0.3 delay:delay options:UIViewAnimationOptionCurveEaseInOut animations:^{
                cell.frame = CGRectOffset(cell.frame, 0.0f, -cell.frame.size.height);
            } completion:^(BOOL finished) {
                if (cell == lastView) {
                    [self.tableView reloadData];
                }
            }];
            delay += 0.03;
        }
        
        if (cell.todoItem == todoItem) {
            startAnimating = true;
            cell.hidden = YES;
        }
    }
    
}

#pragma mark - TableView DataSource methods

- (NSInteger)numberOfRows {
    return _toDoItems.count;
}

- (UITableViewCell *)cellForRow:(NSInteger)row {
    //static NSString *id = @"cell";
    //TableViewCell *cell = [[TableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:id];
    TableViewCell *cell = (TableViewCell *)[self.tableView dequeueReusableCell];
    ToDoItem *item = _toDoItems[row];
    cell.todoItem = item;
    cell.delegate = self;
    cell.backgroundColor = [self colorForIndex:row];
    return cell;
}

-(void)itemAdded {
    [self itemAddedAtIndex:0];
}

- (void)itemAddedAtIndex:(NSInteger)index {
    ToDoItem *toDoItem = [[ToDoItem alloc] init];
    [_toDoItems insertObject:toDoItem atIndex:index];
    
    [_tableView reloadData];
    
    TableViewCell *editCell;
    for (TableViewCell *cell in _tableView.visibleCells) {
        if (cell.todoItem == toDoItem) {
            editCell = cell;
            break;
        }
    }
    [editCell.label becomeFirstResponder];
}

#pragma mark - TableView Delegate

- (void)cellDidBeginEditing:(TableViewCell *)editingcell {
    _editingOffset = _tableView.scrollView.contentOffset.y - editingcell.frame.origin.y;
    for (TableViewCell *cell in [_tableView visibleCells]) {
        [UIView animateWithDuration:0.3 animations:^{
            cell.frame = CGRectOffset(cell.frame, 0, _editingOffset);
            if (cell != editingcell) {
                cell.alpha = 0.3;
            }
        }];
    }
}

- (void)cellDidEndEditing:(TableViewCell *)editingCell {
    for (TableViewCell *cell in [_tableView visibleCells]) {
        [UIView animateWithDuration:0.3 animations:^{
            cell.frame = CGRectOffset(cell.frame, 0, -_editingOffset);
            if (cell != editingCell) {
                cell.alpha = 1.0;
            }
        }];
    }
}

@end
