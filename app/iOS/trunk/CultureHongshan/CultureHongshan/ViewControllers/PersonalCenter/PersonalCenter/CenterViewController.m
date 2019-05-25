//
//  CenterViewController.m
//  CultureHongshan

//  Created by ct on 15/11/10.
//  Copyright © 2015年 CT. All rights reserved.
//

/*
 
 0707 修改个人中心的动画效果
 
 */

#import "CenterViewController.h"

// View And Cells
#import "AnimatedTabBarView.h"
#import "PersonalCenterCell.h"
#import "PersonalCenterSpecialCell.h"
#import "AnimatedSpringPopupView.h"


// Models
#import "PersonalSettingModel.h"
#import "CitySwitchModel.h"

// ViewControllers
#import "PersonalSettingViewController.h"//个人设置
#import "PersonalCenterCommentViewController.h"//我的评论
#import "MyOrderViewController.h"//我的订单
#import "MyCollectionViewController.h"//我的收藏
#import "AccumulativeScoreViewController.h"//我的积分
#import "MyMessageListViewController.h"
#import "HelpAndFeedbackViewController.h"
#import "WebViewController.h"

// Other
#import "AppProtocolMacros.h"
#import "HZPhotoBrowser.h"//查看大图
#import "UIImage+Extensions.h"

// 测试
#import "TestViewController.h"


#define kTag_Message 2
#define kTag_LoginOrRegister 4

#define kImgMinSize  30
#define kBasePositon 0
#define kTopMargin   0
#define kBgImgHeight (kScreenWidth*446/750.0)
#define kMaxWidth    (kScreenWidth-2*60)

static NSString *reuseID_CommonCell  = @"CommonCell";
static NSString *reuseID_SpecialCell = @"SpecialCell";

@interface CenterViewController ()<HZPhotoBrowserDelegate, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>
{
    NSArray *_messagesArray;//消息数组
    
    NSMutableArray *_dataArray;
    
    UIView *_unloginBgView;//未登录的界面背景视图
    
    FBButton *_backButton; // 返回按钮
    
    UIView *_topView;
    UILabel *_nickLabel;
    UIImageView *_headImgView;//头像
    UILabel *_newMessageLabel;//新消息的橘色原点
    
    UIImageView *_topImgView;//下拉放大背景图片
    
    CGFloat _headSize;
    CGFloat _headCenterY;
    CGFloat _labelPosition;//标签在最右侧时，label的中心位置
    CGFloat _imgPosition;//图片移动到最左侧时，图片的中心位置
    BOOL _isNeedCalculateLabelWidth;//是否需要计算昵称的显示宽度
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSString *latestHeadIconUrl;
@end




@implementation CenterViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.tabBarController.tabBar.hidden = NO;
    
    if ([UserService sharedService].userIsLogin && [UserService userShouldReLogin] == NO)
    {
        //登录状态
        _unloginBgView.hidden = YES;
        
        _headImgView.superview.hidden = NO;
        _topView.hidden = NO;
        
        if (_isUpdateUserInfoForbidden == NO){
            [self updateUserInfo];
        }else{
            _isUpdateUserInfoForbidden = NO;
        }

//        [self getUserMessageNumber];
    }
    else
    {
        //未登录状态
        _unloginBgView.hidden = NO;
        
        _headImgView.superview.hidden = YES;
        _topView.hidden = YES;
        
        _tableView.contentOffset = CGPointZero;
    }
    
    [self setupUserInfo];
    [self updateDataArray];
    [_tableView reloadData];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = kBgColor;
    
    [self initTableView];
    
    [self initLoginSubViews];
    [self initUnLoginSubViews];
    
}


#pragma mark - 初始化视图



- (void)initTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-49) style:UITableViewStylePlain];
    _tableView.backgroundColor = self.view.backgroundColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    
    [UIToolClass setupDontAutoAdjustContentInsets:self.tableView forController:self];
    
    [_tableView registerClass:[PersonalCenterCell class] forCellReuseIdentifier:reuseID_CommonCell];
    [_tableView registerClass:[PersonalCenterSpecialCell class] forCellReuseIdentifier:reuseID_SpecialCell];
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:IMG(@"个人中心bg.jpg")];
    bgImageView.frame = CGRectMake(0, 0, kScreenWidth, kBgImgHeight);
    bgImageView.userInteractionEnabled = YES;
    _tableView.tableHeaderView = bgImageView;
    
    CGFloat bottomHeight = kScreenHeight-HEIGHT_TOP_BAR-85-HEIGHT_HOME_INDICATOR-3*7.5-6*50;
    if (bottomHeight >= 0){
        bottomHeight += 20;
    }else{
        bottomHeight = -bottomHeight + 20;
    }
    _tableView.tableFooterView = [MYMaskView maskViewWithBgColor:kBgColor frame:CGRectMake(0, 0, kScreenWidth, bottomHeight) radius:0];
}


