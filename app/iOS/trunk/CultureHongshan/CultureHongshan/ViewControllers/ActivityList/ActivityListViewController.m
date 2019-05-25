//
//  ActivityListViewController.m
//  CultureHongshan
//
//  Created by ct on 16/4/11.
//  Copyright © 2016年 CT. All rights reserved.
//

#import "ActivityListViewController.h"

// View Controllers
#import "ActivityDetailViewController.h"
#import "SearchActivityViewController.h" // 搜索页面
#import "HomepageViewController.h"

// Models
#import "AdvertModel.h"
#import "CustomPointAnnotation.h"

#import "NoDataNoticeCell.h"

#import "MJRefresh.h"
#import "WebSDKService.h"
#import "LocationService2.h"

#define TAG_TITLELABEL       1941
#define TAG_DATELABEL        1942
#define TAG_PRICELABEL       1943
#define TAG_LOCATIONLABEL    1944
#define TAG_DISLABEL         1945
#define TAG_ANNOTATIONBASE   1000


#define ARRAY_INDEX_TOP_ADVERT     0
#define ARRAY_INDEX_INSERT_ADVERT  1
#define ARRAY_INDEX_ACT_LIST       2

static NSString *reuseID_ActivityList = @"ActivityList";
static NSString *reuseID_AdvCell      = @"AdvertCell";
static NSString *reuseID_NoData       = @"NoDataCell";



@implementation FBMapAnnotation

@synthesize coordinate;
@synthesize title;
-(void)setCoordinate:(CLLocationCoordinate2D)newCoordinate
{
    coordinate = newCoordinate;
}

@end



/*
 _dataList的数据结构:
   _dataList = @[
                  @[
                      @[TopAdvert, TopAdvert, TopAdvert], // 顶部的三个广告位数组
                      @[insertAdvert, insertAdvert, ...], // 活动列表中插入的广告位数组
                      @[actModel, actModel, ...], // 活动列表数组
                  ],
                  @[
                      @[TopAdvert, TopAdvert, TopAdvert], // 顶部的三个广告位数组
                      @[insertAdvert, insertAdvert, ...], // 活动列表中插入的广告位数组
                      @[actModel, actModel, ...], // 活动列表数组
                  ],
                  ...
              ];
 */


@interface ActivityListViewController ()<TagSelectScrollViewDelegate,MKMapViewDelegate>
{
    BOOL _isNavAnimating;
    CGFloat _scrollPosition; // 底部的collectionView左右滑动的位置(表示当前显示的是第几个单元格［如: 2.5］，并非表示collectionView.contentOffset.x)
    NSInteger _lastSelectedListIndex;//由列表页切换到地图模式时，列表页的index
    NSInteger _quickFilterTagIndex; // 快速筛选标签索引:0-全部， 1-附近
    
    
    FBButton *_navView;
    NSMutableArray *_nearbyArray; // 附近数组
//    NSMutableArray *_topAdvertArray; // 顶部的三个广告位数组
//    NSMutableArray *_advArray; //活动列表中插入的广告位数组
    NSArray *_insertTagArray;
}

@property (nonatomic, strong) NSArray *screenshotImages;

@end


@implementation ActivityListViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:WHYLocationAuthStatusDidChangeNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (_mapView) {
        _mapView.delegate = nil;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
    if(isNeedUpdateTag)
    {
        isNeedUpdateTag = NO;
        [self updateSelectTagView];
    }
    if (_mapView && !_mapView.delegate)
    {
        _mapView.delegate = self;
    }
    
    // 进入活动详情页再返回时的图片合并动画
    if (_screenshotImages.count) {
        self.bgTableView.hidden = YES;
        
        WS(weakSelf);
        [ToolClass animationWithTopImage:_screenshotImages[0] bottomImage:_screenshotImages[1] headOffset:0 isTogether:YES completion:^(BOOL finished) {
            weakSelf.bgTableView.hidden =  NO;
        }];
        _screenshotImages = nil;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //标签选择的滚动视图
    isShowMap = NO;
    _currentTagId = @"";
    annotationAry   = [NSMutableArray new];
    _nearbyArray    = [NSMutableArray new];
    [self re_InitDataListArray:1];
    
    [self initNavigationBar];
    [self initTagSelectView];
    
    WS(weakSelf)
    [self.bgTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view).offset(0);
        make.top.equalTo(weakSelf.view).offset(HEIGHT_TOP_BAR+5);
    }];
    
    // 添加定位通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLocationAuthStatusDidChange:) name:WHYLocationAuthStatusDidChangeNotification object:nil];
    
    [self checkSelectTagViewData];
}


/**
 *  设置自定义导航条
 */
- (void)initNavigationBar
{
    WS(weakSelf);
    
    // 背景视图
    _navView = [[FBButton alloc] initWithText:CGRectMake(0, 0, kScreenWidth, HEIGHT_TOP_BAR) font:nil fcolor:nil bgcolor:kNavigationBarColor text:nil clickEvent:^(FBButton *owner) {
        [weakSelf scrollToTop];
    }];
    _navView.animation = NO;
    [self.view addSubview:_navView];
    
    //中间的标题
    FBLabel *titleLabel = [[FBLabel alloc] initWithStyle:MRECT(0, HEIGHT_STATUS_BAR+10, kScreenWidth, HEIGHT_NAVIGATION_BAR) font:FONT(20) fcolor:COLOR_IWHITE text:@"文化活动"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [_navView addSubview:titleLabel];
    
    //左侧的地图按钮
    WEAK_VIEW(titleLabel);
    
    FBButton *mapButton = [[FBButton alloc] initWithImage:MRECT(10, HEIGHT_STATUS_BAR, HEIGHT_NAVIGATION_BAR , HEIGHT_NAVIGATION_BAR) bgcolor:COLOR_CLEAR img:IMG(@"icon_maptop") clickEvent:^(FBButton *owner) {
        // 导航条在进行上下移动时，不能变成地图模式，否则有可能导致切换到地图模式后，导航条恰好移到最上边的位置，造成无法切换回列表模式
        if (_isNavAnimating) {
            return;
        }
        
        if(isShowMap)//变为列表模式
        {
            isShowMap = NO;
            
            weakView.text = @"文化活动";
            weakSelf.bgTableView.hidden = NO;
            _mapView.hidden  = YES;
            [owner setImage:IMG(@"icon_maptop") forState:UIControlStateNormal];
            
            //由 地图模式 切换回 列表模式 时，如果两次选中的Tag不一样 或 列表页的数据为空，需要重新请求列表数据
            if ([_dataList[weakSelf.bgTableView.currentIndex][ARRAY_INDEX_ACT_LIST] count] < 1) {
                [weakSelf loadTableDataWithRefresh:NO isClearData:YES];
            }
        }
        else//地图模式
        {
            isShowMap = YES;
            
            _lastSelectedListIndex = weakSelf.bgTableView.currentIndex;
            weakView.text = @"附近";
            if(_mapView == nil)
            {
                [weakSelf initMapView];
                
                [weakSelf loadNearbyData];
            }else {
                if ([LocationService2 isAllowLocating] == NO) {
                    [SVProgressHUD showInfoWithStatus:@"定位服务不可用，无法获取附近的数据！"];
                }else {
                    [weakSelf loadNearbyData];
                }
            }
            [weakSelf.view bringSubviewToFront:tagSelectView];
            weakSelf.bgTableView.hidden = YES;
            _mapView.hidden  = NO;
            [owner setImage:IMG(@"icon_list") forState:UIControlStateNormal];
        }
    }];
    [_navView addSubview:mapButton];
    
    //右侧的搜索
    FBButton *searchButton = [[FBButton alloc] initWithImage:MRECT(kScreenWidth-50,HEIGHT_STATUS_BAR,HEIGHT_NAVIGATION_BAR , HEIGHT_NAVIGATION_BAR) bgcolor:COLOR_CLEAR img:IMG(@"放大镜") clickEvent:^(FBButton *owner) {
        SearchActivityViewController * vc = [[SearchActivityViewController alloc] initWithSearchType:SearchTypeActivity];//活动搜索
        [weakSelf.navigationController pushViewController:vc animated:NO];
    }];
    [_navView addSubview:searchButton];
}


/**
 *  初始化活动标签选择视图
 */
- (void)initTagSelectView
{
    tagSelectView = [[TagSelectScrollView alloc] initWithFrame:CGRectMake(0, _navView.maxY, kScreenWidth, 49) autolayout:NO];
    tagSelectView.delegate = self;
    [self.view addSubview:tagSelectView];
    
    WS(weakSelf)
    [tagSelectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.view);
        make.height.mas_equalTo(49);
        make.top.mas_equalTo(HEIGHT_TOP_BAR);
    }];
}

