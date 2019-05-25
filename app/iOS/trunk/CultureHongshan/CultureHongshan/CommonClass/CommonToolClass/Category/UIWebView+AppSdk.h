//
//  UIWebView+AppSdk.h
//  CultureHongshan
//
//  Created by ct on 16/5/5.
//  Copyright © 2016年 CT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>


@interface UIWebView (AppSdk)<UIWebViewDelegate>

/** 添加SDK方法 */
- (void)setSdkFunction;

- (void)addJudgeImageEventExistJs; // 添加图片点击事件是否已存在的判断
- (void)addGetImageUrlJs; // 获取图片链接
- (void)addFontSettingJs; // UIWebView字体设置
- (void)addImageClickActionJs; // 给图片添加点击事件
- (void)addResizeWebImageJs; // 调整网页中图片的大小

/** 获取网页中的图片链接数组 */
- (NSArray<NSString *> *)getImageUrlArrayFromWeb;
// 获取网页中的第一张图片链接
- (NSString *)getWebFirstImageUrl;

/** 获取网页的正文高度 */
- (CGFloat)getWebViewContentHeight;
// 获取网页的正文内容
- (NSString *)getWebViewHTMLContent;

/** 获取导航条的标题 */
- (NSString *)getWebViewNavTitle;
/** 获取当前页面的地址 */
- (NSString *)getCurrentUrl;
/** 获取前一个页面的地址 */
- (NSString *)getPreviousUrl;

/** 判断JS方法是否存在 */
- (BOOL)functionDidExist:(NSString *)funcName;


@end



