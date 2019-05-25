//
//  ActivityOrderDetailViewController.m
//  CultureHongshan
//
//  Created by ct on 16/6/1.
//  Copyright © 2016年 CT. All rights reserved.
//


#import "ActivityOrderDetailViewController.h"
#import "AppProtocolMacros.h"

#import "ActivityDetailViewController.h"
#import "NearbyLocationViewController.h"
#import "WebViewController.h"
#import "WaitPayViewController.h"

#import "ActOrderDetailModel.h"

#import "SeatContentView.h"


#define kMargin 8
#define kTag_ActDetail   1 // 活动详情
#define kTag_ActLocation 2 // 查看位置
#define kTag_HelpLink    3 // 帮助中心
#define kTag_CancelOrder 4 // 取消订单
#define kTag_Pay         5 // 支付



@interface ActivityOrderDetailViewController ()
@property (nonatomic, strong) ActOrderDetailModel *model;
@property (nonatomic, strong) MYSmartButton *leftBottomBtn;
@property (nonatomic, strong) MYSmartButton *rightBottomBtn;
@end



@implementation ActivityOrderDetailViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"订单详情";
    [self startRequestOrderDetailData];
}


- (void)loadUI {
    WS(weakSelf)
    UIView *bottomToolView = [self loadBottomToolView];
    _scrollView.bounces = YES;
    _scrollView.backgroundColor = kBgColor;
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(weakSelf.view);
        make.bottom.equalTo(bottomToolView.mas_top);
    }];
    
    [bottomToolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.bottom.equalTo(weakSelf.view);
        make.height.mas_equalTo(50);
    }];
    
    /*
     orderTitleView
     orderInfoView
     
     ***********
     
     orderQrCodeView
     priceRelatedView
     payMethodView
     
     ***********
     
     venueInfoView
     orderTimeView
     */
    
    UIView *orderTitleView   = [self loadOrderTitleView];
    UIView *orderInfoView    = [self loadOrderInfoView];
    UIView *orderQrCodeView  = [self loadOrderQrCodeView];
    UIView *priceRelatedView = [self loadOrderPriceRelatedView];
    UIView *payMethodView    = [self loadOrderPayMethodView];
    UIView *venueInfoView    = [self loadVenueInfoView];
    UIView *orderTimeView    = [self loadOrderTimeInfoView];
    
    NSMutableArray *viewArray = [NSMutableArray arrayWithCapacity:5];
    
    if (orderTitleView)   [viewArray addObject:orderTitleView]; // 活动相关信息
    if (orderInfoView)    [viewArray addObject:orderInfoView]; // 订单预订信息：日期、时间等
    if (orderQrCodeView)  [viewArray addObject:orderQrCodeView]; // 取票码、二维码信息
    if (priceRelatedView) [viewArray addObject:priceRelatedView]; // 订单价格、数量等
    if (payMethodView)    [viewArray addObject:payMethodView]; // 支付方式
    if (venueInfoView)    [viewArray addObject:venueInfoView]; // 场馆信息
    if (orderTimeView)    [viewArray addObject:orderTimeView]; // 订单号、订单下单（支付）时间信息
    
    
    UIView *preView = nil;
    for (UIView *view in viewArray) {
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(weakSelf.view);
            if (preView) {
                make.top.equalTo(preView.mas_bottom).offset(7);
            }else {
                make.top.mas_equalTo(0);
            }
        }];
        
        preView = view;
    }
    
    [preView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_scrollView).offset(0);
    }];
}

