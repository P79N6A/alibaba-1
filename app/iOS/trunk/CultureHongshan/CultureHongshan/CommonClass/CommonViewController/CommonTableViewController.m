
//
//  CommonTableViewController.m
//  时尚五角场
//
//  Created by 李 兴 on 14-8-13.
//  Copyright (c) 2014年 李 兴. All rights reserved.
//

#import "CommonTableViewController.h"

#define TableViewCellIdentifier @"cellid"

@interface CommonTableViewController ()

@end

@implementation CommonTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self viewDidLayoutSubviews];
    _isRefresh = NO;
    _isDragAnimation = NO;
    navtapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleViewTap)];
    //self.navigationItem.titleView add
    _showStatus = YES;
    _pageNo = PAGE_START_INDEX;
    _haveNextPage = YES;
    _cellHeightCache = [NSMutableDictionary dictionaryWithCapacity:0];
    _dataList = [[NSMutableArray alloc] init];
    CGRect  frame = CGRectMake(0, 0, WIDTH_SCREEN, self.view.bounds.size.height-HEIGHT_TOP_BAR-HEIGHT_HOME_INDICATOR);
    _tableView = [[UITableView alloc] initWithFrame:frame];
    [self initTableView:_tableView];
    
    _noneDataTipsButton = [[UIButton alloc] init];
    _noneDataTipsButton.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    _noneDataTipsButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    _noneDataTipsButton.titleLabel.font = FONT_MIDDLE;
    [_noneDataTipsButton setTitle:@"内容还在采集，请等等再来。" forState:UIControlStateNormal];
    [_noneDataTipsButton addTarget:self action:@selector(noneDataTipsTap) forControlEvents:UIControlEventTouchUpInside];
    [_noneDataTipsButton setTitleColor:kDeepLabelColor forState:UIControlStateNormal];

    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:TableViewCellIdentifier];
    
    //滑动的时候隐藏navigationbar
    //self.navigationController.hidesBarsOnSwipe = YES;
    //ableView不显示没内容的Cell怎么办
    //_tableView.tableFooterView = [[UIView alloc] init];
    
}


-(void)initTableView:(UITableView *)tableview
{
    tableview.delegate = self;
    tableview.dataSource  = self;
    tableview.backgroundColor = COLOR_IGRAY;
    tableview.separatorInset = UIEdgeInsetsMake(0, -10, 0, 0);
    [self.view addSubview:tableview];
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self setupRefresh:tableview];
}

-(void)headerRereshing
{

    [self reloadTableData];
    _isDragAnimation = YES;
    __weak UITableView * w_tableView = _tableView;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [w_tableView.header endRefreshing];
        _isDragAnimation = NO;
    });
}

-(void)footerRefreshing
{
     _isDragAnimation = YES;
    if (_dataList.count == 0)
    {
        [_tableView.footer setState:MJRefreshStateIdle];
        return;
    }


    if (_haveNextPage)
    {
        _pageNo++;
        [self loadTableData];
    }
    else
    {
        [_tableView.footer setState:MJRefreshStateNoMoreData];
    }
    __weak UITableView * w_tableView = _tableView;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        [w_tableView.footer endRefreshing];
         _isDragAnimation = NO;
    });

}
/**
 *  集成刷新控件
 */
- (void)setupRefresh:(UITableView *)tableview
{

    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"释放刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"文化生活加载中..." forState:MJRefreshStateRefreshing];
    header.stateLabel.font = FONT(14);
    header.lastUpdatedTimeLabel.font = FONT(12);
    header.stateLabel.textColor = kLightLabelColor;
    header.lastUpdatedTimeLabel.textColor = kLightLabelColor;
    //[header beginRefreshing];
    tableview.header = header;


    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshing)];
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    [footer setTitle:@"等待\n遇见更好生活..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"" forState:MJRefreshStateNoMoreData];
    footer.stateLabel.font = FONT(12);
    footer.stateLabel.textColor = kLightLabelColor;
    tableview.footer = footer;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.navigationController)
    {
        self.navigationItem.titleView.userInteractionEnabled = NO;
        [self.navigationController.navigationBar addGestureRecognizer:navtapGesture];
    }
    
    if (_screenshotImages.count)
    {
        _tableView.hidden = YES;
        
        [ToolClass animationWithTopImage:_screenshotImages[0] bottomImage:_screenshotImages[1] headOffset:0 isTogether:YES completion:^(BOOL finished) {
            _tableView.hidden =  NO;
        }];
        
        _screenshotImages = nil;
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.navigationController)
    {
        self.navigationItem.titleView.userInteractionEnabled = YES;
        [self.navigationController.navigationBar removeGestureRecognizer:navtapGesture];
    }
}

