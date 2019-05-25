//
//  ProtocolBased.m
//  CultureHongshan
//
//  Created by Simba on 15/7/8.
//  Copyright (c) 2015年 Sun3d. All rights reserved.
//

#import "ProtocolBased.h"

#import "AppProtocolMacros.h"
#import "WHYHttpRequest.h"
#import "LocationService2.h"

#import <sys/utsname.h>


static NSInteger countOfRequesting; // 正在请求的个数

#define DICT_PARAMS_DECLARE  NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];

#define SAFE_SET_VALUE(value, key) \
if (value && value.length) { [params setValue:value forKey:key]; }

#define __REQUEST_ERROR__(msg) \
if (httpResponseBlock) { httpResponseBlock(HttpResponseError, ( msg && [msg length]) ? msg : @"连接超时或网络连接出错，请稍后再试!"); }\
return;\


@implementation ProtocolBased

+ (void)load {
    countOfRequesting = 0;
}


#pragma mark - ———————————————————————— 新的请求 ————————————————————————

+ (void)requestGetWithParameters:(NSDictionary *)parameterDic protocolString:(NSString *)protocolString cacheMode:(EnumCacheMode)cacheMode UsingBlock:(HttpResponseBlock)httpResponseBlock {
    [self requestWithParameters:parameterDic method:HttpMethodGet protocolString:protocolString cacheMode:cacheMode UsingBlock:httpResponseBlock];
}

+ (void)requestPostWithParameters:(NSDictionary *)parameterDic protocolString:(NSString *)protocolString cacheMode:(EnumCacheMode)cacheMode UsingBlock:(HttpResponseBlock)httpResponseBlock {
    [self requestWithParameters:parameterDic method:HttpMethodPost protocolString:protocolString cacheMode:cacheMode UsingBlock:httpResponseBlock];
}

+ (void)requestPostWithJsonParameters:(NSDictionary *)parameterDic protocolString:(NSString *)protocolString cacheMode:(EnumCacheMode)cacheMode UsingBlock:(HttpResponseBlock)httpResponseBlock {
    [self requestWithParameters:parameterDic method:HttpMethodPostForJSON protocolString:protocolString cacheMode:cacheMode UsingBlock:httpResponseBlock];
}

#pragma mark -

