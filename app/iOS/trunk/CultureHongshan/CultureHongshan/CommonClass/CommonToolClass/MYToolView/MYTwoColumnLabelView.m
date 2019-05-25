//
//  MYTwoColumnLabelView.m
//  WHYUIToolKit
//
//  Created by JackAndney on 2017/10/31.
//  Copyright © 2017年 Creatoo. All rights reserved.
//

#import "MYTwoColumnLabelView.h"

#define DEFALUT_TITLE_FONT [UIFont systemFontOfSize:16]

@interface MYTwoColumnLabelView ()
{
    NSLayoutConstraint *_leftWidthConstraint;
    NSLayoutConstraint *_spacingXConstraint;
}
@property (nonatomic, strong, readwrite) UILabel *leftLabel;
@property (nonatomic, strong, readwrite) UILabel *rightLabel;
@end

@implementation MYTwoColumnLabelView

- (instancetype)initWithFrame:(CGRect)frame leftTitle:(NSString *)leftTitle rightTitle:(NSString *)rightTitle font:(UIFont *)font tColor:(UIColor *)tColor {
    frame.size.height = 0;
    self = [super initWithFrame:frame];
    if (self) {
        _spacingX = 1;
        _lineSpacing = 0;
        
        self.leftLabel.text = leftTitle;
        self.rightLabel.text = rightTitle;
        
        if (font) {
            self.leftLabel.font = font;
            self.rightLabel.font = font;
        }
        if (tColor) {
            self.leftLabel.textColor = tColor;
            self.rightLabel.textColor = tColor;
        }
        [self reloadSubviews];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (CGRectEqualToRect(self.bounds, CGRectZero) == YES) return;
    
    if (self.translatesAutoresizingMaskIntoConstraints == YES) {
        [_rightLabel sizeToFit];
        CGRect frame = self.frame;
        frame.size.height = MAX(CGRectGetMaxY(_leftLabel.frame), CGRectGetMaxY(_rightLabel.frame));
        self.frame = frame;
    }
}

- (void)reloadSubviews {
    if (_leftWidthConstraint) {
        _leftWidthConstraint.constant = ceilf([_leftLabel.text sizeWithAttributes:@{NSFontAttributeName : _leftLabel.font}].width);
    }
    
    // 通过Frame约束
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)updateRightTitle:(NSString *)title {
    if (_lineSpacing > 0) {
        if (title == nil) title = @"";
        
        NSMutableParagraphStyle *paraStyle = [NSMutableParagraphStyle new];
        paraStyle.lineSpacing = _lineSpacing;
        UIFont *font = self.rightLabel.font ? self.rightLabel.font : DEFALUT_TITLE_FONT;
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName : font, NSParagraphStyleAttributeName : paraStyle}];
        self.rightLabel.attributedText = attributedString;
    }else {
        self.rightLabel.text = title;
    }
    
    if (self.translatesAutoresizingMaskIntoConstraints == YES) {
        [self setNeedsLayout];
        [self layoutIfNeeded];
    }
}


#pragma mark -

- (UILabel *)leftLabel {
    if (_leftLabel == nil) {
        _leftLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _leftLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _leftLabel.font = DEFALUT_TITLE_FONT;
        _leftLabel.textColor = [UIColor darkTextColor];
        _leftLabel.numberOfLines = 1;
        _leftLabel.text = @"";
        [self addSubview:_leftLabel];
        
        // 宽度
        [NSLayoutConstraint constraintWithItem:_leftLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationLessThanOrEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:0.7f constant:0].active = YES;
        _leftWidthConstraint = [NSLayoutConstraint constraintWithItem:_leftLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:10];
        _leftWidthConstraint.active = YES;
        
        [NSLayoutConstraint constraintWithItem:_leftLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0].active = YES;
        [NSLayoutConstraint constraintWithItem:_leftLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0].active = YES;
        NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:_leftLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
        bottom.priority = UILayoutPriorityRequired;
        bottom.active = YES;
        
        // Label之间的间距
        [self addLabelSpacingConstraintIfNeeded];
    }
    return _leftLabel;
}

- (UILabel *)rightLabel {
    if (_rightLabel == nil) {
        _rightLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _rightLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _rightLabel.font = DEFALUT_TITLE_FONT;
        _rightLabel.textColor = [UIColor darkTextColor];
        _rightLabel.numberOfLines = 0;
        _rightLabel.text = @"";
        [self addSubview:_rightLabel];
        
        // Label之间的间距
        [self addLabelSpacingConstraintIfNeeded];

        [NSLayoutConstraint constraintWithItem:_rightLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0].active = YES;
        [NSLayoutConstraint constraintWithItem:_rightLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0].active = YES;
        
        NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_rightLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
        bottom.priority = UILayoutPriorityDefaultHigh;
        bottom.active = YES;
    }
    return _rightLabel;
}

- (void)setSpacingX:(CGFloat)spacingX {
    _spacingX = spacingX;
    if (_spacingXConstraint) {
        _spacingXConstraint.constant = spacingX;
    }
}

- (void)setLineSpacing:(CGFloat)lineSpacing {
    _lineSpacing = lineSpacing;
    if (lineSpacing > 0) {
        NSString *text = self.rightLabel.attributedText.string;
        if (text.length == 0) {
            text = self.rightLabel.text;
        }
        
        if (text.length > 0) {
            NSMutableParagraphStyle *paraStyle = [NSMutableParagraphStyle new];
            paraStyle.lineSpacing = lineSpacing;
            UIFont *font = self.rightLabel.font ? self.rightLabel.font : DEFALUT_TITLE_FONT;
            
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName : font, NSParagraphStyleAttributeName : paraStyle}];
            self.rightLabel.attributedText = attributedString;
        }

    }else {
        if (self.rightLabel.attributedText.length > 0) {
            NSString *text = self.rightLabel.attributedText.string;
            self.rightLabel.attributedText = nil;
            self.rightLabel.text = text;
        }
    }
}


- (void)addLabelSpacingConstraintIfNeeded {
    if (_leftLabel != nil && _rightLabel != nil) {
        _spacingXConstraint = [NSLayoutConstraint constraintWithItem:_rightLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_leftLabel attribute:NSLayoutAttributeRight multiplier:1 constant:self.spacingX];
        _spacingXConstraint.active = YES;
    }
}

@end
