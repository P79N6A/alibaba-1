//
//  VenueListViewController.m
//  CultureHongshan
//
//  Created by ct on 16/4/14.
//  Copyright © 2016年 CT. All rights reserved.
//

#import "VenueListViewController.h"

// View Controllers
#import "ActivityListViewController.h"
#import "SearchActivityViewController.h" // 搜索页面
#import "VenueDetailViewController.h"
#import "HomepageViewController.h"
#import "WebViewController.h"

// Views
#import "DropDownView.h"//筛选视图
#import "TagSelectScrollView.h"
#import "VenueListCell.h"


//Model类
#import "ActivityFilterModel.h"
#import "SearchTag.h"
#import "VenueModel.h"
#import "AdvertModel.h"
#import "CultureSpacingTagModel.h"

// Other
#import "UserDataCacheTool.h"
#import "WebSDKService.h"
#import <MapKit/MapKit.h>
#import "MJRefresh.h"
#import "UIWebView+TS_JavaScriptContext.h"
#import "LocationService2.h"

#define TAG_ANNOTATIONBASE 1000
#define TAG_TITLELABEL     1941
#define TAG_DATELABEL      1942
#define TAG_PRICELABEL     1943
#define TAG_LOCATIONLABEL  1944
#define TAG_DISLABEL       1945


#define ARRAY_INDEX_VENUE_LIST   0


static NSString *reuseID_Cell    = @"VenueListCell";
static NSString *reuseID_AdvCell = @"AdvertCell";

@interface VenueListViewController ()<MKMapViewDelegate, UIScrollViewDelegate, TagSelectScrollViewDelegate, DropdownViewDelegate>
{
    WebSDKService *_sdkService; // App 与 H5 交互的接口
    
    CGFloat _scrollPosition; // collectionView 左右滑动的位置
    NSInteger _lastSelectedListIndex; // 由列表页切换到地图模式时，列表页的index
    BOOL _isNavAnimating;
    
    JSContext *_jsContext;
    
    FBButton *_navView;// 导航条
    
    NSMutableArray *_nearbyArray; // 附近场馆数据
    NSMutableArray *_topAdvertArray; // 顶部的广告位数据（不随标签进行切换）
    
    DropdownView *_areaDropdown;//商圈
    DropdownView *_smartDropdown;//智能排序
    DropdownView *_filterDropdown;//筛选
    
    TagSelectScrollView *_tagSelectView;//标签选择
    
    //地图
    MKMapView * _mapView;
    BOOL _isShowMap;
    NSMutableArray * annotationAry;
    __weak MKAnnotationView * _lastSelectedAnnotationView;
    FBButton * _bottomViewButton;
    UIView * bottomView;
    
    NSString * _selectedOrder;
    NSString * _selectedFilter;
    NSString * _selectedArea;
    
    NSString *_currentTagId;//当前选中的文化空间分类标签Id （不保存外链的url地址）
}
@property (nonatomic, strong) NSArray *screenshotImages;
@property (nonatomic, strong) UIView *filterView;
@end

/*
 _dataList的数据结构:
   _dataList = @[
                  @[
                      @[venueModel, venueModel, ...], // 场馆列表数组
                  ],
                  @[
                      @[venueModel, venueModel, ...], // 场馆列表数组
                  ],
                  ...
              ];
 */


@implementation VenueListViewController


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:WHYLocationAuthStatusDidChangeNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (_mapView) {
        _mapView.delegate = nil;
    }
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    // 登录成功返回 或 退出登录 返回到该页面时，重新setSdkFunction。否则H5获取到的userId不正确
    if ([self cellTypeForIndex:self.bgTableView.currentIndex] == TableViewCellTypeWebView) {
        [[self.bgTableView getCurrentShowWebView] setSdkFunction];
    }
    
    if (_mapView && !_mapView.delegate) {
        _mapView.delegate = self;
    }
    
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
    [self re_InitDataListArray:1];
    _sdkService = [WebSDKService new];
    _sdkService.sourceVC = self;
    
    _currentTagId = @"";
    annotationAry   = [NSMutableArray new];
    _nearbyArray    = [NSMutableArray new];
    _topAdvertArray = [NSMutableArray new];
    
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

#pragma mark - 初始化视图