- (void)initLoginSubViews
{
    if (_topView) {
        [_topView removeFromSuperview];
        _topView = nil;
    }
    
    _topView = [MYMaskView maskViewWithBgColor:[UIColor clearColor] frame:CGRectMake(0, kTopMargin, kScreenWidth, HEIGHT_TOP_BAR) radius:0];
    [self.view addSubview:_topView];
    
    //昵称
    _nickLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, HEIGHT_STATUS_BAR, kMaxWidth-kImgMinSize-10, _topView.height-HEIGHT_STATUS_BAR)];
    _nickLabel.textColor = [UIColor whiteColor];
    _nickLabel.textAlignment = NSTextAlignmentCenter;
    _nickLabel.font = FontYT(18);
    [_topView addSubview:_nickLabel];
    _nickLabel.centerX = _topView.width*0.5;

    //头像
    _headSize = MIN((kBgImgHeight-_topView.height)*0.75-10, 102);
    _headCenterY = (kBgImgHeight+_topView.height)*0.5+kTopMargin-8; // 头像稍微偏上一点，最后边 -8
    
    MYMaskView *containerView = [MYMaskView maskViewWithImage:IMG(@"icon_head_bg") frame:CGRectMake(0, 0, _headSize+10, _headSize+10) radius:0];
    containerView.userInteractionEnabled = YES;
    [self.view addSubview:containerView];
    containerView.centerY = _headCenterY;
    containerView.centerX = _topView.width*0.5;
    
    
    NSString *headIconUrl = [UserService sharedService].user.userHeadImgUrl;
    _headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _headSize, _headSize)];
    _headImgView.backgroundColor = [UIColor clearColor];
    _headImgView.userInteractionEnabled = YES;
    _headImgView.image = [IMG(@"sh_user_header_icon") circleImage];
    [containerView addSubview:_headImgView];
    if (headIconUrl.length) {
        WEAK_VIEW(_headImgView)
        [_headImgView sd_setImageWithURL:[NSURL URLWithString:headIconUrl] placeholderImage:[IMG(@"sh_user_header_icon") circleImage] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
                weakView.image = [image circleImage];
            }
        }];
    }
    _headImgView.center = CGPointMake(containerView.width*0.5, containerView.height*0.5);
    
    _headImgView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    [UIView animateWithDuration:0.3 animations:^{
        _headImgView.transform = CGAffineTransformMakeScale(1, 1);
    }];
    
    //头像添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [_headImgView addGestureRecognizer:tap];
}


- (void)initUnLoginSubViews
{
    _unloginBgView = [[UIView alloc] initWithFrame:_tableView.tableHeaderView.bounds];
    [_tableView.tableHeaderView addSubview:_unloginBgView];
    
    //欢迎登录
    UILabel *welcomeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, HEIGHT_STATUS_BAR + 20, kScreenWidth, [UIToolClass fontHeight:FontYT(22)])];
    welcomeLabel.text = [NSString stringWithFormat:@"欢迎来到%@", APP_SHOW_NAME];
    welcomeLabel.font = FontYT(22);
    welcomeLabel.textColor = [UIColor whiteColor];
    welcomeLabel.textAlignment = NSTextAlignmentCenter;
    [_unloginBgView addSubview:welcomeLabel];
    
    UIButton *loginButton = [[UIButton alloc] initWithFrame:CGRectMake(0, welcomeLabel.maxY+30, 145, 50)];
    loginButton.tag = kTag_LoginOrRegister;
    [loginButton setImage:IMG(@"登录注册") forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_unloginBgView addSubview:loginButton];
    loginButton.centerX = welcomeLabel.centerX;
}

#pragma mark - 数据请求

