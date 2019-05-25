//
//  MyOrderViewController.m
//  CultureHongshan
//
//  Created by JackAndney on 16/5/12.
//  Copyright © 2016年 CT. All rights reserved.
//

#import "MyOrderViewController.h"

#import "AppProtocolMacros.h"

#import "OrderListCell.h"
#import "MyOrderModel.h"

#import "ActivityOrderDetailViewController.h"
#import "VenueOrderDetailViewController.h"
#import "WebViewController.h"
#import "WaitPayViewController.h"

#define REUSER_ORDERCELL    @"reuser_ordercell"

@interface MyOrderViewController ()
{
    NSInteger _currentOrderIndex;

    UIView * _indicatorView;
    UIView *_segmentView;
}

@end




@implementation MyOrderViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的订单";
    self.view.backgroundColor = COLOR_IGRAY;
    _joinArray = [NSMutableArray new];
    [_tableView registerClass:[OrderListCell class] forCellReuseIdentifier:@"reuser_ordercell"];

    _currentOrderIndex = _selectedIndex + 1;
    [self initSegment];
    
    WS(weakSelf)
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.bottom.equalTo(weakSelf.view);
        make.top.equalTo(_segmentView.mas_bottom);
    }];
    
    [_noneDataTipsButton setTitle:@"你还没参加过任何活动，点击查看更多精彩活动！" forState:UIControlStateNormal];
    
//    [self getJoinAmount];
    _isRefresh = YES;
    [self loadTableData];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    _currentOrderIndex = selectedIndex + 1;
    [self moveIndicatorViewToIndex:selectedIndex + 1];
}

-(void)getJoinAmount
{
    WS(weakSelf);
    [AppProtocol getUserOrderListWithType:3
                                pageIndex:0
                                  pageNum:100
                                cacheMode:CACHE_MODE_REALTIME
                               UsingBlock:^(HttpResponseCode responseCode, id responseObject)
     {
         if (responseCode == HttpResponseSuccess)
         {
             NSInteger joinAmount = [responseObject[0] integerValue];
             [weakSelf updateNumberOfWaitJoin:joinAmount];
         }
     }];
}

-(void)noneDataTipsTap
{
    self.tabBarController.selectedIndex = 0;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    
//    if (_currentOrderIndex-1 != _selectedIndex && _selectedIndex  > -1 && _selectedIndex < 4) {
//        
//        _currentOrderIndex = _selectedIndex + 1;
//        _isRefresh = YES;
//        [self loadTableData];
//    }
}

-(void)initSegment
{
    _segmentView = [MYMaskView maskViewWithBgColor:kBgColor frame:CGRectZero radius:0];
    [self.view addSubview:_segmentView];
    
    _indicatorView = [MYMaskView maskViewWithBgColor:kThemeDeepColor frame:CGRectZero radius:0];
    [_segmentView addSubview:_indicatorView];
    
    NSArray *imageNames = @[@"icon_waitcheck", @"icon_waitpay", @"icon_waitjoin", @"icon_history"];
    NSArray *titleArray = @[@"待审核", @"待支付", @"待参加", @"历史"];
    
    WS(weakSelf)
    UIView *preView = nil;
    for (int i = 0; i < imageNames.count; i++) {
        UIImage *normalImage = IMG(imageNames[i]);
        UIImage *selectedImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_on", imageNames[i]]];
        
        
        MYSmartButton *button = [MYSmartButton al_buttonWithContentLayout:ButtonContentLayoutImageUp font:FontYT(14) title:titleArray[i] tColor:kDeepLabelColor image:normalImage borderWidth:0 borderColor:nil radius:0 actionBlock:^(MYSmartButton *sender) {
            if (sender.selected) {
                return;
            }
            _currentOrderIndex = sender.tag;
            _selectedIndex = _currentOrderIndex-1;
            [weakSelf reloadTableData];
            [weakSelf moveIndicatorViewToIndex:sender.tag];
        }];
        button.backgroundColor = kWhiteColor;
        button.animationWhenClicked = YES;
        button.tag = 1 + i;
        [button setTitleColor:kThemeDeepColor forState:UIControlStateSelected];
        [button setImage:selectedImage forState:UIControlStateSelected];
        [_segmentView addSubview:button];
        
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            if (preView) {
                make.left.equalTo(preView.mas_right).offset(0);
                make.width.height.and.centerY.equalTo(preView);
            }else {
                make.left.equalTo(_segmentView);
                make.top.equalTo(_segmentView);
                make.bottom.equalTo(_segmentView).offset(-2);
            }
        }];
        
        if (i + 1 == _currentOrderIndex) {
            button.selected = YES;
            [_indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(button);
                make.width.equalTo(button.mas_width).multipliedBy(0.632);
                make.bottom.equalTo(_segmentView).offset(-3);
                make.height.mas_equalTo(1);
            }];
        }
        
        if (preView) {
            MYMaskView *line = [MYMaskView maskViewWithImage:IMG(@"line－nav") frame:CGRectZero radius:0];
            [_segmentView addSubview:line];
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(preView.mas_right);
                make.width.mas_equalTo(2);
                make.height.equalTo(preView).multipliedBy(5.0/6);
                make.centerY.equalTo(preView);
            }];
        }
        
        preView = button;
    }
    [preView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_segmentView);
    }];
    
    [_segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.view);
        make.height.mas_equalTo(62);
    }];
    
    [_segmentView bringSubviewToFront:_indicatorView];
}

