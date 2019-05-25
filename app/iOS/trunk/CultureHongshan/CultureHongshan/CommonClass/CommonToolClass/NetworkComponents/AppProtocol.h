//
//  AppProtocol.h
//  CultureHongshan
//
//  Created by one on 15/11/6.
//  Copyright © 2015年 CT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProtocolBased.h"
#import "ExtendedType.h"
#import "PayService.h"

@interface AppProtocol : NSObject


/**
 *  查询某个城市的接口地址
 *
 *  @param cityId   城市的adCode
 *  @param cityName 城市名称
 */
+ (void)getCityInterfaceByCityId:(NSString *)cityId cityName:(NSString *)cityName UsingBlock:(HttpResponseBlock)responseBlock;


#pragma mark - ——————————————————————————- 整理分割线 ——————————————————————————





#pragma mark - ———————————————————  个人中心  —————————————————————

#pragma mark 用户信息

/**
 *  根据用户id获取信息
 *
 *  @discussion 获取用户信息跟着城市切换，获取用户的积分用全国的接口
 *
 *  @param userId 根据用户id获取信息
 */
+ (void)queryUserInfoWithUserId:(NSString *)userId UsingBlock:(HttpResponseBlock)responseBlock;

/**
 *  更新用户信息
 *
 *  @param userId        用户Id
 *  @param userName      用户昵称
 *  @param userSex       用户性别：1-男 2-女
 *  @param userTelephone 用户手机号
 *  @param userArea      用户地区（50:静安区）
 */
+ (void)updateUserInfoWithUserId:(NSString *)userId userName:(NSString *)userName userSex:(NSString *)userSex userTelephone:(NSString *)userTelephone userArea:(NSString *)userArea UsingBlock:(HttpResponseBlock)responseBlock;


#pragma mark   登录与注册


/**
 *  第三方登录
 *
 *  @param openId         第三方openId（微信的为unionId）
 *  @param registerOrigin 注册来源：1-文化云  2-QQ  3-新浪微博  4-微信
 *  @param birthday       生日：
 *  @param nickName       用户名
 *  @param headImageUrl   头像链接
 *  @param userSex        用户性别：1-男 2-女
 */
+ (void)userLoginThirdPlatformWithOpenId:(NSString *)openId registerOrigin:(NSString *)registerOrigin birthday:(NSString *)birthday nickName:(NSString *)nickName headImageUrl:(NSString *)headImageUrl userSex:(NSString *)userSex UsingBlock:(HttpResponseBlock)responseBlock;

/**
 *  文化云平台用户登录
 *
 *  @param mobile        手机号
 *  @param password      密码（MD5）
 *  @param dynamicLogin  是否为动态登录
 */
+ (void)userLoginWithMobile:(NSString *)mobile password:(NSString *)password dynamicLogin:(BOOL)dynamicLogin UsingBlock:(HttpResponseBlock)responseBlock;

/**
 *  文化云平台用户注册
 *
 *  @param userName  用户名
 *  @param password  密码（MD5）
 *  @param mobile    手机号
 *  @param checkCode 验证码
 */
+ (void)userRegisterWithUserName:(NSString *)userName password:(NSString *)password mobile:(NSString *)mobile checkCode:(NSString *)checkCode UsingBlock:(HttpResponseBlock)responseBlock;


#pragma mark  密码


/**
 *  重置密码
 *
 *  @param mobile    手机号
 *  @param password  密码（MD5）
 *  @param checkCode 验证码
 */
+ (void)resetUserPasswordWithMobile:(NSString *)mobile password:(NSString *)password checkCode:(NSString *)checkCode UsingBlock:(HttpResponseBlock)responseBlock;

/**
 *  修改密码
 *
 *  @param userId        用户Id
 *  @param password      旧密码（MD5）
 *  @param newPassword   新密码（MD5）
 */
+ (void)updatePasswordWithUserId:(NSString *)userId password:(NSString *)password newPassword:(NSString *)newPassword UsingBlock:(HttpResponseBlock)responseBlock;


#pragma mark  我的消息

/**
 *  获取用户消息
 *
 *  @param userId 用户Id
 */
+ (void)getUserMessageWithUserId:(NSString *)userId UsingBlock:(HttpResponseBlock)responseBlock;

/**
 *  获取推送给用户的消息条数
 *
 * @discussion 目前没有该接口
 *
 *  @param userId 用户Id
 */