//更新用户信息
- (void)updateUserInfo
{
    NSString *userId = [UserService sharedService].userId;
    
    if (userId.length) {
        WS(weakSelf);
        
        [AppProtocol queryUserInfoWithUserId:userId UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
            if (responseCode == HttpResponseSuccess) {
                [UserService saveUser:responseObject];
                [weakSelf setupUserInfo];
                [weakSelf updateDataArray];
                [_tableView reloadData];
            }
        }];
    }
}

//获取推送给用户的消息条数
- (void)getUserMessageNumber
{
    return;
    
    __weak CenterViewController *weakSelf  = self;
    
    // 获取用户消息
    [AppProtocol getUserMessageWithUserId:[UserService sharedService].userId UsingBlock:^(HttpResponseCode responseCode, id responseObject)
     {
         [SVProgressHUD dismiss];
         if (responseCode == HttpResponseSuccess) {
             // 保存用户信息条数
             NSInteger pageNum = [responseObject integerValue];
             [ToolClass setDefaultValue:@(pageNum) forKey:kUserDefault_MessageNumber];
             [weakSelf updateNumberLabel:pageNum];
         }
     }];
}

//设置用户的头像和昵称等信息
- (void)setupUserInfo
{
    User *user = [UserService sharedService].user;
    
    //昵称
    _nickLabel.text = user.userNameFull.length ? user.userNameFull : @"未设置用户名";
    _nickLabel.width = MIN([UIToolClass textWidth:_nickLabel.text font:_nickLabel.font], kMaxWidth);
    if (_nickLabel.width <= kMaxWidth-kImgMinSize-10) {
        [self setTitleLabelAndHeadImgUltimatePosition:0 changeRate:0];
        _isNeedCalculateLabelWidth = NO;
    }else{
        _isNeedCalculateLabelWidth = YES;
    }
    [self adjustSubviewsFrame:_tableView.contentOffset.y];
    
    //头像
    if ([user.userHeadImgUrl isEqualToString:kQzoneImageUrl]) {
        _headImgView.image = IMG(@"sh_user_header_icon");
    } else {
        WEAK_VIEW(_headImgView)
        [_headImgView sd_setImageWithURL:[NSURL URLWithString:user.userHeadImgUrl] placeholderImage:[IMG(@"sh_user_header_icon") circleImage] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
                weakView.image = [image circleImage];
            }
        }];
    }
}


- (void)updateDataArray
{
    User *user = [UserService sharedService].user;
    if (_dataArray.count) {
        //我的积分
        
        PersonalSettingModel *model  = _dataArray[0];
        model.rightTitle = (user.userId.length && [UserService userShouldReLogin] == NO) ? [NSString stringWithFormat:@"%d 分", (int)user.userIntegral] : @"";
        //实名认证
        model  = _dataArray[1];
        NSString *realNameStatus = @"";
        if (user.userType == 1){
            realNameStatus = @"未认证";
        } else if (user.userType == 2){
            realNameStatus = @"已认证";
        } else if (user.userType == 3){
            realNameStatus = @"认证中";
        } else if (user.userType == 4){
            realNameStatus = @"认证未通过";
        }
        model.rightTitle = (user.userId.length && [UserService userShouldReLogin] == NO) ? realNameStatus : @" ";
        //资质认证
        model  = _dataArray[2];
        model.rightTitle = (user.userId.length && [UserService userShouldReLogin] == NO) ? (user.teamUserSize > 0 ? @"已认证" : @"未认证") : @" ";
    }else{
        if (_dataArray) {
            _dataArray = nil;
        }
        _dataArray = [[NSMutableArray alloc] initWithCapacity:7];
        
        PersonalSettingModel *model = [PersonalSettingModel new];
        //我的积分
        model.leftTitle = @"我的积分";
        model.rightTitle = (user.userId.length && [UserService userShouldReLogin] == NO) ? [NSString stringWithFormat:@"%d 分", (int)user.userIntegral] : @" ";
        [_dataArray addObject:model];
        //实名认证
        model = [PersonalSettingModel new];
        model.leftTitle = @"实名认证";
        NSString *realNameStatus = @"";
        if (user.userType == 1){
            realNameStatus = @"未认证";
        } else if (user.userType == 2){
            realNameStatus = @"已认证";
        } else if (user.userType == 3){
            realNameStatus = @"认证中";
        } else if (user.userType == 4){
            realNameStatus = @"认证未通过";
        }
        model.rightTitle = (user.userId.length && [UserService userShouldReLogin] == NO) ? realNameStatus : @" ";
        [_dataArray addObject:model];
        //资质认证
        model = [PersonalSettingModel new];
        model.leftTitle = @"资质认证";
        model.rightTitle = (user.userId.length && [UserService userShouldReLogin] == NO) ? (user.teamUserSize > 0 ? @"已认证" : @"未认证") : @" ";
        [_dataArray addObject:model];
        //设置
        model = [PersonalSettingModel new];
        model.leftTitle = @"设置";
        [_dataArray addObject:model];
        //帮助与反馈
        model = [PersonalSettingModel new];
        model.leftTitle = @"帮助与反馈";
        [_dataArray addObject:model];
        //关于文化云
        model = [PersonalSettingModel new];
        model.leftTitle = [NSString stringWithFormat:@"关于%@", APP_SHOW_NAME];
        [_dataArray addObject:model];
        //平台入驻
        model = [PersonalSettingModel new];
        model.leftTitle = @"平台入驻";
        [_dataArray addObject:model];
    }
}