/** 活动相关信息 */
- (UIView *)loadOrderTitleView {
    MYMaskView *bgView = [MYMaskView maskViewWithBgColor:kWhiteColor frame:CGRectZero radius:0];
    [_scrollView addSubview:bgView];
    
    //图片
    UIImageView *picView = [UIImageView new];
    UIImage *placeImg = [UIToolClass getPlaceholderWithViewSize:CGSizeMake(128, 85) centerSize:CGSizeMake(25, 25) isBorder:YES];
    [picView sd_setImageWithURL:[NSURL URLWithString:JointedImageURL(_model.activityIconUrl, kImageSize_300_300)] placeholderImage:placeImg];
    [bgView addSubview:picView];
    
    //标题
    MYSmartLabel *titleLable = [MYSmartLabel al_labelWithMaxRow:2 text:self.model.activityName font:FontYT(17) color:kDeepLabelColor lineSpacing:4];
    [bgView addSubview:titleLable];
    
    //位置图标
    UIImageView *locationView = [[UIImageView alloc] initWithImage:IMG(@"icon_mapon")];
    [bgView addSubview:locationView];
    
    //地点
    MYSmartLabel *addressLable = [MYSmartLabel al_labelWithMaxRow:2 text:self.model.addressString.length ? self.model.addressString : self.model.venueName  font:FontYT(13) color:kLightLabelColor lineSpacing:4];
    [bgView addSubview:addressLable];
    
    // 箭头
    UIImageView *arrowView = nil;
    if (_model.isDelete == NO) {
        arrowView = [[UIImageView alloc] initWithImage:IMG(@"arrow_right")];
        [bgView addSubview:arrowView];
    }
    
    WS(weakSelf)
    
    // 按钮
    MYSmartButton *detailButton = [[MYSmartButton alloc] initWithFrame:CGRectZero image:nil selectedImage:nil actionBlock:^(MYSmartButton *sender) {
        [weakSelf buttonClick:sender];
    }];
    if (_model.isDelete) { detailButton.userInteractionEnabled = NO; }
    detailButton.tag = kTag_ActDetail;
    [bgView addSubview:detailButton];
    
    
    [picView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView).offset(15);
        make.left.equalTo(bgView).offset(8);
        make.height.mas_equalTo(85);
        make.width.equalTo(picView.mas_height).multipliedBy(1.5);
        make.bottom.equalTo(bgView).offset(-15);
    }];
    
    [titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(picView.mas_right).offset(8);
        make.top.equalTo(picView);
        if (arrowView) {
            make.right.equalTo(arrowView.mas_left).offset(-5);
        }else {
            make.right.equalTo(bgView).offset(-10);
        }
    }];
    
    CGFloat halfFontHeight = [UIToolClass fontHeight:addressLable.font]/2;
    [locationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLable);
        make.centerY.equalTo(addressLable.mas_top).offset(halfFontHeight);
        make.size.mas_equalTo(CGSizeMake(12, 16));
    }];
    
    [addressLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLable.mas_bottom).offset(12);
        make.left.equalTo(locationView.mas_right).offset(4);
        make.right.equalTo(titleLable);
    }];
    
    if (arrowView) {
        [arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(bgView);
            make.right.equalTo(bgView).offset(-8);
            make.size.mas_equalTo(arrowView.image.size);
        }];
    }
    
    [detailButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(bgView).multipliedBy(1);
        make.right.equalTo(bgView);
        make.top.and.bottom.equalTo(bgView);
    }];
    
    return bgView;
}