/**
 *  初始化地图视图
 */
- (void)initMapView
{
    _mapView = [[MKMapView alloc] initWithFrame:CGRectZero];
    _mapView.hidden = YES;
    _mapView.delegate = self;
    _mapView.mapType = MKMapTypeStandard;
    _mapView.showsUserLocation = YES;
    
    CLLocationCoordinate2D coords = [LocationService2 sharedService].location.location.coordinate;
    
    MKCoordinateSpan span = MKCoordinateSpanMake(0.5, 0.5);
    [_mapView setRegion:MKCoordinateRegionMake(coords, span) animated:NO];
    [self.view addSubview:_mapView];
    
    [_mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(HEIGHT_TOP_BAR, 0, 0, 0));
    }];
    
    // 地图模式，底部的弹出视图
    [self initViewOnMapBottom];
}


/**
 *  地图模式下，底部的弹出视图：展示当前选中的地图标注的有关活动信息
 */
-(void)initViewOnMapBottom
{
    bottomView = [UIView new];
    bottomView.hidden = YES;
    bottomView.backgroundColor = COLOR_IWHITE;
    [_mapView addSubview:bottomView];
    
    __weak MKMapView * weakMapView = _mapView;
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(weakMapView);
        make.left.equalTo(weakMapView).offset(0);
        make.top.equalTo(weakMapView.mas_bottom).offset(-96);
        make.height.equalTo(@96);
    }];
    
    MYMaskView * line = [MYMaskView maskViewWithBgColor:COLOR_GRAY_LINE frame:CGRectZero radius:0];
    [bottomView addSubview:line];
    __weak UIView * weakView = bottomView;
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(weakView);
        make.height.equalTo(@.5);
        make.left.equalTo(weakView.mas_left).offset(10);
        make.top.equalTo(@60);
    }];
    
    // 活动名称
    FBLabel * titleLabel = [[FBLabel alloc] initWithStyle:MRECT(10, 12, WIDTH_SCREEN-20, 20) font:FONT(18) fcolor:COLOR_IBLACK text:@""];
    titleLabel.tag = TAG_TITLELABEL;
    [bottomView addSubview:titleLabel];
    
    // 活动日期
    FBLabel * dateLabel = [[FBLabel alloc] initWithStyle:MRECT(10, 37, 200, 20) font:FONT(13) fcolor:kLightLabelColor text:@""];
    dateLabel.tag = TAG_DATELABEL;
    [bottomView addSubview:dateLabel];
    
    // 活动的价格
    FBLabel * priceLabel = [[FBLabel alloc] initWithStyle:CGRectZero font:FONT(14) fcolor:kLightLabelColor text:@"130元/人"];
    priceLabel.tag = TAG_PRICELABEL;
    priceLabel.textAlignment = NSTextAlignmentRight;
    [bottomView addSubview:priceLabel];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(weakView.mas_right).offset(-10);
        make.top.equalTo(@37);
    }];
    
    // 定位图标
    UIImageView * locationImage = [[UIImageView alloc] initWithFrame:MRECT(10, 68, 12, 17)];
    locationImage.image = IMG(@"icon_mapon");
    [bottomView addSubview:locationImage];
    
    // 活动所在的场馆名---->活动地址 （---->表示“没有场馆时，使用活动地址来代替”）
    FBLabel * locationLabel = [[FBLabel alloc] initWithStyle:MRECT(26, 70, 240, 20) font:FONT(14) fcolor:kLightLabelColor text:@""];
    locationLabel.tag = TAG_LOCATIONLABEL;
    [bottomView addSubview:locationLabel];
    
    // 活动距离
    FBLabel * distanceLabel = [[FBLabel alloc] initWithStyle:CGRectZero font:FONT(14) fcolor:kLightLabelColor text:@"600m"];
    distanceLabel.tag = TAG_DISLABEL;
    distanceLabel.textAlignment = NSTextAlignmentRight;
    [bottomView addSubview:distanceLabel];
    [distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(weakView.mas_right).offset(-10);
        make.top.equalTo(@70);
    }];
    
    // 距离图标
    UIImageView * distanceImage = [UIImageView new];
    distanceImage.image = IMG(@"icon_距离");
    [bottomView addSubview:distanceImage];
    [distanceImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(distanceLabel.mas_left).offset(-3);
        make.centerY.equalTo(distanceLabel);
        make.size.mas_equalTo(CGSizeMake(10, 11));
    }];
}

#pragma mark - ——————————————————   数据请求  ——————————————

/**
 * @brief 获取广告位的数据
 *
 * 顶部的三个广告位 与 列表中插入的广告位, 都在下面的接口中返回
 *
 */
