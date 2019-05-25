//
//  VenueOrderDetailViewController.m
//  CultureHongshan
//
//  Created by ct on 16/6/1.
//  Copyright © 2016年 CT. All rights reserved.
//

#import "VenueOrderDetailViewController.h"
#import "AppProtocolMacros.h"

#import "OrderDetailModel.h"

#import "ActivityRoomDetailViewController.h"
#import "NearbyLocationViewController.h"
#import "WebViewController.h"





@interface VenueOrderDetailViewController ()
{
    UIScrollView *_scrollView;
    
    UIButton *_leftBtn;
    UIButton *_rightBtn;
}

@end


@implementation VenueOrderDetailViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = kBgColor;
    self.navigationItem.title = @"订单详情";
    
    [self startRequestOrderDetailData];
}


#pragma mark - 请求数据

//获取订单的详情
- (void)startRequestOrderDetailData
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    //[SVProgressHUD showWithStatus:@"努力加载中,请稍候..."];
    [SVProgressHUD showLoading];
    
    WS(weakSelf);
    [AppProtocol getUserOrderDetailWithDataType:DataTypeVenue orderId:_orderId UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        if (responseCode == HttpResponseSuccess) {
            _model = responseObject;
            [weakSelf initScrollView];
            
            [SVProgressHUD dismiss];
        }else{
            if ([responseObject isKindOfClass:[NSString class]]) {
                [weakSelf noMessageNotice:responseObject];
                [SVProgressHUD dismiss];
            }else{
                [SVProgressHUD showInfoWithStatus:@"网络连接出错，请稍候再试!"];
            }
        }
    }];
}


//取消订单
- (void)cancelOrderRequest
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showLoading];
    
    WS(weakSelf);
    
    [AppProtocol cancelUserOrderWithDataType:DataTypeVenue orderId:_orderId orderSeats:nil UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        if (responseCode == HttpResponseSuccess) {
            [SVProgressHUD showSuccessWithStatus:@"订单取消成功!"];
            [weakSelf updateBottomView:@"已取消"];
        }else {
            [SVProgressHUD showInfoWithStatus:responseObject];
        }
    }];
}


#pragma mark - 创建UI


- (void)initScrollView
{
    if (_scrollView){
        [_scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [_scrollView removeFromSuperview];
        _scrollView = nil;
    }
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-HEIGHT_TOP_BAR-50-HEIGHT_HOME_INDICATOR)];
    _scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_scrollView];
    
    
    [self creatOrderTitleView];
}

//订单的标题、封面图等
- (void)creatOrderTitleView
{
    CGFloat picHeight = 85;
    
    //按钮
    UIButton *titleButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, picHeight+2*15)];
    titleButton.tag = 1;
    titleButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    [titleButton setImage:IMG(@"icon_arrow_right_gray") forState:UIControlStateNormal];//
    titleButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [titleButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:titleButton];
    
    //图片
    UIImageView *picView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 15, picHeight*1.5, picHeight)];
    UIImage *placeImg = [UIToolClass getPlaceholderWithViewSize:picView.viewSize centerSize:CGSizeMake(25, 25) isBorder:YES];
    [picView sd_setImageWithURL:[NSURL URLWithString:JointedImageURL(_model.imageUrl, kImageSize_300_300)] placeholderImage:placeImg];
    [titleButton addSubview:picView];
    
    //标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(picView.maxX+8, picView.originalY, kScreenWidth-30-picView.maxX-8, 0)];
    titleLabel.numberOfLines = 0;
    titleLabel.font = FontYT(17);
    titleLabel.textColor = kDeepLabelColor;
    titleLabel.attributedText = [UIToolClass getAttributedStr:_model.titleStr font:titleLabel.font lineSpacing:4];
    titleLabel.height = [UIToolClass textHeight:_model.titleStr lineSpacing:4 font:titleLabel.font width:titleLabel.width maxRow:2];
    [titleButton addSubview:titleLabel];
    
    //位置图标
    UIImageView *locationView = [[UIImageView alloc] initWithFrame:CGRectMake(titleLabel.originalX, titleLabel.maxY+9, 12, 16)];
    locationView.image = IMG(@"icon_mapon");
    [titleButton addSubview:locationView];
    
    //地址或场馆名
    UILabel *locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(locationView.maxX+5, titleLabel.maxY+10, kScreenWidth-30-locationView.maxX-5, 0)];
    locationLabel.numberOfLines = 0;
    locationLabel.font = FontYT(13);
    locationLabel.textColor = kLightLabelColor;
    locationLabel.attributedText = [UIToolClass getAttributedStr:_model.addressStr font:locationLabel.font lineSpacing:4];
    locationLabel.height = [UIToolClass textHeight:_model.addressStr lineSpacing:4 font:locationLabel.font width:locationLabel.width maxRow:2];
    [titleButton addSubview:locationLabel];
    
    MYMaskView *line = [MYMaskView maskViewWithBgColor:kBgColor frame:CGRectMake(0, titleButton.maxY, kScreenWidth, 8) radius:0];
    [_scrollView addSubview:line];
    
    /*   */
    [self creatOrderInfoView:line.maxY];//10为灰色的分割线
}

