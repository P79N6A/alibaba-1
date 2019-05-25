//
//  MyCollectionViewController.m
//  CultureHongshan
//
//  Created by ct on 15/11/12.
//  Copyright © 2015年 CT. All rights reserved.
//

#import "MyCollectionViewController.h"

#import "CollectCell.h"//我的收藏单元格

#import "CustomSegmentView.h"

#import "ActivityDetailViewController.h"
#import "VenueDetailViewController.h"

#import "UserCollectModel.h"

#import "MJRefresh.h"


#define tableCellHeight 100

static NSString *reuseId = @"cellId";
static NSString *reuseId_LineCell = @"LineCell";
static NSString *reuseID_NoResultsTip = @"NoResultsTip";


@interface MyCollectionViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    __block UITableView *_tableView;
    
    CustomSegmentView *_segmentView;
    
    NSInteger _currentIndex;
    
    CGFloat _lastOffset[2];//记录表的偏移量
}

@property (nonatomic, strong) NSMutableArray *listArray;


@end


@implementation MyCollectionViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = kBgColor;
    self.navigationItem.title = @"我的收藏";
    
    _listArray = [NSMutableArray new];
    _listArray[0] = [NSMutableArray new];
    _listArray[1] = [NSMutableArray new];
    
    [self initSegmentView];
    [self initTabelView];
    [self initRefreshControl];
    
    [self startRequestCollectListData:YES index:0];
}



- (void)initSegmentView
{
    WS(weakSelf)
    
    //分段选择视图
    _segmentView = [CustomSegmentView segmentViewWithFrame:CGRectMake(0, 0, kScreenWidth, 41)
                                               normalColor:ColorFromHex(@"494D5B")
                                             selectedColor:ColorFromHex(@"5e6d98")
                                                 lineColor:[UIColor blueColor]
                                               titleArrray:@[@"活动",@"场馆"]
                                             callBackBlock:^(id object, NSInteger index, BOOL isSameIndex)
                    {
                        [weakSelf removeNoticeView:weakSelf.view];
                        _tableView.userInteractionEnabled = 1;
                        
                        if (isSameIndex == NO)
                        {
                            CGFloat lastOffsetY = _lastOffset[index];
                            _lastOffset[1-index] = _tableView.contentOffset.y;
                            _tableView.contentOffset = CGPointMake(0, lastOffsetY);
                        }
                        
                        if ([_listArray[index] count] < 1)
                        {
                            _currentIndex = index;
                            [_tableView reloadData];
                            [weakSelf startRequestCollectListData:YES index:index];
                        }
                        else
                        {
                            _currentIndex = index;
                            [_tableView reloadData];
                        }
                    }];
    [self.view addSubview:_segmentView];
}


- (void)initTabelView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.backgroundColor = kBgColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:reuseID_NoResultsTip];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:reuseId_LineCell];
    [_tableView registerClass:[CollectCell class] forCellReuseIdentifier:reuseId];
    
    [_tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_segmentView.mas_bottom);
        make.left.right.and.bottom.equalTo(self.view);
    }];
}


#pragma mark - 初始化刷新控件

- (void)initRefreshControl
{
    //头部的刷新控件
    __weak MyCollectionViewController *weakSelf = self;
    
    MJRefreshNormalHeader *headerRefresh = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf startRequestCollectListData:YES index:_currentIndex];
    }];
    headerRefresh.lastUpdatedTimeLabel.hidden = NO;
    headerRefresh.stateLabel.font = FontYT(12);
    _tableView.header = headerRefresh;
    
    
    //尾部的刷新控件
    MJRefreshBackNormalFooter *footerRefresh = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf startRequestCollectListData:NO index:_currentIndex];
    }];
    footerRefresh.stateLabel.font = FontYT(12);
    _tableView.footer = footerRefresh;
}


#pragma mark - 请求数据

