//
//  MyCalendarViewController.m
//  CultureHongshan
//
//  Created by ct on 17/2/10.
//  Copyright © 2017年 CT. All rights reserved.
//

#import "MyCalendarViewController.h"

// View Controllers
#import "ActivityDetailViewController.h"
#import "CommonMultiTableViewController.h"
#import "WebViewController.h"

// Views
#import "CalendarListCell.h"
#import "ActivityCell.h"

// Models
#import "ActivityGatherModel.h"
#import "ActivityModel.h"

// Other


static NSString *reuseID_Text = @"TextCell";
static NSString *reuseID_Picture = @"PictureCell";
static NSString *reuseID_Activity = @"ActivityCell";

@interface MyCalendarViewController () <UITableViewDelegate, UITableViewDataSource>
{
    __block NSMutableArray *_dataList;
    NSMutableDictionary *_cellHeightCache;
    NSMutableArray *_dateArray;
    NSInteger _dateIndex;
    BOOL _isParticipated;
    
    
    UITableView *_tableView;
    UIButton *_lastSelectedButton;
    
}
@property (nonatomic, strong) UIView *indicatorView;
@end

@implementation MyCalendarViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _dateArray = [NSMutableArray arrayWithCapacity:5];
    _dataList = [NSMutableArray arrayWithCapacity:0];
    _cellHeightCache = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [self initNavgationBar];
    
    [self loadUI];
    
    [self loadCalendarListData:YES isParticipated:NO isClearData:YES];
}


- (void)initNavgationBar {
    self.navigationItem.title = @"文化日历";
}

