//
//  StrikethroughLabel.m
//  FakeClear
//
//  Created by WongEric on 16/3/31.
//  Copyright © 2016年 WongEric. All rights reserved.
//

#import "StrikethroughLabel.h"
#import <QuartzCore/QuartzCore.h>

@implementation StrikethroughLabel {
    CALayer *_strikethroughlayer;
}

const float STRIKEOUT_THICKNESS = 2.0f;

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _strikethroughlayer = [CALayer layer];
        _strikethroughlayer.backgroundColor = [UIColor whiteColor].CGColor;
        _strikethroughlayer.hidden = YES;
        [self.layer addSublayer:_strikethroughlayer];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self resizeStrikeThrough];
}

- (void)setText:(NSString *)text {
    [super setText:text];
    [self resizeStrikeThrough];
}


- (void)resizeStrikeThrough {
    NSDictionary *textAttr = @{NSFontAttributeName : self.font};
    CGSize textSize = [self.text sizeWithAttributes:textAttr];
    _strikethroughlayer.frame = CGRectMake(0, self.bounds.size.height / 2, textSize.width, STRIKEOUT_THICKNESS);
}

#pragma mark - property setter

- (void)setStrikethrough:(BOOL)strikethrough {
    _strikethrough = strikethrough;
    _strikethroughlayer.hidden = !strikethrough;
}

@end
