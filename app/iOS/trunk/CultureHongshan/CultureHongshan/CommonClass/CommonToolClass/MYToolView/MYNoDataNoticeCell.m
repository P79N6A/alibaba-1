//
//  MYNoDataNoticeCell.m
//  CheckTicketSystem
//
//  Created by JackAndney on 2017/11/9.
//  Copyright © 2017年 Creatoo. All rights reserved.
//

#import "MYNoDataNoticeCell.h"

@interface MYNoDataNoticeCell ()
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) MYLabel *msgLabel;
@property (nonatomic, strong) MYButton *actionButton;
@property (nonatomic, assign) BOOL boolValue;
@property (nonatomic, assign) CGFloat floatValue;
@property (nonatomic, assign) NSInteger integerValue;

@end

@implementation MYNoDataNoticeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = kWhiteColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.iconView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.iconView];
        
        self.msgLabel = [[MYLabel alloc] initWithFrame:CGRectZero text:@"暂无数据" font:FONT(16) tColor:kDeepLabelColor lines:8 align:NSTextAlignmentCenter];
        [self.contentView addSubview:self.msgLabel];
        
        self.actionButton = [[MYButton alloc] initWithFrame:CGRectZero title:@"点击刷新" font:FONT(15) tColor:kWhiteColor bgColor:[UIColor blackColor]];
        self.actionButton.radius = 4;
        [self.actionButton addTarget:self action:@selector(actionButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.actionButton];
        
        WS(weakSelf)
        [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf.contentView);
            make.top.equalTo(weakSelf.contentView).offset(38);
        }];
    }
    return self;
}

- (void)setImage:(UIImage *)image andMsg:(NSString *)msg {
    self.iconView.image = image;
    self.msgLabel.text = msg;
    
    CGFloat btnWidth = [UIToolClass textWidth:self.actionButton.currentTitle font:self.actionButton.titleLabel.font] + 28;
    if (btnWidth < 90) {
        btnWidth = 90;
    }
    
    if (image) {
        [self.iconView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(image.size);
        }];
        
        WS(weakSelf)
        [self.msgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView).offset(35);
            make.right.equalTo(weakSelf.contentView).offset(-35);
            make.top.equalTo(weakSelf.iconView.mas_bottom).offset(10);
            if (weakSelf.actionButton.hidden == YES) {
                make.bottom.equalTo(weakSelf.contentView).offset(-38);
            }
        }];
        
        if (self.actionButton.hidden == NO) {
            [self.actionButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(btnWidth, 30));
                make.centerX.equalTo(weakSelf.contentView);
                make.top.equalTo(weakSelf.msgLabel.mas_bottom).offset(10);
                make.bottom.equalTo(weakSelf.contentView).offset(-38);
            }];
        }
        
    }else {
        WS(weakSelf)
        [self.iconView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGRectZero);
        }];
        
        if (self.actionButton.hidden == NO) {
            // 按钮和文字
            [self.msgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(weakSelf.contentView).offset(35);
                make.right.equalTo(weakSelf.contentView).offset(-35);
                make.top.equalTo(weakSelf.iconView);
            }];
            
            [self.actionButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(btnWidth, 30));
                make.centerX.equalTo(weakSelf.contentView);
                make.top.equalTo(weakSelf.msgLabel.mas_bottom).offset(10);
                make.bottom.equalTo(weakSelf.contentView).offset(-38);
            }];
            
        }else {
            // 只有文字
            [self.msgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(weakSelf.contentView).offset(35);
                make.right.equalTo(weakSelf.contentView).offset(-35);
                make.top.equalTo(weakSelf.iconView);
                make.bottom.equalTo(weakSelf.contentView).offset(-38);
            }];
        }
    }
}

- (void)showActionButton:(BOOL)show forIndexPath:(NSIndexPath *)indexPath {
    self.actionButton.hidden = !show;
    self.my_indexPath = indexPath;
}

- (void)updateActionButtonTitle:(NSString *)title {
    if (title.length > 0) {
        [self.actionButton setTitle:title forState:UIControlStateNormal];
        
        CGFloat btnWidth = [UIToolClass textWidth:self.actionButton.currentTitle font:self.actionButton.titleLabel.font] + 28;
        if (btnWidth < 90) {
            btnWidth = 90;
        }
        
        [self.actionButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(btnWidth);
        }];
    }
}

- (void)actionButtonClick {
    if (self.didClickBlock) {
        self.didClickBlock(self);
    }
}

@end