- (void)loadAdvertData:(BOOL)isRefresh
{
    NSString *tagId = _currentTagId.length ? _currentTagId : @"0";
    WS(weakSelf);
    
    NSInteger currentIndex = self.bgTableView.currentIndex;
    EnumCacheMode cacheMode = isRefresh ? CACHE_MODE_REALTIME : CACHE_VALID_TIME_SHORT;
    
    [AppProtocol getMainIndexAdvListWithActivityType:tagId pageIndex:0 pageNum:kRefreshCount cacheMode:cacheMode UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        if (responseCode == HttpResponseSuccess && [responseObject count] > 0) {
            
            NSDictionary *dict = responseObject[0];
            
            //顶部的三个广告
            AdvertModel *topModel = [AdvertModel new];
            topModel.isOuterLink     = [dict safeIntegerForKey:@"advBannerFIsLink"] == 1;
            topModel.advImgUrl       = [dict safeStringForKey:@"advBannerFImgUrl"];
            topModel.advUrl          = [dict safeStringForKey:@"advBannerFUrl"];
            topModel.advLinkType     = [dict safeIntegerForKey:@"advBannerFLinkType"];
            topModel.advShareImgUrl  = [dict safeStringForKey:@"advShareImgUrl"];
            topModel.advShareContent = [dict safeStringForKey:@"advShareContent"];
            
            AdvertModel *leftModel = [AdvertModel new];
            leftModel.isOuterLink     = [dict safeIntegerForKey:@"advBannerSIsLink"] == 1;
            leftModel.advImgUrl       = [dict safeStringForKey:@"advBannerSImgUrl"];
            leftModel.advUrl          = [dict safeStringForKey:@"advBannerSUrl"];
            leftModel.advLinkType     = [dict safeIntegerForKey:@"advBannerSLinkType"];
            leftModel.advShareImgUrl  = [dict safeStringForKey:@"advShareImgUrl"];
            leftModel.advShareContent = [dict safeStringForKey:@"advShareContent"];
            
            AdvertModel *rightModel = [AdvertModel new];
            rightModel.isOuterLink     = [dict safeIntegerForKey:@"advBannerLIsLink"] == 1;
            rightModel.advImgUrl       = [dict safeStringForKey:@"advBannerLImgUrl"];
            rightModel.advUrl          = [dict safeStringForKey:@"advBannerLUrl"];
            rightModel.advLinkType     = [dict safeIntegerForKey:@"advBannerLLinkType"];
            rightModel.advShareImgUrl  = [dict safeStringForKey:@"advShareImgUrl"];
            rightModel.advShareContent = [dict safeStringForKey:@"advShareContent"];
            
            
            if (topModel.advImgUrl.length) {
                [_dataList[currentIndex][ARRAY_INDEX_TOP_ADVERT] removeAllObjects];//移除之前的广告
                [_dataList[currentIndex][ARRAY_INDEX_TOP_ADVERT] addObject:topModel];
                
                if (leftModel.advImgUrl.length) {
                    [_dataList[currentIndex][ARRAY_INDEX_TOP_ADVERT] addObject:leftModel];
                }
                if (rightModel.advImgUrl.length) {
                    [_dataList[currentIndex][ARRAY_INDEX_TOP_ADVERT] addObject:rightModel];
                }
            }
            
            //列表中的广告
            NSArray *advArray = [AdvertModel instanceArrayFromDictArray:dict[@"dataList"] type:1];
            [_dataList[weakSelf.bgTableView.currentIndex][ARRAY_INDEX_INSERT_ADVERT] removeAllObjects];
            [_dataList[weakSelf.bgTableView.currentIndex][ARRAY_INDEX_INSERT_ADVERT] addObjectsFromArray:advArray];
            
            if ([_dataList[currentIndex][ARRAY_INDEX_ACT_LIST] count] || [_dataList[currentIndex][ARRAY_INDEX_TOP_ADVERT] count]) {
                [weakSelf combineArrayForIndex:currentIndex];
                if (currentIndex == weakSelf.bgTableView.currentIndex) {
                    [weakSelf.bgTableView reloadDataForIndex:weakSelf.bgTableView.currentIndex];
                }
            }
        }
    }];
}

/**
 *  加载活动列表数据
 *
 *  @param isRefresh   是否从服务器请求，而不是使用缓存数据
 *  @param isClearData 是否清空数组中的原有数据
 */
- (void)loadTableDataWithRefresh:(BOOL)isRefresh isClearData:(BOOL)isClearData
{
    /*
     
     1. 在一个Tag下,下拉刷新————Advert 与 dataList 都要清空，isRefresh＝YES，isClearData＝YES
     2. 在一个Tag下，加载更多————Advert不变，dataList合并。isRefresh＝NO，isClearData＝NO
     3. 切换Tag———————————Advert 与 dataList 都要清空，isRefresh＝NO，isClearData＝YES
     
     */
    
    NSInteger currentIndex = self.bgTableView.currentIndex;
    
    if ([_dataList[currentIndex][ARRAY_INDEX_ACT_LIST] count] < 1) {
        isRefresh = YES;
    }
    
    NSInteger pageIndex = 0;
    if (isRefresh == NO && isClearData == NO) {
        // 计算已经获取到的活动数，要排除广告位的数据
        for (int i = 0; i < [_dataList[currentIndex][ARRAY_INDEX_ACT_LIST] count]; i++) {
            if ([_dataList[currentIndex][ARRAY_INDEX_ACT_LIST][i] isKindOfClass:[ActivityModel class]]) {
                pageIndex += 1;
            }
        }
    }
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showLoading];
    
    WS(weakSelf);
    
    void (^handle) (NSInteger responseCode, id responseObject) = ^(NSInteger responseCode, id responseObject)
    {
        [weakSelf.bgTableView removeNoticeView];
        [weakSelf.bgTableView endHeaderRefresh];
        [weakSelf.bgTableView endFooterRefresh];
        
        if (responseCode == HttpResponseSuccess)
        {
            BOOL switchTag = NO;
            if (isRefresh) { // 下拉刷新
                [weakSelf loadAdvertData:YES];
                [weakSelf loadInsertTagsData];
                [_dataList[currentIndex][ARRAY_INDEX_ACT_LIST] removeAllObjects];
                [_dataList[currentIndex][ARRAY_INDEX_ACT_LIST] addObjectsFromArray:responseObject];
            }else {
                if (isClearData) { // 切换Tag
                    switchTag = YES;
                    [weakSelf loadAdvertData:NO];
                    [_dataList[currentIndex][ARRAY_INDEX_ACT_LIST] removeAllObjects];
                    [_dataList[currentIndex][ARRAY_INDEX_ACT_LIST] addObjectsFromArray:responseObject];
                }else { // 加载更多
                    if ([_dataList[currentIndex][ARRAY_INDEX_ACT_LIST] count] && [responseObject count] < 1) {
                        [SVProgressHUD showInfoWithStatus:@"没有更多活动啦^_^"];
                        return;
                    }
                    [_dataList[currentIndex][ARRAY_INDEX_ACT_LIST] addObjectsFromArray:responseObject];
                }
            }
            
            [weakSelf combineArrayForIndex:currentIndex];
            
            if ([_dataList[currentIndex][ARRAY_INDEX_ACT_LIST] count] < 1) {
                // 请求不到数据时，进行提示
                [weakSelf updateErrorNoticeViewWithStyle:NoDataPromptStyleClickRefreshForNoContent message:nil];
            }else {
                [weakSelf.bgTableView removeNoticeView];
            }
            
            if (switchTag || isRefresh) {
                [self scrollToTop];
            }
            
            if (currentIndex == weakSelf.bgTableView.currentIndex) {
                [weakSelf.bgTableView reloadDataForIndex:weakSelf.bgTableView.currentIndex];
            }
            [SVProgressHUD dismiss];
        }
        else
        {
            if ([responseObject isKindOfClass:[NSString class]])
            {
                if ([_dataList[currentIndex][ARRAY_INDEX_ACT_LIST] count] == 0) {
                    // 网络错误等情况的提示
                    [weakSelf.bgTableView updateTableStatusForNoData:responseObject withBlock:^(id object, NSInteger index, BOOL isSameIndex) {
                        [weakSelf loadTableDataWithRefresh:YES isClearData:YES];
                    }];
                    [SVProgressHUD dismiss];
                }else{
                    [SVProgressHUD showErrorWithStatus:responseObject];
                }
            }
        }
    };
    
    NSString *isFree = nil;
    NSString *isReservation = nil;
    NSString *sortType = nil;
    
    switch (_quickFilterTagIndex) {
        case 1: // 附近
        {
            sortType = @"5";
        }
            break;
        case 2: // 人气
        {
            sortType = @"2";
        }
            break;
        case 3: // 免费
        {
            isFree = @"1";
        }
            break;
        case 4: // 可预订
        {
            isReservation = @"2";
        }
            break;
        case 5: // 最新
        {
            sortType = @"3";
        }
            break;
            
        default: // 全部
        {
            
        }
            break;
    }
    
    // 其它标签的活动筛选（置顶活动列表）
