//
//  ActivityGatherModel.m
//  CultureHongshan
//
//  Created by ct on 17/2/8.
//  Copyright © 2017年 CT. All rights reserved.
//

#import "ActivityGatherModel.h"
#import "ActivityModel.h"


@implementation ActivityGatherModel

- (instancetype)initWithAttributes:(NSDictionary *)dict {
    if (self = [super init]) {
        if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
            return nil;
        }
        /*
         
         
         "gatherEndDate":"2017-02-19",
            "gatherPrice":"380/280/180元",
            "gatherName":"写给你的爱情音乐剧《撒娇女王》",
            "gatherAddressLat":null,
            "gatherMovieTime":"",
            "gatherCreateTime":{
                "date":19,
                "day":4,
                "hours":14,
                "minutes":36,
                "month":0,
                "seconds":19,
                "time":1484807779000,
                "timezoneOffset":-480,
                "year":117
            },
            "gatherUpdateUser":null,
            "gatherTag":"演出",
            "gatherType":6,
            "gatherStatus":1,
            "type":2,
            "gatherMovieActor":"",
            "gatherId":"bad5a246b52848768bd39518f9003389",
            "gatherImg":"admin/45/201701/Img/Img7685137830ee4f2d9223895a7a16b952.jpg",
            "gatherAddress":"人民大道300号 上海大剧院",
            "gatherHost":"上海话剧艺术中心",
            "gatherTime":"2017年1月20日-2月19日 19:30（1.25-30日 & 2.6、13日休息）",
            "gatherAddressLon":null,
            "gatherUpdateTime":{
                "date":25,
                "day":3,
                "hours":13,
                "minutes":41,
                "month":0,
                "seconds":6,
                "time":1485322866000,
                "timezoneOffset":-480,
                "year":117
            },
            "gatherStartDate":"2017-01-20",
            "gatherMovieDirector":"",
            "gatherCreateUser":null,
            "gatherGrade":"A",
            "gatherMovieType":"",
            "collectNum":1
         
         
         */
        self.gatherId            = [dict safeStringForKey:@"gatherId"];
        self.gatherType          = MYServerGatherTypeHandle([dict safeIntegerForKey:@"gatherType"]);
        self.gatherTitle         = [dict safeStringForKey:@"gatherName"];
        self.gatherIconUrl       = [dict safeImgUrlForKey:@"gatherImg"];
        self.gatherLink          = [dict safeStringForKey:@"gatherLink"];

        self.gatherMovieType     = [dict safeStringForKey:@"gatherMovieType"];
        self.gatherMovieTime     = [dict safeStringForKey:@"gatherMovieTime"];
        self.gatherMovieActor    = [dict safeStringForKey:@"gatherMovieActor"];
        self.gatherMovieDirector = [dict safeStringForKey:@"gatherMovieDirector"];

        self.gatherAddress       = [dict safeStringForKey:@"gatherAddress"];
        self.gatherHost          = [dict safeStringForKey:@"gatherHost"];
        self.gatherPrice         = [dict safeStringForKey:@"gatherPrice"];
        
        
        NSString *startTime = [dict safeStringForKey:@"gatherStartDate"];
        if (startTime.length == 10) {
            startTime = [[startTime substringWithRange:NSMakeRange(5, 5)] stringByReplacingOccurrencesOfString:@"-" withString:@"."];
        }
        NSString *endTime = [dict safeStringForKey:@"gatherEndDate"];
        if (endTime.length == 10) {
            endTime = [[endTime substringWithRange:NSMakeRange(5, 5)] stringByReplacingOccurrencesOfString:@"-" withString:@"."];
        }
        NSString *joinedTime = startTime;
        if (endTime.length && ![startTime isEqualToString:endTime]) {
            joinedTime = [NSString stringWithFormat:@"%@-%@", startTime, endTime];
        }
        
        self.gatherTime = [NSString stringWithFormat:@"%@  %@", joinedTime, [dict safeStringForKey:@"gatherTime"]];
        

        self.gatherIsCollect = [dict safeIntegerForKey:@"collectNum"] > 0;
    }
    return self;
}

