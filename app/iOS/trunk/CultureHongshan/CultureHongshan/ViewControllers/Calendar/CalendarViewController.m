//
//  CalendarViewController.m
//  CultureHongshan
//
//  Created by ct on 17/2/10.
//  Copyright © 2017年 CT. All rights reserved.
//

#import "CalendarViewController.h"


// View Controllers
#import "MyCalendarViewController.h"
#import "ActivityDetailViewController.h"
#import "CommonMultiTableViewController.h"
#import "HomepageViewController.h"
#import "WebViewController.h"

// Views
#import "TagSelectScrollView.h"
#import "CalendarListSelectDateView.h"
#import "CalendarListCell.h"
#import "ActivityCell.h"

// Models
#import "ActivityGatherModel.h"
#import "ActivityModel.h"
#import "AdvertModel.h"


// Other

#define kDateViewHeight 95
#define kTagSelectViewHeight 50

static NSString *reuseID_Text      = @"TextCell";
static NSString *reuseID_Picture   = @"PictureCell";
static NSString *reuseID_Activity  = @"ActivityCell";
static NSString *reuseID_BlankCell = @"BlankCell";


@interface CalendarViewController () <UITableViewDelegate, UITableViewDataSource, TagSelectScrollViewDelegate, UIScrollViewDelegate>
{
    __block NSMutableArray *_dataList;
    
    NSMutableDictionary *_cellHeightCache;
    CGFloat _beginDragOffsetY;
    CGFloat _preOffsetY;
    
    NSString *_selectedTagName;
    
    __block UITableView *_tableView;
}

@property (nonatomic, strong) UIView *topMaskView;
@property (nonatomic, strong) CalendarListSelectDateView *dateSelectView;
@property (nonatomic, strong) TagSelectScrollView *tagSelectView;
@property (nonatomic, strong) AdvertModel *advModel; // 日历广告
@end



@implementation CalendarViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _selectedTagName = @"";
    _dataList = [NSMutableArray arrayWithCapacity:0];
    _cellHeightCache = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [self initNavgationBar];
    
    [self loadUI];
    
    [self loadCalendarListData:YES isClearData:YES];
}

- (void)initNavgationBar {
    
    self.navigationItem.title = [DateTool dateStringForDate:[NSDate date] formatter:@"yyyy.MM"];
    
    WS(weakSelf)
    MYSmartButton *myCalendarButton = [[MYSmartButton alloc] initWithFrame:CGRectMake(0, 0, 65, 22) title:@"我的日历" font:FontYT(13) tColor:kWhiteColor bgColor:kThemeDeepColor actionBlock:^(MYSmartButton *sender) {
        if ([weakSelf userCanOperateAfterLogin]) {
            MyCalendarViewController *vc = [MyCalendarViewController new];
            vc.collectOperationHandler = ^(NSString *modelId, BOOL isCollect) {
                [weakSelf handleCollectOperationFromOtherPage:modelId isCollect:isCollect];
            };
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
    }];
    myCalendarButton.radius = 4;
    myCalendarButton.layer.borderWidth = 0.7;
    myCalendarButton.layer.borderColor = kWhiteColor.CGColor;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:myCalendarButton];
}


