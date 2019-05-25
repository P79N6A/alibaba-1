//

//  AppProtocol.m
//  CultureHongshan
//
//  Created by one on 15/11/6.
//  Copyright © 2015年 CT. All rights reserved.
//

#import "AppProtocol.h"
#import "AppProtocolMacros.h"
#import "ProtocolBased.h"

#import "UserTagServices.h"
#import "CitySwitchModel.h"

//个人中心

#import "MyCommentModel.h"//用户中心里的“我的评论”

#import "User.h"//用户信息

#import "UserCollectModel.h"//收藏的活动或场馆

#import "MyOrderModel.h"//我的订单
#import "OrderDetailModel.h"//订单详情
#import "ActOrderDetailModel.h"
#import "VenueOrderDetailModel.h"
#import "OrderPayModel.h" // 订单支付参数
#import "PrepayOrderModel.h" // 预支付订单

#import "UserMessage.h"//用户消息
#import "UserAccumulativeScoreModel.h"//用户积分

//广告
#import "AdvertModel.h"

//场馆Model
#import "VenueModel.h"
#import "VenueDetailModel.h"
#import "ActivityRoomModel.h"
#import "ActivityRoomDetailModel.h"
#import "ActivityRoomTimeModel.h"
#import "ActivityRoomBookModel.h"//活动室预订
#import "ActivityRoomOrderConfirmModel.h"//活动室订单确定
#import "AntiqueModel.h"
#import "AntiqueDetailModel.h"

//活动
#import "ActivityModel.h"
#import "ActivitySubModel.h"
#import "ActivityDetail.h"
#import "SeatModel.h"
#import "Registration.h"
#import "ActivityGatherModel.h"

//评论
#import "CommentModel.h"

#import "SearchTag.h"
#import "SearchLocationTag.h"
#import "SearchHotKeyModel.h"

//视频
#import "Video.h"

//筛选
#import "ActivityFilterModel.h"

//版本更新
#import "AppUpdateModel.h"

//文化空间
#import "CultureSpacingTagModel.h"
#import "PushServices.h"


// 固定接口请求
#define FIXED_PROTOCOL_REQUEST   //[params setValue:@1 forKey:kFixedProtocolKey];



#define DICT_PARAMS_DECLARE  NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];

#define SAFE_SET_VALUE(value, key) \
    if (value != nil && [value length]) { [params setValue:value forKey:key]; }

#define __REQUEST_ERROR__ \
    if (responseCode != HttpResponseSuccess) { \
    if (responseBlock) { responseBlock(responseCode, responseObject); } \
    return; \
    } \

#define __ERROR_MSG__(msg) \
    if (responseBlock) { responseBlock(HttpResponseError, msg); }\
    return;


#define __ERROR_HANDLE__(defaultMsg) \
    NSString *errorMsg = [responseObject safeStringForKey:@"data"];\
    if (errorMsg.length<1) { errorMsg = [responseObject safeStringForKey:@"msg"]; }\
    if (errorMsg.length<1) { errorMsg = [[responseObject safeDictForKey:@"msg"] safeStringForKey:@"errmsg"]; }\
    if (responseBlock) {\
    responseBlock(HttpResponseError, errorMsg.length>1 ? errorMsg : defaultMsg);\
    }\



@implementation AppProtocol



#pragma mark - ———————————————————  个人中心  —————————————————————

#pragma mark 用户信息

// 根据用户id获取信息：获取用户信息跟着城市切换，获取用户的积分用全国的接口
+ (void)queryUserInfoWithUserId:(NSString *)userId UsingBlock:(HttpResponseBlock)responseBlock {
    DICT_PARAMS_DECLARE
    if ([userId hasPrefix:@"|"]) {
        userId = [userId substringFromIndex:1];
        [params setValue:@"UnusedValue" forKey:@"UnusedKey"];
    }
    SAFE_SET_VALUE(userId, @"userId");
    
    [ProtocolBased requestPostWithParameters:params protocolString:kUserInfoByUserIdUrl cacheMode:CACHE_MODE_NOCACHE UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        __REQUEST_ERROR__
        
        NSInteger statusCode = [responseObject safeStatusCodeForKey:@"status"];
        if (statusCode == 0) {
            NSArray *listArray = [User instanceArrayFromDictArray:[responseObject safeArrayForKey:@"data"]];
            if (listArray.count) {
                
                User *user = [listArray firstObject];
                [PushServices setTags:nil alias:user.userId];
                
                // 继续获取用户积分
                [AppProtocol getUserIntegralWithUserId:user.userId UsingBlock:^(HttpResponseCode responseCode2, id responseObject2) {
                    if (responseCode2 == HttpResponseSuccess) {
                        user.userIntegral = [responseObject2 integerValue];
                        if (responseBlock) {
                            responseBlock(HttpResponseSuccess, user);
                        }
                    }else {
                        __ERROR_MSG__(responseObject2);
                    }
                }];
            }else {
                __ERROR_MSG__(@"网络出现异常,请稍候再试")
            }
        }else {
            __ERROR_HANDLE__(@"获取用户信息失败！")
        }
    }];
}

// 更新用户信息
+ (void)updateUserInfoWithUserId:(NSString *)userId userName:(NSString *)userName userSex:(NSString *)userSex userTelephone:(NSString *)userTelephone userArea:(NSString *)userArea UsingBlock:(HttpResponseBlock)responseBlock {
    DICT_PARAMS_DECLARE
    FIXED_PROTOCOL_REQUEST
    SAFE_SET_VALUE(userId, @"userId")
    SAFE_SET_VALUE(userName, @"userName")
    SAFE_SET_VALUE(userSex, @"userSex")
    SAFE_SET_VALUE(userTelephone, @"userTelephone")
    SAFE_SET_VALUE(userArea, @"userArea")
    
    [ProtocolBased requestPostWithParameters:params protocolString:kUserInfoUpdateUrl cacheMode:CACHE_MODE_NOCACHE UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        __REQUEST_ERROR__
        
        
        NSInteger statusCode = [responseObject safeStatusCodeForKey:@"status"];
        if (statusCode == 0) {
            NSString *msg = [responseObject safeStringForKey:@"data"];
            if (msg.length) {
                if (responseBlock) responseBlock(HttpResponseSuccess, msg);
            }else {
                __ERROR_MSG__(@"网络异常，请稍后再试！")
            }
        }else {
            __ERROR_HANDLE__(@"更新用户信息失败！")
        }
    }];
}

#pragma mark   登录与注册

// 第三方登录
+ (void)userLoginThirdPlatformWithOpenId:(NSString *)openId registerOrigin:(NSString *)registerOrigin birthday:(NSString *)birthday nickName:(NSString *)nickName headImageUrl:(NSString *)headImageUrl userSex:(NSString *)userSex UsingBlock:(HttpResponseBlock)responseBlock {
    DICT_PARAMS_DECLARE
    FIXED_PROTOCOL_REQUEST
    SAFE_SET_VALUE(openId, @"operId")
    SAFE_SET_VALUE(registerOrigin, @"registerOrigin")
    SAFE_SET_VALUE(birthday, @"userBirthStr")
    SAFE_SET_VALUE(nickName, @"userName")
    SAFE_SET_VALUE(headImageUrl, @"userHeadImgUrl")
    SAFE_SET_VALUE(userSex, @"userSex")
    
    [ProtocolBased requestPostWithParameters:params protocolString:kLoginThirdPlatformUrl cacheMode:CACHE_MODE_NOCACHE UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        __REQUEST_ERROR__
        
        NSInteger statusCode = [responseObject safeStatusCodeForKey:@"status"];
        if (statusCode == 0) {
            NSArray *listArray = [User instanceArrayFromDictArray:[responseObject safeArrayForKey:@"data"]];
            if (listArray.count) {
                if (responseBlock) responseBlock(HttpResponseSuccess, [listArray firstObject]);
             }else {
                __ERROR_MSG__(@"用户登录失败！")
            }
        }else {
            __ERROR_HANDLE__(@"网络出现异常,请稍后再试")
        }
    }];
}

// 文化云平台用户登录
+ (void)userLoginWithMobile:(NSString *)mobile password:(NSString *)password dynamicLogin:(BOOL)dynamicLogin UsingBlock:(HttpResponseBlock)responseBlock {
    DICT_PARAMS_DECLARE
    FIXED_PROTOCOL_REQUEST
    
    if (dynamicLogin) {
        // 动态登录
        SAFE_SET_VALUE(mobile, @"mobileNo")
        SAFE_SET_VALUE(password, @"code")
        
        [ProtocolBased requestPostWithJsonParameters:params protocolString:kLoginWenHuaYunDynamicUrl cacheMode:CACHE_MODE_NOCACHE UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
            __REQUEST_ERROR__
            
            NSInteger statusCode = [responseObject safeStatusCodeForKey:@"status"];
            if (statusCode == 1) {
                NSDictionary *resultDict = [responseObject safeDictForKey:@"data"];
                BOOL isSuccess = [[resultDict safeStringForKey:@"status"] isEqualToString:@"success"];
                if (isSuccess) {
                    /*
                       {
                          "status": "1",
                          "msg": null,
                          "data": {
                            "status": "success",
                            "userId": "92bb5d5f75b84c93afa2963ad8a3f733",
                            "errorCode": "",
                            "errorMsg": ""
                          }
                        }
                     */
                    User *user = [User new];
                    user.userId = [resultDict safeStringForKey:@"userId"];
                    if (user.userId.length) {
                        if (responseBlock) responseBlock(HttpResponseSuccess, user);
                    }else {
                        __ERROR_MSG__(@"用户信息为空!")
                    }
                }else {
                    /*
                        {
                          "status": "1",
                          "msg": null,
                          "data": {
                            "status": "error",
                            "errorCode": "1",
                            "errorMsg": "验证码不正确!"
                          }
                        }
                     */
                    NSString *errorStr = [resultDict safeStringForKey:@"errorMsg"];
                    if (errorStr.length < 1) {
                        errorStr = @"网络出现异常，请稍候再试!";
                    }
                    __ERROR_MSG__(errorStr)
                }
            }else {
                /*
                    data = "<null>";
                    msg =     {
                        errcode = 10800;
                        errmsg = "Unrecognized field \"sysVersion\" (Class com.culturecloud.model.request.common.UserLoginVO), not marked as ignorable\n at [Source: java.io.ByteArrayInputStream@2e11c35f; line: 1, column: 57] (through reference chain: com.culturecloud.model.request.common.UserLoginVO[\"sysVersion\"])";
                    };
                    status = 0;
                 */
                __ERROR_HANDLE__(@"网络连接出错，请稍后再试!")
            }
        }];
        
    }else {
        // 非动态登录
        SAFE_SET_VALUE(mobile, @"userMobileNo")
        SAFE_SET_VALUE(password, @"userPwd")
        
        [ProtocolBased requestPostWithParameters:params protocolString:kLoginWenHuaYunUrl cacheMode:CACHE_MODE_NOCACHE UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
            __REQUEST_ERROR__
            
            NSInteger statusCode = [responseObject safeStatusCodeForKey:@"status"];
            if (statusCode == 0) {
                NSArray *listArray = [User instanceArrayFromDictArray:[responseObject safeArrayForKey:@"data"]];
                if (listArray.count) {
                    if (responseBlock) responseBlock(HttpResponseSuccess, [listArray firstObject]);
                }else {
                    __ERROR_MSG__(@"网络出现异常,请稍候再试!")
                }
            }else {
                __ERROR_HANDLE__(@"用户登录失败！")
            }
        }];
    }
}

// 文化云平台用户注册
+ (void)userRegisterWithUserName:(NSString *)userName password:(NSString *)password mobile:(NSString *)mobile checkCode:(NSString *)checkCode UsingBlock:(HttpResponseBlock)responseBlock {
    DICT_PARAMS_DECLARE
    FIXED_PROTOCOL_REQUEST
    SAFE_SET_VALUE(userName, @"userName")
    SAFE_SET_VALUE(password, @"userPwd")
    SAFE_SET_VALUE(mobile, @"userMobileNo")
    SAFE_SET_VALUE(checkCode, @"code")
    
    [ProtocolBased requestPostWithParameters:params protocolString:kUserRegisterUrl cacheMode:CACHE_MODE_NOCACHE UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        __REQUEST_ERROR__
        
        NSInteger statusCode = [responseObject safeStatusCodeForKey:@"status"];
        if (statusCode == 0) {
            NSString *userId = [responseObject safeStringForKey:@"userId"];
            if (userId.length > 0) {
                if (responseBlock) responseBlock(HttpResponseSuccess, userId);
            }else {
                __ERROR_MSG__(@"注册失败,请稍候再试!")
            }
        }else {
            __ERROR_HANDLE__(@"用户注册失败")
        }
    }];
}


#pragma mark  密码

// 忘记密码时，重置密码
+ (void)resetUserPasswordWithMobile:(NSString *)mobile password:(NSString *)password checkCode:(NSString *)checkCode UsingBlock:(HttpResponseBlock)responseBlock {
    DICT_PARAMS_DECLARE
    FIXED_PROTOCOL_REQUEST
    SAFE_SET_VALUE(mobile, @"userMobileNo")
    SAFE_SET_VALUE(password, @"newPassword")
    SAFE_SET_VALUE(checkCode, @"code")
    
    [ProtocolBased requestPostWithParameters:params protocolString:kFindPasswordEditPasswordUrl cacheMode:CACHE_MODE_NOCACHE UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        __REQUEST_ERROR__
        
        NSInteger statusCode = [responseObject safeStatusCodeForKey:@"status"];
        if (statusCode == 0) {
            if (responseBlock) responseBlock(HttpResponseSuccess, @"密码重置成功！");
        }else {
            __ERROR_HANDLE__(@"找回密码失败！")
        }
    }];
}

// 修改密码
+ (void)updatePasswordWithUserId:(NSString *)userId password:(NSString *)password newPassword:(NSString *)newPassword UsingBlock:(HttpResponseBlock)responseBlock {
    DICT_PARAMS_DECLARE
    FIXED_PROTOCOL_REQUEST
    SAFE_SET_VALUE(userId, @"userId")
    SAFE_SET_VALUE(password, @"password")
    SAFE_SET_VALUE(newPassword, @"newPassword")
    
    [ProtocolBased requestPostWithParameters:params protocolString:kChangePasswordUrl cacheMode:CACHE_MODE_NOCACHE UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        __REQUEST_ERROR__
        
        NSInteger statusCode = [responseObject safeStatusCodeForKey:@"status"];
        if (statusCode == 0) {
            if (responseBlock) responseBlock(HttpResponseSuccess, @"密码修改成功！");
        }else {
            __ERROR_HANDLE__(@"修改密码失败！")
        }
    }];
}


#pragma mark  我的消息

