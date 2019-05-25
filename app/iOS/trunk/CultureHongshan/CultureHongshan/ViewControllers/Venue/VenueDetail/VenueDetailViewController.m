//
//  VenueDetailViewController.m
//  CultureHongshan
//
//  Created by one on 15/11/6.
//  Copyright © 2015年 CT. All rights reserved.
//

#import "VenueDetailViewController.h"

// Models
#import "AntiqueModel.h"
#import "VenueDetailModel.h"
#import "ActivityRoomModel.h"
#import "CommentModel.h"
#import "Video.h"
#import "ActivityModel.h"//活动Model
#import "Registration.h"//点赞

// Views And Cells
#import "AnimationBackView.h"
#import "PopupWebView.h"// WebView弹窗
#import "WebPhotoBrowser.h"// WebView 查看图片
#import "DetailNavTitleView.h"// 导航条
#import "DetailTabBarView.h"
#import "SharePresentView.h"//分享

#import "LikeTableViewCell.h"//点赞单元格
#import "ActivityCommentDetailCell.h"
#import "AnimatedSpringPopupView.h"

// ViewControllers
#import "AntiqueDetailViewController.h"
#import "VenueRoomListViewController.h"//更多相关的活动室
#import "ActivityRoomDetailViewController.h"//相关活动室详情
#import "PublishCommentViewController.h"//发表评论
#import "ActivityDetailViewController.h"
#import "VenueAntiqueViewController.h"//场馆藏品
#import "NearbyLocationViewController.h"
#import "VenueRelatedActivityViewController.h"
#import "PersonalCenterCommentViewController.h"//个人中心，我的评论

// Other
#import "MJRefresh.h"
#import "SDCycleScrollView.h"//开源项目
#import <AVFoundation/AVFoundation.h>
#import "KrVideoPlayerController.h"
#import "KrVideoPlayerControlView.h"
#import "HZPhotoBrowser.h"//查看图片
#import "FBWebView.h"
#import "WebViewController.h"


#define VIEWTAG_LINEPROGRESS    9841
#define HEIGHT_WEBCONTENT   HEIGHT_SCREEN_FULL * 0.6
#define HEIGHT_TOPIMAGE     235
#define cellId_ActivityRoom @"ActivityRoomCell"
#define cellId_VenueComment @"CommentCell"
#define reuseId_LikeCell    @"LikeCell"//点赞

@interface VenueDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate,UIApplicationDelegate,UIGestureRecognizerDelegate,SDCycleScrollViewDelegate,HZPhotoBrowserDelegate>
{
    UIButton *_detailBtn;//详情
    UIButton *_commentBtn;//评论
    UITableView *_detailTableView;
    FBWebView *detailWebView;//详情内容
    CGFloat _commentCellHeight;//评论cell的高度
    CGFloat infoVenueCellHeight;//信息cell的高度
    CGFloat roomCellHeight;//相关活动室cell的高度
    CGFloat detailCellHeight;
    CGFloat venActivityCellHeight;//相关活动cell的高度
    UIButton *_buttomBtn;
    UIView *backView;
    SDCycleScrollView *_cycleScrollView;
    UIButton *_venStopOrPlayBtn;
    UILabel *_playTimeLabel;
    CGFloat timeRatio;
    NSInteger _commentIndex;
    AnimationBackView *_animationView;
    NSInteger _currentIndex;
    CGFloat _endOffsetHeight;//记录拖动高度
    UIScrollView *_buttonsScrollView;
    UIImageView *img;
    UIButton *playButton;
    UIButton *zoomButton;
    //部分需要的控件
    UILabel *title;
    UIView *wView;
    //三个array
    NSMutableArray *imgsMutableArray;
    NSMutableArray *titlesMutableArray;
    NSMutableArray *linksMutableArray;
    NSMutableArray *createTimeMutableArray;
    NSMutableArray * ceollerArray;
    //点赞
    NSMutableArray *_wantGoUsersArray;//点赞的用户
    NSInteger tagOfVideo;
    DetailNavTitleView *_navTitleView;
    DetailTabBarView *_tabBarView;//底部的工具栏
    UITableViewCell * _webContentCell;
    UITableViewCell * _infoCell;
    UITableViewCell * _audioCell;
    UITableViewCell * _vedioCell;
    UITableViewCell * _contentCell;
    UITableViewCell * _activityCell;
    UITableViewCell * _roomCell;
    LikeTableViewCell * _favCell;
    UITableViewCell * _collectionCell;
    ActivityCommentDetailCell *_commentCell;
    UIImageView * _topImgView;
    FBButton * _backbutton;
    
    int _webViewDidLoadTimes;
}

@property (nonatomic, strong) VenueDetailModel *venDetailModel;
@property (nonatomic, assign) BOOL isCollect;
@property (nonatomic, strong) NSArray *roomVenueArray;//相关活动室数据源
@property (nonatomic, strong) NSArray *venueActivityArray;//相关活动数据源
@property (nonatomic, strong) NSMutableArray *venueCommentArray;//场馆评论数据源
@property (nonatomic, assign) CGFloat contentHeight;//详情内容的高度
@property (nonatomic, strong) AVPlayer *videoPlayer;//播放器
@property (nonatomic) AVPlayerItem *item;
@property (nonatomic, assign) CGFloat videoDuraion;//总时间
@property (nonatomic, assign) CGFloat currentTime;//当前播放时间
@property (nonatomic, strong)id timeObserver;
@property (nonatomic, assign) BOOL isPlayer;
@property (nonatomic, assign) BOOL isFistVideoUrl;
@property (assign, nonatomic) BOOL isEnterLogin;
@property (nonatomic, assign) BOOL isFistData;
//视频
@property (nonatomic,strong) UIView *baseView;
@property (nonatomic,strong) NSArray *VideosArray;
@property(nonatomic,strong)KrVideoPlayerController * videoController;
@end

@implementation VenueDetailViewController


- (void)dealloc
{
    _webContentCell = nil;
    _infoCell = nil;
    _audioCell = nil;
    _vedioCell = nil;
    _contentCell = nil;
    _activityCell = nil;
    _roomCell = nil;
    _favCell = nil;
    _collectionCell = nil;
    _commentCell = nil;
    _backbutton = nil;
    [self removeTimeObserver];
    _timeObserver = nil;
    [self.item removeObserver:self forKeyPath:@"status"];
    [self.videoPlayer removeTimeObserver:_timeObserver];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.isEnterLogin) {
        
        [AppProtocol getVenueDetailWithVenueId:_venueId UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
            if (responseCode == HttpResponseSuccess) {
                _venDetailModel = [responseObject firstObject];
                if (_venDetailModel.venueIsCollect && [UserService sharedService].userIsLogin) {
                    _isCollect = YES;
                    [_tabBarView setButtonStatusWithIndex:2 title:@"" selected:YES];
                }else {
                    _isCollect = NO;
                }
            }
        }];
    }
    self.navigationController.navigationBarHidden = YES;
    
    if (_screenshotImages.count)
    {
        [ToolClass animationWithTopImage:_screenshotImages[0] bottomImage:_screenshotImages[1] headOffset:HEIGHT_TOPIMAGE isTogether:NO completion:^(BOOL finished) {
            
        }];
        _screenshotImages = nil;
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [LogService updateLogKey:_venDetailModel.venueId  addr:[NSString stringWithFormat:@"%p",self]];
    [super viewWillDisappear:animated];
    [self.videoController  dismiss];
    [_videoPlayer pause];
    [_venStopOrPlayBtn setBackgroundImage:IMG(@"icon_pause_audio") forState:UIControlStateNormal];
    [_videoPlayer cancelPendingPrerolls];
    self.navigationController.navigationBarHidden = NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    _commentIndex = 0;
    _webViewDidLoadTimes = 0;
    _isFistVideoUrl = YES;
    _videoPlayer = [[AVPlayer alloc] init];
    _venueCommentArray = [[NSMutableArray alloc] init];
    _wantGoUsersArray = [NSMutableArray new];
    _topImgView = [UIImageView new];
    self.VideosArray = @[];
    imgsMutableArray = [[NSMutableArray alloc]init];
    titlesMutableArray = [[NSMutableArray alloc]init];
    linksMutableArray = [[NSMutableArray alloc]init];
    createTimeMutableArray = [[NSMutableArray alloc]init];
    tagOfVideo = 0;
    _isPlayer = NO;
    
    [self initVenueDetailView];
    [self MJRefreshData];
    _isFistData = YES;
    
    //    [self loadRoomVenueData];
    //    [self loadVenueActivityData];
    //    [self loadVenueCommentData];
    
    
    _animationView = [[AnimationBackView alloc] initAnimationWithFrame:CGRectMake(0, 0, 100, 80)];
    [_animationView beginAnimationView];
    [self.view addSubview:_animationView];
    _animationView.center = CGPointMake(self.view.center.x, kScreenHeight/2-40);
    _detailTableView.footer.hidden = NO;
    
    [self loadVenueDetailiData];
    
    [self initBackButton];
}


#pragma mark -  加载数据

//场馆详情
-(void)loadVenueDetailiData
{
    WS(weakSelf);
    [AppProtocol getVenueDetailWithVenueId:_venueId UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
         
         if (responseCode == HttpResponseSuccess) {
             [weakSelf initTabBarView];
             _animationView.isLoadAnimation = YES;
             _detailTableView.hidden = NO;
             _detailTableView.height = kScreenHeight-_tabBarView.height;
             _tabBarView.hidden = NO;
             
             _venDetailModel = [responseObject firstObject];
             
             weakSelf.VideosArray = responseObject[1];
             FBLOG(@"self.VideosArray:%@",self.VideosArray);
             
             [weakSelf dealArray];
             [_detailTableView reloadData];
             [weakSelf handleSomethingAfterRequestDetailData];
             
         }
         else
         {
             [_animationView shutTimer];
    
             if (weakSelf.venDetailModel) {
                 [SVProgressHUD showErrorWithStatus:responseObject];
             } else {
                 [_animationView setAnimationLabelTextString:responseObject];
             }
         }
         
     }];
}

// 加载藏品列表数据
-(void)loadCeollertData
{
//    [SVProgressHUD showWithStatus:@"正在加载中..."];
    
    [AppProtocol getAntiqueListWithVenueId:_venueId pageIndex:0 pageNum:25 cacheMode:CACHE_MODE_REALTIME UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        
        if (responseCode == HttpResponseSuccess) {
            _animationView.isLoadAnimation = YES;
            ceollerArray = [NSMutableArray arrayWithArray:responseObject[0]];
            [_detailTableView reloadData];
        }
    }];
}

