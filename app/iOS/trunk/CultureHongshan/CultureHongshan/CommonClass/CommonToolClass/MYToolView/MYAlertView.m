//
//  MYAlertView.m
//  WHYUIToolKit
//
//  Created by JackAndney on 2017/10/26.
//  Copyright © 2017年 Creatoo. All rights reserved.
//

#import "MYAlertView.h"

#define LINE_COLOR [UIColor colorWithRed:238/255.0f green:238/255.0f blue:238/255.0f alpha:1]

@interface MYAlertView ()
{
    UIScrollView *_msgScrollView;
    UIScrollView *_buttonScrollView;
    
    UILabel *_titleLabel;
    UILabel *_msgLabel;
    
    // 按钮滚动视图上下的遮罩视图，防止滑动时看到底部背景
    UIView *_buttonTopMaskView;
    UIView *_buttonBottomMaskView;
    
    CGFloat VIEW_MARGIN;
    CGFloat ACTION_BUTTON_HEIGHT; // 按钮的高度
    CGFloat ACTION_BUTTON_SPACING; // 按钮之间的间距
    CGFloat TITLE_LABEL_TOP_MARGIN; // 标题与顶部的距离
    CGFloat TITLE_LABEL_BOTTOM_MARGIN; // 标题与消息体的距离
    CGFloat MSG_LABEL_BOTTOM_MARGIN; // 消息体与滑动视图底部的距离
    
    UIFont *DEFAULT_TITLE_FONT;
    UIFont *DEFAULT_MSG_FONT;
}
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, assign) id<MYAlertViewDelegate> delegate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, strong) NSMutableArray *actionTitles;

@property (nonatomic, strong) NSLayoutConstraint *contentViewMaxHeightConstraint;
@property (nonatomic, strong) NSLayoutConstraint *btnViewMaxHeightConstraint;
@property (nonatomic, strong) NSLayoutConstraint *msgScrollViewHeightConstraint;

@end