- (void)loadUI {
    self.topMaskView = [UIView new];
    self.topMaskView.backgroundColor = RGB(245, 245, 245);
    [self.view addSubview:self.topMaskView];
    
    WS(weakSelf)

    // 日期选择
    self.dateSelectView = [[CalendarListSelectDateView alloc] initWithFrame:CGRectZero];
    [self.dateSelectView setMonthDidChangeActionBlock:^(NSString *month) {
        weakSelf.navigationItem.title = month;
    }];
    [self.dateSelectView setDateDidChangeBlock:^(NSString *selectDate) {
        [weakSelf loadCalendarListData:NO isClearData:YES];
    }];
    [self.topMaskView addSubview:self.dateSelectView];
    
    // 标签选择
    self.tagSelectView = [[TagSelectScrollView alloc] initWithFrame:CGRectZero autolayout:YES];
    self.tagSelectView.delegate = self;
    [self.tagSelectView updateSelectTagArray];
    if (self.tagSelectView.titleArray.count < 1) {
        [DictionaryService getCalendarListTagsWithFirstTitles:@[@"全部", @"附近"] completionBlock:^(NSArray *tagArray) {
            [weakSelf.tagSelectView updateSelectTagArray];
        }];
    }
    [self.topMaskView addSubview:self.tagSelectView];
    
    // 表视图
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.backgroundColor = kBgColor;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.contentOffset = CGPointMake(0, -_tableView.contentInset.top);
    [UIToolClass setupDontAutoAdjustContentInsets:_tableView forController:self];
    [self.view addSubview:_tableView];
    _tableView.tableHeaderView = [MYMaskView maskViewWithBgColor:kBgColor frame:CGRectMake(0, 0, kScreenWidth, kDateViewHeight + kTagSelectViewHeight) radius:0];
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:reuseID_BlankCell];
    [_tableView registerClass:[CalendarListTextCell class] forCellReuseIdentifier:reuseID_Text];
    [_tableView registerClass:[CalendarListPictureCell class] forCellReuseIdentifier:reuseID_Picture];
    [_tableView registerClass:[ActivityCell class] forCellReuseIdentifier:reuseID_Activity];
    
    [CommonMultiTableViewController setupRefresh:_tableView withBlock:^(BOOL isRefresh) {
        if (isRefresh) {
            [weakSelf loadCalendarListData:isRefresh isClearData:YES];
        }else {
            [weakSelf loadCalendarListData:NO isClearData:NO];
        }
    }];
    
    [self.topMaskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.view);
        make.top.greaterThanOrEqualTo(weakSelf.view).offset(-kDateViewHeight).priorityHigh();
        make.top.equalTo(weakSelf.view).priorityMedium();
        make.height.mas_equalTo(kDateViewHeight + kTagSelectViewHeight);
    }];
     
    [self.dateSelectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.top.equalTo(weakSelf.topMaskView);
        make.height.mas_equalTo(kDateViewHeight-3);
    }];
    
    [self.tagSelectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(weakSelf.topMaskView);
        make.top.equalTo(weakSelf.dateSelectView.mas_bottom).offset(3);
    }];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.view);
    }];
    
    [self.view bringSubviewToFront:self.topMaskView];
}


#pragma mark - 数据请求

