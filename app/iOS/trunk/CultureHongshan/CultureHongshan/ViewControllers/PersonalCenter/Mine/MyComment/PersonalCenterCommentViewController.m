//
//  PersonalCenterCommentViewController.m
//  CultureHongshan
//
//  Created by ct on 16/4/12.
//  Copyright © 2016年 CT. All rights reserved.
//

#import "PersonalCenterCommentViewController.h"

// Models


//View And Cells
#import "CustomSegmentView.h"

#import "MyCommentCell.h"

// ViewControllers
#import "ActivityDetailViewController.h"
#import "VenueDetailViewController.h"


//Others
#import "MJRefresh.h"


//Test
#import "DetailTabBarView.h"


static NSString *reuseID_Cell = @"CommmentCell";



@interface PersonalCenterCommentViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    __block UITableView *_tableView;
    CustomSegmentView *_segmentView;
    
    
    CGFloat _lastOffset[2];//记录表的偏移量
    
    
    NSInteger _currentIndex;
    
    UIButton *_noDataButton;
    
    
}

@property (nonatomic, strong) NSMutableArray *listArray;
@property (nonatomic, copy) NSString *noDataStr;

@end


@implementation PersonalCenterCommentViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = 0;
    
    if (_isNeedRefresh)
    {
        [self startRequestCommentData:YES index:_currentIndex];
        _isNeedRefresh = NO;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.toolbarHidden = 1;
    self.navigationItem.title = @"我的评论";
    self.navigationController.navigationBarHidden = NO;
    
    _listArray = [NSMutableArray new];
    _listArray[0] = [NSMutableArray new];
    _listArray[1] = [NSMutableArray new];
    
    [self initSegmentView];
    [self initTabelView];
    [self initRefreshControl];
    
    [self startRequestCommentData:YES index:0];
}



#pragma mark - 初始化视图

//分段选择视图
- (void)initSegmentView
{
    __weak PersonalCenterCommentViewController *weakSelf = self;
    
    //分段选择视图
    _segmentView = [CustomSegmentView segmentViewWithFrame:CGRectMake(0, 0, kScreenWidth, 41)
                                               normalColor:ColorFromHex(@"494D5B")
                                             selectedColor:ColorFromHex(@"5e6d98")
                                                 lineColor:[UIColor blueColor]
                                               titleArrray:@[@"活动",@"场馆"]
                                             callBackBlock:^(id object, NSInteger index, BOOL isSameIndex)
                    {
                        _noDataButton.hidden = YES;
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
                            [weakSelf startRequestCommentData:YES index:index];
                        }
                        else
                        {
                            _currentIndex = index;
                            [_tableView reloadData];
                        }
                    }];
    [self.view addSubview:_segmentView];
}


//#pragma mark - 初始化表视图
- (void)initTabelView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _segmentView.height, kScreenWidth, kScreenHeight-HEIGHT_TOP_BAR-_segmentView.height) style:UITableViewStylePlain];
    _tableView.backgroundColor = kBgColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    [_tableView registerClass:[MyCommentCell class] forCellReuseIdentifier:reuseID_Cell];
    
    _noDataButton = [[UIButton alloc] initWithFrame:_tableView.frame];
    _noDataButton.hidden = YES;
    _noDataButton.titleLabel.numberOfLines = 0;
    [_noDataButton addTarget:self action:@selector(noDataButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_noDataButton];
    
    //标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, _noDataButton.height*0.3, kScreenWidth-60, 0)];
    titleLabel.font = FontSystem(20);
    titleLabel.tag = 10;
    titleLabel.numberOfLines = 0;
    titleLabel.textColor = [UIColor grayColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [_noDataButton addSubview:titleLabel];
    
    
    //标题
    UILabel *btnLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _noDataButton.height*0.3, 90, 40)];
    btnLabel.font = FontSystem(17);
    btnLabel.backgroundColor = RGBA(12,12,12,0.9);
    btnLabel.tag = 11;
    btnLabel.radius = 8;
    btnLabel.layer.masksToBounds = 1;
    btnLabel.textColor = [UIColor whiteColor];
    btnLabel.textAlignment = NSTextAlignmentCenter;
    [_noDataButton addSubview:btnLabel];
    btnLabel.centerX = _noDataButton.width*0.5;
}

