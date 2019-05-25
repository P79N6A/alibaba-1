//
//  GuideViewController.h
//  时尚五角场
//
//  Created by 李 兴 on 14-7-21.
//  Copyright (c) 2014年 李 兴. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasicViewController.h"

/**
 *  首次启动的引导页
 */
@interface GuideViewController : BasicViewController
{
    BOOL _haveAnimation;
    CGFloat _position;
    UIPageControl * pageControl;
}

@property(nonatomic,retain) UIScrollView * scrollView;

@end