// 获取用户消息
+ (void)getUserMessageWithUserId:(NSString *)userId UsingBlock:(HttpResponseBlock)responseBlock {
    DICT_PARAMS_DECLARE
    FIXED_PROTOCOL_REQUEST
    SAFE_SET_VALUE(userId, @"userId")
    
    [ProtocolBased requestPostWithParameters:params protocolString:kUserMessageUrl cacheMode:CACHE_MODE_REALTIME UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        __REQUEST_ERROR__
        
        NSInteger statusCode = [responseObject safeStatusCodeForKey:@"status"];
        if (statusCode == 0) {
            NSArray *listArray = [UserMessage instanceArrayFromDictArray:[responseObject safeArrayForKey:@"data"]];
            if (responseBlock) responseBlock(HttpResponseSuccess, listArray);
        }else {
            __ERROR_HANDLE__(@"获取用户消息失败！")
        }
    }];
}

// 获取推送给用户的消息条数
+ (void)getUserMessageNumberWithUserId:(NSString *)userId UsingBlock:(HttpResponseBlock)responseBlock {
    DICT_PARAMS_DECLARE
    FIXED_PROTOCOL_REQUEST
    SAFE_SET_VALUE(userId, @"userId")
    
    [ProtocolBased requestPostWithParameters:params protocolString:kUserMessageUrl cacheMode:CACHE_MODE_REALTIME UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        __REQUEST_ERROR__
        
        NSInteger statusCode = [responseObject safeStatusCodeForKey:@"status"];
        if (statusCode == 0) {
            if (responseObject[@"pageTotal"] != nil && responseObject[@"pageTotal"] != NULL) {
                NSInteger pageTotal = [responseObject safeIntegerForKey:@"pageTotal"];
                if (responseBlock) responseBlock(HttpResponseSuccess, [NSNumber numberWithInteger:pageTotal]);
            }else {
                __ERROR_MSG__(@"获取消息条数失败!")
            }
        }else {
            __ERROR_HANDLE__(@"获取用户消息条数失败！")
        }
    }];
}

// 删除用户消息
+ (void)userMessageDeleteWithMsgId:(NSString *)msgId UsingBlock:(HttpResponseBlock)responseBlock {
    DICT_PARAMS_DECLARE
    FIXED_PROTOCOL_REQUEST
    SAFE_SET_VALUE(msgId, @"userMessageId")
    
    [ProtocolBased requestPostWithParameters:params protocolString:kDeleteUserInfoUrl cacheMode:CACHE_MODE_NOCACHE UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        __REQUEST_ERROR__
        
        NSInteger statusCode = [responseObject safeStatusCodeForKey:@"status"];
        if (statusCode == 0) {
            if (responseBlock) responseBlock(HttpResponseSuccess, @"删除消息成功！");
        }else {
            __ERROR_HANDLE__(@"删除用户信息失败！")
        }
    }];
}

#pragma mark  我的订单

// 获取订单列表接口(3.5.2)
+ (void)getUserOrderListWithType:(NSInteger)orderType pageIndex:(NSInteger)pageIndex pageNum:(NSInteger)pageNum cacheMode:(EnumCacheMode)cacheMode UsingBlock:(HttpResponseBlock)responseBlock {
    NSString *url = nil;
    if (orderType == 1) {
        url = kUserOrderUncheckedUrl;
    }else if (orderType == 2) {
        url = kUserOrderUnPayedUrl;
    }else if (orderType == 3) {
        url = kUserOrderUnParticipateUrl;
    }else if (orderType == 4) {
        url = kUserOrderHistoryUrl;
    }else {
        return;
    }
    
    DICT_PARAMS_DECLARE
    SAFE_SET_VALUE([UserService sharedService].userId, @"userId")
    SAFE_SET_VALUE(StrFromLong(pageIndex) , @"pageIndex")
    SAFE_SET_VALUE(StrFromLong(pageNum) , @"pageNum")
    
    [ProtocolBased requestPostWithParameters:params protocolString:url cacheMode:cacheMode UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        __REQUEST_ERROR__
        
        NSInteger statusCode = [responseObject safeStatusCodeForKey:@"status"];
        if (statusCode == 1) {
            NSMutableArray *listArray = [NSMutableArray arrayWithCapacity:0];
            
            if (orderType == 1) { // 待审核
                [listArray addObjectsFromArray:[MyOrderModel listArrayFromDictArray:[responseObject safeArrayForKey:@"data"] withType:DataTypeVenue]];
            }else if (orderType == 2) { // 待支付
                [listArray addObjectsFromArray:[MyOrderModel listArrayFromDictArray:[responseObject safeArrayForKey:@"data"] withType:DataTypeActivity]];
            }else { // 待参加、历史
                [listArray addObjectsFromArray:[MyOrderModel listArrayFromDictArray:[responseObject safeArrayForKey:@"data"] withType:DataTypeActivity]];
                [listArray addObjectsFromArray:[MyOrderModel listArrayFromDictArray:[responseObject safeArrayForKey:@"data1"] withType:DataTypeVenue]];
            }
            
            NSInteger pageTotal = MAX([responseObject safeIntegerForKey:@"pageTotal"], listArray.count);
            
            if (responseBlock) {
                responseBlock(HttpResponseSuccess, @[StrFromInt(pageTotal),[MyOrderModel sortedOrderListWithModels:listArray]]);
            }
            
        }else {
            __ERROR_HANDLE__(@"获取订单列表失败！")
        }
    }];
}

// 获取订单的详情(3.5.2)
+ (void)getUserOrderDetailWithDataType:(DataType)dataType orderId:(NSString *)orderId  UsingBlock:(HttpResponseBlock)responseBlock {
    DICT_PARAMS_DECLARE
    SAFE_SET_VALUE([UserService sharedService].userId, @"userId")
    
    NSString *url = nil;
    if (dataType == DataTypeActivity) {
        url = kUserOrderDetailActivityUrl;
        SAFE_SET_VALUE(orderId, @"activityOrderId")
    }else if (dataType == DataTypeVenue) {
        url = kUserOrderDetailVenueUrl;
        SAFE_SET_VALUE(orderId, @"roomOrderId")
    }else {
        __ERROR_MSG__(@"参数缺失!")
    }
    
    [ProtocolBased requestPostWithParameters:params protocolString:url cacheMode:CACHE_MODE_NOCACHE UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        __REQUEST_ERROR__
        
        NSInteger statusCode = [responseObject safeStatusCodeForKey:@"status"];
        if (statusCode == 200) {
            if (dataType == DataTypeActivity) {
                ActOrderDetailModel *model = [[ActOrderDetailModel alloc] initWithAttributes:[responseObject safeDictForKey:@"data"]];
                if (responseBlock) {
                    responseBlock(HttpResponseSuccess, model);
                }
            }else if (dataType == DataTypeVenue) {
                OrderDetailModel *model = [[OrderDetailModel alloc] initWithAttributes:[responseObject safeDictForKey:@"data"] type:dataType];
                if (responseBlock) {
                    responseBlock(HttpResponseSuccess, model);
                }
            }
            
        }else {
            __ERROR_HANDLE__(@"获取订单详情失败！")
        }
    }];
}

// 取消用户订单
+ (void)cancelUserOrderWithDataType:(DataType)dataType orderId:(NSString *)orderId orderSeats:(NSString *)orderSeats UsingBlock:(HttpResponseBlock)responseBlock {
    DICT_PARAMS_DECLARE
    SAFE_SET_VALUE([UserService sharedService].userId, @"userId")
    
    NSString *url = nil;
    if (dataType == DataTypeActivity) {
        url = kCancelActivityUrl;
        SAFE_SET_VALUE(orderId, @"activityOrderId")
        SAFE_SET_VALUE(orderSeats, @"orderSeat")
    }else if (dataType == DataTypeVenue) {
        url = kCancelPlayRoomUrl;
        SAFE_SET_VALUE(orderId, @"roomOrderId")
    }else {
        __ERROR_MSG__(@"请求参数缺失！")
    }
    
    [ProtocolBased requestPostWithParameters:params protocolString:url cacheMode:CACHE_MODE_NOCACHE UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        __REQUEST_ERROR__
        
        NSInteger statusCode = [responseObject safeStatusCodeForKey:@"status"];
        if (statusCode == 0) {
            NSString *msg = [responseObject safeStringForKey:@"data"];
            if (msg.length == 0) {
                msg = @"订单取消成功!";
            }
            if (responseBlock) responseBlock(HttpResponseSuccess, msg);
        }else {
            __ERROR_HANDLE__(@"取消订单失败！");
        }
    }];
}

// 删除用户订单
+ (void)deleteUserOrderWithDataType:(DataType)dataType orderId:(NSString *)orderId UsingBlock:(HttpResponseBlock)responseBlock {
    DICT_PARAMS_DECLARE
    SAFE_SET_VALUE([UserService sharedService].userId, @"userId")
    
    NSString *url = nil;
    if (dataType == DataTypeActivity) {
        url = kDeleteActivityHistoryOrder;
        SAFE_SET_VALUE(orderId, @"activityOrderId")
    }else if (dataType == DataTypeVenue) {
        url = kDeletePlayRoomHistoryOrder;
        SAFE_SET_VALUE(orderId, @"roomOrderId")
    }else {
        __ERROR_MSG__(@"请求参数缺失！")
    }
    
    [ProtocolBased requestPostWithParameters:params protocolString:url cacheMode:CACHE_MODE_NOCACHE UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        __REQUEST_ERROR__
        
        NSInteger statusCode = [responseObject safeStatusCodeForKey:@"status"];
        if (statusCode == 0) {
            NSString *msg = [responseObject safeStringForKey:@"data"];
            if (msg.length == 0) {
                msg = @"订单删除成功!";
            }
            if (responseBlock) responseBlock(HttpResponseSuccess, msg);
        }else {
            __ERROR_HANDLE__(@"删除订单失败！");
        }
    }];
}


#pragma mark  我的收藏

// 我的收藏列表
+ (void)getUserCollectListWithDataType:(DataType)dataType searchKey:(NSString *)searchKey pageIndex:(NSInteger)pageIndex pageNum:(NSInteger)pageNum cacheMode:(EnumCacheMode)cacheMode UsingBlock:(HttpResponseBlock)responseBlock {
    DICT_PARAMS_DECLARE
    SAFE_SET_VALUE([UserService sharedService].userId, @"userId")
    SAFE_SET_VALUE(StrFromLong(pageIndex), @"pageIndex")
    SAFE_SET_VALUE(StrFromLong(pageNum), @"pageNum")
    
    NSString *url = nil;
    if (dataType == DataTypeActivity) {
        url = kUserCollectActivityUrl;
        SAFE_SET_VALUE(searchKey, @"activityName")
    }else if (dataType == DataTypeVenue) {
        url = kUserCollectExhibitionHallUrl;
        SAFE_SET_VALUE(searchKey, @"venueName")
    }else {
        __ERROR_MSG__(@"请求参数缺失！")
    }
    
    [ProtocolBased requestPostWithParameters:params protocolString:url cacheMode:cacheMode UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        __REQUEST_ERROR__
        
        NSInteger statusCode = [responseObject safeStatusCodeForKey:@"status"];
        if (statusCode == 0) {
            NSArray *listArray = [UserCollectModel instanceArrayFromDictArray:[responseObject safeArrayForKey:@"data"] withType:dataType];
            if (responseBlock) responseBlock(HttpResponseSuccess, listArray);
        }else {
            __ERROR_HANDLE__(@"获取收藏列表失败！");
        }
    }];
}

// 取消收藏
+ (void)cancelCollectWithDataType:(DataType)dataType modelId:(NSString *)modelId UsingBlock:(HttpResponseBlock)responseBlock {
    DICT_PARAMS_DECLARE
    SAFE_SET_VALUE([UserService sharedService].userId, @"userId")
    
    NSString *url = nil;
    if (dataType == DataTypeActivity) {
        url = kCancelCollectActivityUrl;
        SAFE_SET_VALUE(modelId, @"activityId")
    }else if (dataType == DataTypeVenue) {
        url = kCancelCollectExhibitionHallUrl;
        SAFE_SET_VALUE(modelId, @"venueId")
    }else {
        __ERROR_MSG__(@"请求参数缺失！")
    }
    
    [ProtocolBased requestPostWithParameters:params protocolString:url cacheMode:CACHE_MODE_NOCACHE UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        __REQUEST_ERROR__
        
        NSInteger statusCode = [responseObject safeStatusCodeForKey:@"status"];
        if (statusCode == 0) {
            NSString *msg = [responseObject safeStringForKey:@"data"];
            if (msg.length == 0) {
                msg = @"取消收藏成功!";
            }
            if (responseBlock) responseBlock(HttpResponseSuccess, msg);
        }else {
            __ERROR_HANDLE__(@"取消收藏失败！");
        }
    }];
}

#pragma mark  我的评论

// 我的评论列表
+ (void)getUserCommentListWithDataType:(DataType)dataType pageIndex:(NSInteger)pageIndex pageNum:(NSInteger)pageNum cacheMode:(EnumCacheMode)cacheMode UsingBlock:(HttpResponseBlock)responseBlock {
    DICT_PARAMS_DECLARE
    SAFE_SET_VALUE([UserService sharedService].userId, @"userId")
    SAFE_SET_VALUE(StrFromLong(pageIndex), @"pageIndex")
    SAFE_SET_VALUE(StrFromLong(pageNum), @"pageNum")
    
    NSString *url = nil;
    if (dataType == DataTypeActivity) {
        url = kUserCommentListActivityUrl;
    }else if (dataType == DataTypeVenue) {
        url = kUserCommentListVenueUrl;
    }else {
        __ERROR_MSG__(@"请求参数缺失！")
    }
    
    [ProtocolBased requestPostWithParameters:params protocolString:url cacheMode:cacheMode UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        __REQUEST_ERROR__
        
        NSInteger statusCode = [responseObject safeStatusCodeForKey:@"status"];
        if (statusCode == 1) {
            NSArray *listArray = [MyCommentModel instanceArrayFromDictArray:responseObject[@"data"] withType:dataType];
            if (responseBlock) responseBlock(HttpResponseSuccess, listArray);
        }else {
            __ERROR_HANDLE__(@"获取评论列表失败！");
        }
    }];
}

// 删除用户评论
+ (void)deleteUserCommentWithDataType:(DataType)dataType commentId:(NSString *)commentId UsingBlock:(HttpResponseBlock)responseBlock {
    DICT_PARAMS_DECLARE
    SAFE_SET_VALUE([UserService sharedService].userId, @"userId")
    SAFE_SET_VALUE(commentId, @"commentId")
    
    NSString *url = nil;
    if (dataType == DataTypeActivity) {
        url = kUserCommentDeleteActivityUrl;
    }else if (dataType == DataTypeVenue) {
        url = kUserCommentDeleteVenueUrl;
    }else {
        __ERROR_MSG__(@"请求参数缺失！")
    }
    
    [ProtocolBased requestPostWithParameters:params protocolString:url cacheMode:CACHE_MODE_NOCACHE UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        __REQUEST_ERROR__
        
        NSInteger statusCode = [responseObject safeStatusCodeForKey:@"status"];
        if (statusCode == 1) {
            NSString *msg = [responseObject safeStringForKey:@"data"];
            if (msg.length == 0) {
                msg = @"评论删除成功!";
            }
            if (responseBlock) responseBlock(HttpResponseSuccess, msg);
        }else {
            __ERROR_HANDLE__(@"评论删除失败！");
        }
    }];
}

