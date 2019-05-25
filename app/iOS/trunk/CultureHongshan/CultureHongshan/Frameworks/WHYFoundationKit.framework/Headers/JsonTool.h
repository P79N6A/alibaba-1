//
//  JsonTool.h
//  WHYFoundationKit
//
//  Created by JackAndney on 2017/5/14.
//  Copyright © 2017年 Creatoo. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 JSON工具类
 */
@interface JsonTool : NSObject

+ (nullable id)jsonObjectFromFilePath:(nonnull NSString *)path;
+ (nullable id)jsonObjectFromData:(nonnull NSData *)data;
+ (nullable id)jsonObjectFromString:(nonnull NSString *)string;

+ (nullable NSData *)jsonDataFromJsonObject:(nonnull id)jsonObj;
+ (nullable NSString *)jsonStringFromJsonObject:(nonnull id)jsonObj;



/**
 字典 转 JSON数据
 
 @param escapedKeys 需要剔除的键值对
 */
+ (nonnull NSData *)jsonDataFromDict:(nonnull NSDictionary *)jsonDict escapedKeys:(nullable NSArray<NSString *> *)escapedKeys;

/**
 字典 转 JSON字符串
 
 @param escapedKeys 需要剔除的键值对
 */
+ (nonnull NSString *)jsonStringFromDict:(nonnull NSDictionary *)jsonDict escapedKeys:(nullable NSArray<NSString *> *)escapedKeys;

/**
 字典 转 URL请求字符串
 
 @param escapedKeys 需要剔除的键值对
 */
+ (nonnull NSString *)urlStringFromDict:(nonnull NSDictionary *)jsonDict escapedKeys:(nullable NSArray<NSString *> *)escapedKeys;


@end
