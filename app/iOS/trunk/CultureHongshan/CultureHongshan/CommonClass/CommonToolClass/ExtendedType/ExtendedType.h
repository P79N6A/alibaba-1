//
//  ExtendedType.h
//  CultureHongshan
//
//  Created by ct on 16/4/12.
//  Copyright © 2016年 CT. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AdvertModel;

#pragma mark - 扩展的Block

//按钮点击的回调，可以知道点击的是第几个按钮
typedef void (^IndexBlock)(id object, NSInteger index, BOOL isSameIndex);

//分享的回调Block
typedef void (^ShareStatusBlock)(NSUInteger status);//SSDKResponseState

//登录的回调
typedef void (^LoginCallBackBlock)(NSInteger statusCode);//状态码: 1- 成功， 2-失败

typedef void (^AnimationBlock)(BOOL finished);//

//
typedef void (^AdvertBlock)(AdvertModel *model, UIImage *shareImage);

typedef void(^ButtonActionBlock)(id sender);


#pragma mark - 扩展的枚举类型

typedef NS_ENUM(NSInteger, ShareType) {
    ShareTypeUndefine = 0,
    ShareTypeWeiXinFriend,
    ShareTypeWeiXinFriendsCircle,
    ShareTypeQQFriend,
    ShareTypeWeibo,
};

typedef NS_ENUM(NSInteger, LoginVCSourceType) {
    LoginVCSourceTypeUndefine = 0,
    LoginVCSourceTypePersonalCenter,//个人中心
    LoginVCSourceTypeLaunchPage,//启动页面
    LoginVCSourceTypeRegisterPage,//注册页面：注册完后进入登录页面
    LoginVCSourceTypeOther,//其他页面：详情页面、活动室预订页面等
};

typedef NS_ENUM(NSInteger, LoginType) {
    LoginTypeUnknown = 0,//未知
    LoginTypeWenHuaYun,//文化云平台
    LoginTypeWechat,//微信
    LoginTypeQQ,//QQ
    LoginTypeSina,//新浪微博
    LoginTypeSubPlatform,//子平台
    LoginTypeWenHuaYunDynamic, //文化云动态密码登录
};

typedef enum {
    SearchTypeActivity  = 1,
    SearchTypeVenue = 2,
} SearchType;


//数据的类型
typedef enum {
    DataTypeUnknown = 0,
    DataTypeActivity,
    DataTypeVenue,
    DataTypeCalendarActivity, // 日历中的普通活动
    DataTypeCalendarGatherActivity, // 日历中的采编活动
} DataType;

//获取验证码的类型
typedef enum {
    CheckCodeTypeUnknown = 0,
    CheckCodeTypeRegister,//注册时获取验证码
    CheckCodeTypeDynamicLogin,//动态登录时获取验证码
    CheckCodeTypeFindPassWord,//忘记密码时获取验证码
    CheckCodeTypeBindingMobile,//绑定手机号时获取验证码
    CheckCodeTypeBookActivity,//活动预订时获取验证码
} CheckCodeType;


// App页面类型
typedef enum {
    AppPageTypeActivityDetail = 1,//活动详情 1
    AppPageTypeVenueDetail,//场馆详情 2
    AppPageTypeActivityRoomDetail,//活动室详情 3
    AppPageTypeActivityList,//活动列表 4
    AppPageTypeVenueList,//场馆列表 5
    AppPageTypePersonalCenter,// 个人中心 6
    AppPageTypeOrderList,// 我的订单列表 7
    AppPageTypeActicityOrderDetail,// 活动订单详情 8
    AppPageTypeVenueOrderDetail, //活动室订单详情  9
    AppPageTypeLogin, //登录页面  10
    AppPageTypeAssociationList, //社团列表  11
    AppPageTypeCalendarList = 12, // 文化日历  12
    AppPageTypeActivityListWithFilter = 13, // 活动列表(带筛选)  13
    AppPageTypeTabBarRootVC = 14, // 跳转TabBarVC的根页面
    AppPageTypeExitWebView = 100, // 跳出H5页面
    AppPageTypeOrderPay = 200, // 订单支付页面
} AppPageType;