// 详情页评论列表
+ (void)getCommentListOfDetailPageWithDataType:(DataType)dataType modelId:(NSString *)modelId pageIndex:(NSInteger)pageIndex pageNum:(NSInteger)pageNum cacheMode:(EnumCacheMode)cacheMode UsingBlock:(HttpResponseBlock)responseBlock {
    DICT_PARAMS_DECLARE
    SAFE_SET_VALUE(modelId, @"moldId")
    SAFE_SET_VALUE(StrFromLong(pageIndex), @"pageIndex")
    SAFE_SET_VALUE(StrFromLong(pageNum), @"pageNum")
    
    // 1-场馆  2-活动
    if (dataType == DataTypeActivity) {
        SAFE_SET_VALUE(@"2", @"type")
    }else if (dataType == DataTypeVenue) {
        SAFE_SET_VALUE(@"1", @"type")
    }else {
        __ERROR_MSG__(@"请求参数错误！")
    }
    
    [ProtocolBased requestPostWithParameters:params protocolString:kCommentListOfDetailPageUrl cacheMode:cacheMode UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        __REQUEST_ERROR__
        
        NSInteger statusCode = [responseObject safeStatusCodeForKey:@"status"];
        if (statusCode == 0) {
            NSArray *listArray = [CommentModel instanceArrayFromDictArray:[responseObject safeArrayForKey:@"data"]];
            NSInteger pageTotal = MAX([responseObject safeIntegerForKey:@"pageTotal"], listArray.count);
            if (responseBlock) responseBlock(HttpResponseSuccess, @[[NSNumber numberWithInteger:pageTotal], listArray]);
        }else {
            __ERROR_HANDLE__(@"获取评论列表失败！");
        }
    }];
}

// 发表评论
+ (void)publishCommentWithDataType:(DataType)dataType modelId:(NSString *)modelId commentContent:(NSString *)commentContent commentImageUrls:(NSString *)commentImageUrls commentStarLevel:(NSString *)commentStarLevel UsingBlock:(HttpResponseBlock)responseBlock {
    DICT_PARAMS_DECLARE
    SAFE_SET_VALUE([UserService sharedService].userId, @"commentUserId")
    SAFE_SET_VALUE(modelId, @"commentRkId")
    SAFE_SET_VALUE(commentContent, @"commentRemark")
    SAFE_SET_VALUE(commentImageUrls, @"commentImgUrl")
    SAFE_SET_VALUE(commentStarLevel, @"commentStar")
    
    if (dataType == DataTypeActivity) {
        SAFE_SET_VALUE(@"2", @"commentType")
    }else if (dataType == DataTypeVenue) {
        SAFE_SET_VALUE(@"1", @"commentType")
    }else {
        __ERROR_MSG__(@"请求参数错误！")
    }
    
    [ProtocolBased requestPostWithParameters:params protocolString:kCommentPublishUrl cacheMode:CACHE_MODE_NOCACHE UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        __REQUEST_ERROR__
        
        NSInteger statusCode = [responseObject safeStatusCodeForKey:@"status"];
        if (statusCode == 0) {
            NSString *msg = [responseObject safeStringForKey:@"data"];
            if (msg.length == 0) {
                msg = @"评论发表成功！";
            }
            if (responseBlock) responseBlock(HttpResponseSuccess, msg);
        }else {
            __ERROR_HANDLE__(@"发表评论失败！");
        }
    }];
}


#pragma mark  我的积分

// 获取用户的积分值
+ (void)getUserIntegralWithUserId:(NSString *)userId UsingBlock:(HttpResponseBlock)responseBlock {
    DICT_PARAMS_DECLARE
    FIXED_PROTOCOL_REQUEST
    SAFE_SET_VALUE(userId, @"userId")
    SAFE_SET_VALUE(@"User_Accumulative_Score", @"UnusedKey")
    
    [ProtocolBased requestPostWithParameters:params protocolString:kUserInfoByUserIdUrl cacheMode:CACHE_MODE_NOCACHE UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        __REQUEST_ERROR__
        
        NSInteger statusCode = [responseObject safeStatusCodeForKey:@"status"];
        if (statusCode == 0) {
            NSArray *listArray = [User instanceArrayFromDictArray:[responseObject safeArrayForKey:@"data"]];
            if (listArray.count > 0) {
                if (responseBlock) {
                    User *user = [listArray firstObject];
                    responseBlock(HttpResponseSuccess, StrFromLong(user.userIntegral));
                }
            }else {
                __ERROR_MSG__(@"网络出现异常,请稍候再试!")
            }
        }else {
            __ERROR_HANDLE__(@"获取用户的积分值失败！")
        }
    }];
}

// 获取用户的积分明细列表
+ (void)getUserIntegralListWithType:(NSInteger)listType pageIndex:(NSInteger)pageIndex pageNum:(NSInteger)pageNum cacheMode:(EnumCacheMode)cacheMode UsingBlock:(HttpResponseBlock)responseBlock {
    DICT_PARAMS_DECLARE
    SAFE_SET_VALUE([UserService sharedService].userId, @"userId")
    SAFE_SET_VALUE(StrFromLong(pageIndex), @"pageIndex")
    SAFE_SET_VALUE(StrFromLong(pageNum), @"pageNum")
    
    NSString *url = nil;
    if (listType == 1) {
        url = [NSString stringWithFormat:@"%@%@", kProtocolFixedUrl, kUserAccumulativeScoreRecentlUrl];
    }else if (listType == 2) {
        url = [NSString stringWithFormat:@"%@%@", kProtocolFixedUrl, kUserAccumulativeScoreListUrl];
    }else {
        __ERROR_MSG__(@"请求参数错误！")
    }
    
    [ProtocolBased requestPostWithParameters:params protocolString:url cacheMode:cacheMode UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        __REQUEST_ERROR__
        
        NSInteger statusCode = [responseObject safeStatusCodeForKey:@"status"];
        if (statusCode == 1) {
            NSDictionary *resultDict = [responseObject safeDictForKey:@"data"];
            
            // 保存用户的当前总积分
            User *aUser = [UserService sharedService].user;
            aUser.userIntegral = [resultDict safeIntegerForKey:@"integralNow"];
            [UserService saveUser:aUser];
            
            NSArray *listArray = [UserAccumulativeScoreModel instanceArrayFromDictArray:[resultDict safeArrayForKey:@"userIntegralDetails"]];
            if (responseBlock) responseBlock(HttpResponseSuccess, listArray);
        }else {
            __ERROR_HANDLE__(@"获取积分明细列表失败！");
        }
    }];
}

#pragma mark  其它

// 用户意见反馈
+ (void)userFeedbackWithFeedContent:(NSString *)feedContent feedImgUrl:(NSString *)feedImgUrl feedType:(NSString *)feedType UsingBlock:(HttpResponseBlock)responseBlock {
    DICT_PARAMS_DECLARE
    FIXED_PROTOCOL_REQUEST
    SAFE_SET_VALUE([UserService sharedService].userId, @"userId")
    SAFE_SET_VALUE(feedContent, @"feedContent")
    SAFE_SET_VALUE(feedImgUrl, @"feedImgUrl")
    SAFE_SET_VALUE(feedType, @"feedType")
    
    [ProtocolBased requestPostWithParameters:params protocolString:kUserFeedBackUrl cacheMode:CACHE_MODE_NOCACHE UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        __REQUEST_ERROR__
        
        NSInteger statusCode = [responseObject safeStatusCodeForKey:@"status"];
        if (statusCode == 0) {
            if (responseBlock) responseBlock(HttpResponseSuccess, @"您提交的建议已反馈，谢谢您的支持!");
        }else {
            __ERROR_HANDLE__(@"反馈信息提交失败！")
        }
    }];
}


#pragma mark - ———————————————————  活动列表  —————————————————————

// 首页的猜你喜欢活动列表
+ (void)getActivityYouMayLoveWithPageIndex:(NSInteger)pageIndex pageNum:(NSInteger)pageNum cacheMode:(EnumCacheMode)cacheMode UsingBlock:(HttpResponseBlock)responseBlock {
    DICT_PARAMS_DECLARE
    UserService *userInfo = [UserService sharedService];
    SAFE_SET_VALUE(userInfo.userId, @"userId")
    SAFE_SET_VALUE(userInfo.latitudeStr, @"lat")
    SAFE_SET_VALUE(userInfo.longitudeStr, @"lon")
    SAFE_SET_VALUE(StrFromLong(pageIndex), @"resultIndex")
    SAFE_SET_VALUE(StrFromLong(pageNum), @"resultSize")
    
    [ProtocolBased requestPostWithJsonParameters:params protocolString:kActivityYouMayLoveUrl cacheMode:cacheMode UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        __REQUEST_ERROR__
        
        NSInteger statusCode = [responseObject safeStatusCodeForKey:@"status"];
        if (statusCode == 1) {
            NSArray *listArray = [ActivityModel listArrayWithArray:[responseObject safeArrayForKey:@"data"]];
            if (responseBlock) responseBlock(HttpResponseSuccess, listArray);
        }else {
            __ERROR_HANDLE__(@"获取活动列表失败！")
        }
    }];
}

// 置顶活动列表
+ (void)getTopAcitivityListWithActivityTag:(NSString *)activityTag sortType:(NSString *)sortType activityArea:(NSString *)activityArea activityLocation:(NSString *)activityLocation activityIsReservation:(NSString *)activityIsReservation activityIsFree:(NSString *)activityIsFree pageIndex:(NSInteger)pageIndex pageNum:(NSInteger)pageNum cacheMode:(EnumCacheMode)cacheMode UsingBlock:(HttpResponseBlock)responseBlock {
    DICT_PARAMS_DECLARE
    UserService *userInfo = [UserService sharedService];
    SAFE_SET_VALUE(userInfo.userId, @"userId")
    SAFE_SET_VALUE(userInfo.latitudeStr, @"Lat")
    SAFE_SET_VALUE(userInfo.longitudeStr, @"Lon")
    SAFE_SET_VALUE(StrFromLong(pageIndex), @"pageIndex")
    SAFE_SET_VALUE(StrFromLong(pageNum), @"pageNum")
    
    SAFE_SET_VALUE(activityTag, @"tagId")
    SAFE_SET_VALUE(sortType, @"sortType")
    SAFE_SET_VALUE(activityArea, @"activityArea")
    SAFE_SET_VALUE(activityLocation, @"activityLocation")
    SAFE_SET_VALUE(activityIsReservation, @"activityIsReservation")
    SAFE_SET_VALUE(activityIsFree, @"activityIsFree")
    
    [ProtocolBased requestPostWithParameters:params protocolString:kTopActivityUrl cacheMode:cacheMode UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        __REQUEST_ERROR__
        
        NSInteger statusCode = [responseObject safeStatusCodeForKey:@"status"];
        if (statusCode == 0) {
            NSArray *listArray = [ActivityModel listArrayWithArray:[responseObject safeArrayForKey:@"data"]];
            if (responseBlock) responseBlock(HttpResponseSuccess, listArray);
        }else {
            __ERROR_HANDLE__(@"获取活动列表失败！")
        }
    }];
}

// 首页推荐活动
+ (void)getActivityRecommendedWithPageIndex:(NSInteger)pageIndex pageNum:(NSInteger)pageNum cacheMode:(EnumCacheMode)cacheMode UsingBlock:(HttpResponseBlock)responseBlock {
    DICT_PARAMS_DECLARE
    UserService *userInfo = [UserService sharedService];
    SAFE_SET_VALUE(@"0", @"tagId")
    SAFE_SET_VALUE(userInfo.userId, @"userId")
    SAFE_SET_VALUE(userInfo.latitudeStr, @"Lat")
    SAFE_SET_VALUE(userInfo.longitudeStr, @"Lon")
    SAFE_SET_VALUE(StrFromLong(pageIndex), @"pageIndex")
    SAFE_SET_VALUE(StrFromLong(pageNum), @"pageNum")

    [ProtocolBased requestPostWithParameters:params protocolString:kRecommendActivityUrl cacheMode:cacheMode UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        __REQUEST_ERROR__
        
        NSInteger statusCode = [responseObject safeStatusCodeForKey:@"status"];
        if (statusCode == 0) {
            NSArray *listArray = [ActivityModel listArrayWithArray:[responseObject safeArrayForKey:@"data"]];
            if (responseBlock) responseBlock(HttpResponseSuccess, listArray);
        }else {
            __ERROR_HANDLE__(@"获取活动列表失败！")
        }
    }];
}

// 推荐筛选活动列表
+ (void)getRecommendFilterActivityWithActivityArea:(NSString *)activityArea activityLocation:(NSString *)activityLocation activityIsFree:(NSString *)activityIsFree activityIsReservation:(NSString *)activityIsReservation sortType:(NSString *)sortType pageIndex:(NSInteger)pageIndex pageNum:(NSInteger)pageNum cacheMode:(EnumCacheMode)cacheMode UsingBlock:(HttpResponseBlock)responseBlock {
    DICT_PARAMS_DECLARE
    UserService *userInfo = [UserService sharedService];
    SAFE_SET_VALUE(userInfo.userId, @"userId")
    SAFE_SET_VALUE(userInfo.latitudeStr, @"Lat")
    SAFE_SET_VALUE(userInfo.longitudeStr, @"Lon")
    SAFE_SET_VALUE(StrFromLong(pageIndex), @"pageIndex")
    SAFE_SET_VALUE(StrFromLong(pageNum), @"pageNum")
    
    SAFE_SET_VALUE(activityArea, @"activityArea")
    SAFE_SET_VALUE(activityLocation, @"activityLocation")
    SAFE_SET_VALUE(activityIsFree, @"activityIsFree")
    SAFE_SET_VALUE(activityIsReservation, @"activityIsReservation")
    SAFE_SET_VALUE(sortType, @"sortType")
    
    [ProtocolBased requestPostWithParameters:params protocolString:kRecommendActivityWithFilterUrl cacheMode:cacheMode UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        __REQUEST_ERROR__
        
        NSInteger statusCode = [responseObject safeStatusCodeForKey:@"status"];
        if (statusCode == 0) {
            NSArray *listArray = [ActivityModel listArrayWithArray:[responseObject safeArrayForKey:@"data"]];
            if (responseBlock) responseBlock(HttpResponseSuccess, listArray);
        }else {
            __ERROR_HANDLE__(@"获取活动列表失败！")
        }
    }];
}

// 日历页获取每天的活动数量
+ (void)getActivityCountByDayWithStartDate:(NSString *)startDate endDate:(NSString *)endDate cacheMode:(EnumCacheMode)cacheMode UsingBlock:(HttpResponseBlock)responseBlock {
    DICT_PARAMS_DECLARE
    SAFE_SET_VALUE([UserService sharedService].userId, @"userId")
    SAFE_SET_VALUE(startDate, @"startDate")
    SAFE_SET_VALUE(endDate, @"endDate")
    SAFE_SET_VALUE(@"3.6", @"version")
    
    [ProtocolBased requestPostWithParameters:params protocolString:kAppEveryDateActivityCount cacheMode:cacheMode UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        __REQUEST_ERROR__
        
        NSInteger statusCode = [responseObject safeStatusCodeForKey:@"status"];
        if (statusCode == 1) {
            NSDictionary *resultDict = [responseObject safeDictForKey:@"data"];
            if (responseBlock) responseBlock(HttpResponseSuccess, resultDict);
        }else {
            __ERROR_HANDLE__(@"获取活动列表失败！")
        }
    }];
}


