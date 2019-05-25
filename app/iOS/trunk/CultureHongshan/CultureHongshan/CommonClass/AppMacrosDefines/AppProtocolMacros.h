//
//  AppProtocolMacros.h
//  CultureHongshan
//
//  Created by ct on 17/3/17.
//  Copyright © 2017年 CT. All rights reserved.
//

#ifndef AppProtocolMacros_h
#define AppProtocolMacros_h


/*********************************** 服务器接口地址 *************************************/



#ifdef PRODUCTION_ENVIRONMENT
#define kProtocolFixedUrl    @"http://hs.hb.wenhuayun.cn/"
#define kProtocolNewFixedUrl @"http://hsm.hb.wenhuayun.cn:10019/"
#else
#define kProtocolFixedUrl    @""
#define kProtocolNewFixedUrl @""
#endif

#define kProtocolShanghaiUrl_Production    @"http://hs.hb.wenhuayun.cn/"

#define kProtocolUrl    @"http://hs.hb.wenhuayun.cn/"    // 旧框架的接口地址
#define kProtocolNewUrl @"http://hsm.hb.wenhuayun.cn:10019/" // 新框架接口



#pragma mark - —————————————————— 个人中心 ——————————————————

/*   ————————————————————————————————  用户信息   ————————————————————————————————    */
#define kUserInfoByUserIdUrl @"appUser/queryTerminalUserById.do"// 根据用户id获取用户信息
#define kUserInfoUpdateUrl   @"appUser/editTerminalUser.do"     // 更新用户信息

/*   ————————————————————————————————  登录与注册   ————————————————————————————————    */
#define kLoginThirdPlatformUrl    @"login/appOpenUser.do"// 第三方平台登录
#define kLoginWenHuaYunUrl        @"login/doLogin.do"    // 文化云登录
#define kLoginWenHuaYunDynamicUrl @"user/login"          // 文化云动态密码登录
#define kUserRegisterUrl          @"login/doRegister.do" // 用户注册

/*   ————————————————————————————————    密码     ————————————————————————————————    */

#define kFindPasswordEditPasswordUrl @"appUser/editTerminalUserByPwd.do"// 忘记密码修改密码
#define kChangePasswordUrl           @"appUser/appValidatePwd.do"       // 修改密码

/*   ————————————————————————————————  我的消息   ————————————————————————————————    */
#define kUserMessageUrl    @"appUserMessage/userAppMessage.do"// 获取用户消息
#define kDeleteUserInfoUrl @"appUserMessage/delAppMessage.do" // 删除用户消息

#pragma mark - 我的订单
/*   ————————————————————————————————  我的订单   ————————————————————————————————    */
#define kUserOrderSearchUrl @"appUserOrder/userOrders.do"// 搜索"我的订单"
//订单列表
#define kUserOrderUncheckedUrl     @"appUserOrder/appUserCheckOrder.do"  // 待审核
#define kUserOrderUnPayedUrl       @"wechatUser/userPayOrder.do"         // 待支付
#define kUserOrderUnParticipateUrl @"appUserOrder/appUserOrder.do"       // 待参加
#define kUserOrderHistoryUrl       @"appUserOrder/appUserHistoryOrder.do"// 历史
//订单详情
#define kUserOrderDetailActivityUrl @"appUserOrder/userActivityOrderDetail.do"// 活动订单详情
#define kUserOrderDetailVenueUrl    @"appUserOrder/userRoomOrderDetail.do"    // 活动室订单详情
//订单操作
#define kCancelActivityUrl          @"appUserActivity/removeAppActivity.do"           // 取消活动订单
#define kCancelPlayRoomUrl             @"appUserVenue/removeAppRoomOrder.do"             // 取消活动室订单
#define kDeleteActivityHistoryOrder @"appUserActivity/deleteAppUserActivityHistory.do"// 删除活动预订历史订单
#define kDeletePlayRoomHistoryOrder @"appUserVenue/deleteAppRoomOrder.do"             // 删除活动室预订历史订单

/*   ————————————————————————————————  我的收藏   ————————————————————————————————    */
#define kUserCollectActivityUrl       @"appUserCollect/userAppCollectAct.do" // 用户收藏的活动列表
#define kUserCollectExhibitionHallUrl @"appUserCollect/userAppCollectVen.do" // 用户收藏的场馆列表
#define kUserCollectionGroupUrl       @"appUserCollect/userAppCollectTeam.do"// 用户收藏的团体列表

