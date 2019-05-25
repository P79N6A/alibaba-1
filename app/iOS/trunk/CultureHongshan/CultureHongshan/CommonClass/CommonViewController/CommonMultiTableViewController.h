//
//  CommonMultiTableViewController.h
//  CultureHongshan
//
//  Created by ct on 16/7/29.
//  Copyright © 2016年 CT. All rights reserved.
//

#import "BasicViewController.h"

#import "CommonMultiTableView.h"

typedef void (^RefreshBlock)(BOOL isRefresh);


/**
 *  可以左右滑动的多表视图
 */
@interface CommonMultiTableViewController : BasicViewController<UITableViewDelegate, UITableViewDataSource, CommonMultiTableViewDelegate, UIWebViewDelegate>
{
    __block NSMutableArray *_dataList;
    BOOL _isRefresh;
}


@property (nonatomic, strong) CommonMultiTableView *bgTableView;

/**
 *  集成刷新控件
 */
+ (void)setupRefresh:(UITableView *)tableView withBlock:(RefreshBlock)block;

/**
 *  获取数据失败时的提示
 *
 *  @param notice 提示信息
 *  @param block  点击刷新后的回调
 */
- (void)updateTableStatusForNoData:(NSString *)notice withBlock:(IndexBlock)block;

@end