+ (void)getUserMessageNumberWithUserId:(NSString *)userId UsingBlock:(HttpResponseBlock)responseBlock;

/**
 *  删除用户消息
 *
 *  @param msgId 消息Id
 */
+ (void)userMessageDeleteWithMsgId:(NSString *)msgId UsingBlock:(HttpResponseBlock)responseBlock;



#pragma mark  我的订单


/**
 *  获取订单列表(3.5.2)
 *
 *  @param orderType 订单类型：1-待审核  2-待支付  3-待参加  4-历史
 *  @param pageIndex 数据索引
 *  @param pageNum   数据条数
 *  @param cacheMode 缓存方式
 */
+ (void)getUserOrderListWithType:(NSInteger)orderType pageIndex:(NSInteger)pageIndex pageNum:(NSInteger)pageNum cacheMode:(EnumCacheMode)cacheMode UsingBlock:(HttpResponseBlock)responseBlock;

/**
 *  获取订单详情(3.5.2)
 *
 *  @param dataType 数据类型
 *  @param orderId  订单Id
 */
+ (void)getUserOrderDetailWithDataType:(DataType)dataType orderId:(NSString *)orderId  UsingBlock:(HttpResponseBlock)responseBlock;

/**
 *  取消用户订单
 *
 *  @param dataType   数据类型
 *  @param orderId    订单Id
 *  @param orderSeats 要取消的活动座位（可选，格式：）
 */
+ (void)cancelUserOrderWithDataType:(DataType)dataType orderId:(NSString *)orderId orderSeats:(NSString *)orderSeats UsingBlock:(HttpResponseBlock)responseBlock;

/**
 *  删除用户订单
 *
 *  @param dataType 数据类型
 *  @param orderId  订单Id
 */
+ (void)deleteUserOrderWithDataType:(DataType)dataType orderId:(NSString *)orderId UsingBlock:(HttpResponseBlock)responseBlock;


#pragma mark  我的收藏


/**
 *  我的收藏列表
 *
 *  @param dataType  数据类型
 *  @param searchKey 搜索关键词（预留字段）
 *  @param pageIndex 数据索引
 *  @param pageNum   数据条数
 *  @param cacheMode 缓存方式
 */
+ (void)getUserCollectListWithDataType:(DataType)dataType searchKey:(NSString *)searchKey pageIndex:(NSInteger)pageIndex pageNum:(NSInteger)pageNum cacheMode:(EnumCacheMode)cacheMode UsingBlock:(HttpResponseBlock)responseBlock;

/**
 *  取消收藏
 *
 *  @param dataType 数据类型
 *  @param modelId  数据Id
 */
+ (void)cancelCollectWithDataType:(DataType)dataType modelId:(NSString *)modelId UsingBlock:(HttpResponseBlock)responseBlock;



#pragma mark  我的评论


/**
 *  我的评论列表（个人中心）
 *
 *  @param dataType  数据类型
 *  @param pageIndex 数据索引
 *  @param pageNum   数据条数
 *  @param cacheMode 缓存方式
 */
+ (void)getUserCommentListWithDataType:(DataType)dataType pageIndex:(NSInteger)pageIndex pageNum:(NSInteger)pageNum cacheMode:(EnumCacheMode)cacheMode UsingBlock:(HttpResponseBlock)responseBlock;

/**
 *  删除用户评论
 *
 *  @param dataType  数据类型
 *  @param commentId 评论Id
 */
+ (void)deleteUserCommentWithDataType:(DataType)dataType commentId:(NSString *)commentId UsingBlock:(HttpResponseBlock)responseBlock;

/**
 *  详情页评论列表
 *
 *  @param dataType  数据类型
 *  @param modelId   数据Id
 *  @param pageIndex 数据索引
 *  @param pageNum   数据条数
 *  @param cacheMode 缓存方式
 */
+ (void)getCommentListOfDetailPageWithDataType:(DataType)dataType modelId:(NSString *)modelId pageIndex:(NSInteger)pageIndex pageNum:(NSInteger)pageNum cacheMode:(EnumCacheMode)cacheMode UsingBlock:(HttpResponseBlock)responseBlock;

/**
 *  发表评论
 *
 *  @param dataType         数据类型
 *  @param modelId          数据Id
 *  @param commentContent   评论文本内容
 *  @param commentImageUrls 评论图片链接（多个时以英文分号拼接）
 *  @param commentStarLevel 评论星级：0-5
 */
