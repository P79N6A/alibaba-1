//
//  PageAccessTool.m
//  CultureHongshan
//
//  Created by JackAndney on 2017/7/7.
//  Copyright © 2017年 CT. All rights reserved.
//

#import "PageAccessTool.h"

#import "CitySwitchModel.h"

#import "WebViewController.h"
#import "ActivityDetailViewController.h"
#import "VenueDetailViewController.h"
#import "ActivityRoomDetailViewController.h"
#import "SearchDetailViewController.h"
#import "MyOrderViewController.h"
#import "ActivityOrderDetailViewController.h"
#import "VenueOrderDetailViewController.h"
#import "LoginViewController.h"
#import "CalendarViewController.h"
#import "AssociationViewController.h"
#import "CenterViewController.h"
#import "WaitPayViewController.h"

#import "MyNavigationController.h"

#import "PayService.h"
#import "WebPhotoBrowser.h"



@implementation PageAccessTool

// 页面跳转
+ (BOOL)accessAppPage:(AppPageType)pageType url:(NSString *)url navVC:(UINavigationController *)navVC sourceType:(NSInteger)sourceType extParams:(NSDictionary *)extParams {
    
    switch (pageType) {
        // 活动详情
        case AppPageTypeActivityDetail: {
            if (![navVC isKindOfClass:[UINavigationController class]]) return NO;
            
            ActivityDetailViewController *vc = [ActivityDetailViewController new];
            vc.activityId = url;
            [navVC pushViewController:vc animated:YES];
            return YES;
        }
            break;
        // 场馆详情
        case AppPageTypeVenueDetail: {
            if (![navVC isKindOfClass:[UINavigationController class]]) return NO;
            
            VenueDetailViewController *vc = [VenueDetailViewController new];
            vc.venueId = url;
            [navVC pushViewController:vc animated:YES];
            return YES;
        }
            break;
        // 活动室详情
        case AppPageTypeActivityRoomDetail: {
            if (![navVC isKindOfClass:[UINavigationController class]]) return NO;
            
            ActivityRoomDetailViewController *vc = [ActivityRoomDetailViewController new];
            vc.roomId = url;
            [navVC pushViewController:vc animated:YES];
            return YES;
        }
            break;
        // 活动列表
        case AppPageTypeActivityList: {
            if (![navVC isKindOfClass:[UINavigationController class]]) return NO;
            
            SearchDetailViewController *vc = [SearchDetailViewController new];
            vc.searchType = SearchTypeActivity;
            vc.parameterDict = @{ @"searchKey" : url, };
            [navVC pushViewController:vc animated:YES];
            
            return YES;
        }
            break;
        // 活动列表（带筛选条）
        case AppPageTypeActivityListWithFilter: {
            if (![navVC isKindOfClass:[UINavigationController class]]) return NO;
            
            NSArray *paraArray = [ToolClass getComponentArray:url separatedBy:@";"];
            if (paraArray.count > 1) {
                SearchDetailViewController *vc = [SearchDetailViewController new];
                vc.parameterDict = @{@"searchKey":paraArray[0], @"modelType":paraArray[1]};
                vc.activityTypeSearch = YES;
                vc.searchType = SearchTypeActivity;
                [navVC pushViewController:vc animated:YES];
                return YES;
            }else {
                return NO;
            }
        }
            break;
        // 场馆列表
        case AppPageTypeVenueList: {
            if (![navVC isKindOfClass:[UINavigationController class]]) return NO;
            
            SearchDetailViewController *vc = [SearchDetailViewController new];
            vc.searchType = SearchTypeVenue;
            vc.parameterDict = @{@"searchKey":url};
            [navVC pushViewController:vc animated:YES];
            return YES;
        }
            break;
        // 活动订单详情
        case AppPageTypeActicityOrderDetail: {
            if (![navVC isKindOfClass:[UINavigationController class]]) return NO;
            
            ActivityOrderDetailViewController *vc = [ActivityOrderDetailViewController new];
            vc.orderId = url;
            [navVC pushViewController:vc animated:YES];
            return YES;
        }
            break;
        // 活动室订单详情
        case AppPageTypeVenueOrderDetail: {
            if (![navVC isKindOfClass:[UINavigationController class]]) return NO;
            
            VenueOrderDetailViewController *vc = [VenueOrderDetailViewController new];
            vc.orderId = url;
            [navVC pushViewController:vc animated:YES];
            return YES;
        }
            break;
        // 文化日历页面
        case AppPageTypeCalendarList: {
            if (![navVC isKindOfClass:[UINavigationController class]]) return NO;
            
            [navVC pushViewController:[NSClassFromString(@"CalendarViewController") new] animated:YES];
            return YES;
        }
            break;
        // 文化广场（原"社团列表"）
        case AppPageTypeAssociationList:{
#ifndef FUNCTION_ENABLED_SQUARE
            return NO;
#endif
            
            if ([navVC isKindOfClass:[UINavigationController class]]) {
                if ([[navVC.viewControllers firstObject] isKindOfClass:[AssociationViewController class]]) {
                    [navVC popToRootViewControllerAnimated:YES];
                    return YES;
                }
            }
            
            UITabBarController *tabBar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            if ([tabBar isKindOfClass:[UITabBarController class] ]) {
                for (int i = 0; i < tabBar.viewControllers.count; i++) {
                    
                    UINavigationController *navController = tabBar.viewControllers[i];
                    
                    if (navController.viewControllers.count > 1) {
                        [navController popToRootViewControllerAnimated:i==3];
                    }
                }
                tabBar.selectedIndex = 3; // 选中第4个Item“广场”
                return YES;
            }
            return NO;
        }
            break;
            
        // 订单支付
        case AppPageTypeOrderPay: {
#ifndef FUNCTION_ENABLED_PAY_SERVICE
            return NO; // 不支持支付功能
#endif
            
            if (![navVC isKindOfClass:[UINavigationController class]]) return NO;
            
            WaitPayViewController *vc  = [WaitPayViewController new];
            vc.orderId = url;
            vc.dataType = DataTypeActivity;
            [navVC pushViewController:vc animated:YES];
            return YES;
        }
            break;
        // 退出WebView
        case AppPageTypeExitWebView: {
            if (![navVC isKindOfClass:[UINavigationController class]]) return NO;
            
            [navVC popViewControllerAnimated:YES];
            return YES;
        }
            break;
        // 登录页面
        case AppPageTypeLogin: {
            if (![navVC isKindOfClass:[UINavigationController class]]) return NO;
            
            LoginViewController *vc = [LoginViewController new];
            vc.redirectUrl = [url hasPrefix:@"http"] ? url : kLoginDefaultRedirectUrl;
            UIViewController *lastVC = [navVC.viewControllers lastObject];
            vc.screenshotImage = [UIToolClass getScreenShotImageWithSize:lastVC.view.viewSize views:@[lastVC.view] isBlurry:YES];
            MyNavigationController *nav = [[MyNavigationController alloc] initWithRootViewController:vc];
            [lastVC presentViewController:nav animated:YES completion:^{}];
            return YES;
        }
            break;
        // 访问TabBar的根页面
        case AppPageTypeTabBarRootVC: {
            NSInteger targetIndex = 0;
            if ([url isKindOfClass:[NSString  class]] && url.length) {
                targetIndex = MAX([url intValue], 0);
            }
            
            UITabBarController *tabBar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            if ([tabBar isKindOfClass:[UITabBarController class] ]) {
                
                if (targetIndex >= tabBar.viewControllers.count) {
                    targetIndex = tabBar.viewControllers.count-1;
                }
                NSInteger selectedIndex = tabBar.selectedIndex;
                
                if (selectedIndex == targetIndex) { // 当前页面和要跳转的根页面处于同一个导航控制器中,直接返回到根视图控制器
                    [navVC popToRootViewControllerAnimated:YES];
                }else {
                    tabBar.selectedIndex = targetIndex;
                    for (int i = 0; i < tabBar.viewControllers.count; i++) {
                        UINavigationController *navController = tabBar.viewControllers[i];
                        if (navController.viewControllers.count > 1) {
                            [navController popToRootViewControllerAnimated:NO];
                        }
                    }
                }
                return YES;
            }
            
            return NO;
        }
            break;
        // 个人中心
        case AppPageTypePersonalCenter: {
            UITabBarController * tabbar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            if (tabbar) {
                // 分设城市
                for (int i = 0; i < tabbar.viewControllers.count-1; i++) {
                    UINavigationController *navVC = tabbar.viewControllers[i];
                    if (navVC && [navVC isKindOfClass:[UINavigationController class]]) {
                        [navVC popToRootViewControllerAnimated:NO];
                    }
                }
                // 选中最后一个
                tabbar.selectedIndex = tabbar.viewControllers.count-1;
                UINavigationController *navVC = tabbar.viewControllers.lastObject;
                if (navVC && [navVC isKindOfClass:[UINavigationController class]]) {
                    [navVC popToRootViewControllerAnimated:YES];
                    return YES;
                }
            }
            return NO;
        }
            break;
        // 我的订单列表
        case AppPageTypeOrderList:{
            NSInteger orderListIndex = 0; // 订单列表索引：0-待审核  1-待参加  2-历史  3-待支付
            if ([url intValue] == 1) {
                orderListIndex = 2;
            }else if ([url intValue] == 2){
                orderListIndex = 3;
            }else if ([url intValue] == 3){
                orderListIndex = 1;
            }
            
            UITabBarController * tabbar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            
            NSInteger selectedIndex = tabbar.selectedIndex;
            if (selectedIndex < tabbar.viewControllers.count) {
                UINavigationController *navVC = tabbar.viewControllers[selectedIndex];
                if (navVC && [navVC isKindOfClass:[UINavigationController class]]) {
                    [navVC popToRootViewControllerAnimated:NO];
                }
            }
            
            tabbar.selectedIndex = tabbar.viewControllers.count-1;
            UINavigationController *navVC = tabbar.viewControllers.lastObject;
            if (navVC && [navVC isKindOfClass:[UINavigationController class]]) {
                MyOrderViewController * ordervc = nil;
                NSArray * ary = navVC.viewControllers;
                
                for (UIViewController * vc in ary) {
                    if ([vc isKindOfClass:[MyOrderViewController class]]) {
                        ordervc = (MyOrderViewController *)vc;
                        ordervc.selectedIndex = orderListIndex;
                        [ordervc reloadData];
                        break;
                    }
                }
                
                if (ordervc) {
                    [navVC popToViewController:ordervc animated:NO];
                } else {
                    if (navVC.viewControllers.count > 1) {
                        [navVC popToRootViewControllerAnimated:NO];
                    }
                    
                    MyOrderViewController * vc = [MyOrderViewController new];
                    vc.selectedIndex = orderListIndex;
                    [navVC pushViewController:vc animated:NO];
                    
                }
                return YES;
            }
            return NO;
        }
            break;
            
        default:
            break;
    }
    
    return NO;
}