@implementation MYAlertView

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id<MYAlertViewDelegate>)delegate actionTitles:(NSArray<NSString *> *)actionTitles {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _dismissWhenTouchBackground = NO;
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.backgroundColor = [UIColor clearColor];
        
        self.title = title;
        self.message = message;
        self.delegate = delegate;
        self.actionTitles = [NSMutableArray arrayWithCapacity:0];
        
        for (NSString *action in actionTitles) {
            if (action.length > 0) {
                [self.actionTitles addObject:action];
            }
        }
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
        tapGesture.numberOfTouchesRequired = 1;
        tapGesture.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tapGesture];
        
        CGFloat deviceWidth = MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        CGFloat deviceHeight = MAX([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);

        ACTION_BUTTON_SPACING = 0.5f;
        
        if (deviceWidth == 320 && deviceHeight == 480) {
            // 3.5寸
            VIEW_MARGIN = 20.0f;
            ACTION_BUTTON_HEIGHT = 42.0f;
            ACTION_BUTTON_SPACING = 0.5f;
            TITLE_LABEL_TOP_MARGIN = 20.0f;
            TITLE_LABEL_BOTTOM_MARGIN = 10.0f;
            MSG_LABEL_BOTTOM_MARGIN = 10.0f;
            
            DEFAULT_TITLE_FONT = [UIFont systemFontOfSize:16];
            DEFAULT_MSG_FONT = [UIFont systemFontOfSize:13];
        }else if (deviceWidth == 320 && deviceHeight == 568) {
            // 4.0寸
            VIEW_MARGIN = 20.0f;
            ACTION_BUTTON_HEIGHT = 42.0f;
            ACTION_BUTTON_SPACING = 0.5f;
            TITLE_LABEL_TOP_MARGIN = 24.0f;
            TITLE_LABEL_BOTTOM_MARGIN = 10.0f;
            MSG_LABEL_BOTTOM_MARGIN = 10.0f;
            
            DEFAULT_TITLE_FONT = [UIFont systemFontOfSize:16];
            DEFAULT_MSG_FONT = [UIFont systemFontOfSize:13];
        }else if (deviceWidth == 375 && deviceHeight == 667) {
            // 4.7寸
            VIEW_MARGIN = 22.0f;
            ACTION_BUTTON_HEIGHT = 44.0f;
            ACTION_BUTTON_SPACING = 0.5f;
            TITLE_LABEL_TOP_MARGIN = 30.0f;
            TITLE_LABEL_BOTTOM_MARGIN = 13.0f;
            MSG_LABEL_BOTTOM_MARGIN = 13.0f;
            
            DEFAULT_TITLE_FONT = [UIFont systemFontOfSize:17];
            DEFAULT_MSG_FONT = [UIFont systemFontOfSize:13.5];
        }else if (deviceWidth == 414 && deviceHeight == 736) {
            // 5.5寸
            VIEW_MARGIN = 25.0f;
            ACTION_BUTTON_HEIGHT = 44.0f;
            ACTION_BUTTON_SPACING = 0.334f;
            TITLE_LABEL_TOP_MARGIN = 34.0f;
            TITLE_LABEL_BOTTOM_MARGIN = 16.0f;
            MSG_LABEL_BOTTOM_MARGIN = 16.0f;
            
            DEFAULT_TITLE_FONT = [UIFont systemFontOfSize:18];
            DEFAULT_MSG_FONT = [UIFont systemFontOfSize:14];
        }else if (deviceWidth == 375 && deviceHeight == 812) {
            // 5.8寸
            VIEW_MARGIN = 22.0f;
            ACTION_BUTTON_HEIGHT = 44.0f;
            ACTION_BUTTON_SPACING =  0.30f;
            TITLE_LABEL_TOP_MARGIN = 34.0f;
            TITLE_LABEL_BOTTOM_MARGIN = 16.0f;
            MSG_LABEL_BOTTOM_MARGIN = 16.0f;
            
            DEFAULT_TITLE_FONT = [UIFont systemFontOfSize:18];
            DEFAULT_MSG_FONT = [UIFont systemFontOfSize:14];
        }else {
            VIEW_MARGIN = 25.0f;
            ACTION_BUTTON_HEIGHT = 44.0f;
            ACTION_BUTTON_SPACING = 0.5f;
            TITLE_LABEL_TOP_MARGIN = 32.0f;
            TITLE_LABEL_BOTTOM_MARGIN = 14.0f;
            MSG_LABEL_BOTTOM_MARGIN = 14.0f;
            
            DEFAULT_TITLE_FONT = [UIFont systemFontOfSize:18];
            DEFAULT_MSG_FONT = [UIFont systemFontOfSize:14];
        }
        
        
        [self reloadSubviews];
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    if (CGSizeEqualToSize(self.contentView.bounds.size, CGSizeZero)) {
        return;
    }
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    BOOL landscape = screenSize.width > screenSize.height;
    
    if (landscape) {
        self.btnViewMaxHeightConstraint.constant = 4 * (ACTION_BUTTON_HEIGHT + ACTION_BUTTON_SPACING);
        self.contentViewMaxHeightConstraint.constant = -12;
    }else {
        self.btnViewMaxHeightConstraint.constant = 5 * (ACTION_BUTTON_HEIGHT + ACTION_BUTTON_SPACING);
        self.contentViewMaxHeightConstraint.constant = -40;
    }
    
    self.msgScrollViewHeightConstraint.constant = CGRectGetMaxY(_msgLabel.frame) + MSG_LABEL_BOTTOM_MARGIN;
    [_msgScrollView layoutIfNeeded];
    
    [_buttonScrollView layoutIfNeeded];
    if (self.btnViewMaxHeightConstraint.constant > CGRectGetHeight(self.contentView.bounds)/2.0f) {
        self.btnViewMaxHeightConstraint.constant -= ACTION_BUTTON_HEIGHT + ACTION_BUTTON_SPACING;
    }
    [_buttonScrollView setNeedsLayout];
    [_buttonScrollView layoutIfNeeded];
    
    [self setScrollViewBounces:_msgScrollView];
    [self setScrollViewBounces:_buttonScrollView];
}