+ (void)publishCommentWithDataType:(DataType)dataType modelId:(NSString *)modelId commentContent:(NSString *)commentContent commentImageUrls:(NSString *)commentImageUrls commentStarLevel:(NSString *)commentStarLevel UsingBlock:(HttpResponseBlock)responseBlock;

#pragma mark  我的积分

/**
 *  获取用户的积分值
 *
 *  @param userId 用户Id
 */
+ (void)getUserIntegralWithUserId:(NSString *)userId UsingBlock:(HttpResponseBlock)responseBlock;

/**
 *  获取用户的积分明细列表
 *
 *  @param listType   列表类型：1-最近30天 2-全部积分明细
 *  @param pageIndex  数据索引
 *  @param pageNum    数据条数
 *  @param cacheMode  缓存方式
 */
+ (void)getUserIntegralListWithType:(NSInteger)listType pageIndex:(NSInteger)pageIndex pageNum:(NSInteger)pageNum cacheMode:(EnumCacheMode)cacheMode UsingBlock:(HttpResponseBlock)responseBlock;

#pragma mark  其它

/**
 *  用户意见反馈
 *
 *  @param feedContent 反馈内容
 *  @param feedImgUrl  反馈图片链接（多个时英文分号拼接）
 *  @param feedType    反馈类型Id：
 */
+ (void)userFeedbackWithFeedContent:(NSString *)feedContent feedImgUrl:(NSString *)feedImgUrl feedType:(NSString *)feedType UsingBlock:(HttpResponseBlock)responseBlock;



#pragma mark - ———————————————————  活动列表  —————————————————————


/**
 *  首页的猜你喜欢活动列表
 *
 *  @param pageIndex  数据索引
 *  @param pageNum    数据条数
 *  @param cacheMode  缓存方式
 */
+ (void)getActivityYouMayLoveWithPageIndex:(NSInteger)pageIndex pageNum:(NSInteger)pageNum cacheMode:(EnumCacheMode)cacheMode UsingBlock:(HttpResponseBlock)responseBlock;

/**
 *  置顶活动列表
 *
 *  @param activityTag           活动标签Id（）
 *  @param sortType              排序方式：1-智能排序 2-热门排序 3-最新上线 4-即将结束 5-离我最近
 *  @param activityArea          活动区域（）######
 *  @param activityLocation      活动商圈 ######
 *  @param activityIsReservation 是否可预订：1-否  2-是
 *  @param activityIsFree        是否免费：1-免费  2-收费
 *  @param pageIndex             数据索引
 *  @param pageNum               数据条数
 *  @param cacheMode             缓存方式
 */
+ (void)getTopAcitivityListWithActivityTag:(NSString *)activityTag sortType:(NSString *)sortType activityArea:(NSString *)activityArea activityLocation:(NSString *)activityLocation activityIsReservation:(NSString *)activityIsReservation activityIsFree:(NSString *)activityIsFree pageIndex:(NSInteger)pageIndex pageNum:(NSInteger)pageNum cacheMode:(EnumCacheMode)cacheMode UsingBlock:(HttpResponseBlock)responseBlock;

/**
 *  首页推荐活动
 *
 *  @param pageIndex 数据索引
 *  @param pageNum   数据条数
 *  @param cacheMode 缓存方式
 */
+ (void)getActivityRecommendedWithPageIndex:(NSInteger)pageIndex pageNum:(NSInteger)pageNum cacheMode:(EnumCacheMode)cacheMode UsingBlock:(HttpResponseBlock)responseBlock;

/**
 *  推荐筛选活动列表(3.5.2)
 *
 *  @param activityArea          活动区域 ######
 *  @param activityLocation      活动商圈 ######
 *  @param activityIsFree        是否免费：1-免费  2-收费
 *  @param activityIsReservation 是否可预订：1-否  2-是
 *  @param sortType              排序方式：1-智能排序 2-热门排序 3-最新上线 4-即将结束 5-离我最近
 *  @param pageIndex             数据索引
 *  @param pageNum               数据条数
 *  @param cacheMode             缓存方式
 */
+ (void)getRecommendFilterActivityWithActivityArea:(NSString *)activityArea activityLocation:(NSString *)activityLocation activityIsFree:(NSString *)activityIsFree activityIsReservation:(NSString *)activityIsReservation sortType:(NSString *)sortType pageIndex:(NSInteger)pageIndex pageNum:(NSInteger)pageNum cacheMode:(EnumCacheMode)cacheMode UsingBlock:(HttpResponseBlock)responseBlock;

