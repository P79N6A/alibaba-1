//
//  ActivityDetailViewController.m
//  CultureHongshan
//
//  Created by xiao on 15/11/6.
//  Copyright © 2015年 CT. All rights reserved.
//

#import "ActivityDetailViewController.h"

//Tool类
#import "MJRefresh.h"
#import "AppProtocolMacros.h"


//Model类
#import "ActivityDetail.h"
#import "Registration.h"
#import "CommentModel.h"
#import "Video.h"
#import "ShowOtherActivityModel.h"

#import "HZPhotoItemModel.h"



//View和Cell类
#import "SDCycleScrollView.h"
//#import "HZImagesGroupView.h"

#import "ActivityDetailTitleCell.h"
#import "ActivityDetailInfomationCell.h"
#import "ActivityDetailActivityUnitCell.h"//活动单位
#import "ActivityCommentDetailCell.h"
#import "LikeTableViewCell.h"
#import "WebViewCell.h"
#import "ShowOtherActivityCell.h"

#import "PublishCommentViewController.h"//发表评论

#import "ActivityDetailHeaderView.h"
#import "HZPhotoBrowser.h"

#import "DetailTabBarView.h"

#import "AnimationBackView.h"//加载动画
#import "PopupWebView.h"
#import "DetailNavTitleView.h"
#import "SecKillBroadcastView.h"//秒杀
#import "AnimatedSpringPopupView.h"


//ViewController类
#import "ShowOtherActivityViewController.h"
#import "NearbyLocationViewController.h"
#import "RegistrationViewController.h"//点赞用户列表
#import "SharePresentView.h"
#import "WebViewController.h"
#import "CalendarViewController.h"

#import "PersonalCenterCommentViewController.h"
#import "PublishCommentViewController.h"//发表评论

#import "WebPhotoBrowser.h"

#define HEIGHT_BANNERVIEW   (kScreenWidth*500)/750.0
#define HEIGHT_HEADER 45
#define kWebViewShowedHeight (kScreenHeight*0.6)


static NSString *reuseID_TitleCell         = @"TitleCell";
static NSString *reuseID_InfoCell          = @"InfoCell";
static NSString *reuseID_CommentCell       = @"CommentCell";//评论
static NSString *reuseID_UnitCell          = @"UnitCell";//活动单位
static NSString *reuseID_WantGoCell        = @"WantGoCell";
static NSString *reuseID_WebViewCell       = @"WebViewCell";//详情介绍
static NSString *reuseID_WebViewNoticeCell = @"WebViewNoticeCell";//活动须知
static NSString *reuseID_NewsReportCell    = @"NewsReportCell";
static NSString *reuseID_HeaderView        = @"HeaderView";
static NSString *reuseID_BlankCell         = @"BlankCell";//空白系统单元格
static NSString *reuseID_OtherActivity     = @"OtherActivityCell";


@interface ActivityDetailViewController ()<UITableViewDataSource, UITableViewDelegate,UIWebViewDelegate,UIScrollViewDelegate,SDCycleScrollViewDelegate,HZPhotoBrowserDelegate>
{
    //Data
    NSArray *_sectionTitleArray;//区头的标题
    BOOL _sectionIsHidden[8];//设置每个区的显示与否
    
    BOOL _isUserLoginFromDetail;
    BOOL _isAddComment;//是否新发表了评论
    NSInteger _selectedHeaderIndex;// 0-选中了活动详情区头、 1-选中了活动单位区头
    
    NSTimeInterval _remainedSeconds;
    NSTimer *_timer;// 秒杀倒计时的定时器
    
    CGFloat _webViewHeight[8];//webView的高度
    
    NSArray *_bannerURLsArray;//轮播图URLs
    NSArray *_otherArray;// 演出方的其他活动数组
    
    NSMutableArray *_commentArray;//评论数组
    NSMutableArray *_wantGoUsersArray;//想去的用户
    
    
    NSString *_savedIndex; // 保存进入到活动预订界面时，能够预订的活动场次索引
    NSInteger _seckillStatus;//自定义的秒杀状态：0-无需秒杀  1-已订完(所有的秒杀全部结束)  2-进入倒计时  3-正在秒杀  4-未开始  5-已结束
    
    //View
    SDCycleScrollView *_bannerView; // 顶部的图片轮播（目前还只有一张图片）
    SecKillBroadcastView *_seckillView;//秒杀
    DetailTabBarView *_tabBarView;//底部的工具栏
    
    
    AnimationBackView *_animationView;
    UIImageView * _topImgView;// 下拉放大图片使用
    DetailNavTitleView *_navTitleView;
    FBButton * backbutton;
    UITableViewHeaderFooterView * infoHeaderView;
    MYMaskView *_headerTopView;// 悬浮于区头上的视图：跟第2区的区头一模一样.
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *bannerMaskView;//轮播图上的蒙板

@end


@implementation ActivityDetailViewController



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    if (_screenshotImages.count)
    {
        [ToolClass animationWithTopImage:_screenshotImages[0] bottomImage:_screenshotImages[1] headOffset:HEIGHT_BANNERVIEW   isTogether:NO  completion:^(BOOL finished) {
            
        }];
        _screenshotImages = nil;
    }
    
    User *user = [UserService sharedService].user;
    if (_isUserLoginFromDetail && user.userId.length && _activityDetail) {
        _isUserLoginFromDetail = NO;
        
        // 更新收藏、点赞按钮的状态
        [self startRequestActivityDetailData:YES localUpdate:YES];
        
        NSInteger score = user.userIntegral;
        if (score < _activityDetail.lowestCredit) {
            _activityDetail.integralStatus = 1; return;
        }else if (score < _activityDetail.costCredit){
            _activityDetail.integralStatus = 2; return;
        }else{
            _activityDetail.integralStatus = 0;
        }
    }
}


- (void)viewWillDisappear:(BOOL)animated
{
    [LogService updateLogKey:_activityId  addr:[NSString stringWithFormat:@"%p",self]];
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
    self.navigationController.navigationBarHidden = NO;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _topImgView = [UIImageView new];
    self.navigationItem.title = @"活动详情";
    
    [self initMutableArrayData];
    
    [self setupSectionTitleArray];
    
    [self initTabelView];
    [self initBannerView];
    [self initRefreshControl];
    [self initNavigationBar];
    
    [self startRequestActivityDetailData:YES localUpdate:NO];
}



#pragma mark -
#pragma mark - View视图的初始化 init Views

//#pragma mark - 设置导航条
- (void)initNavigationBar
{
    if (backbutton == nil) {
        WS(weakSelf);
        //返回按钮
        backbutton = [[FBButton alloc] initWithImage:CGRectMake(0, HEIGHT_STATUS_BAR-6, 62, 62) bgcolor:[UIColor clearColor] img:nil clickEvent:^(FBButton *owner) {
            if (_isAddComment){
                NSArray *vcArray = weakSelf.navigationController.viewControllers;
                if (vcArray.count > 1)
                {
                    if ([vcArray[vcArray.count-2] isKindOfClass:NSClassFromString(@"PersonalCenterCommentViewController")] )
                    {
                        PersonalCenterCommentViewController *vc = vcArray[vcArray.count-2];
                        vc.isNeedRefresh = YES;
                    }
                }
            }
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
        [self.view  addSubview:backbutton];
        
        //图片
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 38, 38)];
        imgView.radius = imgView.height*0.5;
        imgView.image = IMG(kReturnButtonImageName);
        imgView.backgroundColor = RGBA(0x7, 0x7, 0x7, 0.15);
        imgView.contentMode = UIViewContentModeCenter;
        [backbutton addSubview:imgView];
        imgView.center = CGPointMake(backbutton.width*0.5, backbutton.height*0.5);
    }
}


//#pragma mark - 初始化表视图
- (void)initTabelView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - HEIGHT_HOME_INDICATOR) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = kBgColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.hidden = YES;
    [self.view addSubview:_tableView];

    [UIToolClass setupDontAutoAdjustContentInsets:self.tableView forController:self];
    
    
    [_tableView registerClass:[ActivityDetailTitleCell class] forCellReuseIdentifier:reuseID_TitleCell];
    [_tableView registerClass:[ActivityDetailInfomationCell class] forCellReuseIdentifier:reuseID_InfoCell];
    [_tableView registerClass:[ActivityCommentDetailCell class] forCellReuseIdentifier:reuseID_CommentCell];
    [_tableView registerClass:[LikeTableViewCell class] forCellReuseIdentifier:reuseID_WantGoCell];
    [_tableView registerClass:[WebViewCell class] forCellReuseIdentifier:reuseID_WebViewCell];
    [_tableView registerClass:[WebViewCell class] forCellReuseIdentifier:reuseID_WebViewNoticeCell];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:reuseID_BlankCell];
    [_tableView registerClass:[ActivityDetailActivityUnitCell class] forCellReuseIdentifier:reuseID_UnitCell];
    [_tableView registerClass:[ShowOtherActivityCell class] forCellReuseIdentifier:reuseID_OtherActivity];
}

/**
 *  顶部的轮播图
 */