//#pragma mark - 初始化刷新控件
- (void)initRefreshControl
{
    //头部的刷新控件
    __weak PersonalCenterCommentViewController *weakSelf = self;
    
    MJRefreshNormalHeader *headerRefresh = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf startRequestCommentData:YES index:_currentIndex];
    }];
    headerRefresh.lastUpdatedTimeLabel.hidden = NO;
    headerRefresh.stateLabel.font = FontYT(12);
    _tableView.header = headerRefresh;
    
    
    //尾部的刷新控件
    MJRefreshBackNormalFooter *footerRefresh = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf startRequestCommentData:NO index:_currentIndex];
    }];
    footerRefresh.stateLabel.font = FontYT(12);
    _tableView.footer = footerRefresh;
}

#pragma mark - 请求数据

- (void)startRequestCommentData:(BOOL)isClearData index:(NSInteger)index
{
    DataType type = (index == 0) ? DataTypeActivity : DataTypeVenue;// 1- 活动，  2- 场馆
    
    NSInteger pageIndex = 0;
    if ([_listArray[index] count] < 1)
    {
        isClearData = YES;
    }
    
    if (isClearData == NO) {
        pageIndex = [_listArray[index] count];
    }
    
    __weak PersonalCenterCommentViewController *weakSelf = self;
    
    EnumCacheMode cacheMode = isClearData ? CACHE_MODE_REALTIME : CACHE_VALID_TIME_SHORT;
    
    [AppProtocol getUserCommentListWithDataType:type pageIndex:pageIndex pageNum:kRefreshCount cacheMode:cacheMode UsingBlock:^(HttpResponseCode responseCode, id responseObject)
     {
         [_tableView.header endRefreshing];
         [_tableView.footer endRefreshing];
         [SVProgressHUD dismiss];
         if (responseCode == HttpResponseSuccess)
         {
             NSArray *resultArray = responseObject;
             
             if (isClearData)
             {
                 _listArray[index] = [NSMutableArray arrayWithArray:resultArray];
                 if (resultArray.count < 1 || resultArray == nil) {
                     weakSelf.noDataStr = @"您还没有评论过呢^_^";
                 }
             }else
             {
                 if (resultArray.count < 1)
                 {
                     [SVProgressHUD showInfoWithStatus:@"数据已经全部加载完了^_^"];
                     return;
                 }
                 _listArray[index] = [NSMutableArray arrayWithArray:[_listArray[index] arrayByAddingObjectsFromArray:resultArray]];
             }
             
             _currentIndex = index;
             [_tableView reloadData];
             
             
         }
         else//请求失败
         {
             if ([responseObject isKindOfClass:[NSString class]]) {
                 if ([_listArray[index] count]) {
                     [SVProgressHUD showErrorWithStatus:responseObject];
                 }
                 else
                 {
                     weakSelf.noDataStr = responseObject;
                 }
             }
            
         }
     }];
}


#pragma mark - 表视图的数据源方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [_listArray[_currentIndex] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID_Cell forIndexPath:indexPath];
    
    MyCommentModel *model = _listArray[_currentIndex][indexPath.row];
    
    CGFloat topSpacing = indexPath.row == 0 ? 4 : 0;
    [cell setModel:model forIndexPath:indexPath topSpacing:topSpacing];
    
    return cell;
}


#pragma mark - 表视图的代理方法

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat topSpacing = indexPath.row == 0 ? 4 : 0;
    return [self getCommentCellHeightWithModel:_listArray[_currentIndex][indexPath.row]] + topSpacing + 8;
}


