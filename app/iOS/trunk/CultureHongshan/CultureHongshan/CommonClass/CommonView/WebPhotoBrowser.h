//
//  WebPhotoBrowser.h
//  CultureHongshan
//
//  Created by ct on 16/7/19.
//  Copyright © 2016年 ct. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebPhotoBrowser : UIView


/** 当前显示的是第几张图片 */
@property (nonatomic, assign, readonly) NSInteger currentIndex;
/** 当前显示的图片 */
@property (nonatomic, copy, readonly) UIImage *currentImage;
/** 显示完成后的回调 */
@property (nonatomic, copy) void (^completionHandler)(WebPhotoBrowser *photoBrowser);


/**
 图片浏览器
 
 @param imgUrls      图片链接 或 图片 数组
 @param currentIndex 当前要显示第几张
 @param block        点击图片消失后的回调
 */
+ (void)photoBrowserWithImageUrlArray:(NSArray *)imgUrls
                         currentIndex:(NSInteger)currentIndex
                      completionBlock:(void (^)(WebPhotoBrowser *photoBrowser))block;

@end
