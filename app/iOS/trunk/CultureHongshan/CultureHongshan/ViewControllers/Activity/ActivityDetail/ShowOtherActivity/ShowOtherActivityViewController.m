//
//  ShowOtherActivityViewController.m
//  CultureHongshan
//
//  Created by JackAndney on 16/7/23.
//  Copyright © 2016年 ct. All rights reserved.
//

#import "ShowOtherActivityViewController.h"

#import "ActivityDetailViewController.h"


#import "ActivityModel.h"
#import "VenueModel.h"
#import "ShowOtherActivityModel.h"

#import "ActivityCell.h"
#import "VenueListCell.h"
#import "ShowOtherActivityCell.h"
#import "NoDataNoticeCell.h"

#import "MJRefresh.h"



static NSString *reuseID_Cell       = @"Cell";
static NSString *reuseID_NoticeCell = @"NoticeCell";


@interface ShowOtherActivityViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *listArray;

@end


@implementation ShowOtherActivityViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = kBgColor;
    self.navigationItem.title = @"精彩回顾";
    _listArray = [NSMutableArray arrayWithCapacity:0];
    
    [self initTabelView];
    [self initRefreshControl];
    
    [self startRequestData:NO];
}


- (void)startRequestData:(BOOL)isRefresh
{
    if (_listArray.count < 1)
    {
        isRefresh = YES;
    }

    WS(weakSelf);
    [SVProgressHUD showLoading];
    EnumCacheMode cacheMode = isRefresh ? CACHE_MODE_REALTIME : CACHE_VALID_TIME_SHORT;
    
    [AppProtocol getActivityShowOtherListWithActivityId:self.activityId associationId:self.associationId cacheMode:cacheMode UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        [_tableView.header endRefreshing];
        
        if (responseCode == HttpResponseSuccess)  {
            
            [_listArray removeAllObjects];
            [_listArray addObjectsFromArray:responseObject[1]];
            
            if (_listArray.count == 0) {
                [weakSelf noDataNotice:@"未发现精彩活动，请稍后再试^_^"];
            }else {
                [_tableView reloadData];
            }
            [SVProgressHUD dismiss];
        }else {
            if ([responseObject isKindOfClass:[NSString class]]) {
                if (_listArray.count) {
                    [SVProgressHUD showInfoWithStatus:responseObject];
                }else {
                    [SVProgressHUD dismiss];
                    [weakSelf noDataNotice:responseObject];
                }
            }
        }
    }];
}



- (void)initTabelView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.sectionHeaderHeight = 0;
    _tableView.sectionFooterHeight = 0;
    [self.view addSubview:_tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    [_tableView registerClass:[ShowOtherActivityCell class] forCellReuseIdentifier:reuseID_Cell];
}

- (void)initRefreshControl
{
    //头部的刷新控件
    WS(weakSelf);
    
    MJRefreshNormalHeader *headerRefresh = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf startRequestData:YES];
    }];
    headerRefresh.lastUpdatedTimeLabel.hidden = NO;
    headerRefresh.stateLabel.font = FontSystem(12);
    _tableView.header = headerRefresh;
    
    //尾部的刷新控件
//    MJRefreshBackNormalFooter *footerRefresh = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        [weakSelf startRequestData:NO];
//    }];
//    footerRefresh.stateLabel.font = FontSystem(12);
//    _tableView.footer = footerRefresh;
}

#pragma mark - UITableView DataSource And Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [ToolClass  getGroupNum:_listArray.count perGroupCount:2];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShowOtherActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID_Cell forIndexPath:indexPath];
    
    ShowOtherActivityModel *leftModel = _listArray[2*indexPath.row];
    ShowOtherActivityModel *rightModel = nil;
    if (2*indexPath.row+1 < _listArray.count) {
        rightModel = _listArray[2*indexPath.row + 1];
    }
    
    WS(weakSelf);
    cell.block = ^ (ShowOtherActivityModel *model){
        UINavigationController *nav = weakSelf.navigationController;
        NSArray *vcArray = nav.viewControllers;
        for (NSInteger i = vcArray.count-1; i > 0; i--) {
            ActivityDetailViewController *pushedVC = vcArray[i];
            if ([pushedVC isKindOfClass:[ActivityDetailViewController class]]) {
                // 堆栈里已经存在一个activityId和要压栈的activityId相同的VC
                if ([pushedVC.activityId isEqualToString:model.activityId] && pushedVC.activityId.length) {
                    [nav popToViewController:vcArray[i-1] animated:NO];
                    break;
                }
            }
        }
        
        ActivityDetailViewController *vc = [ActivityDetailViewController new];
        vc.activityId = model.activityId;
        [nav pushViewController:vc animated:YES];
    };
    
    CGFloat topSpacing = indexPath.row == 0 ? 7 : 10;
    CGFloat bottomSpacing = 0;
    
    if (indexPath.row == [ToolClass  getGroupNum:_listArray.count perGroupCount:2]-1) {
        bottomSpacing = 50;
    }
    
    [cell setLeftModel:leftModel rightModel:rightModel topSpacing:topSpacing bottomSpacing:bottomSpacing];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat topSpacing = indexPath.row == 0 ? 7 : 10;
    CGFloat bottomSpacing = 0;
    
    if (indexPath.row == [ToolClass  getGroupNum:_listArray.count perGroupCount:2]-1) {
        bottomSpacing = 50;
    }
    
    return (kScreenWidth-15)*0.5*0.63+38+ topSpacing+bottomSpacing;
}


//无消息时的提示
- (void)noDataNotice:(NSString *)message
{
    WS(weakSelf);
    
    NoDataNoticeView *noticeView = [NoDataNoticeView noticeViewWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-HEIGHT_TOP_BAR-HEIGHT_HOME_INDICATOR) bgColor:[UIColor whiteColor] message:message promptStyle:NoDataPromptStyleClickRefreshForError callbackBlock:^(id object, NSInteger index, BOOL isSameIndex) {
        [weakSelf startRequestData:YES];
    }];
    [self.view addSubview:noticeView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