//加载相关活动室的数据
-(void)loadRoomVenueData
{
    [AppProtocol getPlayroomListWithVenueId:_venueId pageIndex:0 pageNum:4 cacheMode:CACHE_MODE_REALTIME UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
    // [self loadVenueActivityData];
        if (responseCode == HttpResponseSuccess) {
            _venDetailModel.totalNumOfPlayRoom = (long)[responseObject[0] longLongValue];
            _roomVenueArray = responseObject[1];
            [_detailTableView reloadData];
        }
    }];
}

//加载相关活动的数据
-(void)loadVenueActivityData
{
    [AppProtocol getVenueRelatedActivityListWithVenueId:_venueId pageIndex:0 pageNum:4 cacheMode:CACHE_MODE_REALTIME UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        //[self loadVenueCommentData];
        if (responseCode == HttpResponseSuccess) {
            _venDetailModel.totalNumOfRelatedActivity = (long)[responseObject[0] longLongValue];
            _venueActivityArray = responseObject[1];
            
            [_detailTableView reloadData];
        }
    }];
}

//评论数据
-(void)loadVenueCommentData {
    
    NSInteger pageIndex = 0;
    if (_commentIndex > 0) {
        pageIndex = _venueCommentArray.count;
    }
    
    [AppProtocol getCommentListOfDetailPageWithDataType:DataTypeVenue modelId:_venueId pageIndex:pageIndex pageNum:kRefreshCount cacheMode:CACHE_MODE_REALTIME UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        [_detailTableView.footer endRefreshing];
        if (responseCode == HttpResponseSuccess) {
            
            if (_commentIndex == 0) {
                [_venueCommentArray removeAllObjects];
                _commentIndex = 1;
            }
            
            NSArray *objecctArr = (NSArray *)responseObject[1];
            
            [_venueCommentArray addObjectsFromArray:objecctArr];
            _venDetailModel.totalNumOfComment = MAX(_venueCommentArray.count, [responseObject[0] integerValue]);
            
            if (_venueCommentArray.count && objecctArr.count == 0) {
                [SVProgressHUD showInfoWithStatus:@"没有更多的评论了"];
                return;
            }
            
            [_detailTableView reloadData];
        }
    }];
}


//收藏请求
- (void)userCollectRequestWithIsCancel:(BOOL)isCancel
{
    if ([self userCanOperateAfterLogin] && ![ToolClass showForbiddenNotice]) {
        
        WS(weakSelf);
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
        [SVProgressHUD setBackgroundColor:ColorFromHex(@"eeeeee")];
        if (isCancel) { [SVProgressHUD showWithStatus:@"正在为您取消收藏..."];  }
        
        [AppProtocol userCollectOperationWithDataType:DataTypeVenue
                                             isCancel:isCancel
                                              modelId:_venueId
                                           UsingBlock:^(HttpResponseCode responseCode, id responseObject)
         {
             [SVProgressHUD showProgress:2.0];
             if (responseCode == HttpResponseSuccess) {
                 if (isCancel) {
                     [SVProgressHUD showSuccessWithStatus:@"取消收藏成功！"];
                 }else {
                     [SVProgressHUD showSuccessWithStatus:@"收藏成功！"];
                 }
                 
                 if (weakSelf.collectRefreshBlock) { // 返回到我的收藏列表时需要刷新
                     weakSelf.collectRefreshBlock();
                 }
                 [_tabBarView setButtonStatusWithIndex:2 title:@"" selected: !isCancel];
             }else {
                 if ([responseObject isKindOfClass:[NSString class]]) {
                     [SVProgressHUD showInfoWithStatus:responseObject];
                 }
             }
             [SVProgressHUD setDefaultStyle:SVProgressHUDStyleLight];
         }];
    }
}

//获取点赞列表（我想去）
- (void)startRequestWantGoUserData
{
    int rowNum;
    [ToolClass getElementWidthWithMinWidth:32 elementSpacing:4 containerWidth:kScreenWidth-20 elementNum:&rowNum];
    
    [AppProtocol getUserWantgoListWithType:DataTypeVenue modelId:_venueId pageIndex:0 pageNum:rowNum UsingBlock:^(HttpResponseCode responseCode, id responseObject)
     {
         if (responseCode == HttpResponseSuccess) {
             _venDetailModel.totalNumOfLike = [responseObject[0] integerValue];
             _wantGoUsersArray = [NSMutableArray arrayWithArray:responseObject[1]];
             [_detailTableView reloadData];
         }
     }];
}

//用户点赞请求
- (void)wantGoUserRequestWithIsCancel:(BOOL)isCancel
{
    if ([self userCanOperateAfterLogin] && ![ToolClass showForbiddenNotice]) {
        
        [AppProtocol userLikeOperationWithType:DataTypeVenue isCancel:isCancel modelId:_venueId UsingBlock:^(HttpResponseCode responseCode, id responseObject)
         {
             if (responseCode == HttpResponseSuccess) {
                 if (isCancel) {
                     //取消点赞
                     [_tabBarView setButtonStatusWithIndex:1 title:@"" selected:NO];
                     
                     NSString *userId = [UserService sharedService].userId;
                     NSInteger index = -1;
                     
                     for (int i = 0; i < _wantGoUsersArray.count; i++) {
                         Registration *wantGoUserModel = _wantGoUsersArray[i];
                         if ([wantGoUserModel.userId isEqualToString:userId]) {
                             index = i;
                             break;
                         }
                     }
                     if (index > -1) {
                         [_wantGoUsersArray removeObjectAtIndex:index];
                     }
                     _venDetailModel.totalNumOfLike -= 1;
                     if (_venDetailModel.totalNumOfLike < 0) {
                         _venDetailModel.totalNumOfLike = 0;
                     }
                 }
                 else
                 {
                     User *user = [UserService sharedService].user;
                     //添加点赞
                     Registration *wantGoUserModel = [[Registration alloc] init];
                     wantGoUserModel.userId = user.userId;
                     wantGoUserModel.userName = user.userNameFull;
                     wantGoUserModel.userSex = user.userSex;
                     wantGoUserModel.userHeadImgUrl = user.userHeadImgUrl;
                     [_wantGoUsersArray insertObject:wantGoUserModel atIndex:0];
                     _venDetailModel.totalNumOfLike += 1;
                 }
                 
                 [_tabBarView setButtonStatusWithIndex:1 title:@"" selected: !isCancel ];
                 [_detailTableView reloadData];
                 
             }else{
                 if ([responseObject isKindOfClass:[NSString class]]) {
                     [SVProgressHUD showInfoWithStatus:responseObject];
                 }
             }
         }];
    }
}

//浏览量
- (void)startRequestVenueScanCount
{
    [AppProtocol getScanCountWithDataType:DataTypeVenue modelId:_venueId UsingBlock:^(HttpResponseCode responseCode, id responseObject)
     {
         if (responseCode == HttpResponseSuccess){
             _venDetailModel.totalNumOfScan = [responseObject integerValue];
             //点赞区
             [_detailTableView reloadSections:[NSIndexSet indexSetWithIndex:7] withRowAnimation:UITableViewRowAnimationNone];
         }
     }];
}

//加载音频数据
- (void)loadMusicData
{
    //    NSString *urlString = @"http://192.168.5.212/admin/45/201511/Audio/Audio76f296f1110f4dbea4fe9199bfc9c244.mp3";
    NSString *urlString  = _venDetailModel.venueVoiceUrl;
    NSURL *url = [NSURL URLWithString:urlString];
    
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:url options:nil];
    NSArray *requesteKeys = @[@"playable"];
    
    [asset loadValuesAsynchronouslyForKeys:requesteKeys completionHandler:^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self prepareToPlayAsset:asset withKeys:requesteKeys];
        });
        
    }];
}


- (void)dealArray
{
    for (Video *selected in _VideosArray) {
        [imgsMutableArray addObject:selected.videoImgUrl];
        [titlesMutableArray addObject:selected.videoTitle];
        [linksMutableArray addObject:selected.videoLink];
        [createTimeMutableArray addObject:selected.videoCreateTime];
    }
}

- (void)handleSomethingAfterRequestDetailData
{
    if (_isFistData == YES) {
        _isFistData = NO;
        [self loadRoomVenueData];
        [self loadVenueActivityData];
        [self loadVenueCommentData];
        [self startRequestWantGoUserData];
        [self loadCeollertData];
        [self startRequestVenueScanCount];
    }
    
    //导航条
    if (_navTitleView == nil) {
        _navTitleView = [[DetailNavTitleView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, HEIGHT_TOP_BAR) navTitle:_venDetailModel.venueName];
        [self.view addSubview:_navTitleView];
    }
    
    //点赞
    if (_venDetailModel.venueIsWant) {
        [_tabBarView setButtonStatusWithIndex:1 title:@"" selected:YES];
    }
    //收藏
    if (_venDetailModel.venueIsCollect) {
        [_tabBarView setButtonStatusWithIndex:2 title:@"" selected:YES];
    }
}


#pragma mark -  加载视图

- (void)initBackButton
{
    WS(weakSelf);
    //返回按钮
    _backbutton = [[FBButton alloc] initWithImage:CGRectMake(0, HEIGHT_STATUS_BAR-6, 62, 62) bgcolor:[UIColor clearColor] img:nil clickEvent:^(FBButton *owner) {
        NSArray *vcArray = self.navigationController.viewControllers;
        if (vcArray.count > 1)
        {
            if ([vcArray[vcArray.count-2] isKindOfClass:NSClassFromString(@"PersonalCenterCommentViewController")] )
            {
                PersonalCenterCommentViewController *vc = vcArray[vcArray.count-2];
                vc.isNeedRefresh = YES;
            }
        }
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    [self.view  addSubview:_backbutton];
    
    //图片
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 38, 38)];
    imgView.radius = imgView.height*0.5;
    imgView.image = IMG(kReturnButtonImageName);
    imgView.backgroundColor = [UIColor colorWithWhite:.5 alpha:.5];
    imgView.contentMode = UIViewContentModeCenter;
    [_backbutton addSubview:imgView];
    imgView.center = CGPointMake(_backbutton.width*0.5, _backbutton.height*0.5);
}


