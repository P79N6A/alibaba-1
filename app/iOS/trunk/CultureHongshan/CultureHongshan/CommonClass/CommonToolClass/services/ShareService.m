//
//  ShareService.m
//  CultureHongshan
//
//  Created by ct on 16/10/19.
//  Copyright © 2016年 CT. All rights reserved.
//

#import "ShareService.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import "WeiboSDK.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"




@implementation ShareService

+ (void)configureWithOptions:(NSDictionary *)launchOptions
{
    [ShareSDK registerApp:kAppID_ShareSDK
          activePlatforms:@[@(SSDKPlatformTypeSinaWeibo), @(SSDKPlatformTypeWechat),@(SSDKPlatformTypeQQ)]
                 onImport:^(SSDKPlatformType platformType)
    {
        switch (platformType) {

#ifdef FUNCTION_ENABLED_WECHAT
            case SSDKPlatformTypeWechat:
                [ShareSDKConnector connectWeChat:[WXApi class]];
                break;
#endif

#ifdef FUNCTION_ENABLED_QQ
            case SSDKPlatformTypeQQ:
                [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                break;
#endif
                
#ifdef FUNCTION_ENABLED_WEIBO
            case SSDKPlatformTypeSinaWeibo:
                [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                break;
#endif

            default:
                break;
        }
    }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         switch (platformType) {
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupSinaWeiboByAppKey:kAppKey_Sina
                                           appSecret:kAppSecret_Sina
                                         redirectUri:kWeiboRedirectUri
                                            authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:kAppID_Wechat
                                       appSecret:kAppSecret_Wechat];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:kAppID_QQ
                                      appKey:kAppKey_QQ
                                    authType:SSDKAuthTypeBoth];
                 break;
                 
             default:
                 break;
         }
     }];
}

+ (BOOL)isWeiXinInstalled {
    return [ShareSDK isClientInstalled:SSDKPlatformTypeWechat];
}

+ (BOOL)isQQInstalled {
    return [QQApiInterface isQQInstalled];
}

+ (BOOL)isSinaWeiboInstalled {
    return [ShareSDK isClientInstalled:SSDKPlatformTypeSinaWeibo];
}



#pragma mark -

