//
//  WaitPayViewController.m
//  CultureHongshan
//
//  Created by ct on 17/2/17.
//  Copyright © 2017年 CT. All rights reserved.
//

#import "WaitPayViewController.h"
#import "PayService.h"
#import "CustomAlertView.h"

#import "PrepayOrderModel.h"
#import "OrderPayModel.h"

#import "PayFailureViewController.h"
#import "PaySuccessViewController.h"

#define kMargin   20
#define kBaseTag  200

@interface WaitPayViewController ()
{
    NSMutableArray *_dataList;
    
    MYSmartLabel *_countdownLabel; // 倒计时Label
    MYSmartButton *_wechatPayBtn; // 微信支付按钮
    MYSmartButton *_alipayBtn; // 支付宝支付按钮
    MYSmartButton *_paymentButton; // 立即支付按钮
    
    long _remainedTime;
    BOOL _queryPayResultTimeout; //  查询订单支付结果超时
    BOOL _orderClientPaySuccess; // 订单是否已在客户端支付成功
}

@property (nonatomic, strong) CustomAlertView *payWaitView; // 查询支付结果等待视图
@property (nonatomic, strong) PrepayOrderModel *prepayModel;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSTimer *requestTimer; // 定时请求接口定时器
@end



@implementation WaitPayViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"等待支付";
    _dataList = [NSMutableArray arrayWithCapacity:2];
    
    [self loadPrepayOrderInfo];
    
}

- (void)handleData {
    
    NSMutableArray *orderBasicInfos = [NSMutableArray arrayWithCapacity:4];
    NSMutableArray *priceRelatedInfos = [NSMutableArray arrayWithCapacity:3];
    
    if (self.prepayModel.venueName.length) {
        [orderBasicInfos addObject:@[@"场    馆：", self.prepayModel.venueName]];
    }else if (self.prepayModel.activityAddress.length) {
        [orderBasicInfos addObject:@[@"地    址：", self.prepayModel.activityAddress]];
    }
    
    if (self.prepayModel.activityDate.length) {
        [orderBasicInfos addObject:@[@"日    期：", self.prepayModel.activityDate]];
    }
    
    if (self.prepayModel.activitySeats.length) {
        [orderBasicInfos addObject:@[@"座    位：", self.prepayModel.activitySeats]];
    }else {
        [orderBasicInfos addObject:@[@"人    数：", StrFromLong(self.prepayModel.peopleCount)]];
    }
    
    if (self.prepayModel.orderContacts.length) {
        [orderBasicInfos addObject:@[@"联系人：", self.prepayModel.orderContacts]];
    }
    
    [priceRelatedInfos addObject:@[@"票    价：", [NSString stringWithFormat:@"￥%.2lf", self.prepayModel.activityUnitPrice]]];
    [priceRelatedInfos addObject:@[@"数    量：", [NSString stringWithFormat:@"x %ld", (long)self.prepayModel.peopleCount]]];
    [priceRelatedInfos addObject:@[@"总    价：", [NSString stringWithFormat:@"￥%.2lf", (self.prepayModel.activityUnitPrice * self.prepayModel.peopleCount)]]];
    
    [_dataList addObject:orderBasicInfos];
    [_dataList addObject:priceRelatedInfos];
}

/** 加载预支付信息 */
- (void)loadPrepayOrderInfo {
    
    [SVProgressHUD showLoading];
    
    WS(weakSelf)
    [AppProtocol getPrepayInfoWithDataType:self.dataType orderId:self.orderId UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        if (responseCode == HttpResponseSuccess) {
            weakSelf.prepayModel = responseObject;
            _remainedTime = weakSelf.prepayModel.remainedTime;
            
            [SVProgressHUD dismiss];
            [weakSelf handleData];
            [weakSelf loadUI];
            [weakSelf payForOrderCountDown:nil];
        }else {
            [SVProgressHUD dismiss];
            
            [weakSelf showErrorMessage:responseObject frame:CGRectMake(0, 0, kScreenWidth, HEIGHT_TOP_BAR-HEIGHT_HOME_INDICATOR) promptStyle:NoDataPromptStyleClickRefreshForError parentView:weakSelf.view callbackBlock:^(id object, NSInteger index, BOOL isSameIndex) {
                [weakSelf loadPrepayOrderInfo];
            }];
        }
    }];
}