// 检查是否可以访问某个页面
+ (BOOL)canAccessPage:(AppPageType)pageType url:(NSString *)url {
    switch (pageType) {
        case AppPageTypeActivityDetail: // 活动详情
        case AppPageTypeVenueDetail: // 场馆详情
        case AppPageTypeActivityRoomDetail: // 活动室详情
        case AppPageTypeActivityList: // 活动搜索列表
        case AppPageTypeActivityListWithFilter: // 活动列表（带筛选条）
        case AppPageTypeVenueList: // 场馆列表
        case AppPageTypeActicityOrderDetail: // 活动订单详情
        case AppPageTypeVenueOrderDetail: // 活动室订单详情
        {
            return url.length>0 ? YES : NO;
        }
            break;
            
        default:
            break;
    }
    
    // 订单支付
    if (pageType == AppPageTypeOrderPay) {
#ifdef FUNCTION_ENABLED_PAY_SERVICE
        return url.length>0 ? YES : NO;
#else
        return NO;
#endif
    }
    
    // 不在枚举值之内的
    if (pageType < AppPageTypeActivityDetail || (pageType > AppPageTypeTabBarRootVC && pageType!=AppPageTypeExitWebView && pageType!=AppPageTypeOrderPay )) {
        return NO;
    }
    
    return YES;
}


@end