+ (void)shareWithPlatformType:(SSDKPlatformType)platformType
                        title:(NSString *)title
                      content:(NSString *)content
                  sharedImage:(UIImage *)sharedImage
                     imageUrl:(NSString *)imageUrl
                     shareUrl:(NSString *)shareUrl
                  addIntegral:(BOOL)addIntegral
               onStateChanged:(void(^)(SSDKResponseState state))block
{
    if (title.length < 1) { title = nil; }
    if (content.length < 1) { content = nil; }
    if (imageUrl.length < 1) { imageUrl = nil; }
    if (shareUrl.length < 1) { shareUrl = nil; }
    
    // 图片链接失效时，用默认的Logo代替
    if (title.length && shareUrl.length && !sharedImage) {
        sharedImage = IMG(@"AppIcon60x60@3x");
    }
    
    NSString *sharedTitle= nil;
    NSString *sharedContent = nil;
    id compressedImage = nil;
    
    //只分享图片：分享订票的截图，查看大图时的分享图片
    if (shareUrl == nil && content.length < 1 && sharedImage.size.height > 1)
    {
        compressedImage =  [sharedImage limitToMaxPixel:1080];
    }else {
        if (platformType == SSDKPlatformTypeSinaWeibo) { // 微博图片可以稍微大一些
            compressedImage = [sharedImage scaleToWidth:700 canBeLarger:NO imgScale:1];
        }else {
            compressedImage = [sharedImage clipToSize:CGSizeMake(120,120) imgScale:1];
        }
    }
    
    if (compressedImage == nil) {//分享的图片不存在时，用图片的链接
        if (imageUrl.length) {
            compressedImage = [NSURL URLWithString:imageUrl];
        }
    }
    
    if (platformType == SSDKPlatformSubTypeWechatSession)//微信好友
    {
        sharedTitle = title;
        sharedContent = content;
    }
    else if (platformType == SSDKPlatformSubTypeWechatTimeline)//微信朋友圈
    {
        sharedTitle = title;
        sharedContent = content;
    }
    else if (platformType == SSDKPlatformSubTypeQQFriend)//QQ好友
    {
        sharedTitle = title;
        sharedContent = content;
    }
    else if (platformType == SSDKPlatformTypeSinaWeibo)//新浪微博(不分享图片)
    {
        sharedContent = [NSString stringWithFormat:@"%@%@",title,shareUrl];
        sharedTitle = nil;
    }
    
    
    // 创建分享参数
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    if ([self isSinaWeiboInstalled]) {
        [shareParams SSDKEnableUseClientShare];
    }
    
    [shareParams SSDKSetupShareParamsByText:sharedContent
                                     images:compressedImage
                                        url:shareUrl.length ? [NSURL URLWithString:shareUrl] : nil
                                      title:sharedTitle
                                       type:SSDKContentTypeAuto];
    
    
    
    // 进行分享
    [ShareSDK share:platformType
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
         
         switch (state) {
             case SSDKResponseStateSuccess:
             {
                 [SVProgressHUD showSuccessWithStatus:@"分享成功"];
                 // 调用转发增加用户积分接口
                 if (addIntegral) {
                     [ShareService sendShareDataToServerWithType:platformType title:sharedTitle content:sharedContent sharedImage:compressedImage imageUrl:imageUrl shareUrl:shareUrl];
                 }
                 
                 break;
             }
             case SSDKResponseStateFail:
             {
                 [SVProgressHUD showErrorWithStatus:@"分享失败"];
                 break;
             }
             case SSDKResponseStateCancel:
             {
                 if (platformType == SSDKPlatformSubTypeQQFriend || platformType == SSDKPlatformSubTypeWechatSession)
                 {
                     if (userData == nil && contentEntity == NULL) {
                         //点击屏幕左上角“返回App”会走这一步:分享成功后点击［返回App］也会执行这里
                         [SVProgressHUD showInfoWithStatus:@"已分享"];
                         
                         // 调用转发增加用户积分接口
                         if (addIntegral) {
                             [ShareService sendShareDataToServerWithType:platformType title:sharedTitle content:sharedContent sharedImage:compressedImage imageUrl:imageUrl shareUrl:shareUrl];
                         }
                         
                     }else {
                         [SVProgressHUD showInfoWithStatus:@"分享已取消"];
                     }
                 }else
                 {
                     [SVProgressHUD showInfoWithStatus:@"分享已取消"];
                 }
                 
                 break;
             }
             default:
                 break;
         }
         
         if (block) {
             block(state);
         }
     }];
}




+ (void)sendShareDataToServerWithType:(SSDKPlatformType)platform
                                title:(NSString *)title
                              content:(NSString *)content
                          sharedImage:(UIImage *)sharedImage
                             imageUrl:(NSString *)imageUrl
                             shareUrl:(NSString *)shareUrl
{
    NSInteger contentType = 0; // 转发内容类型
    NSString *shareId = @""; // 分享数据Id
    if (shareUrl.length < 1) shareUrl = @""; // 分享链接
    
    NSInteger shareType = -1; // 分享平台
    if (platform == SSDKPlatformSubTypeWechatSession) {
        shareType = 1;
    }else if (platform == SSDKPlatformSubTypeWechatTimeline) {
        shareType = 2;
    }else if (platform == SSDKPlatformSubTypeQQFriend) {
        shareType = 3;
    }else if (platform == SSDKPlatformTypeSinaWeibo) {
        shareType = 4;
    }
    
    
    NSString *activityId = MYGetParamValueForKey(shareUrl, @"activityId");
    NSString *venueId = MYGetParamValueForKey(shareUrl, @"venueId");
    
    
    if (activityId.length && shareUrl.length) {
        // 活动详情分享
        contentType = 1;
        shareId = activityId;
    }else if (venueId.length && shareUrl.length) {
        // 场馆详情分享
        contentType = 2;
        shareId = venueId;
    }else {
        if ([sharedImage isKindOfClass:[UIImage class]] && imageUrl.length==0 && shareUrl.length==0) {
           // 只分享图片
            contentType = 3;
        }else {
            contentType = 4; // H5页面转发
        }
    }
    
    //调用分享统计接口
    [AppProtocol userShareStatisticsWithContentType:contentType// contentType： 1-活动详情转发  2-场馆详情转发  3-图片转发分享  4-H5页面转发
                                               link:shareUrl
                                          shareType:shareType // 分享的平台：1-微信好友 2-微信朋友圈 3-QQ好友 4-微博
                                            shareId:shareId
                                         UsingBlock:nil];
}


@end
