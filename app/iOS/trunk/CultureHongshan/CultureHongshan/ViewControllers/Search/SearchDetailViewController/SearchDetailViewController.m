//
//  SearchDetailViewController.m
//  CultureHongshan
//
//  Created by ct on 15/11/11.
//  Copyright © 2015年 CT. All rights reserved.
//

#import "SearchDetailViewController.h"


#import "VenueListCell.h"
#import "ActivityCell.h"
#import "SearchDetailFooterView.h"
#import "DropdownView.h"


#import "VenueDetailViewController.h"
#import "ActivityDetailViewController.h"
#import "NearbyLocationViewController.h"

#import "VenueModel.h"
#import "ActivityModel.h"
#import "ActivitySubModel.h"


#import "UIImageView+WebCache.h"
#import "MJRefresh.h"

#import "AnimationBackView.h"
#import "UserDataCacheTool.h"


#define kRequestCount 10

static NSString *reuseID_Venue    = @"VenueCell";
static NSString *reuseID_Activity = @"ActivityCell";
static NSString *reuseID_Header   = @"header";
static NSString *reuseID_Footer   = @"Footer";

static NSString *reuseID_NoResultsTip = @"NoResultsTip";//没有搜索到结果时的提示


@interface SearchDetailViewController ()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, DropdownViewDelegate>
{
    UIButton *_titleButton;
    AnimationBackView *_animationView;
    
    CGFloat _dayCountOfNewTag;//“新”标签天数
    
    BOOL _didRequestData;//是否成功请求了数据
    BOOL _isNearbySort;// 是否为“离我最近”排序
    
    NSUInteger _indexOfDidRequestAdditionalInfo;
    
    UIView *_filterView;
    
    // 筛选
    DropdownView * _areaDropdown;
    DropdownView * _smartDropdown;
    DropdownView * _filterDropdown;
    NSString * _selectedOrder;
    NSString * _selectedFilter;
    NSString * _selectedArea;
}


@end

@implementation SearchDetailViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = kBgColor;
    _listArray = @[@"",[NSMutableArray arrayWithCapacity:0]];
    _selectedArea = @"";
    _selectedOrder = @"";
    _selectedFilter = @"";
    
    if (_activityTypeSearch){
        self.navigationItem.title = [_parameterDict safeStringForKey:@"searchKey"];
        [self loadActivityListDataByCondition:YES isClearData:YES];
    }else {
        _animationView = [[AnimationBackView alloc] initAnimationWithFrame:CGRectMake(0, 0, 100, 80)];
        [_animationView beginAnimationView];
        [self.view addSubview:_animationView];
        _animationView.center = CGPointMake(self.view.center.x, kScreenHeight/2-40);
        
        [self startRequest];
    }
}


/**
 *  初始化刷新控件
 */
- (void)initRefreshControl
{
    if (_activityTypeSearch==NO) {
        return;
    }
    
    //头部的刷新控件
    WS(weakSelf);
    
    MJRefreshNormalHeader *headerRefresh = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadActivityListDataByCondition:YES isClearData:YES];
    }];
    [headerRefresh setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    [headerRefresh setTitle:@"释放刷新" forState:MJRefreshStatePulling];
    [headerRefresh setTitle:@"文化生活加载中..." forState:MJRefreshStateRefreshing];
    headerRefresh.stateLabel.font = FONT(14);
    headerRefresh.lastUpdatedTimeLabel.font = FONT(12);
    headerRefresh.stateLabel.textColor = kLightLabelColor;
    headerRefresh.lastUpdatedTimeLabel.textColor = kLightLabelColor;
    _tableView.header = headerRefresh;
    
    //尾部的刷新控件
    MJRefreshBackNormalFooter *footerRefresh = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadActivityListDataByCondition:NO isClearData:NO];
    }];
    footerRefresh.stateLabel.font = FontYT(12);
    _tableView.footer = footerRefresh;
}

/**
 *  初始化筛选条：位置固定
 */
