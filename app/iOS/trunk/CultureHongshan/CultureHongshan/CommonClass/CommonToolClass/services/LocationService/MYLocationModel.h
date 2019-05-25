//
//  MYLocationModel.h
//  CultureShanghai
//
//  Created by JackAndney on 2017/12/4.
//  Copyright © 2017年 CT. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 位置信息Model基类
 
 @discussion 注意：尽量不要再给该类添加新的属性
 */
@interface MYLocationModel : MYArchivedObject <NSCopying>

@property (nonatomic, copy) CLLocation *location; // 经纬度信息
@property (nonatomic, copy) NSString *formattedAddress; // 格式化地址
@property (nonatomic, copy) NSString *country; // 国家
@property (nonatomic, copy) NSString *province; // 省/直辖市
@property (nonatomic, copy) NSString *city; // 市
@property (nonatomic, copy) NSString *district; // 区

@property (nonatomic, copy) NSString *cityCode; // 城市编码
@property (nonatomic, copy) NSString *adCode; // 区域编码

@property (nonatomic, copy) NSString *street; // 街道名称
@property (nonatomic, copy) NSString *number; // 门牌号
@property (nonatomic, copy) NSString *POIName; // 兴趣点名称
@property (nonatomic, copy) NSString *AOIName; // 所属兴趣点名称

@end
