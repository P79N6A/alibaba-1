//
//  MYSegmentView.m
//  WHYUIToolKit
//
//  Created by JackAndney on 2017/10/25.
//  Copyright © 2017年 Creatoo. All rights reserved.
//

#import "MYSegmentView.h"


@interface MYSegmentView ()
{
    UIView *_indicatorView;
    BOOL _showImageAndTitle;
}

@property (nonatomic, strong) NSLayoutConstraint *indicatorCenterXConstraint; // 指示条中心位置的约束

@end


@implementation MYSegmentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor clearColor];
        
        self.titleAndImageSpacing = 4;
        self.indicatorOffsetY = 0;
        self.indicatorWidth = 0.75;
        self.indicatorHeight = 1.0;
        self.bottomLineHeight = 0.7;
        self.seperatorHeightScale = 0.7;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (_showImageAndTitle) {
        for (UIButton *button in self.subviews) {
            if ([button isKindOfClass:[UIButton class]]) {
                [self.class setButtonContentLayout:button type:2 spacing:self.titleAndImageSpacing];
            }
        }
    }
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    if (backgroundColor) {
        super.backgroundColor = backgroundColor;
    }else {
        super.backgroundColor = [UIColor colorWithRed:0.9294 green:0.9294 blue:0.9294 alpha:1];
    }
}


- (void)beginUpdate {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_indicatorView removeFromSuperview];
    _indicatorView = nil;
    
    if (self.segmentTitles.count == 0) {
        return;
    }
    
    UIView *preView = nil;
    int index = 0;
    _showImageAndTitle = (self.segmentNormalImages.count >= self.segmentTitles.count && self.segmentSelectedImages.count >= self.segmentTitles.count);
    
    for (NSString *title in self.segmentTitles) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.translatesAutoresizingMaskIntoConstraints = NO;
        button.tag = 10 + index;
        button.backgroundColor = self.btnBackgroundColor ? self.btnBackgroundColor : [UIColor whiteColor];
        
        button.titleLabel.font = self.font ? self.font : [UIFont systemFontOfSize:15];
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:self.normalColor forState:UIControlStateNormal];
        [button setTitleColor:self.selectedColor forState:UIControlStateSelected];
        [button addTarget:self action:@selector(segmentItemClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if (_showImageAndTitle) {
            UIImage *normalImage = self.segmentNormalImages[index];
            UIImage *selectedImage = self.segmentSelectedImages[index];
            [button setImage:normalImage forState:UIControlStateNormal];
            [button setImage:selectedImage forState:UIControlStateSelected];
        }
        
        [self addSubview:button];
        
        if (preView == nil) {
            NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:self.leftMargin];
            NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0];
            NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:-self.bottomLineHeight];
            
            [NSLayoutConstraint activateConstraints:@[left, top, bottom]];
        }else {
            NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:preView attribute:NSLayoutAttributeRight multiplier:1 constant:0];
            NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:preView attribute:NSLayoutAttributeTop multiplier:1 constant:0];
            NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:preView attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
            NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:preView attribute:NSLayoutAttributeWidth multiplier:1 constant:0];
            
            [NSLayoutConstraint activateConstraints:@[left, top, bottom, width]];
        }
        
        // 添加中间的分割线
        if (_showMidLine &&  preView) {
            UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectZero];
            line.translatesAutoresizingMaskIntoConstraints = NO;
            [self addSubview:line];
            
            CGSize lineSize = CGSizeZero;
            NSLayoutConstraint *height = nil;
            
            if (self.seperatorImage) {
                line.image = self.seperatorImage;
                lineSize = self.seperatorImage.size;
                
                height = [NSLayoutConstraint constraintWithItem:line attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:lineSize.height];
            }else {
                lineSize = CGSizeMake(1, 0);
                line.backgroundColor = self.seperatorColor ? self.seperatorColor : [UIColor lightGrayColor];
                height = [NSLayoutConstraint constraintWithItem:line attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:button attribute:NSLayoutAttributeHeight multiplier:self.seperatorHeightScale constant:0];
            }
            
            NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:line attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:button attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
            NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:line attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:button attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
            NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:line attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:lineSize.width];
            
            [NSLayoutConstraint activateConstraints:@[centerX, centerY, width, height]];
        }
        
        preView = button;
        index++;
    }
    
    // 约束最后一个按钮的右侧
    [NSLayoutConstraint activateConstraints:@[[NSLayoutConstraint constraintWithItem:preView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:-self.rightMargin]]];
    
    // 底部的分割线
    if (self.bottomLineHeight > 0) {
        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectZero];
        bottomLine.translatesAutoresizingMaskIntoConstraints = NO;
        bottomLine.backgroundColor = self.bottomLineColor ? self.bottomLineColor : [UIColor lightGrayColor];
        [self addSubview:bottomLine];
        
        NSArray *hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-%f-[bottomLine]-%f-|", self.leftMargin, self.rightMargin] options:0 metrics:nil views:@{@"bottomLine": bottomLine}];
        [NSLayoutConstraint activateConstraints:hConstraints];
        NSArray *vConstraints = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[bottomLine(%f)]|", self.bottomLineHeight] options:0 metrics:nil views:@{@"bottomLine": bottomLine}];
        [NSLayoutConstraint activateConstraints:vConstraints];
    }
    
    _itemClickType = 0;
    [self setSelectedIndex:self.selectedIndex animated:NO manually:YES];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex animated:(BOOL)animated {
    _itemClickType = 2; // 外部调用
    [self setSelectedIndex:selectedIndex animated:animated manually:YES];
}