+ (void)requestWithParameters:(NSDictionary *)parameterDic method:(HttpMethod)method protocolString:(NSString *)protocolString cacheMode:(EnumCacheMode)cacheMode UsingBlock:(HttpResponseBlock)httpResponseBlock {
    // 设置缓存策略
    if (cacheMode < CACHE_MODE_NOCACHE) {
        cacheMode = CACHE_MODE_HALFREALTIME_LONG;
    }
    
    // 请求URL处理
    NSString *url = @"";
    if ([protocolString hasPrefix:@"http"]) {
        url = [protocolString copy];
    }else {
        if ([[parameterDic objectForKey:kFixedProtocolKey] intValue] > 0) {
            if (method == HttpMethodPostForJSON) {
                url = [NSString stringWithFormat:@"%@%@", kProtocolNewFixedUrl, protocolString];
            }else {
                url = [NSString stringWithFormat:@"%@%@", kProtocolFixedUrl, protocolString];
            }
        }else {
            if (method == HttpMethodPostForJSON) {
                url = [NSString stringWithFormat:@"%@%@", kProtocolNewUrl, protocolString];
            }else {
                url = [NSString stringWithFormat:@"%@%@", kProtocolUrl, protocolString];
            }
        }
    }
    
    if ([parameterDic objectForKey:kFixedProtocolKey]) {
        NSMutableDictionary *tmpDict = [NSMutableDictionary dictionaryWithDictionary:parameterDic];
        [tmpDict removeObjectForKey:kFixedProtocolKey];
        parameterDic = tmpDict;
    }
    
    
    NSString *requestId = nil;
    if (cacheMode != CACHE_MODE_NOCACHE) {
        requestId = [self getRequestId:url params:parameterDic];
        
        if (cacheMode > CACHE_MODE_REALTIME) {
            // 非实时请求的情况下，优先使用缓存数据
            NSObject *cacheData = [self queryCacheData:requestId cacheMode:cacheMode];
            if (cacheData != nil) {
                // 使用缓存数据
                if (httpResponseBlock) {
                    httpResponseBlock(HttpResponseSuccess, cacheData);
                }
                return;
            }
        }
    }
    
    WHYHttpRequest *request = [WHYHttpRequest requestBuildWithURL:url method:method params:parameterDic requestHeaders:[self requestHeaderParams] delegate:nil withTag:nil];
    request.serializationType = HttpResponseSerializationTypeJson;
    request.completionHandler = ^(WHYHttpRequest *request, id responseData, NSError *error) {
        // 切换到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            countOfRequesting--;
            if (countOfRequesting <= 0) {
                countOfRequesting = 0;
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            }
            
            if (responseData) {
#ifdef LOG_REQUEST_RESULT
                NSMutableString *requestUrl = [[NSMutableString alloc] initWithFormat:@"%@?", url];
                if (method == HttpMethodPostForJSON) {
                    [requestUrl appendString:[JsonTool jsonStringFromJsonObject:parameterDic]];
                }else {
                    [requestUrl appendString:WHYHttpRequestParamHandle(parameterDic)];
                }
                NSLog(@"请求URL:  %@\n\n返回结果：\n %@", requestUrl, responseData);
#endif

                if (([responseData isKindOfClass:[NSDictionary class]] && [responseData count] > 0) ||
                    ([responseData isKindOfClass:[NSArray class]])
                    ) {
                    
                    if (httpResponseBlock) { httpResponseBlock(HttpResponseSuccess, responseData); }
                    // 添加到缓存
                    if (requestId.length > 0) { [ProtocolBased addCacheData:requestId content:responseData]; }
                    
                }else {
                    if (httpResponseBlock) { httpResponseBlock(HttpResponseNoDataError, @"返回的数据为空!"); }
                    return;
                }
                
            }else {
                // 考虑使用缓存数据
                if (requestId.length > 0) {
                    if (error.code == NSURLErrorTimedOut || error.code == NSURLErrorNetworkConnectionLost || error.code == NSURLErrorNotConnectedToInternet) {
                        // 网络失败等情况下，直接使用可能的缓存数据
                        NSObject *cacheData = [ProtocolBased queryCacheData:requestId cacheMode:CACHE_MODE_ALLCACHE];
                        if (cacheData != nil) {
                            if (httpResponseBlock) { httpResponseBlock(HttpResponseSuccess, cacheData); }
                            return;
                        }
                    }else {
                        // 请求失败，可以使用缓存的情况下，使用指定有效期内的缓存
                        NSObject *cacheData = [ProtocolBased queryCacheData:requestId cacheMode:CACHE_MODE_HALFREALTIME_LONG];
                        if (cacheData != nil) {
                            if (httpResponseBlock) { httpResponseBlock(HttpResponseSuccess, cacheData); }
                            return;
                        }
                    }
                }
                
                HttpResponseCode code = HttpResponseError;
                if ([error.domain isEqualToString:WHYHttpJsonFormatError]) {
                    code = HttpResponseFormatError;
                }else if ([error.domain isEqualToString:WHYHttpParamError]) {
                    code = HttpResponseParamError;
                }else if ([error.domain isEqualToString:WHYHttpResponseNoDataError]) {
                    code = HttpResponseNoDataError;
                }else {
                    if (error.code == NSURLErrorTimedOut || error.code == NSURLErrorNetworkConnectionLost || error.code == NSURLErrorNotConnectedToInternet) {
                        code = HttpResponseNetworkError;
                    }else {
                        code = HttpResponseError;
                    }
                }
                
                NSString *errorInfo = WHYHttpRequestErrorDescription(error);
                if (httpResponseBlock) { httpResponseBlock(code, errorInfo); }
            }
        });
    };
    
    if (countOfRequesting == 0) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    }
    countOfRequesting++;
    
    [request startRequest];
    
    [self statQuery:url params:parameterDic result:1];
}