/** 获取订单支付所需要的参数 */
- (void)loadOrderPayParamWithPayPlatform:(PayPlatformType)payType completionHandler:(void(^)(BOOL success, OrderPayModel *payModel))handler {
    [AppProtocol getOrderPayParamsWithOrderId:self.orderId payType:payType UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        if (responseCode == HttpResponseSuccess) {
            
            if (handler) { handler(YES, responseObject); }
            
        }else {
            [SVProgressHUD showInfoWithStatus:responseObject];
            if (handler) {
                handler(NO, responseObject);
            }
        }
    }];
}

- (void)loadOrderPayResultData {
    
    WS(weakSelf)
    [AppProtocol getOrderPayResultWithOrderId:self.orderId UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        if (responseCode == HttpResponseSuccess) {
            [weakSelf orderPaySuccess:responseObject];
        }else {
            if (_queryPayResultTimeout) {
                [SVProgressHUD showInfoWithStatus:@"查询订单支付结果失败，请稍后重试!"];
            }
        }
    }];
}

#pragma mark -

- (void)loadUI {
    
    WS(weakSelf)
    
    // 立即支付按钮
    _paymentButton = [[MYSmartButton alloc] initWithFrame:CGRectZero title:@"立 即 支 付" font:FontYT(17) tColor:kWhiteColor bgColor:kThemeDeepColor actionBlock:^(MYSmartButton *sender) {
        [weakSelf goToPay:sender];
    }];
    [self.view addSubview:_paymentButton];
    
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.top.equalTo(weakSelf.view);
        make.bottom.equalTo(_paymentButton.mas_top);
    }];
    
    [_paymentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view).offset(-HEIGHT_HOME_INDICATOR);
        make.height.mas_equalTo(50);
    }];
    
    
    UIView *timeNoticeView = [self loadTimeNoticeView];
    UIView *basicInfoView = [self loadOrderBasicInfoView];
    UIView *priceRelatedView = [self loadOrderPriceRelatedView];
    UIView *paymentMethodView = [self loadOrderPaymentMethodView];
    
    [basicInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(timeNoticeView.mas_bottom);
        make.left.and.right.equalTo(weakSelf.view);
    }];
    
    [priceRelatedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(basicInfoView.mas_bottom).offset(7);
        make.left.and.right.equalTo(weakSelf.view);
    }];
    
    [paymentMethodView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(priceRelatedView.mas_bottom).offset(7);
        make.left.and.right.equalTo(weakSelf.view);
        make.bottom.equalTo(_scrollView).offset(-20);
    }];
}


/** 15分钟内付款提示 */
- (UIView *)loadTimeNoticeView {
    MYMaskView *bgView = [MYMaskView maskViewWithBgColor:kThemeDeepColor frame:CGRectZero radius:0];
    [_scrollView addSubview:bgView];
    
    MYMaskView *contentView = [MYMaskView maskViewWithBgColor:[UIColor clearColor] frame:CGRectZero radius:0];
    [bgView addSubview:contentView];
    
    MYSmartLabel *leftLabel = [MYSmartLabel al_labelWithMaxRow:1 text:@"请在" font:FONT(14) color:kWhiteColor lineSpacing:0];
    [bgView addSubview:leftLabel];
    
    _countdownLabel = [MYSmartLabel al_labelWithMaxRow:1 text:@"15:00" font:FontYT(14) color:kOrangeYellowColor lineSpacing:0 align:NSTextAlignmentCenter breakMode:NSLineBreakByTruncatingTail];
    [bgView addSubview:_countdownLabel];
    
    MYSmartLabel *rightLabel = [MYSmartLabel al_labelWithMaxRow:1 text:@"内完成付款，逾期订单将自动取消。" font:FONT(14) color:kWhiteColor lineSpacing:0];
    [bgView addSubview:rightLabel];
    
    WS(weakSelf)
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.left.and.right.equalTo(weakSelf.view);
    }];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgView);
        make.centerY.equalTo(bgView);
        make.top.bottom.equalTo(bgView);
    }];
    
    
    CGFloat textWidth = [UIToolClass textWidth:@"99:99" font:_countdownLabel.font]+2;
    [_countdownLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftLabel.mas_right);
        make.width.mas_equalTo(textWidth);
        make.top.equalTo(contentView);
        make.centerY.equalTo(contentView);
    }];
    
    [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(8);
        make.centerY.equalTo(contentView);
    }];
    [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_countdownLabel.mas_right);
        make.right.equalTo(contentView).offset(-8);
        make.centerY.equalTo(contentView);
        
        make.top.equalTo(contentView).offset(20);
        make.bottom.equalTo(contentView).offset(-20);
    }];
    
    return bgView;
}

