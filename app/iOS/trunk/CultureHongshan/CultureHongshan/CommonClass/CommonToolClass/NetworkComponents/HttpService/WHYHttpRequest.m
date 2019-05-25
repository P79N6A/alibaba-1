//
//  WHYHttpRequest.m
//  HttpServiceDemo
//
//  Created by JackAndney on 2017/7/31.
//  Copyright © 2017年 Creatoo. All rights reserved.
//

#import "WHYHttpRequest.h"
#import <UIKit/UIKit.h>

WHYHttpErrorDomain const WHYHttpJsonFormatError = @"cn.creatoo.request.json.error";
WHYHttpErrorDomain const WHYHttpParamError = @"cn.creatoo.request.param.error";
WHYHttpErrorDomain const WHYHttpResponseNoDataError = @"cn.creatoo.request.blankdata.error";



@interface WHYHttpRequest () <NSURLSessionDataDelegate>
{
    long long _totalExpectedLength; // 数据总长度
    long long _totalReceivedLength; // 已接收数据长度
    
    NSMutableData *responseData; // 接收请求到的数据
    NSData *_resumeData; // 断点下载缓存的数据（非文件本身的数据）
    
}
@property (nonatomic, copy) void (^progressHandler)(WHYHttpRequest *request, NSProgress *progress);

@property (nonatomic, strong) NSURLSessionTask *task;
@property (nonatomic, strong) NSURLSession *session;

@end


@implementation WHYHttpRequest

- (void)releaseData {
    if (self.url.length) {
//        FBLOG(@"要释放的请求链接：%@ 参数：%@", self.url, self.params);
    }
    
    responseData = nil;
    self.delegate = nil;
    self.completionHandler = nil;
    self.progressHandler = nil;
    self.url = nil;
    self.params = nil;
    self.requestHeaders = nil;
    self.uploadObject = nil;
    self.targetFilePath = nil;
    self.tag = nil;
    self.task = nil;
    if (self.session) {
        [self.session invalidateAndCancel];
        self.session = nil;
    }
}

- (void)dealloc {
    [self releaseData];
    FBLOG(@"请求被释放：%@", self);
}


- (instancetype)init {
    if (self = [super init]) {
        self.method = HttpMethodPost;
        self.requestHeaders = @{};
        self.tag = nil;
        self.timeoutInterval = HTTP_TIMEOUT_DURATION;
        self.serializationType = HttpResponseSerializationTypeDefault;
        
        self.fileTaskType = 0;
    }
    return self;
}


/** 统一的构建请求的方法 */
+ (WHYHttpRequest *)m_requestBuildWithURL:(NSString *)url
                               method:(HttpMethod)method
                                   params:(NSDictionary *)params
                           requestHeaders:(NSDictionary *)requestHeaders
                                 delegate:(id<WHYHttpRequestDelegate>)delegate
                          timeoutInterval:(NSTimeInterval)timeoutInterval
                                  withTag:(NSString *)tag
                        completionHandler:(WHYRequestResultHandler)handler {
    
    WHYHttpRequest *request = [[WHYHttpRequest alloc] init];
    
    request.url = url;
    request.method = method;
    request.params = params;
    request.delegate = delegate;
    request.completionHandler = handler;
    
    if (requestHeaders.count) request.requestHeaders = requestHeaders;
    if (timeoutInterval > 0) request.timeoutInterval = timeoutInterval;
    if (tag) request.tag = tag;
    
    return request;
}

// 构建请求
+ (WHYHttpRequest *)requestBuildWithURL:(NSString *)url method:(HttpMethod)method params:(NSDictionary *)params requestHeaders:(NSDictionary *)requestHeaders delegate:(id<WHYHttpRequestDelegate>)delegate withTag:(NSString *)tag {
    
    return [WHYHttpRequest m_requestBuildWithURL:url method:method params:params requestHeaders:requestHeaders delegate:delegate timeoutInterval:-1 withTag:tag completionHandler:nil];
}

// 代理方式接收响应的请求
+ (void)requestWithURL:(NSString *)url method:(HttpMethod)method params:(NSDictionary *)params requestHeaders:(NSDictionary *)requestHeaders delegate:(id<WHYHttpRequestDelegate>)delegate withTag:(NSString *)tag {
    
    WHYHttpRequest *request = [WHYHttpRequest m_requestBuildWithURL:url method:method params:params requestHeaders:requestHeaders delegate:delegate timeoutInterval:-1 withTag:tag completionHandler:nil];
    
    [request startRequest];
}