/** 订单预订信息：日期、时间等 */
- (UIView *)loadOrderInfoView {
    MYMaskView *bgView = [MYMaskView maskViewWithBgColor:kWhiteColor frame:CGRectZero radius:0];
    [_scrollView addSubview:bgView];
    
    NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:5];
    if (self.model.participateDate.length) {
        [tmpArray addObject:@[@"日    期：", self.model.participateDate]];
    }
    if (self.model.participateTime.length) {
        [tmpArray addObject:@[@"时    间：", self.model.participateTime]];
    }
    if (self.model.showedSeatArray.count) {
        [tmpArray addObject:@[@"座    位：", self.model.showedSeatArray]];
    }else if (self.model.orderPayStatus == 0) { // 无需支付的要显示人数
        [tmpArray addObject:@[@"人    数：", StrFromLong(self.model.peopleCount)]];
    }
    if (self.model.orderPayStatus == 0) {
        if (self.model.priceStr.length) {
            [tmpArray addObject:@[@"票    价：", self.model.priceStr]];
        }
    }
    
    if (self.model.orderUserName.length && self.model.orderPhoneNum.length) {
        [tmpArray addObject:@[@"联系人：", [NSString stringWithFormat:@"%@  %@",self.model.orderUserName, self.model.orderPhoneNum]]];
    }
    
    if ([self canShowOrderPriceRelatedView] == NO) {
        // 非在线支付类活动的积分扣除显示
        if (self.model.costCredit > 0) {
            [tmpArray addObject:@[@"积    分：", [NSString stringWithFormat:@"- %ld", (long)self.model.costCredit]]];
        }
    }
    
    UIView *preView = nil;
    UIFont *font = FontYT(15);
    CGFloat leftLabelWidth = [UIToolClass textWidth:@"日    期：" font:font]+2;
    
    for (NSArray *item in tmpArray) {
        NSString *leftTitle = item[0];
        id rightTitleOrArray = item[1];
        
        MYSmartLabel *leftLabel = [MYSmartLabel al_labelWithMaxRow:1 text:leftTitle font:font color:kDeepLabelColor lineSpacing:0];
        [bgView addSubview:leftLabel];
        
        [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(leftLabelWidth);
            if (preView) {
                make.left.equalTo(preView);
                make.top.equalTo(preView.mas_bottom).offset(12);
            }else {
                make.left.equalTo(bgView).offset(kMargin);
                make.top.equalTo(bgView).offset(18);
            }
        }];
        
        
        UIView *rightView = nil;
        if ([rightTitleOrArray isKindOfClass:[NSArray class]]) {
            SeatContentView *seatView = [[SeatContentView alloc] initWithFrame:CGRectZero seatArray:rightTitleOrArray font:font tColor:RGB(117, 134, 181)];
            [bgView addSubview:seatView];
            
            [seatView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(leftLabel.mas_right);
                make.right.equalTo(bgView).offset(-kMargin);
                make.top.equalTo(leftLabel);
            }];
            
            rightView = seatView;
        }else {
            // 右侧按钮
            UIColor *textColor = kDeepLabelColor;
            if ([leftTitle hasPrefix:@"积"]) {
                textColor = ColorFromHex(@"a9c7ff");
            }
            MYSmartLabel *rightLabel = [MYSmartLabel al_labelWithMaxRow:20 text:rightTitleOrArray font:font color:textColor lineSpacing:4];
            [bgView addSubview:rightLabel];
            
            [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(leftLabel.mas_right);
                make.right.equalTo(bgView).offset(-kMargin);
                make.top.equalTo(leftLabel);
            }];
            
            rightView = rightLabel;
        }
        
        // 分割线
        MYMaskView *line = [MYMaskView maskViewWithBgColor:kLineGrayColor frame:CGRectZero radius:0];
        [bgView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(rightView.mas_bottom).offset(12);
            make.left.equalTo(leftLabel);
            make.right.equalTo(bgView).offset(-kMargin);
            make.height.mas_equalTo(1);
        }];
        
        preView = line;
    }
    
    [preView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bgView).offset(-10);
    }];
    preView.hidden = YES;
    
    return bgView;
}

/** 取票码、二维码信息 */
- (UIView *)loadOrderQrCodeView {
    
    if (![self canShowQrCode]) return nil;
    
    MYMaskView *bgView = [MYMaskView maskViewWithBgColor:kWhiteColor frame:CGRectZero radius:0];
    [_scrollView addSubview:bgView];
    
    // 取票码
    MYSmartLabel *leftLabel = [MYSmartLabel al_labelWithMaxRow:1 text:@"取票码：" font:FontYT(15) color:kDeepLabelColor lineSpacing:0];
    [bgView addSubview:leftLabel];
    
    MYBoldLabel *ticketNumLabel = [[MYBoldLabel alloc] initWithFrame:CGRectZero];
    ticketNumLabel.isAutoLayout = YES;
    ticketNumLabel.font = leftLabel.font;
    ticketNumLabel.textColor = kDarkRedColor;
    ticketNumLabel.spacingOfLine = 4;
    ticketNumLabel.text = self.model.checkCode;
    ticketNumLabel.numberOfLines = 2;
    [bgView addSubview:ticketNumLabel];
    
    UIImageView *qrCodeView = [UIImageView new];
    UIImage *placeImg = [UIToolClass getPlaceholderWithViewSize:CGSizeMake(145, 145) centerSize:CGSizeMake(30, 30) isBorder:YES];
    [qrCodeView sd_setImageWithURL:[NSURL URLWithString:self.model.qrCodeImgUrl] placeholderImage:placeImg];
    [bgView addSubview:qrCodeView];
    
    MYSmartLabel *tipLabel = [MYSmartLabel al_labelWithMaxRow:1 text:@"出示二维码或取票码验证使用" font:FontYT(12) color:kDeepLabelColor lineSpacing:0 align:NSTextAlignmentCenter breakMode:NSLineBreakByTruncatingTail];
    [bgView addSubview:tipLabel];
    
    
    CGFloat leftLabelWidth = [UIToolClass textWidth:@"取票码：" font:FontYT(15)]+2;
    [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).offset(kMargin);
        make.top.equalTo(bgView).offset(21);
        make.width.mas_equalTo(leftLabelWidth);
    }];
    
    [ticketNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bgView).offset(-kMargin);
        make.left.equalTo(leftLabel.mas_right);
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
        make.bottom.equalTo(bgView).offset(-22);
    }];
    
    return bgView;
}