/** 订单基本信息 */
- (UIView *)loadOrderBasicInfoView {
    MYMaskView *bgView = [MYMaskView maskViewWithBgColor:kWhiteColor frame:CGRectZero radius:0];
    [_scrollView addSubview:bgView];
    
    MYSmartLabel *titleLabel = [MYSmartLabel al_labelWithMaxRow:5 text:self.prepayModel.activityName font:FontYT(16) color:kDeepLabelColor lineSpacing:4];
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

/** 支付票价相关信息 */
- (UIView *)loadOrderPriceRelatedView {
    MYMaskView *bgView = [MYMaskView maskViewWithBgColor:kWhiteColor frame:CGRectZero radius:0];
    [_scrollView addSubview:bgView];
    
    UIView *preView = nil;
    CGFloat leftLabelWidth = [UIToolClass textWidth:@"联系人：" font:FontYT(15)]+2;
    for (NSArray *itemArray in _dataList[1]) {
        NSString *leftTitle = itemArray[0];
        NSString *rightTitle = itemArray[1];
        
        MYSmartLabel *leftLabel = [MYSmartLabel al_labelWithMaxRow:1 text:leftTitle font:FontYT(15) color:kDeepLabelColor lineSpacing:0];
        [bgView addSubview:leftLabel];
        
        UIColor *rightLabelColor = ([leftTitle hasPrefix:@"积"] || [leftTitle hasPrefix:@"总"]) ? kDarkRedColor : kDeepLabelColor;
        MYSmartLabel *rightLabel = [MYSmartLabel al_labelWithMaxRow:10 text:rightTitle font:FontYT(15) color:rightLabelColor lineSpacing:4 align:NSTextAlignmentRight breakMode:NSLineBreakByClipping];
        [bgView addSubview:rightLabel];
        
        [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bgView).offset(kMargin);
            make.width.mas_equalTo(leftLabelWidth);
            if (preView) {
                make.top.equalTo(preView.mas_bottom).offset(10);
            }else {
                make.top.equalTo(bgView).offset(17);
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

/** 订单付款方式 */
- (UIView *)loadOrderPaymentMethodView {
    MYMaskView *bgView = [MYMaskView maskViewWithBgColor:kWhiteColor frame:CGRectZero radius:0];
    [_scrollView addSubview:bgView];
    
    MYSmartLabel *paymentLabel = [MYSmartLabel al_labelWithMaxRow:1 text:@"支付方式：" font:FontYT(16) color:kDeepLabelColor lineSpacing:0];
    [bgView addSubview:paymentLabel];
    
    MYMaskView *line = [MYMaskView maskViewWithBgColor:kLineGrayColor frame:CGRectZero radius:0];
    [bgView addSubview:line];
    
    NSArray *paymentMethods = @[
                                @[@"icon_pay_alipay", @"支付宝支付"],
                                @[@"icon_pay_wechat", @"微信支付"],
                                ];
    
    UIView *preView = nil;
    WS(weakSelf)
    UIImage *normalImage = IMG(@"icon_payment_normal");
    UIImage *selectedImage = IMG(@"icon_payment_select");
    CGSize imgSize = selectedImage.size;
    CGFloat halfFontHeight = [UIToolClass fontHeight:FontYT(14)]/2;
    
    for (int i = 0; i < paymentMethods.count; i++) {
        UIImage *iconImage = IMG(paymentMethods[i][0]);
        NSString *payTitle = paymentMethods[i][1];
        
        UIImageView *iconView = [[UIImageView alloc] initWithImage:iconImage];
        [bgView addSubview:iconView];
        
        MYSmartLabel *payLabel = [MYSmartLabel al_labelWithMaxRow:2 text:payTitle font:FontYT(14) color:kDeepLabelColor lineSpacing:4];
        [bgView addSubview:payLabel];
        
        
        MYSmartButton *payButton = [[MYSmartButton alloc] initWithFrame:CGRectZero image:normalImage selectedImage:selectedImage actionBlock:^(MYSmartButton *sender) {
            [weakSelf choosePaymentMethod:sender];
        }];
        payButton.tag = kBaseTag + i;
        payButton.selected = i==0;
        [bgView addSubview:payButton];
        
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(paymentLabel);
            make.centerY.equalTo(payLabel.mas_top).offset(halfFontHeight);
            make.size.mas_equalTo(iconView.image.size);
        }];
        
        [payLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(iconView.mas_right).offset(12);
            if (preView) {
                make.top.equalTo(preView.mas_bottom).offset(21);
            }else {
                make.top.equalTo(line.mas_bottom).offset(21);
            }
        }];
        
        [payButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(bgView).offset(0);
            make.size.mas_equalTo(CGSizeMake(imgSize.width + 2*15, imgSize.height + 2*15));
            make.centerY.equalTo(iconView);
        }];
        
        MYMaskView *line1 = [MYMaskView maskViewWithBgColor:kLineGrayColor frame:CGRectZero radius:0];
        [bgView addSubview:line1];
        [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(iconView.mas_right).offset(7);
            make.right.equalTo(bgView).offset(-10);
            make.height.mas_equalTo(0.8);
            make.top.equalTo(iconView.mas_bottom).offset(14);
        }];
        
        preView = line1;
    }
    
    [preView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bgView).offset(-20);
    }];
    preView.hidden = YES;
    
    [paymentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView).offset(19);
        make.left.equalTo(bgView).offset(10);
        make.right.equalTo(bgView).offset(-10);
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).offset(9);
        make.right.equalTo(bgView).offset(-9);
        make.height.mas_equalTo(1);
        make.top.equalTo(paymentLabel.mas_bottom).offset(13);
    }];
    
    return bgView;
}


