//
//  SharePresentView.h
//  CultureHongshan
//
//  Created by JackAndney on 2017/7/10.
//  Copyright © 2017年 CT. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 仅展示分享视图
 */
@interface SharePresentView : UIView

/**
 展示分享页面
 
 @param handler   点击事件回调:  1-微信好友  2-微信朋友圈  3-QQ好友  4-新浪微博
 */
+ (void)showShareViewWithActionHandler:(void(^)(NSInteger index))handler;

/**
 分享方法

 @param title       分享的标题
 @param content     分享的内容
 @param sharedImage 分享的内容
 @param imageUrl    分享的图片Url
 @param shareUrl    分享的地址链接
 @param extParams   附加参数：addIntegral
 */
+ (void)showShareViewWithTitle:(NSString *)title
                       content:(NSString *)content
                   sharedImage:(UIImage *)sharedImage
                      imageUrl:(NSString *)imageUrl
                      shareUrl:(NSString *)shareUrl
                     extParams:(NSDictionary *)extParams; // 目前（2017.12.18），只有活动、场馆详情页的分享用到这个方法


/**
 是否可以展示分享视图

 @return 布尔值
 */
+ (BOOL)canShowShareView;


@end
