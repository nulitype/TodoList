//
//  TableViewCell.m
//  FakeClear
//
//  Created by WongEric on 16/3/31.
//  Copyright © 2016年 WongEric. All rights reserved.
//

#import "TableViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "StrikethroughLabel.h"
#import "ToDoItem.h"

@interface TableViewCell () <UITextFieldDelegate>



@end

@implementation TableViewCell {
    CAGradientLayer *_gradientLayer;
    CGPoint _originalCenter;
    BOOL _deleteOnDragRelease;
    StrikethroughLabel *_label;
    CALayer *_itemCompleteLayer;
    BOOL _markCompleteOnDragRelease;
    UILabel *_tickLabel;
    UILabel *_crossLabel;
    ToDoItem *_todoItem;
}

const float UI_CUES_MARGIN = 10.0f;
const float UI_CUES_WIDTH = 50.0f;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _tickLabel = [self createCueLabel];
        _tickLabel.text = @"\u2713";
        _tickLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_tickLabel];
        
        _crossLabel = [self createCueLabel];
        _crossLabel.text = @"\u2717";
        _crossLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_crossLabel];
        
        _label = [[StrikethroughLabel alloc] initWithFrame:CGRectNull];
        _label.textColor = [UIColor whiteColor];
        _label.font = [UIFont boldSystemFontOfSize:16];
        _label.backgroundColor = [UIColor clearColor];
        _label.delegate = self;
        _label.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [self addSubview:_label];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _itemCompleteLayer = [CALayer layer];
        _itemCompleteLayer.backgroundColor = [[UIColor alloc] initWithRed:0.0 green:0.6 blue:0.0 alpha:1.0].CGColor;
        _itemCompleteLayer.hidden = YES;
        [self.layer insertSublayer:_itemCompleteLayer atIndex:0];
        
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.frame = self.bounds;
        _gradientLayer.colors = @[(id)[[UIColor colorWithWhite:1.0f alpha:0.2f] CGColor],
                                  (id)[[UIColor colorWithWhite:1.0f alpha:0.1f] CGColor],
                                  (id)[[UIColor clearColor] CGColor],
                                  (id)[[UIColor colorWithWhite:0.0f alpha:0.1f] CGColor]];
        _gradientLayer.locations = @[@0.00f, @0.01f, @0.95f, @1.00f];
        [self.layer insertSublayer:_gradientLayer atIndex:0];
        
        UIGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        recognizer.delegate = self;
        [self addGestureRecognizer:recognizer];

    }
    return self;
}

-(UILabel*) createCueLabel {
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectNull];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:32.0];
    label.backgroundColor = [UIColor clearColor];
    return label;
}

const float LABEL_LEFT_MARGIN = 15.0;

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _gradientLayer.frame = self.bounds;
    _itemCompleteLayer.frame = self.bounds;
    _label.frame = CGRectMake(LABEL_LEFT_MARGIN, 0,
                              self.bounds.size.width - LABEL_LEFT_MARGIN,self.bounds.size.height);
    _tickLabel.frame = CGRectMake(-UI_CUES_WIDTH - UI_CUES_MARGIN, 0,
                                  UI_CUES_WIDTH, self.bounds.size.height);
    _crossLabel.frame = CGRectMake(self.bounds.size.width + UI_CUES_MARGIN, 0,
                                   UI_CUES_WIDTH, self.bounds.size.height);
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        _originalCenter = self.center;
        
    }
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [recognizer translationInView:self];
        self.center = CGPointMake(_originalCenter.x + translation.x, _originalCenter.y);
        _deleteOnDragRelease = self.frame.origin.x < -self.frame.size.width / 2;
        _markCompleteOnDragRelease = self.frame.origin.x > self.frame.size.width / 2;
        
        float cueAlpha = fabsf(self.frame.origin.x) / (self.frame.size.width / 2);
        _tickLabel.alpha = cueAlpha;
        _crossLabel.alpha = cueAlpha;
        
        _tickLabel.textColor = _markCompleteOnDragRelease ?
        [UIColor greenColor] : [UIColor whiteColor];
        _crossLabel.textColor = _deleteOnDragRelease ?
        [UIColor redColor] : [UIColor whiteColor];
    }
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        CGRect originalFrame = CGRectMake(0, self.frame.origin.y, self.bounds.size.width, self.bounds.size.height);
        if (!_deleteOnDragRelease) {
            [UIView animateWithDuration:0.2 animations:^{
                self.frame = originalFrame;
            }];
        }
        if (_deleteOnDragRelease) {
            [self.delegate toDoItemDeleted:self.todoItem];
        }
        if (_markCompleteOnDragRelease) {
            self.todoItem.completed = YES;
            _itemCompleteLayer.hidden = NO;
            _label.strikethrough = YES;
        }
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTodoItem:(ToDoItem *)todoItem {
    _todoItem = todoItem;
    _label.text = todoItem.text;
    _label.strikethrough = todoItem.completed;
    _itemCompleteLayer.hidden = !todoItem.completed;
    
}

-(ToDoItem*)todoItem
{
    return _todoItem;
}

- (StrikethroughLabel *)label {
    return _label;
}



#pragma mark - pan gesture methods

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    CGPoint translation = [gestureRecognizer translationInView:[self superview]];
    
    if (fabsf(translation.x) > fabsf(translation.y)) {
        return YES;
    }
    return NO;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return !self.todoItem.completed;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    self.todoItem.text = textField.text;
    [self.delegate cellDidEndEditing:self];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self.delegate cellDidBeginEditing:self];
}

@end