- (void)startRequestCollectListData:(BOOL)isClearData index:(NSInteger)index
{
    DataType type = (index == 0) ? DataTypeActivity : DataTypeVenue;// 1- 活动，  2-场馆
    
    NSInteger pageIndex = 0;
    if ([_listArray[index] count] < 1)
    {
        isClearData = YES;
    }
    
    if (isClearData == NO) {
        pageIndex = [_listArray[index] count];
    }
    EnumCacheMode cacheMode = isClearData ? CACHE_MODE_REALTIME : CACHE_VALID_TIME_SHORT;
    
    WS(weakSelf)
    [AppProtocol getUserCollectListWithDataType:type searchKey:nil pageIndex:pageIndex pageNum:kRefreshCount cacheMode:cacheMode UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        
        [_tableView.header endRefreshing];
        [_tableView.footer endRefreshing];
        [SVProgressHUD dismiss];
        
        if (responseCode == HttpResponseSuccess) {
            NSArray *resultArray = responseObject;
            
            if (isClearData) {
                _listArray[index] = [NSMutableArray arrayWithArray:resultArray];
                if (resultArray.count < 1 || resultArray == nil) {
                    [weakSelf showNoticeView:@"您还没有收藏过呢^_^" isNoContent:YES];
                }
            }else {
                
                if (resultArray.count < 1) {
                    [SVProgressHUD showInfoWithStatus:@"数据已经全部加载完了^_^"];
                    return;
                }
                _listArray[index] = [NSMutableArray arrayWithArray:[_listArray[index] arrayByAddingObjectsFromArray:resultArray]];
            }
            
            _currentIndex = index;
            [_tableView reloadData];
            
        } else  {
            //请求失败
            if ([responseObject isKindOfClass:[NSString class]]) {
                
                if ([_listArray[index] count]) {
                    [SVProgressHUD showErrorWithStatus:responseObject];
                } else {
                    [weakSelf showNoticeView:responseObject isNoContent:NO];
                }
            }
            
        }
        
    }];
}


#pragma mark - TableView Delegate & DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = [_listArray[_currentIndex] count];
    return count*2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row%2 == 0)
    {
        CollectCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId forIndexPath:indexPath];
        
        UserCollectModel *model = _listArray[_currentIndex][indexPath.row/2];
        
        [cell setModel:model forIndexPath:indexPath];
        
        return cell;
    }
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId_LineCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = kBgColor;
        return cell;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (indexPath.row%2 == 0) ? tableCellHeight : 10;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([_listArray[_currentIndex] count] && indexPath.row%2 == 0)
    {
        UserCollectModel *model = _listArray[_currentIndex][indexPath.row/2];
        
        __weak MyCollectionViewController *weakSelf = self;
        
        if (model.type == 1)//活动
        {
            ActivityDetailViewController *vc = [ActivityDetailViewController new];
            vc.collectOperationHandler = ^(NSString *modelId, BOOL isCollect) {
                [weakSelf startRequestCollectListData:YES index:_currentIndex];
            };
            vc.activityId = model.modelId;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if (model.type == 2)//场馆
        {
            VenueDetailViewController *vc = [VenueDetailViewController new];
            vc.collectRefreshBlock = ^{
                [weakSelf startRequestCollectListData:YES index:_currentIndex];
            };
            vc.venueId = model.modelId;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_listArray[_currentIndex] count] && indexPath.row%2 == 0)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_listArray[_currentIndex] count] && indexPath.row%2 == 0 && editingStyle == UITableViewCellEditingStyleDelete)
    {
        UserCollectModel *model = _listArray[_currentIndex][indexPath.row/2];
        
        //删除失败也没关系吧？
        DataType type = (_currentIndex == 0) ? DataTypeActivity : DataTypeVenue;
        
        [AppProtocol cancelCollectWithDataType:type modelId:model.modelId UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
            if (responseCode == HttpResponseSuccess) {
                [_listArray[_currentIndex] removeObjectAtIndex:indexPath.row/2];
                [_tableView reloadData];
            }else {
                [SVProgressHUD showInfoWithStatus:responseObject];
            }
        }];
    }
}


#pragma mark - Button Action Methods

/**
 *  网络链接错误或没有内容时的提示信息
 *
 *  @param notice      提示信息
 *  @param isNoContent YES，没有收藏的纪录；NO，网络链接的问题
 */
- (void)showNoticeView:(NSString *)notice isNoContent:(BOOL)isNoContent
{
    WS(weakSelf)
    NoDataNoticeView *noticeView = [NoDataNoticeView noticeViewWithFrame:CGRectMake(0, _segmentView.height, kScreenWidth, kScreenHeight-HEIGHT_TOP_BAR-_segmentView.height)
                                                                 bgColor:kBgColor
                                                                 message:notice
                                                             promptStyle:isNoContent ? NoDataPromptStyleClickRefreshForNoContent : NoDataPromptStyleClickRefreshForError
                                                           callbackBlock:^(id object, NSInteger index, BOOL isSameIndex) {
                                        [weakSelf startRequestCollectListData:YES index:_currentIndex];
                                    }];
    [self.view addSubview:noticeView];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
