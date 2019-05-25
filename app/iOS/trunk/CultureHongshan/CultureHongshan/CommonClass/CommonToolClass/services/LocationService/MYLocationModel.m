//
//  MYLocationModel.m
//  CultureShanghai
//
//  Created by JackAndney on 2017/12/4.
//  Copyright © 2017年 CT. All rights reserved.
//

#import "MYLocationModel.h"
#import <objc/runtime.h>
#import <CoreLocation/CoreLocation.h>

@implementation MYLocationModel

- (id)copyWithZone:(NSZone *)zone {
    id model = [[[self class] allocWithZone:zone] init];
    if (model) {
        
        Class c = self.class;
        // 截取类和父类的成员变量
        while (c && c != [NSObject class]) {
            unsigned int count = 0;
            
            Ivar *ivars = class_copyIvarList(c, &count); // class_copyPropertyList   class_copyIvarList
            
            for (int i = 0; i < count; i++) {
                Ivar ivar = ivars[i];
                NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
                
                id value = [self valueForKey:key];
                if (value) {
                    if ([value conformsToProtocol:@protocol(NSCopying)]) {
                        [model setValue:[value copyWithZone:zone] forKey:key];
                    }else {
                        NSLog(@"该类<%@>未实现<NSCopying>协议", NSStringFromClass(c));
                        break;
                    }
                }
            }
            c = [c superclass];
            
            free(ivars); // 释放内存
        }
    }
    return model;
}


- (NSString *)description {
    NSMutableString *tmpString = [[NSMutableString alloc] initWithCapacity:10];
    [tmpString appendFormat:@"\n<%@: %p\n\t", [self class], self];
    if (self.location) {
        [tmpString appendFormat:@"经纬度：{%.6lf, %.6lf}\n\t", self.location.coordinate.latitude, self.location.coordinate.longitude];
        [tmpString appendFormat:@"海拔：%.2lfm\n\t", self.location.altitude];
        [tmpString appendFormat:@"精确度：{水平：%.2lf ，竖直：%.2lf}\n\t", self.location.horizontalAccuracy, self.location.verticalAccuracy];
        [tmpString appendFormat:@"方位：%.1f°\n\t", self.location.course];
        if (self.location.speed <= 1) {
            [tmpString appendFormat:@"移动速度：%.2fm/s\n\t", self.location.speed];
        }else {
            [tmpString appendFormat:@"移动速度：%.1fm/s\n\t", self.location.speed];
        }
        [tmpString appendFormat:@"时间戳：%@\n\t", self.location.timestamp];
    }
    
    if (self.formattedAddress.length) {
        [tmpString appendFormat:@"formattedAddress: %@\n\t", self.formattedAddress];
    }
    if (self.country.length) {
        [tmpString appendFormat:@"country: %@\n\t", self.country];
    }
    if (self.province.length) {
        [tmpString appendFormat:@"province: %@\n\t", self.province];
    }
    if (self.city.length) {
        [tmpString appendFormat:@"city: %@\n\t", self.city];
    }
    if (self.district.length) {
        [tmpString appendFormat:@"district: %@\n\t", self.district];
    }
    if (self.cityCode.length) {
        [tmpString appendFormat:@"cityCode: %@\n\t", self.cityCode];
    }
    if (self.adCode.length) {
        [tmpString appendFormat:@"adCode: %@\n\t", self.adCode];
    }
    if (self.street.length) {
        [tmpString appendFormat:@"street: %@\n\t", self.street];
    }
    if (self.number.length) {
        [tmpString appendFormat:@"number: %@\n\t", self.number];
    }
    if (self.POIName.length) {
        [tmpString appendFormat:@"POIName: %@\n\t", self.POIName];
    }
    if (self.AOIName.length) {
        [tmpString appendFormat:@"AOIName: %@\n", self.AOIName];
    }
    
    [tmpString appendString:@">"];
    
    return tmpString;
}


@end
