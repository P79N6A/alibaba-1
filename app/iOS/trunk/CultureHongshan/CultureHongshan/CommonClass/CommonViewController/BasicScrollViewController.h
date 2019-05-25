//
//  BasicScrollViewController.h
//  WhereIsMyForward
//
//  Created by 李 兴 on 15-6-5.
//  Copyright (c) 2015年 李 兴. All rights reserved.
//

#import "BasicViewController.h"


/**
 将ScrollView作为页面背景的视图控制器
 
 @discussion 建议页面中有输入框的使用该类，可以自动处理“点击页面、键盘消失”
 */
@interface BasicScrollViewController : BasicViewController
{
    UIScrollView * _scrollView;
}


@end
