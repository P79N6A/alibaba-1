//
//  CitySwitchModel.m
//  CultureHongshan
//
//  Created by ct on 16/11/24.
//  Copyright © 2016年 CT. All rights reserved.
//

#import "CitySwitchModel.h"



@implementation ProvinceModel

- (instancetype)initWithAttributes:(NSDictionary *)dict {
    if (self = [super init]) {
        if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
            return nil;
        }
        
        self.provinceId = [dict safeStringForKey:@"cityId"];
        self.provinceName = [dict safeStringForKey:@"cityName"];
        self.cityList = [CityModel instanceArrayFromDictArray:[dict safeArrayForKey:@"cityList"]];
        
        self.provinceCapital = [[dict safeStringForKey:@"firstLetter"] uppercaseString];// 省份首字母
        if (self.provinceCapital.length < 1) {
            self.provinceCapital = [self.provinceName firstCapitalLetter];
        }
        self.isMunicipality = [ProvinceModel isMunicipality:self.provinceName];// 是否为直辖市
    }
    return self;
}

+ (NSArray *)instanceArrayFromDictArray:(NSArray *)dicArray
{
    if (!dicArray || ![dicArray isKindOfClass:[NSArray class]])  {
        return nil;
    }
    
    NSMutableArray *quickSearchArray = [NSMutableArray array];// 快速选择
    NSMutableArray *municipalityArray = [NSMutableArray array];// 直辖市
    NSMutableArray *otherArray = [NSMutableArray array];// 省份
    
    [quickSearchArray addObject:kChinaKey];
    
    for (NSDictionary *instanceDic in dicArray)  {
        ProvinceModel *model = [[ProvinceModel alloc] initWithAttributes:instanceDic];
        if (model) {
            if (model.isMunicipality && 0) {
//                if (model.cityList.count) {
//                    [municipalityArray addObject:model.cityList[0]];
//                }
            }else {
                [otherArray addObject:model];
            }
            
            //  快速选择
            for (CityModel *city in model.cityList) {
                if (city.isQuickSearch) {
                    [quickSearchArray addObject:city];
                }
            }
        }
    }
    if (otherArray.count > 1) {
        [otherArray sortUsingComparator:^NSComparisonResult(ProvinceModel *obj1, ProvinceModel *obj2) {
            return [obj1.provinceCapital compare:obj2.provinceCapital options:NSCaseInsensitiveSearch];
        }];
    }
    return @[quickSearchArray, municipalityArray, otherArray];
}

+ (BOOL)isMunicipality:(NSString *)provinceName {
    if ([provinceName isKindOfClass:[NSString class]] && provinceName.length) {
        NSString *regex = @"^(上海市?)|(天津市?)|(北京市?)|(重庆市?)$";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self matches %@", regex];
        return [predicate evaluateWithObject:provinceName];
    }
    return NO;
}

@end




@implementation CityModel

- (instancetype)initWithAttributes:(NSDictionary *)dict {
    if (self = [super init]) {
        if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
            return nil;
        }
        self.cityId = [dict safeStringForKey:@"cityId"];
        self.cityCode = [dict safeStringForKey:@"cityCode"];
        self.cityName = [dict safeStringForKey:@"cityName"];
        self.cityInterface = [dict safeStringForKey:@"pagePath"];
        self.cityInterfaceNew = [dict safeStringForKey:@"platformPath"];
        self.isQuickSearch = [dict safeIntegerForKey:@"isQuickSearch"] == 1;
        self.isActivated = [dict safeIntegerForKey:@"cityStatus"] == 1;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    CityModel *city = [[[self class] allocWithZone:zone] init];
    city.cityId           = _cityId;
    city.cityCode         = _cityCode;
    city.cityName         = _cityName;
    city.isQuickSearch    = _isQuickSearch;
    city.cityInterface    = _cityInterface;
    city.cityInterfaceNew = _cityInterfaceNew;
    city.isActivated      = _isActivated;
    
    return city;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.cityId forKey:@"cityId"];
    [aCoder encodeObject:self.cityCode forKey:@"cityCode"];
    [aCoder encodeObject:self.cityName forKey:@"cityName"];
    [aCoder encodeObject:self.cityInterface forKey:@"cityInterface"];
    [aCoder encodeObject:self.cityInterfaceNew forKey:@"cityInterfaceNew"];
    [aCoder encodeObject:[NSNumber numberWithBool:self.isQuickSearch] forKey:@"isQuickSearch"];
    [aCoder encodeObject:[NSNumber numberWithBool:self.isActivated] forKey:@"isActivated"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.cityId = [aDecoder decodeObjectForKey:@"cityId"];
        self.cityCode = [aDecoder decodeObjectForKey:@"cityCode"];
        self.cityName = [aDecoder decodeObjectForKey:@"cityName"];
        self.cityInterface = [aDecoder decodeObjectForKey:@"cityInterface"];
        self.cityInterfaceNew = [aDecoder decodeObjectForKey:@"cityInterfaceNew"];
        self.isQuickSearch = [[aDecoder decodeObjectForKey:@"isQuickSearch"] boolValue] == 1;
        self.isActivated = [[aDecoder decodeObjectForKey:@"isActivated"] boolValue] == 1;
    }
    return self;
}


+ (NSArray *)instanceArrayFromDictArray:(NSArray *)dicArray
{
    if (!dicArray || ![dicArray isKindOfClass:[NSArray class]])  {
        return @[];
    }
    
    NSMutableArray *instanceArray = [NSMutableArray array];
    for (NSDictionary *instanceDic in dicArray)  {
        CityModel *model = [[CityModel alloc] initWithAttributes:instanceDic];
        if (model) {
            [instanceArray addObject:model];
        }
    }
    return [NSArray arrayWithArray:instanceArray];
}

@end