- (void)initBannerView
{
    UIImage *placeImg = [UIToolClass getPlaceholderWithViewSize:CGSizeMake(kScreenWidth, HEIGHT_BANNERVIEW) centerSize:CGSizeMake(40, 40) isBorder:NO];
    _bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, HEIGHT_BANNERVIEW) delegate:self placeholderImage:placeImg];
    
    _bannerView.currentPageDotColor = [UIColor colorWithRed:210/255.0 green:88/255.0 blue:59/255.0 alpha:1.0];
    _bannerView.pageDotColor = [UIColor whiteColor];
    
    _tableView.tableHeaderView = _bannerView;
    
    _bannerMaskView = [[UIImageView alloc] initWithFrame:_bannerView.bounds];
    _bannerMaskView.image = IMG(@"蒙板");
    _bannerMaskView.userInteractionEnabled = NO;
    [_bannerView addSubview:_bannerMaskView];
}


- (void)initRefreshControl
{
    __weak ActivityDetailViewController *weakSelf = self;
    
    //底部的刷新控件：加载更多评论
    MJRefreshBackNormalFooter *footerRefresh = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf startRequestCommentDataWithClearData:NO];
    }];
    footerRefresh.stateLabel.font = FontSystem(12);
    _tableView.footer = footerRefresh;
}



//底部的工具栏
- (void)initTabBarView
{
    if (_tabBarView) {
        [_tabBarView removeFromSuperview];
        _tabBarView = nil;
    }
    
    __weak typeof(self) weakSelf = self;
    _tabBarView = [[DetailTabBarView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 0) prompt:_activityDetail.showedScoreNotice];
    _tabBarView.hidden = YES;
    
    [_tabBarView setButtonStatusWithIndex:4 title:@" " selected:NO];
    
    _tabBarView.callBackBlock = ^(UIButton *sender, NSInteger index, BOOL isSelected){
        switch (index)
        {
            case 0://评论
            {
                [weakSelf enterCommentPage];
            }
                break;
            case 1://点赞
            {
                if(sender.selected){
                    [weakSelf wantGoUserRequestWithIsCancel:YES];
                }else{
                    [weakSelf wantGoUserRequestWithIsCancel:NO];
                }
            }
                break;
            case 2://收藏
            {
                if (sender.selected){//已经收藏
                    [weakSelf userCollectRequestWithIsCancel:YES];
                } else {//未收藏
                    [weakSelf userCollectRequestWithIsCancel:NO];
                }
            }
                break;
            case 3://分享
            {
                [weakSelf enterShareView];
            }
                break;
            case 4://预订按钮
            {
                if (isSelected){
                    if ([sender.currentTitle isEqualToString:@"未开始"]) {
                        [weakSelf startRequestActivitySeckillEventList:NO];
                    }else{
                        [weakSelf enterReservePage:YES];
                    }
                }
            }
                break;
                
            default:
                break;
        }
    };
    [self.view addSubview:_tabBarView];
}

// 悬浮于区头的视图
- (void)initHeaderTopView
{
    if (!_headerTopView) {
        _headerTopView = [MYMaskView maskViewWithBgColor:COLOR_IWHITE frame:CGRectMake(0, _navTitleView.maxY, kScreenWidth, HEIGHT_HEADER) radius:0];
        _headerTopView.hidden = YES;
        
        [_headerTopView addSubview:[self getDetailSectionHeaderWithBaseTag:1]];
        
        [self.view addSubview:_headerTopView];
    }
}

#pragma mark -
#pragma mark - 数据的请求和处理

/**
 *  根据活动id获取活动的信息
 *
 *  @param isClearData 是否清空原有数据
 *  @param localUpdate 是否为局部更新（如：是否收藏、点赞）
 */
- (void)startRequestActivityDetailData:(BOOL)isClearData localUpdate:(BOOL)localUpdate
{
    if(!localUpdate) { // 不是局部更新时，才有加载动画
        [SVProgressHUD showLoading];
    }
    
    WS(weakSelf);
    [AppProtocol getActivtyDetailWithActivityId:self.activityId UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        //成功请求到数据
        if (responseCode == HttpResponseSuccess) {
            if (!localUpdate) {
                [SVProgressHUD dismiss];
                
                _activityDetail = responseObject[0];
                _activityDetail.showedActivityTags = responseObject[1];
                [weakSelf handleSomething:NO];
                _tableView.height = kScreenHeight-_tabBarView.height;
                [_tableView reloadData];
                _tableView.hidden = NO;
                _tabBarView.hidden = NO;
            }else {
                ActivityDetail *model = responseObject[0];
                if (model.activityIsCollect) {
                    _activityDetail.activityIsCollect = YES;
                }
                if (model.activityIsWant) {
                    _activityDetail.activityIsWant = YES;
                }
                
                [weakSelf handleSomething:YES];
            }
        }else {
            // 请求失败
            if(!localUpdate) {
                [SVProgressHUD dismiss];
                [weakSelf requsetDidFail:responseObject];
            }
        }
    }];
}

//点赞（我想去）列表数据
- (void)startRequestWantGoUserData
{
    int rowNum = 0;
    [ToolClass getElementWidthWithMinWidth:32 elementSpacing:4 containerWidth:kScreenWidth-20 elementNum:&rowNum];
    
    [AppProtocol getUserWantgoListWithType:DataTypeActivity modelId:self.activityId pageIndex:0 pageNum:rowNum UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        
        if (responseCode == HttpResponseSuccess) {
            _activityDetail.totalNumOfLike = [responseObject[0] integerValue];
            _wantGoUsersArray = [NSMutableArray arrayWithArray:responseObject[1]];
            if (_wantGoUsersArray.count) {
                _sectionIsHidden[6] = NO;
            }
            [_tableView reloadData];
        }
    }];
}


//收藏请求
- (void)userCollectRequestWithIsCancel:(BOOL)isCancel
{
    if (![self userCanOperateAfterLogin]) {
        _isUserLoginFromDetail = YES;
        return;
    }
    
    if ([ToolClass showForbiddenNotice] == YES) {
        return;
    }
    
    WS(weakSelf);
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setBackgroundColor:ColorFromHex(@"eeeeee")];
    if (isCancel){
        [SVProgressHUD showWithStatus:@"正在为您取消收藏..."];
    }
    
    [AppProtocol userCollectOperationWithDataType:DataTypeActivity isCancel:isCancel modelId:self.activityId UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        
        if (responseCode == HttpResponseSuccess) {
            if (isCancel) {
                [SVProgressHUD showSuccessWithStatus:@"取消收藏成功！"];
            }else {
                [SVProgressHUD showSuccessWithStatus:@"收藏成功！"];
            }
            
            if (weakSelf.collectOperationHandler) {
                weakSelf.collectOperationHandler(weakSelf.activityId, !isCancel);
            }
            [_tabBarView setButtonStatusWithIndex:2 title:@"" selected: !isCancel ];
        }
        else {
            if ([responseObject isKindOfClass:[NSString class]]) {
                [SVProgressHUD showInfoWithStatus:responseObject];
            }
        }
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleLight];
    }];
}

//用户点赞请求
- (void)wantGoUserRequestWithIsCancel:(BOOL)isCancel
{
    if (![self userCanOperateAfterLogin]) {
        _isUserLoginFromDetail = YES;
        return;
    }
    
    if ([ToolClass showForbiddenNotice]) {
        return;
    }
    
    [AppProtocol userLikeOperationWithType:DataTypeActivity isCancel:isCancel modelId:_activityId UsingBlock:^(HttpResponseCode responseCode, id responseObject)
     {
         if (responseCode == HttpResponseSuccess){//点赞操作成功
             if (isCancel) {//取消点赞
                 
                 [SVProgressHUD showSuccessWithStatus:@"成功取消点赞"];
                 [_tabBarView setButtonStatusWithIndex:1 title:@"" selected:NO];
                 
                 NSString *userId = [UserService sharedService].userId;
                 NSInteger index = -1;
                 
                 for (int i = 0; i < _wantGoUsersArray.count; i++)
                 {
                     Registration *wantGoUserModel = _wantGoUsersArray[i];
                     if ([wantGoUserModel.userId isEqualToString:userId])
                     {
                         index = i;
                         break;
                     }
                 }
                 if (index > -1)
                 {
                     [_wantGoUsersArray removeObjectAtIndex:index];
                 }
                 _activityDetail.totalNumOfLike -= 1;
                 if (_activityDetail.totalNumOfLike < 0) {
                     _activityDetail.totalNumOfLike = 0;
                 }
             }
             else//添加点赞
             {
                 [SVProgressHUD showSuccessWithStatus:@"点赞成功"];
                 
                 User *user = [UserService sharedService].user;
                 Registration *wantGoUserModel = [[Registration alloc] init];
                 wantGoUserModel.userId = user.userId;
                 wantGoUserModel.userName = user.userNameFull;
                 wantGoUserModel.userSex = user.userSex;
                 wantGoUserModel.userHeadImgUrl = user.userHeadImgUrl;
                 [_wantGoUsersArray insertObject:wantGoUserModel atIndex:0];
                 _activityDetail.totalNumOfLike += 1;
             }
             _sectionIsHidden[6] = _activityDetail.totalNumOfLike < 1;
             
             [_tabBarView setButtonStatusWithIndex:1 title:@"" selected: !isCancel ];
             [_tableView reloadData];
             
         }else{
             if ([responseObject isKindOfClass:[NSString class]]) {
                 [SVProgressHUD showInfoWithStatus:responseObject];
             }
         }
     }];
}

