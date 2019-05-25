//
//  ShareService.h
//  CultureHongshan
//
//  Created by ct on 16/10/19.
//  Copyright © 2016年 CT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ShareSDK/SSDKTypeDefine.h>


/**
 分享工具类
 
 @discussion 如果只分享图片时，传sharedImage字段（不要传imageUrl）。
 
 */
@interface ShareService : NSObject

/** 配置分享 */
+ (void)configureWithOptions:(NSDictionary *)launchOptions;

/** 是否安装微信 */
+ (BOOL)isWeiXinInstalled;
/** 是否安装QQ */
+ (BOOL)isQQInstalled;
/** 是否安装新浪微博 */
+ (BOOL)isSinaWeiboInstalled;



/**
 统一的分享调用方法
 
 @param platformType 分享的平台
 @param title        分享的标题
 @param content      分享的内容
 @param sharedImage  分享的图片
 @param imageUrl     分享的图片Url
 @param shareUrl     分享的地址链接
 @param addIntegral  是否增加用户的积分
 @param block        分享回调
 */
+ (void)shareWithPlatformType:(SSDKPlatformType)platformType
                        title:(NSString *)title
                      content:(NSString *)content
                  sharedImage:(UIImage *)sharedImage
                     imageUrl:(NSString *)imageUrl
                     shareUrl:(NSString *)shareUrl
                  addIntegral:(BOOL)addIntegral
               onStateChanged:(void(^)(SSDKResponseState state))block;



@end
