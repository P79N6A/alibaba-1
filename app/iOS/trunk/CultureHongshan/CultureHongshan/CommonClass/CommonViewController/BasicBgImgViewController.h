//
//  BasicBgImgViewController.h
//  CultureHongshan
//
//  Created by ct on 16/5/16.
//  Copyright © 2016年 CT. All rights reserved.
//

#import "BasicViewController.h"


/**
 将图片作为整个页面背景的视图控制器
 */
@interface BasicBgImgViewController : BasicViewController

@property (nonatomic, strong) UIImageView *bgImgView;
@property (nonatomic, strong) UIImage *bgImg;
@property (nonatomic, assign) BOOL returnButtonHidden;

@end
