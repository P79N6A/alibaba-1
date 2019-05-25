//
//  VenueRoomListViewController.m
//  CultureHongshan
//
//  Created by one on 15/11/15.
//  Copyright © 2015年 CT. All rights reserved.
//

#import "VenueRoomListViewController.h"
#import "UIImageView+AFNetworking.h"
#import "MJRefresh.h"

#import "ActivityRoomModel.h" //相关活动室domel
#import "ActivityRoomDetailViewController.h"

#import "AnimationBackView.h"



static NSString *reuseID_Cell = @"ActivityRoomCell";

@interface VenueRoomListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *roomTableView;
    
    CGFloat roomCellHeight;//cell高度
    
    CGFloat roomTypeWidth;
    CGFloat roomTypeHeight;
    UILabel *roomTypeLabel;
    
    AnimationBackView *_animationView;
    
    NSMutableArray *_roomVenueArray;
}

//@property (nonatomic, strong) NSMutableArray *roomVenueArray;

@end




@implementation VenueRoomListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"相关活动室";
    
    _roomVenueArray = [[NSMutableArray alloc] init];
    
    
    [self loadUITableView];
    
    _animationView = [[AnimationBackView alloc] initAnimationWithFrame:CGRectMake(0, 0, 100, 80)];
    [_animationView beginAnimationView];
    [self.view addSubview:_animationView];
    _animationView.center = CGPointMake(self.view.center.x, kScreenHeight/2-40);
    [self loadRoomVenueDataWithClearData:YES];
}

-(void)loadUITableView
{
    roomTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-HEIGHT_TOP_BAR)];
    roomTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    roomTableView.hidden = YES;
    roomTableView.delegate = self;
    roomTableView.dataSource = self;
    [self.view addSubview:roomTableView];
    [roomTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:reuseID_Cell];
    
    WS(weakSelf);
    roomTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [_animationView beginAnimationView];
        [weakSelf loadRoomVenueDataWithClearData:YES];
    }];
    
    roomTableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [_animationView beginAnimationView];
        [weakSelf loadRoomVenueDataWithClearData:NO];
    }];
    
}

//加载相关活动室的数据
-(void)loadRoomVenueDataWithClearData:(BOOL)isClearData
{
//    [SVProgressHUD showWithStatus:@"正在加载中..."];
//    [SVProgressHUD showLoading];
    
    NSInteger pageIndex = isClearData ? 0 : _roomVenueArray.count;
    
    [AppProtocol getPlayroomListWithVenueId:self.venueId pageIndex:pageIndex pageNum:kRefreshCount cacheMode:CACHE_MODE_REALTIME UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        
        if (responseCode == HttpResponseSuccess) {
            _animationView.isLoadAnimation = YES;
            roomTableView.hidden = NO;
            
            if ([responseObject count]) {
                NSArray * ary = (NSMutableArray *)responseObject;
                if (ary && ary.count > 1) {
                    if (isClearData) {
                        [_roomVenueArray removeAllObjects];
                    }
                    
                    [_roomVenueArray addObjectsFromArray:ary[1]];
                    [roomTableView reloadData];
                }
                
            }
        }else {
            [_animationView shutTimer];
            NSString *str = (NSString *)responseObject;
            if (_roomVenueArray.count > 0) {
                [SVProgressHUD showErrorWithStatus:str];
            }else {
                [_animationView setAnimationLabelTextString: str];
            }
            
        }
        
        [roomTableView.header endRefreshing];
        [roomTableView.footer endRefreshing];
    }];
}



#pragma -mark UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_roomVenueArray.count == 0) {
        return 0;
    }
    return _roomVenueArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_roomVenueArray.count == 0) {
        return 0;
    }
    if (indexPath.row == _roomVenueArray.count-1) {
        return 9+WIDTH_SCREEN*0.24+10;
    }else{
        return 9+WIDTH_SCREEN*0.24;
    }
}

#pragma mark - 计算活动室单元格的高度
- (CGFloat)roomCellHeightWithModel:(ActivityRoomModel *)model
{
    return 9+WIDTH_SCREEN*0.24;
}