- (void)initNavigationBar
{
    WS(weakSelf);
    _navView = [[FBButton alloc] initWithText:CGRectMake(0, 0, kScreenWidth, HEIGHT_TOP_BAR) font:nil fcolor:nil bgcolor:kNavigationBarColor text:nil clickEvent:^(FBButton *owner) {
        [weakSelf.bgTableView tableViewScrollToTop:YES];
    }];
    _navView.animation = NO;
    [self.view addSubview:_navView];
    
    //中间的标题
    FBLabel *titleLabel = [[FBLabel alloc] initWithStyle:MRECT(0, HEIGHT_STATUS_BAR+10, kScreenWidth, HEIGHT_NAVIGATION_BAR) font:FONT(20) fcolor:COLOR_IWHITE text:@"文化空间"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [_navView addSubview:titleLabel];
    
    //左侧的地图按钮
    WEAK_VIEW(titleLabel);
    
    FBButton *mapButton = [[FBButton alloc] initWithImage:MRECT(10, HEIGHT_STATUS_BAR, HEIGHT_NAVIGATION_BAR , HEIGHT_NAVIGATION_BAR) bgcolor:COLOR_CLEAR img:IMG(@"icon_maptop") clickEvent:^(FBButton *owner) {
        
        if (_isNavAnimating) {
            return;
        }
        
        if(_isShowMap)//列表模式
        {
            _isShowMap = NO;
            
            weakView.text = @"文化空间";
            _filterView.hidden = [weakSelf cellTypeForIndex:weakSelf.bgTableView.currentIndex] != TableViewCellTypeTableView;
            _tagSelectView.hidden = NO;
            weakSelf.bgTableView.hidden = NO;
            _mapView.hidden  = YES;
            [owner setImage:IMG(@"icon_maptop") forState:UIControlStateNormal];
            
            //由 地图模式 切换回 列表模式 时，如果列表页的数据为空，需要重新请求列表数据
            if ([_dataList[weakSelf.bgTableView.currentIndex][ARRAY_INDEX_VENUE_LIST] count] < 1) {
                [weakSelf loadTableDataWithRefresh:NO isClearData:YES forIndex:weakSelf.bgTableView.currentIndex];
            }
        }
        else//地图模式
        {
            _isShowMap = YES;
            weakView.text = @"附近";
            
            if(_mapView == nil)
            {
                [weakSelf initMapView];
                [weakSelf loadNearbyData:YES];
            }else {
                if ([LocationService2 isAllowLocating] == NO) {
                    [SVProgressHUD showInfoWithStatus:@"定位服务不可用，无法获取附近的数据！"];
                }else {
                    [weakSelf loadNearbyData:YES];
                }
            }
            _filterView.hidden = YES;
            _tagSelectView.hidden = YES;
            weakSelf.bgTableView.hidden = YES;
            _mapView.hidden  = NO;
            [owner setImage:IMG(@"icon_list") forState:UIControlStateNormal];
        }
        
        for (UIView *subView in weakSelf.view.subviews) {
            if ([subView isKindOfClass:[NoDataNoticeView class]]) {
                subView.hidden = _isShowMap;
            }
        }
    }];
    [_navView addSubview:mapButton];
    
    //右侧的搜索
    FBButton *searchButton = [[FBButton alloc] initWithImage:MRECT(kScreenWidth-50,HEIGHT_STATUS_BAR,HEIGHT_NAVIGATION_BAR , HEIGHT_NAVIGATION_BAR) bgcolor:COLOR_CLEAR img:IMG(@"放大镜") clickEvent:^(FBButton *owner) {
        SearchActivityViewController *vc = [[SearchActivityViewController alloc] initWithSearchType:SearchTypeVenue];//场馆搜索
        [weakSelf.navigationController pushViewController:vc animated:NO];
    }];
    [_navView addSubview:searchButton];
}

/**
 *  初始化空间标签选择视图
 */
- (void)initTagSelectView
{
    _tagSelectView = [[TagSelectScrollView alloc] initWithFrame:CGRectMake(0, _navView.maxY, kScreenWidth, 49) autolayout:NO];
    _tagSelectView.delegate = self;
    [_tagSelectView hiddenAddButton];
    [self.view addSubview:_tagSelectView];
    
    WS(weakSelf)
    [_tagSelectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.view);
        make.height.mas_equalTo(49);
        make.top.mas_equalTo(HEIGHT_TOP_BAR);
    }];
}

/**
 *  获取半透明黑色的筛选条视图
 */
- (UIView *)filterView
{
    if (_tagSelectView.titleArray.count < 1) {
        [_filterView removeFromSuperview];
        _filterView = nil;
        return nil;
    }
    
    if (_filterView) {
        [self.view bringSubviewToFront:_filterView];
        return _filterView;
    }
    
    _filterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 30)];
    _filterView.backgroundColor = RGBA(0x2e, 0x2e, 0x2e,0.75);
    _filterView.alpha = 0.9;
    _filterView.radius = 10;
    [self.view addSubview:_filterView];
    
    _areaDropdown = [[DropdownView alloc] initWithArray:MRECT(3, 0, 87, 30) title:@"全部商圈" dataList:[DictionaryService getArea] delegate:self];
    [_filterView addSubview:_areaDropdown];
    
    UIImageView * line1 = [[UIImageView alloc] initWithFrame:MRECT(90, 8, 2, 14)];
    line1.image = IMG(@"line_filter_bar");
    [_filterView addSubview:line1];
    
    _smartDropdown = [[DropdownView alloc] initWithArray:MRECT(91, 0, 90, 30) title:@"智能排序" dataList:[DictionaryService getSmartOrderArrayOfVenue] delegate:self];
    [_filterView addSubview:_smartDropdown];
    
    UIImageView * line2 = [[UIImageView alloc] initWithFrame:MRECT(182, 8, 2, 14)];
    line2.image = IMG(@"line_filter_bar");
    [_filterView addSubview:line2];
    
    _filterDropdown = [[DropdownView alloc] initWithArray:MRECT(181, 0, 66, 30) title:@"筛选" dataList:[DictionaryService getFilterArrayOfVenue]  delegate:self];
    [_filterView addSubview:_filterDropdown];
    
    
    WS(weakSelf);
    CGFloat position = [self calculateFilterViewPosition];
    [_filterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(@(position));
        make.height.equalTo(@30);
        make.width.equalTo(@250);
    }];
    
    
    return _filterView;
}


/**
 *  初始化地图
 */
- (void)initMapView
{
    _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, _navView.maxY, kScreenWidth, kScreenHeight-HEIGHT_TAB_BAR-_navView.maxY)];
    _mapView.hidden = YES;
    _mapView.delegate = self;
    _mapView.mapType = MKMapTypeStandard;
    _mapView.showsUserLocation = YES;
    
    CLLocationCoordinate2D coords = [LocationService2 sharedService].location.location.coordinate;
    
    MKCoordinateSpan span = MKCoordinateSpanMake(0.5, 0.5);
    [_mapView setRegion:MKCoordinateRegionMake(coords, span) animated:NO];
    
    [self.view addSubview:_mapView];
    
    [self initViewOnMapBottom];
}

