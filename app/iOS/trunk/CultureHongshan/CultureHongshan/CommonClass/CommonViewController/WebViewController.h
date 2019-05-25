//
//  WebViewController.h
//  徐家汇
//
//  Created by 李 兴 on 13-10-12.
//  Copyright (c) 2013年 李 兴. All rights reserved.
//

#import "BasicViewController.h"


#pragma mark - WebViewControllerProtocol

/**
 网页浏览器接口协议
 */
@protocol WebViewControllerProtocol <NSObject>
/** 分享按钮是否隐藏 */
@property (nonatomic, assign) BOOL shareButtonHidden;
/** 导航栏标题是否被H5页面修改 */
@property (nonatomic, assign) BOOL currentPageNavTitleChanged;
/** 网页中第一个图片的链接 */
@property (nonatomic, copy) NSString *firstWebImgUrl;
/** 图片中的第一张图片 */
@property (nonatomic, strong) UIImage *currentPageShareImage;
/** 返回前一个页面 */
- (void)backToLastPage;
/** 调用App的分享功能 */
- (void)shareByApp:(NSDictionary *)shareInfo;
@end





#pragma mark - WebViewController


/**
 网页浏览器页面
 */
@interface WebViewController : BasicViewController <WebViewControllerProtocol>

/** 导航栏标题 */
@property (nonatomic, copy) NSString *navTitle;
/** 导航条标题是否锁定 */
@property (nonatomic, assign) BOOL navTitleLocked;
/** 访问链接地址 */
@property (nonatomic, copy) NSString *url;
/** 扩展参数(暂时未用到) */
@property (nonatomic, strong) NSDictionary *extParams;




@property (nonatomic, assign) BOOL isBookPage;// 是否为预订页面

@property (nonatomic, copy) UIImage *sharedImage;
@property (nonatomic, copy) NSString *sharedImgUrl;
@property (nonatomic, copy) NSString *shareContent;//分享的内容

@property (nonatomic, readonly) NSString *currentUrl;


@property(retain,nonatomic) UIActivityIndicatorView * indicatorView;

- (void)loadRedirectUrlAfterLogining:(NSString *)redirectUrl;

@end
