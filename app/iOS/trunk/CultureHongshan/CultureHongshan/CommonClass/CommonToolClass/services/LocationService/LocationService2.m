//
//  LocationService2.m
//  CultureShanghai
//
//  Created by JackAndney on 2017/12/4.
//  Copyright © 2017年 CT. All rights reserved.
//

#import "LocationService2.h"

 // 高德地图
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>


NSNotificationName const WHYLocationDidUpdateNotification = @"WHYLocationDidUpdateNotification";
NSNotificationName const WHYLocationDidFailNotification = @"WHYLocationDidFailNotification";
NSNotificationName const WHYLocationAuthStatusDidChangeNotification = @"WHYLocationAuthStatusDidChangeNotification";

#define WHY_LOCATION_ALERT_SHOW_TIME @"last_location_alert_show" // GPS定位弹窗提示时间记录

@interface LocationService2 () <AMapLocationManagerDelegate, CLLocationManagerDelegate>
{
    BOOL _singleLocating; // 是否定位一次
}
@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, strong) CLLocationManager *sysLocationManager;
@end



@implementation LocationService2


+ (instancetype)sharedService {
    static LocationService2 *service;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 配置高德地图Key
        [AMapServices sharedServices].apiKey = kAppKey_AMap;
        service = [[LocationService2 alloc] init];
    });
    return service;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        MYLocationModel *lastLocation = [LocationService2 getLastLocationFromDisk];
        if (lastLocation) {
            self.location = [lastLocation copy];
        }else {
            self.location = [MYLocationModel new];
        }
        
        self.status = MYLocationStatusDefault;
    }
    return self;
}

- (void)releaseLocationManager {
    if (_locationManager) {
        _locationManager.delegate = nil;
        [_locationManager stopUpdatingLocation];
        _locationManager = nil;
    }
}


#pragma mark - 定位开启 与 终止

// 开启单次定位请求
- (BOOL)beginOnceLocationWithCompletion:(void (^)(MYLocationModel *, NSString *))completionBlock {
    _singleLocating = YES;
    
    if (self.authStatus == kCLAuthorizationStatusDenied) {
        if (completionBlock) {
            if (self.status == MYLocationStatusSuccess) {
                completionBlock([self.location copy], nil); // 使用之前的位置信息
            }else {
                self.status = MYLocationStatusFailed;
                completionBlock(nil, @"定位权限被禁止，无法获取位置信息！");
            }
        }
        return YES;
    }
   
    if (self.status == MYLocationStatusInProgress) {
        return NO; // 已经在定位中，不再开启新的定位
    }
    
    [self releaseLocationManager];
    
    // 带逆地理的单次定位
    WS(weakSelf)
    self.status = MYLocationStatusInProgress;
    
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (error) {
            weakSelf.status = MYLocationStatusFailed;
            
            NSString *errorInfo = [weakSelf errorDescriptionForLocationError:error];

            FBLOG(@"定位失败： %@", errorInfo);
            if (completionBlock) {
                completionBlock(nil, errorInfo);
            }
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2*60 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[LocationService2 sharedService] beginLocation];
            });
            
            return;
        }
        
        // 定位成功
        weakSelf.status = MYLocationStatusSuccess;
        
        [weakSelf m_updateLocation:[location copy] andReGeocode:[regeocode copy]];
        
        if (completionBlock) {
            completionBlock([weakSelf.location copy], nil);
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2*60 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[LocationService2 sharedService] beginLocation];
        });
        
        FBLOG(@"定位成功：%@", weakSelf.location);
    }];
    
    return YES;
}

// 开启持续定位
- (BOOL)beginLocation {
    if (self.status == MYLocationStatusInProgress) {
        return NO; // 已经在定位中，不再开启新的定位
    }
    
    [self releaseLocationManager];
    _singleLocating = NO;
    
    self.status = MYLocationStatusInProgress;
    [self.locationManager startUpdatingLocation];
    
    return YES;
}