- (void)reloadSubviews {
    
    self.contentView = [[UIView alloc] initWithFrame:CGRectZero];
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.cornerRadius = 10;
    self.contentView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.contentView];
    
    _msgScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    _msgScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    _msgScrollView.showsHorizontalScrollIndicator = NO;
    _msgScrollView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_msgScrollView];
    
    _buttonScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    _buttonScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    _buttonScrollView.showsHorizontalScrollIndicator = NO;
    [self.contentView addSubview:_buttonScrollView];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _titleLabel.font = self.titleFont ? self.titleFont : DEFAULT_TITLE_FONT;
    _titleLabel.text = self.title;
    _titleLabel.textColor = self.titleColor ? self.titleColor : [UIColor blackColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.numberOfLines = 0;
    [_msgScrollView addSubview:_titleLabel];
    
    _msgLabel = [[UILabel alloc] init];
    _msgLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _msgLabel.font = self.msgFont ? self.msgFont : DEFAULT_MSG_FONT;
    _msgLabel.text = self.message;
    _msgLabel.textColor = self.msgColor ? self.msgColor : [UIColor darkTextColor];
    _msgLabel.textAlignment = NSTextAlignmentCenter;
    _msgLabel.numberOfLines = 0;
    [_msgScrollView addSubview:_msgLabel];
    
    NSInteger index = 0;
    for (NSString *actionTitle in self.actionTitles) {
        UILabel *itemLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        itemLabel.translatesAutoresizingMaskIntoConstraints = NO;
        itemLabel.userInteractionEnabled = YES;
        itemLabel.tag = 10+index;
        itemLabel.text = actionTitle;
        itemLabel.textColor = self.btnColor ? self.btnColor : [UIColor colorWithRed:0.082 green:0.494 blue:0.984 alpha:1];
        itemLabel.backgroundColor = [UIColor whiteColor];
        itemLabel.textAlignment = NSTextAlignmentCenter;
        itemLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        itemLabel.font = self.btnFont ? self.btnFont : [UIFont systemFontOfSize:17];
        [_buttonScrollView addSubview:itemLabel];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionItemClick:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [itemLabel addGestureRecognizer:tap];
        
        index++;
    }
    
    if (self.actionTitles.count >= 3) {
        _buttonTopMaskView = [[UIView alloc] init];
        _buttonTopMaskView.translatesAutoresizingMaskIntoConstraints = NO;
        [_buttonScrollView addSubview:_buttonTopMaskView];
        
        _buttonBottomMaskView = [[UIView alloc] init];
        _buttonBottomMaskView.translatesAutoresizingMaskIntoConstraints = NO;
        [_buttonScrollView addSubview:_buttonBottomMaskView];
    }
    
    [self addViewConstraints];
}


/**
 *  添加视图约束
 */
