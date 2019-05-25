//
//  UIWebView+AppSdk.m
//  CultureHongshan
//
//  Created by ct on 16/5/5.
//  Copyright © 2016年 CT. All rights reserved.
//

#import "UIWebView+AppSdk.h"

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


@implementation UIWebView (AppSdk)

#pragma mark - 将要废弃的方法

// 添加SDK方法
- (void)setSdkFunction {
    [self addGetUserLoginStatus];
    [self addGetUserInfoJS];
}


#pragma mark -

// 获取dom元素图片链接的Script
- (void)addGetImageUrlJs
{
    [self stringByEvaluatingJavaScriptFromString:@"\
     function app_getImageUrl(img) {\
        if (img) {\
            var url = img.getAttribute('src');\
            if (url && url.length) {\
                if (url.substring(0,4) == 'http') { return url; }\
                else { \
                    if (img.src.substring(0,4) == 'http') { return img.src; }\
                }\
            }\
            url = img.getAttribute('data-url');\
            if (url && url.length) {\
                if (url.substring(0,4) == 'http') {  return url; }\
                else {\
                    url = 'http://' + document.location.hostname + url;\
                    return url;\
                }\
            }\
            url = img.getAttribute('data-src');\
            if (url && url.length) {\
                if (url.substring(0,4) == 'http') {\
                    return url;\
                }\
            }\
        }\
        return '';\
     };\
     "];
}

// 图片点击事件是否已存在的判断
- (void)addJudgeImageEventExistJs
{
    NSString *eventJudgeJs = @"function imageEventIsExisting(img) {\
                if (img) {\
                    if (img.onclick) {\
                        var funStr = img.onclick.toString().replace(/\\s/g,'');\
                        if ( (/\\{\\S+\\}/).test(funStr) ) {\
                            return true;\
                        }\
                    }\
                    if (img.ondblclick) {\
                        var funStr = img.ondblclick.toString().replace(/\\s/g,'');\
                        if ( (/\\{\\S+\\}/).test(funStr) ) {\
                            return true;\
                        }\
                    }\
                    \
                    var parentNode = img.parentNode;\
                    if (parentNode && parentNode.tagName == 'A') {\
                        if (parentNode.href.length > 0) {\
                            return true;\
                        }\
                        if (parentNode.onclick) {\
                            var funStr = parentNode.onclick.toString().replace(/\\s/g,'');\
                            if ( (/\\{\\S+\\}/).test(funStr) ) {\
                                return true;\
                            }\
                        }\
                    }else if (parentNode) {\
                        if (parentNode.onclick) {\
                            var funStr = parentNode.onclick.toString().replace(/\\s/g,'');\
                            if ( (/\\{\\S+\\}/).test(funStr) ) {\
                                return true;\
                            }\
                        }\
                    }\
                }\
        return false;\
    }";
    [self stringByEvaluatingJavaScriptFromString:eventJudgeJs];
    
    
    [self addCheckImageSizeScript];
}

// 字体设置
- (void)addFontSettingJs
{
    // Microsoft YaHei  Yuanti SC
    [self stringByEvaluatingJavaScriptFromString:@"\
        function resetStyleForTagName(tag) {\
			var elements = document.getElementsByTagName(tag);\
            for (var i = 0; i < elements.length; i++) {\
				var e = elements[i];\
                e.style.fontSize = '15px';\
                e.style.fontFamily = 'Yuanti SC';\
                e.style.lineHeight = '28px';\
            }\
        }\
    "];
    [self stringByEvaluatingJavaScriptFromString:@"\
        function formatStyle() {\
            resetStyleForTagName('p');\
            resetStyleForTagName('span');\
            resetStyleForTagName('font');\
            resetStyleForTagName('a');\
        }\
     "];
    [self stringByEvaluatingJavaScriptFromString:@"formatStyle()"];
}

//给图片添加点击事件
- (void)addImageClickActionJs
{
    [self stringByEvaluatingJavaScriptFromString:@"\
     function assignImageClickAction() {\
        var imgArray = document.getElementsByTagName('img');\
        var realImgIndex = -1;\
        for (var i = 0; i < imgArray.length; i++) {\
            var image = imgArray[i];\
            if (appsdk_checkImageSize(image)) {\
                if (app_getImageUrl(image).length < 1) {\
                    continue;\
                }\
                realImgIndex += 1;\
                image.imgIndex = realImgIndex;\
                if ( !imageEventIsExisting(image) && image.style.display !== 'none'){\
                    image.onclick = function () { \
                        window.location.href = 'image-preview:' + app_getImageUrl(this) + ';' + this.imgIndex.toString();\
                    }\
                }else {}\
            }\
        }\
     };"];
    
    [self stringByEvaluatingJavaScriptFromString:@"assignImageClickAction();"];
}