//底部的工具栏
- (void)initTabBarView
{
    if (_tabBarView) {
        [_tabBarView removeFromSuperview];
        _tabBarView = nil;
    }
    
    __weak typeof(self) weakSelf = self;
    _tabBarView = [[DetailTabBarView alloc] initWithFrame:CGRectMake(0, kScreenHeight-50, kScreenWidth, 50) prompt:nil];
    _tabBarView.hidden = YES;
    _tabBarView.callBackBlock = ^(UIButton *sender, NSInteger index, BOOL isSelected){
        switch (index)
        {
            case 0://评论
            {
                [weakSelf enterCommitCommentVC];
            }
                break;
            case 1://点赞
            {
                if(sender.selected){
                    [weakSelf wantGoUserRequestWithIsCancel:YES];//取消点赞
                }else{
                    [weakSelf wantGoUserRequestWithIsCancel:NO];//添加点赞
                }
            }
                break;
            case 2://收藏
            {
                if (sender.selected) {//已经收藏
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
            case 4://电话咨询按钮
            {
                [weakSelf callPhone];
            }
                break;
                
            default:
                break;
        }
    };
    [_tabBarView setButtonStatusWithIndex:4 title:@"咨询" selected:YES];
    [self.view addSubview:_tabBarView];
}


-(void)initVenueDetailView
{
    _detailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-HEIGHT_HOME_INDICATOR) style:UITableViewStyleGrouped];
    _detailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _detailTableView.hidden = YES;
    _detailTableView.delegate = self;
    _detailTableView.dataSource = self;
    _detailTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50+HEIGHT_HOME_INDICATOR)];
    
    _detailTableView.sectionHeaderHeight = 0;
    _detailTableView.sectionFooterHeight = 0;
    [self.view addSubview:_detailTableView];
    
    [UIToolClass setupDontAutoAdjustContentInsets:_detailTableView forController:self];
}


//加载更多评论
-(void)MJRefreshData
{
    WS(weakSelf);
    WEAK_VIEW(_detailTableView);
    
    _detailTableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (_venDetailModel) {
            //            _commentIndex +=10;
            [weakSelf loadVenueCommentData];
        }else{
            [weakView.footer endRefreshing];
        }
    }];
}


#pragma -mark UITableViewDataSoure
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 9;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0://场馆信息
        {
            return 1;
        }
        case 1://相关活动
        {
            return (NSInteger)[self getValueByDefautlValue:_venueActivityArray defaultValue:1];
        }
        case 2://语音导览
        {
            return (NSInteger)[self getValueByDefautlValue:_venDetailModel.venueVoiceUrl defaultValue:1];
        }
        case 3://视频
        {
            return (NSInteger)[self getValueByDefautlValue:self.VideosArray defaultValue:1];
        }
        case 4://详情内容
        {
            return (NSInteger)[self getValueByDefautlValue:_venDetailModel.venueMemo defaultValue:1];
        }
        case 5://相关活动室
        {
            return (NSInteger)[self getValueByDefautlValue:_roomVenueArray defaultValue:1];
        }
        case 6://藏品
        {
            return (NSInteger)[self getValueByDefautlValue:ceollerArray defaultValue:1];
        }
        case 7://赞人数
        {
            return _wantGoUsersArray.count > 0 ? 1 : 0;
        }
        case 8://评论
        {
            if (_venueCommentArray.count > 0) {
                return _venueCommentArray.count+1;
            }else{
                return 0;
            }
        }
    }
    return 0;
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0://场馆信息
        {
            if(_infoCell == nil)
            {
                _infoCell = [self getDefaultCell];
                
            }
            if (_infoCell.contentView.subviews.count == 0)
            {
                [self loadInfoCell:_infoCell];
            }
            return _infoCell;
        }
        case 1://场馆活动
        {
            if(_activityCell == nil)
            {
                _activityCell = [self getDefaultCell];
                [self loadActivityCell:_activityCell];
            }
            return _activityCell;
        }
        case 2://音频
        {
            if(_audioCell == nil)
            {
                _audioCell = [self getDefaultCell];
                [self loadAudioCell:_audioCell];
            }
            return _audioCell;
        }
        case 3://相关视频
        {
            if(_vedioCell == nil)
            {
                _vedioCell = [self getDefaultCell];
                [self loadVideoCell:_vedioCell];
            }
            return _vedioCell;
        }
        case 4://详情内容
        {
            if (_webContentCell == nil)
            {
                _webContentCell = [self getDefaultCell];
                [self loadContentCell:_webContentCell];
            }
            
            if(_venDetailModel.venueMemo.length > 0 && _webViewDidLoadTimes < 1) {
                _webViewDidLoadTimes = 1;
                
                [detailWebView loadHTMLString:_venDetailModel.venueMemo baseURL:nil];
                [detailWebView request];
            }
            
            if (_venDetailModel.venueMemo.length) {
                UIView  * lineProgress = [_webContentCell viewWithTag:VIEWTAG_LINEPROGRESS];
                if(_contentHeight < 2)
                {
                    static dispatch_once_t onceToken;
                    dispatch_once(&onceToken, ^{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [UIView animateWithDuration:5 animations:^{
                                lineProgress.width = (WIDTH_SCREEN-30)/2;
                            }];
                        });
                    });
                }else{
                    UIView  * lineProgress = [_webContentCell viewWithTag:VIEWTAG_LINEPROGRESS];
                    [lineProgress.layer removeAllAnimations];
                    [UIView animateWithDuration:.5f animations:^{
                        
                        lineProgress.width = WIDTH_SCREEN - WIDTH_LEFT_SPAN * 2;
                        
                    } completion:^(BOOL finished) {
                        [lineProgress removeFromSuperview];
                    }];
                }
            }
            
            [detailWebView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(_contentHeight));
            }];
            
            FBButton * button = [_webContentCell viewWithTag:19854];
            button.hidden = YES;
            return _webContentCell;
        }
        case 5://相关活动室
        {
            if(_roomCell == nil)
            {
                _roomCell = [self getDefaultCell];
                [self loadRoomCell:_roomCell];
            }
            return _roomCell;
        }
        case 6://藏品
        {
            if(_collectionCell == nil)
            {
                _collectionCell = [self getDefaultCell];
                [self loadCollectionCell:_collectionCell];
            }
            return _collectionCell;
        }
        case 7://赞人数
        {
            _favCell = [[LikeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId_LikeCell];
            [_favCell setLikeCount:_venDetailModel.totalNumOfLike scanCount:_venDetailModel.totalNumOfScan];
            [_favCell setModelArray:_wantGoUsersArray];
            return _favCell;
        }
        case 8://评论
        {
            if (_venueCommentArray.count > 0)
            {
                if (indexPath.row > 0)
                {
                    _commentCell = [[ActivityCommentDetailCell alloc] init];
                    CommentModel *model = _venueCommentArray[indexPath.row-1];
                    [_commentCell setCommmentModel:model forIndexPath:indexPath];
                    [_commentCell setLineViewHidden:(indexPath.row == _venueCommentArray.count)];
                    return _commentCell;
                }else{
                    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TitleCell"];
                    if (![cell.contentView viewWithTag:1])
                    {
                        //标题
                        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth-20, 42)];
                        titleLabel.tag = 1;
                        [cell.contentView addSubview:titleLabel];
                        
                        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(10, 42-0.5, kScreenWidth-20, 0.5)];
                        lineView.backgroundColor = kBgColor;
                        [cell.contentView addSubview:lineView];
                    }
                    UILabel *titleLabel  = [cell.contentView viewWithTag:1];
                    
                    NSString *countStr = [NSString stringWithFormat:@"%ld",_venDetailModel.totalNumOfComment];
                    NSString *titleStr = [NSString stringWithFormat:@"共 %@ 条评论",countStr];
                    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:titleStr attributes:@{NSFontAttributeName:FONT(14), NSForegroundColorAttributeName:kDeepLabelColor}];
                    [attributedString addAttribute:NSForegroundColorAttributeName value:kDarkRedColor range:NSMakeRange(2, countStr.length)];
                    titleLabel.attributedText = attributedString;
                    
                    return cell;
                }
            }
        }
    }
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    return cell;
}

#pragma mark- cell initial

-(UITableViewCell * )getDefaultCell
{
    UITableViewCell * cell =  [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = COLOR_IWHITE;
    return cell;
}

-(void)loadFavCell:(UITableViewCell * )cell
{
    
}

-(void)loadCollectionCell:(UITableViewCell * )cell
{
    cell.frame = CGRectZero;
    if(ceollerArray.count > 0)
    {
        __weak UITableViewCell * weakcell = cell;
        FBLabel * titleLabel = [[FBLabel alloc] initWithStyle:CGRectZero font:FontYT(16) fcolor:ColorFromHex(@"666666") text:@"藏品"];
        [cell.contentView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(@WIDTH_LEFT_SPAN);
            make.top.equalTo(@15);
        }];
        
        WS(weakSelf);
        
        if(ceollerArray.count > 3)
        {
            FBButton * button = [[FBButton alloc] initWithImage:CGRectZero bgcolor:COLOR_CLEAR img:IMG(@"arrow_right") clickEvent:^(FBButton *owner) {
                VenueAntiqueViewController *venCeollertVC = [[VenueAntiqueViewController alloc] init];
                venCeollertVC.venueId = _venDetailModel.venueId;
                [weakSelf.navigationController pushViewController:venCeollertVC animated:YES];
            }];
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            [cell.contentView addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.size.mas_equalTo(CGSizeMake(100, 30));
                make.right.equalTo(@-WIDTH_LEFT_SPAN);
                make.centerY.equalTo(titleLabel);
            }];
            
            NSString * str = [NSString stringWithFormat:@"共%lu个藏品",(unsigned long)ceollerArray.count];
            NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithString:str];
            [attrStr setAttributes:@{NSForegroundColorAttributeName:kLightLabelColor} range:NSMakeRange(0, str.length)];
            [attrStr setAttributes:@{NSForegroundColorAttributeName:kOrangeYellowColor} range:NSMakeRange(1, str.length - 4)];
            UILabel * countLabel = [UILabel new];
            countLabel.font = FONT_MIDDLE;
            countLabel.attributedText = attrStr;
            countLabel.textAlignment = NSTextAlignmentRight;
            [cell.contentView addSubview:countLabel];
            
            [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.right.equalTo(@-25);
                make.centerY.equalTo(titleLabel);
                make.width.equalTo(@100);
            }];
            
        }
        MYMaskView *line = [MYMaskView maskViewWithBgColor:COLOR_GRAY_LINE frame:CGRectZero radius:0];
        [cell.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(@WIDTH_LEFT_SPAN);
            make.right.mas_equalTo(weakcell.mas_right).offset(-WIDTH_LEFT_SPAN);
            make.height.equalTo(@(kLineThick));
            make.top.equalTo(@42);
        }];
        CGFloat btnWidth = (WIDTH_SCREEN-20-2*5)/3.0;
        CGFloat imgHeight = btnWidth*0.667;
        for (int i=0; i<3 && i<ceollerArray.count; i++)
        {
            AntiqueModel * model = ceollerArray[i];
            FBButton * button = [[FBButton alloc] initWithImage:MRECT(11+(btnWidth + 5.5)*i, 60, btnWidth, imgHeight+30) bgcolor:COLOR_CLEAR img:nil clickEvent:^(FBButton *owner) {
                AntiqueDetailViewController *ceollerDetailVC = [[AntiqueDetailViewController alloc] init];
                ceollerDetailVC.antiqueId = model.antiqueId;
                [weakSelf.navigationController pushViewController:ceollerDetailVC animated:YES];
            }];
            button.layer.borderColor = COLOR_GRAY_LINE.CGColor;
            button.layer.borderWidth = .5f;
            [cell.contentView addSubview:button];
            
            
            UIImageView * imgv = [[UIImageView alloc] initWithFrame:MRECT(0, 0, btnWidth, imgHeight)];
            [imgv sd_setImageWithURL:[NSURL URLWithString:model.antiqueImageUrl]];
            [button addSubview:imgv];
            
            
            UILabel * label = [[UILabel alloc] initWithFrame:MRECT(5,imgv.maxY, btnWidth-10, 30)];
            label.text = model.antiqueName;
            label.textAlignment = NSTextAlignmentCenter;
            label.font = FONT(11);
            label.textColor = kDeepLabelColor;
            [button addSubview:label];
        }
        
        cell.frame = MRECT(0, 0, WIDTH_SCREEN, 60+imgHeight+30+22);
    }
}

