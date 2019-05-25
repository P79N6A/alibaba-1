//
//  WebSDKService.h
//  WHYProjectTemplate
//
//  Created by ct on 17/1/4.
//  Copyright © 2017年 Creatoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>


#pragma mark - H5 与 App 交互的协议


@protocol WebSDKJavaScriptProtocol <JSExport>

- (NSInteger)currentNetworkState; // 获取当前网络状态
- (BOOL)userIsLogin; // 判断用户是否已登录
- (NSString *)getUserInfo; // 获取用户信息
- (NSString *)getDeviceInfo; // 获取设备信息
- (NSString *)getUserGeoLocation; // 获取位置信息
- (void)sendUserInfoToApp:(NSString *)userInfo; // 发送用户信息给App
- (void)changeNavTitle:(NSString *)navTitle; // 改变导航栏标题
- (void)setAppShareButtonStatus:(BOOL)isShow; // 设置分享按钮的显示或隐藏
- (void)shareByApp:(NSString *)shareInfo; // H5调用App的分享功能
- (BOOL)appOrderPay:(NSString *)orderId; // 订单支付
- (void)accessDetailPageByApp:(NSString *)url; // 访问详情页面
- (void)enterNewWindow:(NSString *)url; // 进入一个新的页面
- (void)appPageJumpAfterBooking:(AppPageType)type; // 预订完后，要直接返回到详情页面（相当于退出浏览器）


/**
 *  H5访问App页面的接口
 *
 *  @param type 页面类型
 *  @param url  详情Id 或 搜索关键词
 */
JSExportAs(accessAppPage, - (BOOL)accessAppPage:(AppPageType)type url:(NSString *)url);

/**
 H5调用App的图片浏览器
 
 @param imgUrl  当前显示图片的链接
 @param imgUrls 图片链接拼接字符串（英文逗号或分号拼接）
 @return 布尔值：是否可以调用该接口
 */
JSExportAs(appPhotoBrowser, - (BOOL)appPhotoBrowser:(NSString *)imgUrl imgUrls:(NSString *)imgUrls);

@end






#pragma mark - WebSDKService



@interface WebSDKService : NSObject <WebSDKJavaScriptProtocol>

@property (nonatomic, weak) UIViewController *sourceVC;


#pragma mark -

/**
 获取当前网络状态

 @return 当前网络状态：0-无网络连接  1-Wifi网络  2-蜂窝移动网络
 */
+ (NSInteger)currentNetworkState;

/** 配置浏览器的UserAgent */
+ (void)registerWebViewUserAgent;


@end