- (void)loadUI {
    WS(weakSelf)
    
    // 顶部工具条
    UIView *toolView = [UIView new];
    toolView.backgroundColor = kWhiteColor;
    [self.view addSubview:toolView];
    
    self.indicatorView = [MYMaskView maskViewWithBgColor:kThemeDeepColor frame:CGRectZero radius:0];
    [toolView addSubview:self.indicatorView];
    
    [self handleRequestDateArray];
    
    // 已参加
    MYSmartButton *participateButton = [[MYSmartButton alloc] initWithFrame:CGRectZero title:@"已参加" font:FontYT(15) tColor:RGB(135, 135, 135) bgColor:kWhiteColor actionBlock:^(MYSmartButton *sender) {
        if (sender.selected) {
            return;
        }
        _isParticipated = YES;
        [weakSelf.indicatorView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(sender);
            make.height.mas_equalTo(1);
            make.width.equalTo(sender).multipliedBy(0.8);
            make.bottom.equalTo(sender.mas_bottom).offset(-7);
        }];
        
        [UIView animateWithDuration:0.3f animations:^{
            [toolView setNeedsLayout];
            [toolView layoutIfNeeded];
        }];
        
        sender.selected = YES;
        _lastSelectedButton.selected = NO;
        _lastSelectedButton = sender;
        
        [weakSelf loadCalendarListData:NO isParticipated:YES isClearData:YES];
    }];
    [participateButton setTitleColor:kThemeDeepColor forState:UIControlStateSelected];
    [toolView addSubview:participateButton];
    
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.frame = CGRectMake(-4, 0, 20, 54);
    layer.colors = @[(__bridge id)RGB(0xe3, 0xe3, 0xe3).CGColor, (__bridge id)[UIColor whiteColor].CGColor]; // RGB(0xF3, 0xF3, 0xF3)
    layer.startPoint = CGPointMake(0, 0);
    layer.endPoint = CGPointMake(0.4, 0);
    layer.opacity = 0.6;
    [participateButton.layer addSublayer:layer];
    
    // 日期
    UIButton *preButton = nil;
    for (int i = 0; i < _dateArray.count; i++) {
        
        int month = [[_dateArray[i][0] substringWithRange:NSMakeRange(5, 2)] intValue];
        NSString *monthString = [NSString stringWithFormat:@"%d月", month];
        
        MYSmartButton *dateButton = [[MYSmartButton alloc] initWithFrame:CGRectZero title:monthString font:FontYT(14) tColor:kDeepLabelColor bgColor:nil actionBlock:^(MYSmartButton *sender) {
            _isParticipated = NO;
            if (sender.selected) {
                return;
            }
            
            [weakSelf.indicatorView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(sender);
                make.height.mas_equalTo(1);
                make.width.equalTo(sender).multipliedBy(0.8);
                make.bottom.equalTo(sender.mas_bottom).offset(-7);
            }];
            
            [UIView animateWithDuration:0.3f animations:^{
                [toolView setNeedsLayout];
                [toolView layoutIfNeeded];
            }];
            
            _dateIndex = sender.tag;
            
            [weakSelf loadCalendarListData:NO isParticipated:NO isClearData:YES];
            sender.selected = YES;
            _lastSelectedButton.selected = NO;
            _lastSelectedButton = sender;
        }];
        dateButton.tag = i;
        dateButton.selected = (i == 0);
        [dateButton setTitleColor:kThemeDeepColor forState:UIControlStateSelected];
        [toolView addSubview:dateButton];
        
        [dateButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.bottom.equalTo(participateButton);
            if (preButton) {
                make.left.equalTo(preButton.mas_right);
                make.width.equalTo(preButton);
            }else {
                make.left.mas_offset(0);
            }
        }];
        
        if (i == 0) {
            _lastSelectedButton = dateButton;
            
            [weakSelf.indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(dateButton);
                make.height.mas_equalTo(1);
                make.width.equalTo(dateButton).offset(-16);
                make.bottom.equalTo(dateButton.mas_bottom).offset(-7);
            }];
        }
        
        preButton = dateButton;
    }
    [preButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(participateButton.mas_left);
    }];
    
    // 表视图
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[CalendarListTextCell class] forCellReuseIdentifier:reuseID_Text];
    [_tableView registerClass:[CalendarListPictureCell class] forCellReuseIdentifier:reuseID_Picture];
    [_tableView registerClass:[ActivityCell class] forCellReuseIdentifier:reuseID_Activity];
    [self.view addSubview:_tableView];
    [CommonMultiTableViewController setupRefresh:_tableView withBlock:^(BOOL isRefresh) {
        if (isRefresh) {
            [weakSelf loadCalendarListData:YES isParticipated:_isParticipated isClearData:YES];
        }else {
            [weakSelf loadCalendarListData:NO isParticipated:_isParticipated isClearData:NO];
        }
    }];
    
    [toolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.top.equalTo(weakSelf.view);
        make.height.mas_equalTo(54);
    }];
    
    [participateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(toolView);
        make.bottom.equalTo(toolView).offset(-4);
        make.width.mas_equalTo(preButton).multipliedBy(1.2);
    }];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view);
        make.top.equalTo(toolView.mas_bottom).offset(6);
    }];
    
    [toolView bringSubviewToFront:self.indicatorView];
}

#pragma mark - 数据请求与处理

- (void)handleRequestDateArray {
    [_dateArray removeAllObjects];
    
    NSDate *startDate = [NSDate date];
    NSDate *endDate = [DateTool lastDayOfMonthForDate:startDate];
    
    [_dateArray addObject:@[[DateTool dateStringForDate:startDate], [DateTool dateStringForDate:endDate]]];
    
    for (int i = 0; i < 4; i++) {
        startDate = [DateTool dateByAddMonthNum:1 toDate:startDate];
        endDate = [DateTool lastDayOfMonthForDate:startDate];
        
        [_dateArray addObject:@[[DateTool dateStringForDate:startDate], [DateTool dateStringForDate:endDate]]];
    }
    
    
}