-(void)loadRoomCell:(UITableViewCell * )cell
{
    if(_roomVenueArray.count > 0)
    {
        __weak UITableViewCell * weakCell = cell;
        FBLabel * titleLabel = [[FBLabel alloc] initWithStyle:CGRectZero font:FontYT(16) fcolor:ColorFromHex(@"666666") text:@"活动室"];
        [cell.contentView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(@WIDTH_LEFT_SPAN);
            make.top.equalTo(@15);
        }];
        
        // 共n个活动室
        if (_roomVenueArray.count > 3)
        {
            FBButton * button = [[FBButton alloc] initWithImage:CGRectZero bgcolor:COLOR_CLEAR img:IMG(@"arrow_right") clickEvent:^(FBButton *owner) {
                VenueRoomListViewController *roomVenViewController = [[VenueRoomListViewController alloc] init];
                roomVenViewController.venueId = _venDetailModel.venueId;
                [self.navigationController pushViewController:roomVenViewController animated:YES];
            }];
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            [cell.contentView addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.size.mas_equalTo(CGSizeMake(100, 30));
                make.right.equalTo(@-WIDTH_LEFT_SPAN);
                make.centerY.equalTo(titleLabel);
            }];
            
            NSString * str = [NSString stringWithFormat:@"共%lu个活动室",(unsigned long)_venDetailModel.totalNumOfPlayRoom];
            NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithString:str];
            [attrStr setAttributes:@{NSForegroundColorAttributeName:kLightLabelColor} range:NSMakeRange(0, str.length)];
            [attrStr setAttributes:@{NSForegroundColorAttributeName:kOrangeYellowColor} range:NSMakeRange(1, str.length - 5)];
            UILabel * countLabel = [UILabel new];
            countLabel.font = FONT_MIDDLE;
            countLabel.attributedText = attrStr;
            countLabel.textAlignment = NSTextAlignmentRight;
            [cell.contentView addSubview:countLabel];
            
            [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.right.equalTo(weakCell.mas_right).offset(-25);
                make.centerY.equalTo(titleLabel);
                make.width.equalTo(@100);
            }];
            
        }
        MYMaskView *line = [MYMaskView maskViewWithBgColor:COLOR_GRAY_LINE frame:CGRectZero radius:0];
        [cell.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(@WIDTH_LEFT_SPAN);
            make.right.mas_equalTo(weakCell.mas_right).offset(-WIDTH_LEFT_SPAN);
            make.height.equalTo(@(kLineThick));
            make.top.equalTo(@42);
        }];
        __weak FBButton * preView = nil;
        int imgWidth =  WIDTH_SCREEN*0.30;
        int imgHeight = WIDTH_SCREEN*0.24;
        WS(weakSelf);
        for (int i=0; i<3 && i<_roomVenueArray.count; i++)
        {
            ActivityRoomModel * roomModel = _roomVenueArray[i];
            FBButton * containerView = [[FBButton alloc] initWithImage:CGRectZero bgcolor:COLOR_IWHITE img:nil clickEvent:^(FBButton *owner) {
                
                ActivityRoomModel *_roomModel = _roomVenueArray[i];
                ActivityRoomDetailViewController *roomVenDetailViewController = [[ActivityRoomDetailViewController alloc] init];
                roomVenDetailViewController.roomId = _roomModel.roomId;
                roomVenDetailViewController.roomName = _roomModel.roomName;
                [weakSelf.navigationController pushViewController:roomVenDetailViewController animated:YES];
            }];
            containerView.layer.borderColor = ColorFromHex(@"DFDFDF").CGColor;
            containerView.layer.borderWidth = kLineThick;
            containerView.tag = 100;
            containerView.clipsToBounds = YES;
            [cell.contentView addSubview:containerView];
            [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.equalTo(@WIDTH_LEFT_SPAN);
                make.right.mas_equalTo(weakCell.mas_right).offset(-WIDTH_LEFT_SPAN);
                make.height.equalTo(@(imgHeight));
                if (preView == nil)
                {
                    make.top.equalTo(@55);
                }
                else
                {
                    make.top.equalTo(preView.mas_bottom).offset(9);
                }
            }];
            
            preView = containerView;
            
            UIImageView  * imgView = [[UIImageView alloc] initWithFrame:MRECT(-0.5, -0.5, imgWidth, imgHeight+1)];
            [containerView addSubview:imgView];
            UIImage *placeImg = [UIToolClass getPlaceholderWithViewSize:imgView.viewSize centerSize:CGSizeMake(20, 20) isBorder:NO];
            [imgView sd_setImageWithURL:[NSURL URLWithString:JointedImageURL(roomModel.roomPicUrl, kImageSize_150_100)] placeholderImage:placeImg];
            
            FBButton * bookButton = nil;
            if (roomModel.roomIsReserve > 0 )
            {//可以预订
                bookButton = [[FBButton alloc] initWithText:CGRectZero font:FONT_BIG fcolor:COLOR_IWHITE bgcolor:kThemeDeepColor text:@"预订" clickEvent:^(FBButton *owner) {
                }];
                bookButton.userInteractionEnabled = NO;
                [containerView addSubview:bookButton];
                [bookButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(@0);
                    make.top.equalTo(@0);
                    make.bottom.equalTo(@0);
                    make.width.equalTo(@55);
                }];
            }
            CGFloat fontHeight = 0;
            //标题
            fontHeight = [UIToolClass fontHeight:FontYT(16)];
            FBLabel * actNameLabel = [[FBLabel alloc] initWithStyle:CGRectZero font:FontYT(16) fcolor:kDeepLabelColor text:roomModel.roomName];
            [containerView addSubview:actNameLabel];
            [actNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.mas_equalTo(imgView.mas_right).offset(10);
                make.top.equalTo(imgView.mas_top).offset(6);
                make.height.equalTo(@(fontHeight));
                
                if (bookButton){
                    make.right.equalTo(bookButton.mas_left).offset(-5);
                }else{
                    make.right.equalTo(@(-10));
                }
            }];
            
            //面积和客容量
            fontHeight = [UIToolClass fontHeight:FontYT(14)];
            FBLabel * actLabelLabel = [[FBLabel alloc] initWithStyle:CGRectZero font:FontYT(14) fcolor:kLightLabelColor text:[NSString stringWithFormat:@"面积%@平米，容纳%@人",roomModel.roomArea,roomModel.roomCapacity]];
            [containerView addSubview:actLabelLabel];
            actLabelLabel.numberOfLines = 1;
            [actLabelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.height.equalTo(@(fontHeight));
                make.left.mas_equalTo(imgView.mas_right).offset(10);
                make.top.equalTo(actNameLabel.mas_bottom).offset(7);
                make.right.equalTo(actNameLabel.mas_right).offset(0);
            }];
            
            //价格
            FBLabel *  priceLabel = [[FBLabel alloc] initWithStyle:CGRectZero font:FontYT(14) fcolor:kDeepLabelColor text:(roomModel.roomIsFree == 1)?@"免费":@"收费"];
            [containerView addSubview:priceLabel];
            [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(fontHeight));
                make.left.mas_equalTo(imgView.mas_right).offset(10);
                make.top.equalTo(actLabelLabel.mas_bottom).offset(13);
                make.right.equalTo(actNameLabel.mas_right).offset(0);
            }];
        }
//        [preView layoutIfNeeded]; 使用这条语句，在iOS 10 5c设备上，会导致高度计算不正确
        [cell.contentView layoutIfNeeded];
        
        cell.frame = MRECT(0, 0, WIDTH_SCREEN, preView.maxY + 25);
    }
}

-(void)loadContentCell:(UITableViewCell * )cell
{
    __weak UITableViewCell * weakCell = cell;
    if (_venDetailModel.venueMemo.length > 0)
    {
        detailWebView = [[FBWebView alloc] initWithFrame:MRECT(0, 0, WIDTH_SCREEN, 1)];
        detailWebView.backgroundColor = kDeepLabelColor;
        detailWebView.scrollView.bounces = NO;
        detailWebView.delegate = self;
        detailWebView.tag = 100;
        _contentHeight = 0;
        detailWebView.tag = 0;//0 收缩 1扩展
        
        FBLabel * titleLabel = [[FBLabel alloc] initWithStyle:CGRectZero font:FontYT(16) fcolor:ColorFromHex(@"666666") text:@"场馆详情"];
        [_webContentCell.contentView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(@WIDTH_LEFT_SPAN);
            make.top.equalTo(@15);
        }];
        MYMaskView *line1 = [MYMaskView maskViewWithBgColor:COLOR_GRAY_LINE frame:CGRectZero radius:0];
        [_webContentCell.contentView addSubview:line1];
        [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@WIDTH_LEFT_SPAN);
            make.right.mas_equalTo(weakCell).offset(-WIDTH_LEFT_SPAN);
            make.top.equalTo(@42);
            make.height.equalTo(@(kLineThick));
        }];
        
        
        UIView * lineProgressView = [[UIView alloc] initWithFrame:MRECT(WIDTH_LEFT_SPAN, 41, 0, 1.5)];
        lineProgressView.backgroundColor = kNavigationBarColor;
        [_webContentCell.contentView addSubview:lineProgressView];
        lineProgressView.tag = VIEWTAG_LINEPROGRESS;
        
        [_webContentCell.contentView addSubview:detailWebView];
        
        [detailWebView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(@0);
            make.right.mas_equalTo(weakCell).offset(0);
            make.top.equalTo(@52);
            make.height.equalTo(@0);
        }];
        
        FBButton * button = [[FBButton alloc] initWithImage:CGRectZero bgcolor:COLOR_CLEAR img:IMG(@"icon_arrow_down_gray") clickEvent:^(FBButton *owner) {
            [PopupWebView webViewWithUrl:_venDetailModel.venueMemo navTitle:@"场馆详情"];
        }];
        button.tag = 19854;
        [_webContentCell.contentView addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(@0);
            make.right.mas_equalTo(weakCell).offset(0);
            make.top.equalTo(detailWebView.mas_bottom).offset(5);
            make.height.equalTo(@20);
            
        }];
        
    }
}