/** index从1开始 */
- (void)moveIndicatorViewToIndex:(NSInteger)index {
    
    for (UIButton *sender in _segmentView.subviews) {
        if ([sender isKindOfClass:[UIButton class]]) {
            if (sender.tag == index) {
                sender.selected = YES;
                
                [_indicatorView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(sender);
                    make.width.equalTo(sender.mas_width).multipliedBy(0.632);
                    make.bottom.equalTo(_segmentView).offset(-3);
                    make.height.mas_equalTo(1);
                }];
                
                [UIView animateWithDuration:0.3f animations:^{
                    [_segmentView setNeedsLayout];
                    [_segmentView layoutIfNeeded];
                }];
            }else {
                sender.selected = NO;
            }
        }
    }
}


#pragma mark - 请求数据

- (void)loadTableData
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showLoading];

    WS(weakSelf);
    BOOL isRefresh = _isRefresh;
    NSInteger currentIndex = _currentOrderIndex;
    // type说明： 1- 待审核  2-待支付  3- 待参加  4-历史
    
    if (_currentOrderIndex == 1) {
        NSString *userId = [UserService sharedService].userId;
        
        if (userId.length){
            
            [AppProtocol queryUserInfoWithUserId:[NSString stringWithFormat:@"|%@",userId] UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
                if (responseCode == HttpResponseSuccess) {
                    
                    [UserService saveUser:responseObject];
                    [weakSelf loadListData:isRefresh type:currentIndex];
                }else{
                    [weakSelf loadListData:isRefresh type:currentIndex];
                }
            }];
        }
    }else {
        [self loadListData:isRefresh type:currentIndex];
    }
}

- (void)reloadData {
    [_noneDataTipsButton removeFromSuperview];
    
    _isRefresh = YES;
    [self cleanPageInfo];
    [self loadTableData];
    
    _isRefresh = NO;
}

- (void)loadListData:(BOOL)isRefresh type:(NSInteger)type
{
    WS(weakSelf);
    // type说明： 1- 待审核  2-待支付  3- 待参加  4-历史
    [AppProtocol getUserOrderListWithType:type
                                pageIndex:_pageNo * kPageSize
                                  pageNum:kPageSize
                                cacheMode:CACHE_MODE_REALTIME
                               UsingBlock:^(HttpResponseCode responseCode, id responseObject)
     {
         [SVProgressHUD dismiss];
         if (responseCode == HttpResponseSuccess)
         {
//             NSInteger joinAmount = [responseObject[0] integerValue];
//             [weakSelf updateNumberOfWaitJoin:joinAmount];
             
             NSArray * ary = responseObject[1];
             if ([ary count] == 0)
             {
                 if (_dataList.count > 0)
                 {
                     [SVProgressHUD showInfoWithStatus:@"没有更多订单啦!"];
                 }
                 _haveNextPage = NO;
             }
             else
             {
                 [_dataList addObjectsFromArray:ary];
             }
         }
         else
         {
             [SVProgressHUD showInfoWithStatus:(NSString *)responseObject];
         }
         [weakSelf updateTableViewStatus];
     }];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < _dataList.count-1) {
        return 228;
    }else {
        return 230;
    }
}