//订单的基本信息
- (void)creatOrderInfoView:(CGFloat)position
{
    CGFloat leftWidth = [UIToolClass textWidth:@"日  期：" font:FontYT(15)];
    CGFloat rightWidth = kScreenWidth-2*10-leftWidth-5;
    CGFloat fontHeight = [UIToolClass fontHeight:FontYT(15)];
    CGFloat offsetY = position + 18;
    
    UILabel *leftLabel = nil;
    UILabel *rightLabel = nil;
    
    //日期
    if (_model.participateDate.length) {
        
        leftLabel = [self getLeftLabel:CGRectMake(10, offsetY, leftWidth, fontHeight)];
        leftLabel.text = @"日  期：";
        [_scrollView addSubview:leftLabel];
        
        rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftLabel.maxX+5, leftLabel.originalY, rightWidth, fontHeight)];
        rightLabel.numberOfLines = 0;
        rightLabel.textColor = leftLabel.textColor;
        rightLabel.font = leftLabel.font;
        rightLabel.text = _model.participateDate;
        [_scrollView addSubview:rightLabel];
        
        if (_model.participateTime.length || _model.priceStr.length || _model.roomUser.length || _model.roomBooker.length || _model.bookerTel.length || _model.showedCostCredit > 0){
            MYMaskView *line = [MYMaskView maskViewWithBgColor:kBgColor frame:CGRectMake(8, rightLabel.maxY + 10, kScreenWidth-16, kLineThick) radius:0];
            [_scrollView addSubview:line];
            
            offsetY = line.maxY + 10;
        }else{
            offsetY = rightLabel.maxY + 10;
        }
    }
    
    //时间
    if (_model.participateTime.length) {
        
        leftLabel = [self getLeftLabel:CGRectMake(10, offsetY, leftWidth, fontHeight)];
        leftLabel.text = @"时  间：";
        [_scrollView addSubview:leftLabel];
        
        rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftLabel.maxX+5, leftLabel.originalY, rightWidth, fontHeight)];
        rightLabel.numberOfLines = 0;
        rightLabel.textColor = leftLabel.textColor;
        rightLabel.font = leftLabel.font;
        rightLabel.text = _model.participateTime;
        [_scrollView addSubview:rightLabel];
        
        if (_model.priceStr.length || _model.roomUser.length || _model.roomBooker.length || _model.bookerTel.length || _model.showedCostCredit > 0){
            MYMaskView *line = [MYMaskView maskViewWithBgColor:kBgColor frame:CGRectMake(8, rightLabel.maxY + 10, kScreenWidth-16, kLineThick) radius:0];
            [_scrollView addSubview:line];
            
            offsetY = line.maxY + 10;
        }else{
            offsetY = rightLabel.maxY + 10;
        }
    }
    
    //价格
    if (_model.priceStr.length) {
        
        leftLabel = [self getLeftLabel:CGRectMake(10, offsetY, leftWidth, fontHeight)];
        leftLabel.text = @"价  格：";
        [_scrollView addSubview:leftLabel];
        
        rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftLabel.maxX+5, leftLabel.originalY, rightWidth, leftLabel.height)];
        rightLabel.numberOfLines = 0;
        rightLabel.textColor = [_model.priceStr hasPrefix:@"¥"] ? ColorFromHex(@"C05459") : leftLabel.textColor;
        rightLabel.font = leftLabel.font;
        rightLabel.text = _model.priceStr;
        [_scrollView addSubview:rightLabel];
        
        if (_model.roomUser.length || _model.roomBooker.length || _model.bookerTel.length || _model.showedCostCredit > 0){
            MYMaskView *line = [MYMaskView maskViewWithBgColor:kBgColor frame:CGRectMake(8, rightLabel.maxY + 10, kScreenWidth-16, kLineThick) radius:0];
            [_scrollView addSubview:line];
            
            offsetY = line.maxY + 10;
        }else{
            offsetY = rightLabel.maxY + 10;
        }
    }
    
    //使用者
    if (_model.roomUser.length) {
        leftLabel = [self getLeftLabel:CGRectMake(10, offsetY, leftWidth, fontHeight)];
        leftLabel.text = @"使用者：";
        [_scrollView addSubview:leftLabel];
        leftLabel.width = [UIToolClass textWidth:leftLabel.text font:leftLabel.font];
        
        rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftLabel.maxX+5, leftLabel.originalY, kScreenWidth-10-leftLabel.maxX-5, 0)];
        rightLabel.numberOfLines = 0;
        rightLabel.textColor = leftLabel.textColor;
        rightLabel.font = leftLabel.font;
        rightLabel.attributedText = [UIToolClass getAttributedStr:_model.roomUser font:leftLabel.font lineSpacing:4];
        rightLabel.height = [UIToolClass attributedTextHeight:rightLabel.attributedText width:rightLabel.width];
        [_scrollView addSubview:rightLabel];
        
        if (_model.roomBooker.length || _model.bookerTel.length || _model.showedCostCredit > 0){
            MYMaskView *line = [MYMaskView maskViewWithBgColor:kBgColor frame:CGRectMake(8, rightLabel.maxY + 10, kScreenWidth-16, kLineThick) radius:0];
            [_scrollView addSubview:line];
            
            offsetY = line.maxY + 10;
        }else{
            offsetY = rightLabel.maxY + 10;
        }
    }
    
    //预订联系人
    if (_model.roomBooker.length) {
        leftLabel = [self getLeftLabel:CGRectMake(10, offsetY, leftWidth, fontHeight)];
        leftLabel.text = @"预订联系人：";
        [_scrollView addSubview:leftLabel];
        leftLabel.width = [UIToolClass textWidth:leftLabel.text font:leftLabel.font];
        
        rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftLabel.maxX+5, leftLabel.originalY, kScreenWidth-10-leftLabel.maxX-5, 0)];
        rightLabel.numberOfLines = 0;
        rightLabel.textColor = leftLabel.textColor;
        rightLabel.font = leftLabel.font;
        rightLabel.attributedText = [UIToolClass getAttributedStr:_model.roomBooker font:leftLabel.font lineSpacing:4];
        rightLabel.height = [UIToolClass attributedTextHeight:rightLabel.attributedText width:rightLabel.width];
        [_scrollView addSubview:rightLabel];
        
        if (_model.bookerTel.length || _model.showedCostCredit > 0){
            MYMaskView *line = [MYMaskView maskViewWithBgColor:kBgColor frame:CGRectMake(8, rightLabel.maxY + 10, kScreenWidth-16, kLineThick) radius:0];
            [_scrollView addSubview:line];
            
            offsetY = line.maxY + 10;
        }else{
            offsetY = rightLabel.maxY + 10;
        }
    }
    
    //联系人手机
    if (_model.bookerTel.length) {
        leftLabel = [self getLeftLabel:CGRectMake(10, offsetY, leftWidth, fontHeight)];
        leftLabel.text = @"联系人手机：";
        [_scrollView addSubview:leftLabel];
        leftLabel.width = [UIToolClass textWidth:leftLabel.text font:leftLabel.font];
        
        rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftLabel.maxX+5, leftLabel.originalY, kScreenWidth-10-leftLabel.maxX-5, 0)];
        rightLabel.numberOfLines = 0;
        rightLabel.textColor = leftLabel.textColor;
        rightLabel.font = leftLabel.font;
        rightLabel.attributedText = [UIToolClass getAttributedStr:_model.bookerTel font:rightLabel.font lineSpacing:4];
        rightLabel.height = [UIToolClass attributedTextHeight:rightLabel.attributedText width:rightLabel.width];
        [_scrollView addSubview:rightLabel];
        
        if (_model.showedCostCredit > 0){
            MYMaskView *line = [MYMaskView maskViewWithBgColor:kBgColor frame:CGRectMake(8, rightLabel.maxY + 10, kScreenWidth-16, kLineThick) radius:0];
            [_scrollView addSubview:line];
            
            offsetY = line.maxY + 10;
        }else{
            offsetY = rightLabel.maxY + 10;
        }
    }
    
    //积分
    if (_model.showedCostCredit > 0) {
        leftLabel = [self getLeftLabel:CGRectMake(10, offsetY, leftWidth, fontHeight)];
        leftLabel.text = @"积  分：";
        [_scrollView addSubview:leftLabel];
        
        rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftLabel.maxX+5, leftLabel.originalY, rightWidth, fontHeight)];
        rightLabel.numberOfLines = 0;
        rightLabel.textColor = ColorFromHex(@"C05459");
        rightLabel.font = leftLabel.font;
        rightLabel.text = StrFromInt(_model.showedCostCredit);
        [_scrollView addSubview:rightLabel];
        
        offsetY = rightLabel.maxY + 10;
    }
    
    offsetY += 8;
    
    MYMaskView *line = [MYMaskView maskViewWithBgColor:kBgColor frame:CGRectMake(0, offsetY, kScreenWidth, 8) radius:0];
    [_scrollView addSubview:line];
    
    if (_model.isUnParticipateOrder){
        [self creatOrderNumberView:line.maxY];/* 取票码 */
    }else{
        [self creatVenueInfoView:line.maxY];/* 所在场馆的信息 */
    }
}

