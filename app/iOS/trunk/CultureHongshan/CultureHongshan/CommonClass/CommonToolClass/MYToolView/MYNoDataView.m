//
//  MYNoDataView.m
//  CultureHongshan
//
//  Created by JackAndney on 2017/11/22.
//  Copyright © 2017年 CT. All rights reserved.
//

#import "MYNoDataView.h"
#import "MYLabel.h"
#import "MYButton.h"


@interface MYNoDataView ()
{
    UIView *_contentView;
    
    UIImageView *_iconView;
    MYLabel *_msgLabel;
    UIButton *_actionButton;
}
@property (nonatomic, weak) id<MYNoDataViewDelegate> delegate;
@end

@implementation MYNoDataView

- (instancetype)initWithMessage:(NSString *)msg iconImage:(UIImage *)iconImage buttonTitle:(NSString *)btnTitle delegate:(id<MYNoDataViewDelegate>)delegate {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.delegate = delegate;
        
        self.fullViewClickable = NO;
        self.spacingOfImgAndMsg = 5;
        self.spacingOfMsgAndBtn = 22;
        self.btnHeight = 28;
        
        _contentView = [UIView new];
        [self addSubview:_contentView];
        
        if (iconImage) {
            _iconView = [[UIImageView alloc] initWithImage:iconImage];
            [_contentView addSubview:_iconView];
        }
        
        if (msg.length > 0) {
            _msgLabel = [[MYLabel alloc] initWithFrame:CGRectZero text:msg font:FontYT(15) tColor:RGB(0x75, 0x75, 0x75) lines:4 align:NSTextAlignmentCenter];
            _msgLabel.boldText = YES;
            _msgLabel.line_spacing = 5;
            [_msgLabel updateText:msg];
            [_contentView addSubview:_msgLabel];
        }
        
        if (btnTitle == nil || btnTitle.length == 0) {
            btnTitle = @"重新加载";
        }
        
        self.actionLabel = [[MYLabel alloc] initWithFrame:CGRectZero text:nil font:FontYT(13) tColor:RGB(0x75, 0x75, 0x75) lines:3 align:NSTextAlignmentCenter];
        self.actionLabel.textColor = _msgLabel.textColor;
        self.actionLabel.layer.borderColor = self.actionLabel.textColor.CGColor;
        self.actionLabel.layer.borderWidth = 0.8;
        self.actionLabel.layer.masksToBounds = YES;
        self.actionLabel.layer.cornerRadius = 3;
        self.actionLabel.text = btnTitle;
        [_contentView addSubview:self.actionLabel];
        
        _actionButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_actionButton addTarget:self action:@selector(actionButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_actionButton];
     
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self).multipliedBy(0.75f);
            make.centerX.equalTo(self);
            make.centerY.equalTo(self);
        }];
        
        [self updateViewConstrains];
        
    }
    return self;
}


- (void)reloadSubviews {
    [self updateViewConstrains];
}

// 更新视图约束
- (void)updateViewConstrains {
    if (self.centerOffsetY != 0) {
        [_contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self).offset(self.centerOffsetY);
        }];
    }
    
    if (_iconView) {
        [_iconView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_contentView);
            make.size.mas_equalTo(_iconView.image.size);
            make.centerX.equalTo(_contentView);
        }];
    }
    
    if (_msgLabel) {
        [_msgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (_iconView) {
                make.top.equalTo(_iconView.mas_bottom).offset(self.spacingOfImgAndMsg);
            }else {
                make.top.equalTo(_contentView);
            }
            make.left.equalTo(_contentView).offset(10);
            make.right.equalTo(_contentView).offset(-10);
        }];
    }
    
    CGFloat textWidth = ceil([_actionLabel.text sizeWithAttributes:@{NSFontAttributeName : _actionLabel.font}].width) + 2 + 30;
    if (textWidth < 90) {
        textWidth = 90; // 防止宽度过小
    }
    [_actionLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_contentView);
        make.width.lessThanOrEqualTo(_contentView).offset(-40);
        make.width.mas_equalTo(textWidth).priorityMedium();
        make.height.mas_equalTo(self.btnHeight);
        make.bottom.equalTo(_contentView);
        
        if (_msgLabel) {
            make.top.equalTo(_msgLabel.mas_bottom).offset(self.spacingOfMsgAndBtn);
        }else if (_iconView) {
            make.top.equalTo(_iconView.mas_bottom).offset(self.spacingOfMsgAndBtn);
        }else {
            make.top.equalTo(_contentView);
        }
    }];
    
    if (self.fullViewClickable) {
        [_actionButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
    }else {
        [_actionButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_actionLabel);
            make.width.equalTo(_actionLabel).offset(40);
            make.height.equalTo(_actionLabel).offset(20);
        }];
    }
}


#pragma mark -


- (void)showInView:(UIView *)parentView {
    [self showInView:parentView topView:nil];
}

- (void)showInView:(UIView *)parentView topView:(UIView *)topView {
    if (parentView == nil) {
        return;
    }
    [parentView addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.bottom.equalTo(parentView);
        if (topView) {
            make.top.equalTo(topView.mas_bottom);
        }else {
            make.top.equalTo(parentView);
        }
    }];
}

- (void)actionButtonClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(noDataView:didClickButton:)]) {
        if (_actionLabel.attributedText.length > 0) {
            [self.delegate noDataView:self didClickButton:_actionLabel.attributedText.string];
        }else {
            [self.delegate noDataView:self didClickButton:_actionLabel.text];
        }
    }
    [self removeFromSuperview];
}

@end
