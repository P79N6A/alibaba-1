//
//  ProtocolBased.h
//  CultureHongshan
//
//  Created by Simba on 15/7/8.
//  Copyright (c) 2015年 Sun3d. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WHYHttpRequestTypeDefines.h"

typedef void (^HttpResponseBlock) (HttpResponseCode responseCode, id responseObject);


@interface ProtocolBased : NSObject


// GET请求
+ (void)requestGetWithParameters:(NSDictionary *)parameterDic protocolString:(NSString *)protocolString cacheMode:(EnumCacheMode)cacheMode UsingBlock:(HttpResponseBlock)httpResponseBlock;

// POST请求
+ (void)requestPostWithParameters:(NSDictionary *)parameterDic protocolString:(NSString *)protocolString cacheMode:(EnumCacheMode)cacheMode UsingBlock:(HttpResponseBlock)httpResponseBlock;

// Json字符串作为参数
+ (void)requestPostWithJsonParameters:(NSDictionary *)parameterDic protocolString:(NSString *)protocolString cacheMode:(EnumCacheMode)cacheMode UsingBlock:(HttpResponseBlock)httpResponseBlock;


/**
 文化云上传图片文件
 
 @param  type          上传文件的类型
 @param  image         上传的图片
 @param  dataId        上传数据对应的Id
 @param  progressBlock 上传进度回调（未实现）
 
 */
+ (void)uploadFileWithType:(FileUploadType)type image:(UIImage *)image dataId:(NSString *)dataId progressBlock:(void (^)(CGFloat))progressBlock responseBlock:(HttpResponseBlock)httpResponseBlock;


+ (NSDictionary *)requestHeaderParams;


@end

