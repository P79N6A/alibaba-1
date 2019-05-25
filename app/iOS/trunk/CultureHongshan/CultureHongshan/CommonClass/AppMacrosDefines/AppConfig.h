//
//  AppConfig.h
//  CultureHongshan
//
//  Created by ct on 17/3/17.
//  Copyright © 2017年 CT. All rights reserved.
//

#ifndef AppConfig_h
#define AppConfig_h


// 是否为生产环境
#define PRODUCTION_ENVIRONMENT  1
// 是否为调试模式
#define DEBUG_MODE  0 // 正式环境需要把这个设置为0，否则没有接口统计功能
#define LOG_MODE    0 // 日志输出模式: 1-输出到文件，0-不输出
#define LOG_REQUEST_RESULT 1

/*************************************************************************************************/


#define APP_VERSION                [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"]
#define APP_DISPLAY_NAME           [[NSBundle mainBundle] infoDictionary][@"CFBundleDisplayName"]

/*************************************************************************************************/



/****************************************  项目配置数据  ***********************************************/

#define APP_SCHEME_FULL @"com.hongshanwhy.app://"
#define APP_SCHEME      @"com.hongshanwhy.app"
#define APP_ID          @"1354329849"
#define APP_BUNDLE_ID   @"cn.creatoo.hb.hongshancloud"

#define CITY_NAME        @"洪山"
#define APP_SHOW_NAME    @"洪山文化云"

#define CITY_AD_CODE     @"420111"
#define USER_AGENT_IDENTIFIER @"hongshan Wenhuayun"



/*************************************************************************************************/



#define kRefreshCount     20  // 刷新数据的条数
#define kFixedProtocolKey @"Fixed_Protocol_Key" // 是否为固定接口的请求数据


#define kUserDefault_AppNewestVersion  @"AppNewestVersion"            // AppStore上的最新版本号
#define kUserDefault_MessageNumber     @"pageNumber"                  // 上一次接收到的用户消息条数
#define kUserDefault_LaunchImageURL    @"LaunchImageURL"              // 启动页图片链接
#define kUserDefault_ImageUrlPrefix    @"ImageUrlPrefix"              // 新框架中图片链接的前缀，启动应用时更新一次
#define kUserDefault_CityList          @"city_list_and_city_interface"// 所有的城市列表数据

#define kChinaKey                @"中国"
#define kChinaCityCode           @"999999" // 全国的cityCode
#define DEFAULT_VALUE_UUID       @"cn.creatoo.hb.hongshancloud.fishbird"
#define kAliFileDomainIdentifier @".aliyuncs.com/"
#define DEFAULT_IMAGE_URL        @"http://www.wenhuayun.cn/STATIC/image/noimage_bg.png"


#define kUserNickNameMaxLength  7 // 用户昵称的最大长度

/************************************ 第三方账号 ******************************************/

// 高德地图
#define kAppKey_AMap      @"918ca7f1b24b50c78c3d6baf22c090da"

// QQ
#define kAppID_QQ         @""
#define kAppKey_QQ        @""

// 微信
#define kAppID_Wechat     @"wx0cd0d426ed59ff82"
#define kAppSecret_Wechat @"81a48e7491c1f6eaba931fda580cd7d8"
#define kPartnerId_Wechat @""

// 新浪微博
#define kAppKey_Sina      @""
#define kAppSecret_Sina   @""
#define kWeiboRedirectUri @""

#define kAppKey_Mob     @"5a44b360f43e485723000040" // 友盟统计
#define kAppID_ShareSDK @"236367e890dca" // ShareSDK登录、分享
#define kAppKey_JPush   @"" // JPush推送

#define kAppJsSDK     @"injs"             //v3.5.4开始，这个值不能做改变


#define kPictureMaxPixel   1500 // 上传图片的最大像素
#define kPictureMaxByte    350*1024 // 上传图片的文件大小限制: 400kb


// 常量字符串
#define PRIVACY_PHOTO_LIBRARY_ALERT [NSString stringWithFormat:@"无法访问图库，请在系统设置中打开权限：设置->隐私->照片->%@", APP_SHOW_NAME]
#define PRIVACY_CAMERA_ALERT        [NSString stringWithFormat:@"无法启动相机，请在系统设置中打开权限：设置->隐私->相机->%@", APP_SHOW_NAME]
#define PRIVACY_LOCATION_ALERT      @"本应用需要使用您的定位信息，为您推荐附近的优质活动及内容"
#define STRING_FOR_CANT_SHARE       @"抱歉，当前页面无法进行分享操作！"  // 无法分享



// ————————————————— 功能列表 —————————————————

#define FUNCTION_ENABLED_SHARE 1       // 分享
//#define FUNCTION_ENABLED_SQUARE 1      // 广场
#define FUNCTION_ENABLED_THIRD_LOGIN 1 // 第三方登录

// 限制单个第三方的功能
#define FUNCTION_ENABLED_WECHAT  1 // 微信
//#define FUNCTION_ENABLED_QQ      1 // QQ
//#define FUNCTION_ENABLED_WEIBO   1 // 微博

//#define FUNCTION_ENABLED_PAY_SERVICE // 支付功能
//#define FUNCTION_ENABLED_PUSH_SERVICE // 推送功能

//#define FUNCTION_ENABLED_USER_GUIDE 1 // 新手引导页
//#define FUNCTION_ENABLED_LAUNCH_PAGE 1 // 开机启动页


#endif /* AppConfig_h */