// 日期查询活动列表(暂时不用)
+ (void)getActivityListByDayWithActivityArea:(NSString *)activityArea activityLocation:(NSString *)activityLocation activityType:(NSString *)activityType activityIsFree:(NSString *)activityIsFree activityIsReservation:(NSString *)activityIsReservation startDate:(NSString *)startDate endDate:(NSString *)endDate pageIndex:(NSInteger)pageIndex pageNum:(NSInteger)pageNum cacheMode:(EnumCacheMode)cacheMode UsingBlock:(HttpResponseBlock)responseBlock {
    DICT_PARAMS_DECLARE
    UserService *userInfo = [UserService sharedService];
    SAFE_SET_VALUE(userInfo.userId, @"userId")
    SAFE_SET_VALUE(userInfo.latitudeStr, @"Lat")
    SAFE_SET_VALUE(userInfo.longitudeStr, @"Lon")
    SAFE_SET_VALUE(StrFromLong(pageIndex), @"pageIndex")
    SAFE_SET_VALUE(StrFromLong(pageNum), @"pageNum")
    
    SAFE_SET_VALUE(activityArea, @"activityArea")
    SAFE_SET_VALUE(activityLocation, @"activityLocation")
    SAFE_SET_VALUE(activityType, @"activityType")
    SAFE_SET_VALUE(activityIsFree, @"activityIsFree")
    SAFE_SET_VALUE(activityIsReservation, @"activityIsReservation")
    SAFE_SET_VALUE(startDate, @"startDate")
    SAFE_SET_VALUE(endDate, @"endDate")
    
    // kAppEveryDateActivityList
    [ProtocolBased requestPostWithParameters:params protocolString:@"" cacheMode:cacheMode UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        __REQUEST_ERROR__
        
        NSInteger statusCode = [responseObject safeStatusCodeForKey:@"status"];
        if (statusCode == 100) {
            NSArray *listArray = [ActivityModel listArrayWithArray:[responseObject safeArrayForKey:@"data"]];
            if (responseBlock) responseBlock(HttpResponseSuccess, listArray);
        }else {
            __ERROR_HANDLE__(@"获取活动列表失败！")
        }
    }];
}

// 附近地点活动列表
+ (void)getNearbyActivityListWithActivityType:(NSString *)activityType sortType:(NSString *)sortType activityIsFree:(NSString *)activityIsFree activityIsReservation:(NSString *)activityIsReservation pageIndex:(NSInteger)pageIndex pageNum:(NSInteger)pageNum cacheMode:(EnumCacheMode)cacheMode UsingBlock:(HttpResponseBlock)responseBlock {
    DICT_PARAMS_DECLARE
    SAFE_SET_VALUE(@"1", @"appType")
    UserService *userInfo = [UserService sharedService];
    SAFE_SET_VALUE(userInfo.userId, @"userId")
    SAFE_SET_VALUE(userInfo.latitudeStr, @"Lat")
    SAFE_SET_VALUE(userInfo.longitudeStr, @"Lon")
    SAFE_SET_VALUE(StrFromLong(pageIndex), @"pageIndex")
    SAFE_SET_VALUE(StrFromLong(pageNum), @"pageNum")
    
    SAFE_SET_VALUE(activityType, @"activityType")
    SAFE_SET_VALUE(sortType, @"sortType")
    SAFE_SET_VALUE(activityIsFree, @"activityIsFree")
    SAFE_SET_VALUE(activityIsReservation, @"activityIsReservation")
    
    [ProtocolBased requestPostWithParameters:params protocolString:kNearLocationActivityAllUrl cacheMode:cacheMode UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        __REQUEST_ERROR__
        
        NSInteger statusCode = [responseObject safeStatusCodeForKey:@"status"];
        if (statusCode == 1) {
            NSArray *listArray = [ActivityModel listArrayWithArray:[responseObject safeArrayForKey:@"data"]];
            if (responseBlock) responseBlock(HttpResponseSuccess, listArray);
        }else {
            __ERROR_HANDLE__(@"获取活动列表失败！")
        }
    }];
}

// 活动列表插入的标签
+ (void)getActivityListInsertTagWithActivityTag:(NSString *)activityTag cacheMode:(EnumCacheMode)cacheMode UsingBlock:(HttpResponseBlock)responseBlock {
    DICT_PARAMS_DECLARE
    SAFE_SET_VALUE(activityTag, @"tagId")
    
    [ProtocolBased requestPostWithParameters:params protocolString:kActivityListInsertTagUrl cacheMode:cacheMode UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        __REQUEST_ERROR__
        
        NSInteger statusCode = [responseObject safeStatusCodeForKey:@"status"];
        if (statusCode == 200) {
            NSArray *jsonList = [responseObject safeArrayForKey:@"data"];
            NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:jsonList.count];
            
            NSString *protocolUrl = kProtocolUrl;
            for (NSDictionary *dict in jsonList) {
                if ([dict isKindOfClass:[NSDictionary class]]) {
                    AdvertModel *model = [AdvertModel new];
                    model.isOuterLink = YES;
                    model.advertName = [dict safeStringForKey:@"title"];
                    
                    model.advUrl = [NSString stringWithFormat:@"%@wechatActivity/preActivityListTagSub.do?activityType=%@&advertTitle=%@", protocolUrl, [dict safeStringForKey:@"tagSubId"], model.advertName];
                    
                    if (model.advertName.length > 0 && [model.advUrl hasPrefix:@"http"]) {
                        [tmpArray addObject:model];
                    }
                }
            }
            
            if (responseBlock) responseBlock(HttpResponseSuccess, tmpArray);
        }else {
            __ERROR_HANDLE__(@"获取活动列表插入标签失败！")
        }
    }];
}



#pragma mark - ———————————————————  文化日历  —————————————————————

// 文化日历列表
+ (void)getCultureCalendarListWithDate:(NSString *)date activityType:(NSString *)activityType pageIndex:(NSInteger)pageIndex cacheMode:(EnumCacheMode)cacheMode UsingBlock:(HttpResponseBlock)responseBlock {
    DICT_PARAMS_DECLARE
    UserService *userInfo = [UserService sharedService];
    SAFE_SET_VALUE(userInfo.userId, @"userId")
    SAFE_SET_VALUE(userInfo.latitudeStr, @"lat")
    SAFE_SET_VALUE(userInfo.longitudeStr, @"lon")
    SAFE_SET_VALUE(StrFromLong(pageIndex), @"pageIndex")
    SAFE_SET_VALUE(StrFromLong(kPageSize), @"pageNum")
    
    SAFE_SET_VALUE(date, @"selectDate")
    SAFE_SET_VALUE(activityType, @"activityType")
    
    [ProtocolBased requestPostWithParameters:params protocolString:kCultureCalendarListUrl cacheMode:cacheMode UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        __REQUEST_ERROR__
        
        NSInteger statusCode = [responseObject safeStatusCodeForKey:@"status"];
        if (statusCode == 200) {
            NSArray *listArray = [ActivityGatherModel instanceArrayFromDictArray:[responseObject safeArrayForKey:@"data"]];
            if (responseBlock) responseBlock(HttpResponseSuccess, listArray);
        }else {
            __ERROR_HANDLE__(@"获取文化日历列表失败！")
        }
    }];
}

// 我的日历列表
+ (void)getMyCalendarListWithStartDate:(NSString *)startDate endDate:(NSString *)endDate pageIndex:(NSInteger)pageIndex cacheMode:(EnumCacheMode)cacheMode UsingBlock:(HttpResponseBlock)responseBlock {
    DICT_PARAMS_DECLARE
    SAFE_SET_VALUE([UserService sharedService].userId, @"userId")
    SAFE_SET_VALUE(StrFromLong(pageIndex), @"pageIndex")
    SAFE_SET_VALUE(StrFromLong(kPageSize), @"pageNum")
    
    SAFE_SET_VALUE(startDate, @"startDate")
    SAFE_SET_VALUE(endDate, @"endDate")
    
    [ProtocolBased requestPostWithParameters:params protocolString:kMyCalendarActivityListUrl cacheMode:cacheMode UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        __REQUEST_ERROR__
        
        NSInteger statusCode = [responseObject safeStatusCodeForKey:@"status"];
        if (statusCode == 200) {
            NSArray *listArray = [ActivityGatherModel instanceArrayFromDictArray:[responseObject safeArrayForKey:@"data"]];
            if (responseBlock) responseBlock(HttpResponseSuccess, listArray);
        }else {
            __ERROR_HANDLE__(@"获取我的日历列表失败！")
        }
    }];
}

// 我的日历: 历史活动
+ (void)getMyCalendarHistoryListWithPageIndex:(NSInteger)pageIndex cacheMode:(EnumCacheMode)cacheMode UsingBlock:(HttpResponseBlock)responseBlock {
    DICT_PARAMS_DECLARE
    SAFE_SET_VALUE([UserService sharedService].userId, @"userId")
    SAFE_SET_VALUE(StrFromLong(pageIndex), @"pageIndex")
    SAFE_SET_VALUE(StrFromLong(kPageSize), @"pageNum")
    
    [ProtocolBased requestPostWithParameters:params protocolString:kMyCalendarHistoryActivityUrl cacheMode:cacheMode UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        __REQUEST_ERROR__
        
        NSInteger statusCode = [responseObject safeStatusCodeForKey:@"status"];
        if (statusCode == 100) {
            NSArray *listArray = [ActivityGatherModel instanceArrayFromDictArray:[responseObject safeArrayForKey:@"data"]];
            if (responseBlock) responseBlock(HttpResponseSuccess, listArray);
        }else {
            __ERROR_HANDLE__(@"获取我的日历列表失败！")
        }
    }];
}


#pragma mark - ———————————————————  场馆列表  —————————————————————


// 场馆列表
+ (void)getVenueListWithAppType:(NSString *)appType venueName:(NSString *)venueName venueArea:(NSString *)venueArea venueType:(NSString *)venueType venueCrowd:(NSString *)venueCrowd pageIndex:(NSInteger)pageIndex pageNum:(NSInteger)pageNum cacheMode:(EnumCacheMode)cacheMode UsingBlock:(HttpResponseBlock)responseBlock {
    DICT_PARAMS_DECLARE
    UserService *userInfo = [UserService sharedService];
    SAFE_SET_VALUE(userInfo.userId, @"userId")
    SAFE_SET_VALUE(userInfo.latitudeStr, @"Lat")
    SAFE_SET_VALUE(userInfo.longitudeStr, @"Lon")
    SAFE_SET_VALUE(StrFromLong(pageIndex), @"pageIndex")
    SAFE_SET_VALUE(StrFromLong(pageNum), @"pageNum")
    
    SAFE_SET_VALUE(appType, @"appType")
    SAFE_SET_VALUE(venueName, @"venueName")
    SAFE_SET_VALUE(venueArea, @"venueArea")
    SAFE_SET_VALUE(venueType, @"venueType")
    SAFE_SET_VALUE(venueCrowd, @"venueCrowd")
    
    [ProtocolBased requestPostWithParameters:params protocolString:kGetExhibitionHallAllUrl cacheMode:cacheMode UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        __REQUEST_ERROR__
        
        NSInteger statusCode = [responseObject safeStatusCodeForKey:@"status"];
        if (statusCode == 0) {
            NSArray *listArray = [VenueModel instanceArrayFromDictArray:[responseObject safeArrayForKey:@"data"]];
            responseBlock(HttpResponseSuccess, listArray);
        }else {
            __ERROR_HANDLE__(@"获取场馆列表失败！")
        }
    }];
}

// 场馆筛选列表
+ (void)getVenueFilterListWithVenueType:(NSString *)venueType venueArea:(NSString *)venueArea venueLocation:(NSString *)venueLocation sortType:(NSString *)sortType venueIsReserve:(NSString *)venueIsReserve pageIndex:(NSInteger)pageIndex pageNum:(NSInteger)pageNum cacheMode:(EnumCacheMode)cacheMode UsingBlock:(HttpResponseBlock)responseBlock {
    DICT_PARAMS_DECLARE
    UserService *userInfo = [UserService sharedService];
    SAFE_SET_VALUE(userInfo.userId, @"userId")
    SAFE_SET_VALUE(userInfo.latitudeStr, @"Lat")
    SAFE_SET_VALUE(userInfo.longitudeStr, @"Lon")
    SAFE_SET_VALUE(StrFromLong(pageIndex), @"pageIndex")
    SAFE_SET_VALUE(StrFromLong(pageNum), @"pageNum")
    
    
    SAFE_SET_VALUE(venueType, @"venueType")
    SAFE_SET_VALUE(venueArea, @"venueArea")
    SAFE_SET_VALUE(venueLocation, @"venueMood")
    SAFE_SET_VALUE(sortType, @"sortType")
    SAFE_SET_VALUE(venueIsReserve, @"venueIsReserve")
    
    [ProtocolBased requestPostWithParameters:params protocolString:kVenueFilterListUrl cacheMode:cacheMode UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        __REQUEST_ERROR__
        
        NSInteger statusCode = [responseObject safeStatusCodeForKey:@"status"];
        if (statusCode == 1) {
            NSArray *listArray = [VenueModel instanceArrayFromDictArray:[responseObject safeArrayForKey:@"data"]];
            responseBlock(HttpResponseSuccess, listArray);
        }else {
            __ERROR_HANDLE__(@"获取场馆列表失败！")
        }
    }];
}


// 获取场馆的附加信息：（在线活动数、活动室数）
+ (void)getVenueAdditionalInfoWithVenueId:(NSString *)venueId UsingBlock:(HttpResponseBlock)responseBlock {
    DICT_PARAMS_DECLARE
    SAFE_SET_VALUE(venueId, @"venueId")
    
    [ProtocolBased requestPostWithParameters:params protocolString:kVenueAdditionalInfoUrl cacheMode:CACHE_MODE_NOCACHE UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        __REQUEST_ERROR__
        
        NSInteger statusCode = [responseObject safeStatusCodeForKey:@"status"];
        if (statusCode == 1) {
            VenueSubModel *model = [VenueSubModel new];
            model.venueId = venueId;
            model.actCount = [[responseObject safeDictForKey:@"data"] safeIntegerForKey:@"actCount"];
            model.roomCount = [[responseObject safeDictForKey:@"data"] safeIntegerForKey:@"roomCount"];
            
            responseBlock(HttpResponseSuccess, @{venueId : model});
        }else {
            __ERROR_HANDLE__(@"获取在线活动数失败！")
        }
    }];
}

#pragma mark - ———————————————————  活动详情  —————————————————————

