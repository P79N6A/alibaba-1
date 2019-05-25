//
//  PayFailureViewController.m
//  CultureHongshan
//
//  Created by ct on 17/2/23.
//  Copyright © 2017年 CT. All rights reserved.
//

#import "PayFailureViewController.h"


@interface PayFailureViewController ()
@property (nonatomic, copy) NSString *orderId;
@end

@implementation PayFailureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kWhiteColor;
    self.navigationItem.title = @"支付失败";
    [self loadUI];
}

- (void)loadUI {
    WS(weakSelf)
    
    MYMaskView *contentView = [MYMaskView maskViewWithBgColor:[UIColor clearColor] frame:CGRectZero radius:0];
    [self.view addSubview:contentView];
    
    // 图标
    UIImageView *iconView = [[UIImageView alloc] initWithImage:IMG(@"icon_pay_fail")];
    [contentView addSubview:iconView];
    
    self.payErrorMsg = @"支付失败，请重新返回支付。";
    
    // 错误消息Label
    NSTextAlignment align = [UIToolClass textWidth:self.payErrorMsg font:FontYT(15)] < kScreenWidth-40 ? NSTextAlignmentCenter : NSTextAlignmentLeft;
    MYSmartLabel *msgLabel = [MYSmartLabel al_labelWithMaxRow:10 text:self.payErrorMsg font:FontYT(15) color:kDeepLabelColor lineSpacing:4 align:align breakMode:NSLineBreakByTruncatingTail];
    [contentView addSubview:msgLabel];
    
    // 重新支付按钮
    MYSmartButton *repayBtn = [[MYSmartButton alloc] initWithFrame:CGRectZero title:@"重 新 支 付" font:FontYT(14) tColor:kDeepLabelColor bgColor:kWhiteColor actionBlock:^(MYSmartButton *sender) {
        [weakSelf repayOrder];
    }];
    repayBtn.layer.borderColor = RGB(151, 153, 167).CGColor;
    repayBtn.layer.borderWidth = 0.7;
    repayBtn.radius = 3;
    [contentView addSubview:repayBtn];
    
    // 进入我的订单
    MYSmartButton *lookOrderBtn = [[MYSmartButton alloc] initWithFrame:CGRectZero title:@"进入我的订单" font:FontYT(17) tColor:kThemeDeepColor bgColor:kBgColor actionBlock:^(MYSmartButton *sender) {
        [weakSelf lookMyOrders];
    }];
    lookOrderBtn.layer.borderColor = RGB(218, 218, 218).CGColor;
    lookOrderBtn.layer.borderWidth = 1;
    [self.view addSubview:lookOrderBtn];
    
    /********************* 添加约束 **********************/
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.centerY.equalTo(weakSelf.view).offset(-25);
        make.width.equalTo(weakSelf.view).offset(-40);
    }];
    
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.top.equalTo(contentView);
        make.size.mas_equalTo(iconView.image.size);
    }];
    
    [msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView);
        make.width.equalTo(contentView).offset(-10);
        make.top.equalTo(iconView.mas_bottom).offset(26);
    }];
    
    [repayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 28));
        make.centerX.equalTo(contentView);
        make.bottom.equalTo(contentView);
        make.top.equalTo(msgLabel.mas_bottom).offset(21);
    }];
    
    CGFloat borderWidth = lookOrderBtn.layer.borderWidth;
    [lookOrderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.view).offset(borderWidth);
        make.width.equalTo(weakSelf.view).offset(2 * borderWidth);
        make.centerX.equalTo(weakSelf.view);
        make.height.mas_equalTo(50+2*borderWidth);
    }];
}

/** 重新支付订单 */
- (void)repayOrder {
    if (self.repayHandler) {
        self.repayHandler();
    }
}

/** 查看我的订单 */
- (void)lookMyOrders {
    // 0-待审核  1-待参加  2-历史  3-待支付
    [PageAccessTool accessAppPage:AppPageTypeOrderList url:@"3" navVC:self.navigationController sourceType:1 extParams:nil];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}




@end