-(void)loadVideoCell:(UITableViewCell * )cell
{
    if(true)
    {
        return;
    }
    cell.frame  = CGRectZero;
    if (self.VideosArray.count > 0)
    {
        
        self.baseView=[[UIView alloc]init];
        self.baseView.backgroundColor = [UIColor clearColor];
        self.baseView.frame = CGRectMake(0, 0, kScreenWidth, 430);
        [cell.contentView addSubview:self.baseView];
        
        cell.frame = self.baseView.frame;
        
        title = [[UILabel alloc]init];
        title.frame = CGRectMake(0, 0, kScreenWidth, 40);
        title.backgroundColor = [UIColor whiteColor];
        title.text = [NSString stringWithFormat:@"  %@",titlesMutableArray[tagOfVideo]];
        title.textAlignment = NSTextAlignmentLeft;
        title.font = FontYT(14);
        title.textColor = COLOR_IBLACK;
        [self.baseView addSubview:title];
        
        wView = [[UIView alloc]init];
        wView.frame = CGRectMake(0, CGRectGetMaxY(title.frame), kScreenWidth, 250);
        wView.backgroundColor = [UIColor blackColor];
        [self.baseView addSubview:wView];
        
        img = [[UIImageView alloc]init];
        img.frame = CGRectMake(0, 0, CGRectGetWidth(wView.frame), CGRectGetHeight(wView.frame));
        img.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imgsMutableArray[tagOfVideo]]]];
        [wView addSubview:img];
        
        playButton = [[UIButton alloc]init];
        playButton.frame = CGRectMake(CGRectGetMidX(wView.frame)-50,CGRectGetMidY(wView.frame)-50 , 100, 100);
        [playButton setBackgroundImage:IMG(@"icon_play_video") forState:UIControlStateNormal];
        [playButton addTarget:self action:@selector(playButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.baseView addSubview:playButton];
        
        zoomButton = [[UIButton alloc]init];
        zoomButton.frame = CGRectMake(CGRectGetMaxX(wView.frame)-40, CGRectGetMaxY(wView.frame)-40, 35, 35);
        [zoomButton setBackgroundImage:IMG(@"视频放大") forState:UIControlStateNormal];
        
        
        UILabel *line1 = [[UILabel alloc]init];
        line1.frame = CGRectMake(0, CGRectGetMaxY(wView.frame)+5,kScreenWidth , 1);
        line1.backgroundColor = kLineGrayColor;
        [self.baseView addSubview:line1];
        UIView *XuanJiView = [[UIView alloc]init];
        XuanJiView.frame = CGRectMake(0, CGRectGetMaxY(line1.frame), kScreenWidth, 40);
        XuanJiView.backgroundColor = [UIColor whiteColor];
        [self.baseView addSubview:XuanJiView];
        UIImageView *XuanJiImg = [[UIImageView alloc]init];
        XuanJiImg.frame = CGRectMake(10, 12, 16, 16);
        XuanJiImg.image = IMG(@"选集icon");
        [XuanJiView addSubview:XuanJiImg];
        UILabel *XuanJi = [[UILabel alloc]init];
        XuanJi.frame = CGRectMake(CGRectGetMaxX(XuanJiImg.frame), 0, 50, 40);
        XuanJi.text = @"选集";
        XuanJi.textAlignment = NSTextAlignmentLeft;
        XuanJi.textColor = COLOR_IBLACK;
        XuanJi.font = FontYT(14);
        [XuanJiView addSubview:XuanJi];
        
        [_buttonsScrollView removeFromSuperview];
        if (self.VideosArray.count != 0) {
            _buttonsScrollView = [[UIScrollView alloc]init];
            _buttonsScrollView.frame = CGRectMake(0, CGRectGetMaxY(XuanJiView.frame), kScreenWidth, 70);
            _buttonsScrollView.backgroundColor = [UIColor whiteColor];
            _buttonsScrollView.scrollEnabled = YES;
            _buttonsScrollView.pagingEnabled = NO;
            _buttonsScrollView.contentSize = CGSizeMake(140*self.VideosArray.count, 0);
            _buttonsScrollView.showsHorizontalScrollIndicator = NO;
            _buttonsScrollView.showsVerticalScrollIndicator = NO;
            [self.baseView addSubview:_buttonsScrollView];
            
            for (int i=0; i< self.VideosArray.count ; i++) {
                
                UIButton *button = [[UIButton alloc]init];
                button.frame = CGRectMake(i*140, 0, 140, 70);
                button.layer.borderWidth = 0.5;
                button.layer.borderColor = kLineGrayColor.CGColor;
                button.backgroundColor = [UIColor whiteColor];
                button.tag = i +123;
                [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
                [_buttonsScrollView addSubview:button];
                
                if (i == 0) {
                    button.selected = YES;
                    button.backgroundColor =  kBgColor;
                }
                
                UILabel *titleLabel = [[UILabel alloc]init];
                titleLabel.frame = CGRectMake(0, 0, 140, 45);
                titleLabel.text = [NSString stringWithFormat:@"%@",titlesMutableArray[i]];
                titleLabel.numberOfLines = 0;
                titleLabel.textAlignment = NSTextAlignmentCenter;
                titleLabel.textColor = COLOR_IBLACK;
                titleLabel.font = FontYT(12);
                [button addSubview:titleLabel];
                
                UIImageView *imge = [[UIImageView alloc]init];
                imge.frame = CGRectMake(20, CGRectGetMaxY(titleLabel.frame)+7.5, 10, 10);
                imge.image = IMG(@"播放量");
                [button addSubview:imge];
                
                UILabel *playingTimes = [[UILabel alloc]init];
                playingTimes.frame = CGRectMake(35, CGRectGetMaxY(titleLabel.frame), 95, 25);
                playingTimes.text = [NSString stringWithFormat:@"%@",createTimeMutableArray[tagOfVideo]];
                playingTimes.textAlignment = NSTextAlignmentLeft;
                playingTimes.textColor = [UIColor colorWithRed:74/255.0 green:183/255.0 blue:252/255.0 alpha:1];
                playingTimes.font = [UIFont systemFontOfSize:8];
                [button addSubview:playingTimes];
            }
            
        }
        
        UILabel *bgLabel = [[UILabel alloc]init];
        bgLabel.frame =  CGRectMake(0, CGRectGetMaxY(_buttonsScrollView.frame), kScreenWidth, 13);
        bgLabel.backgroundColor = [UIColor whiteColor];
        [self.baseView addSubview:bgLabel];
        
        UILabel *line = [[UILabel alloc]init];
        line.frame = CGRectMake(0, _baseView.frame.size.height-1, kScreenWidth, 1);
        line.backgroundColor = kLineGrayColor;
        [self.baseView addSubview:line];
    }
    
}

-(void)loadAudioCell:(UITableViewCell * )cell
{
    cell.frame = CGRectZero;
    if (_venDetailModel.venueVoiceUrl.length > 0)
    {
        __weak UITableViewCell * weakCell = cell;
        cell.frame = MRECT(0, 0, WIDTH_SCREEN, 135);
        
        FBLabel * titleLabel = [[FBLabel alloc] initWithStyle:CGRectZero font:FontYT(16) fcolor:ColorFromHex(@"666666") text:@"语音导航"];
        [cell.contentView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(@WIDTH_LEFT_SPAN);
            make.top.equalTo(@15);
        }];
        
        MYMaskView *line = [MYMaskView maskViewWithBgColor:COLOR_GRAY_LINE frame:CGRectZero radius:0];
        [cell.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(@WIDTH_LEFT_SPAN);
            make.right.mas_equalTo(weakCell.mas_right).offset(-WIDTH_LEFT_SPAN);
            make.height.equalTo(@(kLineThick));
            make.top.equalTo(@42);
        }];
        
        
        _venStopOrPlayBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth/2-20, 55, 40, 40)];
        [_venStopOrPlayBtn setBackgroundImage:IMG(@"icon_play_audio") forState:UIControlStateNormal];
        [_venStopOrPlayBtn addTarget:self action:@selector(venStopOrPlayBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:_venStopOrPlayBtn];
        
        
        UIView *progessView = [[UIView alloc] initWithFrame:CGRectMake(WIDTH_LEFT_SPAN, CGRectGetMaxY(_venStopOrPlayBtn.frame)+20, kScreenWidth - WIDTH_LEFT_SPAN * 2, 2)];
        progessView.backgroundColor = kNavigationBarColor;
        [cell.contentView addSubview:progessView];
        
        _playTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_venStopOrPlayBtn.frame)+20, 55, 15)];
        _playTimeLabel.userInteractionEnabled = YES;
        _playTimeLabel.font = [UIFont systemFontOfSize:10];
        _playTimeLabel.textAlignment = NSTextAlignmentCenter;
        _playTimeLabel.textColor = [UIColor lightGrayColor];
        _playTimeLabel.backgroundColor = [UIColor whiteColor];
        _playTimeLabel.layer.borderWidth = 1.0;
        _playTimeLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _playTimeLabel.radius = 7.5;
        [cell.contentView addSubview:_playTimeLabel];
        _playTimeLabel.center = CGPointMake(_playTimeLabel.center.x, progessView.center.y);
        
        UIPanGestureRecognizer *timePan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(playerTimeLabelPan:)];
        [_playTimeLabel addGestureRecognizer:timePan];
        
    }
}

