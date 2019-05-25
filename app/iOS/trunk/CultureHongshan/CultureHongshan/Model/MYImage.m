//
//  MYImage.m
//  CultureHongshan
//
//  Created by JackAndney on 2017/7/26.
//  Copyright © 2017年 CT. All rights reserved.
//

#import "MYImage.h"

@implementation MYImage


// 本地图片的初始化方法
+ (instancetype)imageWithLocalURL:(NSURL *)localUrl image:(UIImage *)image {
    MYImage *myImg = [MYImage new];
    myImg.localURL = localUrl;
    myImg.imageObj = image;
    
    return myImg;
}


// 网络图片的初始化方法
+ (instancetype)imageWithNetworkUrl:(NSString *)networkUrl {
    MYImage *myImg = [MYImage new];
    myImg.networkUrl = networkUrl;
    return myImg;
}



@end