- (void)initFilterView
{
    if (_activityTypeSearch==NO) {
        return;
    }
    if (_filterView) {
        [self.view bringSubviewToFront:_filterView];
        return;
    }
    
    _filterView = [[UIView alloc] initWithFrame:CGRectMake(0,0, 250, 30)];
    _filterView.backgroundColor = RGBA(0x2e, 0x2e, 0x2e,0.75);
    _filterView.alpha = 0.9;
    _filterView.radius = 10;
    [self.view addSubview:_filterView];
    
    _areaDropdown = [[DropdownView alloc] initWithArray:MRECT(3, 0, 87, 30) title:@"全部商圈" dataList:[DictionaryService getArea] delegate:self];
    [_filterView addSubview:_areaDropdown];
    
    UIImageView * line1 = [[UIImageView alloc] initWithFrame:MRECT(90, 8, 2, 14)];
    line1.image = IMG(@"line_filter_bar");
    [_filterView addSubview:line1];
    
    _smartDropdown = [[DropdownView alloc] initWithArray:MRECT(91, 0, 90, 30) title:@"智能排序" dataList:[DictionaryService getSmartOrder] delegate:self];
    [_filterView addSubview:_smartDropdown];
    
    UIImageView * line2 = [[UIImageView alloc] initWithFrame:MRECT(182, 8, 2, 14)];
    line2.image = IMG(@"line_filter_bar");
    [_filterView addSubview:line2];
    
    _filterDropdown = [[DropdownView alloc] initWithArray:MRECT(181, 0, 66, 30) title:@"筛选" dataList:[DictionaryService getFilter]  delegate:self];
    [_filterView addSubview:_filterDropdown];
    
    
    WS(weakSelf);
    [_filterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(@(25));
        make.height.equalTo(@30);
        make.width.equalTo(@250);
    }];
}


#pragma -mark 设置表视图
- (void)setupTableView
{
    if (_tableView)
    {
        [self initFilterView];
        [_tableView reloadData];
        return;
    }
    else
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-HEIGHT_TOP_BAR) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = kBgColor;
        _tableView.bounces = _activityTypeSearch;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
        
        //注册自定义Cell
        [_tableView registerClass:[VenueListCell class] forCellReuseIdentifier:reuseID_Venue];
        [_tableView registerClass:[ActivityCell class] forCellReuseIdentifier:reuseID_Activity];
        [_tableView registerClass:[SearchDetailFooterView class] forHeaderFooterViewReuseIdentifier:reuseID_Footer];
        [_tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:reuseID_Header];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:reuseID_NoResultsTip];
    }
    
    [self initFilterView];
    [self initRefreshControl];
}


#pragma mark - 开启网络请求
/**
 *  根据关键词搜索“活动”和“场馆”
 */
- (void)startRequest
{
    NSInteger pageIndex = 0;
    
    if (_listArray[1] && [_listArray[1] count])
    {
        pageIndex = [_listArray[1] count];
    }
    
    DataType type = (_searchType == SearchTypeActivity) ? DataTypeActivity : DataTypeVenue;//1- 活动， 2- 场馆
    NSString *modelType = [_parameterDict[@"modelType"] length] ? _parameterDict[@"modelType"] : @"";//活动或场馆的分类（类型）
    NSString *modelArea = [_parameterDict[@"modelArea"] length] ? _parameterDict[@"modelArea"] : @"";//活动或场馆的区域
    NSString *searchKey = [_parameterDict[@"searchKey"] length] ? _parameterDict[@"searchKey"] : @"";//活动或场馆的搜索关键词
    
    
    WS(weakSelf);
    [AppProtocol searchActivityAndVenueWithType:type modelType:modelType modelArea:modelArea searchKey:searchKey pageIndex:pageIndex pageNum:kRefreshCount cacheMode:CACHE_MODE_REALTIME UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        
        _indexOfDidRequestAdditionalInfo = 0;
        
        [_animationView shutTimer];
        
        if (responseCode == HttpResponseSuccess)
        {
            _didRequestData = YES;
            
            _animationView.isLoadAnimation = YES;
            if (_listArray.count && [_listArray[1] count]) {
                NSArray *newArray = (NSArray *)responseObject[1];
                NSArray *oldArray = _listArray[1];
                _listArray = [NSArray arrayWithObjects:_listArray[0],[oldArray arrayByAddingObjectsFromArray:newArray], nil];
            } else {
                _listArray = (NSArray *)responseObject;
            }
            
            [weakSelf showNumberOfSearchResults:[_listArray[0] integerValue]];
            if ([_listArray[1] count]) {
                if ([responseObject[1] isKindOfClass:[NSArray class]] && type == DataTypeVenue) {
                    if ([responseObject[1] count]) {
                        _indexOfDidRequestAdditionalInfo = MIN([responseObject[1] count], kRequestCount);
                        [weakSelf loadVenueAdditionalInfoWithModelArray:[responseObject[1] subarrayWithRange:NSMakeRange(0, _indexOfDidRequestAdditionalInfo)] range:NSMakeRange(0, _indexOfDidRequestAdditionalInfo)];
                    }
                }
            }
            
            [weakSelf setupTableView];
        }
        else//请求失败
        {
            if (_listArray.count > 0) {
                [SVProgressHUD showInfoWithStatus:@"获取数据失败，请稍后再试吧"];
                [weakSelf showNumberOfSearchResults:[_listArray[0] integerValue]];
            } else {
                [_animationView setAnimationLabelTextString:(NSString *)responseObject];
                [weakSelf showNumberOfSearchResults:0];
            }
        }
    }];
}

