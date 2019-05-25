//
//  HomepageViewController.m
//  CultureHongshan
//
//  Created by ct on 16/7/26.
//  Copyright © 2016年 CT. All rights reserved.
//

#import "HomepageViewController.h"

// View Controller
#import "SearchActivityViewController.h" // 搜索页面

#import "ActivityDetailViewController.h"
#import "VenueDetailViewController.h"
#import "SearchDetailViewController.h"
#import "CenterViewController.h"

#import "WebViewController.h"

// View And Cell
#import "ActivityCell.h"

#import "MainIndexClassifyView.h"
#import "MainIndexSixBannerView.h"
#import "MainIndexRecommendView.h"
#import "AppVersionUpdateView.h"
#import "SDCycleScrollView.h"


// Model
#import "ActivityModel.h"
#import "AdvertModel.h"
#import "AppUpdateModel.h"
#import "CitySwitchModel.h"


// Other
#import "MJRefresh.h"
#import "PushServices.h"
#import "LocationService2.h"


static NSString *reuseID_TopCell       = @"TopCell";
static NSString *reuseID_RecommendCell = @"RecommendCell";
static NSString *reuseID_Cell          = @"ActivityCell";
static NSString *reuseID_AdvCell       = @"AdvertCell";
static NSString *reuseID_FooterView    = @"FooterView";

#define Classify_Advert  0
#define Recommend_Advert 1

@interface HomepageViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,SDCycleScrollViewDelegate>
{
    MYSmartButton *_locationButton;//区域设置按钮
    MYSmartLabel *_noMoreLabel;
    CGFloat _scrollViewOffsetX[2];
    
    NSArray *_scrollBannerArray;//轮播图广告位: @[model,model,...]
    NSArray *_classifyArray;// 类别广告位: @[model,model,...]
    NSArray *_sixBannerArray;//六个广告位: @[model,model,...]
    NSArray *_recommendArray;//推荐的活动广告位: @[model,model,...]
    NSArray *_insertAdvArray;//插入广告数组
    
    NSMutableArray *_listArray;//活动列表
    
}

@property (nonatomic,strong) NSArray *screenshotImages;


@end



@implementation HomepageViewController


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:WHYLocationAuthStatusDidChangeNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    if (!_tableView) {
        [self initTableView];
        [self initRefreshControl];
        _tableView.contentOffset = CGPointMake(0, _preOffsetY);
        [self.view sendSubviewToBack:_tableView];
    }
    
    self.tabBarController.tabBar.hidden = NO;
    
    if (_screenshotImages.count)
    {
        _tableView.hidden = YES;
        
        [ToolClass animationWithTopImage:_screenshotImages[0] bottomImage:_screenshotImages[1] headOffset:0 isTogether:YES completion:^(BOOL finished) {
            _tableView.hidden =  NO;
        }];
        _screenshotImages = nil;
    }
    
    if ([LocationService2 isAllowLocating] == NO) {
        if ([LocationService2 sharedService].authStatus == kCLAuthorizationStatusNotDetermined) {
            [LocationService2 requestWhenInUseAuthorization];
        }else if ([LocationService2 sharedService].authStatus == kCLAuthorizationStatusDenied) {
            if ([LocationService2 canShowAlertAtToday]) {
                [WHYAlertActionUtil showAlertWithTitle:@"温馨提示" msg:PRIVACY_LOCATION_ALERT actionBlock:^(NSInteger index, NSString *buttonTitle) {
                    [LocationService2 updateShowAlertStatus];
                    if (index == 1) {
                        [LocationService2 openSystemLocationSetting];
                    }
                } buttonTitles:@"稍后", @"立即设置", nil];
            }
        }else if ([LocationService2 sharedService].authStatus == kCLAuthorizationStatusRestricted) {
        }
    }
    
    [self startRequestAppUpdate];
    
    
    [PushServices setTags:nil alias:[UserService sharedService].userId];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    _listArray = [NSMutableArray arrayWithCapacity:0];
    
    [self initNavigationBar];
    
    [self initTableView];
    [self initRefreshControl];
    
    [self startRequestActivityListData:YES]; // 活动列表数据
    [self loadAdvertData:YES];//  广告位数据
    
    // 添加定位通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLocationAuthStatusDidChange:) name:WHYLocationAuthStatusDidChangeNotification object:nil];
    
    _noMoreLabel = [MYSmartLabel al_labelWithMaxRow:1 text:@"已经到底啦" font:FontYT(12) color:kDeepLabelColor lineSpacing:0 align:NSTextAlignmentCenter breakMode:NSLineBreakByTruncatingTail];
}