-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderListCell  * cell = [tableView dequeueReusableCellWithIdentifier:REUSER_ORDERCELL forIndexPath:indexPath];
    if([self dataIsValid:indexPath.row])
    {
        MyOrderModel * model =  _dataList[indexPath.row];
        [cell setModel:model  listType:_currentOrderIndex];
        
        WS(weakSelf)
        cell.actionHandler = ^(MyOrderModel *orderModel, NSInteger operationType){
            
            if (operationType == 1) {
                if (model.type == DataTypeVenue)
                {
                    User *user = [UserService sharedService].user;
                    if (orderModel.certifyStatus > -1 && orderModel.certifyStatus < 3) {
                        //需进行实名认证
                        
                        WebViewController *vc = [WebViewController new];
                        vc.navTitle = @"实名认证";
                        vc.url = [NSString stringWithFormat:@"%@&userId=%@&roomOrderId=%@&tuserName=%@&tuserId=%@&userType=%@&tuserIsDisplay=%@", kRealNameAuthUrl, user.userId, orderModel.orderId,orderModel.tuserTeamName,orderModel.tUserId,StrFromInt(user.userType),StrFromInt(orderModel.tuserIsDisplay)];
                        [self.navigationController pushViewController:vc animated:YES];
                    }else if (orderModel.certifyStatus > 2 && orderModel.certifyStatus < 6) {
                        
                        WebViewController *vc = [WebViewController new];
                        vc.navTitle = @"资质认证";
                        vc.url = [NSString stringWithFormat:@"%@&userId=%@&roomOrderId=%@&tuserName=%@&tuserId=%@&userType=%@&tuserIsDisplay=%@", kQualificationAuthUrl, user.userId, orderModel.orderId,orderModel.tuserTeamName,orderModel.tUserId,StrFromInt(user.userType),StrFromInt(orderModel.tuserIsDisplay)];
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                }
            }else if (operationType == 2) {
                WaitPayViewController *vc = [WaitPayViewController new];
                vc.orderId = model.orderId;
                vc.dataType = DataTypeActivity;
                vc.completionHandler = ^(BOOL success, NSString *orderId) {
                    if (success) {
                        model.orderPayStatus = 0;
                        model.orderStatus = 1;
                        [_tableView reloadData];
                    }
                };
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
        };
    }
    return cell;
}


#pragma mark - 单元格点击事件

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MyOrderModel *model = _dataList[indexPath.row];
    if (model.type == 1){
        ActivityOrderDetailViewController * vc = [ActivityOrderDetailViewController new];
        vc.orderId = model.orderId;
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        VenueOrderDetailViewController * vc = [VenueOrderDetailViewController new];
        vc.orderId = model.orderId;
        [self.navigationController pushViewController:vc animated:YES];
    }
}



- (void)updateNumberOfWaitJoin:(NSInteger)joinAmount
{
    UIButton *joinButton;
    
    UILabel * label = (UILabel *)[joinButton viewWithTag:9999];
    if (joinAmount > 0)
    {
        if (joinButton)
        {
            label.hidden = NO;
            if (joinAmount > 99){
                label.text = @"99+";
            }else{
                label.text = StrFromLong(joinAmount);
            }
            CGFloat width = [UIToolClass textWidth:label.text font:label.font]+8;
            if (width < 20) {
                width = 20;
            }
            label.width = width;
        }
    }
    else
    {
        label.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