/**
 *  加载评论列表数据
 */
- (void)startRequestCommentDataWithClearData:(BOOL)isClearData
{
    NSInteger pageIndex = _commentArray.count ? _commentArray.count : 0;
    if (_commentArray.count < 1) {
        isClearData = YES;
    }
//    EnumCacheMode cacheMode = isClearData ? CACHE_MODE_REALTIME : CACHE_VALID_TIME_SHORT;
    
    [AppProtocol getCommentListOfDetailPageWithDataType:DataTypeActivity modelId:self.activityId pageIndex:pageIndex pageNum:kRefreshCount cacheMode:CACHE_MODE_REALTIME UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        
        [_tableView.footer endRefreshing];
        
        if (responseCode == HttpResponseSuccess)
        {
            _activityDetail.totalNumOfComment = MAX([responseObject[0] integerValue], _commentArray.count);
            if (isClearData) {
                _commentArray = [NSMutableArray arrayWithArray:responseObject[1]];
            }
            else {
                if ([responseObject[1] count]) {
                    _commentArray = [NSMutableArray arrayWithArray:[_commentArray arrayByAddingObjectsFromArray:responseObject[1]]];
                }else {
                    [SVProgressHUD showInfoWithStatus:@"没有更多评论了!"];
                }
            }
            
            if (_commentArray.count) {
                _sectionIsHidden[7] = NO;
            }else {
                _sectionIsHidden[7] = YES;
                _tableView.footer = nil;
            }
            [_tableView reloadData];
        }
    }];
}

//浏览量
- (void)startRequestActivityScanCount
{
    [AppProtocol getScanCountWithDataType:DataTypeActivity modelId:self.activityId UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        if (responseCode == HttpResponseSuccess) {
            _activityDetail.totalNumOfScan = [responseObject integerValue];
            //点赞区
            [_tableView reloadSections:[NSIndexSet indexSetWithIndex:6] withRowAnimation:UITableViewRowAnimationNone];
        }
    }];
}

/*
 活动秒杀场次列表:
 如果是点击完“预订按钮”后请求数据，需要在满足预订的条件的情况下，进入到预订页面
 */
- (void)startRequestActivitySeckillEventList:(BOOL)isButtonClick
{
    if (_seckillStatus == 3){
        [SVProgressHUD showLoading];
    }
    WS(weakSelf);
    
    [AppProtocol getActivitySeckillListWithActivityId:_activityId isSeckill:YES UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        
        if (responseCode == HttpResponseSuccess){
            _activityDetail.seckillArray = responseObject;
            [weakSelf handleSeckillRequest:isButtonClick];
            [SVProgressHUD dismiss];
        }
        else
        {
            [SVProgressHUD showInfoWithStatus:responseObject];
        }
    }];
}

//演出方的其他活动
- (void)startRequestShowOtherActivityData
{
    [AppProtocol getActivityShowOtherListWithActivityId:self.activityId associationId:_activityDetail.associationId cacheMode:CACHE_MODE_REALTIME UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        
        if (responseCode == HttpResponseSuccess) {
            _activityDetail.totalNumOfOtherActivity = MAX([responseObject[0] integerValue], [responseObject[1] count]);
            if ([responseObject[1] count] > 4) {
                _otherArray = [responseObject[1] subarrayWithRange:NSMakeRange(0, 4)];
            }else {
                _otherArray = responseObject[1];
            }
            
            if (_otherArray.count) {
                _sectionIsHidden[5] = NO;
            }else {
                _sectionIsHidden[5] = YES;
            }
            [_tableView reloadData];
        }
    }];
}

#pragma mark - 数据初始化

- (void)initMutableArrayData
{
    _wantGoUsersArray = [NSMutableArray new];
    _commentArray = [NSMutableArray array];
}

/**
 *  初始化每个区的区头标题
 */
- (void)setupSectionTitleArray
{
    /*
     活动信息
     秒杀播报
     活动详情
     温馨提示
     活动单位
     演出方的其他活动 —————— 有右侧按钮
     用户点赞
     用户评论
     */
    _sectionTitleArray = [[NSArray alloc] initWithObjects:
                          @"活动信息", //0
                          @"秒杀播报",//1
                          @"活动详情",//2
                          @"温馨提示",//3
                          @"活动单位",//4
                          @"演出方的其他活动", // 5. 有右侧按钮
                          @"用户点赞",//6
                          @"用户评论",//7
                          nil];
    for (int i = 0; i < _sectionTitleArray.count; i++) {
        _sectionIsHidden[i] = i > 0;
    }
}


#pragma mark - 辅助的方法


//轮播图的URL
- (void)setupBannerViewUrlsArray
{
    NSArray *tmpArray = [_activityDetail.activityIconUrl componentsSeparatedByString:@","];
    NSMutableArray *urlArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < tmpArray.count; i++)
    {
        if ([tmpArray[i] length])
        {
            [urlArray addObject:JointedImageURL(tmpArray[i],kImageSize_750_500)];
        }
    }
    _bannerURLsArray = [urlArray copy];
    
    _bannerView.imageURLStringsGroup = [urlArray copy];
    if (_bannerURLsArray.count == 1)
    {
        _bannerView.autoScroll = NO;
    }
    [self initBannerViewSubviews];
}