//    NSDictionary * areaDic = [DictionaryService getAreaCode:_selectedArea];
//    NSDictionary * filterDic = [DictionaryService getFilterValue:_selectedFilter];
    EnumCacheMode cacheMode = isRefresh ? CACHE_MODE_REALTIME : CACHE_VALID_TIME_SHORT;
    
    [AppProtocol getTopAcitivityListWithActivityTag:_currentTagId sortType:sortType activityArea:nil activityLocation:nil activityIsReservation:isReservation activityIsFree:isFree pageIndex:pageIndex pageNum:kRefreshCount cacheMode:cacheMode UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        handle(responseCode,responseObject);
    }];
}

/**
 *  @bried 附近活动列表数据
 *
 *  只根据标签Id筛选
 *
 */
- (void)loadNearbyData
{
    if ([self checkLocatingAuthorization] == NO && isShowMap) { // 展示地图时，若不允许定位，则不请求数据
        return;
    }
    
    WS(weakSelf);
    [AppProtocol getNearbyActivityListWithActivityType:_currentTagId
                                              sortType:@"1"
                                        activityIsFree:nil
                                 activityIsReservation:nil
                                             pageIndex:0
                                               pageNum:30
                                             cacheMode:CACHE_MODE_REALTIME
                                            UsingBlock:^(HttpResponseCode responseCode, id responseObject)
     {
         [SVProgressHUD dismiss];
         
         if (responseCode == HttpResponseSuccess) {
             NSArray * ary = (NSArray *)responseObject;
             if ([ary count] == 0) {
                 if (_nearbyArray.count) {
 //                     [SVProgressHUD showInfoWithStatus:@"没有更多活动啦!"];
                 }
             }
             [_nearbyArray removeAllObjects];
             [_nearbyArray addObjectsFromArray:ary];
         } else {
             [SVProgressHUD showInfoWithStatus:(NSString *)responseObject];
         }
         
         if(isShowMap) {
             [weakSelf initMapData];
         }
    }];
}


/**
 *  处理并展示地图中的活动数据
 */
- (void)initMapData
{
    if ([self checkLocatingAuthorization] == NO && isShowMap) {
        return;
    }
    
    tagSelectView.originalY = HEIGHT_TOP_BAR;
    
    if (annotationAry && annotationAry.count > 0)
    {
        [_mapView removeAnnotations:annotationAry];
        [annotationAry removeAllObjects];
        if(bottomView)
        {
            bottomView.hidden = YES;
        }
    }
    
    // 地图中展示的数据不能超过20个
    for (int i=0; i<_nearbyArray.count && i< 25; i++)
    {
        ActivityModel * model = _nearbyArray[i];
        FBMapAnnotation * annoation = [FBMapAnnotation new];
        CLLocationCoordinate2D point;
        point.latitude = model.activityLat;
        point.longitude = model.activityLon;
        annoation.title = model.activityName;
        annoation.index = TAG_ANNOTATIONBASE+i;
        [annoation setCoordinate:point];
        [annotationAry addObject:annoation];
        [_mapView addAnnotation:annoation];
    }
    
    CLLocationCoordinate2D coords = [LocationService2 sharedService].location.location.coordinate;
    MKCoordinateSpan span = MKCoordinateSpanMake(0.05, 0.05);
    [_mapView setRegion:MKCoordinateRegionMake(coords, span) animated:YES];
}

/** 加载列表中插入的标签数据 */
- (void)loadInsertTagsData {
    WS(weakSelf)
    NSInteger index = self.bgTableView.currentIndex;
    
    [AppProtocol getActivityListInsertTagWithActivityTag:nil cacheMode:CACHE_MODE_REALTIME UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        if (responseCode == HttpResponseSuccess) {
            _insertTagArray = responseObject;
            
            if (_insertTagArray.count) {
                [weakSelf combineArrayForIndex:index];
                if (index == weakSelf.bgTableView.currentIndex) {
                    [weakSelf.bgTableView reloadDataForIndex:weakSelf.bgTableView.currentIndex];
                }
            }
        }
    }];
}


/**
 *  @brief 合并广告位和活动数据
 *
 *  活动列表中插入广告位的规则是：每隔3个活动插入一个广告，列表中最后一个不能是广告位
 */
- (void)combineArrayForIndex:(NSInteger)index
{
    //移除之前的广告
    NSArray *tmpArray = [NSArray arrayWithArray:_dataList[self.bgTableView.currentIndex][ARRAY_INDEX_ACT_LIST]];
    for (NSInteger i = tmpArray.count-1; i > -1; i--) { // 倒序循环，删除广告位Model
        if (![tmpArray[i] isKindOfClass:[ActivityModel class]]) {
            [_dataList[self.bgTableView.currentIndex][ARRAY_INDEX_ACT_LIST] removeObjectAtIndex:i];
        }
    }
    
    if ([_dataList[self.bgTableView.currentIndex][ARRAY_INDEX_ACT_LIST] count] < 4) {
        if ([_dataList[self.bgTableView.currentIndex][ARRAY_INDEX_ACT_LIST] count] && _insertTagArray.count) {
            [_dataList[self.bgTableView.currentIndex][ARRAY_INDEX_ACT_LIST] insertObject:_insertTagArray atIndex:1];
        }
        return;
    }
    
    if ([_dataList[self.bgTableView.currentIndex][ARRAY_INDEX_INSERT_ADVERT] count]) {// 重新插入广告
        NSInteger activityCount = [_dataList[self.bgTableView.currentIndex][ARRAY_INDEX_ACT_LIST] count];
        for (NSInteger i = MIN(activityCount/3, [_dataList[self.bgTableView.currentIndex][ARRAY_INDEX_INSERT_ADVERT] count]); i > 0; i--) {
            if (i*3 >= activityCount) {
                continue;//排除"activityCount正好是3的倍数"
            }
            [_dataList[self.bgTableView.currentIndex][ARRAY_INDEX_ACT_LIST] insertObject:_dataList[self.bgTableView.currentIndex][ARRAY_INDEX_INSERT_ADVERT][i-1] atIndex:i*3];
        }
    }
    
    if (_insertTagArray.count) {
        [_dataList[self.bgTableView.currentIndex][ARRAY_INDEX_ACT_LIST] insertObject:_insertTagArray atIndex:1];
    }
}