/**
 *  日历页获取每天的活动数量
 *
 *  @param startDate  开始日期(yyyy-MM-dd)
 *  @param endDate    结束日期(yyyy-MM-dd)
 *  @param cacheMode  缓存方式
 */
+ (void)getActivityCountByDayWithStartDate:(NSString *)startDate endDate:(NSString *)endDate cacheMode:(EnumCacheMode)cacheMode UsingBlock:(HttpResponseBlock)responseBlock;

/**
 *  日期查询活动列表（暂时不用）
 *
 *  @param activityArea          活动区域 ######
 *  @param activityLocation      活动商圈 ######
 *  @param activityType          活动类型Id
 *  @param activityIsFree        是否免费：1-免费  2-收费
 *  @param activityIsReservation 是否可预订：1-否  2-是
 *  @param startDate             开始日期(yyyy-MM-dd)
 *  @param endDate               结束日期(yyyy-MM-dd)
 *  @param pageIndex             数据索引
 *  @param pageNum               数据条数
 *  @param cacheMode             缓存方式
 */
+ (void)getActivityListByDayWithActivityArea:(NSString *)activityArea activityLocation:(NSString *)activityLocation activityType:(NSString *)activityType activityIsFree:(NSString *)activityIsFree activityIsReservation:(NSString *)activityIsReservation startDate:(NSString *)startDate endDate:(NSString *)endDate pageIndex:(NSInteger)pageIndex pageNum:(NSInteger)pageNum cacheMode:(EnumCacheMode)cacheMode UsingBlock:(HttpResponseBlock)responseBlock;

/**
 *  附近地点活动列表
 *
 *  @param activityType          活动类型Id
 *  @param sortType              排序方式：1-智能排序 2-热门排序 3-最新上线 4-即将结束
 *  @param activityIsFree        是否免费：1-免费  2-收费
 *  @param activityIsReservation 是否可预订：1-否  2-是
 *  @param pageIndex             数据索引
 *  @param pageNum               数据条数
 *  @param cacheMode             缓存方式
 */
+ (void)getNearbyActivityListWithActivityType:(NSString *)activityType sortType:(NSString *)sortType activityIsFree:(NSString *)activityIsFree activityIsReservation:(NSString *)activityIsReservation pageIndex:(NSInteger)pageIndex pageNum:(NSInteger)pageNum cacheMode:(EnumCacheMode)cacheMode UsingBlock:(HttpResponseBlock)responseBlock;

/**
 *  活动列表插入的标签
 *
 *  @param activityTag 活动类型Id
 *  @param cacheMode   缓存方式
 */
+ (void)getActivityListInsertTagWithActivityTag:(NSString *)activityTag cacheMode:(EnumCacheMode)cacheMode UsingBlock:(HttpResponseBlock)responseBlock;



#pragma mark - ———————————————————  文化日历  —————————————————————

/**
 *  文化日历列表
 *
 *  @param date         日期（yyyy-MM-dd）
 *  @param activityType 活动类型Id
 *  @param pageIndex    数据索引
 *  @param cacheMode    缓存方式
 */
+ (void)getCultureCalendarListWithDate:(NSString *)date activityType:(NSString *)activityType pageIndex:(NSInteger)pageIndex cacheMode:(EnumCacheMode)cacheMode UsingBlock:(HttpResponseBlock)responseBlock;

/**
 *  我的日历列表
 *
 *  @param startDate 开始日期（yyyy-MM-dd）
 *  @param endDate   结束日期（yyyy-MM-dd）
 *  @param pageIndex 数据索引
 *  @param cacheMode 缓存方式
 */
+ (void)getMyCalendarListWithStartDate:(NSString *)startDate endDate:(NSString *)endDate pageIndex:(NSInteger)pageIndex cacheMode:(EnumCacheMode)cacheMode UsingBlock:(HttpResponseBlock)responseBlock;

/**
 *  我的日历（历史活动）
 *
 *  @param pageIndex 数据索引
 *  @param cacheMode 缓存方式
 */
+ (void)getMyCalendarHistoryListWithPageIndex:(NSInteger)pageIndex cacheMode:(EnumCacheMode)cacheMode UsingBlock:(HttpResponseBlock)responseBlock;


#pragma mark - ———————————————————  场馆列表  —————————————————————

