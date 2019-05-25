//
//  ActivityRoomDetailViewController.m
//  CultureHongshan
//
//  Created by one on 15/11/15.
//  Copyright © 2015年 CT. All rights reserved.
//

#import "ActivityRoomDetailViewController.h"


#import "ActivityRoomDetailModel.h"//活动室详情model
#import "ActivityRoomBookModel.h"

#import "ActivityRoomBookViewController.h"//预订活动室
#import "WebViewController.h"

#import "AnimationBackView.h"
#import "ActivityRoomScheduleView.h"
#import "AnimatedSpringPopupView.h"


@interface ActivityRoomDetailViewController ()<UIScrollViewDelegate>
{
    AnimationBackView *_animationView;
    
    UIImageView *_topImgView;
    UIImageView *_headerImgView;
    UIButton *_reserveBtn;
    
    ActivityRoomScheduleView *_scheduleView;//预订日程视图
}

@property (nonatomic, strong) ActivityRoomDetailModel *detailModel;

@end


@implementation ActivityRoomDetailViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = _roomName.length ? _roomName : @"活动室详情";
    
    _animationView = [[AnimationBackView alloc] initAnimationWithFrame:CGRectMake(0, 0, 100, 80)];
    [_animationView beginAnimationView];
    [self.view addSubview:_animationView];
    _animationView.center = CGPointMake(self.view.center.x, kScreenHeight/2-40);
    [self.view bringSubviewToFront:_animationView];
    
    [self loadRoomDetailData];
}

#pragma mark - 数据请求

// 活动室详情
- (void)loadRoomDetailData
{
    WS(weakSelf);
    [AppProtocol getPlayroomDetailWithPlayroomId:_roomId UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        
        if (responseCode == HttpResponseSuccess) {
            _animationView.isLoadAnimation = YES;
            _detailModel = responseObject;
            [weakSelf loadRoomDetailView];
            
            [SVProgressHUD dismiss];
        } else {
            [_animationView shutTimer];
            NSString *str = (NSString *)responseObject;
            if (_detailModel.openDateArray.count > 0) {
                [SVProgressHUD showInfoWithStatus:str];
            }else {
                [_animationView setAnimationLabelTextString: str];
            }
        }
    }];
}


//活动室预订
- (void)startActivityRoomBook
{
    NSString *bookId = [[ToolClass getComponentArray:_scheduleView.selectedDateAndTime separatedBy:@"|"] lastObject];
    
    _reserveBtn.userInteractionEnabled = NO;
    
    WS(weakSelf);
    [AppProtocol reservePlayroomWithPlayroomId:_roomId bookId:bookId UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        _reserveBtn.userInteractionEnabled = YES;
        
        if (responseCode == HttpResponseSuccess) {
            // 进入下一个页面
            ActivityRoomBookViewController *vc = [ActivityRoomBookViewController new];
            vc.model = responseObject;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }else {
            [SVProgressHUD showInfoWithStatus:responseObject];
        }
    }];
}


#pragma mark - 初始化视图