// 活动详情
+ (void)getActivtyDetailWithActivityId:(NSString *)activityId UsingBlock:(HttpResponseBlock)responseBlock {
    DICT_PARAMS_DECLARE
    SAFE_SET_VALUE([UserService sharedService].userId, @"userId")
    SAFE_SET_VALUE(activityId, @"activityId")
    
    [ProtocolBased requestPostWithParameters:params protocolString:kActivityDetailUrl cacheMode:CACHE_MODE_REALTIME UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        __REQUEST_ERROR__
        
        NSInteger statusCode = [responseObject safeStatusCodeForKey:@"status"];
        if (statusCode == 0) {
            NSArray *jsonList = [responseObject safeArrayForKey:@"data"];// 活动详情信息与订票信息
            
            // 数组里存在字典，且字典不是空字典
            if (jsonList.count && [jsonList[0] isKindOfClass:[NSDictionary class]] && [jsonList[0] count]) {
                ActivityDetail *model = [[ActivityDetail alloc] initWithAttributes:jsonList[0]];
                
                // 活动的标签列表
                NSArray *activityTags = [responseObject safeArrayForKey:@"data1"];
                NSMutableArray *showedTagNames = [NSMutableArray arrayWithCapacity:1];
                
                if (activityTags.count) {
                    NSDictionary *dict = activityTags[0];
                    
                    NSString *typeName = [dict safeStringForKey:@"tagName"];
                    if (typeName.length) {
                        [showedTagNames addObject:typeName];
                    }
                    
                    NSArray *tagNames = [dict safeArrayForKey:@"subList"];
                    if (tagNames.count) {
                        for (int j = 0; j < tagNames.count && j < 2; j++) {
                            NSDictionary *subDict = tagNames[j];
                            if ([subDict safeStringForKey:@"tagName"].length) {
                                [showedTagNames addObject:[subDict safeStringForKey:@"tagName"]];
                            }
                        }
                    }
                }
                
                // 视频列表
                NSArray *videoArray = [Video instanceArrayFromDictArray:[responseObject safeArrayForKey:@"data2"]];
                NSArray *listArray = @[model, showedTagNames,videoArray];
                
                if (responseBlock) responseBlock(HttpResponseSuccess, listArray);
                
            }else {
                __ERROR_MSG__(@"暂无数据！")
            }
            
        }else {
            __ERROR_HANDLE__(@"获取活动详情失败！")
        }
    }];
}

// 活动场次列表（3.5.2）
+ (void)getActivitySeckillListWithActivityId:(NSString *)activityId isSeckill:(BOOL)isSeckill UsingBlock:(HttpResponseBlock)responseBlock {
    DICT_PARAMS_DECLARE
    SAFE_SET_VALUE(activityId, @"activityId")
    
    [ProtocolBased requestPostWithParameters:params protocolString:kActivitySeckillListUrl cacheMode:CACHE_MODE_NOCACHE UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        __REQUEST_ERROR__
        
        NSInteger statusCode = [responseObject safeStatusCodeForKey:@"status"];
        if (statusCode == 200) {
            NSArray *listArray = [SecKillModel instanceArrayFromDictArray:[responseObject safeArrayForKey:@"data"] isSeckill:isSeckill];
            responseBlock(HttpResponseSuccess, listArray);
        }else {
            __ERROR_HANDLE__(@"获取活动场次信息失败！")
        }
    }];
}

// 演出方的其他活动
+ (void)getActivityShowOtherListWithActivityId:(NSString *)activityId associationId:(NSString *)associationId cacheMode:(EnumCacheMode)cacheMode UsingBlock:(HttpResponseBlock)responseBlock {
    DICT_PARAMS_DECLARE
    SAFE_SET_VALUE([UserService sharedService].userId, @"userId")
    SAFE_SET_VALUE(associationId, @"associationId")
    
    [ProtocolBased requestPostWithJsonParameters:params protocolString:kAssociationOtherActivityUrl cacheMode:cacheMode UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        __REQUEST_ERROR__
        
        NSInteger statusCode = [responseObject safeStatusCodeForKey:@"status"];
        if (statusCode == 1) {
            NSArray *listArray = [ActivityModel listArrayWithArray:[responseObject safeArrayForKey:@"data"] removedActivityId:activityId];
            NSString *totalString = StrFromLong(listArray.count);
            
            responseBlock(HttpResponseSuccess, @[totalString,listArray]);
        }else {
            __ERROR_HANDLE__(@"获取演出方的其它活动失败！")
        }
    }];
}


// 获取详情页点赞列表
+ (void)getUserWantgoListWithType:(DataType)dataType modelId:(NSString *)modelId pageIndex:(NSInteger)pageIndex pageNum:(NSInteger)pageNum UsingBlock:(HttpResponseBlock)responseBlock {
    DICT_PARAMS_DECLARE
    SAFE_SET_VALUE(StrFromLong(pageIndex), @"pageIndex")
    SAFE_SET_VALUE(StrFromLong(pageNum), @"pageNum")
    
    NSString *url = nil;
    if (dataType == DataTypeActivity) {
        url = kWantGoListActivityUrl;
        SAFE_SET_VALUE(modelId, @"activityId")
    }else if (dataType == DataTypeVenue) {
        url = kWantGoListVenueUrl;
        SAFE_SET_VALUE(modelId, @"venueId")
    }else {
        __ERROR_MSG__(@"请求参数错误！")
    }
    
    [ProtocolBased requestPostWithParameters:params protocolString:url cacheMode:CACHE_MODE_REALTIME UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        __REQUEST_ERROR__
        
        NSInteger statusCode = [responseObject safeStatusCodeForKey:@"status"];
        if (statusCode == 1) {
            NSArray *listArray = [Registration instanceArrayFromDictArray:[responseObject safeArrayForKey:@"data"]];
            NSInteger pageTotal = MAX([responseObject safeIntegerForKey:@"pageTotal"], listArray.count);
            if (responseBlock) responseBlock(HttpResponseSuccess, @[[NSNumber numberWithInteger:pageTotal], listArray]);
        }else {
            __ERROR_HANDLE__(@"获取点赞列表数据失败！")
        }
    }];
}

// 添加、取消点赞接口
+ (void)userLikeOperationWithType:(DataType)dataType isCancel:(BOOL)isCancel modelId:(NSString *)modelId UsingBlock:(HttpResponseBlock)responseBlock {
    DICT_PARAMS_DECLARE
    SAFE_SET_VALUE([UserService sharedService].userId, @"userId")
    
    NSString *url = nil;
    if (dataType == DataTypeActivity) {
        url = isCancel ? kWantGoActivityCancelUrl : kWantGoActivityAddUrl;
        SAFE_SET_VALUE(modelId, @"activityId")
    }else if (dataType == DataTypeVenue) {
        url = isCancel ? kWantGoVenueCancelUrl : kWantGoVenueAddUrl;
        SAFE_SET_VALUE(modelId, @"venueId")
    }else {
        __ERROR_MSG__(@"请求参数错误！")
    }
    
    [ProtocolBased requestPostWithParameters:params protocolString:url cacheMode:CACHE_MODE_NOCACHE UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        __REQUEST_ERROR__
        
        NSInteger statusCode = [responseObject safeStatusCodeForKey:@"status"];
        if (statusCode == 0) {
            NSString *msg = [responseObject safeStringForKey:@"data"];
            if (msg.length == 0) msg = @"点赞成功！";
            if (responseBlock) responseBlock(HttpResponseSuccess, msg);
        }else {
            if (isCancel) {
                __ERROR_HANDLE__(@"取消点赞失败！")
            }else {
                __ERROR_HANDLE__(@"点赞失败！")
            }
        }
    }];
}

// 详情页浏览量
+ (void)getScanCountWithDataType:(DataType)dataType modelId:(NSString *)modelId UsingBlock:(HttpResponseBlock)responseBlock {
    DICT_PARAMS_DECLARE
    NSString *url = nil;
    if (dataType == DataTypeActivity) {
        url = kScanCountActivityUrl;
        SAFE_SET_VALUE(modelId, @"activityId")
    }else if (dataType == DataTypeVenue) {
        url = kScanCountVenueUrl;
        SAFE_SET_VALUE(modelId, @"venueId")
    }else {
        __ERROR_MSG__(@"请求参数错误！")
    }
    
    [ProtocolBased requestPostWithParameters:params protocolString:url cacheMode:CACHE_MODE_REALTIME UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        __REQUEST_ERROR__
        
        NSInteger statusCode = [responseObject safeStatusCodeForKey:@"status"];
        if (statusCode == 1) {
            NSInteger scanCount = [responseObject safeIntegerForKey:@"data"];
            if (responseBlock) responseBlock(HttpResponseSuccess, [NSNumber numberWithInteger:scanCount]);
        }else {
            __ERROR_HANDLE__(@"获取浏览量数据失败！")
        }
    }];
}

// 详情页的收藏操作
+ (void)userCollectOperationWithDataType:(DataType)dataType isCancel:(BOOL)isCancel modelId:(NSString *)modelId UsingBlock:(HttpResponseBlock)responseBlock {
    DICT_PARAMS_DECLARE
    SAFE_SET_VALUE([UserService sharedService].userId, @"userId")
    
    NSString *url = nil;
    if (dataType == DataTypeActivity) {
        url = isCancel ? kCancelCollectActivityUrl : kAddCollectActivityUrl;
        SAFE_SET_VALUE(modelId, @"activityId")
        
    }else if (dataType == DataTypeVenue) {
        url = isCancel ? kCancelCollectExhibitionHallUrl : kAddCollectExhibitionHallUrl;
        SAFE_SET_VALUE(modelId, @"venueId")
        
    }else if (dataType == DataTypeCalendarActivity) {
        url = isCancel ? kCancelCollectCalendarActivityUrl : kAddCollectCalendarActivityUrl;
        SAFE_SET_VALUE(modelId, @"relateId")
        SAFE_SET_VALUE(@"2", @"type")
        
    }else if (dataType == DataTypeCalendarGatherActivity) {
        url = isCancel ? kCancelCollectCalendarActivityUrl : kAddCollectCalendarActivityUrl;
        SAFE_SET_VALUE(modelId, @"relateId")
        SAFE_SET_VALUE(@"6", @"type")
    }else {
        __ERROR_MSG__(@"请求参数错误！")
    }
    
    [ProtocolBased requestPostWithParameters:params protocolString:url cacheMode:CACHE_MODE_NOCACHE UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        __REQUEST_ERROR__
        
        NSInteger statusCode = [responseObject safeStatusCodeForKey:@"status"];
        if (statusCode == 0) {
            NSString *msg = [responseObject safeStringForKey:@"data"];
            if (msg.length == 0) msg = @"收藏成功！";
            if (responseBlock) responseBlock(HttpResponseSuccess, msg);
        }else {
            if (isCancel) {
                __ERROR_HANDLE__(@"取消收藏失败！")
            }else {
                __ERROR_HANDLE__(@"收藏失败！")
            }
        }
    }];
}

#pragma mark - ———————————————————  场馆详情  —————————————————————

// 场馆详情
+ (void)getVenueDetailWithVenueId:(NSString *)venueId UsingBlock:(HttpResponseBlock)responseBlock {
    DICT_PARAMS_DECLARE
    SAFE_SET_VALUE([UserService sharedService].userId, @"userId")
    SAFE_SET_VALUE(venueId, @"venueId")
    
    [ProtocolBased requestPostWithParameters:params protocolString:kVenueDetailUrl cacheMode:CACHE_MODE_REALTIME UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        __REQUEST_ERROR__
        
        NSInteger statusCode = [responseObject safeStatusCodeForKey:@"status"];
        if (statusCode == 0) {
            NSArray *listArray = [VenueDetailModel instanceArrayFromDictArray:[responseObject safeArrayForKey:@"data"]];
            if (listArray.count) {
                VenueModel *model = [listArray firstObject];
                NSArray *videoArray = [Video instanceArrayFromDictArray:[responseObject safeArrayForKey:@"data1"]];
                if (responseBlock) responseBlock(HttpResponseSuccess, @[model, videoArray]);
            }else {
                __ERROR_MSG__(@"获取场馆详情出错！")
            }
        }else {
            __ERROR_HANDLE__(@"获取场馆详情信息失败！")
        }
    }];
}

// 场馆相关活动
+ (void)getVenueRelatedActivityListWithVenueId:(NSString *)venueId pageIndex:(NSInteger)pageIndex pageNum:(NSInteger)pageNum cacheMode:(EnumCacheMode)cacheMode UsingBlock:(HttpResponseBlock)responseBlock {
    DICT_PARAMS_DECLARE
    SAFE_SET_VALUE([UserService sharedService].userId, @"userId")
    SAFE_SET_VALUE(StrFromLong(pageIndex), @"pageIndex")
    SAFE_SET_VALUE(StrFromLong(pageNum), @"pageNum")
    SAFE_SET_VALUE(venueId, @"venueId")
    
    [ProtocolBased requestPostWithParameters:params protocolString:kVenueRelatedActivityListUrl cacheMode:cacheMode UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        __REQUEST_ERROR__
        
        NSInteger statusCode = [responseObject safeStatusCodeForKey:@"status"];
        if (statusCode == 0) {
            NSArray *listArray = [ActivityModel listArrayWithArray:[responseObject safeArrayForKey:@"data"]];
            NSInteger pageTotal = MAX([responseObject safeIntegerForKey:@"pageTotal"], listArray.count);
            if (responseBlock) responseBlock(HttpResponseSuccess, @[[NSNumber numberWithInteger:pageTotal], listArray]);
        }else {
            __ERROR_HANDLE__(@"获取场馆下的活动列表失败！")
        }
    }];
}




#pragma mark - ———————————————————  场馆藏品  —————————————————————

// 根据场馆Id获取藏品列表、索引列表
+ (void)getAntiqueListWithVenueId:(NSString *)venueId pageIndex:(NSInteger)pageIndex pageNum:(NSInteger)pageNum cacheMode:(EnumCacheMode)cacheMode UsingBlock:(HttpResponseBlock)responseBlock {
    DICT_PARAMS_DECLARE
    SAFE_SET_VALUE([UserService sharedService].userId, @"userId")
    SAFE_SET_VALUE(StrFromLong(pageIndex), @"pageIndex")
    SAFE_SET_VALUE(StrFromLong(pageNum), @"pageNum")
    SAFE_SET_VALUE(venueId, @"venueId")
    
    [ProtocolBased requestPostWithParameters:params protocolString:kAntiqueListAndIndexUrl cacheMode:cacheMode UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        __REQUEST_ERROR__
        
        NSInteger statusCode = [responseObject safeStatusCodeForKey:@"status"];
        if (statusCode == 0) {
            // 藏品列表
            NSArray *antiqueList = [AntiqueModel instanceArrayFromDictArray:[responseObject safeArrayForKey:@"data"]];
            // 藏品类别列表
            NSArray *categoryList = [responseObject safeArrayForKey:@"data1"];
            // 藏品年代列表
            NSArray *dynastyList = [responseObject safeArrayForKey:@"data2"];
            
            if (responseBlock) {
                responseBlock(HttpResponseSuccess, @[antiqueList, categoryList, dynastyList]);
            }
        }else {
            __ERROR_HANDLE__(@"获取藏品列表失败!")
        }
    }];
}