- (void)loadCalendarListData:(BOOL)isRefresh isParticipated:(BOOL)isParticipated isClearData:(BOOL)isClearData {
    /*
     
     1. 在一个Tag下,下拉刷新————Advert 与 dataList 都要清空，isRefresh＝YES，isClearData＝YES
     2. 在一个Tag下，加载更多————Advert不变，dataList合并。isRefresh＝NO，isClearData＝NO
     3. 切换Tag———————————Advert 与 dataList 都要清空，isRefresh＝NO，isClearData＝YES
     
     */
    
    if (_dataList.count < 1) {
        isRefresh = YES;
    }
    
    NSInteger pageIndex = 0;
    if (!isRefresh && !isClearData && _dataList.count > 0) {
        pageIndex = _dataList.count;
    }
    
    WS(weakSelf)
    void(^completionHandler)(HttpResponseCode responseCode, id responseObject) = ^(HttpResponseCode responseCode, id responseObject) {
        [_tableView.header endRefreshing];
        [_tableView.footer endRefreshing];
        

        if (responseCode == HttpResponseSuccess) {
            [SVProgressHUD dismiss];
            
            if (isRefresh) { // 下拉刷新
                [_dataList removeAllObjects];
                [_dataList addObjectsFromArray:responseObject];
            }else {
                if (isClearData) { // 切换Tag
                    [_dataList removeAllObjects];
                    [_dataList addObjectsFromArray:responseObject];
                    
                    [_tableView setContentOffset:CGPointMake(0, 0) animated:NO];
                }else { // 加载更多
                    if (_dataList.count && [responseObject count] < 1) {
                        [SVProgressHUD showInfoWithStatus:@"没有更多数据啦^_^"];
                        return;
                    }
                    [_dataList addObjectsFromArray:responseObject];
                }
            }
            
            if (_dataList.count < 1) {
                // 请求不到数据时，进行提示
                [weakSelf showErrorMessage:@"内容还在采集，请等等再来。" frame:_tableView.frame promptStyle:NoDataPromptStyleClickRefreshForNoContent parentView:weakSelf.view callbackBlock:^(id object, NSInteger index, BOOL isSameIndex) {
                    [weakSelf loadCalendarListData:YES isParticipated:_isParticipated isClearData:YES];
                }];
            }else {
                [weakSelf removeNoticeView:weakSelf.view];
            }
            
            [_tableView reloadData];
            
        }else {
            if (_dataList.count) {
                if (isRefresh == NO && isClearData) {
                    // 切换Tag
                    [_dataList removeAllObjects];
                    [_tableView reloadData];
                }else {
                    [SVProgressHUD showInfoWithStatus:responseObject];
                    return;
                }
            }
            
            [SVProgressHUD dismiss];
            
            [weakSelf showErrorMessage:responseObject
                                 frame:_tableView.frame
                           promptStyle:NoDataPromptStyleClickRefreshForNoContent
                            parentView:weakSelf.view
                         callbackBlock:^(id object, NSInteger index, BOOL isSameIndex)
             {
                 [weakSelf loadCalendarListData:YES isParticipated:_isParticipated isClearData:YES];
             }];
        }
    };
    
    [SVProgressHUD showLoading];
    if (isParticipated) {
        // 已参加的
        [AppProtocol getMyCalendarHistoryListWithPageIndex:pageIndex cacheMode:CACHE_MODE_REALTIME UsingBlock:completionHandler];
    }else {
        // 按照日期筛选
        NSInteger dateIndex = _dateIndex;
        
        NSString *startDate = _dateArray[dateIndex][0];
        NSString *endDate = _dateArray[dateIndex][1];
        
        [AppProtocol getMyCalendarListWithStartDate:startDate endDate:endDate pageIndex:pageIndex cacheMode:CACHE_MODE_REALTIME UsingBlock:completionHandler];
    }
}

