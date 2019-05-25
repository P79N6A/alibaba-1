//
//  AccumulativeScoreListViewController.m
//  CultureHongshan
//
//  Created by ct on 16/6/13.
//  Copyright © 2016年 CT. All rights reserved.
//

#import "AccumulativeScoreListViewController.h"

// View And Cell
#import "AccumulativeScoreCell.h"



// Model
#import "UserAccumulativeScoreModel.h"

// Other
#import "MJRefresh.h"



static NSString *reuseId_Cell = @"Cell";

@interface AccumulativeScoreListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *listArray;
@property (nonatomic, strong) UITableView *tableView;

@end


@implementation AccumulativeScoreListViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"所有积分明细";
    self.listArray = [NSMutableArray new];
    
    [self initTableView];
    [self initRefreshControl];
    
    [self startRequestAccumulativeScoreRecord:YES];
}



- (void)initTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.backgroundColor = kBgColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    [_tableView registerClass:[AccumulativeScoreCell class] forCellReuseIdentifier:reuseId_Cell];
    
    [_tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

//#pragma mark - 初始化刷新控件
- (void)initRefreshControl
{
    //头部的刷新控件
    WS(weakSelf);
    
    MJRefreshNormalHeader *headerRefresh = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf startRequestAccumulativeScoreRecord:YES];
    }];
    headerRefresh.lastUpdatedTimeLabel.hidden = NO;
    headerRefresh.stateLabel.font = FontYT(12);
    _tableView.header = headerRefresh;
    
    //尾部的刷新控件
    MJRefreshBackNormalFooter *footerRefresh = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf startRequestAccumulativeScoreRecord:NO];
    }];
    footerRefresh.stateLabel.font = FontYT(12);
    _tableView.footer = footerRefresh;
}



#pragma mark - 数据请求

//获取积分的奖惩纪录(积分明细)
- (void)startRequestAccumulativeScoreRecord:(BOOL)isClearData
{
    if (_listArray.count < 1)
    {
        isClearData = YES;
    }
    NSInteger pageIndex = 0;
    if (isClearData == NO) {
        pageIndex = _listArray.count;
    }
    
    WS(weakSelf);
    [SVProgressHUD showLoading];
    
    [AppProtocol getUserIntegralListWithType:2 pageIndex:pageIndex pageNum:kRefreshCount cacheMode:CACHE_MODE_REALTIME UsingBlock:^(HttpResponseCode responseCode, id responseObject)
     {
         [_tableView.header endRefreshing];
         [_tableView.footer endRefreshing];
         [SVProgressHUD dismiss];
         
         if (responseCode == HttpResponseSuccess)
         {
             _didRequestData = YES;
             NSArray *resultArray = responseObject;
             
             if (isClearData)
             {
                 [_listArray removeAllObjects];
                 [_listArray addObjectsFromArray:resultArray];
             }else
             {
                 if (resultArray.count < 1)
                 {
                     [SVProgressHUD showInfoWithStatus:@"数据已经全部加载完了^_^"];
                     return;
                 }
                 [_listArray addObjectsFromArray:resultArray];
             }
             [_tableView reloadData];
         }
         else//请求失败
         {
             if ([responseObject isKindOfClass:[NSString class]]) {
                 if (_listArray.count) {
                     [SVProgressHUD showInfoWithStatus:responseObject];
                 }
                 else
                 {
                     [weakSelf noMessageNotice:responseObject];
                 }
             }
             
         }
     }];
}

#pragma mark - UITableViewDataSource And Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (_listArray.count == 0 && _didRequestData) ? 1 : _listArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_listArray.count == 0 && _didRequestData) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoDataNoticeCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NoDataNoticeCell"];
            cell.textLabel.font = FontYT(17);
            cell.textLabel.textColor = kDeepLabelColor;
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.textLabel.text = @"您还没有积分信息呢～";
        return cell;
    }else
    {
        AccumulativeScoreCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId_Cell forIndexPath:indexPath];
        
        UserAccumulativeScoreModel *model = _listArray[indexPath.row];
        [cell setModel:model isLineHiddden:indexPath.row == _listArray.count-1];
        return cell;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
}


//无消息时的提示
- (void)noMessageNotice:(NSString *)message
{
    WS(weakSelf);
    
    NoDataNoticeView *noticeView = [NoDataNoticeView noticeViewWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-HEIGHT_TOP_BAR) bgColor:[UIColor whiteColor] message:message promptStyle:NoDataPromptStyleClickRefreshForError callbackBlock:^(id object, NSInteger index, BOOL isSameIndex) {
        [weakSelf startRequestAccumulativeScoreRecord:YES];
    }];
    [self.view addSubview:noticeView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
