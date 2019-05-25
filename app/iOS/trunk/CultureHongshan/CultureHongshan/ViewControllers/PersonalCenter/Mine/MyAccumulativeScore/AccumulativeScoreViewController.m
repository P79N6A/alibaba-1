//
//  AccumulativeScoreViewController.m
//  CultureHongshan
//
//  Created by ct on 16/5/27.
//  Copyright © 2016年 CT. All rights reserved.
//

#import "AccumulativeScoreViewController.h"

// View And Cell
#import "AccumulativeScoreCell.h"

// Model
#import "UserAccumulativeScoreModel.h"

// ViewController
#import "WebViewController.h"
#import "AccumulativeScoreListViewController.h"

// Other
#import "MJRefresh.h"
#import "AppProtocolMacros.h"

static NSString *reuseId_Cell = @"Cell";

@interface AccumulativeScoreViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UILabel *_scoreLabel;
    BOOL _didRequestData;//是否请求过数据
}

@property (nonatomic, strong) NSMutableArray *listArray;
@property (nonatomic, strong) UITableView *tableView;

@end


@implementation AccumulativeScoreViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    [self updateScore];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.listArray = [NSMutableArray new];
    self.navigationItem.title = @"我的积分";
    
    [self initTableView];
    [self initRefreshControl];
    
    [self startRequestAccumulativeScoreRecord:YES];
}

#pragma mark - 视图初始化

- (void)initTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.backgroundColor = kBgColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    [_tableView registerClass:[AccumulativeScoreCell class] forCellReuseIdentifier:reuseId_Cell];
    
    _tableView.tableFooterView = [MYMaskView maskViewWithBgColor:kBgColor frame:CGRectMake(0, 0, kScreenWidth, 40) radius:0];
    [self initTableHeaderView];
    
    [_tableView  mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

- (void)initTableHeaderView
{
    if (_tableView.tableHeaderView){
        _scoreLabel = nil;
        _tableView.tableHeaderView = nil;
    }
    
    MYMaskView *headerView = [MYMaskView maskViewWithBgColor:kBgColor frame:CGRectMake(0, 0, kScreenWidth, 135+3) radius:0];
    headerView.hidden = YES;
    
    //紫色的背景
    MYMaskView *scoreView = [MYMaskView maskViewWithBgColor:kThemeDeepColor frame:CGRectMake(0, 0, kScreenWidth, 80) radius:0];
    [headerView addSubview:scoreView];
    
    //积分标签
    _scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, 0, 0, scoreView.height)];
    _scoreLabel.textColor = [UIColor whiteColor];
    [scoreView addSubview:_scoreLabel];
    
    //积分规则
    CGFloat width = [UIToolClass textWidth:@"积分规则" font:FontYT(13)];
    UILabel *ruleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-18-width, 0, width, scoreView.height)];
    ruleLabel.textColor = [UIColor whiteColor];
    ruleLabel.font = FontYT(13);
    ruleLabel.text = @"积分规则";
    [scoreView addSubview:ruleLabel];
    
    UIImageView *ruleImg = [[UIImageView alloc] initWithFrame:CGRectMake(ruleLabel.originalX-5-18, 0, 18, 18)];
    ruleImg.image = IMG(@"icon_积分规则");
    [scoreView addSubview:ruleImg];
    ruleImg.centerY = ruleLabel.centerY;
    
    _scoreLabel.width = ruleImg.originalX-10-_scoreLabel.originalX;
    
    //最近30天 查看更多明细
    MYMaskView *recentView = [MYMaskView maskViewWithBgColor:[UIColor whiteColor] frame:CGRectMake(0, scoreView.maxY, kScreenWidth, 55) radius:0];
    [headerView addSubview:recentView];
    
    UILabel *recentLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, 0, 0, recentView.height)];
    recentLabel.textColor = [UIToolClass colorFromHex:@"262626"];
    recentLabel.font = FontYT(16);
    recentLabel.text = @"最近30天积分明细";
    [recentView addSubview:recentLabel];
    recentLabel.width = [UIToolClass textWidth:recentLabel.text font:recentLabel.font];
    
    UIImageView *moreImg = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-10-20, 0, 20, 20)];
    moreImg.image = IMG(@"icon_arrow_right_gray");
    [recentView addSubview:moreImg];
    moreImg.centerY = recentLabel.centerY;
    
    UILabel *moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(moreImg.originalX-5-100, 0, 100, recentView.height)];
    moreLabel.textColor = [UIToolClass colorFromHex:@"999999"];
    moreLabel.font = FontYT(13);
    moreLabel.text = @"更多明细";
    moreLabel.textAlignment = NSTextAlignmentRight;
    [recentView addSubview:moreLabel];
    
    //“积分规则”按钮
    UIButton *ruleButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth*0.5, 0, kScreenWidth*0.5, scoreView.height)];
    ruleButton.tag = 2;
    [ruleButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [scoreView addSubview:ruleButton];
    
    //“更多明细”按钮
    UIButton *moreButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth*0.5, 0, kScreenWidth*0.5, recentView.height)];
    moreButton.tag = 3;
    [moreButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [recentView addSubview:moreButton];
    
    _tableView.tableHeaderView = headerView;
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
    
    [AppProtocol getUserIntegralListWithType:1 pageIndex:pageIndex pageNum:kRefreshCount cacheMode:CACHE_MODE_REALTIME UsingBlock:^(HttpResponseCode responseCode, id responseObject)
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
             [weakSelf updateScore];
             _tableView.tableHeaderView.hidden = NO;
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



#pragma mark -  按钮的点击事件

//查看更多积分明细
- (void)buttonClick:(UIButton *)sender
{
    switch (sender.tag) {
        case 2://查看积分规则
        {
            WebViewController *vc = [WebViewController new];
            vc.navTitle = @"积分规则";
            vc.url = kAccumulativeScoreRuleUrl;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3://查看更多明细
        {
            [self.navigationController pushViewController:[AccumulativeScoreListViewController new] animated:YES];
        }
            break;
        default:
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - 其它方法

- (void)updateScore
{
    NSInteger score = [UserService sharedService].user.userIntegral;
    NSString *scoreStr = StrFromLong(score);
    NSString *tmpString = [NSString stringWithFormat:@"您有 %@ 积分", scoreStr];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:tmpString];
    [attributedString addAttribute:NSFontAttributeName value:FontYT(15) range:NSMakeRange(0, tmpString.length)];
    NSRange range = [tmpString rangeOfString:scoreStr];
    [attributedString addAttribute:NSFontAttributeName value:FontYT(40) range:range];
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowBlurRadius = 1.5;
    shadow.shadowOffset = CGSizeMake(0, 1.5);
    [attributedString addAttributes:@{NSShadowAttributeName:shadow} range:range];//, NSVerticalGlyphFormAttributeName:@(0)
    _scoreLabel.attributedText = attributedString;
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