/**
 *  场馆列表
 *
 *  @param appType    列表类型：1-距离  2-最新 3-热门
 *  @param venueName  场馆名称
 *  @param venueArea  场馆区域code
 *  @param venueType  场馆类型Id
 *  @param venueCrowd 场馆人群（废弃字段）
 *  @param pageIndex  数据索引
 *  @param pageNum    数据条数
 *  @param cacheMode  缓存方式
 */
+ (void)getVenueListWithAppType:(NSString *)appType venueName:(NSString *)venueName venueArea:(NSString *)venueArea venueType:(NSString *)venueType venueCrowd:(NSString *)venueCrowd pageIndex:(NSInteger)pageIndex pageNum:(NSInteger)pageNum cacheMode:(EnumCacheMode)cacheMode UsingBlock:(HttpResponseBlock)responseBlock;

/**
 *  场馆筛选列表
 *
 *  @param venueType      场馆类型Id
 *  @param venueArea      场馆区域code
 *  @param venueLocation  场馆商圈Id
 *  @param sortType       排序方式：1-热 程度 2-离我最近 为空时- 更新时间
 *  @param venueIsReserve 是否可预订：1-全部  2-可预订
 *  @param pageIndex      数据索引
 *  @param pageNum        数据条数
 *  @param cacheMode      缓存方式
 */
+ (void)getVenueFilterListWithVenueType:(NSString *)venueType venueArea:(NSString *)venueArea venueLocation:(NSString *)venueLocation sortType:(NSString *)sortType venueIsReserve:(NSString *)venueIsReserve pageIndex:(NSInteger)pageIndex pageNum:(NSInteger)pageNum cacheMode:(EnumCacheMode)cacheMode UsingBlock:(HttpResponseBlock)responseBlock;

/**
 *  获取场馆的附加信息（在线活动数、活动室数）
 *
 *  @param venueId 场馆Id
 */
+ (void)getVenueAdditionalInfoWithVenueId:(NSString *)venueId UsingBlock:(HttpResponseBlock)responseBlock;


#pragma mark - ———————————————————  活动详情  —————————————————————

/**
 *  活动详情
 *
 *  @param activityId 活动Id
 */
+ (void)getActivtyDetailWithActivityId:(NSString *)activityId UsingBlock:(HttpResponseBlock)responseBlock;

/**
 *  活动场次列表（3.5.2）
 *
 *  @param activityId 活动Id
 *  @param isSeckill  是否为秒杀
 */
+ (void)getActivitySeckillListWithActivityId:(NSString *)activityId isSeckill:(BOOL)isSeckill UsingBlock:(HttpResponseBlock)responseBlock;

/**
 *  演出方的其他活动
 *
 *  @param activityId    活动Id
 *  @param associationId 社团Id
 *  @param cacheMode     缓存方式
 */
+ (void)getActivityShowOtherListWithActivityId:(NSString *)activityId associationId:(NSString *)associationId cacheMode:(EnumCacheMode)cacheMode UsingBlock:(HttpResponseBlock)responseBlock;


#pragma mark  用户点赞


/**
 *  获取详情页点赞列表
 *
 *  @param dataType  数据类型
 *  @param modelId   数据Id
 *  @param pageIndex 数据索引
 *  @param pageNum   数据条数
 */
+ (void)getUserWantgoListWithType:(DataType)dataType modelId:(NSString *)modelId pageIndex:(NSInteger)pageIndex pageNum:(NSInteger)pageNum UsingBlock:(HttpResponseBlock)responseBlock;


/**
 *  添加、取消点赞接口
 *
 *  @param dataType 数据类型
 *  @param isCancel 是否取消点赞
 *  @param modelId  数据Id

 */
+ (void)userLikeOperationWithType:(DataType)dataType isCancel:(BOOL)isCancel modelId:(NSString *)modelId UsingBlock:(HttpResponseBlock)responseBlock;



#pragma mark    浏览量

/**
 *  详情页浏览量
 *
 *  @param dataType 数据类型
 *  @param modelId  数据Id
 */
+ (void)getScanCountWithDataType:(DataType)dataType modelId:(NSString *)modelId UsingBlock:(HttpResponseBlock)responseBlock;


#pragma mark    收藏


/**
 *  详情页收藏操作
 *
 *  @param dataType 数据类型
 *  @param isCancel 是否取消收藏
 *  @param modelId  数据Id
 */