// 藏品列表筛选_分类
+ (void)getAntiqueFilterListByAntiqueType:(NSString *)antiqueType venueId:(NSString *)venueId pageIndex:(NSInteger)pageIndex pageNum:(NSInteger)pageNum cacheMode:(EnumCacheMode)cacheMode UsingBlock:(HttpResponseBlock)responseBlock {
    DICT_PARAMS_DECLARE
    SAFE_SET_VALUE(venueId, @"venueId")
    SAFE_SET_VALUE(antiqueType, @"antiqueTypeName")
    SAFE_SET_VALUE(StrFromLong(pageIndex), @"pageIndex")
    SAFE_SET_VALUE(StrFromLong(pageNum), @"pageNum")
    
    [ProtocolBased requestPostWithParameters:params protocolString:kAntiqueFilterByCategoryUrl cacheMode:cacheMode UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        __REQUEST_ERROR__
        
        NSInteger statusCode = [responseObject safeStatusCodeForKey:@"status"];
        if (statusCode == 0) {
            NSArray *listArray = [AntiqueModel instanceArrayFromDictArray:[responseObject safeArrayForKey:@"data"]];
            if (responseBlock) responseBlock(HttpResponseSuccess, listArray);
        }else {
            __ERROR_HANDLE__(@"获取藏品列表数据失败！")
        }
    }];
}

// 藏品列表筛选_年代
+ (void)getAntiqueFilterListByAntiqueDynasty:(NSString *)antiqueDynasty venueId:(NSString *)venueId pageIndex:(NSInteger)pageIndex pageNum:(NSInteger)pageNum cacheMode:(EnumCacheMode)cacheMode UsingBlock:(HttpResponseBlock)responseBlock {
    DICT_PARAMS_DECLARE
    SAFE_SET_VALUE(venueId, @"venueId")
    SAFE_SET_VALUE(antiqueDynasty, @"antiqueDynasty")
    SAFE_SET_VALUE(StrFromLong(pageIndex), @"pageIndex")
    SAFE_SET_VALUE(StrFromLong(pageNum), @"pageNum")
    
    [ProtocolBased requestPostWithParameters:params protocolString:kAntiqueFilterByDynastyUrl cacheMode:cacheMode UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        __REQUEST_ERROR__
        
        NSInteger statusCode = [responseObject safeStatusCodeForKey:@"status"];
        if (statusCode == 0) {
            NSArray *listArray = [AntiqueModel instanceArrayFromDictArray:[responseObject safeArrayForKey:@"data"]];
            if (responseBlock) responseBlock(HttpResponseSuccess, listArray);
        }else {
            __ERROR_HANDLE__(@"获取藏品列表数据失败！")
        }
    }];
}

// 藏品详情
+ (void)getAntiqueDetailWithAntiqueId:(NSString *)antiqueId UsingBlock:(HttpResponseBlock)responseBlock {
    DICT_PARAMS_DECLARE
    SAFE_SET_VALUE(antiqueId, @"antiqueId")
    
    [ProtocolBased requestPostWithParameters:params protocolString:kAntiqueDetailUrl cacheMode:CACHE_MODE_REALTIME UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        __REQUEST_ERROR__
        
        NSInteger statusCode = [responseObject safeStatusCodeForKey:@"status"];
        if (statusCode == 0) {
            NSArray *listArray = [AntiqueDetailModel instanceArrayFromDictArray:[responseObject safeArrayForKey:@"data"]];
            if (listArray.count > 0) {
                AntiqueDetailModel *model = [listArray firstObject];
                if (responseBlock) responseBlock(HttpResponseSuccess, model);
            }else {
                responseBlock(HttpResponseError, @"获取藏品详情错误！");
            }
        }else{
            __ERROR_HANDLE__(@"获取藏品详情数据失败！")
        }
    }];
}

#pragma mark - ———————————————————  活动预订  —————————————————————

// 预订活动
+ (void)reserveActivityWithActivityId:(NSString *)activityId bookCount:(NSUInteger)bookCount activityEventIds:(NSString *)activityEventIds seatIds:(NSString *)seatIds seatValues:(NSString *)seatValues activityEventTimes:(NSString *)activityEventTimes mobile:(NSString *)mobile orderPrice:(NSString *)orderPrice orderName:(NSString *)orderName identityCard:(NSString *)identityCard costCredit:(NSString *)costCredit UsingBlock:(HttpResponseBlock)responseBlock {
    
    DICT_PARAMS_DECLARE
    SAFE_SET_VALUE([UserService sharedService].userId, @"userId")
    SAFE_SET_VALUE(activityId, @"activityId")
    SAFE_SET_VALUE(StrFromLong(bookCount), @"bookCount")
    SAFE_SET_VALUE(activityEventIds, @"activityEventIds")
    SAFE_SET_VALUE(seatIds, @"seatIds")
    SAFE_SET_VALUE(seatValues, @"seatValues")
    SAFE_SET_VALUE(activityEventTimes, @"activityEventimes")
    SAFE_SET_VALUE(mobile, @"orderMobileNum")
    SAFE_SET_VALUE(orderPrice, @"orderPrice")
    SAFE_SET_VALUE(orderName, @"orderName")
    SAFE_SET_VALUE(identityCard, @"orderIdentityCard")
    SAFE_SET_VALUE(costCredit, @"costTotalCredit")
    
    [ProtocolBased requestPostWithParameters:params protocolString:kReserveActivityUrl cacheMode:CACHE_MODE_NOCACHE UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        __REQUEST_ERROR__
        
        NSInteger statusCode = [responseObject safeStatusCodeForKey:@"status"];
        if (statusCode == 0) {
            NSString *msg = [responseObject safeStringForKey:@"data"];
            if (msg.length < 1) msg = @"恭喜，活动预订成功！";
            if (responseBlock) responseBlock(HttpResponseSuccess, msg);
        }else {
            __ERROR_HANDLE__(@"活动预订失败，请稍后再试！")
        }
    }];
}

// 获取在线选座类活动的座位信息
+ (void)getActivitySeatInfoWithActivityId:(NSString *)activityId eventId:(NSString *)eventId activityEventTime:(NSString *)activityEventTime UsingBlock:(HttpResponseBlock)responseBlock {
    DICT_PARAMS_DECLARE
    SAFE_SET_VALUE([UserService sharedService].userId, @"userId")
    SAFE_SET_VALUE(activityId, @"activityId")
    SAFE_SET_VALUE(eventId, @"eventId")
    SAFE_SET_VALUE(activityEventTime, @"activityEventimes")
    
    [ProtocolBased requestPostWithParameters:params protocolString:kActivitySeatInfoUrl cacheMode:CACHE_MODE_NOCACHE UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        __REQUEST_ERROR__
        
        NSInteger statusCode = [responseObject safeStatusCodeForKey:@"status"];
        if (statusCode == 0) {
            NSArray *dataArray = [responseObject safeArrayForKey:@"data"];
            if (dataArray.count > 0) {
                NSDictionary *seatDic = [dataArray firstObject];
                NSInteger ticketCount = [seatDic safeIntegerForKey:@"ticketCount"];
                NSArray *listArray = [SeatModel instanceArrayFromDictArray:[seatDic safeArrayForKey:@"seatList"]];
                if (responseBlock) {
                    responseBlock(HttpResponseSuccess, @[[NSNumber numberWithInteger:ticketCount], listArray]);
                }
            }else {
                __ERROR_MSG__(@"座位信息为空！")
            }
            
        }else {
            __ERROR_HANDLE__(@"获取座位信息失败！")
        }
    }];
}



#pragma mark - ———————————————————  活动室与活动室预订  —————————————————————

// 场馆相关活动室
+ (void)getPlayroomListWithVenueId:(NSString *)venueId pageIndex:(NSInteger)pageIndex pageNum:(NSInteger)pageNum cacheMode:(EnumCacheMode)cacheMode UsingBlock:(HttpResponseBlock)responseBlock {
    DICT_PARAMS_DECLARE
    SAFE_SET_VALUE(venueId, @"venueId")
    SAFE_SET_VALUE(StrFromLong(pageIndex), @"pageIndex")
    SAFE_SET_VALUE(StrFromLong(pageNum), @"pageNum")
    
    [ProtocolBased requestPostWithParameters:params protocolString:kPlayRoomListUrl cacheMode:cacheMode UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        __REQUEST_ERROR__
        
        NSInteger statusCode = [responseObject safeStatusCodeForKey:@"status"];
        if (statusCode == 0) {
            NSArray *listArray = [ActivityRoomModel instanceArrayFromDictArray:[responseObject safeArrayForKey:@"data"]];
            NSInteger pageTotal = MAX([responseObject safeIntegerForKey:@"pageTotal"], listArray.count);
            if (responseBlock) {
                responseBlock(HttpResponseSuccess, @[[NSNumber numberWithInteger:pageTotal], listArray]);
            }
        }else {
            __ERROR_HANDLE__(@"获取活动室列表数据失败！")
        }
    }];
}

// 活动室详情
+ (void)getPlayroomDetailWithPlayroomId:(NSString *)playroomId UsingBlock:(HttpResponseBlock)responseBlock {
    DICT_PARAMS_DECLARE
    SAFE_SET_VALUE(playroomId, @"roomId")
    
    [ProtocolBased requestPostWithParameters:params protocolString:kPlayRoomDetailUrl cacheMode:CACHE_MODE_REALTIME UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        __REQUEST_ERROR__
        
        NSInteger statusCode = [responseObject safeStatusCodeForKey:@"status"];
        if (statusCode == 0) {
            NSArray *listArray = [ActivityRoomDetailModel instanceArrayFromDictArray:[responseObject safeArrayForKey:@"data"]];
            if (listArray.count > 0) {
                ActivityRoomDetailModel *model = listArray[0];
                model.openDateArray = [ActivityRoomTimeModel instanceArrayFromDictArray:[responseObject safeArrayForKey:@"data1"]];
                if (responseBlock) responseBlock(HttpResponseSuccess, model);
            }else {
                __ERROR_MSG__(@"获取活动室详情出现错误！")
            }
        }else {
            __ERROR_HANDLE__(@"获取活动室详情数据失败！")
        }
    }];
}

// 活动室预订
+ (void)reservePlayroomWithPlayroomId:(NSString *)playroomId bookId:(NSString *)bookId UsingBlock:(HttpResponseBlock)responseBlock {
    DICT_PARAMS_DECLARE
    SAFE_SET_VALUE([UserService sharedService].userId, @"userId")
    SAFE_SET_VALUE(playroomId, @"roomId")
    SAFE_SET_VALUE(bookId, @"bookId")
    
    [ProtocolBased requestPostWithParameters:params protocolString:kPlayRoomBookUrl cacheMode:CACHE_MODE_NOCACHE UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        __REQUEST_ERROR__
        
        NSInteger statusCode = [responseObject safeStatusCodeForKey:@"status"];
        if (statusCode == 0) {
            ActivityRoomBookModel *model = [[ActivityRoomBookModel alloc] initWithAttributes:[responseObject safeDictForKey:@"data"]];
            responseBlock(HttpResponseSuccess, model);
        }else {
            __ERROR_HANDLE__(@"活动室预订失败！")
        }
    }];
}

// 活动室订单确定
+ (void)playroomOrderConfirmWithBookId:(NSString *)bookId orderName:(NSString *)orderName orderTel:(NSString *)orderTel teamUserId:(NSString *)teamUserId teamUserName:(NSString *)teamUserName purpose:(NSString *)purpose UsingBlock:(HttpResponseBlock)responseBlock {
    DICT_PARAMS_DECLARE
    SAFE_SET_VALUE([UserService sharedService].userId, @"userId")
    SAFE_SET_VALUE(bookId, @"bookId")
    SAFE_SET_VALUE(orderName, @"orderName")
    SAFE_SET_VALUE(orderTel, @"orderTel")
    SAFE_SET_VALUE(teamUserId, @"tuserId")
    SAFE_SET_VALUE(teamUserName, @"tuserName")
    SAFE_SET_VALUE(purpose, @"purpose")
    
    [ProtocolBased requestPostWithParameters:params protocolString:kPlayRoomOrderConfirmlUrl cacheMode:CACHE_MODE_NOCACHE UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        __REQUEST_ERROR__
        
        NSInteger statusCode = [responseObject safeStatusCodeForKey:@"status"];
        if (statusCode == 0) {
            ActivityRoomOrderConfirmModel *model = [[ActivityRoomOrderConfirmModel alloc] initWithAttributes:[responseObject safeDictForKey:@"data"]];
            responseBlock(HttpResponseSuccess, model);
        }else {
            __ERROR_HANDLE__(@"活动室预订失败！");
        }
    }];
}


#pragma mark - ———————————————————  搜  索  —————————————————————

// 搜索活动或场馆(3.5)
+ (void)searchActivityAndVenueWithType:(DataType)dataType modelType:(NSString *)modelType modelArea:(NSString *)modelArea searchKey:(NSString *)searchKey pageIndex:(NSInteger)pageIndex pageNum:(NSInteger)pageNum cacheMode:(EnumCacheMode)cacheMode UsingBlock:(HttpResponseBlock)responseBlock {
    DICT_PARAMS_DECLARE
    
    NSString *url = nil;
    if (dataType == DataTypeActivity) {
        url = kSearchActivityUrl;
    }else if (dataType == DataTypeVenue) {
        url = kSearchVenueUrl;
    }else {
        __ERROR_MSG__(@"请求参数错误！")
    }
    
    if ([@"#" isEqualToString:searchKey]) {
        [params setValue:@"" forKey:@"keyword"];
    }else {
        SAFE_SET_VALUE(searchKey, @"keyword")
    }
    
    [ProtocolBased requestPostWithJsonParameters:params protocolString:url cacheMode:cacheMode UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        __REQUEST_ERROR__
        
        NSInteger statusCode = [responseObject safeStatusCodeForKey:@"status"];
        
        if (statusCode == 1) {
            NSArray *listArray = nil;
            
            if (dataType == DataTypeActivity) {
                listArray = [ActivityModel listArrayWithArray:[responseObject safeArrayForKey:@"data"]];
            }else if (dataType == DataTypeVenue) {
                listArray = [VenueModel instanceArrayFromDictArray:[responseObject safeArrayForKey:@"data"]];
            }
            
            NSInteger pageTotal = [responseObject safeIntegerForKey:@"pageTotal"];
            if (responseBlock) {
                responseBlock(HttpResponseSuccess, @[[NSNumber numberWithInteger:pageTotal], listArray]);
            }
            
        }else {
            __ERROR_HANDLE__(@"未搜索到相关数据！")
        }
    }];
}

// 活动搜索标签
+ (void)searchTagActivityUsingBlock:(HttpResponseBlock)responseBlock {
    DICT_PARAMS_DECLARE
    
    [ProtocolBased requestPostWithParameters:params protocolString:kActivitySearchTagUrl cacheMode:CACHE_MODE_REALTIME UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        __REQUEST_ERROR__
        
        NSInteger statusCode = [responseObject safeStatusCodeForKey:@"status"];
        if (statusCode == 0) {
            // data-心情标签   data1-主题标签  data2-人群标题  data3-区域位置
            NSArray *activityTypes = [SearchTag instanceArrayFromDictArray:[responseObject safeArrayForKey:@"data1"]];
            NSArray *activityAreas = [SearchLocationTag instanceArrayFromDictArray:[responseObject safeArrayForKey:@"data3"]];
            if (responseBlock) {
                responseBlock(HttpResponseSuccess, @[activityTypes, activityAreas]);
            }
        }else {
            __ERROR_HANDLE__(@"获取活动搜索标签数据失败！")
        }
    }];
}