/**
 *  初始化导航条
 */
- (void)initNavigationBar
{
    self.navigationItem.title = APP_SHOW_NAME;
    
    // 右侧的搜索
    WS(weakSelf)
    FBButton *searchButton = [[FBButton alloc] initWithImage:MRECT(0, 0, 26 , 30) bgcolor:COLOR_CLEAR img:IMG(@"放大镜") clickEvent:^(FBButton *owner) {
        SearchActivityViewController * vc = [[SearchActivityViewController alloc] initWithSearchType:SearchTypeActivity];// 活动搜索
        [weakSelf.navigationController pushViewController:vc animated:NO];
    }];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchButton];
}

- (void)initRefreshControl
{
    //头部的刷新控件
    WS(weakSelf);
    
    MJRefreshNormalHeader *headerRefresh = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf startRequestActivityListData:YES];
        [weakSelf loadAdvertData:YES];
    }];
    [headerRefresh setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    [headerRefresh setTitle:@"释放刷新" forState:MJRefreshStatePulling];
    [headerRefresh setTitle:@"文化生活加载中..." forState:MJRefreshStateRefreshing];
    headerRefresh.stateLabel.font = FONT(14);
    headerRefresh.lastUpdatedTimeLabel.font = FONT(12);
    headerRefresh.stateLabel.textColor = kLightLabelColor;
    headerRefresh.lastUpdatedTimeLabel.textColor = kLightLabelColor;
    _tableView.header = headerRefresh;
}


#pragma mark - 初始化表视图
- (void)initTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.backgroundColor = kBgColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    [self.view addSubview:_tableView];
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:reuseID_TopCell];
    [_tableView registerClass:[ActivityCell class] forCellReuseIdentifier:reuseID_Cell];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:reuseID_AdvCell];
    [_tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:reuseID_FooterView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

#pragma mark - ———————————————— 数据请求 ————————————————

// 加载活动列表数据
- (void)startRequestActivityListData:(BOOL)isRefresh
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showLoading];
    
    if (_listArray.count < 1) {
        isRefresh = YES;
    }
    
    NSInteger pageIndex = isRefresh ? 0 : _listArray.count;
    EnumCacheMode cacheMode = isRefresh ? CACHE_MODE_REALTIME : CACHE_VALID_TIME_SHORT;
    
    WS(weakSelf);
    [AppProtocol getActivityYouMayLoveWithPageIndex:pageIndex pageNum:kRefreshCount cacheMode:cacheMode UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        [_tableView.header endRefreshing];
        [_tableView.footer endRefreshing];
        
        if (responseCode == HttpResponseSuccess)
        {
            NSArray *resultArray = responseObject;
            
            if (isRefresh)
            {
                if (resultArray.count < 1) {
                    if ([self hasAdvert] == NO) {
                        [weakSelf showNoDataNotice:@"内容还在采集，请等等再来^_^"];
                    }
                    [SVProgressHUD dismiss];
                    return;
                }else{
                    [_listArray removeAllObjects];
                    [_listArray addObjectsFromArray:resultArray];
                }
            }else
            {
                if (resultArray.count < 1)
                {
                    [SVProgressHUD showInfoWithStatus:@"数据已经全部加载完了^_^"];
                    return;
                }
                [_listArray addObjectsFromArray:resultArray];
            }
            [SVProgressHUD dismiss];
            [weakSelf combineArray];
            _scrollViewOffsetX[Classify_Advert] = 0;
            _scrollViewOffsetX[Recommend_Advert] = 0;
            _noMoreLabel.hidden = YES;
            [_tableView reloadData];
        }
        else
        {
            if ([responseObject isKindOfClass:[NSString class]])
            {
                if (_listArray.count) {
                    [SVProgressHUD showInfoWithStatus:responseObject];
                    return;
                }else{
                    
                    if ([self hasAdvert] == NO) {
                        [weakSelf showNoDataNotice:@"网络连接出问题了，请稍后再试^_^"];
                        [SVProgressHUD dismiss];
                        return;
                    }else{
                        
                    }
                }
            }
            [SVProgressHUD dismiss];
        }
    }];
}

