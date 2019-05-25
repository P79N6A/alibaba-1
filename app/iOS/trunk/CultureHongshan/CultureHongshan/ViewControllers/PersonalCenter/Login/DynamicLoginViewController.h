//
//  DynamicLoginViewController.h
//  CultureHongshan
//
//  Created by ct on 16/12/1.
//  Copyright © 2016年 CT. All rights reserved.
//

#import "BasicCustomNavigationBarViewController.h"

/** 动态登录页面 */
@interface DynamicLoginViewController : BasicCustomNavigationBarViewController

@property (nonatomic, copy) NSString *redirectUrl;//Web调用登录页面返回时的回调地址
@property (nonatomic, copy) NSString *phoneNumber;//注册完成后，直接填充手机号
@property (nonatomic, copy) void (^loginCompletionHandler)();
@end
