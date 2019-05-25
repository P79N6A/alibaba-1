//
//  CommonMultiTableViewController.m
//  CultureHongshan
//
//  Created by ct on 16/7/29.
//  Copyright © 2016年 CT. All rights reserved.
//

#import "CommonMultiTableViewController.h"

#import "MJRefresh.h"

#import "CommonMultiTableView.h"



@interface CommonMultiTableViewController ()
@end

@implementation CommonMultiTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _dataList = [[NSMutableArray alloc] initWithCapacity:0];
    
    self.bgTableView = [[CommonMultiTableView alloc] initWithFrame:CGRectZero delegate:self];
    _bgTableView.tableViewCount = 1;
    _bgTableView.backgroundColor = kBgColor;
    [self.view addSubview:_bgTableView];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RETURN_BLANK_CELL
}


+ (void)setupRefresh:(UITableView *)tableView withBlock:(RefreshBlock)block
{
    if (tableView.header || tableView.footer) {
        return;
    }
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (block){
            block(YES);
        }
    }];
    
    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"释放刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"文化生活加载中..." forState:MJRefreshStateRefreshing];
    header.stateLabel.font = FONT(14);
    header.lastUpdatedTimeLabel.font = FONT(12);
    header.stateLabel.textColor = kLightLabelColor;
    header.lastUpdatedTimeLabel.textColor = kLightLabelColor;
    //[header beginRefreshing];
    tableView.header = header;
    
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (block){
            block(NO);
        }
    }];
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    [footer setTitle:@"等待\n遇见更好生活..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"" forState:MJRefreshStateNoMoreData];
    footer.stateLabel.font = FONT(12);
    footer.stateLabel.textColor = kLightLabelColor;
    tableView.footer = footer;
}


- (void)updateTableStatusForNoData:(NSString *)notice withBlock:(IndexBlock)block
{
    [_bgTableView updateTableStatusForNoData:notice withBlock:block];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