// 场馆搜索标签
+ (void)searchTagVenueUsingBlock:(HttpResponseBlock)responseBlock {
    DICT_PARAMS_DECLARE
    
    [ProtocolBased requestPostWithParameters:params protocolString:kVenueSearchTagUrl cacheMode:CACHE_MODE_REALTIME UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        __REQUEST_ERROR__
        
        NSInteger statusCode = [responseObject safeStatusCodeForKey:@"status"];
        if (statusCode == 0) {
            // 场馆类型
            NSArray *venueTypes = [SearchTag instanceArrayFromDictArray:[responseObject safeArrayForKey:@"data"]];
            if (responseBlock) responseBlock(HttpResponseSuccess, venueTypes);
        }else {
            __ERROR_HANDLE__(@"获取场馆搜索标签失败！")
        }
    }];
}

// 热门搜索标签
+ (void)getSearchHotTagWithDataType:(DataType)dataType cacheMode:(EnumCacheMode)cacheMode UsingBlock:(HttpResponseBlock)responseBlock {
    DICT_PARAMS_DECLARE
    
    if (dataType == DataTypeActivity) {
        SAFE_SET_VALUE(@"A", @"advertType")
    }else if (dataType == DataTypeVenue) {
        SAFE_SET_VALUE(@"B", @"advertType")
    }
    SAFE_SET_VALUE(@"4", @"advertPostion")
    
    [ProtocolBased requestPostWithJsonParameters:params protocolString:kAppAdvertUrl cacheMode:cacheMode UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        __REQUEST_ERROR__
        
        NSInteger statusCode = [responseObject safeStatusCodeForKey:@"status"];
        if (statusCode == 1) {
            NSArray *jsonList = [AdvertModel instanceArrayFromDictArray:[responseObject safeArrayForKey:@"data"] type:3];
            
            NSMutableArray *tmpArray = [NSMutableArray new];
            for (AdvertModel *model in jsonList) {
                if (model.advUrl.length) {
                    
                    for (NSString *keyword in [model.advUrl componentsSeparatedByString:@","]) {
                        
                        if (keyword.length) {
                            SearchHotKeyModel *keywordModel = [SearchHotKeyModel new];
                            keywordModel.hotKey = keyword;
                            [tmpArray addObject:keywordModel];
                        }
                    }
                }
                break;
            }
            
            if (responseBlock) responseBlock(HttpResponseSuccess, tmpArray);
        }else {
            __ERROR_HANDLE__(@"获取热门搜索关键词失败！")
        }
    }];
}

// 活动热搜词和“新”标签
+ (void)getAcitivitySearchHotKeywordsAndNewTagWithType:(NSString *)type UsingBlock:(HttpResponseBlock)responseBlock {
    DICT_PARAMS_DECLARE
    SAFE_SET_VALUE(type, @"type")
    
    [ProtocolBased requestPostWithParameters:params protocolString:kActivityHotKeywordAndNewTagUrl cacheMode:CACHE_MODE_REALTIME UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        __REQUEST_ERROR__
        
        NSInteger statusCode = [responseObject safeStatusCodeForKey:@"status"];
        if (statusCode == 0) {
            
            if ([type isEqualToString:@"1"]) {
                // 活动"新"小时数
                CGFloat dayCount = [responseObject safeDoubleForKey:@"data"];
                if (dayCount < 0.1) { // 说明返回的数据为空，设置为默认值24小时
                    dayCount = 24;
                }
                
                if (responseBlock) responseBlock(HttpResponseSuccess, @[[NSNumber numberWithFloat:dayCount]]);
                
            } else if ([type isEqualToString:@"2"]) {
                // 热搜关键词
                NSString *keyword = [responseObject safeStringForKey:@"data"];
                keyword = [keyword stringByReplacingOccurrencesOfString:@"，" withString:@","];
                
                if (responseBlock) {
                    responseBlock(HttpResponseSuccess, [ToolClass getComponentArrayIgnoreBlank:keyword separatedBy:@","]);
                }
            }
        }else {
            __ERROR_HANDLE__(@"获取数据失败!")
        }
    }];
}

// 获取区域和区域下面对应的商圈
+ (void)getActivityAllAreaAndBussinessRegionUsingBlock:(HttpResponseBlock)responseBlock {
    DICT_PARAMS_DECLARE
    // ——————————————— 这个接口仅支持GET请求 ———————————————
    [ProtocolBased requestGetWithParameters:params protocolString:kActivityAreaAndBussinessRegionUrl cacheMode:CACHE_MODE_REALTIME UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        __REQUEST_ERROR__
        
        NSInteger statusCode = [responseObject safeStatusCodeForKey:@"status"];
        if (statusCode == 200) {
            NSArray *listArray = [AreaFilterListModel listArrayWithDictArray:[responseObject safeArrayForKey:@"data"]];
            if (responseBlock) responseBlock(HttpResponseSuccess, listArray);
        }else {
            __ERROR_HANDLE__(@"获取区域列表数据失败！")
        }
    }];
}

// 搜索联想词
+ (void)getSearchMatchedWordsWithKeyword:(NSString *)keyword UsingBlock:(HttpResponseBlock)responseBlock {
    DICT_PARAMS_DECLARE
    SAFE_SET_VALUE(keyword, @"keyword")
    
    [ProtocolBased requestPostWithJsonParameters:params protocolString:kSearchMatchedWordsUrl cacheMode:CACHE_MODE_REALTIME UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        __REQUEST_ERROR__
        
        NSInteger statusCode = [responseObject safeStatusCodeForKey:@"status"];
        if (statusCode == 1) {
            NSArray *keywords = [responseObject safeArrayForKey:@"data"];
            if (responseBlock) responseBlock(HttpResponseSuccess, keywords);
        } else {
            __ERROR_HANDLE__(@"获取搜索联想词失败！")
        }
    }];
}


#pragma mark - ———————————————————  验证码  —————————————————————


// App获取验证码的接口
+ (void)getCheckCodeWithType:(CheckCodeType)type phoneNum:(NSString *)phoneNum UsingBlock:(HttpResponseBlock)responseBlock {
    NSString *url = @"";
    if (type == CheckCodeTypeRegister) {
        url = kCheckCodeOfRegisterUrl;
    }else if (type == CheckCodeTypeDynamicLogin) {
        url = kCheckCodeOfDynamicLoginUrl;
    }else if (type == CheckCodeTypeFindPassWord) {
        url = kCheckCodeOfFindPasswordUrl;
    }else if (type == CheckCodeTypeBindingMobile) {
        url = kCheckCodeOfBindingMobileUrl;//绑定手机： 发送用户ID和手机号，获取验证码，返回状态
    }else if (type == CheckCodeTypeBookActivity) {
        url = kCheckCodeOfBookActivityUrl;
    }else {
        __ERROR_MSG__(@"请求参数错误!")
    }
    
    DICT_PARAMS_DECLARE
    FIXED_PROTOCOL_REQUEST
    
    if (type == CheckCodeTypeDynamicLogin) {
        // 动态登录获取验证码
        SAFE_SET_VALUE(phoneNum, @"mobileNo")
        
        [ProtocolBased requestPostWithParameters:params protocolString:url cacheMode:CACHE_MODE_NOCACHE UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
            __REQUEST_ERROR__
            
            NSInteger statusCode = [responseObject safeStatusCodeForKey:@"status"];
            if (statusCode == 1) {
                NSString *string = [responseObject safeStringForKey:@"data"];
                if (responseBlock) responseBlock(HttpResponseSuccess, string);
                FBLOG(@"\n\n获取的验证码为： %@\n\n",string);
            }else {
                __ERROR_HANDLE__(@"获取验证码失败！")
            }
        }];
        
    }else {
        // 非动态登录
        SAFE_SET_VALUE([UserService sharedService].userId, @"userId")
        SAFE_SET_VALUE(phoneNum, @"userMobileNo")
        
        [ProtocolBased requestPostWithParameters:params protocolString:url cacheMode:CACHE_MODE_NOCACHE UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
            __REQUEST_ERROR__
            
            NSInteger statusCode = [responseObject safeStatusCodeForKey:@"status"];
            if (statusCode == 0) {
                NSString *code = @"";
                if (type == CheckCodeTypeBookActivity) {
                    code = [responseObject safeStringForKey:@"data1"];
                }else {
                    code = [responseObject safeStringForKey:@"data"];
                }
                if (responseBlock) responseBlock(HttpResponseSuccess, code);
                
                FBLOG(@"\n\n获取的验证码为： %@\n\n",code);
            } else {
                __ERROR_HANDLE__(@"获取验证码失败！")
            }
        }];
    }
}


#pragma mark - ———————————————————  广告位  —————————————————————

// 获取App首页与文化空间的广告位
+ (void)getAppAdvertListWithAdvertPosition:(NSInteger)advertPosition advertType:(NSString *)advertType cacheMode:(EnumCacheMode)cacheMode UsingBlock:(HttpResponseBlock)responseBlock {
    DICT_PARAMS_DECLARE
    if (advertPosition > 0) {
        SAFE_SET_VALUE(StrFromInt(advertPosition), @"advertPostion")
        SAFE_SET_VALUE(advertType, @"advertType")
    }
    
    [ProtocolBased requestPostWithJsonParameters:params protocolString:kAppAdvertUrl cacheMode:cacheMode UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        __REQUEST_ERROR__
        
        NSInteger statusCode = [responseObject safeStatusCodeForKey:@"status"];
        if (statusCode == 1) {
            NSArray *listArray = [AdvertModel instanceArrayFromDictArray:[responseObject safeArrayForKey:@"data"] type:3];
            if (responseBlock) responseBlock(HttpResponseSuccess, listArray);
        }else {
            __ERROR_HANDLE__(@"获取广告位数据失败！")
        }
    }];
}

// 获取首页A、B、C、D四类广告
+ (void)getAdvertListOfHomepageWithCacheMode:(EnumCacheMode)cacheMode isNationwide:(BOOL)isNationwide UsingBlock:(HttpResponseBlock)responseBlock {
    DICT_PARAMS_DECLARE
    SAFE_SET_VALUE(@"2", @"advertPostion")
    
    [ProtocolBased requestPostWithJsonParameters:params protocolString:kAppAdvertUrl cacheMode:cacheMode UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        __REQUEST_ERROR__
        
        NSInteger statusCode = [responseObject safeStatusCodeForKey:@"status"];
        if (statusCode == 1) {
            NSArray *jsonList = [AdvertModel instanceArrayFromDictArray:[responseObject safeArrayForKey:@"data"] type:4];
            
            NSMutableArray *arrayBanner    = [NSMutableArray arrayWithCapacity:0]; // 轮播图
            NSMutableArray *arrayClassify  = [NSMutableArray arrayWithCapacity:0]; // 类别
            NSMutableArray *arraySix       = [NSMutableArray arrayWithCapacity:0]; // 六个广告
            NSMutableArray *arrayRecommend = [NSMutableArray arrayWithCapacity:0]; // 推荐广告
            NSMutableArray *arrayInsert    = [NSMutableArray arrayWithCapacity:0]; // 列表插入广告
            NSMutableArray *arrayYouMayLove = [NSMutableArray arrayWithCapacity:0]; // 全国时，猜你喜欢的数据
            
            
            for (AdvertModel *model in jsonList) {
                if ([model.advertType isEqualToString:@"A"]) {
                    if (model.advertSort <= 7 && model.advertSort >= 2) {
                        [arraySix addObject:model];
                    }else {
                        [arrayBanner addObject:model];
                    }
                }else if ([model.advertType isEqualToString:@"B"]) {
                    [arrayClassify addObject:model];
                }else if ([model.advertType isEqualToString:@"C"]) {
                    [arrayRecommend addObject:model];
                }else if ([model.advertType isEqualToString:@"D"]) {
                    [arrayInsert addObject:model];
                }else if ([model.advertType isEqualToString:@"E"] && isNationwide) {
                    [arrayYouMayLove addObject:model];
                }
            }
            
            [AdvertModel sortAdvertArray:arrayBanner];
            [AdvertModel sortAdvertArray:arrayClassify];
            [AdvertModel sortAdvertArray:arraySix];
            [AdvertModel sortAdvertArray:arrayRecommend];
            [AdvertModel sortAdvertArray:arrayInsert];
            if (isNationwide) {
                [AdvertModel sortAdvertArray:arrayYouMayLove];
            }
            
            if (responseBlock) {
                responseBlock(HttpResponseSuccess, @[arrayBanner,arrayClassify,arraySix,arrayRecommend,arrayInsert, arrayYouMayLove]);
            }
        }else {
            __ERROR_HANDLE__(@"网络连接出问题了，请稍后再试^_^")
        }
    }];
}


// 活动首页广告位列表
+ (void)getMainIndexAdvListWithActivityType:(NSString *)tagId pageIndex:(NSInteger)pageIndex pageNum:(NSInteger)pageNum cacheMode:(EnumCacheMode)cacheMode UsingBlock:(HttpResponseBlock)responseBlock {
    DICT_PARAMS_DECLARE
    SAFE_SET_VALUE(tagId, @"tagId")
    SAFE_SET_VALUE(StrFromLong(pageIndex), @"pageIndex")
    SAFE_SET_VALUE(StrFromLong(pageNum), @"pageNum")
    
    [ProtocolBased requestPostWithParameters:params protocolString:kAppAdvertRecommendList cacheMode:cacheMode UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        __REQUEST_ERROR__
        
        NSInteger statusCode = [responseObject safeStatusCodeForKey:@"status"];
        if (statusCode == 1) {
            NSArray *jsonList = [responseObject safeArrayForKey:@"data"];
            if (responseBlock) responseBlock(HttpResponseSuccess, jsonList);
        }else {
            __ERROR_HANDLE__(@"获取首页广告位数据失败！")
        }
    }];
}


// 日历广告位
+ (void)getCalendarAdvertListWithDate:(NSString *)date cacheMode:(EnumCacheMode)cacheMode UsingBlock:(HttpResponseBlock)responseBlock {
    DICT_PARAMS_DECLARE
    SAFE_SET_VALUE(date, @"date")
    
    [ProtocolBased requestPostWithParameters:params protocolString:kCalendarListAdvertUrl cacheMode:cacheMode UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        __REQUEST_ERROR__
        
        NSInteger statusCode = [responseObject safeStatusCodeForKey:@"status"];
        if (statusCode == 200) {
            AdvertModel *model = [[AdvertModel alloc] initWithItemDict:[responseObject safeDictForKey:@"data"] type:2];
            if (responseBlock) responseBlock(HttpResponseSuccess, model);
        }else {
            __ERROR_HANDLE__(@"获取文化日历广告位数据失败！")
        }
    }];
}



#pragma mark - ———————————————————  标签管理  —————————————————————