/**
 *  地图底部的弹出视图：展示选中场馆的有关信息
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
        make.top.equalTo(weakMapView.mas_bottom).offset(-82);
        make.height.equalTo(@82);
    }];
    
    //分割线
    MYMaskView * line = [MYMaskView maskViewWithBgColor:COLOR_GRAY_LINE frame:CGRectZero radius:0];
    [bottomView addSubview:line];
    __weak UIView * weakView = bottomView;
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(weakView);
        make.height.equalTo(@.5);
        make.left.equalTo(weakView.mas_left).offset(10);
        make.top.equalTo(@42);
    }];
    
    FBLabel * titleLabel = [[FBLabel alloc] initWithStyle:MRECT(10, 12, WIDTH_SCREEN-20, 20) font:FONT(18) fcolor:COLOR_IBLACK text:@""];
    titleLabel.tag = TAG_TITLELABEL;
    [bottomView addSubview:titleLabel];
    
    UIImageView * locationImage = [[UIImageView alloc] initWithFrame:MRECT(10, 54, 12, 17)];
    locationImage.image = IMG(@"icon_mapon");
    [bottomView addSubview:locationImage];
    
    FBLabel * locationLabel = [[FBLabel alloc] initWithStyle:MRECT(26, 56, 240, 20) font:FONT(14) fcolor:kLightLabelColor text:@""];
    locationLabel.tag = TAG_LOCATIONLABEL;
    [bottomView addSubview:locationLabel];
    
    FBLabel * distanceLabel = [[FBLabel alloc] initWithStyle:CGRectZero font:FONT(14) fcolor:kLightLabelColor text:@"－－"];
    distanceLabel.tag = TAG_DISLABEL;
    distanceLabel.textAlignment = NSTextAlignmentRight;
    [bottomView addSubview:distanceLabel];
    [distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(locationLabel);
        make.right.equalTo(weakView.mas_right).offset(-10);
    }];
    
    UIImageView * distanceImage = [UIImageView new];
    distanceImage.image = IMG(@"icon_距离");
    [bottomView addSubview:distanceImage];
    [distanceImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(distanceLabel.mas_left).offset(-3);
        make.centerY.equalTo(distanceLabel);
        make.size.mas_equalTo(CGSizeMake(10, 11));
    }];
}

#pragma mark - 数据请求

/**
 *  加载广告位数据
 */
- (void)loadAdvertData:(BOOL)isRefresh
{
    [self startRequestTopAdvertData:isRefresh];
}

//顶部的广告
- (void)startRequestTopAdvertData:(BOOL)isRefresh
{
    WS(weakSelf);
    
    [AppProtocol getAppAdvertListWithAdvertPosition:3 advertType:@"A" cacheMode:isRefresh ? CACHE_MODE_REALTIME : CACHE_MODE_HALFREALTIME_SHORT UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        if (responseCode == HttpResponseSuccess) {
            [_topAdvertArray removeAllObjects];
            [_topAdvertArray addObjectsFromArray:responseObject];
            
            [weakSelf.bgTableView reloadDataForIndex:weakSelf.bgTableView.currentIndex];
        }
    }];
}

/**
 *  加载附近的场馆数据
 */
- (void)loadNearbyData:(BOOL)isRefresh
{
    if ([self checkLocatingAuthorization] == NO && _isShowMap) {
        return;
    }
    
    NSInteger pageIndex = 0;
    if (_nearbyArray.count && isRefresh == NO) {
        pageIndex = _nearbyArray.count;
    }
    
    EnumCacheMode cacheMode = isRefresh ? CACHE_MODE_REALTIME : CACHE_MODE_HALFREALTIME_SHORT;
    
    WS(weakSelf);
    [AppProtocol getVenueListWithAppType:@"1" venueName:nil venueArea:nil venueType:nil venueCrowd:nil pageIndex:pageIndex pageNum:kRefreshCount cacheMode:cacheMode UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        
        [SVProgressHUD dismiss];
        
        if (responseCode == HttpResponseSuccess) {
            NSArray * ary = (NSArray *)responseObject;
            if (isRefresh) {
                [_nearbyArray removeAllObjects];
            }
            [_nearbyArray addObjectsFromArray:ary];
        }else {
            [SVProgressHUD showInfoWithStatus:(NSString *)responseObject];
        }
        
        if(_isShowMap) {
            [weakSelf initMapData];
        }
    }];
}

