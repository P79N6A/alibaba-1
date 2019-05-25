//
//  ToolClass.h
//  WHYFoundationKit
//
//  Created by JackAndney on 2017/5/14.
//  Copyright © 2017年 Creatoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ToolClass : NSObject


#pragma mark - 字符串 与 数组 互转

/**
 *  字符串分割成数组
 *
 *  @param string   需要分割的字符串
 *  @param splitStr 分隔符
 *
 *  @return 分割后的数组
 */
+ (NSArray<NSString *> *)getComponentArray:(NSString *)string separatedBy:(NSString *)splitStr;

/**
 *  字符串分割成数组,忽略空字符串
 */
+ (NSArray<NSString *> *)getComponentArrayIgnoreBlank:(NSString *)string separatedBy:(NSString *)splitStr;

/** 图片链接分割 */
+ (NSArray<NSString *> *)getImgUrlArray:(NSString *)imgUrl separatedBy:(NSString *)splitStr maxCount:(int)maxCount;

/**
 *  数组合并成字符串
 */
+ (NSString *)getComponentString:(NSArray<NSString *> *)array combinedBy:(NSString *)combinedStr;


#pragma mark - 一行有多个元素时，计算间距或宽度

// 宽度固定，间距可调
/**
 *  已知元素的宽度和最小可容忍间距，计算一行有多个元素时，元素之间的实际间距
 */
+ (CGFloat)getElementSpacingWithMinSpacing:(CGFloat)minSpacing elementWidth:(CGFloat)elementWidth containerWidth:(CGFloat)containerWidth elementNum:(int *)eleNum;

// 间距固定，宽度可调
/**
 *  已知元素的最小可容忍宽度和元素之间的间距，计算一行有多个元素时该元素的实际宽度
 */
+ (CGFloat)getElementWidthWithMinWidth:(CGFloat)minWidth elementSpacing:(CGFloat)elementSpacing containerWidth:(CGFloat)containerWidth elementNum:(int *)eleNum;


#pragma mark - 其它

/**
 *  给字符串每隔指定数目的字符添加一个空格
 *
 *  @param length 多少个字符为一个单位
 *
 */
+ (NSString *)getSpaceSeparatedString:(NSString *)originalString length:(NSInteger)length;

/** 获取HTML字符串中的正文内容（速度较慢） */
+ (NSString *)getHTMLContent:(NSString *)htmlStr limitedLength:(NSInteger)limitedLength;

/** html字符串 转换成 属性字符串 */
+ (NSAttributedString *)getHtmlAttributedText:(NSString *)htmlStr;


/** 找出字符串中数字的range */
+ (NSArray<NSValue *> *)getDigitalNumberRanges:(NSString *)string;

/** 获取最接近的整数 */
+ (NSInteger)getNearestInteger:(double)number;

/** 判断访问数组内元素的索引是否越界 */
+ (BOOL)dataIsValid:(NSInteger)index forArrayCount:(NSInteger)count;

/**
 *  计算有多个元素时，可以分为多少组
 *
 *  @param totalCount  元素的总个数
 *  @param perCount    以多少个元素为一组
 *
 */
+ (NSInteger)getGroupNum:(NSUInteger)totalCount perGroupCount:(NSInteger)perCount;

/** 拼接两个字符串：只有当两个字符串都存在且不一样时，才有中间的拼接符号 */
+ (NSString *)getJointedString:(NSString *)str1 otherStr:(NSString *)str2 jointedBy:(NSString *)jointedStr;

/**
 *  版本号比较
 *
 *  @discussion version1 > version2时，返回 NSOrderedAscending
 */
+ (NSComparisonResult)versionCompare:(NSString *)version1 comparedVersion:(NSString *)version2;


#pragma mark -


+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL;

+ (void)setDefaultValue:(id)value forKey:(NSString *)key;
+ (id)getDefaultValue:(NSString *)key;

+ (BOOL)isFirstVisit;
+ (void)updateFirstVisitState;

/** 前天、昨天、今天、明天、具体日期 */
+ (NSString *)getDayNameByDateString:(NSString *)dateStr;


#pragma mark - C Style Function


/** 随机图片地址 */
NSString *RandomImgUrl();
/** 随机的UUID */
NSString *RandomUUID();
/** 
 “保持不变”的UUID
 @discussion  卸载App后再安装会发生变化
 */
NSString *UniqueUUID();
/** 随机的网络视频地址 */
NSString *RandomVideoUrl();
/** 随机长度的字符串 */
NSString *RandomLengthString(int maxLength);
/** 从url中获取指定的参数值 */
NSString *MYGetParamValueForKey(NSString *url, NSString *key);
/** 输入文本的处理 */
NSString *MYInputTextHandle(NSString *inputText);
/** Emoji表情符号过滤 */
NSString *MYEmojiFilter(NSString *string);
/**
 *  安全显示数字
 *
 *  @param numString   原数字字符串
 *  @param leftLength  左侧要替换为*的长度
 *  @param rightLength 右侧要替换为*的长度
 *
 *  @return 隐藏部分数字的字符串
 */
NSString *MYSecureNumber(NSString *numString, int leftLength, int rightLength);


/** 控制台日志打印 */
void MYBasicLog(NSString *module, const char *file, const int line, id format, ...);



@end