-(void)loadActivityCell:(UITableViewCell * )cell
{
    if(self.venueActivityArray.count > 0)
    {
        __weak UITableViewCell * weakCell = cell;
        FBLabel * titleLabel = [[FBLabel alloc] initWithStyle:CGRectZero font:FontYT(16) fcolor:ColorFromHex(@"666666") text:@"场馆活动"];
        [cell.contentView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(@WIDTH_LEFT_SPAN);
            make.top.equalTo(@15);
        }];
        
        if (self.venueActivityArray.count > 3)
        {
            WS(weakSelf);
            FBButton * button = [[FBButton alloc] initWithImage:CGRectZero bgcolor:COLOR_CLEAR img:IMG(@"arrow_right") clickEvent:^(FBButton *owner) {
                
                VenueRelatedActivityViewController * vc = [VenueRelatedActivityViewController new];
                vc.venueId = weakSelf.venueId;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }];
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            [cell.contentView addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.size.mas_equalTo(CGSizeMake(100, 30));
                make.right.equalTo(@-WIDTH_LEFT_SPAN);
                make.centerY.equalTo(titleLabel);
            }];
            
            NSString * str = [NSString stringWithFormat:@"共%lu个活动",_venDetailModel.totalNumOfRelatedActivity];
            NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithString:str];
            [attrStr setAttributes:@{NSForegroundColorAttributeName:kLightLabelColor} range:NSMakeRange(0, str.length)];
            [attrStr setAttributes:@{NSForegroundColorAttributeName:kOrangeYellowColor} range:NSMakeRange(1, str.length - 4)];
            UILabel * countLabel = [UILabel new];
            countLabel.font = FONT_MIDDLE;
            countLabel.attributedText = attrStr;
            countLabel.textAlignment = NSTextAlignmentRight;
            [cell.contentView addSubview:countLabel];
            
            [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.right.equalTo(weakCell.mas_right).offset(-25);
                make.centerY.equalTo(titleLabel);
                make.width.equalTo(@100);
            }];
            
            
        }
        __weak FBButton * preView = nil;
        for (int i=0; i<3 && i<_venueActivityArray.count; i++)
        {
            ActivityModel * actModel = _venueActivityArray[i];
            FBButton * view = [[FBButton alloc] initWithImage:CGRectZero bgcolor:COLOR_CLEAR img:nil clickEvent:^(FBButton *owner) {
                
                ActivityDetailViewController *activityDetailVC = [[ActivityDetailViewController alloc] init];
                activityDetailVC.activityId = actModel.activityId;
                [self.navigationController pushViewController:activityDetailVC animated:YES];
            }];
            view.tag = 100;
            [cell.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(@0);
                make.size.mas_equalTo(CGSizeMake(WIDTH_SCREEN, 122));
                if (preView == nil)
                {
                    make.top.equalTo(@44);
                }
                else
                {
                    make.top.equalTo(preView.mas_bottom).offset(0);
                }
            }];
            
            preView = view;
            
            MYMaskView *line = [MYMaskView maskViewWithBgColor:COLOR_GRAY_LINE frame:CGRectZero radius:0];
            [view addSubview:line];
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(@WIDTH_LEFT_SPAN);
                make.width.mas_equalTo(@(WIDTH_SCREEN- WIDTH_LEFT_SPAN *2));
                make.height.equalTo(@(kLineThick));
                make.top.equalTo(@0);
            }];
            
            UIImageView  * imgView = [UIImageView new];
            [preView addSubview:imgView];
            [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.equalTo(@WIDTH_LEFT_SPAN);
                make.size.mas_equalTo(CGSizeMake(136, 88));
                make.centerY.equalTo(preView);
            }];
            UIImage *placeImg = [UIToolClass getPlaceholderWithViewSize:CGSizeMake(300, 200) centerSize:CGSizeMake(35, 35) isBorder:YES];
            
            [imgView sd_setImageWithURL:[NSURL URLWithString:JointedImageURL(actModel.activityIconUrl, kImageSize_300_300)] placeholderImage:placeImg];
            
            // 活动名称
            MYSmartLabel *actNameLabel = [MYSmartLabel al_labelWithMaxRow:2 text:actModel.activityName font:FONT_MIDDLE color:kDeepLabelColor lineSpacing:3];
            [view addSubview:actNameLabel];
            [actNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(@(160));
                make.top.equalTo(imgView.mas_top);
                make.width.equalTo(@(kScreenWidth-170));
            }];
            
            FBLabel * actLabelLabel = [[FBLabel alloc] initWithStyle:CGRectZero font:FONT_SMALL fcolor:kThemeDeepColor text:actModel.activityType];
            [cell.contentView addSubview:actLabelLabel];
            [actLabelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.equalTo(@160);
                make.top.equalTo(actNameLabel.mas_bottom).offset(10);
                make.width.equalTo(@(WIDTH_SCREEN - 170));
            }];
            
            FBLabel * actDateLabel = [[FBLabel alloc] initWithStyle:CGRectZero font:FONT_SMALL fcolor:kDeepLabelColor text:actModel.showedActivityDate];
            [cell.contentView addSubview:actDateLabel];
            [actDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.equalTo(@160);
                make.bottom.equalTo(view.mas_bottom).offset(-17);
                make.width.equalTo(@(WIDTH_SCREEN - 170));
            }];
            
            FBLabel * actPriceLabel = [[FBLabel alloc] initWithStyle:CGRectZero font:FONT_MIDDLE fcolor:kDeepLabelColor text:actModel.showedPrice];
            [cell.contentView addSubview:actPriceLabel];
            
            actPriceLabel.textAlignment = NSTextAlignmentRight;
            [actPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.right.equalTo(@-10);
                make.centerY.equalTo(actDateLabel);
                make.width.equalTo(@100);
            }];
            
        }
//        [preView layoutIfNeeded]; 请不要使用这句话(会导致高度计算不正确).
//        [cell.contentView layoutIfNeeded];
        [cell layoutIfNeeded];
        
        cell.frame = MRECT(0, 0, WIDTH_SCREEN, preView.frame.origin.y + 122);
    }
}

-(void)loadInfoCell:(UITableViewCell *)cell
{
    if (_venDetailModel == nil)
    {
        return;
    }
    UIImage *placeImg = [UIToolClass getPlaceholderWithViewSize:CGSizeMake(kScreenWidth, HEIGHT_TOPIMAGE) centerSize:CGSizeMake(25, 25) isBorder:NO];
    
    _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, HEIGHT_TOPIMAGE) delegate:self placeholderImage:placeImg];
    [cell.contentView addSubview:_cycleScrollView];
    _cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleNone;
    
    UIImageView * maskImgView = [[UIImageView alloc] initWithFrame:MRECT(0, 60, WIDTH_SCREEN, HEIGHT_TOPIMAGE - 60)];
    maskImgView.image = IMG(@"蒙板");
    [_cycleScrollView addSubview:maskImgView];
    
    //创建标题和图片URL数组
    NSMutableArray *roomIconArray = [NSMutableArray arrayWithCapacity:0];
    if (_venDetailModel.venueIconUrl.length) {
        [roomIconArray addObject:_venDetailModel.venueIconUrl];
    }
    [roomIconArray addObjectsFromArray:_venDetailModel.roomIconUrls];
    
    for (int i = 0; i < roomIconArray.count; i++) {
        roomIconArray[i] = JointedImageURL(roomIconArray[i], kImageSize_750_500);
    }
    _cycleScrollView.imageURLStringsGroup = roomIconArray;
    if (roomIconArray.count == 1)
    {
        _cycleScrollView.autoScroll = NO;
    }
    
    // 标签与价格
    CGFloat fontHeight = [UIToolClass fontHeight:FontYT(18)]+2;
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-100, _cycleScrollView.height-10-fontHeight, 0, fontHeight)];
    priceLabel.font = FontYT(18);
    priceLabel.textColor = COLOR_IWHITE;
    priceLabel.width = [UIToolClass textWidth:_venDetailModel.showedVenuePrice font:priceLabel.font]+2;
    priceLabel.attributedText = [UIToolClass boldString:_venDetailModel.showedVenuePrice font:FontYT(18)];
    [_cycleScrollView addSubview:priceLabel];
    priceLabel.originalX = kScreenWidth-10-priceLabel.width;
    
    NSDictionary *layoutAttributes = @{MYShowOnlySingleLineAttributeName:@"YES",
                                       MYLabelPaddingAttributeName:@"16",
                                       MYItemHeightAttributeName:@"21",
                                       MYFontAttributeName:FontYT(14),
                                       MYSpacingXAttributeName:@"10",
                                       MYOffsetXAttributeName:@"10",
                                       MYOffsetYAttributeName:StrFromFloat(priceLabel.maxY-21),
                                       MYContainerWidthAttributeName:StrFromFloat(priceLabel.originalX - 10),
                                       };
    NSDictionary *labelAttributes = @{kLabelTextColor:[UIColor whiteColor],
                                      kLabelBgColor:[UIColor clearColor],
                                      kLabelBorderColor:[UIColor whiteColor],
                                      kLabelBorderWidth:@"0.6",
                                      kLabelCornerRadius:@"4",
                                      };
    [ToolClass addSubview:_cycleScrollView titleArray:_venDetailModel.showedVenueTags attributes:layoutAttributes labelAttributes:labelAttributes clearSubviews:NO contentHeight:nil];

    // 场馆标题
    FBLabel  *titleLabel = [[FBLabel alloc] initWithStyle:MRECT(WIDTH_LEFT_SPAN, 260, WIDTH_SCREEN - 30, 0) font:FONT(18) fcolor:kDeepLabelColor text:_venDetailModel.venueName];
    [cell.contentView addSubview:titleLabel];
    
    
    UIImageView * addrImg = [[UIImageView alloc] initWithFrame:MRECT(WIDTH_LEFT_SPAN, 260 + 20 + titleLabel.textHeight , 12, 17)];
    addrImg.image = IMG(@"icon_地址");
    [cell.contentView addSubview:addrImg];
    
    
    UIImageView * arrowImg = [[UIImageView alloc] initWithFrame:MRECT(WIDTH_SCREEN - WIDTH_LEFT_SPAN - 12, 260 + 20 + titleLabel.textHeight , 12, 17)];
    arrowImg.image = IMG(@"arrow_right");
    [cell.contentView addSubview:arrowImg];
    
    
    FBLabel * addrlabel = [[FBLabel alloc] initWithStyle:MRECT(35, 260 + 20 + titleLabel.textHeight,WIDTH_SCREEN-55, 0) font:FONT_MIDDLE fcolor:kDeepLabelColor text:_venDetailModel.venueAddress  linespace:4];
    [cell.contentView addSubview:addrlabel];
    
    
    FBButton * addrButton = [[FBButton alloc] initWithText:addrlabel.frame font:FONT_MIDDLE fcolor:kDeepLabelColor bgcolor:COLOR_CLEAR text:@"" clickEvent:^(FBButton *owner) {
        
        if(_venDetailModel.venueLat > 0 && _venDetailModel.venueLon > 0)
        {
            NearbyLocationViewController *mapVC = [[NearbyLocationViewController alloc] init];
            mapVC.locationCoordinate2D = CLLocationCoordinate2DMake(_venDetailModel.venueLat, _venDetailModel.venueLon);
            mapVC.addressString = _venDetailModel.venueAddress;
            mapVC.type = DataTypeVenue;
            [self.navigationController pushViewController:mapVC animated:YES];
            
        }
        
    }];
    addrButton.animation = NO;
    addrButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    addrButton.titleLabel.lineBreakMode = 0;
    [cell.contentView addSubview:addrButton];
    
    
    
    MYMaskView *line = [MYMaskView maskViewWithBgColor:COLOR_GRAY_LINE frame:CGRectMake(WIDTH_LEFT_SPAN, addrButton.frame.origin.y + addrButton.frame.size.height + 12, WIDTH_SCREEN-WIDTH_LEFT_SPAN*2, kLineThick) radius:0];
    [cell.contentView addSubview:line];
    
    
    
    UIImageView * timeImg = [[UIImageView alloc] initWithFrame:MRECT(WIDTH_LEFT_SPAN, line.frame.origin.y + 15, 15, 15)];
    timeImg.image = IMG(@"icon_时间");
    [cell.contentView addSubview:timeImg];
    
    FBLabel * timeLabel = [[FBLabel alloc] initWithStyle:MRECT(35, line.frame.origin.y + 14, WIDTH_SCREEN-50, 0) font:FONT_MIDDLE fcolor:kDeepLabelColor text:_venDetailModel.showOpenTimeAndNotice linespace:4];
    [cell.contentView addSubview:timeLabel];
    
    MYMaskView *line1 = [MYMaskView maskViewWithBgColor:COLOR_GRAY_LINE frame:CGRectMake(WIDTH_LEFT_SPAN, timeLabel.frame.origin.y + timeLabel.textHeight + 12, WIDTH_SCREEN-WIDTH_LEFT_SPAN*2, kLineThick) radius:0];
    [cell.contentView addSubview:line1];
    
    
    
    UIImageView * phoneImg = [[UIImageView alloc] initWithFrame:MRECT(WIDTH_LEFT_SPAN, line1.frame.origin.y + 14, 15, 15)];
    phoneImg.image = IMG(@"icon_电话");
    [cell.contentView addSubview:phoneImg];
    
    
    WS(weakSelf)
    FBButton * phoneButton = [[FBButton alloc] initWithText:MRECT(35, line1.frame.origin.y + 14, WIDTH_SCREEN-WIDTH_LEFT_SPAN*2, 20) font:FONT_MIDDLE fcolor:kNavigationBarColor bgcolor:COLOR_CLEAR text:_venDetailModel.venueMobile clickEvent:^(FBButton *owner) {
        
        [UIToolClass callPhone:_venDetailModel.venueMobile sourceVC:weakSelf];
    }];
    phoneButton.animation = NO;
    phoneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [cell.contentView addSubview:phoneButton];
    
    // 收费说明
    if(![_venDetailModel.showedVenuePrice isEqualToString:@"免费"])
    {
        MYMaskView *line2 = [MYMaskView maskViewWithBgColor:COLOR_GRAY_LINE frame:CGRectMake(WIDTH_LEFT_SPAN, phoneButton.frame.origin.y + phoneButton.frame.size.height + 12, WIDTH_SCREEN-WIDTH_LEFT_SPAN*2, kLineThick) radius:0];
        [cell.contentView addSubview:line2];
        
        UIImageView * moneyImg = [[UIImageView alloc] initWithFrame:MRECT(WIDTH_LEFT_SPAN, line2.frame.origin.y + 12, 15, 15)];
        moneyImg.image = IMG(@"icon_money");
        [cell.contentView addSubview:moneyImg];
        
        
        NSArray *array = [ToolClass getComponentArray:_venDetailModel.showedVenuePriceAndNotice separatedBy:@"||"];
        
        UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 0, kScreenWidth-35-10, 0)];
        priceLabel.numberOfLines = 0;
        priceLabel.font = FONT_MIDDLE;
        priceLabel.textColor = kDeepLabelColor;
        priceLabel.attributedText = [UIToolClass getAttributedStr:array[0] font:priceLabel.font lineSpacing:4];
        priceLabel.height = [UIToolClass attributedTextHeight:priceLabel.attributedText width:priceLabel.width];
        [cell.contentView addSubview:priceLabel];
        priceLabel.originalY = moneyImg.centerY-[UIToolClass fontHeight:priceLabel.font]*0.5;
        
        if (array.count == 2) {
            UILabel *noticeLabel = [[UILabel alloc] initWithFrame:CGRectMake(priceLabel.originalX, priceLabel.maxY+8, priceLabel.width, 0)];
            noticeLabel.textColor = kDeepLabelColor;
            noticeLabel.font = FONT_MIDDLE;
            noticeLabel.numberOfLines = 0;
            [cell.contentView addSubview:noticeLabel];
            
            NSMutableAttributedString *attributedString = [UIToolClass getAttributedStr:array[1] font:noticeLabel.font lineSpacing:4];
            [attributedString addAttribute:NSForegroundColorAttributeName value:kDeepLabelColor range:NSMakeRange(0, [array[1] length])];
            noticeLabel.attributedText = attributedString;
            noticeLabel.height = [UIToolClass attributedTextHeight:attributedString width:noticeLabel.width];
            
            cell.frame = MRECT(0, 0, WIDTH_SCREEN, noticeLabel.maxY + 30);
        }else{
            cell.frame = MRECT(0, 0, WIDTH_SCREEN, priceLabel.maxY + 30);
        }
    }
    else
    {
        cell.frame = MRECT(0, 0, WIDTH_SCREEN ,timeLabel.originalY + timeLabel.textHeight + 60);
    }
    
    
}