// 根据索引选中指定的Item
- (void)setSelectedIndex:(NSInteger)selectedIndex animated:(BOOL)animated manually:(BOOL)manually {
    // manually：是否手动调用该方法
    if (selectedIndex < 0 || selectedIndex >= self.segmentTitles.count) {
        return;
    }
    
    if (self.selectedIndex == selectedIndex) {
        _sameButonClick = YES;
    }else {
        _sameButonClick = NO;
    }
    
    UIButton *lastSelectedButton = [self getButtonAtIndex:self.selectedIndex];
    lastSelectedButton.selected = NO;
    
    UIButton *button = [self getButtonAtIndex:selectedIndex];
    
    if (self.showIndicatorView) {
        
        if (_indicatorView == nil) {
            _indicatorView = [[UIView alloc] init];
            _indicatorView.translatesAutoresizingMaskIntoConstraints = NO;
            [self addSubview:_indicatorView];
            
            NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:_indicatorView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:self.indicatorHeight];
            NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:_indicatorView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:-self.indicatorOffsetY];
            [NSLayoutConstraint activateConstraints:@[height, bottom]];
            
            if (self.indicatorWidth <= 1.01) {
                NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:_indicatorView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:button attribute:NSLayoutAttributeWidth multiplier:self.indicatorWidth constant:0];
                width.active = YES;
            }else {
                NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:_indicatorView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:self.indicatorWidth];
                width.active = YES;
            }
        }
        
        if (self.indicatorCenterXConstraint != nil) {
            self.indicatorCenterXConstraint.active = NO;
            self.indicatorCenterXConstraint = nil;
        }
        
        _indicatorView.backgroundColor = self.indicatorColor;
        
        self.indicatorCenterXConstraint = [NSLayoutConstraint constraintWithItem:_indicatorView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:button attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
        self.indicatorCenterXConstraint.active = YES;
    }
    
    if (animated) {
        __weak typeof(self) weakSelf = self;
        __weak UIButton *weakButton = button;
        [UIView animateWithDuration:0.25 animations:^{
            [weakSelf setNeedsLayout];
            [weakSelf layoutIfNeeded];
            weakButton.selected = YES;
        }];
    }else {
        [self setNeedsLayout];
        [self layoutIfNeeded];
        button.selected = YES;
    }
    
    self->_selectedIndex = selectedIndex;
    
    if (self.itemClickType == 1 || self.itemClickType == 2) {
        if (self.delegate) {
            if ([self.delegate respondsToSelector:@selector(segmentView:didClickItem:atIndex:)]) {
                [self.delegate segmentView:self didClickItem:button atIndex:selectedIndex];
            }
        }else {
            if (self.didClickItemBlock) {
                self.didClickItemBlock(self, selectedIndex, button);
            }
        }
    }
}

#pragma mark - Button Action

- (void)segmentItemClick:(UIButton *)sender {
    _itemClickType = 1; // 按钮点击调用
    [self setSelectedIndex:sender.tag-10 animated:YES manually:NO];
}

#pragma mark - Private Method

- (UIButton *)getButtonAtIndex:(NSInteger)index {
    if (index < 0 || index >= self.segmentTitles.count) {
        return nil;
    }
    
    return [self viewWithTag:10+index];
}



/**
 更新按钮的图片和文字的显示

 @param type    布局方式：0-图片在左，1-图片在右， 2-图片在上， 3-图片在下
 @param spacing 图片和文字之间的间距
 */
+ (void)setButtonContentLayout:(UIButton *)button type:(int)type spacing:(CGFloat)spacing {
    if (spacing < 0) {
        spacing = 0;
    }
    
    if (CGRectEqualToRect(button.titleLabel.bounds, CGRectZero)) {
        return;
    }
    
    CGFloat imageWidth = button.imageView.image.size.width;
    CGFloat imageHeight = button.imageView.image.size.height;
    
    CGFloat labelWidth = 0.0;
    CGFloat labelHeight = 0.0;
    
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        // 由于iOS 8中titleLabel的size为0，用下面的这种设置
        labelWidth = button.titleLabel.intrinsicContentSize.width;
        labelHeight = button.titleLabel.intrinsicContentSize.height;
    }else {
        labelWidth = button.titleLabel.frame.size.width;
        labelHeight = button.titleLabel.frame.size.height;
    }
    
    switch (type) {
        case 0: { // 0-图片在左
            button.imageEdgeInsets = UIEdgeInsetsMake(0, -spacing/2.0, 0, spacing/2.0);
            button.titleEdgeInsets = UIEdgeInsetsMake(0, spacing/2.0, 0, -spacing/2.0);
        }
            break;
        case 1: { // 1-图片在右
            button.imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth+spacing/2.0, 0, -labelWidth-spacing/2.0);
            button.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth-spacing/2.0, 0, imageWidth+spacing/2.0);
        }
            break;
        case 2: { // 2-图片在上
            button.imageEdgeInsets = UIEdgeInsetsMake(-labelHeight-spacing/2.0, 0, 0, -labelWidth);
            button.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth, -imageHeight-spacing/2.0 -spacing, 0);
        }
            break;
        case 3: { // 3-图片在下
            button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, -labelHeight-spacing/2.0, -labelWidth);
            button.titleEdgeInsets = UIEdgeInsetsMake(-imageHeight-spacing/2.0, -imageWidth, 0, 0);
        }
            break;
        
        default: {
            button.imageEdgeInsets = UIEdgeInsetsZero;
            button.titleEdgeInsets = UIEdgeInsetsZero;
        }
            break;
    }
}



@end