-(void)loadRoomDetailView
{
    _topImgView = [UIImageView new];
    
    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UIScrollView *bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-HEIGHT_TOP_BAR-HEIGHT_HOME_INDICATOR-50)];
    bgScrollView.tag = 50;
    bgScrollView.delegate = self;
    [UIToolClass setupDontAutoAdjustContentInsets:bgScrollView forController:self];
    [self.view addSubview:bgScrollView];
    
    _headerImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth*0.667)];
    UIImage *placeImg = [UIToolClass getPlaceholderWithViewSize:_headerImgView.viewSize centerSize:CGSizeMake(25, 25) isBorder:NO];
    
    [_headerImgView sd_setImageWithURL:[NSURL URLWithString:JointedImageURL(_detailModel.roomPicUrl, kImageSize_750_500)] placeholderImage:placeImg];
    [bgScrollView addSubview:_headerImgView];
    
    //蒙板
    UIImageView *maskView = [[UIImageView alloc] initWithFrame:CGRectMake(0, _headerImgView.height-189, _headerImgView.width, 189)];
    maskView.image = IMG(@"蒙板");
    [_headerImgView addSubview:maskView];
    
    //活动室标签
    NSDictionary *layoutAttributes = @{MYShowOnlySingleLineAttributeName:@"YES",
                                       MYLabelPaddingAttributeName:@"12",
                                       MYItemHeightAttributeName:@"22",
                                       MYFontAttributeName:FontYT(13),
                                       MYSpacingXAttributeName:@"5",
                                       MYOffsetXAttributeName:@"10",
                                       MYOffsetYAttributeName:StrFromFloat(maskView.height-15-22),
                                       MYContainerWidthAttributeName:StrFromFloat(maskView.width - 8),
                                       };
    NSDictionary *labelAttributes = @{kLabelTextColor:[UIColor whiteColor],
                                      kLabelBgColor:[UIColor clearColor],
                                      kLabelBorderColor:[UIColor whiteColor],
                                      kLabelBorderWidth:@"0.6",
                                      kLabelCornerRadius:@"4",
                                      };
    [ToolClass addSubview:maskView titleArray:_detailModel.roomTagNames attributes:layoutAttributes labelAttributes:labelAttributes clearSubviews:NO contentHeight:nil];
    
    CGFloat offsetY = 20 + _headerImgView.maxY;
    CGFloat spacingY = 8;
    CGFloat leftWidth = [UIToolClass textWidth:@"电话：" font:FontYT(15)];
    CGFloat rightWidth = kScreenWidth - 20-leftWidth-3;
    CGFloat fontHeight = [UIToolClass fontHeight:FONT(15)];
    
    UILabel *leftLabel = nil;
    UILabel *rightLabel = nil;
    UIView *lineView = nil;
    
    //电话
    if (_detailModel.roomConsultTel.length)
    {
        leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, offsetY, leftWidth, fontHeight)];
        leftLabel.textColor = kDeepLabelColor;
        leftLabel.font = FONT(15);
        leftLabel.text = @"电话：";
        [bgScrollView addSubview:leftLabel];
        
        rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftLabel.maxX+3, leftLabel.originalY, rightWidth, fontHeight)];
        rightLabel.textColor = kThemeDeepColor;
        rightLabel.font = FONT(15);
        rightLabel.text = _detailModel.roomConsultTel;
        [bgScrollView addSubview:rightLabel];
        
        lineView = [[UIView alloc] initWithFrame:CGRectMake(10, rightLabel.maxY+spacingY, kScreenWidth-20, 0.5)];
        lineView.backgroundColor = ColorFromHex(@"DFDFDF");
        [bgScrollView addSubview:lineView];
        
        offsetY = lineView.maxY + 20;
        
        //打电话按钮
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, _headerImgView.maxY, kScreenWidth, lineView.maxY-_headerImgView.maxY)];
        button.tag = 2;
        [button addTarget:self action:@selector(activityRoomDetailButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [bgScrollView addSubview:button];
    }
    
    //面积
    if (_detailModel.roomArea.length)
    {
        leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, offsetY, leftWidth, fontHeight)];
        leftLabel.textColor = kDeepLabelColor;
        leftLabel.font = FONT(15);
        leftLabel.text = @"面积：";
        [bgScrollView addSubview:leftLabel];
        
        rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftLabel.maxX+3, leftLabel.originalY, rightWidth, fontHeight)];
        rightLabel.textColor = leftLabel.textColor;
        rightLabel.font = FONT(15);
        rightLabel.text = [NSString stringWithFormat:@"%@ 平米",_detailModel.roomArea];
        [bgScrollView addSubview:rightLabel];
        
        lineView = [[UIView alloc] initWithFrame:CGRectMake(10, rightLabel.maxY+spacingY, kScreenWidth-20, 0.5)];
        lineView.backgroundColor = ColorFromHex(@"DFDFDF");
        [bgScrollView addSubview:lineView];
        
        offsetY = lineView.maxY + 20;
    }
    
    //容纳
    if (_detailModel.roomConsultTel.length)
    {
        leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, offsetY, leftWidth, fontHeight)];
        leftLabel.textColor = kDeepLabelColor;
        leftLabel.font = FONT(15);
        leftLabel.text = @"容纳：";
        [bgScrollView addSubview:leftLabel];
        
        rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftLabel.maxX+3, leftLabel.originalY, rightWidth, fontHeight)];
        rightLabel.textColor = leftLabel.textColor;
        rightLabel.font = FONT(15);
        rightLabel.text = [NSString stringWithFormat:@"%@ 人",_detailModel.roomCapacity];
        [bgScrollView addSubview:rightLabel];
        
        lineView = [[UIView alloc] initWithFrame:CGRectMake(10, rightLabel.maxY+spacingY, kScreenWidth-20, 0.5)];
        lineView.backgroundColor = ColorFromHex(@"DFDFDF");
        [bgScrollView addSubview:lineView];
        
        offsetY = lineView.maxY + 20;
    }
    
    //费用
    leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, offsetY, leftWidth, fontHeight)];
    leftLabel.textColor = kDeepLabelColor;
    leftLabel.font = FONT(15);
    leftLabel.text = @"费用：";
    [bgScrollView addSubview:leftLabel];
    
    rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftLabel.maxX+3, leftLabel.originalY, rightWidth, 0)];
    rightLabel.textColor = leftLabel.textColor;
    rightLabel.numberOfLines = 0;
    rightLabel.font = FONT(15);
    NSString *priceStr = @"免费";
    if (_detailModel.roomIsFree == NO) {//收费
        if (_detailModel.roomFee.length > 0) {
            if ([DataValidate isPureFloat:_detailModel.roomFee]) {
                priceStr = [NSString stringWithFormat:@"%@ 元/人",_detailModel.roomFee];
            }else{
                priceStr = _detailModel.roomFee;
            }
        }else{
            priceStr = @"收费";
        }
    }
    rightLabel.attributedText = [UIToolClass getAttributedStr:priceStr font:rightLabel.font lineSpacing:4];
    rightLabel.height = [UIToolClass attributedTextHeight:rightLabel.attributedText width:rightWidth];
    [bgScrollView addSubview:rightLabel];
    
    if (_detailModel.roomRemark.length || _detailModel.facilityArray.count) {
        
        lineView = [[UIView alloc] initWithFrame:CGRectMake(10, rightLabel.maxY+spacingY, kScreenWidth-20, 0.5)];
        lineView.backgroundColor = ColorFromHex(@"DFDFDF");
        [bgScrollView addSubview:lineView];
        
        offsetY = lineView.maxY + 20;
    }else{
        offsetY += spacingY+10;
    }
    
    //备注
    if (_detailModel.roomRemark.length)
    {
        leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, offsetY, leftWidth, fontHeight)];
        leftLabel.textColor = kDeepLabelColor;
        leftLabel.font = FONT(15);
        leftLabel.text = @"备注：";
        [bgScrollView addSubview:leftLabel];
        
        rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftLabel.maxX+3, leftLabel.originalY, rightWidth, 0)];
        rightLabel.textColor = leftLabel.textColor;
        rightLabel.font = FONT(15);
        rightLabel.numberOfLines = 0;
        rightLabel.attributedText = [UIToolClass getAttributedStr:_detailModel.roomRemark font:rightLabel.font lineSpacing:4];
        rightLabel.height = [UIToolClass attributedTextHeight:rightLabel.attributedText width:rightWidth];
        [bgScrollView addSubview:rightLabel];
        
        lineView = [[UIView alloc] initWithFrame:CGRectMake(10, rightLabel.maxY+spacingY, kScreenWidth-20, 0.5)];
        lineView.backgroundColor = ColorFromHex(@"DFDFDF");
        [bgScrollView addSubview:lineView];
        
        offsetY = lineView.maxY + 20;
    }
    
    //设备
    if (_detailModel.facilityArray.count)
    {
        leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, offsetY, leftWidth, fontHeight)];
        leftLabel.textColor = kDeepLabelColor;
        leftLabel.font = FONT(15);
        leftLabel.text = @"设备：";
        [bgScrollView addSubview:leftLabel];
        
        layoutAttributes = @{MYLabelPaddingAttributeName:@"12",
                             MYItemHeightAttributeName:@"22",
                             MYFontAttributeName:FontYT(14),
                             MYSpacingXAttributeName:@"5",
                             MYOffsetXAttributeName:StrFromFloat(leftLabel.maxX+ 3),
                             MYOffsetYAttributeName:StrFromFloat(offsetY-3),
                             MYContainerWidthAttributeName:StrFromFloat(self.view.width - 10),
                             };
        labelAttributes = @{kLabelTextColor:kLightLabelColor,
                            kLabelBgColor:[UIColor clearColor],
                            kLabelBorderColor:kLightLabelColor,
                            kLabelBorderWidth:@"0.6",
                            kLabelCornerRadius:@"4",
                            };
        
        CGFloat contentHeight = 0;
        [ToolClass addSubview:bgScrollView titleArray:_detailModel.facilityArray attributes:layoutAttributes labelAttributes:labelAttributes clearSubviews:NO contentHeight:&contentHeight];
        
        offsetY += contentHeight;
    }else{
        offsetY -= 10;
    }
    
    //预订时间的排期
    if (_detailModel.openDateArray.count > 0) {
        MYMaskView *lineView = [MYMaskView maskViewWithBgColor:kBgColor frame:CGRectMake(0, offsetY+30, kScreenWidth, 7) radius:0];
        [bgScrollView addSubview:lineView];
        
        _scheduleView = [[ActivityRoomScheduleView alloc] initWithFrame:CGRectMake(0, lineView.maxY, kScreenWidth, 0) dataArray:_detailModel.openDateArray];
        [bgScrollView addSubview:_scheduleView];
        
        offsetY = _scheduleView.maxY;
        
        MYMaskView *bottomBaseView = [MYMaskView maskViewWithBgColor:kBgColor frame:CGRectMake(0, offsetY+10, kScreenWidth, kScreenHeight) radius:0];
        [bgScrollView addSubview:bottomBaseView];
    }
    
    bgScrollView.contentSize = CGSizeMake(self.view.width, offsetY + 18);
    
    //预订按钮
    _reserveBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, kScreenHeight-HEIGHT_TOP_BAR-50-HEIGHT_HOME_INDICATOR, kScreenWidth, 50)];
    _reserveBtn.tag = 3;
    _reserveBtn.titleLabel.font = FONT(20);
    [_reserveBtn setTitle:@"立 即 预 订" forState:UIControlStateNormal];
    [_reserveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_reserveBtn addTarget:self action:@selector(activityRoomDetailButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_reserveBtn];
    
    
    if ([ActivityRoomScheduleView getMaxRowNumber:_detailModel.openDateArray] > 0) {
        [self showReserveButton];
        
        if (_scheduleView.isBookable) {
            _reserveBtn.backgroundColor = kThemeDeepColor;
        }else{
            _reserveBtn.backgroundColor = [UIColor lightGrayColor];
            _reserveBtn.userInteractionEnabled = NO;
        }
    }else{
        [self hiddenReserveButton];
    }
}