//取票码
- (void)creatOrderNumberView:(CGFloat)position
{
    UILabel *orderNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, position+18, kScreenWidth-20, [UIToolClass fontHeight:FontYT(16)])];
    orderNumLabel.font = FontYT(16);
    orderNumLabel.numberOfLines = 0;
    orderNumLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [_scrollView addSubview:orderNumLabel];
    
    NSString *string = [NSString stringWithFormat:@"取票码：%@",_model.checkCode];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    [attributedString addAttribute:NSForegroundColorAttributeName value:ColorFromHex(@"1E1E1E") range:NSMakeRange(0, 4)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:kLightRedColor range:NSMakeRange(4, string.length-4)];
    orderNumLabel.attributedText = attributedString;
    
    //二维码
    UIImageView *qrImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, orderNumLabel.maxY+10, 142, 142)];;
    UIImage *placeImg = [UIToolClass getPlaceholderWithViewSize:qrImgView.viewSize centerSize:CGSizeMake(30, 30) isBorder:YES];
    [qrImgView sd_setImageWithURL:[NSURL URLWithString:_model.qrCodeImgUrl] placeholderImage:placeImg];
    [_scrollView addSubview:qrImgView];
    qrImgView.centerX = kScreenWidth*0.5;
    
    //提示
    UILabel *noticeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, qrImgView.maxY+10, kScreenWidth, [UIToolClass fontHeight:FontYT(14)])];
    noticeLabel.font = FontYT(14);
    noticeLabel.textColor = ColorFromHex(@"1E1E1E");
    noticeLabel.textAlignment = NSTextAlignmentCenter;
    noticeLabel.text = @"出示二维码或取票码验证使用";
    [_scrollView addSubview:noticeLabel];
    
    
    MYMaskView *line = [MYMaskView maskViewWithBgColor:kBgColor frame:CGRectMake(0, noticeLabel.maxY+20, kScreenWidth, 8) radius:0];
    [_scrollView addSubview:line];
    
    /* 场馆信息 */
    [self creatVenueInfoView:line.maxY];
}