- (void)stopLocation {
    [self releaseLocationManager];
}


#pragma mark - ————————————— 代理方法 —————————————

// 位置更新
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode {
    [self m_updateLocation:[location copy] andReGeocode:[reGeocode copy]];
    [[NSNotificationCenter defaultCenter] postNotificationName:WHYLocationDidUpdateNotification object:[self.location copy]];
    FBLOG(@"连续定位位置更新： %@", self.location);
}

- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error {
    self.status = MYLocationStatusFailed;
    NSString *errorInfo = [self errorDescriptionForLocationError:error];
    [[NSNotificationCenter defaultCenter] postNotificationName:WHYLocationDidFailNotification object:errorInfo];
    FBLOG(@"连续定位失败：%@", errorInfo);
}

// 定位授权状态变更
- (void)amapLocationManager:(AMapLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    [[NSNotificationCenter defaultCenter] postNotificationName:WHYLocationAuthStatusDidChangeNotification object:[NSNumber numberWithInt:status]];
}

// 系统的代理方法
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusNotDetermined) {
        return;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:WHYLocationAuthStatusDidChangeNotification object:[NSNumber numberWithInt:status]];
    if (self.sysLocationManager) {
        self.sysLocationManager.delegate = nil;
        self.sysLocationManager = nil;
    }
}

#pragma mark -

// 位置信息更新
- (void)m_updateLocation:(CLLocation *)location andReGeocode:(AMapLocationReGeocode *)regeocode {
    if (location) {
        self.location.location = location;
    }
    if (regeocode) {
        self.location.formattedAddress = regeocode.formattedAddress;
        self.location.country = regeocode.country;
        self.location.province = regeocode.province;
        self.location.city = regeocode.city;
        self.location.district = regeocode.district;
        self.location.cityCode = regeocode.citycode;
        self.location.adCode = regeocode.adcode;
        self.location.street = regeocode.street;
        self.location.number = regeocode.number;
        self.location.POIName = regeocode.POIName;
        self.location.AOIName = regeocode.AOIName;
    }
    
    [LocationService2 saveCurrentLocation:self.location];
}

/** 保存GPS位置 */
+ (void)saveCurrentLocation:(MYLocationModel *)location {
    if (location) {
        [MYLocationModel archiveObject:location forPath:kUserLastGPSLocationPath];
    }else {
        [FileService removeFileAtPathOrURL:kUserLastGPSLocationPath error:nil];
    }
}

/** 获取本地保存的GPS位置 */
+ (MYLocationModel *)getLastLocationFromDisk {
    MYLocationModel *place = [MYLocationModel unarchiveObjectForPath:kUserLastGPSLocationPath];
    if (place && [place isKindOfClass:[MYLocationModel class]]) {
        return place;
    }
    return nil;
}


// 定位错误信息
- (NSString *)errorDescriptionForLocationError:(NSError *)error {
    NSString *errorInfo = nil;
    if ([error.domain isEqualToString:AMapLocationErrorDomain]) {
        if (error.code == AMapLocationErrorUnknown) errorInfo = @"定位出现未知错误";
        else if (error.code == AMapLocationErrorLocateFailed) errorInfo = @"定位失败";
        else if (error.code == AMapLocationErrorReGeocodeFailed) errorInfo = @"获取逆地理编码信息失败";
        else if (error.code == AMapLocationErrorTimeOut) errorInfo = @"获取定位信息超时";
        else if (error.code == AMapLocationErrorCanceled) errorInfo = @"定位已取消";
        else if (error.code == AMapLocationErrorCannotFindHost) errorInfo = @"定位时找不到远程主机";
        else if (error.code == AMapLocationErrorBadURL) errorInfo = @"定位URL异常";
        else if (error.code == AMapLocationErrorNotConnectedToInternet) errorInfo = @"网络连接已断开，无法进行定位";
        else if (error.code == AMapLocationErrorCannotConnectToHost) errorInfo = @"服务器连接失败，无法定位";
        else if (error.code == AMapLocationErrorRegionMonitoringFailure) errorInfo = @"地理围栏错误";
        else {
            errorInfo = [error.localizedDescription copy];
        }
    }else {
        errorInfo = [error.localizedDescription copy];
    }
    
    return errorInfo;
}


