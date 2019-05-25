//
//  WHYSdkConfiguration.h
//  WHYFoundationKit
//
//  Created by JackAndney on 2017/5/14.
//  Copyright © 2017年 Creatoo. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  配置文件
 */
@interface WHYSdkConfiguration : NSObject

/** 是否开启打印Log, 默认为NO */
+ (void)setLogEnabled:(BOOL)enabled;

+ (BOOL)canPrintLog;

@end