// 文化云上传图片文件
+ (void)uploadFileWithType:(FileUploadType)type image:(UIImage *)image dataId:(NSString *)dataId progressBlock:(void (^)(CGFloat))progressBlock responseBlock:(HttpResponseBlock)httpResponseBlock {
    
    NSString *userId = [UserService sharedService].userId;
    if (userId.length < 1) {
        if (httpResponseBlock) {
            httpResponseBlock(HttpResponseError, @"用户未登录，无法上传文件!");
        }
        return;
    }
    
    
    if (countOfRequesting == 0) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    }
    countOfRequesting++;
    
    NSString *uploadType = @"";// 上传类型
    NSString *modelType = @""; // 模块类型
    NSData *imageData = nil;
    
    switch (type) {
        case FileUploadTypeUserHeaderImage:{// 上传头像
            uploadType = @"2";
            modelType  = @"2";
            imageData  = [image imageDataLimitWithMaxPixel:1000 maxByte:kPictureMaxByte];
        }
            break;
        case FileUploadTypeUserFeedbackImage:{// 用户反馈
            uploadType = @"1";
            modelType  = @"3";
            imageData  = [image imageDataLimitWithMaxPixel:kPictureMaxPixel maxByte:kPictureMaxByte];
        }
            break;
        case FileUploadTypeActivityCommentImage:
        case FileUploadTypeVenueCommentImage: { // 活动、场馆评论
            uploadType = @"1";
            modelType  = @"3";
            imageData  = [image imageDataLimitWithMaxPixel:kPictureMaxPixel maxByte:kPictureMaxByte];
        }
            break;
        default:
            break;
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
    if (userId.length) { [params setValue:userId forKey:@"userId"]; }
    if (uploadType.length) { [params setValue:uploadType forKey:@"uploadType"]; }
    if (modelType.length) { [params setValue:modelType forKey:@"modelType"]; }
    if (dataId.length) { [params setValue:dataId forKey:@"cemmentId"]; }
    [params setValue:APP_VERSION forKey:@"sysVersion"];
    
    
    NSString *url = [NSString stringWithFormat:@"%@%@", kProtocolUrl, kUploadAppFiles];
    
    [WHYHttpRequest requestFileUploadWithURL:url uploadObject:imageData imageUpload:YES params:params requestHeaders:[self requestHeaderParams] delegate:nil progressHandler:^(WHYHttpRequest *request, NSProgress *progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (progressBlock) {
                progressBlock(progress.fractionCompleted);
            }
        });
    } completionHandler:^(WHYHttpRequest *request, id responseData, NSError *error) {
        // 切换到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            countOfRequesting--;
            if (countOfRequesting <= 0) {
                countOfRequesting = 0;
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            }
            
            if (responseData) {
                if ([responseData isKindOfClass:[NSDictionary class]] && [responseData count] > 0) {
                    NSInteger statusCode = [responseData safeStatusCodeForKey:@"status"];
                    NSString *imgUrl = [responseData safeStringForKey:@"data"];
                    if (statusCode == 0) {
                        if ([imgUrl isValidImgUrl]) {
                            if (httpResponseBlock) httpResponseBlock(HttpResponseSuccess, imgUrl);
                            return;
                        }else {
                            if (httpResponseBlock) { httpResponseBlock(HttpResponseFormatError, @"图片链接返回错误！"); }
                        }
                    }else {
                        if (imgUrl.length == 0) imgUrl = @"图片上传失败！";
                        if (httpResponseBlock) { httpResponseBlock(HttpResponseError, imgUrl); }
                    }
                }else {
                    if (httpResponseBlock) { httpResponseBlock(HttpResponseFormatError, @"图片上传返回数据的格式不正确!"); }
                }
                
            }else {
                HttpResponseCode code = HttpResponseError;
                if ([error.domain isEqualToString:WHYHttpJsonFormatError]) {
                    code = HttpResponseFormatError;
                }else if ([error.domain isEqualToString:WHYHttpParamError]) {
                    code = HttpResponseParamError;
                }else if ([error.domain isEqualToString:WHYHttpResponseNoDataError]) {
                    code = HttpResponseNoDataError;
                }else {
                    if (error.code == NSURLErrorTimedOut || error.code == NSURLErrorNetworkConnectionLost || error.code == NSURLErrorNotConnectedToInternet) {
                        code = HttpResponseNetworkError;
                    }else {
                        code = HttpResponseError;
                    }
                }
                
                NSString *errorInfo = WHYHttpRequestErrorDescription(error);
                if (httpResponseBlock) { httpResponseBlock(code, errorInfo); }
            }
        });
    }];
}