/** 场馆信息 */
- (UIView *)loadVenueInfoView {
    MYMaskView *bgView = [MYMaskView maskViewWithBgColor:kWhiteColor frame:CGRectZero radius:0];
    [_scrollView addSubview:bgView];
    
    NSString *venueName = self.model.venueName;
    if ([self.model.addressString isEqualToString:self.model.addressString]) {
        venueName = [ToolClass getJointedString:self.model.addressString otherStr:self.model.venueName jointedBy:@" . "];
    }else {
        venueName = self.model.addressString;
    }
    MYSmartLabel *venueNameLabel = [MYSmartLabel al_labelWithMaxRow:4 text:venueName font:FontYT(15) color:kDeepLabelColor lineSpacing:4];
    [bgView addSubview:venueNameLabel];
    
    MYSmartLabel *addressLabel = [MYSmartLabel al_labelWithMaxRow:4 text:self.model.activityAddress font:FontYT(13) color:kLightLabelColor lineSpacing:4];
    [bgView addSubview:addressLabel];
    
    // 箭头
    UIImageView *arrowView = [[UIImageView alloc] initWithImage:IMG(@"arrow_right")];
    [bgView addSubview:arrowView];
    
    WS(weakSelf)
    MYSmartButton *locationButton = [[MYSmartButton alloc] initWithFrame:CGRectZero image:nil selectedImage:nil actionBlock:^(MYSmartButton *sender) {
        [weakSelf buttonClick:sender];
    }];
    locationButton.tag = kTag_ActLocation;
    [bgView addSubview:locationButton];
    
    [venueNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).offset(kMargin);
        make.right.equalTo(arrowView.mas_left).offset(-8);
        make.top.equalTo(bgView).offset(12);
    }];
    
    [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(venueNameLabel);
        make.top.equalTo(venueNameLabel.mas_bottom).offset(10);
        make.bottom.equalTo(bgView).offset(-12);
    }];
    
    [arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bgView);
        make.right.equalTo(bgView).offset(-kMargin);
        make.size.mas_equalTo(arrowView.image.size);
    }];
    
    [locationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(bgView).multipliedBy(1.0);
        make.right.equalTo(bgView);
        make.top.and.bottom.equalTo(bgView);
    }];
    return bgView;
}

