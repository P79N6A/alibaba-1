//
//  BasicBgImgViewController.m
//  CultureHongshan
//
//  Created by ct on 16/5/16.
//  Copyright © 2016年 CT. All rights reserved.
//

#import "BasicBgImgViewController.h"

@implementation BasicBgImgViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.bgImgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    _bgImgView.userInteractionEnabled = YES;
    _bgImgView.image = _bgImg;
    [self.view addSubview:_bgImgView];
    
    if (_returnButtonHidden == NO) {
        UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 44, 44)];
        [backButton setImage:IMG(kReturnButtonImageName) forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:backButton];
        backButton.centerX = 30;
    }
    
    [self addTapGestureOnView:_bgImgView target:nil action:nil];
}


@end