// 加载广告位数据
- (void)loadAdvertData:(BOOL)isRefresh
{
    if (!isRefresh) {
        return;
    }
    
    BOOL nationwide = NO;
    
    WS(weakSelf)
    [AppProtocol getAdvertListOfHomepageWithCacheMode:CACHE_MODE_REALTIME isNationwide:nationwide UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        
        if (responseCode == HttpResponseSuccess && [responseObject count]) {
            
            _scrollBannerArray = responseObject[0];
            _classifyArray = responseObject[1];
            _sixBannerArray = responseObject[2];
            _recommendArray = responseObject[3];
            _insertAdvArray = responseObject[4];
            
            if (nationwide == YES) {
                _listArray = responseObject[5];
                [SVProgressHUD dismiss];
                [_tableView.header endRefreshing];
                [_tableView.footer endRefreshing];
            }
            
            _scrollViewOffsetX[Classify_Advert] = 0;
            _scrollViewOffsetX[Recommend_Advert] = 0;
            _noMoreLabel.hidden = YES;
            [_tableView reloadData];
            [weakSelf removeNoticeView:nil];
        }else {
            
            if (nationwide == YES) {
                [weakSelf showNoDataNotice:responseObject];
                [SVProgressHUD dismiss];
                [_tableView.header endRefreshing];
                [_tableView.footer endRefreshing];
            }
        }
        
    }];
}

- (void)combineArray
{
    [self removeAdvertDataOfListArray];
    
    if (_listArray.count < 4) {
        return;
    }
    
    if (_insertAdvArray.count) {// 重新插入广告
        NSInteger activityCount = _listArray.count;
        for (NSInteger i = MIN(activityCount/3, _insertAdvArray.count); i > 0; i--) {
            if (i*3 >= activityCount) {
                continue;//排除"activityCount正好是3的倍数"
            }
            [_listArray insertObject:_insertAdvArray[i-1] atIndex:i*3];
        }
    }
}

//移除_listArray中已有的广告Model
- (void)removeAdvertDataOfListArray
{
    NSArray *tmpArray = [NSArray arrayWithArray:_listArray];
    for (NSInteger i = tmpArray.count-1; i > -1; i--) {
        if (![tmpArray[i] isKindOfClass:[ActivityModel class]]) {
            [_listArray removeObjectAtIndex:i];
        }
    }
}

- (void)startRequestAppUpdate
{
    [AppProtocol checkAppVersionUpdateUsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        if (responseCode == HttpResponseSuccess) {
            [AppVersionUpdateView showUpdateViewWithModel:responseObject completionHandler:^(NSInteger index) {}];
        }
    }];
}


