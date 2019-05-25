//
//  WHYHttpRequest.h
//  HttpServiceDemo
//
//  Created by JackAndney on 2017/7/31.
//  Copyright © 2017年 Creatoo. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol WHYHttpRequestDelegate;

#import "WHYHttpRequestTypeDefines.h"

typedef NSString * WHYHttpErrorDomain NS_STRING_ENUM;

FOUNDATION_EXPORT WHYHttpErrorDomain const WHYHttpJsonFormatError; // JSON格式错误
FOUNDATION_EXPORT WHYHttpErrorDomain const WHYHttpParamError; // 参数错误
FOUNDATION_EXPORT WHYHttpErrorDomain const WHYHttpResponseNoDataError; // 返回数据为空


/**
 *  自定义网络请求类
 
 *  @discussion 请求类本身不做数据缓存的处理，如需缓存功能，请在请求前、请求后做缓存处理逻辑
 */
@interface WHYHttpRequest : NSObject

/** 请求链接 */
@property (nonatomic, copy) NSString *url;

/** 请求方式 */
@property (nonatomic, assign) HttpMethod method;

/** 请求参数 */
@property (nonatomic, copy) NSDictionary<NSString *, NSString *> *params;

/**
 *  请求的代理对象，用于接收接口请求的响应结果
 */
@property (nonatomic, weak) id<WHYHttpRequestDelegate> delegate;

/** 请求完成后的回调 */
@property (nonatomic, copy) WHYRequestResultHandler completionHandler;

/** 请求超时时间
 *
 *  默认为15s
 */
@property (nonatomic, assign) NSTimeInterval timeoutInterval;

/** 是否保存并在请求时携带Cookie信息 */
@property (nonatomic, assign) BOOL requestWithCookie; // 默认为NO

/** 请求头信息 */
@property (nonatomic, copy) NSDictionary *requestHeaders;

/** 自定义请求Tag
 *
 *  用于区分不同的回调请求
 */
@property (nonatomic, copy) NSString *tag;

/** 文件下载后的保存路径/上传文件的本地路径 */
@property (nonatomic, copy) NSString *targetFilePath;
/** 上传的图片或文件 */
@property (nonatomic, copy) id uploadObject;

/** 数据解析的方式(默认返回data) */
@property (nonatomic, assign) HttpResponseSerializationType serializationType;

/** 文件请求类型：
 *
 * 0-非文件请求
 *
 * 1-文件下载
 *
 * 2-图片文件上传
 *
 * 3-其它文件上传
 */
@property (nonatomic, assign) int fileTaskType;




#pragma mark -




/**
 *  构建请求
 *
 * @discussion 需要自己调用[WHYHttpRequest startRequest];方法开始请求
 *
 *  @param url        接口地址
 *  @param method     请求方式
 *  @param params     请求参数
 *  @param delegate   代理对象
 *  @param tag        请求Tag
 *
 *  @return 请求类
 */
+ (WHYHttpRequest *)requestBuildWithURL:(NSString *)url method:(HttpMethod)method params:(NSDictionary *)params requestHeaders:(NSDictionary *)requestHeaders delegate:(id<WHYHttpRequestDelegate>)delegate withTag:(NSString *)tag;

/** 代理方式接收响应的请求 */
+ (void)requestWithURL:(NSString *)url method:(HttpMethod)method params:(NSDictionary *)params requestHeaders:(NSDictionary *)requestHeaders delegate:(id<WHYHttpRequestDelegate>)delegate withTag:(NSString *)tag;

/**
 *  Block回调方式的请求
 * 
 * @discussion 注意：回调handler中返回的responseData为原始数据
 */
+ (void)requestWithURL:(NSString *)url method:(HttpMethod)method params:(NSDictionary *)params requestHeaders:(NSDictionary *)requestHeaders withTag:(NSString *)tag completionHandler:(WHYRequestResultHandler)handler;


