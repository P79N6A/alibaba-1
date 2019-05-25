//
//  WHYFoundationKitMacros.h
//  WHYFoundationKit
//
//  Created by JackAndney on 2017/5/14.
//  Copyright © 2017年 Creatoo. All rights reserved.
//

#ifndef WHYFoundationKitMacros_h
#define WHYFoundationKitMacros_h


#import "WHYSdkConfiguration.h"
#import "ToolClass.h"

// 是否为模拟器环境
#if TARGET_IPHONE_SIMULATOR
#define SIMULATOR_TEST 1
#else
#define SIMULATOR_TEST 0
#endif



/******************************************* Private Data  Begin ******************************************************/

#define MD5_PRIVATEKEY              @"fb_wenhuayun"
#define DEFAULTKEY_USER_FIRST_VISIT @"why_user_first_visit"


/******************************************* Private Data  End ******************************************************/


#define DATABASE_PATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"culture_dongli.db"]

#define kHttpTimeOutDuration 15
#define kPageSize  20 // 每页请求的数据条数

#define WS(weakSelf)   __weak __typeof(self) weakSelf = self;
#define SS(strongSelf) __strong __typeof(self) strongSelf = weakSelf;



// String转换
#define StrFromBool(boolValue)       [NSString stringWithFormat:@"%d",(boolValue) ? 1 : 0]
#define StrFromInt(intValue)         [NSString stringWithFormat:@"%d",(int)(intValue)]
#define StrFromLong(longValue)       [NSString stringWithFormat:@"%lld",(long long)(longValue)]
#define StrFromDouble(doubleValue)   [NSString stringWithFormat:@"%lf",(double)(doubleValue)]
#define StrFromFloat(floatValue)     [NSString stringWithFormat:@"%f",(float)(floatValue)]
#define StrForCoordinate(floatValue) [NSString stringWithFormat:@"%.4f",(float)(floatValue)]

// 设置缓存数据的有效期
#define CACHE_VALID_TIME_FOR_REALTIME 60*10 // http实时请求失败后获取缓存数据的有效生存时间，秒为单位
#define CACHE_VALID_TIME_SHORT        60*1// http请求数据的短的缓存生存时间，秒为单位  60*1
#define CACHE_VALID_TIME_LONG         60*30 // http请求数据的长的缓存生存时间，秒为单位



#define WHYSDKLog(fmt, ...) \
if ([WHYSdkConfiguration canPrintLog]) MYBasicLog(@"WHYSDKLog", __FILE__, __LINE__, fmt, ##__VA_ARGS__)




#endif /* WHYFoundationKitMacros_h */