// Block回调方式的请求
+ (void)requestWithURL:(NSString *)url method:(HttpMethod)method params:(NSDictionary *)params requestHeaders:(NSDictionary *)requestHeaders withTag:(NSString *)tag completionHandler:(WHYRequestResultHandler)handler {
    
    WHYHttpRequest *request = [WHYHttpRequest m_requestBuildWithURL:url method:method params:params requestHeaders:requestHeaders delegate:nil timeoutInterval:-1 withTag:tag completionHandler:handler];
    
    [request startRequest];
}


// 文件下载
+ (void)requestFileDownloadWithURL:(NSString *)url targetFilePath:(NSString *)targetPath method:(HttpMethod)method params:(NSDictionary *)params requestHeaders:(NSDictionary *)requestHeaders delegate:(id<WHYHttpRequestDelegate>)delegate progressHandler:(void(^)(WHYHttpRequest *request, NSProgress *progress))progressHandler completionHandler:(WHYRequestResultHandler)handler {
    
    WHYHttpRequest *request = [WHYHttpRequest m_requestBuildWithURL:url method:method params:params requestHeaders:requestHeaders delegate:delegate timeoutInterval:-1 withTag:nil completionHandler:handler];
    
    request.fileTaskType = 1; // 设置为文件下载请求
    request.targetFilePath = targetPath;
    request.progressHandler = progressHandler;
    
    [request startRequest];
}

// 文件上传
+ (void)requestFileUploadWithURL:(NSString *)url uploadObject:(id)uploadObj imageUpload:(BOOL)imageUpload params:(NSDictionary *)params requestHeaders:(NSDictionary *)requestHeaders delegate:(id<WHYHttpRequestDelegate>)delegate progressHandler:(void(^)(WHYHttpRequest *request, NSProgress *progress))progressHandler completionHandler:(WHYRequestResultHandler)handler {
    
    WHYHttpRequest *request = [WHYHttpRequest m_requestBuildWithURL:url method:HttpMethodPost params:params requestHeaders:requestHeaders delegate:delegate timeoutInterval:-1 withTag:nil completionHandler:handler];
    
    if (imageUpload) {
        request.fileTaskType = 2; // 图片上传
    }else {
        request.fileTaskType = 3; // 其它文件上传
    }
    
    request.serializationType = HttpResponseSerializationTypeJson;
    request.uploadObject = uploadObj;
    request.progressHandler = progressHandler;
    
    [request startRequest];
}

#pragma mark -