#pragma mark - —————————— UITableView Delegate And DataSource ——————————

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return (_scrollBannerArray.count || _classifyArray.count) ? 1 : 0;
    }else if (section == 1) {
        return _sixBannerArray.count > 5 ? 1 : 0;
    }else if (section == 2) {
        return _recommendArray.count ? 1 : 0;
    }else if (section == 3) {
        return _listArray.count ? _listArray.count+1 : 0;
    }else{
        return 0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID_AdvCell forIndexPath:indexPath];
        [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];//移除之前的视图
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        CGFloat offsetY = 0;
        if (_scrollBannerArray.count) {
            UIImage *placeImg = [UIToolClass getPlaceholderWithViewSize:CGSizeMake(kScreenWidth, ConvertSize(250)) centerSize:CGSizeMake(22, 22) isBorder:NO];
            SDCycleScrollView *bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, ConvertSize(250)) delegate:self placeholderImage:placeImg];
            NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:_scrollBannerArray.count];
            for (AdvertModel *model in _scrollBannerArray) {
                [tmpArray addObject:JointedImageURL(model.advImgUrl, kImageSize_BigAdv)];
            }
            bannerView.imageURLStringsGroup = [tmpArray copy];
            bannerView.currentPageDotColor = kNavigationBarColor;
            bannerView.pageDotColor = ColorFromHex(@"f2f2f2");
            bannerView.autoScrollTimeInterval = 4;
            bannerView.autoScroll = _scrollBannerArray.count > 1;
            [cell.contentView addSubview:bannerView];
            
            offsetY = bannerView.maxY+2.5;
            
            if (_classifyArray.count) {
                WS(weakSelf);
                MainIndexClassifyView *classifyView = [[MainIndexClassifyView alloc] initWithFrame:CGRectMake(0, offsetY, kScreenWidth, cell.height-offsetY) modelArray:_classifyArray callBackBlock:^(AdvertModel *model, UIImage *shareImage) {
                    [weakSelf goToAdvertPage:model shareImage:shareImage];
                }];
                [cell.contentView addSubview:classifyView];
                classifyView.contentOffsetX = _scrollViewOffsetX[Classify_Advert];
            }
        }
        return cell;
    }
    else if (indexPath.section == 1) {//六个广告
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID_AdvCell forIndexPath:indexPath];
        [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];//移除之前的视图
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        WS(weakSelf);
        MainIndexSixBannerView *bannerView = [[MainIndexSixBannerView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, cell.height) modelArray:_sixBannerArray callBackBlock:^(AdvertModel *model, UIImage *shareImage) {
            [weakSelf goToAdvertPage:model shareImage:shareImage];
        }];
        [cell.contentView addSubview:bannerView];
        
        return cell;
    }
    else if (indexPath.section == 2) {//推荐
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID_AdvCell forIndexPath:indexPath];
        [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];//移除之前的视图
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        WS(weakSelf);
        MainIndexRecommendView *recommendView = [[MainIndexRecommendView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 197.5) modelArray:_recommendArray callBackBlock:^(AdvertModel *model, UIImage *shareImage) {
            [weakSelf goToAdvertPage:model shareImage:shareImage];
        }];
        [cell.contentView addSubview:recommendView];
        recommendView.contentOffsetX = _scrollViewOffsetX[Recommend_Advert];
        
        return cell;
    }
    else if (indexPath.section == 3) {//猜你喜欢
        
        if (indexPath.row == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HeaderCell"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HeaderCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.contentView.backgroundColor = [UIColor whiteColor];
            }
            [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            
            CGFloat imgSize = 21;
            CGFloat textWidth = [UIToolClass textWidth:@"猜你喜欢" font:FontYT(15)];
            
            //标题
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, textWidth, 47.5)];
            titleLabel.textColor = kLabelBlueColor;
            titleLabel.attributedText = [UIToolClass boldString:@"猜你喜欢" font:FontYT(15) lineSpacing:0 alignment:NSTextAlignmentCenter];
            [cell.contentView addSubview:titleLabel];
            
            //图片
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth-imgSize-6-textWidth)*0.5, (titleLabel.height-imgSize)*0.5, imgSize, imgSize)];
            imgView.image = IMG(@"icon_猜你喜欢");
            [cell.contentView addSubview:imgView];
            titleLabel.originalX = imgView.maxX+6;
            
            return cell;
        }
        
        
        if ([_listArray[indexPath.row-1] isKindOfClass:[AdvertModel class]]){
            
            AdvertModel *model = _listArray[indexPath.row-1];
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID_AdvCell forIndexPath:indexPath];
            [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];//移除之前的视图
            cell.contentView.backgroundColor = [UIColor whiteColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ConvertSize(250))];
            UIImage *placeImg = [UIToolClass getPlaceholderWithViewSize:imgView.viewSize centerSize:CGSizeMake(20, 20) isBorder:NO];
            [imgView sd_setImageWithURL:[NSURL URLWithString:JointedImageURL(model.advImgUrl, kImageSize_BigAdv)] placeholderImage:placeImg];
            [cell.contentView addSubview:imgView];
            
            MYMaskView *line = [MYMaskView maskViewWithBgColor:kBgColor frame:CGRectMake(0, imgView.maxY, kScreenWidth, cell.height-imgView.maxY) radius:0];
            [cell.contentView addSubview:line];
            
            return cell;
        }else{
            ActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID_Cell forIndexPath:indexPath];
            [cell setModel:_listArray[indexPath.row-1] type:1 forIndexPath:indexPath];
            return cell;
        }
        
    }
    else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BlankCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BlankCell"];
            cell.contentView.backgroundColor = kBgColor;
        }
        return cell;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        CGFloat height = 0;
        if (_scrollBannerArray.count) {
            height += ConvertSize(250);
        }
        if (_classifyArray.count) {
            height += (height > 0) ? 2.5 + 113 : 113;
        }
        return height;
    }else if (indexPath.section == 1) {
        CGFloat lineWidth = 0.6;
        return _sixBannerArray.count > 5 ? (kScreenWidth-lineWidth)*0.5*0.59 + lineWidth + (kScreenWidth-3*lineWidth)/4.0*1.163 : 0; // (kScreenWidth-1)*0.5*0.59 + 1 + (kScreenWidth-3)/4.0*1.163  ConvertSize(437)
    }else if (indexPath.section == 2) {
        return _recommendArray.count ? 198 : 0;  // 47.5 + 150*0.63 + 35 + 20  ConvertSize(440)
    }else if (indexPath.section == 3) {
        if (indexPath.row == 0){ // 猜你喜欢
            return 47.5;
        }
        
        if ([_listArray[indexPath.row-1] isKindOfClass:[AdvertModel class]]) {
            return ConvertSize(250)+7.5;
        }else {
            return kScreenWidth*kPicScale_ListCover + 76;
        }
    }else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return (_scrollBannerArray.count || _classifyArray.count) ? 7.5 : 0.01;
    }else if (section == 1) {
        return _sixBannerArray.count > 5 ? 7.5 : 0.01;
    }else if (section == 2) {
        return _recommendArray.count ? 7.5 : 0.01;
    }else if (section == 3) {
        return 0.01;
    }else{
        return 0.01;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UITableViewHeaderFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:reuseID_FooterView];
    [footerView.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if (section != 3) {
        footerView.contentView.backgroundColor = kBgColor;
        
        MYMaskView *line = [MYMaskView maskViewWithBgColor:RGB(231, 231, 231) frame:CGRectMake(0, 0, kScreenWidth, 1) radius:0];
        [footerView.contentView addSubview:line];
    }else {
        footerView.contentView.backgroundColor = kBgColor;
    }
    return footerView;
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell.reuseIdentifier isEqualToString:reuseID_AdvCell]) {
        for (UIView *view in cell.contentView.subviews) {
            if ([view isKindOfClass:[MainIndexClassifyView class]]) {
                _scrollViewOffsetX[Classify_Advert] = [(MainIndexClassifyView *)view contentOffsetX];
            }else if ([view isKindOfClass:[MainIndexRecommendView class]]) {
                _scrollViewOffsetX[Recommend_Advert] = [(MainIndexRecommendView *)view contentOffsetX];
            }
        }
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3 && _listArray.count) {
        if (indexPath.row > 0) {
            
            if ([_listArray[indexPath.row-1] isKindOfClass:[AdvertModel class]]) {
                AdvertModel *model = _listArray[indexPath.row-1];
                
                UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                UIImageView *imgView = cell.contentView.subviews[0];
                [self goToAdvertPage:model shareImage:imgView.image];
                
            }else{
                ActivityModel *model = _listArray[indexPath.row-1];
                
                UIWindow *window = [UIApplication sharedApplication].keyWindow;
                UIImage *screenShotImg = [UIToolClass getScreenShotImageWithSize:CGSizeMake(kScreenWidth, kScreenHeight) views:@[window] isBlurry:NO];
                
                ActivityCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                CGRect frame = [cell.contentView convertRect:cell.contentView.frame toView:window];
                
                
                CGFloat topHeight = MIN(MAX(CGRectGetMaxY(frame)-8-76, HEIGHT_TOP_BAR), kScreenHeight-HEIGHT_TAB_BAR);
                self.screenshotImages = [ToolClass getTwoScreenShotsWithImage:screenShotImg topHeight:topHeight headimg:[cell getHeadImage]];
                
                ActivityDetailViewController *activityDetailVC = [ActivityDetailViewController new];
                activityDetailVC.activityId = model.activityId;
                activityDetailVC.screenshotImages = self.screenshotImages;
                [self.navigationController pushViewController:activityDetailVC animated:NO];
            }
        }
    }
}