//场馆信息
- (void)creatVenueInfoView:(CGFloat)position
{
    UILabel *venueNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, position+10, kScreenWidth-35, [UIToolClass fontHeight:FontYT(16)])];
    venueNameLabel.font = FontYT(16);
    venueNameLabel.textColor = ColorFromHex(@"1E1E1E");
    venueNameLabel.text = _model.venueName;
    [_scrollView addSubview:venueNameLabel];
    
    UILabel *venueAddressLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, venueNameLabel.maxY+8, kScreenWidth-20, [UIToolClass fontHeight:FontYT(14)])];
    venueAddressLabel.font = FontYT(14);
    venueAddressLabel.textColor = [UIColor lightGrayColor];
    venueAddressLabel.text = _model.venueAddress;
    [_scrollView addSubview:venueAddressLabel];
    
    //按钮
    UIButton *venueButton = [[UIButton alloc] initWithFrame:CGRectMake(0, position, kScreenWidth, venueAddressLabel.maxY+10-position)];
    venueButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    venueButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [venueButton setImage:IMG(@"icon_arrow_right_gray") forState:UIControlStateNormal];
    venueButton.tag = 2;
    [venueButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:venueButton];
    
    MYMaskView *line = [MYMaskView maskViewWithBgColor:kBgColor frame:CGRectMake(0, venueButton.maxY, kScreenWidth, 8) radius:0];
    [_scrollView addSubview:line];
    
    [self creatOrderPayInfoView:line.maxY];
}