typedef enum : NSUInteger {
    NoDataPromptStyleNone,
    NoDataPromptStyleClickRefreshForNoContent,// 没有内容
    NoDataPromptStyleClickRefreshForNoNetwork, // 断网
    NoDataPromptStyleClickRefreshForError,
    NoDataPromptStyleTextOnly, // 只显示文本
} NoDataPromptStyle;



typedef NS_ENUM(NSInteger,FileUploadType) {
    FileUploadTypeUnknown = -1,             // 未知类型（不上传）
    FileUploadTypeActivityCommentImage = 1, // 活动评论上传图片
    FileUploadTypeVenueCommentImage,        // 场馆评论上传图片
    FileUploadTypeUserHeaderImage,          // 更新个人头像
    FileUploadTypeUserFeedbackImage,        // 用户反馈图片
};


typedef enum : NSUInteger {
    CityStyleBranch,// 分设城市
    CityStyleNationwide,// 全国
} CityStyle;


typedef enum : NSUInteger {
    LocatitonStatusForbidden,// 禁止定位
    LocatitonStatusNotStarted, // 允许定位，但未开始定位
    LocatitonStatusUpdating, // 定位中
    LocatitonStatusSuccess, // 定位成功
    LocatitonStatusFailed, // 定位失败
} LocatitonStatus;


/** 活动采编类型 */
typedef NS_ENUM(NSInteger, ActivityGatherType) {
    /** 未知标签类型 */
    ActivityGatherTypeUnknown = 0,
    /** 热映影片 */
    ActivityGatherTypeReyingYingpian,
    /** 舞台演出 */
    ActivityGatherTypeWutaiYanchu,
    /** 美术展览 */
    ActivityGatherTypeMeishuZhanlan,
    /** 音乐会 */
    ActivityGatherTypeYinyuehui,
    /** 演唱会 */
    ActivityGatherTypeYanchanghui,
    /** 舞蹈 */
    ActivityGatherTypeWudao,
    /** 话剧歌剧 */
    ActivityGatherTypeHuajuGeju,
    /** 戏曲曲艺 */
    ActivityGatherTypeXiquQuyi,
    /** 儿童剧 */
    ActivityGatherTypeErtongju,
    /** 杂技魔术 */
    ActivityGatherTypeZajiMoshu,
};



/**
 *  Label的字体
 */
UIKIT_EXTERN NSString * const MYFontAttributeName;
/**
 *  第一列Label的左侧 距离 父视图左侧 的间距，默认值为0。
 */
UIKIT_EXTERN NSString * const MYOffsetXAttributeName;
/**
 *  第一行Label的顶部 距离 父视图的顶部 的间距，默认值为0。
 */
UIKIT_EXTERN NSString * const MYOffsetYAttributeName;
/**
 *  最左、最右侧的Label边缘 距离 父视图的边缘 的间距（左右两侧的空白间隙相等），默认值为0。
 */
UIKIT_EXTERN NSString * const MYHorizontalMarginAttributeName;
/**
 *  水平方向两个Label之间的间距，默认值为10。
 */
UIKIT_EXTERN NSString * const MYSpacingXAttributeName;
/**
 *  垂直方向两个Label之间的间距，默认值为10。
 */
UIKIT_EXTERN NSString * const MYSpacingYAttributeName;
/**
 *  一个Label的高度，默认值为20。
 */
UIKIT_EXTERN NSString * const MYItemHeightAttributeName;
/**
 *  Label的内边距，默认值为12。
 */
UIKIT_EXTERN NSString * const MYLabelPaddingAttributeName;
/**
 *  用于显示Label的区域的宽度，默认值为“父视图的宽度”。
 */
UIKIT_EXTERN NSString * const MYContainerWidthAttributeName;
/**
 *  是否只显示一行，@"YES" 或 [NSNumber numberWithBool:YES]
 */
UIKIT_EXTERN NSString * const MYShowOnlySingleLineAttributeName;




@interface ExtendedType : NSObject

@end