- (void)loadTableDataWithRefresh:(BOOL)isRefresh isClearData:(BOOL)isClearData forIndex:(NSInteger)index
{
    if ([self cellTypeForIndex:index] != TableViewCellTypeTableView) {
        return;
    }
    
    NSDictionary *areaDic = [DictionaryService getAreaCode:_selectedArea];
    NSDictionary *dict = @{@"venueType":_currentTagId.length ? _currentTagId : @"",
                           @"venueArea":areaDic[@"activityArea"],
                           @"venueLocation":areaDic[@"activityLocation"],
                           @"sortType":[DictionaryService getSmartOrderValueOfVenue:_selectedOrder],
                           @"reserveType":[DictionaryService getFilterValueOfVenue:_selectedFilter],
                           };
    

    if ([_dataList[index][ARRAY_INDEX_VENUE_LIST] count] < 1) {
        isRefresh = YES;
    }

    NSInteger pageIndex = 0;
    if (isRefresh == NO && isClearData == NO) {
        pageIndex = [_dataList[index][ARRAY_INDEX_VENUE_LIST] count];
        // for (int i = 0; i < [_dataList[index][ARRAY_INDEX_VENUE_LIST] count]; i++) {
        //     if ([_dataList[index][ARRAY_INDEX_VENUE_LIST][i] isKindOfClass:[VenueModel class]]) {
        //         pageIndex += 1;
        //     }
        // }
    }
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showLoading];
    
    WS(weakSelf);
    EnumCacheMode cacheMode = isRefresh ? CACHE_MODE_REALTIME : CACHE_VALID_TIME_SHORT;
    
    [AppProtocol getVenueFilterListWithVenueType:dict[@"venueType"]
                                       venueArea:dict[@"venueArea"]
                                   venueLocation:dict[@"venueLocation"]
                                        sortType:dict[@"sortType"]
                                  venueIsReserve:dict[@"reserveType"]
                                       pageIndex:pageIndex
                                         pageNum:10
                                       cacheMode:cacheMode
                                      UsingBlock:^(HttpResponseCode responseCode, id responseObject)
    {
        
        [weakSelf.bgTableView removeNoticeView];
        [weakSelf.bgTableView endHeaderRefresh];
        [weakSelf.bgTableView endFooterRefresh];
        
        if (responseCode == HttpResponseSuccess)
        {
            BOOL switchTag = NO;
            if (isRefresh) { // 下拉刷新
                [weakSelf loadAdvertData:YES];
                [_dataList[index][ARRAY_INDEX_VENUE_LIST] removeAllObjects];
                [_dataList[index][ARRAY_INDEX_VENUE_LIST] addObjectsFromArray:responseObject];
            }else {
                if (isClearData) { // 切换Tag
                    [weakSelf loadAdvertData:NO];
                    [_dataList[index][ARRAY_INDEX_VENUE_LIST] removeAllObjects];
                    [_dataList[index][ARRAY_INDEX_VENUE_LIST] addObjectsFromArray:responseObject];
                }else { // 加载更多
                    if ([_dataList[index][ARRAY_INDEX_VENUE_LIST] count] && [responseObject count] < 1) {
                        [SVProgressHUD showInfoWithStatus:@"没有更多数据啦^_^"];
                        return;
                    }
                    [_dataList[index][ARRAY_INDEX_VENUE_LIST] addObjectsFromArray:responseObject];
                }
                
            }
            
            _filterView.hidden = [weakSelf cellTypeForIndex:index] != TableViewCellTypeTableView;
            
            
            if ([_dataList[index][ARRAY_INDEX_VENUE_LIST] count] < 1) {
                if ([weakSelf cellTypeForIndex:weakSelf.bgTableView.currentIndex] == TableViewCellTypeTableView) {
                    [weakSelf updateFilterViewPosition];
                }
                [weakSelf.bgTableView updateTableStatusForNoData:@"内容还在采集，请等等再来。" withBlock:^(id object, NSInteger index, BOOL isSameIndex) {                     [weakSelf loadTableDataWithRefresh:YES isClearData:YES forIndex:index];
                }];
            }
            
            if (switchTag || isRefresh) {
                [weakSelf.bgTableView tableViewScrollToTop:YES];
            }
            
            if (index == weakSelf.bgTableView.currentIndex) {
                [weakSelf.bgTableView reloadDataForIndex:weakSelf.bgTableView.currentIndex];
            }
            
            // 请求场馆的附加信息
            if ([responseObject count]) {
                [weakSelf loadVenueAdditionalInfoWithModelArray:responseObject index:index];
            }
            
            [SVProgressHUD dismiss];
        }
        else
        {
            if ([responseObject isKindOfClass:[NSString class]])
            {
                if ([_dataList[index][ARRAY_INDEX_VENUE_LIST] count] == 0) {
                    [weakSelf.bgTableView updateTableStatusForNoData:responseObject withBlock:^(id object, NSInteger index, BOOL isSameIndex) {
                        [weakSelf loadTableDataWithRefresh:YES isClearData:YES forIndex:index];
                    }];
                    [SVProgressHUD dismiss];
                }else{
                    [SVProgressHUD showErrorWithStatus:responseObject];
                }
            }
        }
        
    }];
}


/**
 *  @brief 请求场馆的附加信息
 *
 *  每次只能请求一个场馆
 */
- (void)loadVenueAdditionalInfoWithModelArray:(NSArray *)modelArray index:(NSInteger)index
{
    NSString *venueIdString = [VenueModel getAllVenueIdStringWithListArray:modelArray];
    if (venueIdString.length < 1) {
        return;
    }
    NSArray *venueIdArray = [ToolClass getComponentArray:venueIdString separatedBy:@","];
    
    WS(weakSelf);
    for (int i = 0; i < venueIdArray.count; i++) {
        
        [AppProtocol getVenueAdditionalInfoWithVenueId:venueIdArray[i] UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
            if (responseCode == HttpResponseSuccess) {
                [VenueModel getMatchedModelWithVenueModelArray:_dataList[index][ARRAY_INDEX_VENUE_LIST] subModelDict:responseObject];
                if (index == weakSelf.bgTableView.currentIndex) {
                    [weakSelf.bgTableView reloadDataForIndex:index];
                }
            }else {
                FBLOG(@"获取活动的附件信息失败");
            }
        }];
    }
}


-(void)initMapData
{
    if ([self checkLocatingAuthorization] == NO && _isShowMap) {
        return;
    }
    
    self.filterView.hidden = YES;
    _tagSelectView.hidden = YES;
    
    
    if (annotationAry && annotationAry.count > 0)
    {
        [_mapView removeAnnotations:annotationAry];
        [annotationAry removeAllObjects];
        if(bottomView)
        {
            bottomView.hidden = YES;
        }
    }
    
    for (int i = 0 ; i < _nearbyArray.count && i < 25; i++)
    {
        if ([_nearbyArray[i] isKindOfClass:[VenueModel class]] == NO) {
            return;
        }
        
        VenueModel * model = _nearbyArray[i];
        FBMapAnnotation * annoation = [FBMapAnnotation new];
        CLLocationCoordinate2D point;
        point.latitude = [model.venueLat floatValue];
        point.longitude = [model.venueLon floatValue];
        annoation.title = model.venueName;
        annoation.index = TAG_ANNOTATIONBASE+i;
        [annoation setCoordinate:point];
        [annotationAry addObject:annoation];
        [_mapView addAnnotation:annoation];
    }
    
    CLLocationCoordinate2D coords = [LocationService2 sharedService].location.location.coordinate;
    MKCoordinateSpan span = MKCoordinateSpanMake(0.05, 0.05);
    [_mapView setRegion:MKCoordinateRegionMake(coords, span) animated:YES];
}



#pragma mark - ———————————— UITableView DataSource And Delegate ————————————

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return _topAdvertArray.count > 2 && [_dataList[tableView.tag][ARRAY_INDEX_VENUE_LIST] count] ? 1 : 0;
    }else if (section == 1) {
        return [_dataList[tableView.tag][ARRAY_INDEX_VENUE_LIST] count];
    }
    return 0;
}

