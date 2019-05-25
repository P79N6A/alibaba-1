//
//  RegistrationViewController.m
//  CultureHongshan
//
//  Created by xiao on 15/12/8.
//  Copyright © 2015年 CT. All rights reserved.
//

#import "RegistrationViewController.h"

#import "MJRefresh.h"

#import "Registration.h"
#import "RegistrationTableViewCell.h"

#import "UIButton+WebCache.h"


static NSString *reuseID_Registration = @"RegistrationCell";


@interface RegistrationViewController ()<UITableViewDataSource, UITableViewDelegate>

//瀑布流
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *ListArray;

@property (nonatomic, strong) RegistrationTableViewCell *RegistrationCell;

@end

@implementation RegistrationViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kBgColor;

    [self createNav];
    
    //初始化瀑布流数据
    self.ListArray = [[NSMutableArray alloc]init];
    
    
    [self pulldownRefreshData];
    
    
    // Do any additional setup after loading the view.
}

- (void) createNav {
    self.navigationItem.title = @"查看用户";
}



-(void)pulldownRefreshData
{
    WS(weakSelf);
    [AppProtocol getUserWantgoListWithType:DataTypeActivity modelId:_activityId pageIndex:0 pageNum:kPageSize UsingBlock:^(HttpResponseCode responseCode, id responseObject)
     {
         if (responseCode == HttpResponseSuccess) {
             weakSelf.ListArray = (NSArray *)responseObject[1];
             if (weakSelf.ListArray.count == 0) {
                 [weakSelf createUI];
             }else {
                 [weakSelf loadViews];
                 [weakSelf.tableView reloadData];
             }
         }else {
             [SVProgressHUD showErrorWithStatus:(NSString *)responseObject];
         }
         [weakSelf.tableView.header endRefreshing];
 
    }];
}

- (void) createUI
{
    UILabel *label = [[UILabel alloc]init];
    label.text = @"-------暂无报名用户-------";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:17];
    label.textColor = COLOR_IBLACK;
    [self.view addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

-(void)pullupLoadMore
{
    WS(weakSelf);
    [AppProtocol getUserWantgoListWithType:DataTypeActivity modelId:_activityId pageIndex:_ListArray.count pageNum:kPageSize UsingBlock:^(HttpResponseCode responseCode, id responseObject)
     {
         if (responseCode == HttpResponseSuccess) {
             
             NSArray *array = (NSArray *)responseObject[1];
             if (array.count == 0) {
                 [SVProgressHUD showInfoWithStatus:@"没有更多数据了！"];
             }
             weakSelf.ListArray = [weakSelf.ListArray arrayByAddingObjectsFromArray:array];
             [weakSelf.tableView reloadData];
         }else
         {
             [SVProgressHUD showErrorWithStatus:(NSString *)responseObject];
         }
         [weakSelf.tableView.footer endRefreshing];
         
     }];
}


- (void)loadViews
{
    if (_tableView)
    {
        [_tableView reloadData];
        return;
    }
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = kBgColor;
    [self.view addSubview:self.tableView];
    
    [_tableView registerClass:[RegistrationTableViewCell class] forCellReuseIdentifier:reuseID_Registration];
    
    //上下拉刷新
    MJRefreshNormalHeader *HeaderRefresh = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pulldownRefreshData)];
    HeaderRefresh.lastUpdatedTimeLabel.hidden = YES;
    HeaderRefresh.stateLabel.font = FontYT(12);
    self.tableView.header = HeaderRefresh;
    
    MJRefreshBackNormalFooter *FooterRefresh = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(pullupLoadMore)];
    FooterRefresh.stateLabel.font = FontYT(12);
    self.tableView.footer = FooterRefresh;
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.ListArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    RegistrationTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:reuseID_Registration];
    
    Registration *selected = self.ListArray[indexPath.row];
    
    cell.nameLabel.text = [NSString stringWithFormat:@"%@",selected.userName];

    if (selected.userSex == 2)
    {
        cell.ageLabel.text = @"女";
    }
    else
    {
        cell.ageLabel.text = @"男";
    }
    //设置头像
    [cell.headerImage sd_setBackgroundImageWithURL:[NSURL URLWithString:JointedImageURL(selected.userHeadImgUrl, kImageSize_72_72)] forState:UIControlStateNormal placeholderImage:IMG(@"sh_user_header_icon") completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {
         if (error)
         {
             [cell.headerImage sd_setBackgroundImageWithURL:[NSURL URLWithString:selected.userHeadImgUrl] forState:UIControlStateNormal placeholderImage:IMG(@"sh_user_header_icon")];
         }
     }];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