//轮播图上的子视图
- (void)initBannerViewSubviews
{
    [_bannerMaskView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    //预约状态
    //   参与类型：无需预约、在线预订 余票XX张
    UILabel *reserveLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _bannerMaskView.height-15-28, 0, 28)];
    reserveLabel.radius = 5;
    reserveLabel.backgroundColor = RGBA(0, 0, 0, 0.7);
    reserveLabel.textColor = [UIColor whiteColor];
    reserveLabel.font = FontYT(14);
    if (_activityDetail.activityIsReservation){
        if (_activityDetail.isSeckillActivity){
            reserveLabel.text = @"限时秒杀";
            reserveLabel.width = [UIToolClass textWidth:reserveLabel.text font:reserveLabel.font] + 20;
        }else{
            NSString *ticketCount = [NSString stringWithFormat:@"%ld",(long)_activityDetail.activityAbleCount];
            NSString *string = [NSString stringWithFormat:@"余票 %@ 张",ticketCount];
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:FONT(14)}];
            [attributedString addAttribute:NSForegroundColorAttributeName value:kDarkRedColor range:NSMakeRange(3, ticketCount.length)];
            reserveLabel.attributedText = attributedString;
            reserveLabel.width = [UIToolClass attributedTextWidth:attributedString] + 20;
        }
    }else{
        if (_activityDetail.activitySupplementType == 1) {
            reserveLabel.text = @"不可预订";
        }else if (_activityDetail.activitySupplementType == 2) {
            reserveLabel.text = @"无需预约";
        }else if (_activityDetail.activitySupplementType == 3) {
            reserveLabel.text = @"电话预约";
        }else {
            reserveLabel.text = @"无需预约";
        }
        reserveLabel.width = [UIToolClass textWidth:reserveLabel.text font:reserveLabel.font] + 20;
    }
    
    reserveLabel.textAlignment = NSTextAlignmentCenter;
    [_bannerMaskView addSubview:reserveLabel];
    
    reserveLabel.originalX = _bannerMaskView.width - 10 - reserveLabel.width;
    
    //价格
    NSString *priceStr = _activityDetail.showedPrice;
    NSInteger littleFontLength = 0;//字符串最后的小字体文本的长度
    UIFont *bigFont = FONT(25);

    if ([priceStr containsSubString:@"元/"]) {
        littleFontLength = 3;
        bigFont = FONT(28);
    }else if ([priceStr hasSuffix:@"元起"]) {
        littleFontLength = 2;
        bigFont = FontYT(22);
    }
    
    CGFloat fontHeight = [UIToolClass fontHeight:bigFont];
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, reserveLabel.originalY - 5-fontHeight, 0, fontHeight)];
    priceLabel.numberOfLines = 0;
    priceLabel.textColor = [UIColor whiteColor];
    [_bannerMaskView addSubview:priceLabel];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:priceStr];
    [attributedString addAttributes:@{NSFontAttributeName:bigFont, NSForegroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(0, priceStr.length- littleFontLength)];
    [attributedString addAttributes:@{NSFontAttributeName:FONT(14), NSForegroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(priceStr.length- littleFontLength, littleFontLength)];
    priceLabel.attributedText = attributedString;
    priceLabel.width = [UIToolClass attributedTextWidth:attributedString];
    priceLabel.originalX = reserveLabel.maxX - priceLabel.width;
    
    //活动的标签
    CGFloat labelWidth = 0;
    CGFloat labelSpacing  = 10;
    CGFloat labelHeight = 22;
    CGFloat offsetX = 10;
    CGFloat offsetY = reserveLabel.maxY - labelHeight;
    UIFont *font = FONT(14);
    
    for (int i = 0 ; i < _activityDetail.showedActivityTags.count; i++)
    {
        NSString *tagName = _activityDetail.showedActivityTags[i];
        labelWidth = [UIToolClass textWidth:tagName font:font]+20;
        if (offsetX + labelWidth > reserveLabel.originalX - 10) {
            break;
        }
        
        UILabel *tagLabel = [[UILabel alloc] initWithFrame:CGRectMake(offsetX, offsetY, labelWidth, labelHeight)];
        tagLabel.layer.borderColor = [UIColor whiteColor].CGColor;
        tagLabel.layer.borderWidth = 0.6;
        tagLabel.radius = 4;
        tagLabel.font = font;
        tagLabel.textColor = [UIColor whiteColor];
        tagLabel.textAlignment = NSTextAlignmentCenter;
        tagLabel.text = tagName;
        [_bannerMaskView addSubview:tagLabel];
        
        offsetX += labelWidth + labelSpacing;
    }
}

- (void)enterShareView
{
    NSString *shareContent = [ToolClass getHTMLContent:_activityDetail.activityMemo limitedLength:40];
    
    [SharePresentView showShareViewWithTitle:_activityDetail.activityName content:shareContent sharedImage:_bannerView.currentImage imageUrl:nil shareUrl:_activityDetail.shareUrl extParams:@{ @"addIntegral" : @"1", }];
}


#pragma mark - 表视图的数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _sectionTitleArray.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)//活动名称以及基本信息
    {
        return 1+_activityDetail.activityInfoArray.count;
    }
    else if (section == 1)//秒杀播报
    {
        return _sectionIsHidden[section] ? 0 : 1;
    }
    else if (section == 2)//活动详情
    {
        return _sectionIsHidden[section] ? 0 : 1;
    }
    else if (section == 3)//活动单位
    {
        return _sectionIsHidden[section] ? 0 : 1;
    }
    else if (section == 4)//温馨提示
    {
        NSInteger number = _activityDetail.activityUnitArray.count ? 1 : 0;
        return _sectionIsHidden[section] ? 0 : number;
    }
    else if (section == 5)//演出方的其他活动
    {
        return _sectionIsHidden[section] ? 0 : 1 + [ToolClass  getGroupNum:_otherArray.count perGroupCount:2];
    }
    else if (section == 6)//用户点赞
    {
        return _sectionIsHidden[section] ? 0 : 1;
    }
    else// 7. 用户评论
    {
        return (_commentArray.count && _sectionIsHidden[section] == NO) ? _commentArray.count : 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    /*
     
     @"活动信息", //0
     @"秒杀播报",//1
     @"活动详情",//2
     @"温馨提示",//3
     @"活动单位",//4
     @"演出方的其他活动", // 5. 有右侧按钮
     @"用户点赞",//6
     @"用户评论",//7
     
     */
    if (indexPath.section == 0)//活动基本信息
    {
        if (indexPath.row == 0)
        {
            ActivityDetailTitleCell *titleCell = [tableView dequeueReusableCellWithIdentifier:reuseID_TitleCell forIndexPath:indexPath];
            titleCell.activityName = _activityDetail.activityName;
            
            return titleCell;
        } else {
            ActivityDetailInfomationCell *infoCell = [tableView dequeueReusableCellWithIdentifier:reuseID_InfoCell forIndexPath:indexPath];
            [infoCell setDataArray:_activityDetail.activityInfoArray[indexPath.row-1] forIndexPath:indexPath];
            return infoCell;
        }
    }
    else if (indexPath.section == 1)//秒杀播报
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SeckillCell"];
        if (!cell){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SeckillCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        if (_seckillView) {
            [_seckillView removeFromSuperview];
            _seckillView = nil;
        }
        _seckillView = [[SecKillBroadcastView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0) title:@"秒杀播报" notice:_activityDetail.showedScoreNotice modelArray:_activityDetail.seckillArray];
        [cell.contentView addSubview:_seckillView];
        
        return cell;
    }
    else if (indexPath.section == 2)//活动详情
    {
        WebViewCell *webCell = [tableView dequeueReusableCellWithIdentifier:reuseID_WebViewCell forIndexPath:indexPath];
        webCell.webView.delegate = self;
        webCell.webView.tag = indexPath.section;
        CGFloat height = _webViewHeight[indexPath.section];
        webCell.moreButton.hidden = YES;
        webCell.webView.height = height;
        webCell.htmlString = _activityDetail.activityMemo;
        return webCell;
    }
    else if (indexPath.section == 3)//温馨提示
    {
        WebViewCell *webCell = [tableView dequeueReusableCellWithIdentifier:reuseID_WebViewNoticeCell forIndexPath:indexPath];
        webCell.webView.delegate = self;
        webCell.webView.tag = indexPath.section;
        webCell.webView.height = _webViewHeight[indexPath.section];
        webCell.moreButton.hidden = YES;
        webCell.htmlString = _activityDetail.activityInformation;
        return webCell;
    }
    else if (indexPath.section == 4)//活动单位
    {
        WS(weakSelf);
        ActivityDetailActivityUnitCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID_UnitCell forIndexPath:indexPath];
        cell.block = ^(NSString *activityUnitId) {
            
            NSString *linkUrl = [NSString stringWithFormat:@"%@?assnId=%@",kActDetailAssociationWebUrl, activityUnitId];
            
            UINavigationController *nav = weakSelf.navigationController;
            NSArray *vcArray  = nav.viewControllers;
            for (NSInteger i = vcArray.count-1; i > 0; i--) {
                
                WebViewController *vc = vcArray[i];
                if ([vc isKindOfClass:[WebViewController class]] && [vc.currentUrl isEqualToString:linkUrl]) {
                    [nav popToViewController:vcArray[i-1] animated:NO];
                    break;
                }
            }

            WebViewController *vc = [WebViewController new];
            vc.url = linkUrl;
            [nav pushViewController:vc animated:YES];
        };
        [cell setDataArray:_activityDetail.activityUnitArray forIndexPath:indexPath];
        return cell;
    }
    else if (indexPath.section == 5)//演出方的其他活动
    {
        if (indexPath.row == 0 ) { // 当作区头
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID_BlankCell forIndexPath:indexPath];
            cell.contentView.backgroundColor = COLOR_IWHITE;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            
            WS(weakSelf);
            FBButton *button = [[FBButton alloc] initWithImage:CGRectMake(0, 0, kScreenWidth, HEIGHT_HEADER) bgcolor:COLOR_IWHITE img:nil clickEvent:^(FBButton *owner) {
                ShowOtherActivityViewController *vc = [ShowOtherActivityViewController new];
                vc.activityId = weakSelf.activityId;
                vc.associationId = _activityDetail.associationId;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }];
            button.animation = NO;
            button.userInteractionEnabled = _activityDetail.totalNumOfOtherActivity > 4;
            [cell.contentView addSubview:button];
            
            UILabel *leftLabel =  [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 0, button.height)];
            leftLabel.text = _sectionTitleArray[indexPath.section];
            leftLabel.textColor = ColorFromHex(@"666666");
            leftLabel.font = FontYT(16);
            [button addSubview:leftLabel];
            leftLabel.width = [UIToolClass textWidth:leftLabel.text font:leftLabel.font];
            
            if (_activityDetail.totalNumOfOtherActivity > 4) {
                
                button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
                button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
                [button setImage:IMG(@"arrow_right") forState:UIControlStateNormal];
                
                NSString *title = [NSString stringWithFormat:@"共 %d 个活动",(int)_activityDetail.totalNumOfOtherActivity];
                UILabel *rightLabel =  [[UILabel alloc] initWithFrame:CGRectMake(leftLabel.maxX+10, 5, kScreenWidth-30-leftLabel.maxX-10, button.height-5)];
                [button addSubview:rightLabel];
                
                NSMutableAttributedString *attributedString = (NSMutableAttributedString *)[UIToolClass getAttributedStr:title font:FontYT(14) lineSpacing:4 alignment:NSTextAlignmentRight];
                [attributedString addAttribute:NSForegroundColorAttributeName value:ColorFromHex(@"666666") range:NSMakeRange(0, title.length)];
                NSArray *rangeArray = [ToolClass getDigitalNumberRanges:title];
                for (NSValue *rangeValue in rangeArray) {
                    [attributedString addAttribute:NSForegroundColorAttributeName value:kDarkRedColor range:rangeValue.rangeValue];
                }
                rightLabel.attributedText = attributedString;
            }
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, button.height-1, kScreenWidth-20, 1)];
            lineView.backgroundColor = kBgColor;
            [button addSubview:lineView];
            
            return cell;
        }
        else {
            ShowOtherActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID_OtherActivity forIndexPath:indexPath];
            
            NSInteger leftIndex = 2*(indexPath.row-1);
            NSInteger rightIndex = 2*(indexPath.row-1)+1;
            
            ShowOtherActivityModel *leftModel = _otherArray[leftIndex];
            ShowOtherActivityModel *rightModel = nil;
            if (rightIndex < _otherArray.count) {
                rightModel = _otherArray[rightIndex];
            }
            WS(weakSelf);
            
            // 演出方的其它活动的点击事件
            cell.block = ^ (ShowOtherActivityModel *model){
                
                UINavigationController *nav = weakSelf.navigationController;
                NSArray *vcArray = nav.viewControllers;
                for (NSInteger i = vcArray.count-1; i > 0; i--) {
                    ActivityDetailViewController *pushedVC = vcArray[i];
                    if ([pushedVC isKindOfClass:[ActivityDetailViewController class]]) {
                        // 堆栈里已经存在一个activityId和要压栈的activityId相同的VC
                        if ([pushedVC.activityId isEqualToString:model.activityId] && pushedVC.activityId.length) {
                            CalendarViewController *vc = vcArray[i-1];
                            if ([vc isKindOfClass:[CalendarViewController class]]) {
//                                vc.screenshotImages = nil;
                            }
                            [nav popToViewController:vc animated:NO];
                            break;
                        }
                    }
                }
                
                ActivityDetailViewController *vc = [ActivityDetailViewController new];
                vc.activityId = model.activityId;
                [nav pushViewController:vc animated:YES];
            };
            
            CGFloat topSpacing = indexPath.row == 1 ? 22 : 10;
            CGFloat bottomSpacing = 0;
            
            if (indexPath.row-1 == [ToolClass  getGroupNum:_otherArray.count perGroupCount:2] - 1) {
                bottomSpacing = 35;
            }
            
            [cell setLeftModel:leftModel rightModel:rightModel topSpacing:topSpacing bottomSpacing:bottomSpacing];
            
            return cell;
        }
    }
    else if (indexPath.section == 6)//用户点赞
    {
        LikeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID_WantGoCell forIndexPath:indexPath];
        [cell setLikeCount:_activityDetail.totalNumOfLike scanCount:_activityDetail.totalNumOfScan];
        [cell setModelArray:_wantGoUsersArray];
        return cell;
    }
    else//用户点评  if (indexPath.section == 7)
    {
        CommentModel *model = _commentArray[indexPath.row];
        
        ActivityCommentDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID_CommentCell forIndexPath:indexPath];
        [cell setCommmentModel:model forIndexPath:indexPath];
        [cell setLineViewHidden:(indexPath.row == _commentArray.count-1)];
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ActivityDetailHeaderView *headerView = nil;
    if (section == 2 && [_activityDetail isShowAnchor])
    {
        if (infoHeaderView) {
            return infoHeaderView;
        }
        
        UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"DetailHeaderView"];
        if (!headerView) {
            headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"DetailHeaderView"];
        }
        [headerView.contentView addSubview:[self getDetailSectionHeaderWithBaseTag:3]];
        infoHeaderView = headerView;
        
        return headerView;
    }
    else
    {
        headerView =  [tableView dequeueReusableHeaderFooterViewWithIdentifier:reuseID_HeaderView];
        if (!headerView) {
            headerView = [[ActivityDetailHeaderView alloc] initWithReuseIdentifier:reuseID_HeaderView];
        }
    }
    
    
    headerView.button.tag = section;
    
    
    NSString *leftTitle = _sectionTitleArray[section];
    if (section == 7) {
        leftTitle = [NSString stringWithFormat:@"%d",(int)_activityDetail.totalNumOfComment];
    }
    NSString *rightTitle = @"";
    [headerView setDataArray:@[leftTitle, rightTitle] forSection:section];
    
    //右侧的箭头
    headerView.accessoryImgHidden = YES;
    
    headerView.headerViewButtonBlock = ^(NSInteger btnIndex)
    {
        
    };
    
    
    if (section == 0) {
        return nil;
        
    }else if (section ==1){//秒杀播报
        return nil;
    }
    else if (section ==2){//活动详情
        return _sectionIsHidden[section] ? nil : headerView;
    }
    else if (section ==3){//温馨提示
        return _sectionIsHidden[section] ? nil : headerView;
    }
    else if (section ==4){//活动单位
        return _sectionIsHidden[section] ? nil : headerView;
    }
    else if (section ==5){//用户点赞
        return nil;
    }
    else if (section ==7){//用户点评
        return _sectionIsHidden[section] ? nil : headerView;
    }
    else{
        return nil;
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UITableViewHeaderFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"FooterView"];
    if (!footerView)
    {
        footerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"FooterView"];
        footerView.contentView.backgroundColor = kBgColor;
    }
    footerView.hidden = _sectionIsHidden[section] ? YES : NO;
    return footerView;
}



