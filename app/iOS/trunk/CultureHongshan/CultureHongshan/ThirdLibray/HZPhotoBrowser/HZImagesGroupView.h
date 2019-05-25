//
//  HZImagesGroupView.h
//  photoBrowser
//
//  Created by huangzhenyu on 15/6/23.
//  Copyright (c) 2015年 eamon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HZImagesGroupView : UIView

@property (nonatomic, assign) CGFloat viewWidth;//容器视图的宽度
@property (nonatomic, assign) CGFloat spacing;//两边的间距
@property (nonatomic, assign) CGFloat picScale;//图片的高度和宽度之比
@property (nonatomic, strong) NSArray *photoItemArray;

@end