/*   ————————————————————————————————  我的评论   ————————————————————————————————    */
#define kUserCommentListActivityUrl   @"appActivity/appActivityCommentList.do"  // 我的评论_活动评论列表
#define kUserCommentListVenueUrl      @"appVenue/appVenueCommentList.do"        // 我的评论_场馆评论列表

#define kUserCommentDeleteActivityUrl @"appActivity/appDeleteActivityComment.do"// 删除用户评论_活动
#define kUserCommentDeleteVenueUrl    @"appVenue/appDeleteVenueComment.do"      // 删除用户评论_场馆

#define kCommentListOfDetailPageUrl   @"appActivity/activityAppComment.do"      // 详情页评论列表（活动和场馆）
#define kCommentPublishUrl            @"appActivity/addComment.do"              // 发表评论

/*   ————————————————————————————————  我的积分   ————————————————————————————————    */
#define kUserAccumulativeScoreRecentlUrl @"appUser/appUserIntegralDetail.do"    // 最近30天积分明细列表
#define kUserAccumulativeScoreListUrl    @"appUser/appUserIntegralDetailList.do"// 更多积分明细列表

/*   ————————————————————————————————  其它   ————————————————————————————————    */
#define kUserFeedBackUrl @"appUser/appFeedInformation.do"// 用户意见反馈



#pragma mark - —————————————————— 活动列表 ——————————————————

#define kActivityYouMayLoveUrl          @"activity/recommendActivity"              // 首页的"猜你喜欢"活动列表
#define kActivityAllUrl                 @"appActivity/appActivityIndex.do"         // 原先地图页中的活动列表（暂时不用了）
#define kTopActivityUrl                 @"appActivity/appTopActivityList.do"       // 置顶活动
#define kRecommendActivityUrl           @"appActivity/appRecommendActivityList.do" // 推荐活动
#define kRecommendActivityWithFilterUrl @"appActivity/appFilterActivityList.do"    // 3.5.2
#define kNearLocationActivityAllUrl     @"appActivity/appNearActivityList.do"      // 附近活动列表
#define kActivityNearUrl                @"appActivity/appNearActivity.do"          // 近期活动
#define kActivityListInsertTagUrl       @"appActivity/appActivityListTagSub.do"    // 活动列表插入标签



#pragma mark - 文化日历

#define kAppEveryDateActivityCount    @"appActivity/appEveryDateActivityCount.do" // 日历下每天活动场数
//#define kAppEveryDateActivityList     @"appActivity/appActivityCalendarList.do"   // 查询日历中每一天的活动

#define kCultureCalendarListUrl       @"wechatActivity/wcCultureCalendarList.do"  // 文化日历列表
#define kMyCalendarActivityListUrl    @"wechatActivity/wcMyCultureCalendarList.do"// 我的日历列表
#define kMyCalendarHistoryActivityUrl @"wechatActivity/wcHistoryActivityList.do"  // 我的日历: 历史活动


#pragma mark - —————————————————— 场馆列表 ——————————————————


#define kGetExhibitionHallAllUrl @"appVenue/appVenueListIndex.do"// 场馆列表3_1
#define kVenueFilterListUrl      @"appVenue/appVenueList.do"     // 场馆筛选列表3_5
#define kVenueAdditionalInfoUrl  @"appVenue/appVenueCountInfo.do"// 获取场馆的在线活动数，活动室数量




#pragma mark - —————————————————— 活动详情 ——————————————————

#define kActivityDetailUrl           @"appActivity/cmsActivityAppDetail.do"// 活动详情
#define kActivitySeckillListUrl      @"appActivity/appActivityEventList.do"// 3.5.2 活动秒杀场次列表
#define kAssociationOtherActivityUrl @"association/associationActivity"    // 演出方的其他活动（app社团在线活动）

/*   ————————————————————————————————  用户点赞   ————————————————————————————————    */
#define kWantGoListActivityUrl   @"appActivity/appCmsActivityUserWantgoList.do"// 获取活动详情报名列表
#define kWantGoListVenueUrl      @"appVenue/appVenueUserWantgoList.do"         // 获取场馆详情报名列表
#define kWantGoActivityAddUrl    @"appActivity/appAddActivityUserWantgo.do"    // 添加活动报名列表
#define kWantGoActivityCancelUrl @"appActivity/deleteActivityUserWantgo.do"    // 取消活动报名列表
#define kWantGoVenueAddUrl       @"appVenue/appAddVenueUserWantgo.do"          // 添加场馆报名列表
#define kWantGoVenueCancelUrl    @"appVenue/appDeleteVenueUserWantgo.do"       // 取消场馆报名列表

