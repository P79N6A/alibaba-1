//
//  AppVersionUpdateView.h
//  属性字符串Test
//
//  Created by ct on 16/4/28.
//  Copyright © 2016年 ct. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AppUpdateModel;

@interface AppVersionUpdateView : UIView



/**
 版本升级视图

 @param model 版本升级Model
 @param handler 回调：index:0-无需操作  1-立即更新
 */
+ (void)showUpdateViewWithModel:(AppUpdateModel *)model completionHandler:(void (^)(NSInteger index))handler;



@end