// 活动标签列表
+ (void)getTagListOfActivityWithUserId:(NSString *)userId UsingBlock:(HttpResponseBlock)responseBlock {
    DICT_PARAMS_DECLARE
    SAFE_SET_VALUE(userId, @"userId")
    
    [ProtocolBased requestPostWithParameters:params protocolString:kActivityTagListUrl cacheMode:CACHE_MODE_REALTIME UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        __REQUEST_ERROR__
        
        NSInteger statusCode = [responseObject safeStatusCodeForKey:@"status"];
        if (statusCode == 0) {
            NSArray *resultArray = [responseObject safeArrayForKey:@"data"];
            if (resultArray.count && userId.length) {
                // 在用户登录的情况下，直接保存选中的标签
                NSString *jsonTag = [ToolClass jsonActTagsForTagArray:resultArray isServerTag:YES];
                
                [[UserTagServices getInstance] saveUserTag:[UserService sharedService].userId citycode:CITY_AD_CODE tagcontent:jsonTag];
            }
            if (responseBlock) responseBlock(HttpResponseSuccess, resultArray);
        }else {
            __ERROR_HANDLE__(@"获取活动标签列表失败！")
        }
    }];
}

// 上传用户选择的标签(主题)
+ (void)uploadUserTagsWithUserSelectedTags:(NSString *)selectedTags UsingBlock:(HttpResponseBlock)responseBlock {
    DICT_PARAMS_DECLARE
    SAFE_SET_VALUE([UserService sharedService].userId, @"userId")
    SAFE_SET_VALUE(selectedTags, @"userSelectTag")
    
    [ProtocolBased requestPostWithParameters:params protocolString:kUserSelectedTagUploadUrl cacheMode:CACHE_MODE_NOCACHE UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        __REQUEST_ERROR__
        
        NSInteger statusCode = [responseObject safeStatusCodeForKey:@"status"];
        if (statusCode == 0) {
            NSString *msg = [responseObject safeStringForKey:@"data"];
            if (msg.length == 0) msg = @"用户标签上传成功！";
            if (responseBlock) responseBlock(HttpResponseSuccess, msg);
        }else {
            __ERROR_HANDLE__(@"上传用户标签失败！")
        }
    }];
}

// 获取文化空间的标签
+ (void)getTagListOfCultureSpacingUsingBlock:(HttpResponseBlock)responseBlock {
    DICT_PARAMS_DECLARE
    SAFE_SET_VALUE(@"3", @"advertPostion")
    SAFE_SET_VALUE(@"B", @"advertType")
    
    [ProtocolBased requestPostWithJsonParameters:params protocolString:kAppAdvertUrl cacheMode:CACHE_MODE_REALTIME UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        __REQUEST_ERROR__
        
        NSInteger statusCode = [responseObject safeStatusCodeForKey:@"status"];
        if (statusCode == 1) {
            NSArray *listArray = [CultureSpacingTagModel listArrayWithArray:[responseObject safeArrayForKey:@"data"] type:3];
            if (responseBlock) responseBlock(HttpResponseSuccess, listArray);
        }else {
            __ERROR_HANDLE__(@"获取文化空间标签失败！")
        }
    }];
}


#pragma mark - —————————————————— 订单支付相关接口 ——————————————————

// 获取订单的预支付信息
+ (void)getPrepayInfoWithDataType:(DataType)dataType orderId:(NSString *)orderId UsingBlock:(HttpResponseBlock)responseBlock {
    DICT_PARAMS_DECLARE
    SAFE_SET_VALUE([UserService sharedService].userId, @"userId")
    
    if (dataType == DataTypeActivity) {
        SAFE_SET_VALUE(orderId, @"activityOrderId")
    }else if (dataType == DataTypeVenue) {
        SAFE_SET_VALUE(orderId, @"roomOrderId")
    }else {
        __ERROR_MSG__(@"请求参数错误！")
    }
    
    [ProtocolBased requestPostWithParameters:params protocolString:kPrepayOrderInfoUrl cacheMode:CACHE_MODE_NOCACHE UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        __REQUEST_ERROR__
        
        NSInteger statusCode = [responseObject safeStatusCodeForKey:@"status"];
        if (statusCode == 200) {
            PrepayOrderModel *model = [[PrepayOrderModel alloc] initWithAttributes:[responseObject safeDictForKey:@"data"] type:dataType];
            if (responseBlock) {
                responseBlock(HttpResponseSuccess, model);
            }
        }else {
            __ERROR_HANDLE__(@"获取订单支付信息失败！")
        }
    }];
}

// 获取订单支付参数
+ (void)getOrderPayParamsWithOrderId:(NSString *)orderId payType:(PayPlatformType)payType UsingBlock:(HttpResponseBlock)responseBlock {
    
    NSString *url = nil;
    if (payType == PayPlatformTypeWeiXin) {
        url = kOrderPayParamForWechatUrl;
    }else if (payType == PayPlatformTypeAliPay) {
        url = kOrderPayParamForAlipayUrl;
    }else {
        __ERROR_MSG__(@"请先选择支付方式！")
    }
    
    DICT_PARAMS_DECLARE
    SAFE_SET_VALUE(orderId, @"orderId")
    
    [ProtocolBased requestPostWithJsonParameters:params protocolString:url cacheMode:CACHE_MODE_NOCACHE UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        __REQUEST_ERROR__
        
        NSInteger statusCode = [responseObject safeStatusCodeForKey:@"status"];
        if (statusCode == 1) {
            
            if (payType == PayPlatformTypeAliPay) {
                OrderPayModel *model = [OrderPayModel new];
                model.payType = payType;
                model.orderId = orderId;
                model.orderInfo = [responseObject safeStringForKey:@"data"];
                
                if (model.orderInfo.length > 0) {
                    if (responseBlock) responseBlock(HttpResponseSuccess, model);
                }else {
                    __ERROR_MSG__(@"获取订单支付信息异常!")
                }
                
            }else if (payType == PayPlatformTypeWeiXin) {
                OrderPayModel *model = [[OrderPayModel alloc] initWithAttributes:[responseObject safeDictForKey:@"data"] payType:payType];
                if (model) {
                    
                    if (model.prepayId.length > 0) {
                        if (responseBlock) responseBlock(HttpResponseSuccess, model);
                    }else {
                        __ERROR_MSG__(@"订单可能已经支付过了，请至我的订单中查看支付结果！")
                    }
                }else {
                    __ERROR_MSG__(@"获取订单支付信息异常!")
                }
            }
            
        }else {
            __ERROR_HANDLE__(@"获取订单支付信息失败！")
        }
    }];
}

// 查询订单支付结果
+ (void)getOrderPayResultWithOrderId:(NSString *)orderId UsingBlock:(HttpResponseBlock)responseBlock {
    DICT_PARAMS_DECLARE
    SAFE_SET_VALUE([UserService sharedService].userId, @"userId")
    SAFE_SET_VALUE(orderId, @"activityOrderId")
    // 加这个变量只是为了可以每隔2s重新发送一次新的请求
    SAFE_SET_VALUE(StrFromLong(arc4random()%10000), kOrderPayQueryKey)
    
    [ProtocolBased requestPostWithParameters:params protocolString:kPrepayOrderInfoUrl cacheMode:CACHE_MODE_NOCACHE UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        __REQUEST_ERROR__
        
        NSInteger statusCode = [responseObject safeStatusCodeForKey:@"status"];
        if (statusCode == 200) {
            PrepayOrderModel *model = [[PrepayOrderModel alloc] initWithAttributes:[responseObject safeDictForKey:@"data"] type:DataTypeActivity];
            if (model.orderPayStatus == 2) {
                if (responseBlock) responseBlock(HttpResponseSuccess, model);
            }else {
                __ERROR_MSG__(@"订单支付结果正在处理中...")
            }
        }else {
            __ERROR_HANDLE__(@"查询订单支付结果失败！")
        }
    }];
}



#pragma mark - ———————————————————  其他接口  —————————————————————

// App版本更新
+ (void)checkAppVersionUpdateUsingBlock:(HttpResponseBlock)responseBlock {
    DICT_PARAMS_DECLARE
    NSString *currentVersion = [NSString stringWithFormat:@"v%@",APP_VERSION];
    SAFE_SET_VALUE(currentVersion, @"versionNo")
    SAFE_SET_VALUE(@"1", @"mobileType")  // 1-iOS   2-Android
    
    NSString *url = [NSString stringWithFormat:@"%@%@", kProtocolFixedUrl, kAppUpdateUrl];
    
    [ProtocolBased requestPostWithParameters:params protocolString:url cacheMode:CACHE_MODE_REALTIME UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        __REQUEST_ERROR__
        
        NSInteger statusCode = [responseObject safeStatusCodeForKey:@"status"];
        if (statusCode == 200) {
            
            AppUpdateModel *model = [[AppUpdateModel alloc] initWithAttributes:[responseObject safeDictForKey:@"data"]];
            
            if (model && (model.updateType == 1 || model.updateType == 2)) {
                
                NSString *appNewestVersion = [ToolClass getDefaultValue:kUserDefault_AppNewestVersion];
                
                if (model.updateDescription.length > 0 && model.updateLink.length > 0 && [ToolClass versionCompare:APP_VERSION comparedVersion:appNewestVersion]==NSOrderedDescending)  {
                    // 需要弹窗提示
                    
                    if (model.updateType == 1) {
                        // 非强制更新时，避免一天内多次提示
                        NSString *storedDate = [ToolClass getDefaultValue:@"last_update_alert_time"];
                        if (storedDate.length) {
                            if ([storedDate isEqualToString:[DateTool dateStringForDate:[NSDate date]]]) {
                                responseBlock(HttpResponseError, @"不需要更新!");
                                return;
                            }
                        }
                    }
                    
                    NSString *dateString = [DateTool dateStringForDate:[NSDate date]];
                    [ToolClass setDefaultValue:dateString forKey:@"last_update_alert_time"];
                    
                    responseBlock(HttpResponseSuccess, model);
                    return;
                }
                
            }
        }else {
        }
        
        __ERROR_HANDLE__(@"不需要进行更新！")
    }];
    
}

// 获取启动页图片
+ (void)getLaunchImageUrlUsingBlock:(HttpResponseBlock)responseBlock {
    int w = 0;
    int h = 0;
    
    if (iPhone_3_5) {
        w = 640;
        h = 743;
    }else if (iPhone_4_0 || iPhone_4_7 || iPhone_5_5) {
        w = 1242;
        h = 1787;
    }else if (iPhone_5_8) {
        w = 1125;
        h = 2054;
    }else {
        int screenWidth = [UIScreen mainScreen].bounds.size.width;
        int screenHeight = [UIScreen mainScreen].bounds.size.height;
        
        w = screenWidth;
        h = screenHeight - screenWidth * 421.0/1242;
    }
    
    NSString *width = [NSString stringWithFormat:@"%d",w];
    NSString *height = [NSString stringWithFormat:@"%d",h];
    NSString *currentVersion = [NSString stringWithFormat:@"v%@", APP_VERSION];
    
    DICT_PARAMS_DECLARE
    SAFE_SET_VALUE(currentVersion, @"versionNo")
    SAFE_SET_VALUE(width, @"width")
    SAFE_SET_VALUE(height, @"height")
    SAFE_SET_VALUE(CITY_AD_CODE, @"cityCode")
    
    [ProtocolBased requestPostWithParameters:params protocolString:[NSString stringWithFormat:@"%@%@", kProtocolShanghaiUrl_Production, kLaunchImageUrl] cacheMode:CACHE_MODE_REALTIME UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        __REQUEST_ERROR__
        
        NSInteger statusCode = [responseObject safeStatusCodeForKey:@"status"];
        
        if (statusCode == 100) {
            NSString *imageUrl = [responseObject safeStringForKey:@"data"];
            if ([imageUrl isValidImgUrl]) {
                if (responseBlock) responseBlock(HttpResponseSuccess, imageUrl);
                return;
            }
        }
        
        __ERROR_MSG__(@"获取启动页图片失败!")
    }];
}


// 获取图片地址的前缀
+ (void)getImageUrlPrefixUsingBlock:(HttpResponseBlock)responseBlock {
    DICT_PARAMS_DECLARE
    
    [ProtocolBased requestPostWithJsonParameters:params protocolString:kImageUrlPrefixUrl cacheMode:CACHE_MODE_HALFREALTIME_SHORT UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        __REQUEST_ERROR__
        
        NSInteger statusCode = [responseObject safeStatusCodeForKey:@"status"];
        if (statusCode == 1) {
            NSString *imgUrlPrefix = [responseObject safeStringForKey:@"data"];
            if ([imgUrlPrefix hasPrefix:@"http"]) {
                NSString *oldImgUrlPrefix = [ToolClass getDefaultValue:kUserDefault_ImageUrlPrefix];
                if (![oldImgUrlPrefix isEqualToString:imgUrlPrefix]) {
                    [ToolClass setDefaultValue:imgUrlPrefix forKey:kUserDefault_ImageUrlPrefix];
                }
                
                if (responseBlock) responseBlock(HttpResponseSuccess, imgUrlPrefix);
                return;
            }
        }
        
        __ERROR_MSG__(@"获取图片地址前缀失败！");
    }];
}

// 统计用户转发，增加用户积分的接口
+ (void)userShareStatisticsWithContentType:(NSInteger)type link:(NSString *)url shareType:(ShareType)platform shareId:(NSString *)shareId UsingBlock:(HttpResponseBlock)responseBlock {
    DICT_PARAMS_DECLARE
    FIXED_PROTOCOL_REQUEST
    SAFE_SET_VALUE([UserService sharedService].userId, @"userId")
    SAFE_SET_VALUE(StrFromInt(type), @"shareType")
    SAFE_SET_VALUE([DateTool timeSpForDate:[NSDate date] millisecond:NO], @"shareDate")
    SAFE_SET_VALUE(StrFromInt(platform), @"platform")
    SAFE_SET_VALUE(shareId, @"shareId")
    SAFE_SET_VALUE(url, @"shareLink")
    
    [ProtocolBased requestPostWithParameters:params protocolString:kUserShareStatisticsUrl cacheMode:CACHE_MODE_NOCACHE UsingBlock:nil];
    
    [ProtocolBased requestPostWithParameters:params protocolString:kUserShareIncreaseIntegeralUrl cacheMode:CACHE_MODE_NOCACHE UsingBlock:nil];
}

// 获取App Store上的最新版本号
+ (void)getAppVersionFromAppStore {
    if ([APP_ID length] < 1) {
        return;
    }
    
    DICT_PARAMS_DECLARE
    SAFE_SET_VALUE(APP_ID, @"id")
    
    [ProtocolBased requestGetWithParameters:params protocolString:@"https://itunes.apple.com/lookup" cacheMode:CACHE_MODE_REALTIME UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        
        if (responseCode == HttpResponseSuccess) {
            NSArray *resultArray = [responseObject safeArrayForKey:@"results"];
            if (resultArray.count) {
                NSString *version = [resultArray[0] safeStringForKey:@"version"];
                if (version.length) {
                    [ToolClass setDefaultValue:version forKey:kUserDefault_AppNewestVersion];
                }
            }
        }
    }];
}



@end

/*
 
 重要说明：
 改动过返回值的接口：场馆详情、藏品列表接口、藏品详情、活动搜索标签、用户上传标签
 
 

 */
