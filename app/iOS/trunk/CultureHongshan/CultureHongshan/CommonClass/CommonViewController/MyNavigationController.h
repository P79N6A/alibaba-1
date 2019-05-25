//
//  MyNavigationController.h
//  徐家汇
//
//  Created by 李 兴 on 13-10-2.
//  Copyright (c) 2013年 李 兴. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyNavigationController : UINavigationController
{
    UIButton * _backBut;
    UIBarButtonItem * _barButton;
}

- (void)switchRootVC:(UIViewController *) vc;
- (id)initWithRootViewController:(UIViewController *)rootViewController;

@end