- (UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID_AdvCell forIndexPath:indexPath];
        cell.contentView.backgroundColor = RGB(230, 230, 230);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        for (int i = 0; i < _topAdvertArray.count && i < 3; i++) {
            
            CGRect frame = CGRectZero;
            if (i == 0) {
                frame = CGRectMake(0, 0, kScreenWidth, ConvertSize(250));
            }else{
                CGFloat lineWidth = 0.6;
                frame = CGRectMake((i-1)*(kScreenWidth*0.5+lineWidth*0.5), ConvertSize(250)+lineWidth, kScreenWidth*0.5-lineWidth*0.5, cell.height-6-ConvertSize(250)-1);
            }
            
            AdvertModel *model = _topAdvertArray[i];
            WS(weakSelf);
            FBButton *button = [[FBButton alloc] initWithImage:frame bgcolor:COLOR_IWHITE img:nil clickEvent:^(FBButton *owner) {
                [weakSelf goToAdvertPage:model shareImage:owner.currentImage];
            }];
            button.animation = NO;
            UIImage *placeImg = [UIToolClass getPlaceholderWithViewSize:button.viewSize centerSize:CGSizeMake(20, 20) isBorder:NO];
            [button sd_setImageWithURL:[NSURL URLWithString:JointedImageURL(model.advImgUrl, i > 0 ? @"_750_310" : kImageSize_BigAdv)] forState:UIControlStateNormal placeholderImage:placeImg];
            [cell.contentView addSubview:button];
        }
        
        return cell;
    }else if (indexPath.section == 1) {
        if (![ToolClass dataIsValid:indexPath.row forArrayCount:[_dataList[tableView.tag][ARRAY_INDEX_VENUE_LIST] count]]) {
            RETURN_BLANK_CELL
        }

        if ([_dataList[tableView.tag][ARRAY_INDEX_VENUE_LIST][indexPath.row] isKindOfClass:[AdvertModel class]]){
            
            AdvertModel *model = _dataList[tableView.tag][ARRAY_INDEX_VENUE_LIST][indexPath.row];
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID_AdvCell forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];//移除之前的视图
            cell.contentView.backgroundColor = [UIColor whiteColor];
            
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ConvertSize(250))];
            UIImage *placeImg = [UIToolClass getPlaceholderWithViewSize:imgView.viewSize centerSize:CGSizeMake(20, 20) isBorder:NO];
            [imgView sd_setImageWithURL:[NSURL URLWithString:JointedImageURL(model.advImgUrl, kImageSize_BigAdv)] placeholderImage:placeImg];
            [cell.contentView addSubview:imgView];
            
            MYMaskView *line = [MYMaskView maskViewWithBgColor:kBgColor frame:CGRectMake(0, imgView.maxY, kScreenWidth, cell.height-imgView.maxY) radius:0];
            [cell.contentView addSubview:line];
            
            return cell;
        }else{
            VenueListCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID_Cell forIndexPath:indexPath];
            [cell setModel:_dataList[tableView.tag][ARRAY_INDEX_VENUE_LIST][indexPath.row] forIndexPath:indexPath];
            
            return cell;
        }
    }else {
        RETURN_BLANK_CELL
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        // 顶部三个广告都有，且场馆列表不为空时
        return (_topAdvertArray.count > 2 && [_dataList[tableView.tag][ARRAY_INDEX_VENUE_LIST] count]) ? 1+ConvertSize(250+155)+6 : 0.01;
    }else {
        
        if ([ToolClass dataIsValid:indexPath.row forArrayCount:[_dataList[tableView.tag][ARRAY_INDEX_VENUE_LIST] count]]) {
            
            if ([_dataList[tableView.tag][ARRAY_INDEX_VENUE_LIST][indexPath.row] isKindOfClass:[AdvertModel class]]) {
                return ConvertSize(250)+7.5;
            }else {
                return kScreenWidth*kPicScale_ListCover+8;
            }
        }
    }
    
    return 0.01;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (fabs(_scrollPosition - self.bgTableView.currentIndex) == 0 ) {
        if ([indexPath compare:[self getTargetCellIndexPath]] == NSOrderedSame) {
            
            CGRect rect = [cell convertRect:cell.contentView.frame toView:[UIApplication sharedApplication].keyWindow];
            
            CGFloat position = 0;
            if (rect.origin.y > _tagSelectView.maxY) {
                //第一个场馆cell已经出现时，直接设定值
                position = rect.origin.y+16;
            }else {
                position = MIN(MAX(rect.origin.y+16, _tagSelectView.maxY+16), kScreenHeight-50-self.filterView.height-30);
            }
            
            [self.filterView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(@(position));
            }];
            
            [self.filterView layoutIfNeeded];
        }
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!(indexPath.section == 1 &&  [_dataList[tableView.tag][ARRAY_INDEX_VENUE_LIST] count])) {
        return;
    }
    
    if ([ToolClass dataIsValid:indexPath.row forArrayCount:[_dataList[tableView.tag][ARRAY_INDEX_VENUE_LIST] count]])
    {
        id obj = _dataList[tableView.tag][ARRAY_INDEX_VENUE_LIST][indexPath.row];
        if ([obj isKindOfClass:[VenueModel class]])
        {
            VenueModel *model = (VenueModel *)obj;
            if (model.venueId.length > 0) {
                UIWindow *window = [UIApplication sharedApplication].keyWindow;
                UIImage *screenShotImg = [UIToolClass getScreenShotImageWithSize:CGSizeMake(kScreenWidth, kScreenHeight) views:@[window] isBlurry:NO];
                
                VenueListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                CGRect frame = [cell.contentView convertRect:cell.contentView.frame toView:window];
                UIImageView * imageV = [cell getImageView];
                
                CGFloat topHeight = MIN(MAX(CGRectGetMaxY(frame)-8, _tagSelectView.maxY), kScreenHeight-50);
                self.screenshotImages = [ToolClass getTwoScreenShotsWithImage:screenShotImg topHeight:topHeight headimg:imageV];
                
                VenueDetailViewController *vc = [VenueDetailViewController new];
                vc.venueId = model.venueId;
                vc.screenshotImages = self.screenshotImages;
                [self.navigationController pushViewController:vc animated:NO];
            } else if ([obj isKindOfClass:[AdvertModel class]]) {
                AdvertModel *model = (AdvertModel *)obj;
                UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                UIImage *image = ((UIImageView *)cell.contentView.subviews[0]).image;
                [self goToAdvertPage:model shareImage:image];
            }
        }
    }
}



