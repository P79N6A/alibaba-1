//
//  PageAccessTool.h
//  CultureHongshan
//
//  Created by JackAndney on 2017/7/7.
//  Copyright © 2017年 CT. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 页面访问工具类
 */
@interface PageAccessTool : NSObject

/**
 *  页面跳转
 *
 *  @param pageType   页面类型
 *  @param url        数据URL 或 id
 *  @param navVC      导航控制器
 *  @param sourceType 页面来源：1 - App内  2 - H5页面
 *  @param extParams  扩展参数
 *
 *  @return 布尔值：是否跳转成功
 */
+ (BOOL)accessAppPage:(AppPageType)pageType url:(NSString *)url navVC:(UINavigationController *)navVC sourceType:(NSInteger)sourceType extParams:(NSDictionary *)extParams;


/**
 检查是否可以访问某个页面

 @param pageType 页面类型
 @param url      数据URL 或 id
 @return 布尔值
 */
+ (BOOL)canAccessPage:(AppPageType)pageType url:(NSString *)url;



@end