#pragma mark - ———————————— UITableView DataSource And Delegate ————————————

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(MYTableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }else if (section == 1) {
        return [_dataList[tableView.tag][ARRAY_INDEX_ACT_LIST] count];
    }else if (section == 2) {
        if ([_dataList[tableView.tag][ARRAY_INDEX_ACT_LIST] count]==0 && tableView.promptStyle != NoDataPromptStyleNone) {
            return 1;
        }
    }
    return 0;
}


- (UITableViewCell * )tableView:(MYTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            // 顶部的三个广告位
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID_AdvCell forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.contentView.backgroundColor = RGB(230, 230, 230);
            [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            
            for (int i = 0; i < [_dataList[tableView.tag][ARRAY_INDEX_TOP_ADVERT] count] && i < 3; i++) {
                
                CGRect frame = CGRectZero;
                if (i == 0) {
                    frame = CGRectMake(0, 0, kScreenWidth, ConvertSize(250));
                }else {
                    frame = CGRectMake((i-1)*(kScreenWidth*0.5+0.5), 1+ConvertSize(250), kScreenWidth*0.5-0.5, ConvertSize(155));
                }
                
                AdvertModel *model = _dataList[tableView.tag][ARRAY_INDEX_TOP_ADVERT][i];
                WS(weakSelf);
                FBButton *button = [[FBButton alloc] initWithImage:frame bgcolor:COLOR_IWHITE img:nil clickEvent:^(FBButton *owner) {
                    [weakSelf goToAdvertPage:model shareImage:owner.currentImage];
                }];
                button.animation = NO;
                UIImage *placeImg = [UIToolClass getPlaceholderWithViewSize:button.viewSize centerSize:CGSizeMake(20, 20) isBorder:NO];
                [button sd_setImageWithURL:[NSURL URLWithString:JointedImageURL(model.advImgUrl, i > 0 ? kImageSize_SmallAdv : kImageSize_BigAdv)] forState:UIControlStateNormal placeholderImage:placeImg];
                [cell.contentView addSubview:button];
                
                if (i == 1) {
                    [cell.contentView addSubview:[MYMaskView maskViewWithBgColor:kBgColor frame:CGRectMake(0, button.maxY, kScreenWidth, 5) radius:0]];
                }
            }
            
            return cell;
        }else {
            UITableViewCell *filterCell = [tableView dequeueReusableCellWithIdentifier:@"Filter_Cell"];
            if (!filterCell) {
                filterCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Filter_Cell"];
                filterCell.contentView.backgroundColor = kWhiteColor;
                filterCell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                NSArray *filterImages = @[@"icon_activity_filter_all", @"icon_activity_filter_nearby", @"icon_activity_filter_hotest", @"icon_activity_filter_free", @"icon_activity_filter_book", @"icon_activity_filter_newest"];
                
                MYSmartButton *preButton;
                WS(weakSelf)
                for (int i = 0; i < filterImages.count; i++) {
                    NSString *imgName = filterImages[i];
                    
                    MYSmartButton *button = [[MYSmartButton alloc] initWithFrame:CGRectZero image:IMG(imgName) selectedImage:nil actionBlock:^(MYSmartButton *sender) {
                        if (sender.selected) {
                            return;
                        }
                        _quickFilterTagIndex = sender.tag;
                        
                        [weakSelf loadTableDataWithRefresh:NO isClearData:YES];
                        
                        for (UIButton *subButton in sender.superview.subviews) {
                            if ([subButton isKindOfClass:[UIButton class]]) {
                                if (subButton.tag == sender.tag) {
                                    subButton.selected = YES;
                                    subButton.backgroundColor = kOrangeYellowColor;
                                }else {
                                    subButton.selected = NO;
                                    subButton.backgroundColor = kThemeDeepColor;
                                }
                            }
                        }
                    }];
                    button.tag = i;
                    button.radius = 4;
                    button.selected = i==0;
                    button.layer.borderColor = ColorFromHex(@"b7b7b7").CGColor;
                    button.layer.borderWidth = 0.6;
                    button.backgroundColor = button.selected ? kOrangeYellowColor : kThemeDeepColor; // kThemeLightColor
                    [filterCell.contentView addSubview:button];
                    [button mas_makeConstraints:^(MASConstraintMaker *make) {
                        if (preButton) {
                            make.left.equalTo(preButton.mas_right).offset(7);
                            make.width.height.and.centerY.equalTo(preButton);
                        }else {
                            make.left.equalTo(filterCell.contentView).offset(6);
                            make.top.equalTo(filterCell.contentView).offset(13);
                            make.height.equalTo(button.mas_width);
                        }
                    }];
                    
                    preButton = button;
                }
                [preButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(filterCell.contentView).offset(-6);
                }];
                
                MYMaskView *bottomLine = [MYMaskView maskViewWithBgColor:kBgColor frame:CGRectZero radius:0];
                [filterCell.contentView addSubview:bottomLine];
                [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.and.bottom.equalTo(filterCell);
                    make.height.mas_equalTo(5);
                }];
            }
            for (UIButton *button in filterCell.contentView.subviews) {
                if ([button isKindOfClass:[UIButton class]]) {
                    button.selected = _quickFilterTagIndex==button.tag;
                    if (button.selected) {
                        button.backgroundColor = kOrangeYellowColor;
                    }else {
                        button.backgroundColor = kThemeDeepColor;
                    }
                }
            }
            
            return filterCell;
        }
        
    }else if (indexPath.section == 1) {
        if (![ToolClass dataIsValid:indexPath.row forArrayCount:[_dataList[tableView.tag][ARRAY_INDEX_ACT_LIST] count]]) {
            RETURN_BLANK_CELL
        }
        
        if ([_dataList[tableView.tag][ARRAY_INDEX_ACT_LIST][indexPath.row] isKindOfClass:[AdvertModel class]]) {
            
            AdvertModel *model = _dataList[tableView.tag][ARRAY_INDEX_ACT_LIST][indexPath.row];
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID_AdvCell forIndexPath:indexPath];
            [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];//移除之前的视图
            cell.contentView.backgroundColor = [UIColor whiteColor];
            
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ConvertSize(250))];
            UIImage *placeImg = [UIToolClass getPlaceholderWithViewSize:imgView.viewSize centerSize:CGSizeMake(20, 20) isBorder:NO];
            [imgView sd_setImageWithURL:[NSURL URLWithString:JointedImageURL(model.advImgUrl, kImageSize_BigAdv)] placeholderImage:placeImg];
            [cell.contentView addSubview:imgView];
            
            MYMaskView *line = [MYMaskView maskViewWithBgColor:kBgColor frame:CGRectMake(0, imgView.maxY, kScreenWidth, cell.height-imgView.maxY) radius:0];
            [cell.contentView addSubview:line];
            
            return cell;
        }else if ([_dataList[tableView.tag][ARRAY_INDEX_ACT_LIST][indexPath.row] isKindOfClass:[ActivityModel class]]) {
            ActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID_ActivityList forIndexPath:indexPath];
            // 按照距离进行排序时，需要显示距离是多少，其它情况下，则隐藏距离显示
            [cell setModel:_dataList[tableView.tag][ARRAY_INDEX_ACT_LIST][indexPath.row] type:_quickFilterTagIndex==1 ? 2 : 1 forIndexPath:indexPath];
            return cell;
        }else if ([_dataList[tableView.tag][ARRAY_INDEX_ACT_LIST][indexPath.row] isKindOfClass:[NSArray class]]) {
            NSArray *insertTagArray = _dataList[tableView.tag][ARRAY_INDEX_ACT_LIST][indexPath.row];
            if (insertTagArray.count) {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID_AdvCell forIndexPath:indexPath];
                [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];//移除之前的视图
                cell.contentView.backgroundColor = RGB(230, 230, 230);
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                MYMaskView *bottomLine = [MYMaskView maskViewWithBgColor:kBgColor frame:CGRectZero radius:0];
                [cell.contentView addSubview:bottomLine];
                [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.and.bottom.equalTo(cell.contentView);
                    make.height.mas_equalTo(5);
                }];
                
                
                WS(weakSelf)
                MYSmartButton *preButton;
                for (int i = 0; i < insertTagArray.count; i++) {
                    AdvertModel *model = insertTagArray[i];
                    
                    MYSmartButton *button = [[MYSmartButton alloc] initWithFrame:CGRectZero title:model.advertName font:FontYT(14) tColor:kDeepLabelColor bgColor:RGB(245, 245, 245) actionBlock:^(MYSmartButton *sender) {
                        if (model.isOuterLink) {
                            [weakSelf goToAdvertPage:model shareImage:nil];
                        }
                    }];
                    button.radius = 3;
                    button.layer.borderColor = RGB(175, 175, 175).CGColor;
                    button.layer.borderWidth = 0.5;
                    [cell.contentView addSubview:button];
                    
                    [button mas_makeConstraints:^(MASConstraintMaker *make) {
                        if (i%3 == 0) {
                            make.left.equalTo(cell.contentView).offset(7);
                            if (i == 0) {
                                make.width.equalTo(cell.contentView.mas_width).offset(-(2*8 + 2*7)/3.0f).multipliedBy(1.0/3);
                                make.top.mas_equalTo(12);
                                make.height.mas_equalTo(27);
                            }else {
                                make.width.and.height.equalTo(preButton);
                                make.top.equalTo(preButton.mas_bottom).offset(8);
                            }
                        }else if (i%3 == 1) {
                            make.centerX.equalTo(cell.contentView);
                            make.width.and.height.equalTo(preButton);
                            make.top.equalTo(preButton);
                        }else {
                            make.right.equalTo(cell.contentView).offset(-7);
                            make.width.and.height.equalTo(preButton);
                            make.top.equalTo(preButton);
                        }
                    }];
                    
                    preButton = button;
                }
                

                
                return cell;
            }
        }
    }else if (indexPath.section == 2) {
        
        if ([_dataList[tableView.tag][ARRAY_INDEX_ACT_LIST] count] == 0 && tableView.promptStyle != NoDataPromptStyleNone) {
            NoDataNoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID_NoData forIndexPath:indexPath];
            WS(weakSelf)
            [cell setPromptStyle:tableView.promptStyle message:tableView.errorMsg actionHandler:^{
                [[weakSelf.bgTableView getCurrentShowTableView].header beginRefreshing];
            }];
            return cell;
        }
    }
    
    RETURN_BLANK_CELL
}