#pragma mark - 表视图的代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)//活动基本信息
    {
        if (indexPath.row == 0)
        {
            return [self getTitleAndTagsCellHeight];
        }else{
            if (indexPath.row == 3 && [_activityDetail.activityInfoArray[2][1] count])
            {
                // 时间 以及 时间备注
                NSArray *timeArray = _activityDetail.activityInfoArray[indexPath.row-1][1];
                
                UIFont *font = FONT(15);
                CGFloat textWidth = 0;
                CGFloat fontHeight = [UIToolClass fontHeight:font];
                
                CGFloat offsetX = 40;
                CGFloat offsetY = 23 - fontHeight*0.5;
                CGFloat spacingX = 10;
                CGFloat spacingY = 7;
                
                for (int i = 0; i < timeArray.count; i++)
                {
                    NSString *timeStr = timeArray[i];
                    
                    if (i == timeArray.count-1 && [timeStr hasPrefix:@"|"]) {//时间备注
                        if (i == 0 ){
                            offsetX = 40;
                            offsetY += [UIToolClass textHeight:[timeStr substringFromIndex:1] lineSpacing:4 font:font width:kScreenWidth-80+25]-fontHeight;
                        }else{
                            offsetX = 40;
                            offsetY += [UIToolClass textHeight:[timeStr substringFromIndex:1] lineSpacing:4 font:font width:kScreenWidth-80+25] + spacingY;
                        }
                    }else{
                        textWidth = [UIToolClass textWidth:timeStr font:font];
                        
                        if (offsetX + textWidth > kScreenWidth-40+25) {
                            offsetX = 40;
                            offsetY += fontHeight + spacingY;
                        }
                        offsetX += textWidth + spacingX;
                    }
                }
                return offsetY+fontHeight + 23 - fontHeight*0.5;
            }else
            {
                UIImage *image = IMG(_activityDetail.activityInfoArray[indexPath.row-1][0]);
                NSString *title = indexPath.row ==3 ? @"" : _activityDetail.activityInfoArray[indexPath.row-1][1];
                CGFloat textHeight = [UIToolClass textHeight:title lineSpacing:4 font:FONT(15) width:kScreenWidth-80];
                CGFloat cellHeight = 12 + textHeight + 12;
                
                if (cellHeight < 12+image.size.height + 12){
                    cellHeight = 12+image.size.height + 12;
                }
                return cellHeight;
            }
        }
    }
    else if (indexPath.section == 1)//秒杀播报
    {
        return [self getSeckillCellHeight];
    }
    else if (indexPath.section == 2)//活动详情
    {
        if (_activityDetail.activityMemo.length) {
            return _webViewHeight[indexPath.section];
        }
        else{
            return 0;
        }
    }
    else if (indexPath.section == 3)//活动单位
    {
        return _webViewHeight[indexPath.section];
    }
    else if (indexPath.section == 4)//温馨提示
    {
        return _activityDetail.activityUnitArray.count ? [self getActivityUnitCellHeight] : 0;
    }
    else if (indexPath.section == 5)//演出方的其他活动
    {
        if (indexPath.row == 0) {
            return HEIGHT_HEADER;
        }else{
            CGFloat topSpacing = indexPath.row == 1 ? 22 : 10;
            CGFloat bottomSpacing = 0;
            
            if (indexPath.row-1 == [ToolClass  getGroupNum:_otherArray.count perGroupCount:2] - 1) {
                bottomSpacing = 35;
            }
            
            return (kScreenWidth-15)*0.5*0.63+38+ topSpacing+bottomSpacing;
        }
    }
    else if (indexPath.section == 6)//用户点赞
    {
        return 12.5+[UIToolClass fontHeight:FONT(14)]+10+32+15;
    }
    else{//用户点评
        
        return [self getCommentCellHeightWithModel:_commentArray[indexPath.row]];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    /*
     
     @"活动信息", //0
     @"秒杀播报",//1
     @"活动详情",//2
     @"温馨提示",//3
     @"活动单位",//4
     @"演出方的其他活动", // 5. 有右侧按钮
     @"用户点赞",//6
     @"用户评论",//7
     
     */
    
    if (section == 2 && _sectionIsHidden[section] == NO){//活动详情
        return HEIGHT_HEADER;
    }
    
    if (section == 3 && _sectionIsHidden[section] == NO){//温馨提示
        return HEIGHT_HEADER;
    }
    
    if (section == 4 && _sectionIsHidden[section] == NO){//活动单位
        return HEIGHT_HEADER;
    }
    
    if (section == 7 && _sectionIsHidden[section] == NO){//用户点评
        return HEIGHT_HEADER;
    }
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    NSInteger lastShowSection = [self getLastShowedSection];
    if (section == lastShowSection) {
        return 7.5+_tabBarView.height;
    }
    
    return (_sectionIsHidden[section] || section == _sectionTitleArray.count-1) ? 0.01 :7.5;
}