//调整网页中图片的大小
- (void)addResizeWebImageJs
{
    [self stringByEvaluatingJavaScriptFromString:@"\
        function ResizeImage() {\
            var maxWidth = screen.width - 15;\
            var imageArray = document.getElementsByTagName('img');\
            for (var i = 0; i < imageArray.length; i++) {\
                var image = imageArray[i];\
                var imgWidth = image.width;\
                var imgStyleWidth = image.style.width.replace(/px/g,'');\
                if (image.width > maxWidth || imgWidth != imgStyleWidth) {\
                    var imgScale = image.height / Math.max(imgWidth,imgStyleWidth);\
                    image.style.width = maxWidth + 'px';\
                    image.style.height = maxWidth * imgScale + 'px';\
                }\
            }\
        };\
     "];
    [self stringByEvaluatingJavaScriptFromString:@"ResizeImage();"];
    /*
     有时候，image.width 会与 image.style.width 的值不相等。需要多加一步判断
     Log('screen.width:' + document.body.offsetWidth + ' | ' + imgWidth + ' | ' + Math.max(imgWidth,imgStyleWidth));\
     */
}


//获取网页中的所有图片链接
- (NSArray *)getImageUrlArrayFromWeb
{
    if (![self functionDidExist:@"appsdk_checkImageSize"]) {
        [self addCheckImageSizeScript];
    }
    
    if (![self functionDidExist:@"app_getImageUrl"]) {
        [self addGetImageUrlJs];
    }
    
    [self stringByEvaluatingJavaScriptFromString:@"\
     function getImageLinks(){\
        var imageArray = document.getElementsByTagName('img');\
        var imgSrc = '';\
        for (var i = 0; i < imageArray.length; i++){\
            var image = imageArray[i];\
            var imgUrl = app_getImageUrl(image);\
            if (imgUrl.length > 0) {\
                if (imgUrl.indexOf('http') == 0) {\
                    imgSrc += imgUrl + ';' ;\
                }else {\
                    imgSrc += 'http://' + document.location.hostname + imgUrl + ';' ;\
                }\
            }\
        }\
        return imgSrc;\
     };"];
    NSString *imgStr = [self stringByEvaluatingJavaScriptFromString:@"getImageLinks();"];
    return [ToolClass getComponentArray:imgStr separatedBy:@";"];
}

// 获取网页中的第一张图片链接
- (NSString *)getWebFirstImageUrl {
    for (NSString *imgUrl in [self getImageUrlArrayFromWeb]) {
        if ([imgUrl isValidImgUrl]) {
            return [imgUrl copy];
        }
    }
    return @"";
}

// 获取网页内容的显示高度
- (CGFloat)getWebViewContentHeight
{
    self.height += 2;
    CGFloat height1 = self.scrollView.contentSize.height;
    CGFloat height2 = [[self stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight;"] floatValue];
    return MAX(height1, height2);
}

// 获取网页的正文内容
- (NSString *)getWebViewHTMLContent {
    NSString *tmpString = [self stringByEvaluatingJavaScriptFromString:@"document.body.innerText"];
    // 去除空白字符 以及 html转义字符
    NSString *str = [tmpString stringByReplacingOccurrencesOfString:@"\\s+|&[a-zA-Z]{1,8};|&#[0-9]{1,6};" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, tmpString.length)];
    return str;
}

// 获取导航栏标题
- (NSString *)getWebViewNavTitle {
    return [self stringByEvaluatingJavaScriptFromString:@"document.title"];
}

// 获取当前页面的地址
- (NSString *)getCurrentUrl {
    return [self stringByEvaluatingJavaScriptFromString:@"window.location.href"];
}

// 获取前一个页面的地址
- (NSString *)getPreviousUrl  {
    return [self stringByEvaluatingJavaScriptFromString:@"document.referrer"];
}


// 判断JS方法是否存在
- (BOOL)functionDidExist:(NSString *)funcName {
    if (funcName.length > 0) {
        return [[self stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"typeof %@", funcName]] isEqualToString:@"function"];
    }
    return NO;
}




#pragma mark - Private Methods

/** 获取用户信息 */
- (void)addGetUserInfoJS {
    User *user = [UserService sharedService].user;
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] initWithCapacity:2];
    dic[@"userId"] = user.userId;
    dic[@"userName"] = user.userNameFull;
    NSString * json = [[JsonTool jsonStringFromDict:dic escapedKeys:nil] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSString * jsstr = [NSString stringWithFormat:@"function appsdk_getUserInfo(){return '%@';} ",json];
    [self stringByEvaluatingJavaScriptFromString:jsstr];
}

/** 获取用户登录状态 */
- (void)addGetUserLoginStatus {
    NSString * ret = ([UserService sharedService].userId.length > 0) ? @"true" : @"false";
    NSString * script = [NSString stringWithFormat:@"function appsdk_UserIsLogin(){return %@;} ",ret];
    [self stringByEvaluatingJavaScriptFromString:script];
}

/** 添加判断图片大小是否合适的JS方法 */
- (void)addCheckImageSizeScript {
    [self stringByEvaluatingJavaScriptFromString:@"\
        function appsdk_checkImageSize (img) {\
            if (img) {\
                var imgScale = img.height / img.width ;\
                var bodyWidth = document.body.clientWidth;\
                var showImgWidthScale = img.width / bodyWidth;\
                if (showImgWidthScale > 0.8 && imgScale > 0.35) {\
                    return true;\
                }\
            }\
            return false;\
        }\
     "];
}


@end