//订单的支付信息
- (void)creatOrderPayInfoView:(CGFloat)position
{
    NSMutableArray *stringArray = [[NSMutableArray alloc] initWithCapacity:3];
    if (_model.orderNumber.length) {
        [stringArray addObject:[NSString stringWithFormat:@"订  单  号：%@",[ToolClass getSpaceSeparatedString:_model.orderNumber length:4]]];
    }
    if (_model.orderCreatTime.length) {
        [stringArray addObject:[NSString stringWithFormat:@"下单时间：%@",_model.orderCreatTime]];
    }
    //支付信息暂时不需要
    if (_model.orderPayTime.length) {
        [stringArray addObject:[NSString stringWithFormat:@"支付时间：%@",_model.orderPayTime]];
    }
    position += 18;
    
    CGFloat fontHeight = [UIToolClass fontHeight:FontYT(15)];
    for (NSString *string in stringArray) {
        
        UILabel *orderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, position, kScreenWidth-20, fontHeight)];
        orderLabel.font = FontYT(15);
        orderLabel.textColor = [UIColor lightGrayColor];
        orderLabel.text = string;
        [_scrollView addSubview:orderLabel];
        
        position += orderLabel.height + 8;
    }
    position += 10;
    
    MYMaskView *line = [MYMaskView maskViewWithBgColor:kLineGrayColor frame:CGRectMake(8, position, kScreenWidth-16, 0.7) radius:0];
    [_scrollView addSubview:line];
    
    // 帮助中心
    UILabel *helpLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, line.maxY+18, kScreenWidth-20, [UIToolClass fontHeight:FontYT(18)])];
    helpLabel.font = FontYT(18);
    helpLabel.textColor = [UIToolClass colorFromHex:@"1E1E1E"];
    helpLabel.text = @"帮助中心";
    [_scrollView addSubview:helpLabel];
    
    //按钮
    UIButton *helpButton = [[UIButton alloc] initWithFrame:CGRectMake(0, position, kScreenWidth, helpLabel.maxY+18-position)];
    helpButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    helpButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [helpButton setImage:IMG(@"icon_arrow_right_gray") forState:UIControlStateNormal];
    helpButton.tag = 3;
    [helpButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:helpButton];
    
    _scrollView.contentSize = CGSizeMake(kScreenWidth, MAX(helpButton.maxY+25, _scrollView.height));
    
    [self creatToolBarView];
}


