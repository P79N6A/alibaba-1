//
//  MyNavigationController.m
//  徐家汇
//
//  Created by 李 兴 on 13-10-2.
//  Copyright (c) 2013年 李 兴. All rights reserved.
//

#import "MyNavigationController.h"
#import "BasicViewController.h"

@interface MyNavigationController ()

@end

@implementation MyNavigationController


-(id)initWithRootViewController:(UIViewController *)rootViewController
{
    if (self = [super initWithRootViewController:rootViewController])
    {
        //导航条返回键带的title太讨厌了，怎么让它消失？
        //[[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
        
        self.navigationBar.barTintColor = kNavigationBarColor;
        [self.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(20),NSForegroundColorAttributeName:[UIColor whiteColor]}];
        
        self.navigationBar.translucent = NO;
    }
    return self;
}


-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0)
    {
        UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -22, 0, 0);
        [backBtn setImage:IMG(kReturnButtonImageName) forState:UIControlStateNormal];
        
        if ([viewController isKindOfClass:[BasicViewController class]]) {
            [backBtn addTarget:(BasicViewController *)viewController action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
        }else {
            
        }
        
        viewController.navigationItem.leftBarButtonItem =  [[UIBarButtonItem alloc] initWithCustomView:backBtn];
        viewController.hidesBottomBarWhenPushed = YES;
    }
   
    [super pushViewController:viewController animated:animated];
}

- (void)switchRootVC:(UIViewController *) vc
{
    if ([vc isKindOfClass:[UIViewController class]]) {
        NSArray * ary = [[NSArray alloc] initWithObjects:vc, nil];
        [self setViewControllers:ary];
        [self popViewControllerAnimated:NO];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
