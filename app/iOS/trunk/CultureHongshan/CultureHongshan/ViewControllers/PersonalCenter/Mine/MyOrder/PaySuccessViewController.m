

//
//  PaySuccessViewController.m
//  CultureHongshan
//
//  Created by ct on 17/2/23.
//  Copyright © 2017年 CT. All rights reserved.
//

#import "PaySuccessViewController.h"
#import "PrepayOrderModel.h"

#define kMargin   20

@interface PaySuccessViewController ()
{
    NSMutableArray *_dataList;
    NSDictionary *_orderDict; // 订单字典
}

@end

@implementation PaySuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"支付成功";
    _scrollView.backgroundColor = kBgColor;
    _dataList = [NSMutableArray arrayWithCapacity:3];
    
    [self loadOrderInfoData];
}


- (void)loadOrderInfoData {
    [self handleData];
    [self loadUI];
}



- (void)handleData {
    NSMutableArray *orderBasicInfos = [NSMutableArray arrayWithCapacity:4];
    
    if (self.model.venueName.length) {
        [orderBasicInfos addObject:@[@"场    馆：", self.model.venueName]];
    }else if (self.model.activityAddress.length) {
        [orderBasicInfos addObject:@[@"地    址：", self.model.activityAddress]];
    }
    
    if (self.model.activityDate.length) {
        [orderBasicInfos addObject:@[@"日    期：", self.model.activityDate]];
    }
    
    if (self.model.activitySeats.length) {
        [orderBasicInfos addObject:@[@"座    位：", self.model.activitySeats]];
    }else {
        [orderBasicInfos addObject:@[@"人    数：", StrFromLong(self.model.peopleCount)]];
    }
    
    if (self.model.orderContacts.length) {
        [orderBasicInfos addObject:@[@"联系人：", self.model.orderContacts]];
    }
    _orderDict = @{
                   @"orderNum" : self.model.checkCode,
                   @"orderQrCodeUrl" : self.model.qrCodeImgUrl
                   };
    
    [_dataList addObject:orderBasicInfos];
}




- (void)loadUI {
    WS(weakSelf)
    // 进入我的订单
    
    MYSmartButton *lookOrderBtn = [[MYSmartButton alloc] initWithFrame:CGRectZero title:@"进入我的订单" font:FontYT(17) tColor:kThemeDeepColor bgColor:kBgColor actionBlock:^(MYSmartButton *sender) {
        [weakSelf lookMyOrders];
    }];
    [self.view addSubview:lookOrderBtn];
    
    MYMaskView *line = [MYMaskView maskViewWithBgColor:RGB(218, 218, 218) frame:CGRectZero radius:0];
    [lookOrderBtn addSubview:line];
    
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.top.equalTo(weakSelf.view);
        make.bottom.equalTo(lookOrderBtn.mas_top);
    }];
    
    [lookOrderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.bottom.equalTo(weakSelf.view);
        make.height.mas_offset(50);
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.7);
        make.left.right.and.top.equalTo(lookOrderBtn);
    }];
    
    
    
    UIView *successView = [self loadSuccessView];
    UIView *basicInfoView = [self loadOrderBasicInfoView];
    UIView *qrCodeView = [self loadOrderQRCodeView];
    
    MYMaskView *whiteView = [MYMaskView maskViewWithBgColor:kWhiteColor frame:CGRectZero radius:0];
    [_scrollView addSubview:whiteView];
    
    [successView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.view);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(92);
    }];
    
    [basicInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(successView.mas_bottom);
        make.left.and.right.equalTo(weakSelf.view);
    }];
    
    [qrCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(basicInfoView.mas_bottom).offset(7);
        make.left.and.right.equalTo(weakSelf.view);
        make.bottom.equalTo(_scrollView).offset(-20);
    }];
    
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(qrCodeView.mas_bottom);
        make.left.and.right.equalTo(weakSelf.view);
        make.height.mas_equalTo(300);
    }];
}

- (UIView *)loadSuccessView {
    MYMaskView *bgView = [MYMaskView maskViewWithBgColor:kThemeDeepColor frame:CGRectZero radius:0];
    [_scrollView addSubview:bgView];
    
    MYBoldLabel *successLabel = [MYBoldLabel new];
    successLabel.spacingOfLine = 0;
    successLabel.numberOfLines = 1;
    successLabel.textColor = kWhiteColor;
    successLabel.textAlignment = NSTextAlignmentCenter;
    successLabel.font = FontYT(21);
    successLabel.text = @"支付成功！";
    [bgView addSubview:successLabel];
    
    [successLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(bgView);
        make.centerY.equalTo(bgView);
    }];
    
    return bgView;
}