#pragma mark - ———————————— 代理方法 ————————————
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if ( offsetY >= scrollView.contentSize.height-scrollView.height ) {
        _preOffsetY = offsetY;
        
        
        if (offsetY > scrollView.contentSize.height-scrollView.height + 3 && offsetY > 0) {
            
            if (_noMoreLabel.superview==nil) {
                [scrollView addSubview:_noMoreLabel];
            }
            
            WS(weakSelf)
            [_noMoreLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(scrollView.contentSize.height + 10);
                make.centerX.equalTo(weakSelf.view);
            }];
            
            [scrollView setNeedsLayout];
            [scrollView layoutIfNeeded];
            
            _noMoreLabel.hidden = NO;
        }else {
            _noMoreLabel.hidden = YES;
        }
        return;
    }
    
    _noMoreLabel.hidden = YES;
    
    if (_preOffsetY > offsetY) {
        [self navViewAnimation:YES];//出现
    }else{
        
        if (offsetY - _beginDragOffsetY > 60) {
            [self navViewAnimation:NO];// 消失
        }
    }
    
    _preOffsetY = offsetY;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _beginDragOffsetY = scrollView.contentOffset.y;
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    if (_scrollBannerArray.count) {
        [self goToAdvertPage:_scrollBannerArray[index] shareImage:cycleScrollView.currentImage];
    }
}

