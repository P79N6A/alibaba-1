//
//  NSDictionary+SDKExtensions.h
//  WHYFoundationKit
//
//  Created by JackAndney on 2017/5/14.
//  Copyright © 2017年 Creatoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CGBase.h>


@interface NSDictionary (SDKExtensions)

- (BOOL)safeBoolForKey:(NSString *)key;
- (BOOL)safeBoolForKeyPath:(NSString *)keyPath;

- (int)safeIntForKey:(NSString *)key;
- (int)safeIntForKeyPath:(NSString *)keyPath;

- (NSInteger)safeIntegerForKey:(NSString *)key;
- (NSInteger)safeIntegerForKeyPath:(NSString *)keyPath;

- (double)safeDoubleForKey:(NSString *)key;
- (double)safeDoubleForKeyPath:(NSString *)keyPath;

- (CGFloat)safeFloatForKey:(NSString *)key;
- (CGFloat)safeFloatForKeyPath:(NSString *)keyPath;

- (NSDictionary *)safeDictForKey:(NSString *)key;
- (NSDictionary *)safeDictForKeyPath:(NSString *)keyPath;

- (NSString *)safeStringForKey:(NSString *)key;
- (NSString *)safeStringForKeyPath:(NSString *)keyPath;

- (NSArray *)safeArrayForKey:(NSString *)key;
- (NSArray *)safeArrayForKeyPath:(NSString *)keyPath;


- (NSInteger)safeStatusCodeForKey:(NSString *)key;// 状态码： 为空时，默认值为NSIntegerMax
- (NSString *)safeImgUrlForKey:(NSString *)key prefix:(NSString *)prefix; // 添加图片前缀

@end