/** 订单基本信息 */
- (UIView *)loadOrderBasicInfoView {
    MYMaskView *bgView = [MYMaskView maskViewWithBgColor:kWhiteColor frame:CGRectZero radius:0];
    [_scrollView addSubview:bgView];
    
    MYSmartLabel *titleLabel = [MYSmartLabel al_labelWithMaxRow:5 text:self.model.activityName font:FontYT(16) color:kDeepLabelColor lineSpacing:4];
    [bgView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).offset(kMargin);
        make.right.equalTo(bgView).offset(-kMargin);
        make.top.mas_equalTo(17.5);
    }];
    
    UIView *preView = nil;
    CGFloat leftLabelWidth = [UIToolClass textWidth:@"联系人：" font:FontYT(15)]+2;
    for (NSArray *itemArray in _dataList[0]) {
        NSString *leftTitle = itemArray[0];
        NSString *rightTitle = itemArray[1];
        
        MYSmartLabel *leftLabel = [MYSmartLabel al_labelWithMaxRow:1 text:leftTitle font:FontYT(15) color:kDeepLabelColor lineSpacing:0];
        [bgView addSubview:leftLabel];
        
        UIColor *rightLabelColor = [leftTitle hasPrefix:@"座"] ? kThemeDeepColor : kDeepLabelColor;
        MYSmartLabel *rightLabel = [MYSmartLabel al_labelWithMaxRow:10 text:rightTitle font:FontYT(15) color:rightLabelColor lineSpacing:4];
        [bgView addSubview:rightLabel];
        
        [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bgView).offset(kMargin);
            make.width.mas_equalTo(leftLabelWidth);
            if (preView) {
                make.top.equalTo(preView.mas_bottom).offset(10);
            }else {
                make.top.equalTo(titleLabel.mas_bottom).offset(16);
            }
        }];
        [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(bgView).offset(-kMargin);
            make.left.equalTo(leftLabel.mas_right).offset(4);
            make.top.equalTo(leftLabel);
        }];
        
        
        preView = rightLabel;
    }
    
    [preView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bgView.mas_bottom).offset(-21);
    }];
    
    return bgView;
}

/** 订单号以及二维码视图 */
- (UIView *)loadOrderQRCodeView {
    MYMaskView *bgView = [MYMaskView maskViewWithBgColor:kWhiteColor frame:CGRectZero radius:0];
    [_scrollView addSubview:bgView];
    
    // 取票码
    MYSmartLabel *leftLabel = [MYSmartLabel al_labelWithMaxRow:1 text:@"取票码：" font:FontYT(15) color:kDeepLabelColor lineSpacing:0];
    [bgView addSubview:leftLabel];
    
    MYSmartLabel *ticketNumLabel = [MYSmartLabel al_labelWithMaxRow:2 text:[ToolClass getSpaceSeparatedString:_orderDict[@"orderNum"] length:4] font:leftLabel.font color:kDarkRedColor lineSpacing:0];
    [bgView addSubview:ticketNumLabel];
    
    UIImageView *qrCodeView = [UIImageView new];
    UIImage *placeImg = [UIToolClass getPlaceholderWithViewSize:CGSizeMake(145, 145) centerSize:CGSizeMake(30, 30) isBorder:YES];
    [qrCodeView sd_setImageWithURL:[NSURL URLWithString:_orderDict[@"orderQrCodeUrl"]] placeholderImage:placeImg];
    [bgView addSubview:qrCodeView];
    
    MYSmartLabel *tipLabel = [MYSmartLabel al_labelWithMaxRow:2 text:@"出示二维码或取票码验证使用" font:FontYT(13) color:kDeepLabelColor lineSpacing:3 align:NSTextAlignmentCenter breakMode:NSLineBreakByTruncatingTail];
    [bgView addSubview:tipLabel];
    
    
    CGFloat leftLabelWidth = [UIToolClass textWidth:@"联系人：" font:FontYT(15)]+2;
    [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).offset(kMargin);
        make.top.equalTo(bgView).offset(18);
        make.width.mas_equalTo(leftLabelWidth);
    }];
    
    [ticketNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bgView).offset(-kMargin);
        make.left.equalTo(leftLabel.mas_right).offset(4);
        make.top.equalTo(leftLabel);
    }];
    
    [qrCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgView);
        make.size.mas_equalTo(CGSizeMake(142, 142));
        make.top.equalTo(ticketNumLabel.mas_bottom).offset(10);
    }];
    
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgView);
        make.top.equalTo(qrCodeView.mas_bottom).offset(10);
        make.left.equalTo(bgView).offset(kMargin);
        make.right.equalTo(bgView).offset(-kMargin);
        make.bottom.equalTo(bgView).offset(-46);
    }];
    
    return bgView;
}

#pragma mark -


/** 查看我的订单 */
- (void)lookMyOrders {
    // 0-待审核  1-待参加  2-历史  3-待支付
    [PageAccessTool accessAppPage:AppPageTypeOrderList url:@"1" navVC:self.navigationController sourceType:1 extParams:nil];
}

- (void)popViewController {
    for (NSInteger i = self.navigationController.viewControllers.count-3 ; i > 0; i--) {
        UIViewController *vc = self.navigationController.viewControllers[i];
        if ([vc isKindOfClass:NSClassFromString(@"MyOrderViewController")] ||
            [vc isKindOfClass:NSClassFromString(@"ActivityDetailViewController")] ||
            [vc isKindOfClass:NSClassFromString(@"ActivityOrderDetailViewController")]
            )
        {
            // 跳转到订单列表、活动详情、订单详情
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