+ (void)userCollectOperationWithDataType:(DataType)dataType isCancel:(BOOL)isCancel modelId:(NSString *)modelId UsingBlock:(HttpResponseBlock)responseBlock;



#pragma mark - ———————————————————  场馆详情  ———————————————————

/**
 *  场馆详情
 *
 *  @param venueId 场馆Id
 */
+ (void)getVenueDetailWithVenueId:(NSString *)venueId UsingBlock:(HttpResponseBlock)responseBlock;

/**
 *  场馆相关活动
 *
 *  @param venueId   场馆Id
 *  @param pageIndex 数据索引
 *  @param pageNum   数据条数
 *  @param cacheMode 缓存方式
 */
+ (void)getVenueRelatedActivityListWithVenueId:(NSString *)venueId pageIndex:(NSInteger)pageIndex pageNum:(NSInteger)pageNum cacheMode:(EnumCacheMode)cacheMode UsingBlock:(HttpResponseBlock)responseBlock;


#pragma mark - ———————————————————  场馆藏品  —————————————————————

/**
 *  根据场馆Id获取藏品列表、索引列表(3.1)
 *
 *  @param venueId   场馆Id
 *  @param pageIndex 数据索引
 *  @param pageNum   数据条数
 *  @param cacheMode 缓存方式
 */
+ (void)getAntiqueListWithVenueId:(NSString *)venueId pageIndex:(NSInteger)pageIndex pageNum:(NSInteger)pageNum cacheMode:(EnumCacheMode)cacheMode UsingBlock:(HttpResponseBlock)responseBlock;

/**
 *  藏品列表筛选_分类
 *
 *  @param antiqueType 藏品类别Id
 *  @param venueId     场馆Id
 *  @param pageIndex   数据索引
 *  @param pageNum     数据条数
 *  @param cacheMode   缓存方式
 */
+ (void)getAntiqueFilterListByAntiqueType:(NSString *)antiqueType venueId:(NSString *)venueId pageIndex:(NSInteger)pageIndex pageNum:(NSInteger)pageNum cacheMode:(EnumCacheMode)cacheMode UsingBlock:(HttpResponseBlock)responseBlock;

/**
 *  藏品列表筛选_年代
 *
 *  @param antiqueDynasty 藏品年代
 *  @param venueId        场馆Id
 *  @param pageIndex      数据索引
 *  @param pageNum        数据条数
 *  @param cacheMode      缓存方式
 */
+ (void)getAntiqueFilterListByAntiqueDynasty:(NSString *)antiqueDynasty venueId:(NSString *)venueId pageIndex:(NSInteger)pageIndex pageNum:(NSInteger)pageNum cacheMode:(EnumCacheMode)cacheMode UsingBlock:(HttpResponseBlock)responseBlock;

/**
 *  藏品详情
 *
 *  @param antiqueId 藏品Id
 */
+ (void)getAntiqueDetailWithAntiqueId:(NSString *)antiqueId UsingBlock:(HttpResponseBlock)responseBlock;



#pragma mark - ———————————————————  活动预订  —————————————————————

/**
 *  预订活动
 *
 *  @param activityId         活动Id
 *  @param bookCount          预订票数
 *  @param activityEventIds   活动场次Id
 *  @param seatIds            活动座位Id
 *  @param seatValues         活动座位
 *  @param activityEventTimes 活动场次时间
 *  @param mobile             手机号
 *  @param orderPrice         订单价格
 *  @param orderName          预订人
 *  @param identityCard       身份证号
 *  @param costCredit         一共要扣除的积分
 */
+ (void)reserveActivityWithActivityId:(NSString *)activityId bookCount:(NSUInteger)bookCount activityEventIds:(NSString *)activityEventIds seatIds:(NSString *)seatIds seatValues:(NSString *)seatValues activityEventTimes:(NSString *)activityEventTimes mobile:(NSString *)mobile orderPrice:(NSString *)orderPrice orderName:(NSString *)orderName identityCard:(NSString *)identityCard costCredit:(NSString *)costCredit UsingBlock:(HttpResponseBlock)responseBlock;

/**
 *  获取在线选座类活动的座位信息
 *
 *  @param activityId        活动Id
 *  @param eventId           活动场次Id
 *  @param activityEventTime 活动场次时间
 */
+ (void)getActivitySeatInfoWithActivityId:(NSString *)activityId eventId:(NSString *)eventId activityEventTime:(NSString *)activityEventTime UsingBlock:(HttpResponseBlock)responseBlock;