#pragma mark -



+ (NSDictionary *)queryCacheData:(NSString *)requestId cacheMode:(EnumCacheMode)cacheMode {
    NSArray *results = [[CacheService shareInstance] getCache:requestId cacheMode:cacheMode];
    
    if (results != nil && results.count > 0) {
        NSString *content = [results[0] objectForKey:@"content"];
        NSData *jsonData = [content dataUsingEncoding:NSUTF8StringEncoding];
        id jsonObj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments|NSJSONReadingMutableLeaves error:nil];
        
        if ([jsonObj isKindOfClass:[NSDictionary class]] || [jsonObj isKindOfClass:[NSArray class]]) {
            return jsonObj;
        }
    }
    return nil;
}

+ (void)addCacheData:(NSString *)requestId content:(id)responseData {
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseData options:NSJSONWritingPrettyPrinted error:nil];

    NSString *content = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [[CacheService shareInstance] addCache:requestId content:content];
}


+ (NSString *)getRequestId:(NSString *)url params:(NSDictionary *)params {
    NSString *paramString =WHYHttpRequestParamHandle(params);
    NSString *md5 = [EncryptTool md5Encode:[NSString stringWithFormat:@"%@?%@", url, paramString]];
    return [NSString stringWithFormat:@"%@?key=%@", url, md5];
}


#pragma mark - ———————————————————————— END ————————————————————————

/**
 *  接口统计调用的方法
 */
+ (void)statQuery:(NSString *)url params:(NSDictionary *)params result:(int)result {
    if (DEBUG_MODE) return;
    if (![url hasPrefix:@"http"]) return;
    
    // 先判断url是否在允许统计的list里面
    NSArray *urlList = [DictionaryService allowStatisticsUrlList];
    
    if (urlList == nil || urlList.count == 0) return;
    
    // 判断是否在接口统计列表中
    BOOL allowStat = NO;
    for (NSString *protocolUrl  in urlList) {
        if([url rangeOfString:protocolUrl].location != NSNotFound) {
            allowStat = YES;
            break;
        }
    }
    
    if (!allowStat) return;
    
    // 获取数据Id（如：activityId、venueId）
    NSString *dataId = @"";
    for (NSString *key in params.allKeys) {
        if ([key isKindOfClass:[NSString class]] &&  [key hasSuffix:@"Id"] && ![@"userId" isEqualToString:key]) {
            id value = [params valueForKey:key];
            if ([value isKindOfClass:[NSString class]] && [value length] > 0) {
                dataId = value;
            }
            break;
        }
    }
    
    // 获取接口名
    NSString *interfaceName = @"";
    NSArray *pathComponents = [[[NSURL URLWithString:url] path] componentsSeparatedByString:@"/"];
    if (pathComponents.count > 0) {
        NSString *lastPath = [pathComponents lastObject];
        if (lastPath.length > 0) {
            if ([lastPath hasSuffix:@".do"]) {
                interfaceName = [lastPath substringToIndex:lastPath.length-3];
            }else {
                interfaceName = [lastPath copy];
            }
        }
    }
    
    NSString *queryString = WHYHttpRequestParamHandle(params);
    NSString *requestUrl = WHYHttpUrlParamJointHandle(url, queryString);
    requestUrl = [requestUrl stringByReplacingOccurrencesOfString:@"&" withString:@"~"];
    
    UserService *userInfo = [UserService sharedService];
    
    NSMutableString *statUrl = [[NSMutableString alloc] initWithString:@"http://www.wenhuayun.cn/stat/stat.jsp?"];
    [statUrl appendFormat:@"userid=%@&", userInfo.userId];
    [statUrl appendFormat:@"stype=%@&", interfaceName];
    [statUrl appendFormat:@"skey1=%@&", dataId];;
    [statUrl appendString:@"skey2=&"];
    [statUrl appendFormat:@"skey3=%.1f&", IOS_VERSION];
    [statUrl appendFormat:@"skey4=%@&", APP_VERSION];
    [statUrl appendFormat:@"GUID=%@&", [ToolClass getUUID]];
    [statUrl appendFormat:@"ostype=%@&platform=iphone&", APP_BUNDLE_ID];
    
    [statUrl appendFormat:@"localurl=%@&", requestUrl];
    
    [statUrl appendFormat:@"lat=%f&lont=%f&", [LocationService2 sharedService].location.location.coordinate.latitude, [LocationService2 sharedService].location.location.coordinate.longitude];
    [statUrl appendFormat:@"citycode=%@", CITY_AD_CODE];
    
    [WHYHttpRequest requestWithURL:statUrl method:HttpMethodGet params:nil requestHeaders:[self requestHeaderParams] withTag:nil completionHandler:nil];
}


