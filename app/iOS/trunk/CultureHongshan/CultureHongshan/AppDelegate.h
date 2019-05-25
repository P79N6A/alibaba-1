//
//  AppDelegate.h
//  CultureHongshan
//
//  Created by one on 15/11/5.
//  Copyright © 2015年 CT. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Reachability.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    Boolean  isConnect;
}

@property (nonatomic,retain ) Reachability *reachablity;
@property (nonatomic,assign ) BOOL         isFullScreen;
@property (nonatomic,retain ) UIButton     *Leftbutton;
@property (strong, nonatomic) UIWindow     *window;
@property (nonatomic, assign) BOOL allowRotation;

@end


/*
 重要须知：
        1. 发表评论页需要修改
 
 */