/*   ————————————————————————————————  浏览量   ————————————————————————————————    */
#define kScanCountActivityUrl @"appActivity/appCmsActivityBrowseCount.do"// 获取活动的浏览量
#define kScanCountVenueUrl    @"appVenue/appCmsVenueBrowseCount.do"      // 获取场馆的浏览量

/*   ————————————————————————————————  收藏   ————————————————————————————————    */
#define kAddCollectActivityUrl            @"appUserCollect/appCollectActivity.do"   // 添加收藏活动
#define kCancelCollectActivityUrl         @"appUserCollect/appDelCollectActivity.do"// 取消收藏活动
#define kAddCollectExhibitionHallUrl      @"appUserCollect/appCollectVenue.do"      // 添加收藏展馆
#define kCancelCollectExhibitionHallUrl   @"appUserCollect/appDelCollectVenue.do"   // 取消收藏展馆
#define kAddCollectCalendarActivityUrl    @"wechat/wcCollect.do"                    // 添加收藏日历(采编)活动
#define kCancelCollectCalendarActivityUrl @"wechat/wcDelCollect.do"                 // 取消收藏日历(采编)活动


#pragma mark - —————————————————— 场馆详情 ——————————————————

#define kVenueDetailUrl              @"appVenue/cmsVenueAppDetail.do"  // 场馆详情3_1
#define kVenueRelatedActivityListUrl @"appVenue/venueAppCmsActivity.do"// 根据展馆ID查询相关活动



#pragma mark - ——————————————————  场馆藏品  ——————————————————

#define kAntiqueListAndIndexUrl     @"appAntique/antiqueAppIndex.do"         // 获取藏品列表及索引3_1
#define kAntiqueFilterByCategoryUrl @"appAntique/screenAppAntiqueTypeName.do"// 藏品筛选 按分类3_1
#define kAntiqueFilterByDynastyUrl  @"appAntique/screenAppAntiqueDynasty.do" // 藏品筛选 按朝代3_1
#define kAntiqueDetailUrl           @"appAntique/antiqueAppDetail.do"        // 藏品详情 3_1




#pragma mark - —————————————————— 活动预订 ——————————————————

#define kReserveActivityUrl  @"appActivity/appActivityOrder.do"// 活动预订
#define kActivitySeatInfoUrl @"appActivity/appActivityBook.do" // 活动在线选座的座位信息



#pragma mark - —————————————————— 活动室与活动室预订 ——————————————————

#define kPlayRoomListUrl          @"appVenue/activityAppRoom.do"// 活动室列表
#define kPlayRoomDetailUrl        @"appRoom/roomAppDetail.do"   // 活动室详情3_1
#define kPlayRoomBookUrl          @"appRoom/roomBook.do"        // 活动室预订
#define kPlayRoomOrderConfirmlUrl @"appRoom/roomOrderConfirm.do"// 活动室订单确定3_1






#pragma mark - ——————————————————  搜  索  ——————————————————

#define kSearchActivityUrl     @"activity/searchActivity"       // 根据条件搜索活动
#define kSearchVenueUrl        @"venue/searchVenue"             // 场馆搜索
#define kActivitySearchTagUrl  @"appTag/appActivityTagByType.do"// 活动搜索标签（暂时没有用了）
#define kVenueSearchTagUrl     @"appTag/appVenueTagByType.do"   // 场馆搜索标签
#define kSearchMatchedWordsUrl @"activity/automatedName"        // 搜索联想词
//热门分类、热门区域、热门搜索
#define kHotTagActivityUrl @"appHot/getActivity.do"
#define kHotTagVenueUrl    @"appHot/getVenue.do"
//活动热搜词和“新”标签: type : 1. 活动新天数  2. 热搜关键词
#define kActivityHotKeywordAndNewTagUrl @"appActivity/appSettingPara.do"
//获取区域和下面对应的商圈
#define kActivityAreaAndBussinessRegionUrl @"appActivity/getAllArea.do"



#pragma mark - —————————————————— 验证码 ——————————————————