// 配置请求参数
- (void)beginConfigureRequest {
    NSString *requestUrl = @"";
    
    if (self.method == HttpMethodGet) {
        // GET请求，参数直接拼接到URL中
        NSString *paramString = WHYHttpRequestParamHandle(self.params);
        requestUrl = WHYHttpUrlParamJointHandle(self.url, paramString);
        // 添加签名
        requestUrl = WHYHttpUrlParamJointHandle(requestUrl, [NSString stringWithFormat:@"sign=%@", WHYHttpURLSign(requestUrl)]);
        
//        FBLOG(@"实际请求链接GET：%@", requestUrl); // *********************************************
    }else {
        requestUrl = [self.url copy];
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:requestUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:self.timeoutInterval > 0 ? self.timeoutInterval : HTTP_TIMEOUT_DURATION];
    
    
    // 设置Cookie信息
    if (self.requestWithCookie) {
        NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        NSArray *cookies = [cookieStorage cookiesForURL:[NSURL URLWithString:requestUrl]];
        if (cookies.count > 0) {
            NSDictionary *headerFields = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
            if (headerFields.count > 0) {
                for (NSString *key in headerFields.allKeys) {
                    [request setValue:[headerFields valueForKey:key] forHTTPHeaderField:key];
                }
            }
        }
    }
    
    // 请求头信息
    [self.class configureRequestHeaders:request allHeaders:self.requestHeaders];
    
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
    self.session = session;
    
    if (self.method == HttpMethodGet) {
        [request setHTTPMethod:@"GET"];
        
        if (_fileTaskType == 1) { // 文件下载
            if (_resumeData.length > 0) {
                self.task = [session downloadTaskWithResumeData:_resumeData];
            }else {
                self.task = [session downloadTaskWithRequest:request];
            }
        }else {
            self.task = [session dataTaskWithRequest:request];
        }
        
    }else if (self.method == HttpMethodPostForJSON) {
        [request setHTTPMethod:@"POST"];
        NSData *bodyData = [NSJSONSerialization dataWithJSONObject:self.params options:NSJSONWritingPrettyPrinted error:nil];
        request.HTTPBodyStream = [[NSInputStream alloc] initWithData:bodyData];
        
        // 添加签名
        NSString *bobyString = [[NSString alloc] initWithData:bodyData encoding:NSUTF8StringEncoding];
        NSString *jointedUrl = WHYHttpUrlParamJointHandle(requestUrl, bobyString);
        NSString *sign = WHYHttpURLSign(jointedUrl);
        [request setValue:sign forHTTPHeaderField:@"sign"];
        
        
        [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)bodyData.length] forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [request setValue:@"keep-alive" forHTTPHeaderField:@"Connection"];
        
        // 传Json参数的请求，统一认为是普通的请求（非文件类型）
        self.task = [session dataTaskWithRequest:request];
        
    }else {
        // 其它情况下，默认为POST请求
        [request setHTTPMethod:@"POST"];
        [request setValue:@"keep-alive" forHTTPHeaderField:@"Connection"];
        
 
        if (_fileTaskType == 2 || _fileTaskType == 3) {
            // 文件上传
            NSData *uploadFileData = nil;
            NSString *pathExtension = @"data";
            
            if (_fileTaskType == 2) {
                // 图片文件上传
                pathExtension = @"jpg";
                if ([self.uploadObject isKindOfClass:[NSData class]]) { // 数据
                    uploadFileData = self.uploadObject;
                }else if ([self.uploadObject isKindOfClass:NSClassFromString(@"UIImage")]) { // 图片对象
                    
#ifdef UIKIT_EXTERN
                    uploadFileData = UIImageJPEGRepresentation(self.uploadObject, 0.8);
#else
                    [self m_requestDidFailWithError:WHYHttpErrorMake(0, @"上传图片此处不支持UIImage对象，请转为NSData对象后再进行上传！")];
                    return;
#endif
                }
            }
            
            // 其它文件上传
            NSFileManager *fm = [NSFileManager defaultManager];
            
            if ([self.uploadObject isKindOfClass:[NSString class]]) { // 文件路径
                if ([fm fileExistsAtPath:self.uploadObject]) {
                    pathExtension = [[self.uploadObject pathExtension] lowercaseString];
                    uploadFileData = [[NSData alloc] initWithContentsOfFile:self.uploadObject];
                }else {
                    [self m_requestDidFailWithError:WHYHttpErrorMake(0, @"上传文件路径不存在！", WHYHttpParamError)];
                    return;
                }
            }else if ([self.uploadObject isKindOfClass:[NSURL class]]) { // 文件URL
                if ([fm fileExistsAtPath:[(NSURL *)self.uploadObject path]]) {
                    pathExtension = [[self.uploadObject pathExtension] lowercaseString];
                    uploadFileData = [[NSData alloc] initWithContentsOfURL:self.uploadObject];
                }else {
                    [self m_requestDidFailWithError:WHYHttpErrorMake(0, @"上传文件路径不存在！", WHYHttpParamError)];
                    return;
                }
            }
            
            if (uploadFileData.length < 1) {
                [self m_requestDidFailWithError:WHYHttpErrorMake(0, @"上传的数据为空，请检查！", WHYHttpParamError)];
                return;
            }
            
            
            /*******************************************************************************/
            /*******************************************************************************/
            
            NSData *bodyData = [self uploadFileBodyDataHandle:uploadFileData pathExtension:pathExtension request:request];
            
            self.task = [session uploadTaskWithRequest:request fromData:bodyData];
            
        }else {
            // 文件下载 或 普通的POST请求
            
            NSString *bodyString = WHYHttpRequestParamHandle(self.params);
            
            NSString *jointedUrl = WHYHttpUrlParamJointHandle(requestUrl, bodyString);
            NSString *sign = WHYHttpURLSign(jointedUrl);
            [request setValue:sign forHTTPHeaderField:@"sign"];
            if (bodyString.length > 0) {
                bodyString = [NSString stringWithFormat:@"%@&sign=%@", bodyString, sign];
            }else {
                bodyString = [NSString stringWithFormat:@"sign=%@", sign];
            }
            
//            FBLOG(@"实际请求链接POST：%@", WHYHttpUrlParamJointHandle(requestUrl, bodyString)); // *********************************************
            
            NSData *bodyData = bodyString.length>0 ? [bodyString dataUsingEncoding:NSUTF8StringEncoding] : [NSData data];
            request.HTTPBody = bodyData;
            
            [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)bodyData.length] forHTTPHeaderField:@"Content-Length"];
            [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            
            self.task = [session dataTaskWithRequest:request];
        }
    }
}