#pragma mark - UITabelViewDelegate And DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        PersonalCenterSpecialCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID_SpecialCell forIndexPath:indexPath];
        WS(weakSelf);
        cell.block = ^(id object, NSInteger index, BOOL isSameIndex){
            [weakSelf enterMineDetailVC:index];
        };
        return cell;
    }
    else
    {
        NSInteger realRow = [self getRealRow:indexPath];
        
        if (realRow > -1) {
            PersonalCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID_CommonCell forIndexPath:indexPath];
            
            CGFloat offsetX = 0;
            if (realRow == 1 || realRow == 3 || realRow == 4) {
                offsetX = 18;
            }
            PersonalSettingModel *model = _dataArray[realRow];
            [cell setModel:model lineOffset:offsetX];
            return cell;
        }
    }
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LineCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LineCell"];
        cell.contentView.backgroundColor = kBgColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}



#pragma mark - 表视图的代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0){
        return 85;
    }else
    {
        NSInteger realRow = [self getRealRow:indexPath];
        if (realRow > -1){
            return 50;
        }else{
            return 7.5;
        }
    }
}


#pragma mark - 查看头像
//查看大图
- (void)tapClick:(UITapGestureRecognizer *)tapGesture
{
    HZPhotoBrowser *photoBrowser = [[HZPhotoBrowser alloc] init];
    photoBrowser.sourceImagesContainerView = tapGesture.view.superview;
    photoBrowser.imageCount = 1;
    photoBrowser.currentImageIndex = 0;
    photoBrowser.delegate = self;
    [photoBrowser show];
}


- (UIImage *)photoBrowser:(HZPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    return _headImgView.image;
}

- (id)photoBrowser:(HZPhotoBrowser *)browser highQualityImageOrImageURLForIndex:(NSInteger)index
{
    NSString *headerUrl = [UserService sharedService].user.userHeadImgUrl;
    if (headerUrl.length > 0) {
        return [NSURL URLWithString:headerUrl];
    }else {
        return nil;
    }
}




#pragma mark - Button Action Methods



- (void)buttonClick:(UIButton *)sender
{
    switch (sender.tag) {
        case kTag_Message://我的消息
        {
            [self enterNextViewController:7];
        }
            break;
        case kTag_LoginOrRegister://未登录时的“登录/注册”按钮
        {
            [self enterNextViewController:8];
        }
            break;
        default:
            break;
    }
}