#pragma -mark UITableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __block UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID_Cell forIndexPath:indexPath];
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
 
    int imgWidth =  WIDTH_SCREEN*0.30;
    int imgHeight = WIDTH_SCREEN*0.24;
    WS(weakSelf);

    ActivityRoomModel * roomModel = _roomVenueArray[indexPath.row];
    FBButton *containerView = [[FBButton alloc] initWithImage:CGRectZero bgcolor:COLOR_IWHITE img:nil clickEvent:^(FBButton *owner) {
        
        ActivityRoomDetailViewController *vc = [[ActivityRoomDetailViewController alloc] init];
        vc.roomId = roomModel.roomId;
        vc.roomName = roomModel.roomName;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    containerView.layer.borderColor = ColorFromHex(@"DFDFDF").CGColor;
    containerView.layer.borderWidth = kLineThick;
    [cell.contentView addSubview:containerView];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@WIDTH_LEFT_SPAN);
        make.right.mas_equalTo(cell.contentView.mas_right).offset(-WIDTH_LEFT_SPAN);
        make.height.equalTo(@(imgHeight));
        make.top.equalTo(@9);
    }];
    
    UIImageView  * imgView = [[UIImageView alloc] initWithFrame:MRECT(0, 0, imgWidth, imgHeight)];
    [containerView addSubview:imgView];
    UIImage *placeImg = [UIToolClass getPlaceholderWithViewSize:imgView.viewSize centerSize:CGSizeMake(20, 20) isBorder:NO];
    [imgView sd_setImageWithURL:[NSURL URLWithString:JointedImageURL(roomModel.roomPicUrl, kImageSize_150_100)] placeholderImage:placeImg];
    
    //预订按钮
    FBButton * bookButton = nil;
    if (roomModel.roomIsReserve > 0 )
    {//可以预订
        bookButton = [[FBButton alloc] initWithText:CGRectZero font:FONT_BIG fcolor:COLOR_IWHITE bgcolor:kThemeDeepColor text:@"预订" clickEvent:^(FBButton *owner) {
        }];
        bookButton.userInteractionEnabled = NO;
        [containerView addSubview:bookButton];
        [bookButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@0);
            make.top.equalTo(@0);
            make.bottom.equalTo(@0);
            make.width.equalTo(@55);
        }];
    }
    
    CGFloat fontHeight = 0;
    
    //标题
    fontHeight = [UIToolClass fontHeight:FontYT(16)];
    FBLabel * actNameLabel = [[FBLabel alloc] initWithStyle:CGRectZero font:FontYT(16) fcolor:kDeepLabelColor text:roomModel.roomName];
    [containerView addSubview:actNameLabel];
    [actNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(imgView.mas_right).offset(10);
        make.top.equalTo(imgView.mas_top).offset(6);
        make.height.equalTo(@(fontHeight));
        
        if (bookButton){
            make.right.equalTo(bookButton.mas_left).offset(-5);
        }else{
            make.right.equalTo(@(-10));
        }
    }];
    
    
    //面积和客容量
    fontHeight = [UIToolClass fontHeight:FontYT(14)];
    FBLabel * actLabelLabel = [[FBLabel alloc] initWithStyle:CGRectZero font:FontYT(14) fcolor:kLightLabelColor text:[NSString stringWithFormat:@"面积%@平米，容纳%@人",roomModel.roomArea,roomModel.roomCapacity]];
    [containerView addSubview:actLabelLabel];
    actLabelLabel.numberOfLines = 1;
    [actLabelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.equalTo(@(fontHeight));
        make.left.mas_equalTo(imgView.mas_right).offset(10);
        make.top.equalTo(actNameLabel.mas_bottom).offset(7);
        make.right.equalTo(actNameLabel.mas_right).offset(0);
    }];
    
    //价格
    FBLabel *  priceLabel = [[FBLabel alloc] initWithStyle:CGRectZero font:FONT_MIDDLE fcolor:kDeepLabelColor text:(roomModel.roomIsFree == 1) ? @"免费":@"收费"];
    [containerView addSubview:priceLabel];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(fontHeight));
        make.left.mas_equalTo(imgView.mas_right).offset(10);
        make.top.equalTo(actLabelLabel.mas_bottom).offset(13);
        make.right.equalTo(actNameLabel.mas_right).offset(0);
    }];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ActivityRoomModel *_roomModel = _roomVenueArray[indexPath.row];
    ActivityRoomDetailViewController *roomVenDetailVC = [[ActivityRoomDetailViewController alloc] init];
    roomVenDetailVC.roomId = _roomModel.roomId;
    roomVenDetailVC.roomName = _roomModel.roomName;
    [self.navigationController pushViewController:roomVenDetailVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