// 开始请求(外部方法)
- (void)startRequest {
    [self beginConfigureRequest];
    [self m_startRequest];
    
//    FBLOG(@"开始请求：%@ url: %@ 参数：%@", self, self.url, self.params);
}



// 开始请求(内部方法)
- (void)m_startRequest {
    if (self.task) {
        [self.task resume];
    }
}

// 暂停请求
- (void)suspend {
    if (self.task) {
        [self.task suspend];
    }
}

// 取消请求
- (void)cancel {
    if (self.task) {
        if ([self.task isKindOfClass:[NSURLSessionDownloadTask class]]) {
            [(NSURLSessionDownloadTask *)self.task cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
                _resumeData = resumeData;
            }];
        }else {
            [self.task cancel];
        }
    }
}



#pragma mark - NSURLSessionDelegate

// 请求出错
- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(nullable NSError *)error {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(request:didFailWithError:)]) {
        [self.delegate request:self didFailWithError:error];
    }else {
        if (self.completionHandler) {
            self.completionHandler(self, nil, error);
        }
    }
    
    responseData = nil;
}

// 请求鉴权
- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * __nullable credential))completionHandler {
//    FBLOG(@"请求需要授权：%@", challenge);
//    FBLOG(@"%@", challenge.protectionSpace.authenticationMethod);
    
    // 1.从服务器返回的受保护空间中拿到证书的类型
    // 2.判断服务器返回的证书是否是服务器信任的
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
//        FBLOG(@"是服务器信任的证书");
        // 3.根据服务器返回的受保护空间创建一个证书
        //         void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *)
        //         代理方法的completionHandler block接收两个参数:
        //         第一个参数: 代表如何处理证书
        //         第二个参数: 代表需要处理哪个证书
        //创建证书
        NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        // 4.安装证书
        completionHandler(NSURLSessionAuthChallengeUseCredential , credential);
    }
}

// 应用进入前台后的请求回调
- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session {
    FBLOG(@"应用进入前台？  %@", session);
}


#pragma mark - NSURLSessionTaskDelegate 请求完成

// 上传进度监听
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend {
    
    if (_fileTaskType == 2 || _fileTaskType == 3) {
        // 文件上传任务时
        
        NSProgress *progress = [NSProgress progressWithTotalUnitCount:totalBytesExpectedToSend];
        progress.completedUnitCount = totalBytesSent;
        
        if (self.delegate) {
            if ([self.delegate respondsToSelector:@selector(request:didChangeProgress:)]) {
                [self.delegate request:self didChangeProgress:progress];
            }
        }else {
            if (self.progressHandler) {
                self.progressHandler(self, progress);
            }
        }
    }
}

// 请求完成，error为空表示请求成功
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(nullable NSError *)error {
    if (error) {
        [self m_requestDidFailWithError:error];
    }else {
        [self m_requestDidSuccess];
    }
}



#pragma mark - NSURLSessionDataDelegate

// 接收到请求响应
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
//    FBLOG(@"接收到服务器的响应： %@", response);
    
    if (self.requestWithCookie) {
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            NSDictionary *responseHeaders =  httpResponse.allHeaderFields;
            
            // 保存Cookie信息
            if (responseHeaders.count > 0 && responseHeaders[@"Set-Cookie"] != nil) {
                NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:responseHeaders];
                [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
            }
        }
    }

    
    if (self.delegate && [self.delegate respondsToSelector:@selector(request:didReceiveResponse:)]) {
        [self.delegate request:self didReceiveResponse:response];
    }
    
    // 初始化数据接收容器
    if (responseData) responseData = nil;
    responseData = [[NSMutableData alloc] init];
    
    // 保存数据的总大小
    _totalExpectedLength = response.expectedContentLength;
    
    // 允许处理服务器的响应，才会继续接收服务器返回的数据
    completionHandler(NSURLSessionResponseAllow);
}