/**
 *  文件下载(responseData为文件保存路径)
 *
 *  @param url             请求地址
 *  @param targetPath      本地要保存的文件路径
 *  @param method          请求方法
 *  @param params          请求参数
 *  @param requestHeaders  请求头信息
 *  @param delegate        代理对象（优先级大于block回调）
 *  @param progressHandler 进度更新回调
 *  @param handler         下载完成/失败回调
 */
+ (void)requestFileDownloadWithURL:(NSString *)url targetFilePath:(NSString *)targetPath method:(HttpMethod)method params:(NSDictionary *)params requestHeaders:(NSDictionary *)requestHeaders delegate:(id<WHYHttpRequestDelegate>)delegate progressHandler:(void(^)(WHYHttpRequest *request, NSProgress *progress))progressHandler completionHandler:(WHYRequestResultHandler)handler;


/**
 文件上传

 @param url             请求地址
 @param uploadObj       上传对象（只允许图片data或文件的URL地址）
 @param imageUpload     是否为图片上传
 @param params          请求参数
 @param requestHeaders  请求头信息
 @param delegate        代理对象（优先级大于block回调）
 @param progressHandler 进度更新回调
 @param handler         下载完成/失败回调
 */
+ (void)requestFileUploadWithURL:(NSString *)url uploadObject:(id)uploadObj imageUpload:(BOOL)imageUpload params:(NSDictionary *)params requestHeaders:(NSDictionary *)requestHeaders delegate:(id<WHYHttpRequestDelegate>)delegate progressHandler:(void(^)(WHYHttpRequest *request, NSProgress *progress))progressHandler completionHandler:(WHYRequestResultHandler)handler;



/** 开始请求 */
- (void)startRequest;

/** 暂停任务 */
- (void)suspend; // 只对下载任务有效

/**
 取消网络请求接口
 
 // 调用此接口后，将取消当前网络请求，建议同时[WHYHttpRequest setDelegate:nil];
 
 // 注意：该方法只对使用delegate的request方法有效。无法取消任何使用block的request的网络请求接口。
 */
- (void)cancel;


@end



#pragma mark - WHYHttpRequestDelegate



/**
 *  请求的代理方法
 */
@protocol WHYHttpRequestDelegate <NSObject>

@optional

- (void)request:(WHYHttpRequest *)request didReceiveResponse:(NSURLResponse *)response;

// 该方法的优先级大于下面的 -didFinishLoadingWithResult
- (void)request:(WHYHttpRequest *)request didFinishLoadingWithResponseData:(NSData *)data;
- (void)request:(WHYHttpRequest *)request didFinishLoadingWithResult:(NSString *)result;

- (void)request:(WHYHttpRequest *)request didFailWithError:(NSError *)error;

- (void)request:(WHYHttpRequest *)request didReciveRedirectResponseWithURI:(NSURL *)redirectUrl;

// 文件上传/下载的进度更新回调
- (void)request:(WHYHttpRequest *)request didChangeProgress:(NSProgress *)progress;


#pragma mark  - 其它方法


/**
 URL前半部分与参数拼接处理
 
 @param url         URL前半部分
 @param queryString 要拼接的参数
 @return 拼接后的URL
 */
NSString *WHYHttpUrlParamJointHandle(NSString *url, NSString *queryString);

/** URL请求参数拼接、编码处理 */
NSString *WHYHttpRequestParamHandle(NSDictionary *params);

/**
 字符串编码
 
 @param string 原字符串
 @return 编码后的字符串
 */
NSString *WHYPercentEscapedStringFromString(NSString *string);

/**
 自定义错误信息
 
 @param code 错误码
 @param msg  错误信息
 @param domain 错误域名
 */
NSError *WHYHttpErrorMake(NSInteger code, NSString *msg, NSString *domain);

/**
 网络请求错误描述
 
 @param error NSError对象
 @return 错误描述
 */
NSString *WHYHttpRequestErrorDescription(NSError *error);




@end