//底部的工具栏
- (void)creatToolBarView
{
    UIView *toolView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-HEIGHT_TOP_BAR-50-HEIGHT_HOME_INDICATOR, kScreenWidth, 50+HEIGHT_HOME_INDICATOR)];
    [self.view addSubview:toolView];
    
    MYMaskView *line = [MYMaskView maskViewWithBgColor:RGB(225, 225, 225) frame:CGRectMake(0, 0, kScreenWidth, 0.6) radius:0];
    [toolView addSubview:line];
    
    //按钮
    _rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth*0.5, line.maxY, kScreenWidth*0.5, 50)];
    [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _rightBtn.backgroundColor = RGB(204, 204, 204);
    _rightBtn.titleLabel.font = FontYT(20);
    _rightBtn.tag = 5;
    [_rightBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [toolView addSubview:_rightBtn];
    
    _leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, line.maxY, kScreenWidth*0.5, 50)];
    _leftBtn.backgroundColor = [UIColor whiteColor];
    _leftBtn.titleLabel.font = FontYT(20);
    [_leftBtn setTitleColor:kThemeDeepColor forState:UIControlStateNormal];
    [_leftBtn setTitle:@"取消订单" forState:UIControlStateNormal];
    _leftBtn.tag = 4;
    [_leftBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [toolView addSubview:_leftBtn];
    
    /*
     
     订单预订状态：
     0-需考虑认证状态 1-预订成功  2-已取消  3-已出票  4-已验票  5-已过期  6-已删除 7-审核未通过
     订单认证状态：
     -1.未定义的认证状态  0-未实名认证  1-实名认证中  2-实名认证未通过  3-未资质认证  4-资质认证中  5-资质认证未通过  6-资质认证已通过 7-使用者被冻结 (3-7表明实名认证已通过)
     */
    
    
    if (_model.orderStatus > 0)
    {
        _rightBtn.userInteractionEnabled = NO;
        
        switch (_model.orderStatus) {
            case 1:
                if (_model.tUserIsFreeze) {
                    [_rightBtn removeFromSuperview];
                    _rightBtn = nil;
                    _leftBtn.width = kScreenWidth;
                }else{
                    [_rightBtn setTitle:@"待使用" forState:UIControlStateNormal];
                }
                break;
            case 2: {
                [_leftBtn removeFromSuperview];
                _rightBtn.width = kScreenWidth;
                _rightBtn.originalX = 0;
                [_rightBtn setTitle:@"已取消" forState:UIControlStateNormal];
            } break;
            case 3:
                if (_model.tUserIsFreeze) {
                    [_rightBtn removeFromSuperview];
                    _rightBtn = nil;
                    _leftBtn.width = kScreenWidth;
                }else{
                    [_rightBtn setTitle:@"待使用" forState:UIControlStateNormal];
                }
                break;
            case 4:{
                [_leftBtn removeFromSuperview];
                _rightBtn.width = kScreenWidth;
                _rightBtn.originalX = 0;
                [_rightBtn setTitle:@"已使用" forState:UIControlStateNormal]; break;
            }
            case 5:{
                [_leftBtn removeFromSuperview];
                _rightBtn.width = kScreenWidth;
                _rightBtn.originalX = 0;
                [_rightBtn setTitle:@"已过期" forState:UIControlStateNormal]; break;
            }
            case 6:{
                [_leftBtn removeFromSuperview];
                _rightBtn.width = kScreenWidth;
                _rightBtn.originalX = 0;
                [_rightBtn setTitle:@"已删除" forState:UIControlStateNormal]; break;
            }
            case 7:{
                [_leftBtn removeFromSuperview];
                _rightBtn.width = kScreenWidth;
                _rightBtn.originalX = 0;
                [_rightBtn setTitle:@"审核未通过" forState:UIControlStateNormal]; break;
            }
                
            default:
                break;
        }
    }
    else if (_model.orderStatus == 0)
    {
        if (_model.tUserIsFreeze) {//被冻结时，只能取消订单
            _leftBtn.width = kScreenWidth;
            [_rightBtn removeFromSuperview];
            _rightBtn = nil;
        }else{
            if (_model.certifyStatus == 6) {//实名和资质认证均通过，但订单未通过
                [_rightBtn setTitle:@"待审核" forState:UIControlStateNormal];
                _rightBtn.userInteractionEnabled = NO;
            }
            else
            {
                _rightBtn.userInteractionEnabled = YES;//右侧按钮可点击
                if (_model.certifyStatus == 1 || _model.certifyStatus == 4) {
                    [_rightBtn setTitle:@"认证中" forState:UIControlStateNormal];
                }else{
                    [_rightBtn setTitle:@"前往认证" forState:UIControlStateNormal];
                }
                _rightBtn.backgroundColor = kThemeDeepColor;
            }
        }
        
    }else{
        [_leftBtn removeFromSuperview];
        [_rightBtn removeFromSuperview];
    }
}



