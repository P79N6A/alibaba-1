//
//  HomepageViewController.h
//  CultureHongshan
//
//  Created by ct on 16/7/26.
//  Copyright © 2016年 CT. All rights reserved.
//

#import "BasicViewController.h"


/**
 *  首页
 */
@interface HomepageViewController : BasicViewController

@property (nonatomic, strong) MYMaskView *navView;
@property (nonatomic,strong) UITableView *tableView;

/**
 *  所有广告位的跳转方法
 */
+ (void)goToAdvertPage:(AdvertModel *)model shareImage:(UIImage *)shareImage sourceVC:(UINavigationController *)navVC;

@end
