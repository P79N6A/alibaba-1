//
//  MYBasicAlertView.m
//  WHYUIToolKit
//
//  Created by JackAndney on 2017/11/1.
//  Copyright © 2017年 Creatoo. All rights reserved.
//

#import "MYBasicAlertView.h"

@interface MYBasicAlertView ()
{
    UITapGestureRecognizer *_tapGesture;
    NSLayoutConstraint *_centerYConstraint;
    NSLayoutConstraint *_maxWidthConstraint; // contentView的最大宽度约束
}
@property (nonatomic, strong, readwrite) UIView *contentView;

@end


@implementation MYBasicAlertView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        _dismissWhenTouchBackground = NO;
        _strictWidthConstraint = YES;
        
        self.contentView = [[UIView alloc] initWithFrame:CGRectZero];
                self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
        self.contentView.layer.cornerRadius = 5;
        self.contentView.layer.masksToBounds = YES;
        [self addSubview:self.contentView];
    
        [self configContentViewConstraints];
        if ([self.class addBlurEffectOnView:self.contentView] == NO) {
            self.contentView.backgroundColor = [UIColor whiteColor];
        }
    }
    return self;
}


- (void)setDismissWhenTouchBackground:(BOOL)dismissWhenTouchBackground {
    _dismissWhenTouchBackground = dismissWhenTouchBackground;
    
    if (dismissWhenTouchBackground) {
        if (_tapGesture == nil) {
            // 添加点击手势
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
            tapGesture.numberOfTouchesRequired = 1;
            tapGesture.numberOfTapsRequired = 1;
            [self addGestureRecognizer:tapGesture];
            _tapGesture = tapGesture;
        }
        _tapGesture.enabled = YES;
    }else {
        if (_tapGesture) {
            _tapGesture.enabled = NO;
        }
    }
}

- (void)setStrictWidthConstraint:(BOOL)strictWidthConstraint {
    _strictWidthConstraint = strictWidthConstraint;

    if (strictWidthConstraint) {
        if (_maxWidthConstraint != nil) {
            _maxWidthConstraint.active = NO;
            _maxWidthConstraint = nil;
        }
        _maxWidthConstraint = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationLessThanOrEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:0.75f constant:0];
        _maxWidthConstraint.priority = UILayoutPriorityRequired;
        _maxWidthConstraint.active = YES;
    }else {
        if (_maxWidthConstraint) {
            _maxWidthConstraint.active = NO;
            _maxWidthConstraint = nil;
        }
    }
}

- (void)setContentOffsetY:(CGFloat)contentOffsetY {
    _contentOffsetY = contentOffsetY;
    if (_centerYConstraint) {
        _centerYConstraint.constant = contentOffsetY;
    }
}

- (void)configContentViewConstraints {
    [NSLayoutConstraint deactivateConstraints:self.contentView.constraints];
    
    // 宽度约束
    NSLayoutConstraint *width1 = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:0.75f constant:0];
    width1.priority = UILayoutPriorityDefaultHigh;
    width1.active = YES;
    
    [self setStrictWidthConstraint:_strictWidthConstraint];
    
    // 高度约束
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationLessThanOrEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1.0f constant:-30];
    height.priority = UILayoutPriorityRequired;
    height.active = YES;

    // 中心位置
    [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0].active = YES;
    _centerYConstraint = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0];
    _centerYConstraint.active = YES;
}

#pragma mark - 显示与隐藏

- (void)showWithAnimation:(BOOL)animated {
    if (self.superview == nil) {
        [self showInView:nil];
    }
    
    // 添加约束
    NSArray *hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[self]|" options:0 metrics:nil views:@{@"self" : self}];
    NSArray *vConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[self]|" options:0 metrics:nil views:@{@"self" : self}];
    [NSLayoutConstraint activateConstraints:hConstraints];
    [NSLayoutConstraint activateConstraints:vConstraints];
    
    if (animated) {
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.25 animations:^{
            weakSelf.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.55f];
        }];
        [self.class addAlertAnimationOnView:self.contentView];
    }else {
        self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.55f];
        [self.superview setNeedsLayout];
        [self.superview layoutIfNeeded];
    }
}

- (void)dismissWithAnimation:(BOOL)animated {
    if (animated) {
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.3f animations:^{
            weakSelf.backgroundColor = [UIColor clearColor];
            weakSelf.contentView.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [weakSelf removeFromSuperview];
        }];
    }else {
        [self removeFromSuperview];
    }
}

- (void)showInView:(UIView *)view {
    UIView *parentView = nil;
    if (view) {
        parentView = view;
    }else {
        if ([UIApplication sharedApplication].keyWindow != nil) {
            parentView = [UIApplication sharedApplication].keyWindow;
        }else {
            parentView = [UIApplication sharedApplication].delegate.window;
        }
    }
    
    [parentView addSubview:self];
}


#pragma mark - Button Actions

- (void)tapGesture:(UITapGestureRecognizer *)gesture {
    if (self.dismissWhenTouchBackground == NO) return;
    
    CGPoint point = [gesture locationInView:self];
    if (CGRectContainsPoint(self.contentView.frame, point) == NO) {
        if ([self respondsToSelector:@selector(tapOnBackgroundForDisappear)]) {
            [self tapOnBackgroundForDisappear];
        }
    }
}

- (void)tapOnBackgroundForDisappear {
    [self dismissWithAnimation:YES];
}


#pragma mark -

// 添加UIAlertView出现时的动画效果
+ (void)addAlertAnimationOnView:(UIView *)view {
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = 0.4;
    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    popAnimation.keyTimes = @[@0.0f, @0.5f, @0.75f, @1.0f];
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [view.layer addAnimation:popAnimation forKey:nil];
}

// 添加模糊效果
+ (BOOL)addBlurEffectOnView:(UIView *)view {
    if (NSClassFromString(@"UIVisualEffectView") != nil) {
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
        visualEffectView.translatesAutoresizingMaskIntoConstraints = NO;
        [view addSubview:visualEffectView];
        
        [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[visualEffectView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(visualEffectView)]];
        [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[visualEffectView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(visualEffectView)]];
        
        return YES;
    }
    return NO;
}


@end