// 转为下载任务
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didBecomeDownloadTask:(NSURLSessionDownloadTask *)downloadTask {
    FBLOG(@"请求任务转为下载文件任务");
}


// 转为数据流任务
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didBecomeStreamTask:(NSURLSessionStreamTask *)streamTask {
    FBLOG(@"didBecomeStreamTask");
}

// 接收到部分数据
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data {
    
    [responseData appendData:data];
    _totalReceivedLength += data.length;
    
    
    if (_fileTaskType != 2 && _fileTaskType != 3) {
        // 非文件上传任务时
        NSProgress *progress = [NSProgress progressWithTotalUnitCount:_totalExpectedLength];
        progress.completedUnitCount = _totalReceivedLength;

        if (self.delegate) {
            if ([self.delegate respondsToSelector:@selector(request:didChangeProgress:)]) {
                [self.delegate request:self didChangeProgress:progress];
            }
        }else {
            if (self.progressHandler) {
                self.progressHandler(self, progress);
            }
        }
    }
}

// 数据缓存
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
 willCacheResponse:(NSCachedURLResponse *)proposedResponse
 completionHandler:(void (^)(NSCachedURLResponse * __nullable cachedResponse))completionHandler {
//    FBLOG(@"数据将要缓存， 这里可以更改缓存的数据");
    completionHandler(proposedResponse);
}



#pragma mark -  文件下载（NSURLSessionDownloadDelegate）

// 文件下载完成
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    
    NSFileManager *fm = [NSFileManager defaultManager];
    
    NSError *error = nil;
    
    if ([fm fileExistsAtPath:self.targetFilePath]) {
        if (![fm removeItemAtPath:self.targetFilePath error:&error]) {
            FBLOG(@"原文件删除失败： %@", error);
        }
    }
    
    if (![fm moveItemAtURL:location toURL:[NSURL fileURLWithPath:self.targetFilePath] error:&error]) {
        FBLOG(@"文件移动失败： %@", error);
    }
}

// 下载中回调
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    
    NSProgress *progress = [NSProgress progressWithTotalUnitCount:totalBytesExpectedToWrite];
    progress.completedUnitCount = totalBytesWritten;
    
    // 进度回调
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(request:didChangeProgress:)]) {
            [self.delegate request:self didChangeProgress:progress];
        }
    }else {
        if (self.progressHandler) {
            self.progressHandler(self, progress);
        }
    }
}


// Sent when a download has been resumed. If a download failed with an error, the -userInfo dictionary of the error will contain an NSURLSessionDownloadTaskResumeData key, whose value is the resume data.
// 请求恢复
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes {
    FBLOG(@"请求恢复： ");
}



#pragma mark -


// 错误处理
- (void)m_requestDidFailWithError:(NSError *)error {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(request:didFailWithError:)]) {
        [self.delegate request:self didFailWithError:error];
    }else {
        if (self.completionHandler) {
            self.completionHandler(self, nil, error);
        }
    }
    
    [self releaseData];
}

// 请求成功处理
- (void)m_requestDidSuccess {
    
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(request:didFinishLoadingWithResponseData:)]) {
            [self.delegate request:self didFinishLoadingWithResponseData:[responseData copy]];
        }else {
            if ([self.delegate respondsToSelector:@selector(request:didFinishLoadingWithResult:)]) {
                if (_fileTaskType == 1) { // 文件下载
                    [self.delegate request:self didFinishLoadingWithResult:self.targetFilePath];
                }else {
                    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
                    [self.delegate request:self didFinishLoadingWithResult:responseString];
                }
            }
        }
        
    }else {

        if (self.completionHandler) {
            
            if (self.serializationType == HttpResponseSerializationTypeJson) {
                
                if (responseData.length == 0) {
                    NSError *responseError = WHYHttpErrorMake(0, @"服务器返回数据为空！", WHYHttpResponseNoDataError);
                    self.completionHandler(self, nil, responseError);
                    return;
                }
                
                NSError *jsonError = nil;
                id jsonObj = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&jsonError];
                
                if (jsonError) {
                    NSError *responseError = WHYHttpErrorMake(0, @"服务器返回数据格式错误！", WHYHttpJsonFormatError);
                    self.completionHandler(self, nil, responseError);
                    
                    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
                    FBLOG(@"responseString： %@", responseString);
                    
                }else {
                    self.completionHandler(self, jsonObj, nil);
                }
                
            }else if (self.serializationType == HttpResponseSerializationTypeString) {
                
                NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
                self.completionHandler(self, responseString, nil);
                
            }else {
                if (_fileTaskType == 1) {
                    self.completionHandler(self, self.targetFilePath, nil);
                }else {
                    self.completionHandler(self, [responseData copy], nil);
                }
            }
        }
        else {
        }
    }
    
    [self releaseData];
}