- (void)addViewConstraints {
    CGFloat value = 0;
    
    // ————————————— Content View ———————————————
    NSLayoutConstraint *contentViewCenterX = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSLayoutConstraint *contentViewCenterY = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    
    value = 0.653 * MIN(CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds)); // 810 / 1242 // 取宽度、高度中的小者
    if (value < 270) {
        value = 270;
    }
    NSLayoutConstraint *contentViewWidth = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:value];
    self.contentViewMaxHeightConstraint = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationLessThanOrEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1 constant:-30];
    self.contentViewMaxHeightConstraint.priority = UILayoutPriorityRequired;
    self.contentViewMaxHeightConstraint.active = YES;

    [NSLayoutConstraint activateConstraints:@[contentViewCenterX, contentViewCenterY, contentViewWidth]];
    
    

    // ————————————— Message ScrollView ———————————————
    
    NSArray *msgScrollViewHConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_msgScrollView]|" options:0 metrics:nil views:@{@"_msgScrollView" : _msgScrollView}];
    [NSLayoutConstraint activateConstraints:msgScrollViewHConstraints];
    
    NSLayoutConstraint *msgScrollViewTop = [NSLayoutConstraint constraintWithItem:_msgScrollView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    msgScrollViewTop.active = YES;
    
    self.msgScrollViewHeightConstraint = [NSLayoutConstraint constraintWithItem:_msgScrollView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:30];
    self.msgScrollViewHeightConstraint.priority = UILayoutPriorityDefaultLow;
    self.msgScrollViewHeightConstraint.active = YES;
    
    
    // ————————————— Button ScrollView ———————————————
    
    NSArray *btnScrollViewHConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_buttonScrollView]|" options:0 metrics:nil views:@{@"_buttonScrollView" : _buttonScrollView}];
    [NSLayoutConstraint activateConstraints:btnScrollViewHConstraints];
    
    NSArray *btnScrollViewVConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_msgScrollView][_buttonScrollView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_msgScrollView, _buttonScrollView)];
    [NSLayoutConstraint activateConstraints:btnScrollViewVConstraints];
    
    if (self.actionTitles.count == 0) {
        value = 0;
    }else if (self.actionTitles.count < 3) {
        value = ACTION_BUTTON_HEIGHT + ACTION_BUTTON_SPACING;
    }else {
        value = self.actionTitles.count * (ACTION_BUTTON_HEIGHT + ACTION_BUTTON_SPACING);
    }
    
    NSLayoutConstraint *btnScrollViewHeight = [NSLayoutConstraint constraintWithItem:_buttonScrollView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:value];
    btnScrollViewHeight.priority = UILayoutPriorityDefaultHigh;
    btnScrollViewHeight.active = YES;
    
    self.btnViewMaxHeightConstraint = [NSLayoutConstraint constraintWithItem:_buttonScrollView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationLessThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:2 * ACTION_BUTTON_HEIGHT];
    self.btnViewMaxHeightConstraint.priority = UILayoutPriorityRequired;
    self.btnViewMaxHeightConstraint.active = YES;
    
    
    // ————————————— Title Label ———————————————
    
    // 宽度约束
    [NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeWidth multiplier:1 constant:-2*VIEW_MARGIN].active = YES;
    // 顶部约束
    [NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_msgScrollView attribute:NSLayoutAttributeTop multiplier:1 constant:TITLE_LABEL_TOP_MARGIN].active = YES;
    
    // 左右边距
    NSArray *titleLabelHConstraints = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-%f-[_titleLabel]-%f-|", VIEW_MARGIN, VIEW_MARGIN] options:0 metrics:nil views:@{@"_titleLabel" : _titleLabel}];
    [NSLayoutConstraint activateConstraints:titleLabelHConstraints];
    
    
    // ————————————— Message Label ———————————————
    // 左右约束
    [NSLayoutConstraint constraintWithItem:_msgLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_titleLabel attribute:NSLayoutAttributeLeft multiplier:1 constant:0].active = YES;
    [NSLayoutConstraint constraintWithItem:_msgLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_titleLabel attribute:NSLayoutAttributeRight multiplier:1 constant:0].active = YES;
    // 垂直约束
    NSArray *msgLabelVConstraints = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[_titleLabel]-%f-[_msgLabel]-%f-|", TITLE_LABEL_BOTTOM_MARGIN, MSG_LABEL_BOTTOM_MARGIN] options:0 metrics:nil views:NSDictionaryOfVariableBindings(_titleLabel, _msgLabel)];
    [NSLayoutConstraint activateConstraints:msgLabelVConstraints];
    
    
    // ————————————— Action Buttons ———————————————
    if (self.actionTitles.count == 0) {
        return;
    }
    
    if (self.actionTitles.count == 2) {
        UIView *leftItemView = [_buttonScrollView viewWithTag:10];
        UIView *rightItemView = [_buttonScrollView viewWithTag:11];
        
        NSArray *hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|[leftItemView]-%f-[rightItemView(==leftItemView)]|", ACTION_BUTTON_SPACING] options:0 metrics:nil views:NSDictionaryOfVariableBindings(leftItemView, rightItemView)];
        [NSLayoutConstraint activateConstraints:hConstraints];
        
        NSArray *vConstraintsOfLeftBtn = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-%f-[leftItemView(%f)]|", ACTION_BUTTON_SPACING,  ACTION_BUTTON_HEIGHT] options:0 metrics:nil views:NSDictionaryOfVariableBindings(leftItemView)];
        [NSLayoutConstraint activateConstraints:vConstraintsOfLeftBtn];
        
        NSArray *vConstraintsOfRigthBtn = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-%f-[rightItemView(%f)]|", ACTION_BUTTON_SPACING,  ACTION_BUTTON_HEIGHT] options:0 metrics:nil views:NSDictionaryOfVariableBindings(rightItemView)];
        [NSLayoutConstraint activateConstraints:vConstraintsOfRigthBtn];
        
        [NSLayoutConstraint constraintWithItem:leftItemView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_buttonScrollView attribute:NSLayoutAttributeWidth multiplier:0.5 constant:-ACTION_BUTTON_SPACING * 0.5].active = YES;
        
    }else {
        UIView *preView = nil;
        
        for (NSInteger i = 0; i < self.actionTitles.count; i++) {
            UIView *itemView = [_buttonScrollView viewWithTag:10+i];
            
            NSArray *hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[itemView(==_contentView)]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(itemView, _contentView)];
            [NSLayoutConstraint activateConstraints:hConstraints];
            
            if (preView == nil) {
                NSArray *vConstraints = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[itemView(%f)]-0-|", ACTION_BUTTON_HEIGHT] options:0 metrics:nil views:NSDictionaryOfVariableBindings(itemView)];
                [NSLayoutConstraint activateConstraints:vConstraints];
            }else {
                NSArray *vConstraints = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[itemView(%f)]-%f-[preView]", ACTION_BUTTON_HEIGHT, ACTION_BUTTON_SPACING] options:0 metrics:nil views:NSDictionaryOfVariableBindings(itemView, preView)];
                [NSLayoutConstraint activateConstraints:vConstraints];
            }
            
            preView = itemView;
        }
        
        [NSLayoutConstraint constraintWithItem:preView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_buttonScrollView attribute:NSLayoutAttributeTop multiplier:1 constant:ACTION_BUTTON_SPACING].active = YES;
        
        // 遮罩
        if (_buttonTopMaskView != nil) {
            UIButton *bottomButton = [_buttonScrollView viewWithTag:10];
            
            _buttonTopMaskView.backgroundColor = preView.backgroundColor;
            _buttonBottomMaskView.backgroundColor = preView.backgroundColor;
            
            NSArray *constraintArray = nil;
            constraintArray = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_buttonTopMaskView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_buttonTopMaskView)];
            [NSLayoutConstraint activateConstraints:constraintArray];
            
            constraintArray = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[_buttonTopMaskView(1000)]-%f-[preView]", ACTION_BUTTON_SPACING] options:0 metrics:nil views:NSDictionaryOfVariableBindings(preView, _buttonTopMaskView)];
            [NSLayoutConstraint activateConstraints:constraintArray];
            
            constraintArray = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_buttonBottomMaskView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_buttonBottomMaskView)];
            [NSLayoutConstraint activateConstraints:constraintArray];
            
            constraintArray = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[bottomButton]-%f-[_buttonBottomMaskView(1000)]", ACTION_BUTTON_SPACING] options:0 metrics:nil views:NSDictionaryOfVariableBindings(bottomButton, _buttonBottomMaskView)];
            [NSLayoutConstraint activateConstraints:constraintArray];
        }
    }
    
}