/** 订单价格、数量等 */
- (UIView *)loadOrderPriceRelatedView {
    
    if (![self canShowOrderPriceRelatedView]) return nil;
    
    MYMaskView *bgView = [MYMaskView maskViewWithBgColor:kWhiteColor frame:CGRectZero radius:0];
    [_scrollView addSubview:bgView];
    
    NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:3];
    [tmpArray addObject:@[@"价    格：", [NSString stringWithFormat:@"￥%.2lf", self.model.activityUnitPrice]]];
    [tmpArray addObject:@[@"数    量：", StrFromLong(self.model.peopleCount)]];
    if (self.model.costCredit > 0) {
        [tmpArray addObject:@[@"积    分：", [NSString stringWithFormat:@"- %ld", (long)self.model.costCredit]]];
    }
    [tmpArray addObject:@[@"总    价：", [NSString stringWithFormat:@"￥%.2lf", self.model.activityUnitPrice * self.model.peopleCount]]];
    
    
    CGFloat leftLabelWidth = [UIToolClass textWidth:@"总    价：" font:FONT(15)];
    UIView *preView = nil;
    for (NSArray *item in tmpArray) {
        NSString *leftTitle = item[0];
        NSString *rightTitle = item[1];
        UIColor *rightTextColor = ([leftTitle hasPrefix:@"总"] || [leftTitle hasPrefix:@"积"]) ? kDarkRedColor : kDeepLabelColor;
        
        MYSmartLabel *leftLabel = [MYSmartLabel al_labelWithMaxRow:1 text:leftTitle font:FONT(15) color:kDeepLabelColor lineSpacing:0];
        [bgView addSubview:leftLabel];
        
        MYSmartLabel *rightLabel = [MYSmartLabel al_labelWithMaxRow:1 text:rightTitle font:FONT(15) color:rightTextColor lineSpacing:0 align:NSTextAlignmentRight breakMode:NSLineBreakByTruncatingTail];
        [bgView addSubview:rightLabel];
        
        MYMaskView *line = [MYMaskView maskViewWithBgColor:kLineGrayColor frame:CGRectZero radius:0];
        [bgView addSubview:line];
        
        [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            if (preView) {
                make.left.equalTo(preView);
                make.width.mas_equalTo(leftLabelWidth);
                make.top.equalTo(preView.mas_bottom).offset(12);
            }else {
                make.left.equalTo(bgView).offset(kMargin);
                make.width.mas_equalTo(leftLabelWidth);
                make.top.equalTo(bgView).offset(15);
            }
        }];
        
        [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(bgView).offset(-kMargin);
            make.top.equalTo(leftLabel);
            make.left.lessThanOrEqualTo(leftLabel.mas_right).offset(10);
        }];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(leftLabel.mas_bottom).offset(12);
            make.left.equalTo(leftLabel);
            make.right.equalTo(bgView).offset(-kMargin);
            make.height.mas_equalTo(1);
        }];
        
        preView = line;
    }
    preView.hidden = YES;
    [preView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bgView).offset(-10);
    }];
    
    return bgView;
}

/** 支付方式 */
- (UIView *)loadOrderPayMethodView {
    if (self.model.orderPayMethod > 0) {
        MYMaskView *bgView = [MYMaskView maskViewWithBgColor:kWhiteColor frame:CGRectZero radius:0];
        [_scrollView addSubview:bgView];
        
        NSString *payMethod = @"其他方式";
        if (self.model.orderPayMethod == 1) {
            payMethod = @"支付宝";
        }else if (self.model.orderPayMethod == 2) {
            payMethod = @"微信";
        }
        
        MYSmartLabel *leftLabel = [MYSmartLabel al_labelWithMaxRow:1 text:@"支付方式" font:FontYT(15) color:kDeepLabelColor lineSpacing:0];
        [bgView addSubview:leftLabel];
        
        MYSmartLabel *rightLabel = [MYSmartLabel al_labelWithMaxRow:1 text:payMethod font:FontYT(15) color:kDeepLabelColor lineSpacing:0 align:NSTextAlignmentRight breakMode:NSLineBreakByTruncatingTail];
        [bgView addSubview:rightLabel];
        
        
        [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bgView).offset(kMargin);
            make.top.equalTo(bgView).offset(12);
            make.bottom.equalTo(bgView).offset(-12);
        }];
        
        [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(bgView).offset(-18);
            make.top.equalTo(leftLabel);
            make.centerY.equalTo(leftLabel);
        }];
        
        return bgView;
    }
    return nil;
}