/** 选择支付方式 */
- (void)choosePaymentMethod:(MYSmartButton *)sender {
    if (sender.selected) return;
    
    for (int i = 0; i < 2; i++) {
        MYSmartButton *button = [sender.superview viewWithTag:kBaseTag + i];
        if ([button isKindOfClass:[UIButton class]]) {
            if (button.tag == sender.tag) {
                button.selected = YES;
            }else {
                button.selected = NO;
            }
        }
    }
}


#pragma mark - 

/** 订单支付倒计时 */
- (void)payForOrderCountDown:(NSTimer *)timer
{
    if (self.prepayModel) {
        if (timer.userInfo) {
            _remainedTime--;
            if (_remainedTime <= 0) {
                [timer invalidate];
                timer = nil;
                _countdownLabel.text = @"00:00";
                _paymentButton.userInteractionEnabled = NO;
                [_paymentButton setTitleColor:kBlackColor forState:UIControlStateNormal];
                _paymentButton.backgroundColor = kLineGrayColor;
                return;
            }
            
            NSString *timeString = [NSString stringWithFormat:@"%02ld:%02ld", _remainedTime/60, _remainedTime - (_remainedTime/60) * 60];
            _countdownLabel.text = timeString;
        }else {
            if (_timer) {
                [_timer invalidate];
                _timer = nil;
            }
            _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(payForOrderCountDown:) userInfo:@"countdown" repeats:YES];
            [_timer fire];
        }
    }
}