#pragma mark - 显示与隐藏

- (void)showWithAnimation:(BOOL)animated {
    // 添加约束
    NSArray *hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[self]-0-|" options:0 metrics:nil views:@{@"self" : self}];
    NSArray *vConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[self]-0-|" options:0 metrics:nil views:@{@"self" : self}];
    [NSLayoutConstraint activateConstraints:hConstraints];
    [NSLayoutConstraint activateConstraints:vConstraints];
    
    if (animated) {
        __weak MYAlertView *weakSelf = self;
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
        __weak MYAlertView *weakSelf = self;
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

#pragma mark - Button Actions

- (void)tapGesture:(UITapGestureRecognizer *)gesture {
    CGPoint point = [gesture locationInView:self];
    if (CGRectContainsPoint(self.contentView.frame, point) == NO) {
        if (self.dismissWhenTouchBackground) {
            [self dismissWithAnimation:YES];
            
            if (self.delegate) {
                if ([self.delegate respondsToSelector:@selector(alertView:didDismissWithItem:atIndex:)]) {
                    [self.delegate alertView:self didDismissWithItem:nil atIndex:-1];
                }
            }else {
                if (self.didDismissBlock) {
                    self.didDismissBlock(self, nil, -1);
                }
            }
        }
    }
}

- (void)actionItemClick:(UIButton *)sender {
    NSInteger index = 0;
    if ([sender isKindOfClass:[UIButton class]]) {
        index = sender.tag-10;
    }else if ([sender isKindOfClass:[UITapGestureRecognizer class]]) {
        UILabel *label = (UILabel *)[(UITapGestureRecognizer *)sender view];
        index = label.tag-10;
    }
    
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(alertView:didClickItem:atIndex:)]) {
            [self.delegate alertView:self didClickItem:self.actionTitles[index] atIndex:index];
        }
    }else {
        if (self.didClickItemBlock) {
            self.didClickItemBlock(self, self.actionTitles[index], index);
        }
    }
    
    [self dismissWithAnimation:YES];
    
    
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(alertView:didDismissWithItem:atIndex:)]) {
            [self.delegate alertView:self didDismissWithItem:self.actionTitles[index] atIndex:index];
        }
    }else {
        if (self.didDismissBlock) {
            self.didDismissBlock(self, self.actionTitles[index], index);
        }
    }
}

#pragma mark - 外部方法

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
    
    [self showWithAnimation:YES];
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

- (void)setScrollViewBounces:(UIScrollView *)sView {
    sView.bounces = sView.scrollEnabled = (sView.contentSize.height > sView.bounds.size.height+3 || sView.contentSize.height == sView.bounds.size.height);
}

@end