#pragma mark - 代理方法

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY < 0)
    {
        if (_topImgView.superview == nil)
        {
            _topImgView.image = [UIToolClass convertImgFromView:_headerImgView];
            [self.view addSubview:_topImgView];
            _topImgView.layer.anchorPoint = CGPointMake(0.5,0);
            _topImgView.frame = MRECT(0, 0, WIDTH_SCREEN, _headerImgView.height);
        }
        float scale = (_headerImgView.height - offsetY)/_headerImgView.height;
        _topImgView.transform = CGAffineTransformMakeScale(scale,scale);
    }
    else
    {
        [_topImgView removeFromSuperview];
    }
}

#pragma mark - 点击事件

- (void)activityRoomDetailButtonClick:(UIButton *)sender
{
    switch (sender.tag) {
        case 2://拨打电话
        {
            if (_detailModel.roomConsultTel.length) {
                [UIToolClass callPhone:_detailModel.roomConsultTel sourceVC:self];
            }
        }
            break;
        case 3://预订按钮
        {
            //不再判断是否有手机号
            if (_scheduleView.selectedDateAndTime.length < 1) {
                [SVProgressHUD showInfoWithStatus:@"请选择预订时间段!"];
                return;
            }
            
            if ([self userCanOperateAfterLogin]) {
                if ([ToolClass showForbiddenNotice]) {
                    return;
                }
                
                [self startActivityRoomBook];
            }
        }
            break;
            
        default:
            break;
    }
}