- (UILabel *)getLeftLabel:(CGRect)rect
{
    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    label.font = FontYT(15);
    label.textColor = kDeepLabelColor;
    
    return label;
}

#pragma mark - 按钮的点击事件

- (void)buttonClick:(UIButton *)sender
{
    switch (sender.tag) {
        case 1://活动室详情
        {
            if (_model.modelId.length) {
                ActivityRoomDetailViewController *vc = [ActivityRoomDetailViewController new];
                vc.roomId = _model.modelId;
                vc.roomName = _model.titleStr;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
            break;
        case 2://场馆位置查看
        {
            if (_model.latitude < 0.1 && _model.longitude < 0.1){
                [SVProgressHUD showInfoWithStatus:@"暂无相关位置信息!"];
                return;
            }
            NearbyLocationViewController *vc = [NearbyLocationViewController new];
            vc.type = DataTypeVenue;
            vc.locationCoordinate2D = CLLocationCoordinate2DMake(_model.latitude, _model.longitude);
            vc.addressString = _model.venueAddress;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:
        {
            WebViewController *webVC = [WebViewController new];
            webVC.url = kHelpCenterUrl;
            webVC.navTitle = @"使用帮助";
            [self.navigationController pushViewController:webVC animated:YES];
        }
            break;
        case 4:
        {
            WS(weakSelf)
            [WHYAlertActionUtil showAlertWithTitle:@"温馨提示" msg:@"确认要取消该订单吗？取消后将无法撤回。" actionBlock:^(NSInteger index, NSString *buttonTitle) {
                if (index == 1) {
                    [weakSelf cancelOrderRequest];
                }
            } buttonTitles:@"取消", @"确认", nil];
        }
            break;
        case 5:
        {
            //认证按钮
            //            -1.未定义的认证状态  0-未实名认证  1-实名认证中  2-实名认证未通过  3-未资质认证  4-资质认证中  5-资质认证未通过  6-资质认证已通过 7-使用者被冻结 (3-7表明实名认证已通过)
            NSString *userId = [UserService sharedService].userId;
            
            if (_model.certifyStatus > -1 && _model.certifyStatus < 3) {
                //需进行实名认证
                
                WebViewController *vc = [WebViewController new];
                vc.navTitle = @"实名认证";
                vc.url = [NSString stringWithFormat:@"%@&userId=%@&roomOrderId=%@&tuserName=%@&tuserId=%@", kRealNameAuthUrl, userId, _model.orderId,_model.roomUser,_model.roomUserId];
                [self.navigationController pushViewController:vc animated:YES];
                
            }else if (_model.certifyStatus > 2 && _model.certifyStatus < 6) {
                
                WebViewController *vc = [WebViewController new];
                vc.navTitle = @"资质认证";
                vc.url = [NSString stringWithFormat:@"%@&userId=%@&roomOrderId=%@&tuserName=%@&tuserId=%@", kQualificationAuthUrl, userId, _model.orderId,_model.roomUser,_model.roomUserId];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
            break;
            
        default:
            break;
    }
}

//无消息时的提示
- (void)noMessageNotice:(NSString *)message
{
    WS(weakSelf);
    
    NoDataNoticeView *noticeView = [NoDataNoticeView noticeViewWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-HEIGHT_TOP_BAR-HEIGHT_HOME_INDICATOR) bgColor:[UIColor whiteColor] message:message promptStyle:NoDataPromptStyleClickRefreshForError callbackBlock:^(id object, NSInteger index, BOOL isSameIndex) {
        [weakSelf startRequestOrderDetailData];
    }];
    [self.view addSubview:noticeView];
}



- (void)updateBottomView:(NSString *)status
{
    [_leftBtn removeFromSuperview];
    _leftBtn = nil;
    
    _rightBtn.originalX = 0;
    _rightBtn.width = kScreenWidth;
    
    [_rightBtn setTitle:status forState:UIControlStateNormal];
    [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _rightBtn.backgroundColor = RGB(204, 204, 204);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