#pragma mark - ————————————   其它代理方法   ————————————

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self shrinkAllDropDown];
    
    CGFloat offsetY = scrollView.contentOffset.y;
    if ( !(offsetY < 0 && [self getTargetCell] == nil) && [scrollView isKindOfClass:[UITableView class]]) {
        [self updateFilterViewPosition];
    }
    
    if (_isNavAnimating) return;
    if ([scrollView isKindOfClass:[UITableView class]]) {
        if (scrollView.tag != self.bgTableView.currentIndex) {
            return;
        }
    }
    
    if ( offsetY >= scrollView.contentSize.height-scrollView.height || offsetY < 10 ) {
        _preOffsetY = offsetY;
        return;
    }
    
    // 导航条的动画
    if (_preOffsetY > offsetY) {
        [self navViewAnimation:YES];//出现
    }else {
        if (offsetY - _beginDragOffsetY > 10) {
            [self navViewAnimation:NO];// 消失
        }
    }
    _preOffsetY = offsetY;

}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    _filterView.userInteractionEnabled = NO;
    _beginDragOffsetY = scrollView.contentOffset.y;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    _filterView.userInteractionEnabled = YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _filterView.userInteractionEnabled = YES;
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
        
        VenueModel * model = _nearbyArray[view.tag - TAG_ANNOTATIONBASE];
        [self updateBottomView:model];
    }
}

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


- (void)dropdownView:(DropdownView *)services result:(NSString *)result
{
    BOOL haveChange = NO;
    if(services == _areaDropdown  && ![_selectedArea isEqualToString:result])
    {
        haveChange = YES;
        _selectedArea = result;
    }
    else if(services == _smartDropdown  && ![_selectedOrder isEqualToString:result])
    {
        haveChange = YES;
        _selectedOrder = result;
    }
    else if(services == _filterDropdown   && ![_selectedFilter isEqualToString:result])
    {
        haveChange = YES;
        _selectedFilter = result;
    }
    
    if (haveChange)
    {
        [self loadTableDataWithRefresh:NO isClearData:YES forIndex:self.bgTableView.currentIndex];
    }
}

// CommonMultiTableViewDelegate

- (void)tableViewSetting:(UITableView *)tableView forIndex:(NSInteger)index
{
    [tableView registerClass:[VenueListCell class] forCellReuseIdentifier:reuseID_Cell];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:reuseID_AdvCell];
    
    WS(weakSelf);
    [CommonMultiTableViewController setupRefresh:tableView withBlock:^(BOOL isRefresh) {
        if (isRefresh) {
            [weakSelf loadAdvertData:isRefresh];
        }
        [weakSelf loadTableDataWithRefresh:isRefresh isClearData:isRefresh forIndex:weakSelf.bgTableView.currentIndex];
    }];
}

- (void)webViewSetting:(UIWebView *)webView forIndex:(NSInteger)index
{
    if (webView.scrollView.header) {
        return;
    }
    
    WEAK_VIEW(webView);
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakView reload];
    }];
    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"释放刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"文化生活加载中..." forState:MJRefreshStateRefreshing];
    header.stateLabel.font = FONT(14);
    header.lastUpdatedTimeLabel.font = FONT(12);
    header.stateLabel.textColor = kLightLabelColor;
    header.lastUpdatedTimeLabel.textColor = kLightLabelColor;
    webView.scrollView.header = header;
}

- (void)tableViewDidEndScrollToIndex:(NSInteger)index forCell:(UICollectionViewCell *)cell
{
    if (index == self.bgTableView.currentIndex){
        return;
    }
    
    [_tagSelectView moveToIndex:index];
    if ([self cellTypeForIndex:index] != TableViewCellTypeTableView) {
        self.filterView.hidden = YES;
    }else {
        self.filterView.hidden = NO;
    }
}

- (void)tableViewDidScrollHorizontally:(CGFloat)position
{
    _scrollPosition = position;
    NSUInteger index = [ToolClass getNearestInteger:position];
    self.filterView.hidden = ([self cellTypeForIndex:index] != TableViewCellTypeTableView);
}

- (NSString *)webViewUrlForIndex:(NSInteger)index
{
    if (index < _tagSelectView.titleArray.count && index >= 0) {
        CultureSpacingTagModel *model = _tagSelectView.titleArray[index];
        if (model.tagIsOuterLink) {
            return model.tagId;
        }
    }
    return @"";
}


- (TableViewCellType)cellTypeForIndex:(NSInteger)index
{
    if (index < _tagSelectView.titleArray.count && index >= 0) {
        CultureSpacingTagModel *model = _tagSelectView.titleArray[index];
        if (model.tagIsOuterLink) {
            return TableViewCellTypeWebView;
        }else{
            return TableViewCellTypeTableView;
        }
    }else{
        return TableViewCellTypeUnknown;
    }
}


- (void)willShowContentView:(UIView *)contentView {
    if ([contentView isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)contentView;
        tableView.contentInset = UIEdgeInsetsMake(_tagSelectView.originalY > 25 ? 44 : 0, 0, 0, 0);
        tableView.contentOffset = CGPointMake(0, -tableView.contentInset.top);
    }else if ([contentView isKindOfClass:[UIWebView class]]) {
        CGFloat positionY = _tagSelectView.originalY > 25 ? 44 : 0;
        [contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.and.bottom.equalTo(contentView.superview);
            make.top.mas_equalTo(positionY);
        }];
        
        [contentView.superview setNeedsLayout];
        [contentView.superview layoutIfNeeded];
        
        ((UIWebView *)contentView).scrollView.contentOffset = CGPointZero;
    }
}


