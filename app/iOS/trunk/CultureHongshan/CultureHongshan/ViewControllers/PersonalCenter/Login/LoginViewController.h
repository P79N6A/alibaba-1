//
//  LoginViewController.h
//  TableVIewCellTest
//
//  Created by JackAndney on 16/4/14.
//  Copyright © 2016年 Andney. All rights reserved.
//

#import "BasicCustomNavigationBarViewController.h"

@interface LoginViewController : BasicCustomNavigationBarViewController

@property (nonatomic, strong) UIImage *screenshotImage;
@property (nonatomic, assign) LoginVCSourceType sourceType;//从哪个页面进入该界面

// 下面的属性不是必须的
@property (nonatomic, copy) NSString *redirectUrl;//Web调用登录页面返回时的回调地址
@property (nonatomic, copy) NSString *phoneNumber;//注册完成后，直接填充手机号

/**
 登录成功后的回调
 */
@property (nonatomic, copy) void (^loginCompletionHandler)();
@end