#pragma mark - ———————————————————  活动室与活动室预订  —————————————————————

/**
 *  场馆相关活动室
 *
 *  @param venueId   场馆Id
 *  @param pageIndex 数据索引
 *  @param pageNum   数据条数
 *  @param cacheMode 缓存方式
 */
+ (void)getPlayroomListWithVenueId:(NSString *)venueId pageIndex:(NSInteger)pageIndex pageNum:(NSInteger)pageNum cacheMode:(EnumCacheMode)cacheMode UsingBlock:(HttpResponseBlock)responseBlock;

/**
 *  活动室详情
 *
 *  @param playroomId 活动室Id
 */
+ (void)getPlayroomDetailWithPlayroomId:(NSString *)playroomId UsingBlock:(HttpResponseBlock)responseBlock;

/**
 *  活动室预订
 *
 *  @param playroomId 活动室Id
 *  @param bookId     预订Id
 */
+ (void)reservePlayroomWithPlayroomId:(NSString *)playroomId bookId:(NSString *)bookId UsingBlock:(HttpResponseBlock)responseBlock;

/**
 *  活动室订单确定
 *
 *  @param bookId        预订Id
 *  @param orderName     预订人
 *  @param orderTel      预订人手机号
 *  @param teamUserId    使用者Id
 *  @param teamUserName  使用者名称
 *  @param purpose       使用用途
 */
+ (void)playroomOrderConfirmWithBookId:(NSString *)bookId orderName:(NSString *)orderName orderTel:(NSString *)orderTel teamUserId:(NSString *)teamUserId teamUserName:(NSString *)teamUserName purpose:(NSString *)purpose UsingBlock:(HttpResponseBlock)responseBlock;






#pragma mark - ———————————————————  搜  索  —————————————————————

/**
 *  搜索活动或场馆(3.5)
 *
 *  @param dataType  数据类型
 *  @param modelType 数据类型标签Id
 *  @param modelArea 数据区域code
 *  @param searchKey 搜索关键词
 *  @param pageIndex 数据索引
 *  @param pageNum   数据条数
 *  @param cacheMode 数据缓存
 */
+ (void)searchActivityAndVenueWithType:(DataType)dataType modelType:(NSString *)modelType modelArea:(NSString *)modelArea searchKey:(NSString *)searchKey pageIndex:(NSInteger)pageIndex pageNum:(NSInteger)pageNum cacheMode:(EnumCacheMode)cacheMode UsingBlock:(HttpResponseBlock)responseBlock;

/**
 *  活动搜索标签
 */
+ (void)searchTagActivityUsingBlock:(HttpResponseBlock)responseBlock;

/**
 *  场馆搜索标签
 */
+ (void)searchTagVenueUsingBlock:(HttpResponseBlock)responseBlock;


/**
 *  热门搜索标签
 *
 *  @param dataType  数据类型
 *  @param cacheMode 缓存方式
 */
+ (void)getSearchHotTagWithDataType:(DataType)dataType cacheMode:(EnumCacheMode)cacheMode UsingBlock:(HttpResponseBlock)responseBlock;

/**
 *  活动热搜词/“新”标签
 *
 *  @param type 类型：1-活动热的天数 2-热搜关键词
 */
+ (void)getAcitivitySearchHotKeywordsAndNewTagWithType:(NSString *)type UsingBlock:(HttpResponseBlock)responseBlock;

/**
 *  获取区域和区域下面对应的商圈
 */
+ (void)getActivityAllAreaAndBussinessRegionUsingBlock:(HttpResponseBlock)responseBlock;

/**
 *  搜索联想词
 *
 *  @param keyword 搜索关键词
 */
+ (void)getSearchMatchedWordsWithKeyword:(NSString *)keyword UsingBlock:(HttpResponseBlock)responseBlock;




#pragma mark - ———————————————————  验证码  —————————————————————

/**
 *  App获取验证码的接口
 *
 *  @param type     验证码类型
 *  @param phoneNum 手机号
 */
+ (void)getCheckCodeWithType:(CheckCodeType)type phoneNum:(NSString *)phoneNum UsingBlock:(HttpResponseBlock)responseBlock;





#pragma mark - ———————————————————  广告位  —————————————————————