- (void)tagSelectView:(TagSelectScrollView *)tagSelectView didSelectItem:(CultureSpacingTagModel *)model forIndex:(NSInteger)index
{
    _filterView.userInteractionEnabled = YES;
    
    if (self.bgTableView.currentIndex != index-2){// 两次点击的不是同一个标签
        [self clearAdvertData];
    }
    
    [self shrinkAllDropDown];
    
    
    [self.bgTableView tableViewChangeToIndex:index-2 animated:NO];
    
    
    if (model.tagIsOuterLink) {
        _filterView.hidden = YES;
        _mapView.hidden = YES;
        [self.bgTableView reloadDataForIndex:index-2];
        
    }else{
        
        if (model.tagId.length) { // 记录当前选中的空间分类标签ID
            _currentTagId = model.tagId;
        }
        
        _filterView.hidden = NO;
        if (_isShowMap) {
            _mapView.hidden = NO;
            [self loadNearbyData:YES];
        }else{
            _mapView.hidden = YES;
        }
        
        [self.bgTableView tableViewScrollToTop:YES];
        
        [self loadTableDataWithRefresh:NO isClearData:YES forIndex:index-2];
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.bgTableView startIndicatorAnimating];
}

- (void)webView:(UIWebView *)webView didCreateJavaScriptContext:(JSContext*) ctx;
{
    [webView setSdkFunction];
    
    ctx[kAppJsSDK] = _sdkService;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [webView.scrollView.header endRefreshing];
    
    [self.bgTableView stopIndicatorAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self.bgTableView stopIndicatorAnimating];
    if (error) {
        switch (error.code) {
            case NSURLErrorUnknown: {
                [SVProgressHUD showInfoWithStatus:@"出现未知错误!"];
            }
                break;
            case NSURLErrorCancelled: {
                //[SVProgressHUD showInfoWithStatus:@"出现未知错误!"];
            }
                break;
            case NSURLErrorBadURL: {
                [SVProgressHUD showInfoWithStatus:@"网络链接有误!"];
            }
                break;
            case NSURLErrorTimedOut: {
                [SVProgressHUD showInfoWithStatus:@"连接超时，请稍候再试!"];
            }
                break;
            case NSURLErrorNotConnectedToInternet: {
                [SVProgressHUD showInfoWithStatus:@"网络连接已断开，请检查网络!"];
            }
                break;
            default:
                break;
        }
    }
}


#pragma mark - ————————————   其它方法   ————————————

/**
 *  显示地图底部的弹出视图
 */
-(void)updateBottomView:(VenueModel *)model
{
    if (![model isKindOfClass:[VenueModel class]]) {
        return;
    }
    
    if(bottomView.hidden)
    {
        bottomView.hidden = NO;
        
        [UIView animateWithDuration:.5f animations:^{
            bottomView.originalY = _mapView.height-bottomView.height;
        }];
    }
    
    if (_bottomViewButton)
    {
        [_bottomViewButton removeFromSuperview];
        _bottomViewButton = nil;
    }
    
    WS(weakSelf);
    _bottomViewButton = [[FBButton alloc] initWithImage:bottomView.bounds bgcolor:COLOR_CLEAR img:nil clickEvent:^(FBButton *owner) {
        
        VenueDetailViewController *vc = [VenueDetailViewController new];
        vc.venueId = model.venueId;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    [bottomView addSubview:_bottomViewButton];
    
    {
        FBLabel * label = [bottomView viewWithTag:TAG_TITLELABEL];
        label.text = model.venueName;
    }
    {
        FBLabel * label = [bottomView viewWithTag:TAG_DATELABEL];
        label.text = @"日期";
    }
    {
        FBLabel * label = [bottomView viewWithTag:TAG_PRICELABEL];
        label.text = @"价格";
    }
    {
        FBLabel * label = [bottomView viewWithTag:TAG_LOCATIONLABEL];
        label.text = model.venueAddress;//
    }
    {
        FBLabel * label = [bottomView viewWithTag:TAG_DISLABEL];
        label.text = model.showedDistance;//model.distance
    }
}

-(BOOL)isPoiAnnotation:(MKAnnotationView *)annotationView
{
    if (annotationView.tag >= TAG_ANNOTATIONBASE) {
        return YES;
    }
    return NO;
}

/**
 *  导航条动画
 */
- (void)navViewAnimation:(BOOL)isShow
{
    if (_isShowMap) {
        _tagSelectView.originalY = HEIGHT_TOP_BAR;
        [self.bgTableView getCurrentShowTableView].contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
        [self updateFilterViewPosition];
        return;
    }
    
    CGFloat targetPositon = isShow ? HEIGHT_TOP_BAR : HEIGHT_STATUS_BAR;
    
    if (targetPositon == _tagSelectView.originalY) {
        return;
    }
    
    WS(weakSelf)
    [_tagSelectView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).offset(targetPositon);
    }];
    
    _isNavAnimating = YES;
    
    // 根据单元格的位置判断是否需要更新筛选条的竖直位置
    UITableViewCell *cell = [self getTargetCell];
    CGRect rect = [cell convertRect:cell.contentView.frame toView:[UIApplication sharedApplication].keyWindow];
    BOOL isMoveFilterView = YES;
    if (rect.origin.y > _tagSelectView.maxY || [self.bgTableView getCurrentShowTableView] == nil) {
        isMoveFilterView = NO;
    }
    
    UIWebView *webView = [self.bgTableView getCurrentShowWebView];
    if (webView) {
        CGFloat positionY = isShow ? 44 : 0;
        
        [webView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(webView.superview.mas_top).offset(positionY);
            make.left.right.and.bottom.equalTo(webView.superview);
        }];
    }
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        [weakSelf.view setNeedsLayout];
        [weakSelf.view layoutIfNeeded];
        
        if (isShow) {
            if (isMoveFilterView) {
                weakSelf.filterView.originalY += _tagSelectView.height-5;
            }
            [weakSelf.bgTableView getCurrentShowTableView].contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
        }else {
            if (isMoveFilterView) {
                weakSelf.filterView.originalY -= _tagSelectView.height-5;
            }
            [weakSelf.bgTableView getCurrentShowTableView].contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        }
        
        [webView.superview setNeedsLayout];
        [webView.superview layoutIfNeeded];
    } completion:^(BOOL finished) {
        _isNavAnimating = NO;
    }];
}

/**
 *  收起所有下拉表
 */