-(void)setNoneDataTipsText:(NSString * )tipText
{
    [_noneDataTipsButton setTitle:tipText forState:UIControlStateNormal];
}


-(void)noneDataTipsTap
{
    [_noneDataTipsButton removeFromSuperview];
    [self reloadTableData];
}

-(void)titleViewTap
{
    if (_dataList && _dataList.count > 0)
    {
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

-(void)disablefreshTableCell
{

    _tableView.header = nil;
    _tableView.footer = nil;

}

-(void)setShowTableStaus:(Boolean)show;
{
    _showStatus = show;
}

-(Boolean)dataHavePage
{
    if ([self haveDataUrl])
    {

        if ([_tableDataUrl rangeOfString:@"pagesize="].location != NSNotFound)
        {
            return YES;
        }
    }
    return NO;
}

-(Boolean)haveDataUrl
{
    if (_tableDataUrl == nil || _tableDataUrl.length == 0)
    {
        return NO;
    }
    return YES;
}


-(void)removeCache
{
    [super removeCache];
    if (_tableDataUrl.length > 0)
    {
        [[CacheServices shareInstance]removeCache:_tableDataUrl];
    }

}

-(void)cleanPageInfo
{
    _haveNextPage = YES;
    _pageNo = PAGE_START_INDEX;
    [_dataList removeAllObjects];
}

-(void)reloadTableData
{

//    if ([self haveDataUrl] == NO)
//    {
//        return;
//    }
//    [self removeCache];
    [_noneDataTipsButton removeFromSuperview];
    _isRefresh = YES;
    [self cleanPageInfo];
    [self loadTableData];
    _isRefresh = NO;
}


-(void)loadTableData
{
}


-(void)checkHavePage:(NSDictionary *)results
{
    
    if([self dataHavePage])
    {
        if (results == nil || results.count == 0)
        {
            _haveNextPage = NO;
            return;
        }
        NSArray * ary = results[@"resultList"];
        if (ary == nil || ary.count == 0 || ary.count < kPageSize)
        {
            _haveNextPage = NO;
        }
        else
        {
            _haveNextPage = YES;
        }
        
    }
}


#pragma mark tableView delegate


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _cellHeight;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataList.count;
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if([self dataHavePage] && indexPath.row > 0)
//    {
//        if (indexPath.row == _dataList.count-1 && _haveNextPage)
//        {
//            _pageNo++;
//            [self loadTableData];
//        }
//    }
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}




-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell  * cell  = [_tableView dequeueReusableCellWithIdentifier:TableViewCellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableViewCellIdentifier];
        //cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    else
    {
        [ToolClass removeAllSubViews:cell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
    
}

-(void)viewDidLayoutSubviews
{
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    float offset = scrollView.contentOffset.y;
    float nowOffset = (_lastOffsetY - offset);
    //FBLOG(@"%f",nowOffset);
    if (((nowOffset >0 && _lastOffset > 0) || (nowOffset <0 && _lastOffset < 0)) && offset>0)
    {
        if (nowOffset < 0)
        {
            _direction = FBDIRECTION_UP;
        }
        else
        {
            _direction = FBDIRECTION_DOWN;
        }
    }
    //FBLOG(@"----%d",_direction);
    //FBLOG(@"    %f      %f      %f",nowOffset,_lastOffset,scrollView.contentOffset.y);
    _lastOffsetY = offset;
    _lastOffset = nowOffset;
}


-(void)updateTableViewStatus
{

    [_tableView reloadData];
    if (!_showStatus)
    {
        return;
    }

    if(_dataList == nil || _dataList.count == 0)
    {
        
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.35f * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^(void){
            
            [_tableView addSubview:_noneDataTipsButton];
            _noneDataTipsButton.frame = _tableView.bounds;
            
        });

       
        //[self.view insertSubview:_noneDataTipsButton aboveSubview:_tableView];
        //_noneDataTipsButton.frame = MRECT(0, 0, WIDTH_SCREEN, HEIGHT_SCREEN);
        //_tableView.hidden = YES;
    }
    else
    {
        [_noneDataTipsButton removeFromSuperview];
        if (_pageNo == PAGE_START_INDEX)
        {
            [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
    }
    
}



-(void)dealloc
{
    _dataList = nil;
    if (_tableView)
    {
        [_tableView removeFromSuperview];
        _tableView = nil;
    }
    if (_noneDataTipsButton)
    {
        [_noneDataTipsButton removeFromSuperview];
        _noneDataTipsButton = nil;
    }

    
}

-(Boolean)dataIsValid:(NSUInteger)idx
{
    if(_dataList == nil ||  _dataList.count == 0)
    {
        return NO;
    }
    if (_dataList.count > 0 && idx <= (_dataList.count - 1))
    {
        return YES;
    }
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
