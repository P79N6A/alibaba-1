//
//  AppVersionUpdateView.m
//  属性字符串Test
//
//  Created by ct on 16/4/28.
//  Copyright © 2016年 ct. All rights reserved.
//

#import "AppVersionUpdateView.h"
#import "AppUpdateModel.h"


@interface AppVersionUpdateView ()

@property (nonatomic, strong) AppUpdateModel *model;
@property (nonatomic, copy) void (^completionHandler)(NSInteger index);
@property (nonatomic, strong) MYSmartLabel *messageLabel;
@end



@implementation AppVersionUpdateView

+ (void)showUpdateViewWithModel:(AppUpdateModel *)model completionHandler:(void (^)(NSInteger index))handler {
    UIWindow *keyWindow = [UIToolClass getKeyWindow];
    
    AppVersionUpdateView *updateView = [[AppVersionUpdateView alloc] initWithFrame:CGRectZero];
    updateView.model = model;
    updateView.completionHandler = handler;
    [updateView initSubviews];
    [keyWindow addSubview:updateView];
    
    [updateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(keyWindow);
    }];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    }
    return self;
}

- (void)layoutSubviews {
    if (_messageLabel) {
        CGFloat labelWidth = kScreenWidth*0.74-24;
        CGSize size = [_messageLabel sizeThatFits:CGSizeMake(labelWidth, NSIntegerMax)];
        if ([UIToolClass textWidth:_messageLabel.text font:_messageLabel.font] < labelWidth) {
            _messageLabel.textAlignment = NSTextAlignmentCenter;
            
            [_messageLabel.superview mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(size.height).priorityMedium();
            }];
        }else {
            _messageLabel.textAlignment = NSTextAlignmentLeft;
            
            [_messageLabel.superview mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(size.height).priorityMedium();
            }];
        }
    }
    
    [super layoutSubviews];
}

- (void)initSubviews {
    
    MYMaskView *contentView = [MYMaskView maskViewWithBgColor:kWhiteColor frame:CGRectZero radius:4];
    [self addSubview:contentView];
    WS(weakSelf)
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf).multipliedBy(0.74);
        make.centerX.equalTo(weakSelf);
        make.centerY.equalTo(weakSelf).multipliedBy(0.96).priorityHigh();
        make.top.greaterThanOrEqualTo(weakSelf).offset(40).priorityHigh();
    }];
    
    MYSmartLabel *titleLabel = [MYSmartLabel al_labelWithMaxRow:2 text:self.model.forceUpdate ? @"升级APP, 方可享受全新服务" : @"发现新版本" font:FONT(17) color:kDeepLabelColor lineSpacing:4 align:NSTextAlignmentCenter breakMode:NSLineBreakByTruncatingTail];
    [contentView addSubview:titleLabel];
    
    MYMaskView *line = [MYMaskView maskViewWithBgColor:ColorFromHex(@"CCCCCC") frame:CGRectZero radius:0];
    [contentView addSubview:line];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(18);
        make.left.equalTo(contentView).offset(8);
        make.right.equalTo(contentView).offset(-8);
        make.height.mas_equalTo(22);
    }];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(3);
        make.right.equalTo(contentView).offset(-3);
        make.height.mas_equalTo(0.6);
        make.top.equalTo(titleLabel.mas_bottom).offset(16);
    }];
    
    
    // 底部的按钮
    UIButton *preButton = nil;
    if (self.model.forceUpdate) {
        MYSmartButton *button = [[MYSmartButton alloc] initWithFrame:CGRectZero title:@"立 即 升 级" font:FONT(16) tColor:kWhiteColor bgColor:kThemeDeepColor actionBlock:^(MYSmartButton *sender) {
            [weakSelf goToAppStore];
            
            if (weakSelf.completionHandler) { weakSelf.completionHandler(1); }
        }];
        button.radius = 3;
        [contentView addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            if (weakSelf.model.updateDescription.length == 0) {
                make.top.equalTo(line.mas_bottom).offset(23);
            }
            make.width.equalTo(contentView).multipliedBy(0.65);
            make.centerX.equalTo(contentView);
            make.height.mas_equalTo(40);
            make.bottom.equalTo(contentView).offset(-26);
        }];
        
        preButton = button;
    }else {
        MYSmartButton *leftButton = [[MYSmartButton alloc] initWithFrame:CGRectZero title:@"下次再说" font:FONT(16) tColor:ColorFromHex(@"7C7C7C") bgColor:kThemeDeepColor actionBlock:^(MYSmartButton *sender) {
            [weakSelf dismiss];
            
            if (weakSelf.completionHandler) {
                weakSelf.completionHandler(0);
            }
        }];
        leftButton.radius = 3;
        leftButton.backgroundColor = ColorFromHex(@"F5F5F5");
        leftButton.layer.borderColor = ColorFromHex(@"D0D0D0").CGColor;
        leftButton.layer.borderWidth = 0.5;
        [contentView addSubview:leftButton];
        
        MYSmartButton *rightButton = [[MYSmartButton alloc] initWithFrame:CGRectZero title:@"立即升级" font:FONT(16) tColor:kWhiteColor bgColor:kThemeDeepColor actionBlock:^(MYSmartButton *sender) {
            [weakSelf goToAppStore];
            
            if (weakSelf.completionHandler) { weakSelf.completionHandler(1); }
            
            if (weakSelf.model.forceUpdate==NO) {
                [weakSelf dismiss];
            }
        }];
        rightButton.radius = leftButton.radius;
        [contentView addSubview:rightButton];
        
        
        [leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            if (weakSelf.model.updateDescription.length == 0) {
                make.top.equalTo(line.mas_bottom).offset(23);
            }
            make.left.equalTo(contentView).offset(25);
            make.height.mas_equalTo(40);
            make.bottom.equalTo(contentView).offset(-26);
        }];
        
        [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.height.and.width.equalTo(leftButton);
            make.left.equalTo(leftButton.mas_right).offset(28);
            make.right.equalTo(contentView).offset(-25);
        }];
        
        preButton = leftButton;
    }
    
    if (_model.updateDescription.length) {
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        [contentView addSubview:scrollView];
        
        self.messageLabel = [MYSmartLabel al_labelWithMaxRow:100 text:_model.updateDescription font:FontYT(14) color:kLightLabelColor lineSpacing:5];
        [scrollView addSubview:self.messageLabel];
        
        [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(line.mas_bottom).offset(20);
            make.bottom.equalTo(preButton.mas_top).offset(-20);
            make.left.equalTo(contentView).offset(12);
            make.right.equalTo(contentView).offset(-12);
        }];
        
        [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.top.equalTo(scrollView);
            make.width.equalTo(scrollView);
            make.bottom.equalTo(scrollView).offset(0);
        }];
    }
}

- (void)dismiss
{
    WS(weakSelf)
    [UIView animateWithDuration:0.3f animations:^{
        weakSelf.alpha = 0;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}

- (void)goToAppStore
{
    NSURL *url = [NSURL URLWithString:_model.updateLink];
    
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
}

@end