+ (NSDictionary *)requestHeaderParams {
    NSMutableDictionary *tmpDict = [[NSMutableDictionary alloc] initWithCapacity:8];
    
    [tmpDict setValue:APP_VERSION forKey:@"sysVersion"];
    [tmpDict setValue:@"iphone" forKey:@"sysPlatform"];
    
    [tmpDict setValue:[UserService sharedService].userId forKey:@"sysUserId"];
    
    [tmpDict setValue:[NSString stringWithFormat:@"%.6f", [LocationService2 sharedService].location.location.coordinate.longitude] forKey:@"sysUserLon"];
    [tmpDict setValue:[NSString stringWithFormat:@"%.6f", [LocationService2 sharedService].location.location.coordinate.latitude] forKey:@"sysUserLat"];
    
    [tmpDict setValue:[[UIDevice currentDevice] systemVersion] forKey:@"osVersion"];
    [tmpDict setValue:[[UIDevice currentDevice] model] forKey:@"phoneModel"];
    [tmpDict setValue:[[UIDevice currentDevice] systemName] forKey:@"phoneName"];
    
    [tmpDict setValue:[MYDeviceMachineInfo() valueForKey:@"machine"] forKey:@"deviceModel"];
    [tmpDict setValue:[[UIDevice currentDevice] name] forKey:@"deviceUserName"];
    
    CGSize deviceSize = [UIScreen mainScreen].bounds.size;
    [tmpDict setValue:[NSNumber numberWithInt:deviceSize.width] forKey:@"deviceWidth"];
    [tmpDict setValue:[NSNumber numberWithInt:deviceSize.height] forKey:@"deviceHeight"];
    
    return tmpDict;
}

// 获取设备信息
NSDictionary *MYDeviceMachineInfo() {
    struct utsname systemInfo;
    uname(&systemInfo);
    
    NSMutableDictionary *deviceInfo = [[NSMutableDictionary alloc] initWithCapacity:5];
    
    [deviceInfo setValue:[NSString stringWithCString:systemInfo.sysname encoding:NSUTF8StringEncoding] forKey:@"sysname"];
    [deviceInfo setValue:[NSString stringWithCString:systemInfo.nodename encoding:NSUTF8StringEncoding] forKey:@"nodename"];
    [deviceInfo setValue:[NSString stringWithCString:systemInfo.release encoding:NSUTF8StringEncoding] forKey:@"release"];
    [deviceInfo setValue:[NSString stringWithCString:systemInfo.version encoding:NSUTF8StringEncoding] forKey:@"version"];
    [deviceInfo setValue:[NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding] forKey:@"machine"];
    
    return deviceInfo;
}


@end