- (void)goToPay:(UIButton *)sender {
    
    NSInteger selectBtnIndex = -1;
    for (int i = 0; i < 2; i++) {
        UIButton *button = [self.view viewWithTag:kBaseTag + i];
        if ([button isKindOfClass:[UIButton class]] && button.selected) {
            selectBtnIndex = i;
            break;
        }
    }
    
    if (selectBtnIndex < 0) {
        [SVProgressHUD showInfoWithStatus:@"请选择支付方式！"];
        return;
    }
    
    PayPlatformType payType = PayPlatformTypeUnknown;
    if (selectBtnIndex == 0) { // 支付宝在第一个位置
        payType = PayPlatformTypeAliPay;
    }else if (selectBtnIndex == 1) {
        payType = PayPlatformTypeWeiXin;
    }
    
    _paymentButton.userInteractionEnabled = NO;
    _orderClientPaySuccess = NO;
    
    WS(weakSelf)
    [self loadOrderPayParamWithPayPlatform:payType completionHandler:^(BOOL success, OrderPayModel *payModel) {
        _paymentButton.userInteractionEnabled = YES;
        if (success) {
            
            NSMutableDictionary *payParams = [NSMutableDictionary dictionaryWithCapacity:6];
            
            if (payType == PayPlatformTypeWeiXin) {
                [payParams setValue:payModel.partnerId forKey:@"partnerId"];
                [payParams setValue:payModel.prepayId forKey:@"prepayId"];
                [payParams setValue:payModel.nonceStr forKey:@"nonceStr"];
                [payParams setValue:payModel.timeStamp forKey:@"timeStamp"];
                [payParams setValue:payModel.package forKey:@"package"];
                [payParams setValue:payModel.sign forKey:@"sign"];
            }else if (payType == PayPlatformTypeAliPay) {
                [payParams setValue:payModel.orderInfo forKey:@"orderInfo"];
            }
            
            [PayService payWithPlatformType:payType payParams:payParams completionHandler:^(NSInteger statusCode, id result) {
                if (statusCode == 1) { // 支付成功
                    [weakSelf queryOrderPayResult:YES];
                }else if (statusCode == 2) { // 支付失败
                    PayFailureViewController *vc = [PayFailureViewController new];
                    vc.payErrorMsg = result;
                    vc.repayHandler = ^() {
                        [weakSelf goToPay:nil];
                        [weakSelf.navigationController popViewControllerAnimated:NO];
                    };
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }else if (statusCode == 3) { // 用户取消
                    [WHYAlertActionUtil showAlertWithTitle:@"支付结果提示" msg:result actionBlock:^(NSInteger index, NSString *buttonTitle) {
                        
                    } buttonTitles:@"知道了", nil];
                }
            }];
        }
    }];
}

/** 查询订单支付结果 */
- (void)queryOrderPayResult:(BOOL)firstRequest {
    if (firstRequest) {
        self.payWaitView = [CustomAlertView showAlertWithStyle:MYAlertStylePaying animated:NO];
        
        if (self.requestTimer == nil) {
            self.requestTimer = [NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(requestEveryTwoSecond) userInfo:nil repeats:YES];
            [self.requestTimer fire];
        }
        
        [self performSelector:@selector(payOrderFailedForLongTime) withObject:nil afterDelay:10]; // afterDelay:3
    }else {
        [self loadOrderPayResultData];
    }
}

- (void)requestEveryTwoSecond {
    [self loadOrderPayResultData];
    if (_queryPayResultTimeout) {
        [self.requestTimer invalidate];
        self.requestTimer = nil;
    }
}



/** 长时间未获取到支付结果 */
- (void)payOrderFailedForLongTime {
    [self.payWaitView dismiss];
    
    _queryPayResultTimeout = YES;
    [WHYAlertActionUtil showAlertWithTitle:@"温馨提示" msg:@"查询订单支付结果失败，请稍后重试!" actionBlock:^(NSInteger index, NSString *buttonTitle){
        
    } buttonTitles:@"知道了", nil];
}


/** 订单支付成功 */
- (void)orderPaySuccess:(PrepayOrderModel *)model {
    if (![[self.navigationController.viewControllers lastObject] isKindOfClass:self.class]) {
        return;
    }
    
    [self.class cancelPreviousPerformRequestsWithTarget:self selector:@selector(payOrderFailedForLongTime) object:nil];
    [self.requestTimer invalidate];
    self.requestTimer = nil;
    _orderClientPaySuccess = YES;
    
    PaySuccessViewController *vc = [PaySuccessViewController new];
    vc.orderId = self.orderId;
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
    
    [self.payWaitView dismiss];
}

- (void)popViewController {
    if (_timer) {
        [_timer invalidate];
        self.timer = nil;
    }
    if (self.requestTimer) {
        [self.requestTimer invalidate];
        self.requestTimer = nil;
    }
    
    if (self.navigationController.viewControllers.count > 2) {
        UIViewController *actDetailVC = self.navigationController.viewControllers[self.navigationController.viewControllers.count-3];
        if ([actDetailVC isKindOfClass:NSClassFromString(@"ActivityDetailViewController")]) {
            [self.navigationController popToViewController:actDetailVC animated:YES];
            return;
        }
    }
    
    [super popViewController];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
/*
 
 未支付的订单：
     335e91d417af4c6e94e10f09624321d2
 
 
 self.orderId = @"3fcbb91eabad450a957c23fd8d32eed2";
 
 
 
 
 */