- (void)shrinkAllDropDown
{
    for (UIView * v in self.filterView.subviews)
    {
        if([v isKindOfClass:[DropdownView class]])
        {
            [(DropdownView *)v shrinkDropView];
        }
    }
}

- (BOOL)checkLocatingAuthorization
{
    CLAuthorizationStatus status= [CLLocationManager authorizationStatus];
    if ( (status != kCLAuthorizationStatusAuthorizedAlways && status != kCLAuthorizationStatusAuthorizedWhenInUse))//不允许定位
    {
        if ([ToolClass shouldNoticeUserAllowLocating])
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"无法获取到您的位置,请允许定位后再试吧" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            [ToolClass updateAllowLocatingNoticeStatus];
            return NO;
        } else  {
            return YES;
        }
    } else {
        return YES;
    }
}

/**
 *  标签出现更改时，更新空间标签选择视图
 */
- (void)checkSelectTagViewData
{
    for (UIView *subView in self.view.subviews) {
        if ([subView isKindOfClass:[NoDataNoticeView class]]) {
            [subView removeFromSuperview];
        }
    }
    
    _currentTagId = @"";
    [_tagSelectView updateSelectTagArray];
    _tagSelectView.canGoPreTag = NO;
    _tagSelectView.canGoNextTag = _tagSelectView.titleArray.count > 0 ? YES : NO;
    
    self.bgTableView.tableViewCount = _tagSelectView.titleArray.count;
    [self.bgTableView reloadData];
    [self.bgTableView tableViewChangeToIndex:0 animated:NO];
    
    
    if (_tagSelectView.titleArray.count) {

        [self re_InitDataListArray:_tagSelectView.titleArray.count]; // 重新初始化数组
        
        CultureSpacingTagModel *model = _tagSelectView.titleArray[0];
        _currentTagId = model.tagId;
        
        if ([self cellTypeForIndex:0] == TableViewCellTypeTableView) {
            [self loadTableDataWithRefresh:YES isClearData:YES forIndex:0];
        }else if ([self cellTypeForIndex:0] == TableViewCellTypeWebView) {
            [self.bgTableView reloadDataForIndex:0];
        }
    }else{
        WS(weakSelf);
        NoDataNoticeView *noticeView = [NoDataNoticeView noticeViewWithFrame:CGRectMake(0, HEIGHT_TOP_BAR, kScreenWidth, kScreenHeight-HEIGHT_TOP_BAR-HEIGHT_TAB_BAR) bgColor:[UIColor whiteColor] message:@"内容还在采集，请等等再来。" promptStyle:NoDataPromptStyleClickRefreshForNoContent  callbackBlock:^(id object, NSInteger index, BOOL isSameIndex) {
            [weakSelf checkSelectTagViewData];
        }];
        [self.view addSubview:noticeView];
    }
}

/**
 *  更新筛选条的位置
 */
- (void)updateFilterViewPosition
{
    if ([self cellTypeForIndex:self.bgTableView.currentIndex] != TableViewCellTypeTableView) {
        return;
    }
    
    if (fabs(_scrollPosition - self.bgTableView.currentIndex) == 0 ) {
        
        CGFloat position = [self calculateFilterViewPosition];
        
        [self.filterView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(position));
        }];
    }
    [self.filterView layoutIfNeeded];
}

- (CGFloat)calculateFilterViewPosition
{
    CGFloat position = 0;
    
    UITableViewCell *cell = [self getTargetCell];
    
    if (cell) {
        // 使用cell.contentView.window在viewWillAppear时，window为nil，会导致rect计算不正确
        CGRect rect = [cell convertRect:cell.contentView.frame toView:[UIApplication sharedApplication].keyWindow];
        if (rect.origin.y > _tagSelectView.maxY) { // cell已经出现时，直接设定值
            position = rect.origin.y+16;
            return position;
        }
        
        position = MIN(MAX(rect.origin.y+16, _tagSelectView.maxY+16), kScreenHeight-50-_filterView.height-30);
    }else{
        position = _tagSelectView.maxY+16;
    }
    return position;
}


- (NSIndexPath *)getTargetCellIndexPath
{
    return [NSIndexPath indexPathForRow:0 inSection:1];
}

- (UITableViewCell *)getTargetCell
{
    return [[self.bgTableView getCurrentShowTableView] cellForRowAtIndexPath:[self getTargetCellIndexPath]];
}

/**
 *  跳转广告位
 */
- (void)goToAdvertPage:(AdvertModel *)model shareImage:(UIImage *)shareImage
{
    [HomepageViewController goToAdvertPage:model shareImage:shareImage sourceVC:self.navigationController];
}


- (void)clearAdvertData
{
    [_topAdvertArray removeAllObjects];
}

- (void)loadRedirectUrlAfterLogining:(NSString *)redirectUrl
{
    if ([self cellTypeForIndex:self.bgTableView.currentIndex] == TableViewCellTypeWebView) {
        
        UIWebView *webView = [self.bgTableView getCurrentShowWebView];
        if (webView) {
            NSString *currentUrl = [webView getCurrentUrl];
            if (redirectUrl.length && ![redirectUrl isEqualToString:currentUrl] && ![redirectUrl isEqualToString:kLoginDefaultRedirectUrl]) {
                [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.location.href='%@'",redirectUrl]];
            } else {
                [webView reload];
            }
        }
    }
}

- (void)re_InitDataListArray:(NSInteger)count {
    NSInteger maxCount = MAX(count, _dataList.count);
    for (int i = 0; i < maxCount; i++) {
        if (i < count) {
            if (i < _dataList.count) {
                for (int j = 0; j < 1; j++) {
                    [_dataList[i][j] removeAllObjects];
                }
            }else {
                NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:1];
                for (int j = 0; j < 1; j++) {
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
                if (_isShowMap) {
                    [weakSelf loadNearbyData:YES];
                }
            }];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    FBLOG(@"内存警告：%@",self.class);
    
    if (_mapView && _isShowMap == NO)
    {
        _mapView.delegate = nil;
        [_mapView removeFromSuperview];
        _mapView = nil;
    }
}

@end