- (NSInteger)getLastShowedSection
{
    NSInteger lastSection = -1;
    for (int i = (int)_sectionTitleArray.count-1; i > -1; i--) {
        if (_sectionIsHidden[i] == NO) {
            lastSection = i;
            break;
        }
    }
    return lastSection;
}

- (CGFloat)getTitleAndTagsCellHeight
{
    CGFloat cellHeight = 16;
    
    cellHeight += [UIToolClass textHeight:_activityDetail.activityName lineSpacing:4 font:FONT(18) width:kScreenWidth-20] +11;
    
    return cellHeight;
}

- (CGFloat)getSeckillCellHeight
{
    CGFloat cellHeight = 0;
    
    CGFloat rightLabelWidth =  kScreenWidth-10-(10+[UIToolClass textWidth:@"秒杀播报" font:FontYT(18)]+15);
    
    NSString *notice = nil;
    if (_activityDetail.requiredScoreType == 1) {
        notice = [NSString stringWithFormat:@"本活动需要达到%d积分才可预订",(int)(_activityDetail.lowestCredit)];
    }else if (_activityDetail.requiredScoreType == 2){
        notice = [NSString stringWithFormat:@"预订本活动每张票务需要抵扣%d积分",(int)(_activityDetail.costCredit)];
    }else if (_activityDetail.requiredScoreType == 3){
        notice = [NSString stringWithFormat:@"预订本活动需要达到%d积分,且每张票务需抵扣%d积分",(int)_activityDetail.lowestCredit,(int)_activityDetail.costCredit];
    }
    else{
        notice = @"  ";
    }
    
    cellHeight = 20 +[UIToolClass textHeight:notice lineSpacing:4 font:FontYT(13) width:rightLabelWidth] + 20;
    
    if (_activityDetail.seckillArray.count) {
        cellHeight += _activityDetail.seckillArray.count * 40+(_activityDetail.seckillArray.count-1)*1+35;
    }
    return cellHeight;
}

//活动单位
- (CGFloat)getActivityUnitCellHeight
{
    CGFloat leftSpacing = 10;
    CGFloat lineSpacing = 10;
    CGFloat offsetY = 27;
    
    CGFloat leftTextWidth = [UIToolClass textWidth:@"活动日期：" font:FONT(14)]+2;
    CGFloat middleTextWidth = 0;
    
    CGFloat textHeight = 0;
    
    for (int i = 0;  i < _activityDetail.activityUnitArray.count; i++)
    {
        NSArray *array = _activityDetail.activityUnitArray[i];
        NSString *rightTitle = array[1];
        
        if (rightTitle.length)
        {
            if (array.count > 2 && [array[3] length]) {
                middleTextWidth = kScreenWidth - leftSpacing - leftTextWidth - 10-18.5;
            }else {
                middleTextWidth = kScreenWidth - leftSpacing - leftTextWidth - 10;
            }
            
            textHeight = [UIToolClass textHeight:rightTitle lineSpacing:4 font:FONT(14) width:middleTextWidth];
            
            if (array.count > 2 && [array[2] count]) {
                offsetY += textHeight+8;
                
                CGFloat offsetX = 0;
                CGFloat textWidth = 0;
                CGFloat tagHeight = 18;
                
                for (int i = 0; i < [array[2] count]; i++) {
                    NSString *tagName = array[2][i];
                    if (tagName.length) {
                        textWidth = MIN([UIToolClass textWidth:tagName font:FontYT(12)]+20, middleTextWidth);
                        
                        if (offsetX + textWidth > middleTextWidth) {
                            offsetX = 0;
                            offsetY += tagHeight + 8;
                        }
                        offsetX += textWidth + 5;
                    }
                }
                
                offsetY += tagHeight + 2*lineSpacing + 1;
            }else{
                offsetY += textHeight+2*lineSpacing + 1;
            }
        }
    }
    return offsetY + 10 - lineSpacing;
}


- (CGFloat)getCommentCellHeightWithModel:(CommentModel *)model
{
    CGFloat cellHeight = 18 + [UIToolClass fontHeight:FONT(14)] +8+[UIToolClass fontHeight:FONT(12)]+10;
    CGFloat viewWidth = kScreenWidth-20-32-10;
    
    if (model.commentRemark.length < 1) {
        cellHeight -= 2.5;
    }else{
        cellHeight += [UIToolClass textHeight:model.commentRemark lineSpacing:4 font:FONT(14) width:viewWidth];
    }
    
    NSInteger rowNumber = (model.imageOrUrlStrArray.count%3 == 0) ? model.imageOrUrlStrArray.count/3 : model.imageOrUrlStrArray.count/3 + 1;
    CGFloat imageContainerHeight = rowNumber > 0 ? rowNumber*(viewWidth-2*10)/3 + (rowNumber-1)*10 : 0;
    if (imageContainerHeight > 1) {
        cellHeight += imageContainerHeight + 12.5;
    }
    return cellHeight + 20;
}

#pragma mark -
#pragma mark -  按钮的点击事件 Action Methods

//查看报名用户列表
- (void)wantGoCellButtonClick:(UIButton *)sender
{
    RegistrationViewController *registrationVC = [[RegistrationViewController alloc] init];
    registrationVC.activityId = self.activityId;
    [self.navigationController pushViewController:registrationVC animated:YES];
}


#pragma mark - 查看更多活动详情
- (void)activityDetailMoreContentButtonClick:(UIButton *)sender
{
    [PopupWebView webViewWithUrl:_activityDetail.activityMemo navTitle:@"活动详情"];
}

//#pragma mark - 单元格的点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.section == 0)//活动基本信息
    {
        switch (indexPath.row) {
            case 1://地址
            {
                if (_activityDetail.activityLat < 0.1 && _activityDetail.activityLat < 0.1)
                {
                    [SVProgressHUD showInfoWithStatus:@"暂无相关位置信息"];
                    return;
                }
                
                NearbyLocationViewController *vc = [[NearbyLocationViewController alloc]init];
                vc.locationCoordinate2D =  CLLocationCoordinate2DMake(_activityDetail.activityLat, _activityDetail.activityLon);
                vc.addressString = _activityDetail.activityAddress;
                vc.type = DataTypeActivity;
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 4://电话
            {
                [UIToolClass callPhone:_activityDetail.activityTel sourceVC:self];
            }
                break;
            default:
                break;
        }
    }
}


- (void)handleSomething:(BOOL)localUpdate
{
    if (localUpdate) {
        // 收藏按钮
        [_tabBarView setButtonStatusWithIndex:2 title:nil selected:_activityDetail.activityIsCollect];
        // 点赞按钮
        [_tabBarView setButtonStatusWithIndex:1 title:nil selected:_activityDetail.activityIsWant];
        
        return;
    }
    
    //导航条
    if (_navTitleView == nil) {
        _navTitleView = [[DetailNavTitleView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, HEIGHT_TOP_BAR) navTitle:_activityDetail.activityName];
        [self.view addSubview:_navTitleView];
    }
    
    [self setupBannerViewUrlsArray];
    
    //底部的工具栏
    [self initTabBarView];
    
    //秒杀播报
    if (_activityDetail.isSeckillActivity){
        [self startRequestActivitySeckillEventList:NO];
    }
    
    //活动详情
    if (_activityDetail.activityMemo.length) {
        _sectionIsHidden[2] = NO;
    }
    
    //温馨提示
    if (_activityDetail.activityInformation.length ){
        _sectionIsHidden[3] = NO;
    }
    
    //活动单位
    if (_activityDetail.activityUnitArray.count) {
        _sectionIsHidden[4] = NO;
    }
    
    //演出方的其他活动(社团)
    if (_activityDetail.associationId.length) {
        [self startRequestShowOtherActivityData];
    }
    
    //点赞
    [self startRequestWantGoUserData];
    
    //评论
    [self startRequestCommentDataWithClearData:YES];
    
    // 点赞
    [_tabBarView setButtonStatusWithIndex:1 title:@"" selected:_activityDetail.activityIsWant];
    
    //浏览量
    [self startRequestActivityScanCount];
    
    //收藏
    [_tabBarView setButtonStatusWithIndex:2 title:nil selected:_activityDetail.activityIsCollect];
    
    //预订
    [self setupReserveButton];
    
    // 顶部的悬浮区头
    if ([_activityDetail isShowAnchor]) {
        [self initHeaderTopView];
    }
}

/**
 *  设置预订按钮的状态
 */