/** 订单号、订单下单（支付）时间信息 */
- (UIView *)loadOrderTimeInfoView {
    MYMaskView *bgView = [MYMaskView maskViewWithBgColor:kWhiteColor frame:CGRectZero radius:0];
    [_scrollView addSubview:bgView];
    
    NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:3];
    if (self.model.orderNumber.length) {
        [tmpArray addObject:[NSString stringWithFormat:@"订  单  号： %@", self.model.orderNumber]];
    }
    if (self.model.orderCreatTime.length) {
        [tmpArray addObject:[NSString stringWithFormat:@"下单时间： %@", self.model.orderCreatTime]];
    }
    if (self.model.orderPayTime.length) {
        [tmpArray addObject:[NSString stringWithFormat:@"支付时间： %@", self.model.orderPayTime]];
    }
    
    UIView *preView = nil;
    for (NSString *item in tmpArray) {
        MYSmartLabel *label = [MYSmartLabel al_labelWithMaxRow:1 text:item font:FONT(15) color:kLightLabelColor lineSpacing:0];
        [bgView addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            if (preView) {
                make.left.right.equalTo(preView);
                make.top.equalTo(preView.mas_bottom).offset(8);
            }else {
                make.left.equalTo(bgView).offset(kMargin);
                make.right.equalTo(bgView).offset(-kMargin);
                make.top.equalTo(bgView).offset(17);
            }
        }];
        
        preView = label;
    }
    
    MYMaskView *line = [MYMaskView maskViewWithBgColor:kLineGrayColor frame:CGRectZero radius:0];
    [bgView addSubview:line];
    
    MYSmartLabel *helpLabel = [MYSmartLabel al_labelWithMaxRow:1 text:@"帮助中心" font:FontYT(15) color:kDeepLabelColor lineSpacing:0];
    [bgView addSubview:helpLabel];
    
    UIImageView *arrowView = [[UIImageView alloc] initWithImage:IMG(@"arrow_right")];
    [bgView addSubview:arrowView];
    
    WS(weakSelf)
    MYSmartButton *helpButton = [[MYSmartButton alloc] initWithFrame:CGRectZero image:nil selectedImage:nil actionBlock:^(MYSmartButton *sender) {
        [weakSelf buttonClick:sender];
    }];
    helpButton.tag = kTag_HelpLink;
    [bgView addSubview:helpButton];
    
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(preView.mas_bottom).offset(18);
        make.left.equalTo(bgView).offset(kMargin);
        make.right.equalTo(bgView).offset(-kMargin);
        make.height.mas_equalTo(1);
    }];
    [helpLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(12);
        make.left.equalTo(bgView).offset(kMargin);
        make.bottom.equalTo(bgView).offset(-30);
    }];
    [arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(helpLabel);
        make.right.equalTo(bgView).offset(-kMargin);
        make.size.mas_equalTo(arrowView.image.size);
    }];
    [helpButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(bgView).multipliedBy(1);
        make.right.equalTo(bgView);
        make.top.equalTo(line.mas_bottom);
        make.bottom.equalTo(helpLabel.mas_bottom).offset(12);
    }];
    
    return bgView;
}

/** 底部工具条 */
- (UIView *)loadBottomToolView {
    MYMaskView *bgView = [MYMaskView maskViewWithBgColor:RGB(240, 240, 240) frame:CGRectZero radius:0];
    [self.view addSubview:bgView];
    
    WS(weakSelf)
    self.leftBottomBtn = [[MYSmartButton alloc] initWithFrame:CGRectZero title:@"取消订单" font:FontYT(20) tColor:kThemeDeepColor bgColor:nil actionBlock:^(MYSmartButton *sender) {
        [weakSelf buttonClick:sender];
    }];
    self.leftBottomBtn.tag = kTag_CancelOrder;
    [bgView addSubview:self.leftBottomBtn];
    
    self.rightBottomBtn = [[MYSmartButton alloc] initWithFrame:CGRectZero title:@" " font:FontYT(20) tColor:kThemeDeepColor bgColor:nil actionBlock:^(MYSmartButton *sender) {
        [weakSelf buttonClick:sender];
    }];
    self.rightBottomBtn.tag = kTag_Pay;
    self.rightBottomBtn.userInteractionEnabled = NO;
    [bgView addSubview:self.rightBottomBtn];
    
    MYMaskView *line = [MYMaskView maskViewWithBgColor:RGB(215, 215, 215) frame:CGRectZero radius:0];
    [bgView addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(bgView);
        make.height.mas_equalTo(0.8f);
    }];
    
    [self.leftBottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(bgView);
        make.height.mas_equalTo(50);
        make.bottom.equalTo(bgView).offset(-HEIGHT_HOME_INDICATOR);
    }];
    
    [self.rightBottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.leftBottomBtn.mas_right);
        make.top.height.width.equalTo(self.leftBottomBtn);
        make.right.equalTo(bgView);
    }];
    
    [self updateBottomToolViewStatus];
    
    return bgView;
}


#pragma mark - 数据请求

//获取订单的详情
- (void)startRequestOrderDetailData {
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showLoading];
    
    WS(weakSelf);
    [AppProtocol getUserOrderDetailWithDataType:DataTypeActivity orderId:self.orderId UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        
        if (responseCode == HttpResponseSuccess) {
            _model = responseObject;
            [weakSelf loadUI];
            [SVProgressHUD dismiss];
        }else {
            if ([responseObject isKindOfClass:[NSString class]]) {
                [weakSelf noMessageNotice:responseObject];
                [SVProgressHUD dismiss];
            }else {
                [SVProgressHUD showInfoWithStatus:@"网络连接出错，请稍候再试!"];
            }
        }
    }];
}