/**
 *  根据条件筛选活动（目前[v3.5.4]入口只有“广告位”）
 */
- (void)loadActivityListDataByCondition:(BOOL)isRefresh isClearData:(BOOL)isClearData
{
    NSString *activityType  = [_parameterDict safeStringForKey:@"modelType"];
    NSString *selectedOrder = [DictionaryService getSmartOrderValue:_selectedOrder];
    NSDictionary *areaDic   = [DictionaryService getAreaCode:_selectedArea];
    NSDictionary *filterDic = [DictionaryService getFilterValue:_selectedFilter];
    
    NSInteger pageIndex = 0;
    if ([_listArray[1] count] == 0) {
        isRefresh = YES;
    }
    if (isRefresh == NO && isClearData == NO) {
        pageIndex = [_listArray[1] count];
    }
    
    [SVProgressHUD showLoading];
    
    WS(weakSelf);
    WEAK_VIEW(_tableView);
    
    EnumCacheMode cacheMode = isRefresh ? CACHE_MODE_REALTIME : CACHE_VALID_TIME_SHORT;
    
    [AppProtocol getTopAcitivityListWithActivityTag:activityType
                                           sortType:selectedOrder
                                       activityArea:[areaDic safeStringForKey:@"activityArea"]
                                   activityLocation:[areaDic safeStringForKey:@"activityLocation"]
                              activityIsReservation:[filterDic safeStringForKey:@"activityIsReservation"]
                                     activityIsFree:[filterDic safeStringForKey:@"activityIsFree"]
                                          pageIndex:pageIndex
                                            pageNum:kRefreshCount
                                          cacheMode:cacheMode
                                         UsingBlock:^(HttpResponseCode responseCode, id responseObject)
    {
        
        [weakView.header endRefreshing];
        [weakView.footer endRefreshing];
        
        if (responseCode == HttpResponseSuccess)
        {
            if (isRefresh) { // 下拉刷新
                [_listArray[1] removeAllObjects];
                [_listArray[1] addObjectsFromArray:responseObject];
                weakView.contentOffset = CGPointZero;
            }else {
                if (isClearData) { // 切换筛选条件
                    [_listArray[1] removeAllObjects];
                    [_listArray[1] addObjectsFromArray:responseObject];
                    weakView.contentOffset = CGPointZero;
                }else { // 加载更多
                    if ([_listArray[1] count] && [responseObject count] < 1) {
                        [SVProgressHUD showInfoWithStatus:@"没有更多活动啦^_^"];
                        return;
                    }
                    [_listArray[1] addObjectsFromArray:responseObject];
                }
            }
            
            [weakSelf setupTableView];
            
            if ([_listArray[1] count] < 1) {
                [weakSelf requestDidFail:@"内容还在采集，请等等再来。"];
            }else {
                [weakSelf removeNoticeView];
            }
            
            [SVProgressHUD dismiss];
        }
        else
        {
            if ([responseObject isKindOfClass:[NSString class]]) {
                if ([_listArray[1] count] < 1) {
                    [weakSelf requestDidFail:responseObject];
                    [SVProgressHUD dismiss];
                }else {
                    [SVProgressHUD showErrorWithStatus:responseObject];
                }
            }
        }
        
    }];
}


- (void)loadVenueAdditionalInfoWithModelArray:(NSArray *)modelArray range:(NSRange)range
{
    
    FBLOG(@"请求了多少条: %@",NSStringFromRange(range));
    
    NSString *venueIdString = [VenueModel getAllVenueIdStringWithListArray:modelArray];
    if (venueIdString.length < 1) {
        return;
    }
    NSArray *venueIdArray = [ToolClass getComponentArray:venueIdString separatedBy:@","];
    
    for (int i = 0; i < venueIdArray.count; i++) {
        [AppProtocol getVenueAdditionalInfoWithVenueId:venueIdArray[i] UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
            
            if (responseCode == HttpResponseSuccess) {
                 [VenueModel getMatchedModelWithVenueModelArray:_listArray[1] subModelDict:responseObject];
                 [_tableView reloadData];
             }else {
                 FBLOG(@"获取场馆的附加信息失败");
             }
         }];
    }
}