- (void)loadCalendarListData:(BOOL)isRefresh isClearData:(BOOL)isClearData {
    /*
     
     1. 在一个Tag下,下拉刷新————Advert 与 dataList 都要清空，isRefresh＝YES，isClearData＝YES
     2. 在一个Tag下，加载更多————Advert不变，dataList合并。isRefresh＝NO，isClearData＝NO
     3. 切换Tag———————————Advert 与 dataList 都要清空，isRefresh＝NO，isClearData＝YES
     
     */
    
    if (_dataList.count < 1) {
        isRefresh = YES;
    }
    
    NSInteger pageIndex = 0;
    if (_dataList.count && !isRefresh && !isClearData) {
        pageIndex = _dataList.count;
    }
    
    [SVProgressHUD showLoading];
    
    NSString *selectDate = [DateTool dateStringForDate:self.dateSelectView.currentSelectedDate];
    NSString *activityType = [DictionaryService getCalendarTagIdWithTagName:_selectedTagName];
    WS(weakSelf)
    
    EnumCacheMode cacheMode = isRefresh ? CACHE_MODE_REALTIME : CACHE_MODE_HALFREALTIME_SHORT;
    
    [AppProtocol getCultureCalendarListWithDate:selectDate activityType:activityType pageIndex:pageIndex cacheMode:cacheMode UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        
        [_tableView.header endRefreshing];
        [_tableView.footer endRefreshing];
        
        if (responseCode == HttpResponseSuccess) {
            [SVProgressHUD dismiss];
            
            if (isRefresh) { // 下拉刷新
                [weakSelf clearAdvertData];
                [weakSelf loadAdvertData:YES];
                [_dataList removeAllObjects];
                [_dataList addObjectsFromArray:responseObject];
            }else {
                if (isClearData) { // 切换Tag
                    [weakSelf clearAdvertData];
                    [weakSelf loadAdvertData:NO];
                    [_dataList removeAllObjects];
                    [_dataList addObjectsFromArray:responseObject];
                    
                    if (weakSelf.topMaskView.originalY == -kDateViewHeight) {
                        [_tableView setContentOffset:CGPointMake(0, kDateViewHeight) animated:NO];
                    }else {
                        [_tableView setContentOffset:CGPointMake(0, 0) animated:NO];
                    }
                }else { // 加载更多
                    if (_dataList.count && [responseObject count] < 1) {
                        [SVProgressHUD showInfoWithStatus:@"没有更多活动啦^_^"];
                        return;
                    }
                    [_dataList addObjectsFromArray:responseObject];
                }
            }
            
            
            if (_dataList.count < 1) {
                // 请求不到数据时，进行提示
                
                NoDataNoticeView *noticeView = [weakSelf showErrorMessage:@"内容还在采集，请等等再来。" frame:CGRectMake(0, weakSelf.topMaskView.maxY, kScreenWidth, kScreenHeight - HEIGHT_TOP_BAR - weakSelf.topMaskView.maxY) promptStyle:NoDataPromptStyleClickRefreshForNoContent parentView:weakSelf.view callbackBlock:^(id object, NSInteger index, BOOL isSameIndex) {
                    [weakSelf loadCalendarListData:YES isClearData:YES];
                }];
                [noticeView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.and.bottom.equalTo(weakSelf.view);
                    make.top.equalTo(weakSelf.topMaskView.mas_bottom);
                }];
            }else {
                [weakSelf removeNoticeView:weakSelf.view];
            }
            
            [_tableView reloadData];
        }else {
            if (_dataList.count) {
                if (!isRefresh && isClearData) {
                    // 切换Tag
                    [weakSelf clearAdvertData];
                    [_dataList removeAllObjects];
                    [_tableView reloadData];
                }else {
                    [SVProgressHUD showInfoWithStatus:responseObject];
                    return;
                }
            }
            
            [SVProgressHUD dismiss];
            
            NoDataNoticeView *noticeView = [weakSelf showErrorMessage:responseObject frame:CGRectMake(0, weakSelf.topMaskView.maxY, kScreenWidth, kScreenHeight - HEIGHT_TOP_BAR - weakSelf.topMaskView.maxY) promptStyle:NoDataPromptStyleClickRefreshForNoContent parentView:weakSelf.view callbackBlock:^(id object, NSInteger index, BOOL isSameIndex) {
                [weakSelf loadCalendarListData:YES isClearData:YES];
            }];
            [noticeView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.and.bottom.equalTo(weakSelf.view);
                make.top.equalTo(weakSelf.topMaskView.mas_bottom);
            }];
        }
        
    }];
}

//请求广告数据
- (void)loadAdvertData:(BOOL)isRefresh {
    WS(weakSelf);
    EnumCacheMode cacheMode = isRefresh ? CACHE_MODE_REALTIME : CACHE_MODE_HALFREALTIME_SHORT;
    
    [AppProtocol getCalendarAdvertListWithDate:[DateTool dateStringForDate:_dateSelectView.currentSelectedDate] cacheMode:cacheMode UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        if (responseCode == HttpResponseSuccess) {
            weakSelf.advModel = responseObject;
            [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }
    }];
}

- (void)userCollectRequestWithIsCancel:(BOOL)isCancel indexPath:(NSIndexPath *)indexPath completionBlock:(void(^)(BOOL success))block {
    if ([self userCanOperateAfterLogin]) {
        id model = _dataList[indexPath.row-1];
        NSString *modelId = @"";
        DataType type = DataTypeUnknown;
        if ([model isKindOfClass:[ActivityModel class]]) {
            type = DataTypeCalendarActivity;
            modelId = [model activityId];
        }else if ([model isKindOfClass:[ActivityGatherModel class]]) {
            type = DataTypeCalendarGatherActivity;
            modelId = [model gatherId];
        }
        
        [AppProtocol userCollectOperationWithDataType:type isCancel:isCancel modelId:modelId UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
            if (responseCode == HttpResponseSuccess) {
                if (isCancel) {
                    [SVProgressHUD showSuccessWithStatus:responseObject];
                }else {
                    [SVProgressHUD showSuccessWithStatus:@"已成功添加到我的文化日历"];
                }
                if (block) { block(YES); }
            }else {
                [SVProgressHUD showInfoWithStatus:responseObject];
                if (block) { block(NO); }
            }
        }];
    }
}