#pragma mark- UITableViewDelegate And DataSource

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil)
    {
        return 0;
    }
    CGFloat height = cell.frame.size.height;
    switch (indexPath.section) {
        case 0://场馆信息
        {
            return [self getValueByDefautlValue:_venueId defaultValue:height];
        }
        case 1://相关活动
        {
            return [self getValueByDefautlValue:_venueActivityArray defaultValue:height];
        }
        case 2://语音导览
        {
            return [self getValueByDefautlValue:_venDetailModel.venueVoiceUrl defaultValue:height];
        }
        case 3://视频
        {
            return [self getValueByDefautlValue:self.VideosArray defaultValue:height];
        }
        case 4://详情内容
        {
            return [self getValueByDefautlValue:_venDetailModel.venueMemo defaultValue:_contentHeight+52];
        }
        case 5://相关活动室
        {
            FBLOG(@"活动室的高度：%f", height);
            return [self getValueByDefautlValue:_roomVenueArray defaultValue:height];
        }
        case 6://藏品
        {
            FBLOG(@"藏品的高度：%f", height);
            return [self getValueByDefautlValue:ceollerArray defaultValue:height];
        }
        case 7://点赞
        {
            return 12.5+[UIToolClass fontHeight:FONT(14)]+10+32+15;
        }
        case 8://评论
        {
            if (_venueCommentArray.count > 0)
            {
                if (indexPath.row > 0) {
                    CommentModel *model = _venueCommentArray[indexPath.row-1];
                    return [self getCommentCellHeightWithModel:model];
                }else{
                    return 42;
                }
            }
        }
            break;
            
        default:
            break;
    }
    return 0;
    
}

//评论单元格高度
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

-(CGFloat)getValueByDefautlValue:(id)obj  defaultValue:(CGFloat)defaultValue
{
    if (obj == nil)
    {
        return .1f;
    }
    if([obj isKindOfClass:[NSString class]])
    {
        if(((NSString *)obj).length == 0)
        {
            return .1f;
        }
    }
    
    if([obj isKindOfClass:[NSArray class]])
    {
        if(((NSArray *)obj).count == 0)
        {
            return .1f;
        }
    }
    if([obj isKindOfClass:[NSDictionary class]])
    {
        if(((NSDictionary *)obj).count == 0)
        {
            return .1f;
        }
    }
    return defaultValue;
}


//#pragma mark -创建滚动视图
//自定义UITableView头部控件
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *backgroundView = [[UIView alloc] initWithFrame:MRECT(0, 0, WIDTH_SCREEN, .1)];
    backgroundView.backgroundColor = COLOR_CLEAR;
    return backgroundView;
}

//返回头部的高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return .1f;
    
}

//返回尾部的高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    int height = 10;
    switch (section) {
        case 0://场馆信息
        {
            return [self getValueByDefautlValue:_venueId defaultValue:height];
        }
        case 1://相关活动
        {
            return [self getValueByDefautlValue:_venueActivityArray defaultValue:height];
        }
        case 2://语音导览
        {
            return [self getValueByDefautlValue:_venDetailModel.venueVoiceUrl defaultValue:height];
        }
        case 3://视频
        {
            return [self getValueByDefautlValue:self.VideosArray defaultValue:height];
        }
        case 4://详情内容
        {
            return [self getValueByDefautlValue:_venDetailModel.venueMemo defaultValue:height];
        }
        case 5://相关活动室
        {
            return [self getValueByDefautlValue:_roomVenueArray defaultValue:height];
        }
        case 6://藏品
        {
            return [self getValueByDefautlValue:ceollerArray defaultValue:height];
        }
        case 7://点赞
        {
            return [self getValueByDefautlValue:_wantGoUsersArray defaultValue:height];
        }
        case 8://评论
        {
            return [self getValueByDefautlValue:_venueCommentArray defaultValue:height];
        }
        default:
            return .1f;
    }
    
}



#pragma mark - —————————————————— 点击事件 ——————————————————

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//发表评论
- (void)enterCommitCommentVC
{
    if ([self userCanOperateAfterLogin] && ![ToolClass showForbiddenNotice]) {
        
        User *user = [UserService sharedService].user;
        
        if ([user.commentStatus integerValue] == 1) {
            WEAK_VIEW(_detailTableView)
            
            PublishCommentViewController *vc = [PublishCommentViewController new];
            vc.dataType = DataTypeVenue;
            vc.modelId = _venueId;
            // 评论成功后的回调
            vc.successBlock = ^(CommentModel *model) {
                [_venueCommentArray insertObject:model atIndex:0];
                _commentIndex = 0;
                _venDetailModel.totalNumOfComment += 1;
                [weakView reloadData];
            };

            [self.navigationController pushViewController:vc animated:YES];
        }else { // commentStatus = 0
            [SVProgressHUD showInfoWithStatus:@"当前用户已被禁止评论"];
        }
    }
}

//拨打电话
- (void)callPhone
{
    [UIToolClass callPhone:_venDetailModel.venueMobile sourceVC:self];
}

//分享
- (void)enterShareView
{
    NSString *shareContent = [ToolClass getHTMLContent:_venDetailModel.venueMemo limitedLength:40];
    
    [SharePresentView showShareViewWithTitle:_venDetailModel.venueName content:shareContent sharedImage:_cycleScrollView.currentImage imageUrl:nil shareUrl:_venDetailModel.shareUrl extParams:@{ @"addIntegral" : @"1", }];
}

// 语音导览事件
-(void)venStopOrPlayBtnClick:(UIButton *)btn
{
    __weak VenueDetailViewController *weakSelf = self;
    if (_isPlayer == NO) {
        if (_isFistVideoUrl == YES) {
            [weakSelf loadMusicData];
            _isFistVideoUrl = NO;
        }
        
        [btn setBackgroundImage:IMG(@"icon_pause_audio") forState:UIControlStateNormal];
        [weakSelf.videoPlayer play];
        _isPlayer = YES;
        
        self.timeObserver = [_videoPlayer addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
            
            CGFloat currentTime = CMTimeGetSeconds(time);
            
            [weakSelf setSlideValue:currentTime / weakSelf.videoDuraion];
            
        }];
        
    }
    else
    {
        [btn setBackgroundImage:IMG(@"icon_play_audio") forState:UIControlStateNormal];
        [weakSelf.videoPlayer pause];
        _isPlayer = NO;
    }
    
}

