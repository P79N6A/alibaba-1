//
//  CitySwitchModel.h
//  CultureHongshan
//
//  Created by ct on 16/11/24.
//  Copyright © 2016年 CT. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CityModel;


/**
省份Model
*/
@interface ProvinceModel : NSObject
@property (nonatomic, copy) NSString *provinceId; // 省份Id
@property (nonatomic, copy) NSString *provinceName;// 省份名字
@property (nonatomic, copy) NSString *provinceCapital;// 省份拼音首字母
@property (nonatomic, assign) BOOL isMunicipality;// 是否为直辖市
@property (nonatomic, strong) NSArray<CityModel *> *cityList;

+ (NSArray *)instanceArrayFromDictArray:(NSArray *)dicArray;

@end








/**
 城市Model
 */
@interface CityModel : NSObject <NSCoding, NSCopying>
@property (nonatomic, copy) NSString *cityId;
@property (nonatomic, copy) NSString *cityCode;// 城市代码
@property (nonatomic, copy) NSString *cityName;
@property (nonatomic, assign) BOOL isQuickSearch;// 是否为快速选择
@property (nonatomic, assign) BOOL isActivated;// 是否激活
/**
 *  城市的接口地址(旧平台)
 */
@property (nonatomic, copy) NSString *cityInterface;
/**
 *  城市的接口地址（新平台）
 */
@property (nonatomic, copy) NSString *cityInterfaceNew;

- (instancetype)initWithAttributes:(NSDictionary *)dict;
+ (NSArray *)instanceArrayFromDictArray:(NSArray *)dicArray;
@end



