//
//  NSObject+Log.h
//  WHYFoundationKit
//
//  Created by JackAndney on 2017/5/14.
//  Copyright © 2017年 Creatoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Log)

- (NSString *)my_description;

/** 是否为自定义类 */
- (BOOL)isCustomClass;
- (NSString *)customClassDescription;


/**
 Model对象转Json字符串

 @return JSON字符串
 */
- (NSString *)toJsonString; // 如果对象本身不是Json对象，则返回的也不是Json字符串




@end