#pragma mark - 导航条按钮的点击事件
// 重写根类的方法
- (void)popViewController
{
    [self.navigationController popViewControllerAnimated:!_hiddenPopAnimation];
}


#pragma -mark UITableViewDataSoure
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_activityTypeSearch) {
        return [_listArray[1] count];
    }
    
    return ( ([_listArray[1] count] == 0) && _didRequestData) ? 1 : [_listArray[1] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (([_listArray[1] count] == 0) && _didRequestData)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID_NoResultsTip forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = @"没有找到搜索结果，请换个关键词试试^_^";
        cell.textLabel.font = FontYT(15);
        cell.textLabel.textColor = kDeepLabelColor;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        return cell;
    }
    else
    {
        if (_searchType == SearchTypeActivity)
        {
            ActivityModel *activity = _listArray[1][indexPath.section];
            
            ActivityCell *activityCell = [tableView dequeueReusableCellWithIdentifier:reuseID_Activity forIndexPath:indexPath];
            [activityCell setModel:activity type:_isNearbySort?2:1 forIndexPath:indexPath];
            return activityCell;
        }
        else
        {
            VenueModel *aVenue = _listArray[1][indexPath.section];
            VenueListCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID_Venue forIndexPath:indexPath];
            [cell setModel:aVenue forIndexPath:indexPath];
            return cell;
        }
    }
}