//取消订单
- (void)cancelOrderRequest {
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"请稍候..."];
    
    WS(weakSelf)
    [AppProtocol cancelUserOrderWithDataType:DataTypeActivity orderId:self.orderId orderSeats:nil UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        
        if (responseCode == HttpResponseSuccess) {
            [SVProgressHUD showSuccessWithStatus:@"订单取消成功!"];
            weakSelf.model.orderStatus = 2;
            [weakSelf updateBottomToolViewStatus];
        }else {
            [SVProgressHUD showInfoWithStatus:responseObject];
        }
    }];
}

#pragma mark -

- (void)buttonClick:(UIButton *)sender {
    switch (sender.tag) {
        case kTag_ActDetail: {
            if (self.model.activityId.length) {
                ActivityDetailViewController *vc = [ActivityDetailViewController new];
                vc.activityId = self.model.activityId;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
            break;
        case kTag_ActLocation: {
            if (_model.latitude < 0.1 && _model.longitude < 0.1){
                [SVProgressHUD showInfoWithStatus:@"暂无活动的位置信息!"];
                return;
            }
            NearbyLocationViewController *vc = [NearbyLocationViewController new];
            vc.type = DataTypeActivity;
            vc.locationCoordinate2D = CLLocationCoordinate2DMake(_model.latitude, _model.longitude);
            vc.addressString = _model.activityAddress;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case kTag_HelpLink: {
            WebViewController *webVC = [WebViewController new];
            webVC.url = kHelpCenterUrl;
            webVC.navTitle = @"使用帮助";
            [self.navigationController pushViewController:webVC animated:YES];
        }
            break;
        case kTag_CancelOrder: {
            WS(weakSelf)
            [WHYAlertActionUtil showAlertWithTitle:@"温馨提示" msg:@"确认要取消该订单吗？取消后将无法撤回。" actionBlock:^(NSInteger index, NSString *buttonTitle) {
                if (index == 1) {
                    [weakSelf cancelOrderRequest];
                }
            } buttonTitles:@"取消", @"确认", nil];
        }
            break;
        case kTag_Pay: {
            WaitPayViewController *vc = [WaitPayViewController new];
            vc.orderId = self.orderId;
            vc.dataType = DataTypeActivity;
            WS(weakSelf)
            vc.completionHandler = ^(BOOL success, NSString *orderId) {
                if (success) {
                    weakSelf.model.orderPayStatus = 2;
                    [weakSelf updateBottomToolViewStatus];
                }
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }
}

/** 移除底部工具条的左侧按钮 */
- (void)removeBottomToolViewLeftButton {
    [self.leftBottomBtn removeFromSuperview];
    
    WS(weakSelf)
    [self.rightBottomBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(weakSelf.rightBottomBtn.superview);
        make.height.mas_equalTo(50);
        make.bottom.mas_equalTo(-HEIGHT_HOME_INDICATOR);
    }];
    
    [self.rightBottomBtn.superview setNeedsLayout];
    [self.rightBottomBtn.superview layoutIfNeeded];
}

/** 更新底部工具条的按钮状态 */
- (void)updateBottomToolViewStatus {
    // 1-预订成功 2-已取消 3-已出票 4-已验票 5-已过期 6-已删除
    // 订单支付状态：0-无需支付  1-未支付  2-支付成功  3-退款中  4-退款成功
    self.rightBottomBtn.userInteractionEnabled = NO;
    self.rightBottomBtn.backgroundColor = RGB(204, 204, 204);
    [self.rightBottomBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    
    switch (_model.orderStatus) {
        case 1: // 预订成功
        {
            if (_model.orderPayStatus == 0) { // 无需支付
                [self.rightBottomBtn setTitle:@"待使用" forState:UIControlStateNormal];
            }else if (_model.orderPayStatus == 1) { // 未支付
                self.rightBottomBtn.userInteractionEnabled = YES;
                self.rightBottomBtn.backgroundColor = kThemeDeepColor;
                [self.rightBottomBtn setTitle:@"去付款" forState:UIControlStateNormal];
            }else if (_model.orderPayStatus == 2) { // 支付成功
                /************************ 支付的订单，不能取消。只能人工退款后取消 ************************/
                [self.rightBottomBtn setTitle:@"待使用" forState:UIControlStateNormal];
                [self removeBottomToolViewLeftButton];
            }else if (_model.orderPayStatus == 3) { // 退款中
                [self removeBottomToolViewLeftButton];
                [self.rightBottomBtn setTitle:@"退款中" forState:UIControlStateNormal];
            }else if (_model.orderPayStatus == 4) { // 退款成功
                [self removeBottomToolViewLeftButton];
                [self.rightBottomBtn setTitle:@"退款成功" forState:UIControlStateNormal];
            }else {
                [self removeBottomToolViewLeftButton];
                [self.rightBottomBtn setTitle:@"未知状态" forState:UIControlStateNormal];
            }
        }
            break;
        case 2: // 已取消
        {
            if (_model.orderPayStatus == 3) { // 退款中
                [self removeBottomToolViewLeftButton];
                [self.rightBottomBtn setTitle:@"退款中" forState:UIControlStateNormal];
            }else if (_model.orderPayStatus == 4) { // 退款成功
                [self removeBottomToolViewLeftButton];
                [self.rightBottomBtn setTitle:@"退款成功" forState:UIControlStateNormal];
            }else {
                [self removeBottomToolViewLeftButton];
                [self.rightBottomBtn setTitle:@"已取消" forState:UIControlStateNormal];
            }
        }
            break;
        case 3: // 已出票
        {
            [self removeBottomToolViewLeftButton];
            [self.rightBottomBtn setTitle:@"已出票" forState:UIControlStateNormal];
        }
            break;
        case 4: // 已验票
        {
            [self removeBottomToolViewLeftButton];
            [self.rightBottomBtn setTitle:@"已使用" forState:UIControlStateNormal];
        }
            break;
        case 5: // 已过期
        {
            [self removeBottomToolViewLeftButton];
            [self.rightBottomBtn setTitle:@"已过期" forState:UIControlStateNormal];
        }
            break;
        case 6: // 已删除
        {
            [self removeBottomToolViewLeftButton];
            [self.rightBottomBtn setTitle:@"已删除" forState:UIControlStateNormal];
        }
            break;
        default: {
            [self removeBottomToolViewLeftButton];
            [self.rightBottomBtn setTitle:@"未知状态" forState:UIControlStateNormal];
        }
            break;
    }
}

#pragma mark -

/** 是否可以显示二维码 */
- (BOOL)canShowQrCode {
    /*
     订单状态:  0.未定义  1.预订成功 2.已取消 3.已出票 4.已验票 5.已过期 6.已删除
     订单支付状态：0-无需支付  1-未支付  2-支付成功  3-退款中  4-退款成功
     */
    if (self.model.qrCodeImgUrl.length) {
        if (self.model.orderStatus == 1) { // 预订成功
            if (self.model.orderPayStatus == 0) {
                return YES;
            }else if (self.model.orderPayStatus == 1) {
                return NO;
            }else if (self.model.orderPayStatus == 2) {
                return YES;
            }else if (self.model.orderPayStatus == 3) {
                return NO;
            }else if (self.model.orderPayStatus == 4) {
                return NO;
            }
        }else if (self.model.orderStatus == 2) { // 已取消
            return NO;
        }else if (self.model.orderStatus == 3) { // 已出票
            return YES;
        }else if (self.model.orderStatus == 4) { // 已验票
            return YES;
        }
    }
    return NO;
}

/** 是否可以显示订单价格相关的信息 */
- (BOOL)canShowOrderPriceRelatedView {
    /*
     订单支付状态：0-无需支付  1-未支付  2-支付成功  3-退款中  4-退款成功
     */
    if (self.model.orderPayStatus != 0) {
        return YES;
    }
    
    return NO;
}

//无消息时的提示
- (void)noMessageNotice:(NSString *)message {
    WS(weakSelf);
    NoDataNoticeView *noticeView = [NoDataNoticeView noticeViewWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-HEIGHT_TOP_BAR-HEIGHT_HOME_INDICATOR)
                                                                 bgColor:[UIColor whiteColor]
                                                                 message:message
                                                             promptStyle:NoDataPromptStyleClickRefreshForError
                                                           callbackBlock:^(id object, NSInteger index, BOOL isSameIndex) {
                                                               [weakSelf startRequestOrderDetailData];
                                                           }];
    [self.view addSubview:noticeView];
}

@end
