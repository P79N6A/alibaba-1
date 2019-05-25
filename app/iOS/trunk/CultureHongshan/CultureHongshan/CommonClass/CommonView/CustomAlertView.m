//
//  CustomAlertView.m
//  CultureHongshan
//
//  Created by JackAndney on 2017/2/19.
//  Copyright © 2017年 CT. All rights reserved.
//

#import "CustomAlertView.h"

@interface CustomAlertView ()
@property (nonatomic, assign) MYAlertStyle style;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, assign) BOOL animated;
@end

@implementation CustomAlertView

+ (nullable instancetype )showAlertWithStyle:(MYAlertStyle)style animated:(BOOL)animated {
    return [self showAlertWithStyle:style message:nil animated:animated];
}

+ (nullable instancetype)showAlertWithStyle:(MYAlertStyle)style message:(NSString *)msg animated:(BOOL)animated {
    CustomAlertView *alertView = [[CustomAlertView alloc] initWithFrame:CGRectZero];
    alertView.style = style;
    alertView.message = msg;
    alertView.animated = animated;
    [alertView loadUI];
    
    [alertView show];
    
    switch (style) {
        case MYAlertStylePaying:
            return alertView;
            
        default:
            break;
    }
    
    return nil;
}



- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    }
    return self;
}

- (void)loadUI {
    WS(weakSelf)
    
    if (self.style == MYAlertStyleRefundSuccess) {
        // 退款申请成功
        self.contentView = [MYMaskView maskViewWithBgColor:kWhiteColor frame:CGRectZero radius:4];
        [self addSubview:self.contentView];
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(weakSelf).multipliedBy(0.65);
            make.centerX.equalTo(weakSelf);
            make.centerY.equalTo(weakSelf).multipliedBy(0.7496);
        }];
        
        
        MYSmartLabel *titleLabel = [MYSmartLabel al_labelWithMaxRow:3 text:@"退款申请提交成功" font:FontYT(17) color:kThemeDeepColor lineSpacing:2 align:NSTextAlignmentCenter breakMode:NSLineBreakByTruncatingTail];
        [self.contentView addSubview:titleLabel];
        
        MYSmartLabel *subtitleLabel = [MYSmartLabel al_labelWithMaxRow:10 text:@"我们将在24h内处理您的申请" font:FontYT(14) color:kDeepLabelColor lineSpacing:4 align:NSTextAlignmentCenter breakMode:NSLineBreakByTruncatingTail];
        [self.contentView addSubview:subtitleLabel];
        
        MYSmartButton *confirmButton = [[MYSmartButton alloc] initWithFrame:CGRectZero title:@"确 定" font:FontYT(16) tColor:kDeepLabelColor bgColor:RGB(245, 245, 245) actionBlock:^(MYSmartButton *sender) {
            [weakSelf dismiss];
        }];
        confirmButton.radius = 3;
        confirmButton.layer.borderWidth = 0.7;
        confirmButton.layer.borderColor = RGB(208, 208, 208).CGColor;
        [self.contentView addSubview:confirmButton];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.contentView).offset(25);
            make.left.equalTo(weakSelf.contentView).offset(12);
            make.right.equalTo(weakSelf.contentView).offset(-12);
        }];
        
        [subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLabel.mas_bottom).offset(13);
            make.left.right.equalTo(titleLabel);
        }];
        
        [confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(subtitleLabel.mas_bottom).offset(21);
            make.height.mas_equalTo(40);
            make.width.equalTo(weakSelf.contentView).multipliedBy(0.4375);
            make.centerX.equalTo(weakSelf.contentView);
            make.bottom.equalTo(weakSelf.contentView).offset(-32);
        }];
    }else if (self.style == MYAlertStylePaying) {
        // 支付中
        self.backgroundColor = kWhiteColor;
        self.contentView = [MYMaskView maskViewWithBgColor:kWhiteColor frame:CGRectZero radius:0];
        [self addSubview:self.contentView];
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(weakSelf).multipliedBy(0.9);
            make.centerX.equalTo(weakSelf);
            make.centerY.equalTo(weakSelf);
        }];
        
        UIImageView *iconView = [[UIImageView alloc] initWithImage:IMG(@"icon_paying")];
        [self.contentView addSubview:iconView];
        
        MYSmartLabel *messageLabel = [MYSmartLabel al_labelWithMaxRow:2 text:@"支付完成，请等待支付结果返回。" font:FontYT(14) color:kThemeDeepColor lineSpacing:4 align:NSTextAlignmentCenter breakMode:NSLineBreakByTruncatingTail];
        [self.contentView addSubview:messageLabel];
        
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.contentView).offset(20);
            make.centerX.equalTo(weakSelf.contentView);
        }];
        
        [messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView).offset(10);
            make.right.equalTo(weakSelf.contentView).offset(-10);
            make.bottom.equalTo(weakSelf.contentView).offset(-20);
            make.top.equalTo(iconView.mas_bottom).offset(10);
        }];
    }else if (self.style == MYAlertStyleAutoDismiss) {
        // 自动消失的弹窗
        self.backgroundColor = RGB(0x32, 0x33, 0x34);
        self.alpha = 0;
        self.radius = 5;
        
        NSTextAlignment textAlign = ([UIToolClass textWidth:self.message font:FontYT(15)] < kScreenWidth * 0.85 - 24) ? NSTextAlignmentCenter : NSTextAlignmentLeft;
        MYSmartLabel *msgLabel = [MYSmartLabel al_labelWithMaxRow:20 text:self.message font:FontYT(15) color:COLOR_IWHITE lineSpacing:4 align:textAlign breakMode:NSLineBreakByTruncatingTail];
        [self addSubview:msgLabel];
        
        WS(weakSelf)
        [msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf).offset(15);
            make.bottom.equalTo(weakSelf).offset(-15);
            make.left.equalTo(weakSelf).offset(12);
            make.right.equalTo(weakSelf).offset(-12);
        }];
    }
}


- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    WS(weakSelf)
    if (self.style == MYAlertStyleAutoDismiss) {
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(weakSelf.superview).offset(-70);
            make.width.greaterThanOrEqualTo(weakSelf.superview).multipliedBy(0.5).priorityHigh();
            make.width.lessThanOrEqualTo(weakSelf.superview).multipliedBy(0.85).priorityHigh();
            make.centerX.equalTo(weakSelf.superview);
            make.top.mas_greaterThanOrEqualTo(weakSelf.superview).offset(40).priorityHigh();
        }];
        
        if (self.animated) {
            [UIView animateWithDuration:0.3 animations:^{
                weakSelf.alpha = 1;
            } completion:^(BOOL finished) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)([CustomAlertView messageDisplayDuration:weakSelf.message] * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf dismiss];
                });
            }];
        }else {
            self.alpha = 1;
        }
    }else {
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf.superview);
        }];
        
        if (self.style == MYAlertStyleRefundSuccess) {
            if (self.animated) {
                [AnimationTool addAlertAnimationOnView:self.contentView];
            }
        }else if (self.style == MYAlertStylePaying) {
            
        }
    }
}

- (void)dismiss {
    WS(weakSelf)
    [UIView animateWithDuration:0.3f animations:^{
        weakSelf.alpha = 0;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}


+ (NSTimeInterval)messageDisplayDuration:(NSString *)msg {
    return MIN(5, msg.length * 0.06 + 0.8);
}

@end