- (void)clearAdvertData {
    self.advModel = nil;
}

#pragma mark - UITableView Data Source And Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataList.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        if (self.advModel) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID_BlankCell forIndexPath:indexPath];
            cell.contentView.backgroundColor = kBgColor;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ConvertSize(380))];
            UIImage *placeImg = [UIToolClass getPlaceholderWithViewSize:imgView.viewSize centerSize:CGSizeMake(20, 20) isBorder:NO];
            [imgView sd_setImageWithURL:[NSURL URLWithString:JointedImageURL(self.advModel.advImgUrl, kImageSize_CalendarAdv)] placeholderImage:placeImg];
            [cell.contentView addSubview:imgView];
            
            MYMaskView *line = [MYMaskView maskViewWithBgColor:kBgColor frame:CGRectMake(0, imgView.maxY, kScreenWidth, cell.height-imgView.maxY) radius:0];
            [cell.contentView addSubview:line];
            
            return cell;
        }
    }else {
        if ([_dataList[indexPath.row-1] isKindOfClass:[ActivityModel class]]) {
            ActivityModel *model = _dataList[indexPath.row-1];
            
            ActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID_Activity forIndexPath:indexPath];
            [cell showCollectButton:YES];
            [cell setModel:_dataList[indexPath.row-1] type:1 forIndexPath:indexPath];
            
            WS(weakSelf)
            [cell setButtonActionHandler:^(UIButton *sender, NSInteger index) {
                if (index == 1) {
                    [weakSelf userCollectRequestWithIsCancel:sender.selected indexPath:indexPath completionBlock:^(BOOL success) {
                        if (success) {
                            sender.selected = !sender.selected;
                            model.activityIsCollect = sender.selected;
                        }
                    }];
                }
            }];
            
            return cell;
        }else if ([_dataList[indexPath.row-1] isKindOfClass:[ActivityGatherModel class]]) {
            
            ActivityGatherModel *model = _dataList[indexPath.row-1];
            if (model.gatherIconUrl.length) {
                CalendarListPictureCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID_Picture forIndexPath:indexPath];
                
                WS(weakSelf)
                [cell setButtonActionHandler:^(UIButton *sender, NSInteger index) {
                    if (index == 1) {
                        [weakSelf userCollectRequestWithIsCancel:sender.selected indexPath:indexPath completionBlock:^(BOOL success) {
                            if (success) {
                                sender.selected = !sender.selected;
                                model.gatherIsCollect = sender.selected;
                            }
                        }];
                    }
                }];
                [cell setModel:model forIndexPath:indexPath];
                
                return cell;
            }else {
                CalendarListTextCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID_Text forIndexPath:indexPath];
                
                WS(weakSelf)
                [cell setButtonActionHandler:^(UIButton *sender, NSInteger index) {
                    if (index == 1) {
                        [weakSelf userCollectRequestWithIsCancel:sender.selected indexPath:indexPath completionBlock:^(BOOL success) {
                            if (success) {
                                sender.selected = !sender.selected;
                                model.gatherIsCollect = sender.selected;
                            }
                        }];
                    }
                }];
                [cell setModel:model forIndexPath:indexPath];
                
                return cell;
            }
        }
    }
    
    RETURN_BLANK_CELL
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        if (self.advModel) {
            return ConvertSize(380)+ 6;
        }
    }else {
        if ([_dataList[indexPath.row-1] isKindOfClass:[ActivityModel class]]) {
            return kScreenWidth*kPicScale_ListCover + 76;
        }else if ([_dataList[indexPath.row-1] isKindOfClass:[ActivityGatherModel class]]) {
            ActivityGatherModel *model = _dataList[indexPath.row-1];
            CGFloat cellHeight = [[_cellHeightCache valueForKey:model.gatherId] floatValue];
            if (cellHeight > 0) {
                return cellHeight;
            }
            
            if (model.gatherIconUrl.length) {
                cellHeight = [CalendarListPictureCell cellHeightForModel:model];
                [_cellHeightCache setValue:[NSNumber numberWithFloat:cellHeight] forKey:model.gatherId];
                return cellHeight;
            }else {
                cellHeight = [CalendarListTextCell cellHeightForModel:model];
                [_cellHeightCache setValue:[NSNumber numberWithFloat:cellHeight] forKey:model.gatherId];
                return cellHeight;
            }
        }
    }
    return 0.01f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        if (self.advModel) {
            [HomepageViewController goToAdvertPage:self.advModel shareImage:nil sourceVC:self.navigationController];
        }
    }else {
        if ([ToolClass dataIsValid:indexPath.row-1 forArrayCount:_dataList.count]) {
            
            if ([_dataList[indexPath.row-1] isKindOfClass:[ActivityModel class]]) {
                ActivityModel *model = _dataList[indexPath.row-1];
                
                ActivityDetailViewController *vc = [ActivityDetailViewController new];
                vc.activityId = model.activityId;
                WEAK_VIEW(tableView);
                vc.collectOperationHandler = ^(NSString *activityId, BOOL activityIsCollect) {
                    model.activityIsCollect = activityIsCollect;
                    [weakView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                };
                [self.navigationController pushViewController:vc animated:YES];
            }else if ([_dataList[indexPath.row-1] isKindOfClass:[ActivityGatherModel class]]) {
                ActivityGatherModel *model = _dataList[indexPath.row-1];
                if (model.gatherLink.length) {
                    WebViewController *vc = [WebViewController new];
                    vc.url = model.gatherLink;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
        }
    }
}

#pragma mark - Delegate Method

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (offsetY < kDateViewHeight) {
        if (self.topMaskView.originalY == 0 && offsetY >= 0) {
            // 这里主要是：防止从下面返回到顶部时，出现跳跃
            _preOffsetY = offsetY;
            return;
        }
        
        [self.topMaskView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(-offsetY).priorityMedium();
        }];
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
        _preOffsetY = offsetY;
        return;
    }
    
    if ( offsetY >= scrollView.contentSize.height-scrollView.height) {
        // 防止在底部拖拽过度返回时，浮层又滑动下来
        _preOffsetY = offsetY;
        return;
    }
    
    if (offsetY > kDateViewHeight) {
        if (offsetY - _preOffsetY < 0) {
            // 手指向下滑动，浮层完全显示
            [self maskViewAnimation:YES];
        }else if (offsetY - _beginDragOffsetY > 10) {
            // 手指向上滑动，浮层隐藏一部分
            [self maskViewAnimation:NO];
        }
    }
    _preOffsetY = offsetY;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _beginDragOffsetY = scrollView.contentOffset.y;
}