- (void)setupReserveButton
{
    //预订
    /* 1-已结束  2-直接前往  3-已订完  4-无法预订 5-立即预订  */
    if (_activityDetail && _activityDetail.isSeckillActivity == NO) {
        
        NSString *reserveTitle = _activityDetail.actIsFree==3 ? @"立即预订" : @"立即预约";
        NSString *joinMethod = @"直接前往";
        if (_activityDetail.activitySupplementType == 1) {
            joinMethod = @"不可预订";
        }else if (_activityDetail.activitySupplementType == 2) {
            joinMethod = @"直接前往";
        }else if (_activityDetail.activitySupplementType == 3) {
            joinMethod = @"电话预约";
        }
        
        NSArray *statusArray = @[@"已结束",joinMethod,@"已订完",@"无法预订",reserveTitle];
        NSInteger reserveStatus = _activityDetail.reserveStatus;
        if (reserveStatus > 0 && reserveStatus < 6) {
            [_tabBarView setButtonStatusWithIndex:4 title:statusArray[reserveStatus-1] selected:reserveStatus==5];
        }
    }else {
        [_tabBarView setButtonStatusWithIndex:4 title:@" " selected:NO];
    }
}

//预订活动
- (void)enterReservePage:(BOOL)isNeedRequestAgain
{
    if (![self userCanOperateAfterLogin]) {
        _isUserLoginFromDetail = YES;
        return;
    }
    
    User *user = [UserService sharedService].user;
    
    if ([user.userIsDisable isEqualToString:@"0"]) {//未激活
        [AnimatedSpringPopupView popupViewWithTitle:@"温馨提示" message:@"您的帐号还未激活，请激活后再使用!" callbackBlock:^(id object, NSInteger index, BOOL isSameIndex) {
            
        }];
        return;
    }
    if ([user.userIsDisable isEqualToString:@"2"]) {//冻结
        [AnimatedSpringPopupView popupViewWithTitle:@"抱歉!" message:@"您的帐号当前已被冻结，无法进行预订操作!" callbackBlock:^(id object, NSInteger index, BOOL isSameIndex) {
        }];
        return;
    }
    
    if (_activityDetail.integralStatus == 0) {
        // 进入活动预订H5页面
        if (isNeedRequestAgain && _activityDetail.isSeckillActivity) {
            [self startRequestActivitySeckillEventList:YES];
            return;
        }
        
        WebViewController *vc = [WebViewController new];
        vc.isBookPage = YES;
        if (_activityDetail.subPlatformReserveUrl.length && [_activityDetail.subPlatformReserveUrl hasPrefix:@"http"]) {
            if ([_activityDetail.subPlatformReserveUrl containsSubString:@"activityId="]) {
                // 链接中已经包含了activityId
                vc.url = [NSString stringWithFormat:@"%@&userId=%@", _activityDetail.subPlatformReserveUrl, user.userId];
            }else {
                vc.url = [NSString stringWithFormat:@"%@?activityId=%@&userId=%@", _activityDetail.subPlatformReserveUrl, _activityId, user.userId];
            }
        }else {
            vc.url = [NSString stringWithFormat:@"%@?activityId=%@",kActivityBookWebUrl,_activityId];
        }
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (_activityDetail.integralStatus == 1){
        [AnimatedSpringPopupView popupViewWithTitle:@"" message:@"抱歉!\n您的积分未达到最低要求" callbackBlock:^(id object, NSInteger index, BOOL isSameIndex) {
            
        }];
    }else if (_activityDetail.integralStatus == 2){
        [AnimatedSpringPopupView popupViewWithTitle:@"抱歉!\n您的积分不够抵扣" message:@"" callbackBlock:^(id object, NSInteger index, BOOL isSameIndex) {
            
        }];
    }
}

/**
 *  进入发表评论界面
 */
- (void)enterCommentPage
{
    if (![self userCanOperateAfterLogin]) {
        _isUserLoginFromDetail = YES;
        return;
    }
    
    if (![ToolClass showForbiddenNotice]) {
        //我要点评
        User *user = [UserService sharedService].user;
        
        if ([user.commentStatus integerValue] == 1) {
            
            WEAK_VIEW(_tableView)
            PublishCommentViewController *vc = [PublishCommentViewController new];
            vc.modelId = _activityId;
            vc.dataType = DataTypeActivity;
            // 评论成功后的回调
            vc.successBlock = ^(CommentModel *model) {
                _isAddComment = YES;
                _sectionIsHidden[7] = NO;
                [_commentArray insertObject:model atIndex:0];
                _activityDetail.totalNumOfComment += 1;
                [weakView reloadData];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }else { // commentStatus = 0
            [SVProgressHUD showInfoWithStatus:@"当前用户已被禁止评论"];
        }
    }
}

#pragma mark - 其他代理方法

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _tableView)
    {
        CGFloat offsetY = scrollView.contentOffset.y;
        // 顶部导航条的动画
        [_navTitleView setContentOffsetY:offsetY];
        
        if ([_activityDetail isShowAnchor]) {
            _headerTopView.hidden = [self getSectionHeaderPositionWithType:1]-offsetY > 0;
            
            UITableViewHeaderFooterView *headerView = [_tableView headerViewForSection:2];
            if (headerView) {
                CGFloat showedHeight = headerView.originalY-scrollView.contentOffset.y- _navTitleView.height;
                if (showedHeight >= 0) {
                    _headerTopView.hidden = YES;
                }
            }
        }
        
        if (offsetY < 0) // 图片下拉放大
        {
            if (_topImgView.image == nil)
            {
                _topImgView.image = [UIToolClass convertImgFromView:_bannerView];
                _topImgView.layer.anchorPoint = CGPointMake(0.5,0);
                _topImgView.frame = MRECT(0, 0, WIDTH_SCREEN, _bannerView.frame.size.height);
            }
            if (_topImgView.superview == nil)
            {
                UIView * v = [[UIView alloc] initWithFrame:_bannerView.bounds];
                v.backgroundColor = COLOR_IWHITE;
                _tableView.tableHeaderView = nil;
                _tableView.tableHeaderView = v;
                [self.view insertSubview:_topImgView belowSubview:backbutton];
            }
            float scale = (_bannerView.frame.size.height - offsetY)/_bannerView.frame.size.height;
            
            if (scale <= 1)
            {
                scale = 1.f;
            }
            _topImgView.transform = CGAffineTransformMakeScale(scale ,scale);
            
        }
        else
        {
            [self restoreHeadView];
        }
        
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (scrollView == _tableView)
    {
        [_tabBarView dismissWithAnimation:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView == _tableView && decelerate == NO) {
        [_tabBarView showWithAnimation:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _tableView)
    {
        [self restoreHeadView];
        [_tabBarView showWithAnimation:scrollView];
    }
}


//#pragma mark - 轮播图的代理方法
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    HZPhotoBrowser *photoVC = [[HZPhotoBrowser alloc] init];
    photoVC.delegate = self;
    photoVC.sourceImagesContainerView = _bannerView;
    photoVC.currentImageIndex = 0;
    photoVC.imageCount = 1;
    [photoVC show];
}

// 查看大图
- (UIImage *)photoBrowser:(HZPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    return _bannerView.currentImage;
}

- (id)photoBrowser:(HZPhotoBrowser *)browser highQualityImageOrImageURLForIndex:(NSInteger)index
{
    id imageOrUrlStr = _bannerURLsArray[index];
    if ([imageOrUrlStr isKindOfClass:[NSString class]])
    {
        return [NSURL URLWithString:imageOrUrlStr];
    }
    else if ([imageOrUrlStr isKindOfClass:[UIImage class]] || [imageOrUrlStr isKindOfClass:[NSURL class]])
    {
        return imageOrUrlStr;
    }
    return nil;
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        
        NSString *url = request.URL.absoluteString;
        if ([url hasPrefix:@"http"]) {
            
            WebViewController *vc = [WebViewController new];
            vc.url = url;
            [self.navigationController pushViewController:vc animated:YES];
            
            return NO;
        }
    }
    
    // 查看大图
    if ([request.URL.scheme isEqualToString:@"image-preview"])
    {
        NSString *path = [request.URL.absoluteString substringFromIndex:[@"image-preview:" length]];
        path = [path stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        
        NSArray *pathArray = [ToolClass getComponentArray:path separatedBy:@";"];
        
        _tableView.userInteractionEnabled = 0;
        __weak UITableView *weakTableView = _tableView;
        
        [WebPhotoBrowser photoBrowserWithImageUrlArray:[webView getImageUrlArrayFromWeb]
                                          currentIndex:[pathArray[1] integerValue]
                                       completionBlock:^(WebPhotoBrowser *photoBrowser) {
                                           weakTableView.userInteractionEnabled = 1;
                                       }];
        
        return NO;
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    context[@"Log"] = ^(NSString *msg) {
        FBLOG(@"%@",msg);
    };
    
    
    [webView addJudgeImageEventExistJs];
    [webView addGetImageUrlJs];
    
    // 重设字体的格式
    [webView addFontSettingJs];
    //修改图片的尺寸
    [webView addResizeWebImageJs];
    [webView addImageClickActionJs];
    
    
    _webViewHeight[webView.tag] = [webView getWebViewContentHeight];
    
    if (webView.tag == 0){//活动参与方式说明
        webView.height = _webViewHeight[webView.tag];
    }
    else if (webView.tag == 1){//活动详情
        webView.height = _webViewHeight[webView.tag];
    }
    [_tableView reloadData];
}

#pragma mark - 活动秒杀
- (void)beginCountdown:(NSTimeInterval)timeInterval afterDelay:(NSTimeInterval)delay
{
    [self performSelector:@selector(fireTimerWithDuration:) withObject:[NSString stringWithFormat:@"%lld",(long long)timeInterval] afterDelay:delay];
}

- (void)fireTimerWithDuration:(NSString *)duration
{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    _remainedSeconds = [duration longLongValue];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateSeckillTime:) userInfo:nil repeats:YES];
    [_timer fire];
}

/**
 *  刷新剩余的秒杀
 */
- (void)updateSeckillTime:(NSTimer *)timer
{
    if (_remainedSeconds <= 0) {
        [timer invalidate];
        timer = nil;
        [self startRequestActivitySeckillEventList:NO];
    }else {
        [_tabBarView setButtonStatusWithIndex:4 title:[ToolClass getCountdownTimeStr:_remainedSeconds] selected:NO];
    }
    _remainedSeconds -= 1;
}

/**
 *  @brief 处理秒杀请求
 *
 *  @param isButtonClick 是否为“点击预订”按钮后的请求
 *
 *  对于秒杀的活动，在点击“预订”后，需要再次请求秒杀的场次来确认该秒杀活动还可以预订 或者 已经秒杀结束
 */
- (void)handleSeckillRequest:(BOOL)isButtonClick
{
    NSInteger status = -1;
    NSTimeInterval remainedSeconds = 0;
    
    NSString *savedIndex = nil;
    
    _activityDetail.seckillArray = [SecKillModel updateSeckillStatus:_activityDetail.seckillArray status:&status remainedSeconds:&remainedSeconds savedIndex:&savedIndex isPast:_activityDetail.reserveStatus == 1];
    
    
    _savedIndex = savedIndex;
    _seckillStatus = status;
    
    if (_activityDetail.seckillArray.count){
        _sectionIsHidden[1] = NO;
    }else{
        [SVProgressHUD showInfoWithStatus:@"查询活动秒杀数据失败!"];
    }
    [_tableView reloadData];
    
    
    if (_activityDetail.reserveStatus == 1){
        [_tabBarView setButtonStatusWithIndex:4 title:@"已结束" selected:NO];
    }else{
        // status :  0-无需秒杀  1-已订完(所有的秒杀全部结束)  2-进入倒计时  3-正在秒杀  4-未开始
        if (_seckillStatus == 0){
            [_tabBarView setButtonStatusWithIndex:4 title:@"无法预订" selected:NO];
        }else if (_seckillStatus == 1){
            [_tabBarView setButtonStatusWithIndex:4 title:@"已订完" selected:NO];
        }else if (_seckillStatus == 2){
            [self beginCountdown:remainedSeconds afterDelay:0];
        }else if (_seckillStatus == 3){
            [_tabBarView setButtonStatusWithIndex:4 title:@"秒 杀" selected:YES];
        }else if (_seckillStatus == 4){
            [_tabBarView setButtonStatusWithIndex:4 title:@"未开始" selected:YES];
        }
    }
    
    if (isButtonClick && _seckillStatus == 3){
        [self enterReservePage:NO];
    }
}


#pragma mark -

/** 刷新详情页数据 */
- (void)updateActivityDetailData
{
    [self initBannerViewSubviews];
    [self setupReserveButton];
}

- (void)restoreHeadView
{
    if (_topImgView.superview != nil)
    {
        _tableView.tableHeaderView = nil;
        _tableView.tableHeaderView = _bannerView;
        [_topImgView removeFromSuperview];
    }
}


// 无数据时的提示
- (void)requsetDidFail:(NSString *)message
{
    WS(weakSelf);
    
    NoDataNoticeView *noticeView = [NoDataNoticeView noticeViewWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-HEIGHT_TOP_BAR-HEIGHT_HOME_INDICATOR) bgColor:[UIColor whiteColor] message:message promptStyle:NoDataPromptStyleClickRefreshForError callbackBlock:^(id object, NSInteger index, BOOL isSameIndex) {
        [weakSelf startRequestActivityDetailData:YES localUpdate:NO];
    }];
    [self.view addSubview:noticeView];
    
    [self.view bringSubviewToFront:backbutton];
}