#pragma mark - ———————————— 其它方法 ————————————

- (void)updateUserArea:(NSString *)area
{
    if (area.length < 1 || _locationButton == nil) {
        return;
    }
}

- (void)navViewAnimation:(BOOL)isShow
{
    return;
//    CGFloat targetPositon = isShow ? 20 : -24;
//
//    if (_navView.originalY == targetPositon) {
//        return;
//    }
//
//    WEAK_VIEW1(_navView);
//    WEAK_VIEW2(_tableView);
//
//    [UIView animateWithDuration:0.5 animations:^{
//
//        weakView1.originalY = targetPositon;
//        weakView2.originalY = weakView1.maxY;
//        weakView2.height = kScreenHeight-49-weakView2.originalY;
//    }];
}


- (void)goToAdvertPage:(AdvertModel *)model shareImage:(UIImage *)shareImage
{
    [HomepageViewController goToAdvertPage:model shareImage:shareImage sourceVC:self.navigationController];
}

+ (void)goToAdvertPage:(AdvertModel *)model shareImage:(UIImage *)shareImage sourceVC:(UINavigationController *)navVC
{
    if (![model isKindOfClass:[AdvertModel class]]) {
        return;
    }
    
    UIViewController * vc = nil;
    if (model.isOuterLink)
    {
        if (model.advUrl.length && ![model.advUrl isEqualToString:@"#"]) {
            vc = [WebViewController new];
            ((WebViewController *)vc).url = model.advUrl;
            ((WebViewController *)vc).sharedImage = shareImage;
            ((WebViewController *)vc).shareContent = model.advShareContent;
            [navVC pushViewController:vc animated:YES];
        }
    }
    else
    {
        switch (model.advLinkType)
        {
            case 0://活动列表
            {
                [PageAccessTool accessAppPage:AppPageTypeActivityList url:model.advUrl navVC:navVC sourceType:1 extParams:nil];
            }
                break;
            case 1://活动详情
            {
                [PageAccessTool accessAppPage:AppPageTypeActivityDetail url:model.advUrl navVC:navVC sourceType:1 extParams:nil];
            }
                break;
            case 2://场馆列表
            {
                [PageAccessTool accessAppPage:AppPageTypeVenueList url:model.advUrl navVC:navVC sourceType:1 extParams:nil];
            }
                break;
            case 3://场馆详情
            {
                [PageAccessTool accessAppPage:AppPageTypeVenueDetail url:model.advUrl navVC:navVC sourceType:1 extParams:nil];
            }
                break;
            case 4://文化日历
            {
                [PageAccessTool accessAppPage:AppPageTypeCalendarList url:model.advUrl navVC:navVC sourceType:1 extParams:nil];
            }
                break;
            case 5: //活动列表（带标签筛选）
            {
                if (model.advUrl.length && model.advertName.length) {
                    [PageAccessTool accessAppPage:AppPageTypeActivityListWithFilter url:[NSString stringWithFormat:@"%@;%@",model.advertName,model.advUrl] navVC:navVC sourceType:1 extParams:nil];
                }
            }
                break;
            default:
                break;
        }
    }
}