- (void)maskViewAnimation:(BOOL)fullShow {
    CGFloat position = fullShow ? 0 : -kDateViewHeight;
    
    if (self.topMaskView.originalY == position) {
        return;
    }
    
    [self.topMaskView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(position).priorityMedium();
    }];
    
    [UIView animateWithDuration:0.3f animations:^{
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
    }];
}

- (void)tagSelectView:(TagSelectScrollView *)tagSelectView didSelectItem:(ThemeTagModel *)model forIndex:(NSInteger)index {
    _selectedTagName = model.tagName;
    
    if (!tagSelectView.isSameButton) {
        [self loadCalendarListData:NO isClearData:YES];
    }
}



- (void)handleCollectOperationFromOtherPage:(NSString *)modelId isCollect:(BOOL)isCollect {
    NSInteger row = -1;
    for (NSInteger i = 0; i < _dataList.count; i++) {
        if ([_dataList[i] isKindOfClass:[ActivityModel class]]) {
            ActivityModel *model = _dataList[i];
            if ([model.activityId isEqualToString:modelId]) {
                model.activityIsCollect = isCollect;
                row = i;
                break;
            }
        }else if ([_dataList[i] isKindOfClass:[ActivityGatherModel class]]) {
            ActivityGatherModel *model = _dataList[i];
            if ([model.gatherId isEqualToString:modelId]) {
                model.gatherIsCollect = isCollect;
                row = i;
                break;
            }
        }
    }
    
    if (row >= 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row+1 inSection:0];
        [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)userLoginSuccess {
    [super userLoginSuccess];
    [self loadCalendarListData:YES isClearData:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
