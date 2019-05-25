//
//  NoDataNoticeCell.m
//  CultureHongshan
//
//  Created by ct on 16/8/5.
//  Copyright © 2016年 CT. All rights reserved.
//

#import "NoDataNoticeCell.h"

@interface NoDataNoticeCell ()

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) MYSmartButton *actionButton;
@property (nonatomic, strong) MYSmartLabel *msgLabel;

@property (nonatomic, copy) void(^actionHandler)();
@end


@implementation NoDataNoticeCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = kWhiteColor;
        
        self.textLabel.font = FontYT(17);
        self.textLabel.textColor = kDeepLabelColor;
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        MYMaskView *bgView = [MYMaskView maskViewWithBgColor:kWhiteColor frame:CGRectZero radius:0];
        [self.contentView addSubview:bgView];
        
        
        self.imgView = [UIImageView new];
        [bgView addSubview:self.imgView];
        
        self.msgLabel = [MYSmartLabel al_labelWithMaxRow:5 text:@"" font:FontYT(15) color:kLightLabelColor lineSpacing:4 align:NSTextAlignmentCenter breakMode:NSLineBreakByTruncatingTail];
        [bgView addSubview:self.msgLabel];
        
        WS(weakSelf)
        self.actionButton = [[MYSmartButton alloc] initWithFrame:CGRectZero title:@"点击刷新" font:FontYT(13) tColor:kLightLabelColor bgColor:nil actionBlock:^(MYSmartButton *sender) {
            if (weakSelf.actionHandler) { weakSelf.actionHandler(); }
        }];
        self.actionButton.radius = 3;
        self.actionButton.layer.borderColor = kLightLabelColor.CGColor;
        self.actionButton.layer.borderWidth = 0.8;
        [bgView addSubview:self.actionButton];
        
        
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf.contentView);
            make.left.and.right.equalTo(weakSelf.contentView);
        }];
        
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(bgView);
            make.top.equalTo(bgView).offset(0);
            make.height.mas_lessThanOrEqualTo(weakSelf.contentView.mas_height).multipliedBy(0.45);
        }];
        
        [self.msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(bgView);
            make.width.equalTo(bgView).multipliedBy(0.8);
            make.top.equalTo(weakSelf.imgView.mas_bottom).offset(5);
        }];
        
        [self.actionButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(ConvertSize(200));
            make.height.mas_equalTo(28);
            make.centerX.equalTo(bgView);
            make.top.equalTo(weakSelf.msgLabel.mas_bottom).offset(15);
            make.bottom.equalTo(bgView).offset(-10);
        }];
    }
    return self;
}




- (void)setPromptStyle:(NoDataPromptStyle)style message:(NSString *)msg actionHandler:(void (^)())handler {
    
    if (style == NoDataPromptStyleClickRefreshForNoNetwork) {
        msg = @"咦～～怎么木有网了?";
        
        self.imgView.image = IMG(@"img_for_no_network");
        self.msgLabel.text = msg;
        self.actionHandler = handler;
        
    }else if (style == NoDataPromptStyleClickRefreshForNoContent) {
        if (msg.length==0) {
            msg = @"内容还在采集，请等等再来。";
        }
        
        self.imgView.image = IMG(@"img_for_no_content");
        self.msgLabel.text = msg;
        self.actionHandler = handler;
    }else {
        return;
    }
    
    WS(weakSelf)
    CGFloat scale = self.imgView.image.size.width / self.imgView.image.size.height;
    [self.imgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.imgView.superview);
        make.top.equalTo(weakSelf.imgView.superview).offset(0);
        make.width.equalTo(weakSelf.imgView.mas_height).multipliedBy(scale);
        make.height.mas_lessThanOrEqualTo(weakSelf.contentView.mas_height).multipliedBy(0.5);
        make.height.mas_equalTo(weakSelf.imgView.image.size.height).priorityMedium();
    }];
}



@end