- (NSArray *)handleCalemdarListShowDataArray {
    if (self.listArray.count) {
        return self.listArray;
    }
    
    NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:0];
    
    if (self.gatherType == ActivityGatherTypeReyingYingpian) {
        if (self.gatherMovieType.length) {
            [tmpArray addObject:@[@"icon_gather_movie_type", self.gatherMovieType]];
        }
        if (self.gatherMovieTime.length) {
            [tmpArray addObject:@[@"icon_gather_movie_time", self.gatherMovieTime]];
        }
        if (self.gatherMovieActor.length) {
            [tmpArray addObject:@[@"icon_gather_movie_actor", self.gatherMovieActor]];
        }
        if (self.gatherMovieDirector.length) {
            [tmpArray addObject:@[@"icon_gather_movie_director", self.gatherMovieDirector]];
        }
    }else {
        if (self.gatherAddress.length) {
            [tmpArray addObject:@[@"icon_gather_other_address", self.gatherAddress]];
        }
        if (self.gatherHost.length) {
            [tmpArray addObject:@[@"icon_gather_other_host", self.gatherHost]];
        }
        if (self.gatherTime.length) {
            [tmpArray addObject:@[@"icon_gather_other_time", self.gatherTime]];
        }
        if (self.gatherPrice.length) {
            [tmpArray addObject:@[@"icon_gather_other_price", self.gatherPrice]];
        }
    }
    
    self.listArray = tmpArray;
    
    return tmpArray;
}


+ (NSArray *)instanceArrayFromDictArray:(NSArray *)dicArray
{
    if (!dicArray || ![dicArray isKindOfClass:[NSArray class]])  {
        return @[];
    }
    
    NSMutableArray *instanceArray = [NSMutableArray array];
    for (NSDictionary *instanceDic in dicArray)  {
        
        NSInteger type = [[instanceDic valueForKey:@"type"] integerValue];
        if (type == 1) {
            ActivityModel *model = [[ActivityModel alloc] initWithAttributes:instanceDic];
            if (model) {
                [instanceArray addObject:model];
            }
        }else if (type == 2) {
            ActivityGatherModel *model = [[ActivityGatherModel alloc] initWithAttributes:instanceDic];
            if (model) {
                [instanceArray addObject:model];
            }
        }
    }
    return [NSArray arrayWithArray:instanceArray];
}



@end



/** 活动类型标签处理 */
NSString *MYActivityGatherTypeShowHandle(ActivityGatherType tagType) {
    switch (tagType) {
        case ActivityGatherTypeReyingYingpian:  return @"热映影片";
        case ActivityGatherTypeWutaiYanchu:     return @"舞台演出";
        case ActivityGatherTypeMeishuZhanlan:   return @"美术展览";
        case ActivityGatherTypeYinyuehui:       return @"音乐会";
        case ActivityGatherTypeYanchanghui:     return @"演唱会";
        case ActivityGatherTypeWudao:           return @"舞蹈";
        case ActivityGatherTypeHuajuGeju:       return @"话剧歌剧";
        case ActivityGatherTypeXiquQuyi:        return @"戏曲曲艺";
        case ActivityGatherTypeErtongju:        return @"儿童剧";
        case ActivityGatherTypeZajiMoshu:       return @"杂技魔术";
            
        default:
            break;
    }
    
    return @"";
}

ActivityGatherType MYServerGatherTypeHandle(NSInteger type) {
    switch (type) {
        case 0: return ActivityGatherTypeReyingYingpian;
        case 1: return ActivityGatherTypeWutaiYanchu;
        case 2: return ActivityGatherTypeMeishuZhanlan;
        case 3: return ActivityGatherTypeYinyuehui;
        case 4: return ActivityGatherTypeYanchanghui;
        case 5: return ActivityGatherTypeWudao;
        case 6: return ActivityGatherTypeHuajuGeju;
        case 7: return ActivityGatherTypeXiquQuyi;
        case 8: return ActivityGatherTypeErtongju;
        case 9: return ActivityGatherTypeZajiMoshu;
            
        default:
            break;
    }
    return ActivityGatherTypeUnknown;
}

UIColor *MYActivityGatherTypeColorHandle(ActivityGatherType tagType) {
    switch (tagType) {
        case ActivityGatherTypeReyingYingpian:  return RGB(0x96, 0xc2, 0xdb); // 96c2db
        case ActivityGatherTypeWutaiYanchu:     return RGB(0xae, 0xc1, 0xcf); // aec1cf
        case ActivityGatherTypeMeishuZhanlan:   return RGB(0x7d, 0xb3, 0xcf); // 7db3cf
        case ActivityGatherTypeYinyuehui:       return RGB(0x93, 0x9f, 0xdb); // 939fdb
        case ActivityGatherTypeYanchanghui:     return RGB(0xaa, 0xa1, 0xd0); // aaa1d0
        case ActivityGatherTypeWudao:           return RGB(0xaf, 0xb7, 0xe5); // afb7e5
        case ActivityGatherTypeHuajuGeju:       return RGB(0xa4, 0xac, 0xd0); // a4acd0
        case ActivityGatherTypeXiquQuyi:        return RGB(0xad, 0xb1, 0xca); // adb1ca
        case ActivityGatherTypeErtongju:        return RGB(0xa9, 0xc7, 0xeb); // a9c7eb
        case ActivityGatherTypeZajiMoshu:       return RGB(0x85, 0x8e, 0xaf); // 858eaf
            
        default:
            break;
    }
    
    return RGB(204, 177, 114);
}