//进入我的订单、收藏、评论页面
- (void)enterMineDetailVC:(NSInteger)index
{
    if ([self userCanOperateAfterLogin]) {
        if ([ToolClass showForbiddenNotice]) {
            return;
        }
        
        if (index == 0) {//我的订单
            MyOrderViewController *vc = [[MyOrderViewController alloc]init];
            vc.selectedIndex = 0;
            [self.navigationController pushViewController:vc animated:YES];
            return;
        }else if (index ==1){//我的收藏
            MyCollectionViewController *vc = [[MyCollectionViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            return;
        }else if (index ==2){//我的评论
            PersonalCenterCommentViewController *vc = [[PersonalCenterCommentViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}


- (void)enterNextViewController:(NSInteger)index
{
    if (index != 4 && index != 5) {//需要登录后，才能进入到下一级页面
        if (![self userCanOperateAfterLogin]) {
            return;
        }
        if ([ToolClass showForbiddenNotice]) {
            return;
        }
    }
    
    switch (index) {
        case 0://我的积分
        {
            AccumulativeScoreViewController *vc = [[AccumulativeScoreViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1://实名认证
        {
            NSString *userId = [UserService sharedService].userId;
            if (userId.length) {
                WebViewController *vc = [WebViewController new];
                vc.navTitle = @"实名认证";
                vc.url = [NSString stringWithFormat:@"%@&userId=%@", kRealNameAuthUrl, userId];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
            break;
        case 2://资质认证
        {
            NSString *userId = [UserService sharedService].userId;
            if (userId.length) {
                WebViewController *vc = [WebViewController new];
                vc.navTitle = @"资质认证";
                vc.url = [NSString stringWithFormat:@"%@&userId=%@", kQualificationAuthUrl, userId];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
            break;
        case 3://设置
        {
            PersonalSettingViewController *vc = [[PersonalSettingViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 4://帮助与反馈
        {
            HelpAndFeedbackViewController *vc = [[HelpAndFeedbackViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 5://关于文化云
        {
            [self enterAboutCulturePage];
        }
            break;
        case 6://平台入驻
        {
            
        }
            break;
        case 7://我的消息
        {
            MyMessageListViewController *messageVC = [[MyMessageListViewController alloc]init];
            _newMessageLabel.hidden = YES;
            [self.navigationController pushViewController:messageVC animated:YES];
        }
            break;
        case 8:{//未登录时的“登录/注册”按钮
            //理论上，方法不会执行到这里（进入方法后的登录判断会拦截事件）
        }
            
        default:
            break;
    }
}

- (void)enterAboutCulturePage
{
    WebViewController *vc = [WebViewController new];
    vc.navTitle = [NSString stringWithFormat:@"关于%@", APP_SHOW_NAME];
    vc.url = [NSString stringWithFormat:@"%@/%@",kProtocolFixedUrl,kAboutCultureCloudUrl];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)enterTestPage
{
    TestViewController *vc = [TestViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row)
    {
        NSInteger realRow = [self getRealRow:indexPath];
        if (realRow > -1) {
            [self enterNextViewController:realRow];
        }
    }
}

- (void)updateNumberLabel:(NSInteger)number
{
    number = 0;
    if (number < 1)
    {
        _newMessageLabel.hidden = YES;
        return;
    }
    else
    {
        _newMessageLabel.hidden = NO;
    }
    
    if (number > 99)
    {
        _newMessageLabel.text = @"99+";
        CGFloat width = [UIToolClass textWidth:@"99+" font:FontYT(10)] + 8;
        _newMessageLabel.bounds = CGRectMake(0, 0, width, width);
        _newMessageLabel.center = CGPointMake(60-7 , 14);
        _newMessageLabel.font = FontYT(10);
        
    }
    else
    {
        _newMessageLabel.text = [NSString stringWithFormat:@"%d",(int)number];
        CGFloat width = [UIToolClass textWidth:@"10" font:FontYT(11)] + 9;
        _newMessageLabel.bounds = CGRectMake(0, 0, width, width);
        _newMessageLabel.center = CGPointMake(60-10 , 14);
        _newMessageLabel.font = FontYT(11);
        if (number < 10)
        {
            _newMessageLabel.font = FontYT(15);
        }
    }
    _newMessageLabel.radius = _newMessageLabel.bounds.size.width*0.5;
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _tableView) {
        
        CGFloat offsetY = scrollView.contentOffset.y;
        
        CGFloat alpha = 0;
        if (offsetY > kBasePositon) {
            alpha = MIN(MAX((offsetY - kBasePositon)*1.0/(kBgImgHeight-_topView.height), 0), 1);
        }
        
        _topView.backgroundColor = kThemeColorWithAlpha(alpha);
        [self adjustSubviewsFrame:offsetY];
        
        //图片下拉放大
        if (offsetY < kBasePositon) {
            if (!_topImgView) {
                _topImgView = [UIImageView new];
                _topImgView.image = [UIToolClass convertImgFromView:_tableView.tableHeaderView];
                [self.view addSubview:_topImgView];
                _topImgView.layer.anchorPoint = CGPointMake(0.5,0);
                _topImgView.frame = CGRectMake(0, 0, kScreenWidth, kBgImgHeight);
                
                [self.view bringSubviewToFront:_topView];
                [self.view bringSubviewToFront:_headImgView.superview];
                
            }
            float scale = (kBgImgHeight - offsetY)/kBgImgHeight;
            _topImgView.transform = CGAffineTransformMakeScale(scale,scale);
            
            [self.view bringSubviewToFront:_backButton];
        }else{
            [_topImgView removeFromSuperview];
            _topImgView = nil;
        }
    }
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (offsetY < kBasePositon) {
        [scrollView setContentOffset:CGPointMake(0, kBasePositon) animated:YES];
        return;
    }
    
    if (offsetY - kBasePositon > kBgImgHeight-_topView.height-50  && offsetY - kBasePositon <= kBgImgHeight-_topView.height) {
        
        [scrollView setContentOffset:CGPointMake(0, kBasePositon + kBgImgHeight - _topView.height) animated:YES];
        return;
    }else if (offsetY - kBasePositon <= kBgImgHeight-_topView.height-50 )
    {
        [scrollView setContentOffset:CGPointMake(0, kBasePositon) animated:YES];
    }
}


- (void)adjustSubviewsFrame:(CGFloat)positionY
{
    //计算scrollView的垂直方向偏移量的变化率
    CGFloat changeRate = MIN(positionY-kBasePositon, kBgImgHeight-_topView.height)*1.0/(kBgImgHeight-_topView.height);
    
    CGFloat headSize = MIN(kImgMinSize+(_headSize-kImgMinSize)*(1-MAX(changeRate, 0)), _headSize);
    
    //调整头像的边框线宽度
    CGFloat borderWidth = 5.6+(0.6-5.6)*MAX(changeRate,0);
    _headImgView.superview.viewSize = CGSizeMake(headSize+2*borderWidth, headSize+2*borderWidth);;
    _headImgView.bounds = CGRectMake(0, 0, headSize, headSize);
    _headImgView.center = CGPointMake(_headImgView.superview.width*0.5, _headImgView.superview.width*0.5);
    
    if (changeRate < 0) {
        // 头像稍微偏上一点，最后边 -8
        _headImgView.superview.centerY = kTopMargin + (kBasePositon-positionY + (kBgImgHeight-_topView.height))*0.5+_topView.height-8;
    }else{
        _headImgView.superview.centerY = _headCenterY-(_headCenterY-(_nickLabel.centerY+kTopMargin))*changeRate;
    }
    
    _headImgView.userInteractionEnabled = (MAX(changeRate, 0) < 0.01 && changeRate >= 0) ||  MAX(changeRate, 0) > 0.99;
    
    //调整昵称和头像的水平位置
    [self setTitleLabelAndHeadImgUltimatePosition:positionY changeRate:changeRate];
    _nickLabel.centerX = kScreenWidth*0.5 + (_labelPosition-kScreenWidth*0.5)*MAX(changeRate, 0);
    _headImgView.superview.centerX = kScreenWidth*0.5 + (_imgPosition-kScreenWidth*0.5)*MAX(changeRate, 0);
}

/**
 *  设置昵称和头像的左右极限位置
 */
- (void)setTitleLabelAndHeadImgUltimatePosition:(CGFloat)positionY changeRate:(CGFloat)changeRate
{
    CGFloat labelWidth = _nickLabel.width;
    if (_isNeedCalculateLabelWidth) {
        labelWidth = kMaxWidth - (kImgMinSize+10)*MAX(changeRate, 0);
        _nickLabel.width = labelWidth;
    }
    _imgPosition = kScreenWidth*0.5-(kImgMinSize+10+labelWidth)*0.5+kImgMinSize*0.5;
    _labelPosition = kScreenWidth*0.5+(kImgMinSize+10+labelWidth)*0.5-labelWidth*0.5;
}


#pragma mark - 其它方法

- (NSInteger)getRealRow:(NSIndexPath *)indexPath
{
    //row == 0 不在这里做判断
    NSInteger row = indexPath.row;
    switch (row) {
        case 2:{//我的积分
            return 0;
        }
            break;
        case 4:{//实名认证
            return 1;
        }
            break;
        case 5:{//资质认证
            return 2;
        }
            break;
        case 7:{//设置
            return 3;
        }
            break;
        case 8:{//帮助与反馈
            return 4;
        }
            break;
        case 9:{//关于文化云
            return 5;
        }
            break;
        case 11:{//平台入驻
            return 6;
        }
            break;
        default:{
            return -1;//不可点击的单元格
        }
            break;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}





@end