- (void)showNoDataNotice:(NSString *)message
{
    WS(weakSelf);
    [self showErrorMessage:message
                     frame:CGRectMake(0, _navView.maxY, kScreenWidth, kScreenHeight-_navView.maxY)
               promptStyle:NoDataPromptStyleClickRefreshForNoContent
                parentView:self.view
             callbackBlock:^(id object, NSInteger index, BOOL isSameIndex)
    {
        [weakSelf startRequestActivityListData:YES];
        [weakSelf loadAdvertData:YES];
    }];
}

- (BOOL)hasAdvert
{
    if (_scrollBannerArray.count==0 && _classifyArray.count==0 && _sixBannerArray.count==0 && _recommendArray.count==0 && _insertAdvArray.count==0) {
        return NO;
    }else {
        return YES;
    }
}


// 定位授权状态发生变化
- (void)userLocationAuthStatusDidChange:(NSNotification *)noti {
    NSNumber *status = noti.object;
    if (status && [status isKindOfClass:[NSNumber class]]) {
        CLAuthorizationStatus authStatus = [status intValue];
        if (authStatus == kCLAuthorizationStatusAuthorizedWhenInUse || authStatus == kCLAuthorizationStatusAuthorizedAlways) {
            [[LocationService2 sharedService] beginOnceLocationWithCompletion:^(MYLocationModel *location, NSString *errorMsg) {
            }];
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    FBLOG(@"内存警告：%@",self.class);
    
    if (self.tabBarController && self.tabBarController.selectedIndex != 0) {
        _tableView.delegate = nil;
        _tableView.dataSource = nil;
        [_tableView removeFromSuperview];
        _tableView = nil;
    }
}

/*
 
 
 */

@end