/**  收藏操作 */
- (void)userCollectRequestWithIsCancel:(BOOL)isCancel indexPath:(NSIndexPath *)indexPath completionBlock:(void(^)(BOOL success))block {
    id model = _dataList[indexPath.row];
    NSString *modelId = @"";
    DataType type = DataTypeUnknown;
    if ([model isKindOfClass:[ActivityModel class]]) {
        type = DataTypeCalendarActivity;
        modelId = [model activityId];
    }else if ([model isKindOfClass:[ActivityGatherModel class]]) {
        type = DataTypeCalendarGatherActivity;
        modelId = [model gatherId];
    }
    
    WS(weakSelf)
    [AppProtocol userCollectOperationWithDataType:type isCancel:isCancel modelId:modelId UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        if (responseCode == HttpResponseSuccess) {
            [SVProgressHUD showSuccessWithStatus:responseObject];
            if (block) { block(YES); }
            if (weakSelf.collectOperationHandler) { weakSelf.collectOperationHandler(modelId, !isCancel); }
        }else {
            [SVProgressHUD showInfoWithStatus:responseObject];
            if (block) { block(NO); }
        }
    }];
}




#pragma mark - UITableView Data Source And Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_dataList[indexPath.row] isKindOfClass:[ActivityModel class]]) {
        ActivityModel *model = _dataList[indexPath.row];
        
        ActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID_Activity forIndexPath:indexPath];
        if (_isParticipated) {
            [cell showCollectButton:NO];
            
            [cell setModel:_dataList[indexPath.row] type:4 forIndexPath:indexPath];
        }else {
            if (model.orderOrCollect == 2) {
                [cell showCollectButton:YES];
            }else {
                [cell showCollectButton:NO];
            }
            
            [cell setModel:_dataList[indexPath.row] type:3 forIndexPath:indexPath];
        }
        [cell hideTypeView:YES];
        
        WS(weakSelf)
        [cell setButtonActionHandler:^(UIButton *sender, NSInteger index) {
            if (index == 1) {
                WEAK_VIEW(tableView)
                [weakSelf userCollectRequestWithIsCancel:sender.selected indexPath:indexPath completionBlock:^(BOOL success) {
                    if (success) {
                        sender.selected = !sender.selected;
                        model.activityIsCollect = sender.selected;
                        if (model.orderOrCollect == 2 && sender.selected == NO) {
                            
                            [_dataList removeObjectAtIndex:indexPath.row];
                            
                            [weakView beginUpdates];
                            [weakView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                            [weakView endUpdates];
                        }
                    }
                }];
            }
        }];
        
        return cell;
    }else if ([_dataList[indexPath.row] isKindOfClass:[ActivityGatherModel class]]) {
        
        ActivityGatherModel *model = _dataList[indexPath.row];
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
    
    RETURN_BLANK_CELL
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([_dataList[indexPath.row] isKindOfClass:[ActivityModel class]]) {
        return kScreenWidth*kPicScale_ListCover + 76;
    }else if ([_dataList[indexPath.row] isKindOfClass:[ActivityGatherModel class]]) {
        
        ActivityGatherModel *model = _dataList[indexPath.row];
        if (model.gatherIconUrl.length) {
            return [CalendarListPictureCell cellHeightForModel:model];
        }else {
            return [CalendarListTextCell cellHeightForModel:model];
        }
    }
    return 0.01f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([ToolClass dataIsValid:indexPath.row forArrayCount:_dataList.count]) {
        
        if ([_dataList[indexPath.row] isKindOfClass:[ActivityModel class]]) {
            ActivityModel *model = _dataList[indexPath.row];
            
            ActivityDetailViewController *vc = [ActivityDetailViewController new];
            vc.activityId = model.activityId;
            WEAK_VIEW(tableView);
            WS(weakSelf)
            vc.collectOperationHandler = ^(NSString *modelId, BOOL isCollect) {
                model.activityIsCollect = isCollect;
                [weakView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                
                if (weakSelf.collectOperationHandler) {
                    weakSelf.collectOperationHandler(modelId, isCollect);
                }
            };
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([_dataList[indexPath.row] isKindOfClass:[ActivityGatherModel class]]) {
            ActivityGatherModel *model = _dataList[indexPath.row];
            if (model.gatherLink.length) {
                WebViewController *vc = [WebViewController new];
                vc.url = model.gatherLink;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - 



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