/**
 *  @brief 获取表的第2（或4）区的区头位置(偏移量)
 *
 *   type ： 1-活动详情区头   2-活动单位区头
 */
- (CGFloat)getSectionHeaderPositionWithType:(NSInteger)type
{
    if (type == 1 || type == 2) {
        CGRect frame = [_tableView rectForHeaderInSection:type==1 ? 2 : 4 ];
        CGFloat position = CGRectGetMaxY(frame) - _navTitleView.height - _headerTopView.height;
        return MIN(position, _tableView.contentSize.height-_tableView.height);
    }
    return 0;
}


/**
 *  @brief 获取 表的区头 或 区头副本（添加到self.view上）
 *
 *  表的区头(2区)：infoHeaderView， 区头副本：_headerTopView
 *  前者两个按钮的tag值为3，4       后者的两个按钮的tag值为1，2
 */
- (UIView *)getDetailSectionHeaderWithBaseTag:(NSInteger)tag
{
    MYMaskView *headerView = [MYMaskView maskViewWithBgColor:COLOR_IWHITE frame:CGRectMake(0, 0, kScreenWidth, HEIGHT_HEADER) radius:0];
    
    WS(weakSelf);
    NSArray *titleArray = @[@"活动详情",@"活动单位"];
    for (int i = 0; i < titleArray.count; i++) {
        
        FBButton *button = [[FBButton alloc] initWithText:CGRectMake(i*(kScreenWidth*0.5+kLineThick*0.5), 0, kScreenWidth*0.5-kLineThick*0.5, HEIGHT_HEADER) font:FontYT(16) fcolor:ColorFromHex(@"666666") bgcolor:nil text:titleArray[i] clickEvent:^(FBButton *owner) {
            
            if (owner.tag == 1 || owner.tag == 3) { // 活动详情
                _selectedHeaderIndex = 0;
                [weakSelf updateSectionHeaderSelectedIndex];
                [_tableView setContentOffset:CGPointMake(0, [weakSelf getSectionHeaderPositionWithType:1]) animated:YES];
            }else { // 活动单位
                _selectedHeaderIndex = 1;
                [weakSelf updateSectionHeaderSelectedIndex];
                [_tableView setContentOffset:CGPointMake(0, [weakSelf getSectionHeaderPositionWithType:2]) animated:YES];
            }
        }];
        button.tag = i+tag;
        button.selected = i==_selectedHeaderIndex;
        [button setTitleColor:kDeepLabelColor forState:UIControlStateSelected];
        [headerView addSubview:button];
        
        if (i == 0) { // 中间的竖直分割线
            MYMaskView *line = [MYMaskView maskViewWithBgColor:ColorFromHex(@"CCCCCC") frame:CGRectMake(button.maxX, 5, kLineThick, HEIGHT_HEADER-10) radius:0];
            [headerView addSubview:line];
        }
    }
    MYMaskView *bottomLine = [MYMaskView maskViewWithBgColor:ColorFromHex(@"CCCCCC") frame:CGRectMake(10, HEIGHT_HEADER-kLineThick, kScreenWidth-20, kLineThick) radius:0];
    [headerView addSubview:bottomLine];
    
    MYMaskView *indicatorView = [MYMaskView maskViewWithBgColor:kNavigationBarColor frame:CGRectMake(0, HEIGHT_HEADER-1.25, 150, 1.5) radius:0];
    indicatorView.tag = 10;
    [headerView addSubview:indicatorView];
    indicatorView.centerX = [headerView viewWithTag:tag].centerX;
    
    return headerView;
}


/**
 *  切换 活动详情 和 活动单位
 */
- (void)updateSectionHeaderSelectedIndex
{
    if (_selectedHeaderIndex == 0) { // 活动详情
        
        UIButton *selectedBtn1 = [_headerTopView viewWithTag:1];
        UIButton *otherButton1 = [_headerTopView viewWithTag:2];
        UIButton *selectedBtn2 = [infoHeaderView viewWithTag:3];
        UIButton *otherButton2 = [infoHeaderView viewWithTag:4];
        
        selectedBtn1.selected = selectedBtn2.selected = YES;
        otherButton1.selected = otherButton2.selected = NO;
        
        [_headerTopView viewWithTag:10].centerX = selectedBtn1.centerX;
        [infoHeaderView viewWithTag:10].centerX = selectedBtn1.centerX;
        
    }else { // 活动单位
        UIButton *selectedBtn1 = [_headerTopView viewWithTag:2];
        UIButton *otherButton1 = [_headerTopView viewWithTag:1];
        UIButton *selectedBtn2 = [infoHeaderView viewWithTag:4];
        UIButton *otherButton2 = [infoHeaderView viewWithTag:3];
        
        selectedBtn1.selected = selectedBtn2.selected = YES;
        otherButton1.selected = otherButton2.selected = NO;
        
        [_headerTopView viewWithTag:10].centerX = selectedBtn1.centerX;
        [infoHeaderView viewWithTag:10].centerX = selectedBtn1.centerX;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
