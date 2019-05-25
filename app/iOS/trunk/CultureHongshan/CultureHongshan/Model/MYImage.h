//
//  MYImage.h
//  CultureHongshan
//
//  Created by JackAndney on 2017/7/26.
//  Copyright © 2017年 CT. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 自定义图片对象
 */
@interface MYImage : NSObject

/** 图片对象 */
@property (nonatomic, strong) UIImage *imageObj;
/** 本地图片URL */
@property (nonatomic, copy) NSURL *localURL;
/** 网络图片地址 */
@property (nonatomic, copy) NSString *networkUrl;


/** 本地图片的初始化方法 */
+ (instancetype)imageWithLocalURL:(NSURL *)localUrl image:(UIImage *)image;

/** 网络图片的初始化方法 */
+ (instancetype)imageWithNetworkUrl:(NSString *)networkUrl;

@end
