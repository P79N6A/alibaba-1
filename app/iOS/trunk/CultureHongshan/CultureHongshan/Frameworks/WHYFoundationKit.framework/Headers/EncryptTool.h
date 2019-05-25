//
//  EncryptTool.h
//  WHYFoundationKit
//
//  Created by JackAndney on 2017/5/14.
//  Copyright © 2017年 Creatoo. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 加密、解密工具类
 */
@interface EncryptTool : NSObject


/**
 对NSString或NSData进行MD5加密
 
 @param data  要加密的字符串或数据
 
 @return 32位小写md5字符串
 */
+ (NSString *)md5Encode:(id)data;


/**
 获取文件的MD5值（花费时间较长）
 
 @param filePath 文件路径
 
 @return 32位小写md5字符串
 */
+ (NSString *)md5EncodeForFile:(NSString *)filePath;

/**
 对字符串进行BASE64编码
 
 @param string 要编码的字符串
 
 @return 编码后的字符串
 */
+ (NSString *)base64Encode:(NSString *)string;

/**
 对字符串进行BASE64解码
 
 @param string 要解码的字符串
 
 @return 解码后的字符串
 */
+ (NSString *)base64Decode:(NSString *)string;


/**
 对字符串进行SHA1加密
 
 @param string 要加密的字符串
 
 @return 加密后的字符串
 */
+ (NSString *)sha1Encode:(NSString *)string;

/**
 获取IP地址
 
 @param preferIPv4 优先获取ipv4的还是ipv6的地址
 
 @return IP地址
 */
+ (NSString *)getIPAddress:(BOOL)preferIPv4;

/**
 URL加密
 
 @discussion 确保MD5_PRIVATEKEY宏定义已经设置
 */
+ (NSString * )getEncryptUrl:(NSString *)url;




@end
