//
//  FBTabbarController.h
//  徐家汇
//
//  Created by 李 兴 on 13-9-16.
//  Copyright (c) 2013年 李 兴. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FBTabbarController : UITabBarController<UITabBarControllerDelegate>
{
    
    UIViewController * centerVC;
    UIView * _maskView;
    FBButton * _createSceneButton;
    FBButton * _createPoiButton;

}

- (void)tabBarHidden:(BOOL)isHidden;

@end
