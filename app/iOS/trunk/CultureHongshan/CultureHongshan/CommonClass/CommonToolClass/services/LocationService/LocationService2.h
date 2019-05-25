//
//  LocationService2.h
//  CultureShanghai
//
//  Created by JackAndney on 2017/12/4.
//  Copyright © 2017年 CT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "LocationServiceTypeDefines.h"
#import "MYLocationModel.h"

UIKIT_EXTERN NSNotificationName const WHYLocationDidUpdateNotification; // 位置更新通知
UIKIT_EXTERN NSNotificationName const WHYLocationDidFailNotification; // 位置获取失败通知
UIKIT_EXTERN NSNotificationName const WHYLocationAuthStatusDidChangeNotification; // 位置授权状态变化

@interface LocationService2 : NSObject
@property (nonatomic, assign, readonly) BOOL singleLocating; // 是否单次定位
@property (nonatomic, assign, readonly) BOOL havePosition; // 是否已获取到位置
@property (nonatomic, assign, readonly) CLAuthorizationStatus authStatus; // 定位授权状态
@property (nonatomic, assign) MYLocationStatus status;
@property (nonatomic, strong) MYLocationModel *location;
/** 纬度字符串（精确到小数点后4位） */
@property (nonatomic, readonly) NSString *latitudeStr;
/** 经度字符串（精确到小数点后4位）  */
@property (nonatomic, readonly) NSString *longitudeStr;


+ (instancetype)sharedService;


#pragma mark - 定位开启 与 终止

/**
 开启单次定位请求，用时大约0.6s

 @param completionBlock 定位结果回调
 */
- (BOOL)beginOnceLocationWithCompletion:(void(^)(MYLocationModel *location, NSString *errorMsg))completionBlock;

/** 开启持续定位 */
- (BOOL)beginLocation;

/** 停止所有的定位 */
- (void)stopLocation;

#pragma mark -

// 是否允许定位
+ (BOOL)isAllowLocating;

+ (void)requestWhenInUseAuthorization;
+ (void)requestAlwaysAuthorization;

+ (void)openSystemLocationSetting; // 跳转系统定位设置


#pragma mark - 其它方法


+ (BOOL)canShowAlertAtToday; // 当天是否要再次弹窗提示
+ (void)updateShowAlertStatus; // 弹窗提示后更新此状态





@end