#pragma mark - 其它方法

- (void)showReserveButton
{
    UIScrollView *bgScrollView = [self.view viewWithTag:50];
    bgScrollView.height = kScreenHeight-HEIGHT_TOP_BAR-50-HEIGHT_HOME_INDICATOR;
    _reserveBtn.hidden = NO;
}

- (void)hiddenReserveButton
{
    UIScrollView *bgScrollView = [self.view viewWithTag:50];
    bgScrollView.height = kScreenHeight-HEIGHT_TOP_BAR-HEIGHT_HOME_INDICATOR;
    _reserveBtn.hidden = YES;
}

// 弹窗提示
- (void)showAlertViewWithMessage:(NSString *)message
{
    UIView *alertView = [self.view viewWithTag:130];
    if (!alertView)
    {
        CGFloat strHeight = [UIToolClass textHeight:message font:FONT(14) width:kScreenWidth*7.0/15];
        
        alertView = [[UIView alloc] initWithFrame:CGRectMake(40, 30, kScreenWidth-80, strHeight+20)];
        alertView.tag = 130;
        alertView.radius = 5;
        alertView.backgroundColor = [UIColor grayColor];
        [self.view addSubview:alertView];
        alertView.center = self.view.center;
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 10, alertView.bounds.size.width-10 , alertView.bounds.size.height-19)];
        titleLabel.text = message;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.numberOfLines = 0;
        titleLabel.font = FONT(14);
        [alertView addSubview:titleLabel];
    }
    [alertView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:2];
}



