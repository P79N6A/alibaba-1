//
//  NSDictionary+Extensions.m
//  CultureHongshan
//
//  Created by Simba on 15/7/8.
//  Copyright (c) 2015年 Sun3d. All rights reserved.
//

#import "NSDictionary+Extensions.h"

@implementation NSDictionary (Extensions)

- (NSString *)safeImgUrlForKey:(NSString *)key
{
    NSString *value = [self valueForKey:key];
    if ([value isKindOfClass:[NSString class]]) {
        if (value.length) {
            if ([value hasPrefix:@"http"]) {
                return value;
            }else {
                NSString *imgUrlPrefix = [ToolClass getDefaultValue:kUserDefault_ImageUrlPrefix];
                if (imgUrlPrefix.length) {
                    return [NSString stringWithFormat:@"%@%@",imgUrlPrefix, value];
                }else{
                    return [NSString stringWithFormat:@"http://img1.wenhuayun.cn/%@", value];
                }
            }
        }
    }
    
    return @"";
}

@end