#pragma mark - 其它方法


/** 设置请求头信息 */
+ (void)configureRequestHeaders:(NSMutableURLRequest *)request allHeaders:(NSDictionary *)allHeaders {
    if (request == nil) return;
    
    for (NSString *key in allHeaders.allKeys) {
        NSString *value = [allHeaders valueForKey:key];
        if ([value isKindOfClass:[NSString class]] && value.length > 0) {
            [request setValue:value forHTTPHeaderField:key];
        }
    }
}


- (NSData *)uploadFileBodyDataHandle:(NSData *)fileData pathExtension:(NSString *)pathExtension request:(NSMutableURLRequest *)request {
    // 分界线的标识符
    NSString *BOUNDARY_IDENTIFIER = [NSString stringWithFormat:@"Boundary+%08X%08X", arc4random(), arc4random()];
    //分界线 --AaB03x
    NSString *boundary_seperate = [[NSString alloc] initWithFormat:@"--%@",BOUNDARY_IDENTIFIER];
    //结束符 AaB03x--
    NSString *boundary_end_flag = [[NSString alloc] initWithFormat:@"%@--",boundary_seperate];
    
    // http body的字符串
    NSMutableString *bodyString = [[NSMutableString alloc] init];
    
    
    for (NSString *key in self.params.allKeys) {
        // 添加分界线，换行
        [bodyString appendFormat:@"%@\r\n",boundary_seperate];
        // 添加字段名称，换2行
        [bodyString appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
        
        // 添加字段的值
        id value = [self.params valueForKey:key];
        
        if ([value isKindOfClass:[NSString class]]) {
            [bodyString appendFormat:@"%@\r\n", value];
        }else if ([value isEqual:[NSNull null]]) {
            [bodyString appendFormat:@"%@\r\n",@""];
        }else {
            [bodyString appendFormat:@"%@\r\n", [value description]];
        }
    }
    
    
    //声明bodyData，用来放入http body
    NSMutableData *bodyData = [NSMutableData data];
    //将body字符串转化为UTF8格式的二进制
    [bodyData appendData:[bodyString dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSDateFormatter *df = [NSDateFormatter new];
    df.dateFormat = @"yyyyMMddHHmmss";
    NSString *uuid = [[[[NSUUID UUID] UUIDString] stringByReplacingOccurrencesOfString:@"-" withString:@""] lowercaseString];
    
    NSString *fileName = [NSString stringWithFormat:@"%@%@", [df stringFromDate:[NSDate date]], uuid];
    
    
    // 添加图片信息字段
    // 添加分界线，换行
    NSMutableString *imgbody = [NSMutableString stringWithCapacity:20];
    [imgbody appendFormat:@"%@\r\n",boundary_seperate];
    NSString *name = @"file";
    [imgbody appendFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@.%@\"\r\n", name, fileName, pathExtension];
    // 声明上传文件的格式
    [imgbody appendFormat:@"Content-Type: application/octet-stream; charset=utf-8\r\n\r\n"];
    // 将body字符串转化为UTF8格式的二进制
    [bodyData appendData:[imgbody dataUsingEncoding:NSUTF8StringEncoding]];
    [bodyData appendData:fileData];
    [bodyData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    
    //声明结束符：--AaB03x--
    NSString *end = [[NSString alloc]initWithFormat:@"%@\r\n",boundary_end_flag];
    //加入结束符--AaB03x--
    [bodyData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    //设置HTTPHeader
    [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", BOUNDARY_IDENTIFIER] forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[bodyData length]] forHTTPHeaderField:@"Content-Length"];
    
    return bodyData;
}


#pragma mark - ——————————————————— 辅助方法 —————————————————


// URL前半部分与参数拼接处理
NSString *WHYHttpUrlParamJointHandle(NSString *url, NSString *queryString)  {
    if (url.length > 0) {
        
        if (queryString.length > 0) {
            if ([url rangeOfString:@"?"].location != NSNotFound) {
                if ([url hasSuffix:@"&"]) {
                    return [NSString stringWithFormat:@"%@%@", url, queryString];
                }else {
                    return [NSString stringWithFormat:@"%@&%@", url, queryString];
                }
            }else {
                // 请求前半部分不包含?
                return [NSString stringWithFormat:@"%@?%@", url, queryString];
            }
        }else {
            return [url copy];
        }
    }
    return @"";
}


// 请求参数拼接处理
NSString *WHYHttpRequestParamHandle(NSDictionary *params) {
    
    if (params.count) {
        NSMutableString *tmpString = [[NSMutableString alloc] initWithCapacity:10];
        
        // 字典key值按ASCII码排序
        NSArray *allKeys = [params.allKeys sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
            NSComparisonResult result = [obj1 compare:obj2];
            if (result == NSOrderedDescending) {
                return NSOrderedDescending;
            }else if (result == NSOrderedAscending) {
                return NSOrderedAscending;
            }
            return NSOrderedSame;
        }];
        
        // 将“key=value”拼接到参数字符串后面
        for (NSString *key in allKeys) {
            
            NSString *valueString = nil;
            id value = [params valueForKey:key];
            
            if ([value isKindOfClass:[NSString class]]) {
                valueString = value;
            }else if ([value isKindOfClass:[NSNumber class]]) {
                valueString = [value stringValue];
            }
            
            if (valueString) {
                if (tmpString.length) {
                    [tmpString appendString:@"&"];
                }
                [tmpString appendFormat:@"%@=%@", WHYPercentEscapedStringFromString(key), WHYPercentEscapedStringFromString(valueString)];
            }
        }
        return tmpString;
    }
    
    return @"";
}


/**
 获取请求的加密签名

 @param originalUrl  请求的URL
 @return 签名MD5
 */
NSString *WHYHttpURLSign(NSString *originalUrl) {
    if (originalUrl.length > 0) {
        NSString * md5 = [EncryptTool md5Encode:[NSString stringWithFormat:@"%@%@", originalUrl, MD5_PRIVATEKEY]];
        return md5;
    }
    return @"";
}


/**
 字符串编码

 @param string 原字符串
 @return 编码后的字符串
 */
NSString *WHYPercentEscapedStringFromString(NSString *string) {
    static NSString * const kWHYCharactersGeneralDelimitersToEncode = @":#[]@"; // does not include "?" or "/" due to RFC 3986 - Section 3.4
    static NSString * const kWHYCharactersSubDelimitersToEncode = @"!$&'()*+,;=";
    
    NSMutableCharacterSet * allowedCharacterSet = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
    [allowedCharacterSet removeCharactersInString:[kWHYCharactersGeneralDelimitersToEncode stringByAppendingString:kWHYCharactersSubDelimitersToEncode]];
    
    // FIXME: https://github.com/AFNetworking/AFNetworking/pull/3028
    // return [string stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
    
    static NSUInteger const batchSize = 50;
    
    NSUInteger index = 0;
    NSMutableString *escaped = @"".mutableCopy;
    
    while (index < string.length) {
        NSUInteger length = MIN(string.length - index, batchSize);
        NSRange range = NSMakeRange(index, length);
        
        // To avoid breaking up character sequences such as 👴🏻👮🏽
        range = [string rangeOfComposedCharacterSequencesForRange:range];
        
        NSString *substring = [string substringWithRange:range];
        NSString *encoded = [substring stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
        [escaped appendString:encoded];
        
        index += range.length;
    }
    
    return escaped;
}


// 创建NSError对象
NSError *WHYHttpErrorMake(NSInteger code, NSString *msg, NSString *domain) {
    if (msg == nil) {
        msg = @"返回数据格式不正确！";
    }
    NSDictionary *userInfo = @{
                               NSLocalizedDescriptionKey : msg,
                               NSLocalizedFailureReasonErrorKey : msg,
                               };
    return [NSError errorWithDomain:domain code:code userInfo:userInfo];
};


// 网络请求错误描述
NSString *WHYHttpRequestErrorDescription(NSError *error) {
    if (error == nil) return @"";
    
    // 自定义的错误域名
    if ([error.domain isEqualToString:WHYHttpJsonFormatError] || [error.domain isEqualToString:WHYHttpParamError] || [error.domain isEqualToString:WHYHttpResponseNoDataError]) {
        if (error.localizedFailureReason.length > 0) {
            return error.localizedFailureReason;
        }else {
            return error.localizedDescription;
        }
    }
    
    // 系统类错误
    switch (error.code) {
        case NSURLErrorTimedOut: return @"网络请求超时，请稍后再试！";
        case NSURLErrorNetworkConnectionLost: return @"网络连接已断开！";
        case NSURLErrorNotConnectedToInternet: return @"网络连接不可用，请检查网络！";
            
        case NSURLErrorUnknown: return @"出现未知错误！";
        case NSURLErrorCancelled: return @"网络请求已取消！";
        case NSURLErrorBadURL: return @"无效的请求地址！";
        case NSURLErrorUnsupportedURL: return @"不受支持的请求地址！";
        case NSURLErrorCannotFindHost: return @"无法找到指定的服务器地址！";
        case NSURLErrorCannotConnectToHost: return @"无法连接到服务器地址！";
        case NSURLErrorDNSLookupFailed: return @"DNS解析失败!";
        case NSURLErrorHTTPTooManyRedirects: return @"HTTP请求重定向过多！";
        case NSURLErrorResourceUnavailable: return @"请求的资源文件不可用！";
        case NSURLErrorRedirectToNonExistentLocation: return @"网络请求被重定向到不存在的位置！";
        case NSURLErrorBadServerResponse: return @"服务器响应异常！";
        case NSURLErrorUserCancelledAuthentication: return @"用户取消授权";
        case NSURLErrorUserAuthenticationRequired: return @"需要用户授权";
        case NSURLErrorZeroByteResource: return @"零字节资源！";
        case NSURLErrorCannotDecodeRawData: return @"无法解码原始数据!";
        case NSURLErrorCannotDecodeContentData: return @"无法解码内容数据";
        case NSURLErrorCannotParseResponse: return @"无法解析请求的响应";
            
        case -1022: return @"App必须使用HTTPs加密请求！"; // NSURLErrorAppTransportSecurityRequiresSecureConnection
        case NSURLErrorFileDoesNotExist: return @"请求的文件不存在！";
        case NSURLErrorFileIsDirectory: return @"请求的文件是一个文件目录！";
        case NSURLErrorNoPermissionsToReadFile: return @"无读取文件的权限！";
        case NSURLErrorDataLengthExceedsMaximum: return @"请求数据长度超出最大限度";
        case -1104: return @"文件不在安全区域内！"; // NSURLErrorFileOutsideSafeArea ios(10.3)
        case NSURLErrorSecureConnectionFailed: return @"安全连接失败！";
        case NSURLErrorServerCertificateHasBadDate: return @"服务器证书已失效！";
        case NSURLErrorServerCertificateUntrusted: return @"不被信任的服务器证书！";
        case NSURLErrorServerCertificateHasUnknownRoot: return @"服务器证书是由未知颁发机构签名的！";
        case NSURLErrorServerCertificateNotYetValid: return @"服务器证书未生效!";
        case NSURLErrorClientCertificateRejected: return @"客户端证书被拒!";
        case NSURLErrorCannotLoadFromNetwork: return @"无法从网络获取!";
            
        case NSURLErrorCannotCreateFile: return @"无法创建文件！";
        case NSURLErrorCannotOpenFile: return @"无法打开文件！";
        case NSURLErrorCannotCloseFile: return @"无法关闭文件!";
        case NSURLErrorCannotWriteToFile: return @"无法写入文件！";
        case NSURLErrorCannotRemoveFile: return @"无法删除文件！";
        case NSURLErrorCannotMoveFile: return @"无法移动文件！";
            
        case NSURLErrorDownloadDecodingFailedMidStream: return @"下载的编码数据解码失败！";
        case NSURLErrorDownloadDecodingFailedToComplete: return @"下载的编码文件解码失败！";
        case NSURLErrorInternationalRoamingOff: return @"国际漫游被关闭";
        case NSURLErrorCallIsActive: return @"拨打电话中，";
        case NSURLErrorDataNotAllowed: return @"蜂窝网络连接不可用！";
            
        case -995: return @"后台会话需要共享的容器！"; // NSURLErrorBackgroundSessionRequiresSharedContainer
        case -996: return @"后台会话被另一个进程占用！"; // NSURLErrorBackgroundSessionInUseByAnotherProcess
        case -997: return @"后台会话已断开连接"; // NSURLErrorBackgroundSessionWasDisconnected

        default:
            break;
    }
    
    return @"出现未知错误!";
}


@end