#pragma -mark UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (([_listArray[1] count] == 0) && _didRequestData)
    {
        return kScreenHeight-HEIGHT_TOP_BAR;
    }
    
    if (_searchType == SearchTypeActivity)
    {
        if (indexPath.section == [_listArray[1] count]-1) {
            return [self cellHeightWithTopSpacing:0]-6;
        }else{
            return [self cellHeightWithTopSpacing:0];
        }
    }
    else
    {
        return kScreenWidth*kPicScale_ListCover;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_listArray[1] count] == 0) {
        return;
    }
    
    if (_searchType == SearchTypeActivity)
    {
        ActivityModel *activity = _listArray[1][indexPath.section];
        ActivityDetailViewController *activityDetailVC = [ActivityDetailViewController new];
        activityDetailVC.activityId = activity.activityId;
        [self.navigationController pushViewController:activityDetailVC animated:YES];
    }
    else if (_searchType == SearchTypeVenue)
    {
        VenueModel *venue = _listArray[1][indexPath.section];
        VenueDetailViewController *venueDetailVC = [VenueDetailViewController new];
        venueDetailVC.venueId = venue.venueId;
        [self.navigationController pushViewController:venueDetailVC animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([_listArray[1] count] && section == 0) {
        return 7.5;
    }
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (_searchType == SearchTypeActivity)
    {
        if (section == [_listArray[1] count]-1 && _activityTypeSearch==NO)
        {
            return 60;
        }
        else
        {
            return 0.01;
        }
    }
    else
    {
        if (section == [_listArray[1] count]-1)
        {
            return 60;
        }
        else
        {
            return 8;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ([_listArray[1] count] && section == 0) {
        UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:reuseID_Header];
        headerView.contentView.backgroundColor = kBgColor;
        return headerView;
    }
    return nil;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    SearchDetailFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:reuseID_Footer];
    [footerView.loadMoreButton addTarget:self action:@selector(loadMoreButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    footerView.loadMoreButton.tag = section;
    
    //调整frame和title
    if (section == [_listArray[1] count] - 1 && _activityTypeSearch==NO)
    {
        footerView.loadMoreButton.hidden = NO;
        
        CGRect rect = footerView.loadMoreButton.frame;
        rect.size.height = 60;
        footerView.loadMoreButton.frame = rect;
        if (_listArray)
        {
            if ([_listArray[0] intValue] > [_listArray[1] count])
            {
                [footerView.loadMoreButton setTitle:@"----- 点击加载更多 -----" forState:UIControlStateNormal];
            }
            else
            {
                [footerView.loadMoreButton setTitle:@"----- 已经加载完了哦 -----" forState:UIControlStateNormal];
            }
        }
    }
    else
    {
        footerView.loadMoreButton.hidden = YES;
        
        CGRect rect = footerView.loadMoreButton.frame;
        if (_searchType == SearchTypeActivity)
        {
            rect.size.height = 0.001;
        }
        else
        {
            rect.size.height = 20;
        }
        footerView.loadMoreButton.frame = rect;
        [footerView.loadMoreButton setTitle:@"" forState:UIControlStateNormal];
    }
    
    return footerView;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_activityTypeSearch) {
        return;
    }
    
    if (_indexOfDidRequestAdditionalInfo >= kRequestCount && indexPath.section > _indexOfDidRequestAdditionalInfo - 3 && _indexOfDidRequestAdditionalInfo < [_listArray[1] count]) {
        
        NSUInteger requestLength = MIN([_listArray[1] count]-_indexOfDidRequestAdditionalInfo, kRequestCount);
        
        [self loadVenueAdditionalInfoWithModelArray:[_listArray[1] subarrayWithRange:NSMakeRange(_indexOfDidRequestAdditionalInfo, requestLength)] range:NSMakeRange(_indexOfDidRequestAdditionalInfo, requestLength)];
        _indexOfDidRequestAdditionalInfo += requestLength;
        if (_indexOfDidRequestAdditionalInfo > [_listArray[1] count]) {
            _indexOfDidRequestAdditionalInfo = [_listArray[1] count];
        }
    }
}


#pragma mark - 计算单元格的高度

- (CGFloat)cellHeightWithTopSpacing:(CGFloat)topSpacing
{
    return kScreenWidth * kPicScale_ListCover + 76;
}


#pragma mark - 加载更多
- (void)loadMoreButtonClick:(UIButton *)sender
{
    if (_listArray)
    {
        if ([_listArray[0] intValue] <= [_listArray[1] count])
        {
            [sender setTitle:@"----- 已经加载完了哦 -----" forState:UIControlStateNormal];
            return;
        }
    }
    if (sender.tag == [_listArray[1] count] - 1 && [sender.titleLabel.text hasPrefix:@"----- 点击"])
    {;
        [self startRequest];
    }
}

- (void)shrinkAllDropDown
{
    for (UIView * v in _filterView.subviews)
    {
        if([v isKindOfClass:[DropdownView class]])
        {
            [(DropdownView *)v shrinkDropView];
        }
    }
}

- (void)requestDidFail:(NSString *)msg
{
    [self removeNoticeView];
    
    if ([msg isKindOfClass:[NSString class]]) {
        WS(weakSelf);
        
        NoDataNoticeView *noticeView = [NoDataNoticeView noticeViewWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-HEIGHT_TOP_BAR) bgColor:[UIColor whiteColor] message:msg promptStyle:NoDataPromptStyleClickRefreshForNoContent callbackBlock:^(id object, NSInteger index, BOOL isSameIndex) {
            [weakSelf loadActivityListDataByCondition:YES isClearData:YES];
        }];
        [self.view addSubview:noticeView];
    }else {
        
    }
    
    //切换筛选条件后，如果没有数据，需要显示筛选条
    NSDictionary *areaDic   = [DictionaryService getAreaCode:_selectedArea];
    NSDictionary *filterDic = [DictionaryService getFilterValue:_selectedFilter];
    
    NSString *sortType = [DictionaryService getSmartOrderValue:_selectedOrder];
    NSString *area = [areaDic safeStringForKey:@"activityArea"];
    NSString *activityIsFree = [filterDic safeStringForKey:@"activityIsFree"];
    NSString *activityIsReservation = [filterDic safeStringForKey:@"activityIsFree"];
    
    if (!(sortType.length==0 && area.length==0 && activityIsFree.length==0 && activityIsReservation.length==0))
    {
        [self initFilterView];
    }
}


#pragma mark - 代理方法


- (void)scrollViewDidScroll:(UIScrollView *)scrollViw
{
    [self shrinkAllDropDown];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _filterView.userInteractionEnabled = NO;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    _filterView.userInteractionEnabled = YES;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _filterView.userInteractionEnabled = YES;
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
    
    _isNearbySort = [_selectedOrder isEqualToString:@"离我最近"];
    
    if (haveChange)
    {
        [self loadActivityListDataByCondition:NO isClearData:YES];
    }
}

- (void)removeNoticeView
{
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[NoDataNoticeView class]]) {
            [view removeFromSuperview];
        }
    }
}



// 显示搜索结果的条数
- (void)showNumberOfSearchResults:(NSInteger)number
{
    //    NSString *title = [[NSString alloc] initWithFormat:@"为您筛选%d条",(int)number];
    self.navigationItem.title = @"搜索结果";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