#pragma mark -

+ (BOOL)isAllowLocating {
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        return YES;
    }
    
    return NO;
}

+ (void)requestWhenInUseAuthorization {
    // 必须声明
    CLLocationManager *m = [[CLLocationManager alloc] init];
    m.delegate = [LocationService2 sharedService];
    [LocationService2 sharedService].sysLocationManager = m;
    [m requestWhenInUseAuthorization];
}

+ (void)requestAlwaysAuthorization {
    CLLocationManager *m = [[CLLocationManager alloc] init];
    m.delegate = [LocationService2 sharedService];
    [LocationService2 sharedService].sysLocationManager = m;
    [m requestAlwaysAuthorization];
}

// 跳转系统定位设置
+ (void)openSystemLocationSetting {
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        if (IOS_VERSION_GREATER_OR_EQUAL(10.0)) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        }else {
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}


#pragma mark - 其它方法

// 当天是否要再次弹窗提示
+ (BOOL)canShowAlertAtToday {
    NSString *dateString = [DateTool dateStringForDate:[NSDate date]];
    NSString *lastAlertDate = [ToolClass getDefaultValue:WHY_LOCATION_ALERT_SHOW_TIME];
    
    if (lastAlertDate.length > 0 && dateString.length > 0) {
        if ([dateString isEqualToString:lastAlertDate]) {
            return NO;
        }
    }
    return YES;
}

// 弹窗提示后更新此状态
+ (void)updateShowAlertStatus {
    NSString *dateString = [DateTool dateStringForDate:[NSDate date]];
    [ToolClass setDefaultValue:dateString forKey:WHY_LOCATION_ALERT_SHOW_TIME];
}



#pragma mark - Property Getters And Setters

- (AMapLocationManager *)locationManager {
    if (_locationManager == nil) {
        // 配置高德地图Key
        [AMapServices sharedServices].apiKey = kAppKey_AMap;
        
        self.status = MYLocationStatusDefault;
        _locationManager.delegate = self;
        
        _locationManager = [[AMapLocationManager alloc] init];
        
        if (_singleLocating) {
            _locationManager.locationTimeout = 8;
            _locationManager.reGeocodeTimeout = 4;
            _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 精度低一些，可以快速定位到位置
        }else {
            _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
            _locationManager.distanceFilter = 150.0f;
            _locationManager.locationTimeout = 10;
            _locationManager.reGeocodeTimeout = 5;
            _locationManager.locatingWithReGeocode = YES;
            
            // 设置不允许系统暂停定位
            [_locationManager setPausesLocationUpdatesAutomatically:NO];
        }
    }
    return _locationManager;
}


- (void)setStatus:(MYLocationStatus)status {
    if (status == MYLocationStatusFailed && _status == MYLocationStatusSuccess) {
        return;
    }
    _status = status;
}

- (CLAuthorizationStatus)authStatus {
    return [CLLocationManager authorizationStatus];
}

- (NSString *)latitudeStr {
    if (self.location.location) {
        return [NSString stringWithFormat:@"%.4f", self.location.location.coordinate.latitude];
    }else {
        return @"";
    }
}

- (NSString *)longitudeStr {
    if (self.location.location) {
        return [NSString stringWithFormat:@"%.4f", self.location.location.coordinate.longitude];
    }else {
        return @"";
    }
}

- (BOOL)havePosition {
    if (self.location.location) {
        if (self.location.location.coordinate.latitude > 0.01 && self.location.location.coordinate.longitude > 0.01) {
            return YES;
        }
    }
    return NO;
}

@end

