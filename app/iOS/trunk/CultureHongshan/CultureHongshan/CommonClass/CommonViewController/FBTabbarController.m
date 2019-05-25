//
//  FBTabbarController.m
//  徐家汇
//
//  Created by 李 兴 on 13-9-16.
//  Copyright (c) 2013年 李 兴. All rights reserved.
//

#import "FBTabbarController.h"
#import "MyNavigationController.h"

@interface FBTabbarController ()

@end

@implementation FBTabbarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
#ifdef FUNCTION_ENABLED_SQUARE
        NSArray * vcs = @[@"HomepageViewController",@"ActivityListViewController",@"VenueListViewController",@"AssociationViewController",@"CenterViewController"];
        NSArray * titles = @[@"首页",@"活动",@"空间",@"广场",@"我"];
        NSArray * imageNames = @[@"首页",@"活动",@"空间",@"广场",@"我"];
#else
        NSArray * vcs = @[@"HomepageViewController",@"ActivityListViewController",@"VenueListViewController",@"CenterViewController"];
        NSArray * titles = @[@"首页",@"活动",@"空间",@"我"];
        NSArray * imageNames = @[@"首页",@"活动",@"空间",@"我"];
        
#endif
        
        NSMutableArray * views = [NSMutableArray new];
        for (int i=0; i<vcs.count; i++)
        {
            NSString * classname = vcs[i];
            UIViewController * vc = [NSClassFromString(classname) new];
            NSString * imageName = [NSString stringWithFormat:@"%@_on",imageNames[i]];
            NSString * imageunselName = [NSString stringWithFormat:@"%@",imageNames[i]];
            MyNavigationController * nav = [[MyNavigationController alloc] initWithRootViewController:vc];
            UIImage * imgunsel = [IMG(imageunselName) imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            UIImage * imgsel = [IMG(imageName) imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            nav.tabBarItem.image  = imgunsel;
            nav.tabBarItem.selectedImage = imgsel;
            nav.tabBarItem.title = titles[i];
            [nav.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:FONT(11)} forState:UIControlStateNormal];
            nav.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -4);
            [views addObject:nav];
        }
        self.viewControllers = views;
    }
    return self;
}


- (void)viewDidLoad
{
    self.delegate = self;
    [super viewDidLoad];
    self.tabBar.backgroundColor = COLOR_IGRAY;
    //self.tabBar.backgroundImage = IMG(@"tabbar_bg");
    [[UITabBar appearance] setTintColor:COLOR_IBLACK];
    
    //[[UITabBar appearance] setBarTintColor:COLOR_CLEAR];
    //[[UITabBar appearance] setBackgroundColor:COLOR_CLEAR];
    self.tabBar.shadowImage = IMG(@"alaphPoint");
    self.tabBar.opaque = NO;
    self.tabBar.translucent = YES;
}



-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if (viewController == tabBarController.selectedViewController) {
        return NO;
    }
    
    if ([self.viewControllers indexOfObject:viewController] == 3)
    {
        [(UINavigationController *)viewController setNavigationBarHidden:NO];
    }else
    {
        [(UINavigationController *)viewController setNavigationBarHidden:YES];
    }
    
    return YES;
}




-(void)removeMask
{
    CGRect buttonFrame = MRECT(WIDTH_SCREEN/2 - 22, HEIGHT_SCREEN_FULL - 51,44,44);
    [_maskView removeFromSuperview];
    _createSceneButton.frame = buttonFrame;
    _createPoiButton.frame = buttonFrame;
}

- (void)tabBarHidden:(BOOL)isHidden
{
    if (self.tabBar.hidden == isHidden) {
        return;
    }
    
    UIView *tab = self.view;
    
    if([tab.subviews count] < 2) {
        return;
    }
    
    UIView *view;
    if([[tab.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]]) {
        view = [tab.subviews objectAtIndex:1];
    }else {
        view = [tab.subviews objectAtIndex:0];
    }
    
    if(isHidden) {
        view.frame = tab.bounds;
    }else {
        view.frame = CGRectMake(tab.bounds.origin.x, tab.bounds.origin.y, tab.bounds.size.width, tab.bounds.size.height);
    }
    self.view.frame = view.frame;
    self.tabBar.hidden = isHidden;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