//视频播放有关
- (void) buttonClick:(UIButton *)button
{
    tagOfVideo = button.tag -123;
    
    if (button.selected == NO) {
        button.selected = YES;
        button.backgroundColor = kBgColor;
        
        [self.videoController dismiss];
        
        //跳转
        img.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imgsMutableArray[button.tag-123]]]];
        title.text = [NSString stringWithFormat:@"  %@",titlesMutableArray[button.tag - 123]];
        
    }
    
    for (UIButton *btn in _buttonsScrollView.subviews)
    {
        if (button == btn)
        {
            btn.backgroundColor = kBgColor;
            btn.selected = YES;
        }
        else
        {
            btn.backgroundColor = [UIColor whiteColor];
            btn.selected = NO;
        }
    }
    
}

- (void) playButtonClick:(UIButton *)button
{
    self.videoController = [[KrVideoPlayerController alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(title.frame), kScreenWidth, 250)];
    __weak typeof(self)weakSelf = self;
    [self.videoController setDimissCompleteBlock:^{
        weakSelf.videoController = nil;
    }];
    [self.videoController setWillBackOrientationPortrait:^{
        [[UIApplication sharedApplication]setStatusBarHidden:NO];
        weakSelf.navigationController.navigationBarHidden = NO;
        [weakSelf.videoController topBarHidden:YES];
        [weakSelf.videoController volumeHidden:YES];
        [weakSelf.baseView addSubview:weakSelf.videoController.view];
        
    }];
    [self.videoController setWillChangeToFullscreenMode:^{
        [[UIApplication sharedApplication]setStatusBarHidden:YES];
        weakSelf.navigationController.navigationBarHidden = YES;
        [weakSelf.videoController volumeHidden:NO];
        [weakSelf.videoController topBarHidden:NO];
        [weakSelf.videoController showInWindow];
        
        
    }];
    [_baseView addSubview:self.videoController.view];
    
    self.videoController.contentURL = [NSURL URLWithString:linksMutableArray[tagOfVideo]];
    [self.videoController setTitle:titlesMutableArray[tagOfVideo]];
    [self.videoController topBarHidden:YES];
    
    [self.videoController play];
}

//返回至顶部
-(void)topToPeakBtnClick:(UIButton *)btn
{
    [_detailTableView setContentOffset:CGPointMake(0, 0) animated:YES];
}



#pragma mark - —————————————————— 代理方法 ——————————————————

#pragma mark- UIScrollViewDelegate
-(void)restoreHeadView
{
    if (_topImgView.superview != nil)
    {
        [_topImgView removeFromSuperview];
        [_infoCell.contentView addSubview:_cycleScrollView];
        
    }
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat y = scrollView.contentOffset.y;
    [_navTitleView setContentOffsetY:y];
    
    if (y < 0)
    {
        if (_topImgView.image == nil)
        {
            
            _topImgView.image = [UIToolClass convertImgFromView:_cycleScrollView];
            _topImgView.layer.anchorPoint = CGPointMake(0.5,0);
            _topImgView.frame = MRECT(0, 0, WIDTH_SCREEN,HEIGHT_TOPIMAGE);
            
        }
        if (_topImgView.superview == nil)
        {
            [self.view insertSubview:_topImgView belowSubview:_backbutton];
            [_cycleScrollView removeFromSuperview];
        }
        float scale = (HEIGHT_TOPIMAGE - y)/HEIGHT_TOPIMAGE;
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


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _detailTableView)
    {
        [self restoreHeadView];
        [_tabBarView showWithAnimation:scrollView];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (scrollView == _detailTableView) {
        [_tabBarView dismissWithAnimation:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView == _detailTableView && decelerate == NO)
    {
        [_tabBarView showWithAnimation:scrollView];
    }
}

#pragma mark-  UIWebViewDelegate



- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if([webView isKindOfClass:[FBWebView class]] ) {
        [(FBWebView *)webView restoreImagesUrl];
    }
    
    [webView addJudgeImageEventExistJs];
    [webView addGetImageUrlJs];
    
    //修改背景
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.background='#FFFFFF'"];
    //修改图片的尺寸
    [webView addResizeWebImageJs];
    //图片添加点击事件
    [webView addImageClickActionJs];
    // 重设字体的格式
    [webView addFontSettingJs];
    
    
    _contentHeight = [webView getWebViewContentHeight];
        
    [webView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(_contentHeight));
    }];
    
    [_detailTableView reloadData];
}


-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
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
    if ([request.URL.scheme isEqualToString:@"image-preview"]) {
        
        NSString *path = [request.URL.absoluteString substringFromIndex:[@"image-preview:" length]];
        path = [path stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        
        NSArray *pathArray = [ToolClass getComponentArray:path separatedBy:@";"];
        
        _detailTableView.userInteractionEnabled = 0;
        __weak UITableView *weakTableView = _detailTableView;
        [WebPhotoBrowser photoBrowserWithImageUrlArray:[webView getImageUrlArrayFromWeb]//图片链接数组
                                          currentIndex:[pathArray[1] integerValue]
                                       completionBlock:^(WebPhotoBrowser *photoBrowser) {
                                           weakTableView.userInteractionEnabled = 1;
                                       }];
        
        return NO;
    }
    return YES;
}


#pragma mark- 查看大图 HZPhotoBrowserDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    HZPhotoBrowser *photoVC = [[HZPhotoBrowser alloc] init];
    photoVC.delegate = self;
    photoVC.sourceImagesContainerView = _cycleScrollView;
    photoVC.currentImageIndex = 0;
    photoVC.imageCount = 1;
    _currentIndex = index;
    [photoVC show];
}

- (UIImage *)photoBrowser:(HZPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index{
    return _cycleScrollView.imagesGroup[_currentIndex];
}


- (id)photoBrowser:(HZPhotoBrowser *)browser highQualityImageOrImageURLForIndex:(NSInteger)index
{
    return [NSURL URLWithString:_cycleScrollView.imageURLStringsGroup[_currentIndex]];
}


#pragma mark - —————————————————— 其它方法 ——————————————————

#pragma mark-  音频相关

-(void)prepareToPlayAsset:(AVURLAsset *)asset withKeys:(NSArray *)requestedKeys
{
    for (NSString *thisKey in requestedKeys) {
        NSError *error = nil;
        AVKeyValueStatus keyStatus = [asset statusOfValueForKey:thisKey error:&error];
        
        if (keyStatus == AVKeyValueStatusFailed)
        {
            return;
        }
    }
    
    _item = [AVPlayerItem playerItemWithAsset:asset];
    
    [_item addObserver:self
            forKeyPath:@"status"
               options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
               context:nil];
    
    if (!_videoPlayer) {
        _videoPlayer = [AVPlayer playerWithPlayerItem:_item];
    }
    
    if (self.videoPlayer.currentItem != self.item)
    {
        [self.videoPlayer replaceCurrentItemWithPlayerItem:self.item];
    }
    
    [self removeTimeObserver];
    
    __weak VenueDetailViewController *weakSelf = self;
    self.timeObserver = [_videoPlayer addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        
        CGFloat currentTime = CMTimeGetSeconds(time);
        
        [weakSelf setSlideValue:currentTime / weakSelf.videoDuraion];
        
    }];
    
    [_videoPlayer play];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"status"])
    {
        AVPlayerStatus staus = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
        
        switch (staus) {
            case AVPlayerStatusReadyToPlay://正在播放
            {
                
                //只有在播放状态才能获取视频时间长度
                AVPlayerItem *playerItem = (AVPlayerItem *)object;
                NSTimeInterval duration = CMTimeGetSeconds(playerItem.asset.duration);
                _videoDuraion = duration;
                
                
            }
                break;
                
            case AVPlayerStatusFailed:
                
                break;
                
            case AVPlayerStatusUnknown:
                
                break;
                
            default:
                break;
        }
        
    }
}

-(void)removeTimeObserver
{
    if (_timeObserver)
    {
        [self.videoPlayer removeTimeObserver:_timeObserver];
        _timeObserver = nil;
    }
}

-(void)playerTimeLabelPan:(UIPanGestureRecognizer *)pan
{
    //FBLOG(@"拖拽手势！");
    [_videoPlayer pause];
    CGPoint location = [pan locationInView:pan.view.superview];
    
    if (location.x>= CGRectGetWidth(_playTimeLabel.frame)/2 && location.x <= kScreenWidth-CGRectGetWidth(_playTimeLabel.frame)/2) {
        pan.view.center = CGPointMake(location.x, pan.view.center.y);
        CGFloat width = pan.view.center.x/kScreenWidth;
        CGFloat panTime = width * _videoDuraion;
        _playTimeLabel.width = panTime >= 3600 ? 50 : 35;
        _playTimeLabel.text = [ToolClass getMusicPlayTimeString:panTime];
        CMTime time = CMTimeMake(panTime, 1);
        [_videoPlayer seekToTime:time completionHandler:^(BOOL finish){
            _isPlayer = YES;
            [_videoPlayer play];
            [_venStopOrPlayBtn setBackgroundImage:IMG(@"icon_play_audio") forState:UIControlStateNormal];
            
        }];
    }
    [pan setTranslation:CGPointZero inView:pan.view];
    
}

-(void)setSlideValue:(CGFloat)value
{
    if (value>0) {
        timeRatio = value;
    }else{
        timeRatio = 0;
    }
    
    _currentTime = value * _videoDuraion;
    
    _playTimeLabel.width = _currentTime >= 3600 ? 50 : 35;
    _playTimeLabel.text = [ToolClass getMusicPlayTimeString:_currentTime];
    
    [self updateProgressText];
}

-(void)updateProgressText
{
    CGFloat widht = (kScreenWidth-30)*timeRatio;
    
    _playTimeLabel.center = CGPointMake(CGRectGetWidth(_playTimeLabel.frame)/2+widht, _playTimeLabel.center.y);
    
    if (_currentTime == _videoDuraion) {
        _isPlayer = NO;
        _playTimeLabel.center = CGPointMake(CGRectGetWidth(_playTimeLabel.frame)/2, _playTimeLabel.center.y);
        _playTimeLabel.text = @"";
        [_venStopOrPlayBtn setBackgroundImage:IMG(@"icon_pause_audio") forState:UIControlStateNormal];
        //        [_videoPlayer pause];
        CMTime time = CMTimeMake(0, 1);
        [_videoPlayer seekToTime:time completionHandler:^(BOOL finish){
            
            [_videoPlayer pause];
            
        }];
    }
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