- (CGFloat)getCommentCellHeightWithModel:(MyCommentModel *)model
{
    CGFloat cellHeight = 15+[UIToolClass fontHeight:FONT(17)];
    

    if (model.contentStr.length < 1 && model.imageUrlArray.count < 1)//无文本、无图片
    {
        cellHeight += 10 + [UIToolClass fontHeight:FontYT(15)] + 10 + [UIToolClass fontHeight:FONT(13)] + 20;
        return cellHeight;
    }
    
    CGFloat viewWidth = kScreenWidth-(10+10)*2;
    CGFloat contentHeight = [UIToolClass textHeight:model.contentStr lineSpacing:4 font:FONT(15) width:viewWidth];
    
    NSInteger rowNumber = (model.imageUrlArray.count%3 == 0) ? model.imageUrlArray.count/3 : model.imageUrlArray.count/3 + 1;
    CGFloat imageContainerHeight = rowNumber*(viewWidth-2*10)/3*0.667 + (rowNumber-1)*15;
    
    if (model.type == DataTypeActivity) {
        
        if (model.contentStr.length < 1 && model.imageUrlArray.count > 0){//只有图片
            cellHeight += 10 + [UIToolClass fontHeight:FONT(15)] + 15 + 8 + imageContainerHeight + 10 + 10+ [UIToolClass fontHeight:FONT(13)] + 20;
            return cellHeight;
        }
        else if (model.contentStr.length && model.imageUrlArray.count == 0){//只有文本
            cellHeight += 10 + [UIToolClass fontHeight:FONT(15)] + 15+8+contentHeight+10+10 + [UIToolClass fontHeight:FONT(13)] + 20;
            return cellHeight;
        }
        else{
            cellHeight += 10 + [UIToolClass fontHeight:FontYT(15)] + 15 + 8 + contentHeight + 10 + imageContainerHeight + 10+ 10+[UIToolClass fontHeight:FONT(13)] + 20;
            return cellHeight;
        }
    }else//场馆
    {
        if (model.contentStr.length < 1 && model.imageUrlArray.count > 0){//只有图片
            cellHeight += 15+8+ imageContainerHeight + 10 + 10+ [UIToolClass fontHeight:FONT(13)] + 20;
            return cellHeight;
        }
        else if (model.contentStr.length && model.imageUrlArray.count == 0){//只有文本
            cellHeight += 15+8+contentHeight+10+10 + [UIToolClass fontHeight:FONT(13)] + 20;
            return cellHeight;
        }
        else{
            cellHeight += 15 + 8 + contentHeight + 10 + imageContainerHeight + 10+ 10+[UIToolClass fontHeight:FONT(13)] + 20;
            return cellHeight;
        }
    }
}



#pragma mark - 单元格的点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyCommentModel *model = _listArray[_currentIndex][indexPath.row];
    
    if (model.type == DataTypeActivity)
    {
        ActivityDetailViewController *vc = [ActivityDetailViewController new];
        vc.activityId = model.modelId;
        [self.navigationController pushViewController:vc animated:YES];
    }else
    {
        VenueDetailViewController *vc = [VenueDetailViewController new];
        vc.venueId = model.modelId;
        [self.navigationController pushViewController:vc animated:YES];
    }
}




#pragma mark - Button Action Methods


- (void)noDataButtonClick
{
    _noDataButton.hidden = YES;
    [_tableView.header beginRefreshing];
    _tableView.userInteractionEnabled = 1;
}



- (void)setNoDataStr:(NSString *)noDataStr
{
    if (noDataStr == nil || ![noDataStr isKindOfClass:[NSString class]])
    {
        return;
    }
    if (noDataStr.length > 0)
    {
        UILabel *label = [_noDataButton viewWithTag:10];
        label.text = noDataStr;
        label.height = [UIToolClass textHeight:label.text font:FontSystem(20) width:label
                        .width];
        UILabel *btnLabel = [_noDataButton viewWithTag:11];
        btnLabel.text = @"点我刷新";
        btnLabel.originalY = label.maxY + 20;
        
        _noDataButton.hidden = NO;
        [self.view bringSubviewToFront:_noDataButton];
        _tableView.userInteractionEnabled = 0;
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    
    
    
}


@end