-(CGFloat)tableView:(MYTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            if ([_dataList[tableView.tag][ARRAY_INDEX_TOP_ADVERT] count] < 1) {
                return 0;
            }else if ([_dataList[tableView.tag][ARRAY_INDEX_TOP_ADVERT] count] == 1){
                return ConvertSize(250);
            }else {
                return ConvertSize(405) + 6; // ConvertSize(250 + 155) + 1 + 5
            }
        }else  {
            return (kScreenWidth-47)/6.0f + 31; // (kScreenWidth-2*6-5*7)/6.0f + 2*13 + 5
        }
    }else if (indexPath.section == 1) {
        if ([ToolClass dataIsValid:indexPath.row forArrayCount:[_dataList[tableView.tag][ARRAY_INDEX_ACT_LIST] count]]) {
            id obj = _dataList[tableView.tag][ARRAY_INDEX_ACT_LIST][indexPath.row];
            
            if ([obj isKindOfClass:[AdvertModel class]]) {
                return ConvertSize(250)+7.5;
            }else if ([obj isKindOfClass:[ActivityModel class]]) {
                return kScreenWidth*kPicScale_ListCover + 76;
            }else if ([obj isKindOfClass:[NSArray class]] && [obj count]) {
                NSInteger rowNum = [ToolClass getGroupNum:[obj count] perGroupCount:3];
                return 2*12 + 5 + rowNum * 27 + (rowNum-1)*8;
            }
        }
    }else {
        if ([_dataList[tableView.tag][ARRAY_INDEX_ACT_LIST] count]==0 && tableView.promptStyle != NoDataPromptStyleNone) {
            return 200;
        }
    }
    
    return 0.01f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!(indexPath.section == 1 &&  [_dataList[tableView.tag][ARRAY_INDEX_ACT_LIST] count])) {
        return;
    }
    
    id obj = _dataList[tableView.tag][ARRAY_INDEX_ACT_LIST][indexPath.row];
    if ([obj isKindOfClass:[ActivityModel class]])
    {
        ActivityModel *model = (ActivityModel *)obj;
        if (model.activityId.length > 0)
        {
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            UIImage *screenShotImg = [UIToolClass getScreenShotImageWithSize:CGSizeMake(kScreenWidth, kScreenHeight) views:@[window] isBlurry:NO];
            
            ActivityCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            CGRect frame = [cell.contentView convertRect:cell.contentView.frame toView:window];
            
            
            CGFloat topHeight = MIN(MAX(CGRectGetMaxY(frame)-8-76, tagSelectView.maxY), kScreenHeight-50);
            self.screenshotImages = [ToolClass getTwoScreenShotsWithImage:screenShotImg topHeight:topHeight headimg:[cell getHeadImage]];
            
            ActivityDetailViewController *activityDetailVC = [ActivityDetailViewController new];
            activityDetailVC.activityId = model.activityId;
            activityDetailVC.screenshotImages = self.screenshotImages;
            [self.navigationController pushViewController:activityDetailVC animated:NO];
        }
    }else if ([obj isKindOfClass:[AdvertModel class]]) {
        AdvertModel *model = (AdvertModel *)obj;
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        UIImage *image = ((UIImageView *)cell.contentView.subviews[0]).image;
        [self goToAdvertPage:model shareImage:image];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

#pragma mark - ———————————— 代理方法  ————————————


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_isNavAnimating) return;
    if ([scrollView isKindOfClass:[UITableView class]]) {
        if (scrollView.tag != self.bgTableView.currentIndex) {
            return;
        }
    }
    
    // 导航条的动画
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if ( offsetY >= scrollView.contentSize.height-scrollView.height || offsetY < 0 ) {
        _preOffsetY = offsetY;
        return;
    }
    
    if (_preOffsetY > offsetY) {
        [self navViewAnimation:YES];//出现
    }else {
        if (offsetY - _beginDragOffsetY > 10) {
            [self navViewAnimation:NO];// 消失
        }
    }
    _preOffsetY = offsetY;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _beginDragOffsetY = scrollView.contentOffset.y;
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKAnnotationView * pinView = nil;
    static NSString * annotation_identify = @"pinview";
    if ([annotation isKindOfClass:[FBMapAnnotation class]])
    {
        pinView = [_mapView dequeueReusableAnnotationViewWithIdentifier:annotation_identify];
        if(pinView == nil)
        {
            pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotation_identify];
        }
        if (pinView)
        {
            pinView.tag = ((FBMapAnnotation *)annotation).index;
            
            [UIView animateWithDuration:.5 animations:^{
                pinView.image = IMG(@"icon_map");
            }];
        }
    }
    return pinView;
}

