//
//  MYImageView.h
//  WHYToolSDK
//
//  Created by JackAndney on 2017/5/14.
//  Copyright © 2017年 Creatoo. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 默认情况下，图片会按比例裁剪铺满视图，保证图片不变形。超出视图的部分会被裁减掉(masksToBounds = YES)
 */
@interface MYImageView : UIImageView

@property (nonatomic, strong) UIImage *smallImage; // 小图
@property (nonatomic, strong) UIImage *bigImage; // 大图

@end
