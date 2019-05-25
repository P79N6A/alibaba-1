//
//  NSString+SDKExtensions.h
//  WHYFoundationKit
//
//  Created by JackAndney on 2017/5/14.
//  Copyright © 2017年 Creatoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (SDKExtensions)

/** 字符串是否不为空 */
- (BOOL)isNotEmpty;
/** 是否包含某个字符串 */
- (BOOL)containsSubString:(NSString *)subString;
/** 是否为纯文本 */
- (BOOL)isPlainText;

/** 是否为有效的网络图片地址 */
- (BOOL)isValidImgUrl;

/** 指定字符串在该字符串中最后一次出现的位置 */
- (NSUInteger)lastLocationForString:(NSString *)string;

/**
 去除HTML标签元素
 
 @discussion  同时，也会去除所有的 空白字符 和 HTML转义字符
 */
- (NSString *)stringByTrimmingHTMLElements;

/** 去除两端的空白字符 */
- (NSString *)stringByTrimmingBlankCharacters;

/** Unicode字符处理 */
- (NSString *)stringByReplaceUnicode;

// 获取汉字、英文字符串的首个字符
- (NSString *)firstCapitalLetter;

@end





#pragma mark - TimeExtension


@interface NSString (TimeExtension)
/** 播放时长的显示 */
+ (NSString *)stringWithPlayTime:(NSTimeInterval)time;
/** 消息发布时间的显示 */
+ (NSString *)stringWithMsgTime:(NSTimeInterval)time;
@end