// 选中地图标注
-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if (view && [self isPoiAnnotation:view]) {
        if (_lastSelectedAnnotationView) {
            [mapView deselectAnnotation:_lastSelectedAnnotationView.annotation animated:NO];
        }
        _lastSelectedAnnotationView = view;
        [UIView animateWithDuration:.5 animations:^{
            view.image = IMG(@"icon_mapon");
        }];
        
        ActivityModel * model = _nearbyArray[view.tag - TAG_ANNOTATIONBASE];
        [self updateBottomView:model];
    }
}

// 取消选中地图标注
-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    if ([self isPoiAnnotation:view])
    {
        [UIView animateWithDuration:.5 animations:^{
            view.image = IMG(@"icon_map");
        }];
        _lastSelectedAnnotationView = nil;
        bottomView.hidden = YES;
    }
}


- (void)tagSelectView:(TagSelectScrollView *)tagView didSelectItem:(ThemeTagModel *)model forIndex:(NSInteger)index
{
    _currentTagId = model.tagId;
    
    if (isShowMap) {
        [self loadNearbyData];
        [self.bgTableView tableViewChangeToIndex:index-2 animated:NO];
    }else {
        if (self.bgTableView.currentIndex != index-2){// 两次点击的不是同一个标签
//            [self clearAdvertData];
        }
        
        [self.bgTableView tableViewChangeToIndex:index-2 animated:NO];
        
        
        if ([_dataList[self.bgTableView.currentIndex][ARRAY_INDEX_ACT_LIST] count] < 1) {
            [self loadTableDataWithRefresh:NO isClearData:YES];
        }
    }
    [self scrollToTop];
}

// CommonMultiTableViewDelegate

- (void)tableViewSetting:(UITableView *)tableView forIndex:(NSInteger)index
{
    [tableView registerClass:[ActivityCell class] forCellReuseIdentifier:reuseID_ActivityList];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:reuseID_AdvCell];
    [tableView registerClass:[NoDataNoticeCell class] forCellReuseIdentifier:reuseID_NoData];
    
    WS(weakSelf);
    [CommonMultiTableViewController setupRefresh:tableView withBlock:^(BOOL isRefresh) {
        [weakSelf loadTableDataWithRefresh:isRefresh isClearData:isRefresh];
    }];
}

- (void)tableViewDidEndScrollToIndex:(NSInteger)index forCell:(UICollectionViewCell *)cell
{
    if (index == self.bgTableView.currentIndex) return;
    
    [tagSelectView moveToIndex:index];
}

- (void)tableViewDidScrollHorizontally:(CGFloat)position
{
    _scrollPosition = position;
}

- (void)willShowContentView:(UIView *)contentView {
    if ([contentView isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)contentView;
        tableView.contentInset = UIEdgeInsetsMake(tagSelectView.originalY > 25 ? 44 : 0, 0, 0, 0);
        tableView.contentOffset = CGPointMake(0, -tableView.contentInset.top);
    }else if ([contentView isKindOfClass:[UIWebView class]]) {
        CGFloat positionY = tagSelectView.originalY > 25 ? 44 : 0;
        [contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.and.bottom.equalTo(contentView.superview);
            make.top.mas_equalTo(positionY);
        }];
        
        [contentView.superview setNeedsLayout];
        [contentView.superview layoutIfNeeded];
        
        ((UIWebView *)contentView).scrollView.contentOffset = CGPointZero;
    }
}

#pragma mark -  ————  其它方法  ————

-(void)updateBottomView:(ActivityModel *)model
{
    if(bottomView.hidden)
    {
        bottomView.hidden = NO;
        __weak MKMapView * weakMap = _mapView;
        [bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(weakMap.mas_bottom).offset(0);
            
        }];
        
        [weakMap layoutIfNeeded];
        
        [UIView animateWithDuration:.5f animations:^{
            
            [bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
                
                make.top.equalTo(weakMap.mas_bottom).offset(-96);
            }];
            [weakMap layoutIfNeeded];
            
        }];
    }
    if (_bottomViewButton)
    {
        [_bottomViewButton removeFromSuperview];
        _bottomViewButton = nil;
    }
    
    WS(weakSelf);
    _bottomViewButton = [[FBButton alloc] initWithImage:CGRectZero bgcolor:COLOR_CLEAR img:nil clickEvent:^(FBButton *owner) {
        
        ActivityDetailViewController *activityDetailVC = [ActivityDetailViewController new];
        activityDetailVC.activityId = model.activityId;
        [weakSelf.navigationController pushViewController:activityDetailVC animated:YES];
    }];
    [bottomView addSubview:_bottomViewButton];
    [_bottomViewButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(bottomView).offset(0);
    }];
    
    {
        FBLabel * label = [bottomView viewWithTag:TAG_TITLELABEL];
        label.text = model.activityName;
    }
    {
        FBLabel * label = [bottomView viewWithTag:TAG_DATELABEL];
        label.text = model.showedActivityDate;
    }
    {
        FBLabel * label = [bottomView viewWithTag:TAG_PRICELABEL];
        label.text = model.showedPrice;
    }
    {
        FBLabel * label = [bottomView viewWithTag:TAG_LOCATIONLABEL];
        label.text = model.venueName;
    }
    {
        FBLabel * label = [bottomView viewWithTag:TAG_DISLABEL];
        label.text = model.showedDistance;
    }
    
}


-(BOOL)isPoiAnnotation:(MKAnnotationView *)annotationView
{
    if (annotationView.tag >= TAG_ANNOTATIONBASE) {
        return YES;
    }
    return NO;
}

- (void)setNeedUpdateSelectTagView:(BOOL)isNeed
{
    isNeedUpdateTag = isNeed;
}


/**
 *  用户重新选择喜爱的活动类型标签后，更新标签选择视图
 */