#define kCheckCodeOfRegisterUrl      @"login/userCode.do"                  // 注册获取验证码
#define kCheckCodeOfDynamicLoginUrl  @"muser/loginSendCode.do"             // 动态登录获取验证码  user/sendCode
#define kCheckCodeOfFindPasswordUrl  @"appUser/editTerminalUserByMobile.do"// 忘记密码发送验证码
#define kCheckCodeOfBindingMobileUrl @"appUser/appSendCode.do"             // 绑定手机号码获取验证码
#define kCheckCodeOfBookActivityUrl  @"appUser/sendAuthCode.do"            // 活动预订时获取验证码




#pragma mark - —————————————————— 广 告 位 ——————————————————

#define kAppAdvertUrl           @"advertRecommend/pageAdvertRecommend"  // 包含首页与文化空间的广告位 v3.5.4
#define kAppAdvertRecommendList @"appActivity/appAdvertRecommendList.do"// 文化活动广告位列表 v3.5.3
#define kCalendarListAdvertUrl  @"appActivity/queryCalendarAdvert.do"   // 3.5.2：日历列表中的广告位


#pragma mark - ————————————————  标签管理  ————————————————

#define kActivityTagListUrl       @"appActivity/appActivityTagList.do"// 获取活动标签列表接口
#define kUserSelectedTagUploadUrl @"appTag/addUserTags.do"            // 上传用户选择标签



#pragma mark - ————————————————  H5接口  ————————————————

//关于文化云
#define kAboutCultureCloudUrl     [NSString stringWithFormat:@"wechatUser/preCulture.do?type=app&version=%@",APP_VERSION]
//积分规则
#define kAccumulativeScoreRuleUrl [NSString stringWithFormat:@"%@wechatUser/preIntegralRule.do?version=%@&type=app",kProtocolUrl,APP_VERSION]
//实名认证
#define kRealNameAuthUrl          [NSString stringWithFormat:@"%@wechatUser/auth.do?version=%@&type=app",kProtocolUrl,APP_VERSION]
//资质认证
#define kQualificationAuthUrl     [NSString stringWithFormat:@"%@wechatRoom/authTeamUser.do?version=%@&type=app",kProtocolUrl,APP_VERSION]
//帮助中心
#define kHelpCenterUrl            [NSString stringWithFormat:@"%@wechat/help.do?version=%@&type=app",kProtocolFixedUrl,APP_VERSION]
//社团列表
#define kAssociationListUrl       [NSString stringWithFormat:@"%@wechatStatic/cultureSquare.do",kProtocolUrl]
//活动预订H5
#define kActivityBookWebUrl       [NSString stringWithFormat:@"%@wechatActivity/preActivityOrder.do",kProtocolUrl]

//活动室预订H5
#define kActivityRoomBookWebUrl   [NSString stringWithFormat:@"%@wechatVenue/roomBookOrder.do",kProtocolUrl]
// 活动详情中演出单位（社团）跳转链接
#define kActDetailAssociationWebUrl [NSString stringWithFormat:@"%@wechatAssn/toAssnDetail.do",kProtocolUrl]
#define kFollowBrandWebUrl          @"http://www.so.com/" // 关注喜欢的品牌


#pragma mark - —————————————————— 订单支付相关接口 ——————————————————

#define kPrepayOrderInfoUrl        @"appUserOrder/userActivityOrderDetail.do"// 根据订单号查询订单的预支付信息
#define kOrderPayParamForWechatUrl @"pay/wxpreapppay"                        // 获取订单的支付参数
#define kOrderPayParamForAlipayUrl @"alipay/preapppay"                       // 获取订单的支付参数
#define kQueryOrderPayResultUrl    @"appUserOrder/userActivityOrderDetail.do"// 查询订单支付结果

#pragma mark - —————————————————— 其它接口 ——————————————————

#define kUploadAppFiles @"appUser/uploadAppFiles.do"// 上传多文件

#define kAppUpdateUrl      @"appUser/checkAppVersionNo.do"// 3.5.1：版本更新接口
#define kLaunchImageUrl    @"appUser/getMobileImage.do"   // 3.5.1：获取启动页图片接口
#define kImageUrlPrefixUrl @"staticServer/path"           // 获取图片地址的前缀

#define kUserShareIncreaseIntegeralUrl @"appUser/forwardingIntegral.do"//3.5.2用户转发增加积分接口
#define kUserShareStatisticsUrl        @"appUser/userShareStatistics.do"//3.5.2用户转发统计接口




#endif /* AppProtocolMacros_h */
