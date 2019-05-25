//
//  ActivityRoomBookSuccessViewController.m
//  CultureHongshan
//
//  Created by JackAndney on 16/5/29.
//  Copyright © 2016年 CT. All rights reserved.
//

#import "ActivityRoomBookSuccessViewController.h"

// Model
#import "ActivityRoomOrderConfirmModel.h"

// ViewController
#import "MyOrderViewController.h"
#import "WebViewController.h"
#import "ActivityRoomDetailViewController.h"

// Other
#import "AppProtocolMacros.h"

@interface ActivityRoomBookSuccessViewController ()
{
    UIScrollView *_bgScrollView;
}

@end

@implementation ActivityRoomBookSuccessViewController




- (void)viewDidLoad
{
    [super viewDidLoad];
    if (_tUserId.length < 1) {
        _tUserId = @"";
    }
    self.navigationItem.title = @"活动室预订";
    self.view.backgroundColor = kBgColor;
    
    [self initSubviews];
}


#pragma mark - 数据请求


- (void)initSubviews
{
    if (_bgScrollView) {
        [_bgScrollView removeFromSuperview];
        _bgScrollView = nil;
    }
    
    _bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-HEIGHT_TOP_BAR-50-HEIGHT_HOME_INDICATOR)];
    _bgScrollView.backgroundColor = [UIColor whiteColor];
    _bgScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_bgScrollView];
    
    //底部的按钮
    UIButton *orderButton = [[UIButton alloc] initWithFrame:CGRectMake(0, _bgScrollView.maxY, kScreenWidth, 50)];
    orderButton.tag = 3;
    orderButton.backgroundColor = [UIToolClass colorFromHex:@"F5F5F5"];
    orderButton.titleLabel.font = FontYT(20);
    [orderButton setTitle:@"进入我的订单" forState:UIControlStateNormal];
    [orderButton setTitleColor:kThemeDeepColor forState:UIControlStateNormal];
    [orderButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:orderButton];
    
    MYMaskView *topLine = [MYMaskView maskViewWithBgColor:[UIToolClass colorFromHex:@"E1E1E1"] frame:CGRectMake(0, 0, kScreenWidth, 0.7) radius:0];
    [orderButton addSubview:topLine];
    
    //提交成功，请等待审核
    [self initTopView];
}

//提交成功，请等待审核
- (void)initTopView
{
    MYMaskView *topView = [MYMaskView maskViewWithBgColor:kThemeDeepColor frame:CGRectMake(0, 0, kScreenWidth, 125) radius:0];
    [_bgScrollView addSubview:topView];
    
    //标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 17.5, kScreenWidth-40, 0)];
    titleLabel.font = FontYT(22);
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"提交成功，请等待审核!";
    [topView addSubview:titleLabel];
    titleLabel.height = [UIToolClass fontHeight:titleLabel.font];
    
    //提示信息
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.originalX, titleLabel.maxY+10, titleLabel.width, 0)];
    messageLabel.textColor = [UIColor whiteColor];
    messageLabel.numberOfLines = 0;
    messageLabel.attributedText = [UIToolClass getAttributedStr:@"您的活动室预约信息已提交成功，我们将在3个工作日之内予以审核，请及时关注短信通知，谢谢!" font:FontYT(13) lineSpacing:4];
    [topView addSubview:messageLabel];
    messageLabel.height = [UIToolClass attributedTextHeight:messageLabel.attributedText width:messageLabel.width];
    
    //活动室的预订信息
    [self initMiddleView:topView.maxY];
}

//活动室的预订信息
- (void)initMiddleView:(CGFloat)position
{
    UILabel *roomNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, position+20, kScreenWidth-40, 0)];
    roomNameLabel.textColor = [UIToolClass colorFromHex:@"262626"];
    roomNameLabel.numberOfLines = 0;
    roomNameLabel.attributedText = [UIToolClass getAttributedStr:_model.roomName font:FontYT(16) lineSpacing:5];
    roomNameLabel.height = [UIToolClass attributedTextHeight:roomNameLabel.attributedText width:roomNameLabel.width];
    [_bgScrollView addSubview:roomNameLabel];
    
    
    CGFloat leftWidth = [UIToolClass textWidth:@"使用人：" font:FontYT(15)]+10;
    CGFloat rightWidth = kScreenWidth-40-leftWidth;
    
    //场馆
    UILabel *leftLabel = [self getLeftLabel:@"场    馆：" width:leftWidth offsetY:roomNameLabel.maxY+20];
    [_bgScrollView addSubview:leftLabel];
    
    UILabel *rightLabel = [self getRightLabel:_model.venueName width:rightWidth offsetX:leftLabel.maxX offsetY:leftLabel.originalY];
    [_bgScrollView addSubview:rightLabel];
    //日期
    leftLabel = [self getLeftLabel:@"日    期：" width:leftWidth offsetY:rightLabel.maxY+8];
    [_bgScrollView addSubview:leftLabel];
    
    rightLabel = [self getRightLabel:[NSString stringWithFormat:@"%@  %@",_model.roomDate,_model.openPeriod] width:rightWidth offsetX:leftLabel.maxX offsetY:leftLabel.originalY];
    [_bgScrollView addSubview:rightLabel];
    //使用人
    leftLabel = [self getLeftLabel:@"使用人：" width:leftWidth offsetY:rightLabel.maxY+8];
    [_bgScrollView addSubview:leftLabel];
    
    rightLabel = [self getRightLabel:_model.tUserName width:rightWidth offsetX:leftLabel.maxX offsetY:leftLabel.originalY];
    [_bgScrollView addSubview:rightLabel];
    //联系人
    leftLabel = [self getLeftLabel:@"联系人：" width:leftWidth offsetY:rightLabel.maxY+8];
    [_bgScrollView addSubview:leftLabel];
    
    rightLabel = [self getRightLabel:[NSString stringWithFormat:@"%@   %@",_model.orderName, _model.orderTel] width:rightWidth offsetX:leftLabel.maxX offsetY:leftLabel.originalY];
    [_bgScrollView addSubview:rightLabel];
    
    /*
     
     
     */
    
    if ( !(_model.userType == 2 && _model.tUserIsDisplay == 1 && self.tUserId.length)){
        //分割线
        MYMaskView *lineView = [MYMaskView maskViewWithBgColor:kLineGrayColor frame:CGRectMake(8, rightLabel.maxY+25, kScreenWidth-16, 0.8) radius:0];
        [_bgScrollView addSubview:lineView];
        
        //认证提醒与前往认证
        [self initBottomView:lineView.maxY+27.5];
    }else{
        _bgScrollView.contentSize = CGSizeMake(_bgScrollView.width, MAX(rightLabel.maxY+50, _bgScrollView.height));
    }
}