- (void)updateSelectTagView
{
    [tagSelectView updateSelectTagArray];
    _currentTagId = @"";
    if (tagSelectView.titleArray.count) {
        ThemeTagModel *model = tagSelectView.titleArray[0];
        if (model.tagId.length) {
            _currentTagId = model.tagId;
        }
    }

    self.bgTableView.tableViewCount = tagSelectView.titleArray.count;
    
    [self re_InitDataListArray:tagSelectView.titleArray.count]; // 重新初始化数组
    
    
    [self.bgTableView tableViewChangeToIndex:0 animated:NO];
    [self.bgTableView reloadData];
    [self loadTableDataWithRefresh:NO isClearData:YES];
}


/**
 *  导航条的动画
 *
 *  @param isShow YES时，导航条完全显示，活动标签选择视图处于最低位置；否则，导航条的下半部分被覆盖住
 */
- (void)navViewAnimation:(BOOL)isShow
{
    if (isShowMap) {
        tagSelectView.originalY = HEIGHT_TOP_BAR;
        [self.bgTableView getCurrentShowTableView].contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
        return;
    }
    
    CGFloat targetPositon = isShow ? HEIGHT_TOP_BAR : HEIGHT_STATUS_BAR;
    if (targetPositon == tagSelectView.originalY) {
        return;
    }
    
    
    WS(weakSelf)
    _isNavAnimating = YES;
    
    [tagSelectView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(targetPositon);
    }];
    
    UIWebView *webView = [self.bgTableView getCurrentShowWebView];
    if (webView) {
        CGFloat positionY = isShow ? 44 : 0;
        
        [webView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(webView.superview.mas_top).offset(positionY);
            make.left.right.and.bottom.equalTo(webView.superview);
        }];
    }
    
    [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        [weakSelf.view setNeedsLayout];
        [weakSelf.view layoutIfNeeded];
        
        if (isShow) {
            [weakSelf.bgTableView getCurrentShowTableView].contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
        }else {
            [weakSelf.bgTableView getCurrentShowTableView].contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        }
        
        [webView.superview setNeedsLayout];
        [webView.superview layoutIfNeeded];
    } completion:^(BOOL finished) {
        _isNavAnimating = NO;
    }];
}

// 广告位跳转
- (void)goToAdvertPage:(AdvertModel *)model shareImage:(UIImage *)shareImage
{
    [HomepageViewController goToAdvertPage:model shareImage:shareImage sourceVC:self.navigationController];
}

// YES时，允许定位,需要请求数据
- (BOOL)checkLocatingAuthorization
{
    CLAuthorizationStatus status= [CLLocationManager authorizationStatus];
    if ( (status != kCLAuthorizationStatusAuthorizedAlways && status != kCLAuthorizationStatusAuthorizedWhenInUse))
    {
        //不允许定位
        if ([ToolClass shouldNoticeUserAllowLocating])
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"无法获取到您的位置,请允许定位后再试吧" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            [ToolClass updateAllowLocatingNoticeStatus];
            return NO;
        }
        else
        {
            return YES;
        }
    }
    else
    {
        return YES;
    }
}

// 清除广告位数据
- (void)clearAdvertData
{
    [_dataList[self.bgTableView.currentIndex][ARRAY_INDEX_TOP_ADVERT] removeAllObjects];
    [_dataList[self.bgTableView.currentIndex][ARRAY_INDEX_INSERT_ADVERT] removeAllObjects];
}



/**
 *  检查标签选择视图是否有数据，没有标签数据时，要点击刷新重新请求数据
 */
- (void)checkSelectTagViewData
{
    for (UIView *subView in self.view.subviews) {
        if ([subView isKindOfClass:[NoDataNoticeView class]]) {
            [subView removeFromSuperview];
        }
    }
    
    [tagSelectView updateSelectTagArray];
    
    if (tagSelectView.titleArray.count) {
        
        tagSelectView.canGoPreTag = NO;
        tagSelectView.canGoNextTag = tagSelectView.titleArray.count > 0 ? YES : NO;
        
        [self re_InitDataListArray:tagSelectView.titleArray.count]; // 重新初始化数组
        
        self.bgTableView.tableViewCount = tagSelectView.titleArray.count;
        [self.bgTableView reloadData];
        
        
        
        ThemeTagModel *model = tagSelectView.titleArray[0];
        _currentTagId = model.tagId;
        
        [self loadTableDataWithRefresh:YES isClearData:YES];
    }else{
        WS(weakSelf);
        NoDataNoticeView *noticeView = [NoDataNoticeView noticeViewWithFrame:CGRectMake(0, HEIGHT_TOP_BAR, kScreenWidth, kScreenHeight-HEIGHT_TOP_BAR-HEIGHT_TAB_BAR) bgColor:[UIColor whiteColor] message:@"内容还在采集，请等等再来。" promptStyle:NoDataPromptStyleClickRefreshForNoContent  callbackBlock:^(id object, NSInteger index, BOOL isSameIndex) {
            [weakSelf checkSelectTagViewData];
        }];
        [self.view addSubview:noticeView];
    }
}


- (void)updateErrorNoticeViewWithStyle:(NoDataPromptStyle)style message:(NSString *)msg {
    if ([WebSDKService currentNetworkState] == NotReachable) {
        style = NoDataPromptStyleClickRefreshForNoNetwork;
    }
    
    MYTableView *tableView = [self.bgTableView getCurrentShowTableView];
    if (tableView) {
        tableView.promptStyle = style;
        tableView.errorMsg = msg;
    }
}


- (void)scrollToTop {
    [self.bgTableView tableViewScrollToTop:YES];
}


- (void)re_InitDataListArray:(NSInteger)count {
    NSInteger maxCount = MAX(count, _dataList.count);
    for (int i = 0; i < maxCount; i++) {
        if (i < count) {
            if (i < _dataList.count) {
                for (int j = 0; j < 3; j++) {
                    [_dataList[i][j] removeAllObjects];
                }
            }else {
                NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:3];
                for (int j = 0; j < 3; j++) {
                    [tmpArray addObject:[NSMutableArray arrayWithCapacity:0]];
                }
                [_dataList addObject:tmpArray];
            }
        }else {
            [_dataList removeLastObject];
        }
    }
}



// 定位授权状态发生变化
- (void)userLocationAuthStatusDidChange:(NSNotification *)noti {
    NSNumber *status = noti.object;
    if (status && [status isKindOfClass:[NSNumber class]]) {
        CLAuthorizationStatus authStatus = [status intValue];
        if (authStatus == kCLAuthorizationStatusAuthorizedWhenInUse || authStatus == kCLAuthorizationStatusAuthorizedAlways) {
            WS(weakSelf)
            WEAK_VIEW(_mapView)
            [[LocationService2 sharedService] beginOnceLocationWithCompletion:^(MYLocationModel *location, NSString *errorMsg) {
                CLLocationCoordinate2D coords = location.location.coordinate;
                
                MKCoordinateSpan span = MKCoordinateSpanMake(0.5, 0.5);
                [weakView setRegion:MKCoordinateRegionMake(coords, span) animated:NO];
                if (isShowMap) {
                    [weakSelf loadNearbyData];
                }
            }];
        }
    }
}


#pragma mark -

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    FBLOG(@"内存警告：%@",self.class);
    
    if (_mapView && isShowMap == NO)
    {
        _mapView.delegate = nil;
        [_mapView removeFromSuperview];
        _mapView = nil;
    }
}

@end

