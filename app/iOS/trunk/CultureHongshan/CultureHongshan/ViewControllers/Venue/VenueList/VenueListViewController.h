//
//  VenueListViewController.h
//  CultureHongshan
//
//  Created by ct on 16/4/14.
//  Copyright © 2016年 CT. All rights reserved.
//



#import "CommonMultiTableViewController.h"
@class VenueModel;

/**
 *  @brief 文化空间
 *
 *  表视图的结构：分为2个区，frame保持不变
 *      0区，顶部的广告位； 1区，活动列表（含插入的广告）
 *      上下滑动时，通过更新tableView的contentInset，达到第一个单元格不被隐藏
 *      如果是UIWebView，则是通过改变frame（也采用改变contentInset的话，在webView中有顶部的固定条时，动画会不连贯）。
 *
 *  除了该页面中增加了Webview，其它的地方与“文化活动”完全一样
 */
@interface VenueListViewController : CommonMultiTableViewController

@property (nonatomic, strong) VenueModel *venueModel;

/**
 *  在当前页面中WebView内，进入登录界面，登录成功后需要刷新WebView
 *
 *  @param redirectUrl 刷新的地址：默认为刷新当前页，也有可能刷新的是H5传递的页面地址
 */
- (void)loadRedirectUrlAfterLogining:(NSString *)redirectUrl;

@end
