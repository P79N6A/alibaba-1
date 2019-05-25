//
//  WHYHttpRequestTypeDefines.h
//  HttpServiceDemo
//
//  Created by JackAndney on 2017/7/31.
//  Copyright © 2017年 Creatoo. All rights reserved.
//

#ifndef WHYHttpRequestTypeDefines_h
#define WHYHttpRequestTypeDefines_h


//#define kHttpTimeOutDuration 15
#define HTTP_TIMEOUT_DURATION 15 // 默认请求超时时间


@class WHYHttpRequest;


#pragma mark - Block定义

/** 请求结果回调 */
typedef void (^WHYRequestResultHandler)(WHYHttpRequest *request, id responseData, NSError *error);


#pragma mark - 枚举变量定义


/** HTTP请求方法 */
typedef NS_ENUM(NSInteger, HttpMethod) {
    HttpMethodGet         = 10, // GET请求
    HttpMethodPost        = 20, // 常规POST请求
    HttpMethodPostForJSON = 30, // POST请求，参数以JSON字符串形式传递
};


/** 数据请求类型 */
typedef NS_ENUM(NSInteger, RequestType) {
    /** 刷新 */
    RequestTypeRefresh = 0,
    /** 加载更多 */
    RequestTypeLoadMore,
    /** 切换列表 */
    RequestTypeSwitchList,
};



/**
 网络请求结果状态码
 */
typedef NS_ENUM(NSInteger, HttpResponseCode) {
    /** 未知响应 */
    HttpResponseUnknown = 0,
    /** 请求成功 */
    HttpResponseSuccess = 10,
    /** 网络错误 */
    HttpResponseNetworkError = 20,
    /** 请求参数错误 */
    HttpResponseParamError = 30,
    /** 数据返回格式错误 */
    HttpResponseFormatError = 40,
    /** 数据返回为空 */
    HttpResponseNoDataError = 50,
    /** 接口返回的错误信息 */
    HttpResponseError = 60,
};


/** 请求成功后的数据解析方式 */
typedef NS_ENUM(NSInteger, HttpResponseSerializationType) {
    /** 默认方式，直接返回data数据 */
    HttpResponseSerializationTypeDefault = 0,
    /** 解析为JOSN对象 */
    HttpResponseSerializationTypeJson,
    /** 转为String */
    HttpResponseSerializationTypeString,
};


#endif /* WHYHttpRequestTypeDefines_h */