/**
 *  获取App首页与文化空间的广告位
 *
 *  @param advertPosition 广告位置：2-首页  3-文化空间
 *  @param advertType     广告类型：A、B、C、D、E（E为全国版，猜你喜欢的数据）
 *  @param cacheMode      缓存类型
 */
+ (void)getAppAdvertListWithAdvertPosition:(NSInteger)advertPosition advertType:(NSString *)advertType cacheMode:(EnumCacheMode)cacheMode UsingBlock:(HttpResponseBlock)responseBlock;

/**
 *  获取首页A、B、C、D四类广告
 *
 *  @param cacheMode     缓存类型
 *  @param isNationwide  是否为全国版
 */
+ (void)getAdvertListOfHomepageWithCacheMode:(EnumCacheMode)cacheMode isNationwide:(BOOL)isNationwide UsingBlock:(HttpResponseBlock)responseBlock;

/**
 *  活动列表广告位列表
 *
 *  @param tagId     活动类型Id
 *  @param pageIndex 数据索引
 *  @param pageNum   数据条数
 *  @param cacheMode 缓存方式
 */
+ (void)getMainIndexAdvListWithActivityType:(NSString *)tagId pageIndex:(NSInteger)pageIndex pageNum:(NSInteger)pageNum cacheMode:(EnumCacheMode)cacheMode UsingBlock:(HttpResponseBlock)responseBlock;

/**
 *  日历广告位
 *
 *  @param date          日期（yyyy-MM-dd）
 *  @param cacheMode     缓存方式
 */
+ (void)getCalendarAdvertListWithDate:(NSString *)date cacheMode:(EnumCacheMode)cacheMode UsingBlock:(HttpResponseBlock)responseBlock;





#pragma mark - ———————————————————  标签管理  —————————————————————

/**
 *  活动标签列表
 *
 *  @param userId 用户Id
 */
+ (void)getTagListOfActivityWithUserId:(NSString *)userId UsingBlock:(HttpResponseBlock)responseBlock;

/**
 *  上传用户选择的标签(主题)
 *
 *  @param selectedTags  选中的标签id（英文逗号拼接）
 */
+ (void)uploadUserTagsWithUserSelectedTags:(NSString *)selectedTags UsingBlock:(HttpResponseBlock)responseBlock;

/**
 *  获取文化空间的标签
 */
+ (void)getTagListOfCultureSpacingUsingBlock:(HttpResponseBlock)responseBlock;



#pragma mark - —————————————————— 订单支付相关接口 ——————————————————


/**
 *  获取订单的预支付信息
 *
 *  @param dataType 数据类型
 *  @param orderId  订单Id
 */
+ (void)getPrepayInfoWithDataType:(DataType)dataType orderId:(NSString *)orderId UsingBlock:(HttpResponseBlock)responseBlock;

/**
 *  获取订单支付参数
 *
 *  @param orderId 订单Id
 *  @param payType 支付方式
 */
+ (void)getOrderPayParamsWithOrderId:(NSString *)orderId payType:(PayPlatformType)payType UsingBlock:(HttpResponseBlock)responseBlock;

/**
 *  查询订单支付结果
 *
 *  @param orderId 订单Id
 */
+ (void)getOrderPayResultWithOrderId:(NSString *)orderId UsingBlock:(HttpResponseBlock)responseBlock;


#pragma mark - ———————————————————  其他接口  —————————————————————

/**
 * App版本更新
 */
+ (void)checkAppVersionUpdateUsingBlock:(HttpResponseBlock)responseBlock;

/**
 * 获取启动页图片
 */
+ (void)getLaunchImageUrlUsingBlock:(HttpResponseBlock)responseBlock;

/**
 * 获取图片地址的前缀（只在每次程序启动时调用一次）
 */
+ (void)getImageUrlPrefixUsingBlock:(HttpResponseBlock)responseBlock;

/**
 *  统计用户转发，增加用户积分的接口
 *
 *  @param type     转发类型：1-活动详情转发  2-场馆详情转发  3-图片转发分享  4-H5页面转发
 *  @param url      转发链接
 *  @param platform 转发平台：1-微信好友 2-微信朋友圈 3-QQ好友 4-微博
 *  @param shareId  数据Id
 */
+ (void)userShareStatisticsWithContentType:(NSInteger)type link:(NSString *)url shareType:(ShareType)platform shareId:(NSString *)shareId UsingBlock:(HttpResponseBlock)responseBlock;

/**
 * 获取App Store版本号
 */
+ (void)getAppVersionFromAppStore;


@end