//认证提醒与前往认证
- (void)initBottomView:(CGFloat)position
{
    //提示信息
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, position, kScreenWidth-40, 0)];
    messageLabel.textColor = kLightRedColor;//C05459
    messageLabel.numberOfLines = 0;
    messageLabel.attributedText = [UIToolClass getAttributedStr:@"本活动室预约需要进行实名认证，请进行资料完善，以便通过预约审核，谢谢!" font:FontYT(13) lineSpacing:5];
    [_bgScrollView addSubview:messageLabel];
    messageLabel.height = [UIToolClass attributedTextHeight:messageLabel.attributedText width:messageLabel.width];
    
    //认证按钮
    UIButton *certifyButton = [[UIButton alloc] initWithFrame:CGRectMake(0, messageLabel.maxY+30, 145, 40)];
    certifyButton.tag = 2;
    certifyButton.radius = 4;
    certifyButton.layer.borderColor = [UIToolClass colorFromHex:@"CCCCCC"].CGColor;
    certifyButton.layer.borderWidth = 0.6;
    certifyButton.backgroundColor = kThemeDeepColor;
    certifyButton.titleLabel.font = FontSystemBold(17);
    [certifyButton setTitle:@"前 往 认 证" forState:UIControlStateNormal];
    [certifyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [certifyButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bgScrollView addSubview:certifyButton];
    certifyButton.centerX = kScreenWidth*0.5;
    
    _bgScrollView.contentSize = CGSizeMake(_bgScrollView.width, MAX(certifyButton.maxY+50, _bgScrollView.height));
}


#pragma mark - 按钮的点击事件

- (void)popViewController
{
    NSArray *vcArray = self.navigationController.viewControllers;
    for (NSInteger i = vcArray.count-1; i > -1; i--){
        UIViewController *vc = vcArray[i];
        if ([vc isKindOfClass:[ActivityRoomDetailViewController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
    [super popViewController];
}

- (void)buttonClick:(UIButton *)sender
{
    switch (sender.tag) {
        case 2://前往认证
        {
            NSString *userId = [UserService sharedService].userId;
            
            WebViewController *vc = [WebViewController new];
            
            if (_model.userType != 2) {
                /*
                 除了“实名认证已通过”，其它都需要跳转到“实名认证页面”
                 */
                vc.navTitle = @"实名认证";
                vc.url = [NSString stringWithFormat:@"%@&userId=%@&roomOrderId=%@&tuserName=%@&tuserId=%@&tuserIsDisplay=%@&userType=%@", kRealNameAuthUrl, userId, _model.orderId,_model.tUserName,self.tUserId,StrFromInt(_model.tUserIsDisplay),StrFromInt(_model.userType)];
            }else{
                //冻结的用户不会出现在“使用者list”中
                if ( !(self.tUserId.length && _model.tUserIsDisplay == 1) ) {
                    vc.navTitle = @"资质认证";
                    vc.url = [NSString stringWithFormat:@"%@&userId=%@&roomOrderId=%@&tuserName=%@&tuserId=%@&tuserIsDisplay=%@&userType=%@", kQualificationAuthUrl, userId, _model.orderId,_model.tUserName, self.tUserId,StrFromInt(_model.tUserIsDisplay),StrFromInt(_model.userType)];
                }
            }
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3://进入我的订单
        {
            MyOrderViewController *vc = [MyOrderViewController new];
            vc.selectedIndex = 0;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }
}


#pragma mark - 其它方法

- (UILabel *)getLeftLabel:(NSString *)title width:(CGFloat)width offsetY:(CGFloat)offsetY
{
    UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, offsetY, width, [UIToolClass fontHeight:FontYT(15)])];
    leftLabel.font = FontYT(15);
    leftLabel.text = title;
    leftLabel.textColor = [UIToolClass colorFromHex:@"262626"];
    return leftLabel;
}


- (UILabel *)getRightLabel:(NSString *)title width:(CGFloat)width offsetX:(CGFloat)offsetX offsetY:(CGFloat)offsetY
{
    UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(offsetX, offsetY, width, 0)];
    rightLabel.textColor = [UIToolClass colorFromHex:@"808080"];
    rightLabel.numberOfLines = 0;
    rightLabel.attributedText = [UIToolClass getAttributedStr:title font:FontYT(15) lineSpacing:6];
    rightLabel.height = [UIToolClass attributedTextHeight:rightLabel.attributedText width:rightLabel.width];
    return rightLabel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