// 提示场馆预订只针对团体用户
- (void)showPromptViewWithTitle:(NSString *)title message:(NSString *)message
{
    self.navigationController.navigationBarHidden = YES;
    
    UIImageView *bgImageView = (UIImageView *)[self.view viewWithTag:999];
    
    if (!bgImageView)
    {
        bgImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    }
    else if ([bgImageView isKindOfClass:[UIImageView class]])//已经存在提示视图了
    {
        return;
    }
    
    bgImageView.tag = 999;
    bgImageView.userInteractionEnabled = YES;
    bgImageView.image = [UIToolClass getScreenShotImageWithSize:self.view.viewSize views:@[self.view, self.navigationController.navigationBar] isBlurry:YES];
    [self.view addSubview:bgImageView];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [button addTarget:self action:@selector(dismissPromptView:) forControlEvents:UIControlEventTouchUpInside];
    [bgImageView addSubview:button];

    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ConvertSize(690), ConvertSize(200))];
    bgView.radius = 8;
    bgView.backgroundColor = [UIColor whiteColor];
    [bgImageView addSubview:bgView];
    bgView.center = CGPointMake(kScreenWidth/2.0, kScreenHeight/2.0-20);
    
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(ConvertSize(41), ConvertSize(70), bgView.frame.size.width-2*ConvertSize(41), 0)];
    titleLabel.text = title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.numberOfLines = 0;
    titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    titleLabel.textColor = kDeepLabelColor;
    titleLabel.font = FONT(16);
    [bgView addSubview:titleLabel];
    
    CGFloat titleHeight = [UIToolClass textHeight:titleLabel.text font:titleLabel.font width:titleLabel.frame.size.width];
    titleLabel.frame = CGRectMake(titleLabel.frame.origin.x, titleLabel.frame.origin.y, titleLabel.bounds.size.width, titleHeight);
    titleLabel.center = CGPointMake(bgView.bounds.size.width/2.0, bgView.bounds.size.height/2.0);
    
    
    UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(titleLabel.frame), CGRectGetMaxY(titleLabel.frame)+ConvertSize(95), titleLabel.frame.size.width, 0)];
    detailLabel.hidden = YES;//暂时不需要显示
    detailLabel.text = message;
    detailLabel.numberOfLines = 0;
    detailLabel.lineBreakMode = NSLineBreakByCharWrapping;
    detailLabel.textColor = RGBA(139, 150, 154, 1);
    detailLabel.font = FONT(14);
    [bgView addSubview:detailLabel];
    
    CGFloat detailHeight = [UIToolClass textHeight:detailLabel.text font:detailLabel.font width:detailLabel.frame.size.width];
    CGRect rect = detailLabel.frame;
    rect.size.height = detailHeight;
    detailLabel.frame = rect;
}

//弹窗消失
- (void)dismissPromptView:(UIButton *)sender
{
    self.navigationController.navigationBarHidden = NO;
    UIImageView *bgImageView = (UIImageView *)[self.view viewWithTag:999];
    [bgImageView removeFromSuperview];
}



@end
