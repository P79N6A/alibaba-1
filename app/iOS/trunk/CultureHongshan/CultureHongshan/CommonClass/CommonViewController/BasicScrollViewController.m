//
//  BasicScrollViewController.m
//  WhereIsMyForward
//
//  Created by 李 兴 on 15-6-5.
//  Copyright (c) 2015年 李 兴. All rights reserved.
//

#import "BasicScrollViewController.h"

@interface BasicScrollViewController ()

@end

@implementation BasicScrollViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.bounces = YES;
    _scrollView.backgroundColor = kBgColor;
    [self.view addSubview:_scrollView];
    
    [self addTapGestureOnView:_scrollView target:nil action:nil];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
