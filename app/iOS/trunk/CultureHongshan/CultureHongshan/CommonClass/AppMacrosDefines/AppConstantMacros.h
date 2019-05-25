//
//  AppConstantMacros.h
//  CultureHongshan
//
//  Created by ct on 17/3/17.
//  Copyright © 2017年 CT. All rights reserved.
//

#ifndef AppConstantMacros_h
#define AppConstantMacros_h


// Log日志
//#define kLogPath [NSTemporaryDirectory() stringByAppendingPathComponent:@"log.txt"]


#if DEBUG_MODE
#define FBLOG(format, ...)  MYBasicLog(@"JinZhongCloudApp", __FILE__, __LINE__, format, ##__VA_ARGS__)
#else
#define FBLOG(format, ...)
#endif


#define     WEAK_VIEW(view)             __weak  typeof(view) weakView = view;
#define     WEAK_VIEW1(view)            __weak  typeof(view) weakView1 = view;
#define     WEAK_VIEW2(view)            __weak  typeof(view) weakView2 = view;
#define     WEAK_VIEW3(view)            __weak  typeof(view) weakView3 = view;
#define     WEAK_VIEW4(view)            __weak  typeof(view) weakView4 = view;



#pragma mark -  ———————— 资源路径 ————————

#define kPersonalStatusTagListPath  [[NSBundle mainBundle] pathForResource:@"personal_status_tag_list" ofType:@"json"]

#define kUserLastGPSLocationPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"tmp_location.data"]



#pragma mark -  ———————— 一些常量 ————————

#define kQzoneImageUrl           @"http://qzapp.qlogo.cn/qzapp/1104771371/F1C11758CD2EE9B27DADE0330996529A/100"// QQ空间的图片链接
#define kLoginDefaultRedirectUrl @"DefaultRedirectUrl_ReloadPage"                                              // Web调用登录页面后的默认空回调地址
#define kOrderPayQueryKey        @"OrderPayQueryRandKey" // 订单支付结果查询Key


#pragma mark -  字体

#define     FONT_BIG                     FONT(16)
#define     FONT_SMALL                   FONT(12)
#define     FONT_MIDDLE                  FONT(14)

#define FontSystem(size)     [UIFont systemFontOfSize:(size)] // 普通的系统字体
#define FontSystemBold(size) [UIFont boldSystemFontOfSize:(size)] // 粗体的系统字体
#define FontYT(aSize)        [UIFont fontWithName:@"STYuanti-SC-Light" size:aSize] // 普通的圆体字体
#define FontYTBold(aSize)    [UIFont fontWithName:@"STYuanti-SC-Light" size:aSize]  // 粗体的圆体字体



#pragma mark - 尺寸相关


#define iPhone_3_5 (MAX([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) == 480)
#define iPhone_4_0 (MAX([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) == 568)
#define iPhone_4_7 (MAX([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) == 667)
#define iPhone_5_5 (MAX([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) == 736)
#define iPhone_5_8 (MAX([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) == 812)

// 判断是否是iPhone X
#define iPhoneX iPhone_5_8
// 状态栏高度
#define HEIGHT_STATUS_BAR (iPhone_5_8 ? 44.f : 20.f)
// 导航栏高度
#define HEIGHT_NAVIGATION_BAR  44.0f
#define HEIGHT_TOP_BAR (iPhone_5_8 ? 88.f : 64.f)
// TabBar高度
#define HEIGHT_TAB_BAR (iPhone_5_8 ? (49.f+34.f) : 49.f)
// Home Indicator
#define HEIGHT_HOME_INDICATOR (iPhone_5_8 ? 34.f : 0.f)


#define     __MainScreenFrame           [[UIScreen mainScreen] bounds]
#define     HEIGHT_SCREEN               (__MainScreenFrame.size.height-HEIGHT_NAVIGATION_BAR-HEIGHT_STATUS_BAR)
#define     HEIGHT_SCREEN_FULL          __MainScreenFrame.size.height
#define     WIDTH_SCREEN                (__MainScreenFrame.size.width)

#define     MRECT(x,y,w,h)               CGRectMake(x,y,w,h)
#define     MHEIGHT(height)              ((WIDTH_SCREEN/320)*height)

#define     HEIGHT_KEYBOARD             300.0
#define     HEIGHT_LINE                 0.6
#define     WIDTH_LEFT_SPAN             10
#define     HEIGHT_SCENE                (42 + HEIGHT_SCENE_WITHOUTUSER)
#define     HEIGHT_SCENE_WITHOUTUSER    (MHEIGHT(200) + 68)
#define     HEIGHT_POIROUTE             50
#define     WIDTH_SHRINKREMAIN          50
#define     kLineThick                  0.6f // 分割线的粗细


/**************************************** 颜色 **********************************************/


#define kNavigationBarColor  RGB(0x4b, 0x70, 0xb7)  // 导航条的颜色
#define kThemeDeepColor      RGB(0x53, 0xb0, 0xd2)  // 深色的主题色 53b0d2 4b70b7
#define kThemeLightColor     RGB(238, 102, 122) // 浅色的主题色
#define kThemeColorWithAlpha(alpha) RGBA(0x4b, 0x70, 0xb7, alpha)


#define kOrangeYellowColor   RGB(0xd4,0xc8,0x1c) // 橙黄色  d4c81c
#define kRedColor            RGB(252,  85, 86) // 粉红色
#define kDarkRedColor        RGB(0xD5, 0x81, 0x85) // 暗红色
#define kLineGrayColor       RGB(237, 237, 237)// 浅灰色的分割线
#define kLightRedColor       RGB(207, 107, 114)// 浅红色——取票码的颜色
#define kPlaceholderColor    RGB(204, 204, 204)// 文本框占位字符的颜色
#define kLabelBlueColor      RGB(0x4b, 0x70, 0xb7)  // 4b70b7

#define kMaskBgColor         [UIColor colorWithWhite:0 alpha:0.4]

// ————————————————————————————————————————————
#define     COLOR_CLEAR                 [UIColor clearColor]
#define     COLOR_IWHITE                [UIColor whiteColor]
#define     COLOR_IBLACK                [UIColor blackColor]
#define     COLOR_DEEPIGRAY             RGB(229,229,229)
#define     COLOR_IGRAY                 RGB(247,247,247)
#define     COLOR_LIGHTGRAY             RGB(242,244,246)
#define     COLOR_GRAY_LINE             RGB(226,226,226)


#pragma mark - 图片相关

//返回按钮的图片名字
#define kReturnButtonImageName @"sh_return_icon"

#define kImageSize_750_500  @"_750_500"//
#define kImageSize_750_400  @"_750_400"//
#define kImageSize_750_150  @"_750_150"//
#define kImageSize_300_300  @"_300_300"//

#define kImageSize_150_150  @"_150_150"//
#define kImageSize_150_100  @"_150_100"//
#define kImageSize_72_72    @"_72_72"  //

#define kImageSize_BigAdv      @"_750_250"//大的轮播图
#define kImageSize_CalendarAdv @"_750_380"//日历广告位图
#define kImageSize_SmallAdv    @"_748_310"//小的轮播图

#define kImageSize_Adv_140_120 @"_140_120"//
#define kImageSize_Adv_375_220 @"_750_440"//
#define kImageSize_Adv_187_215 @"_374_430"//
#define kImageSize_Adv_300_190 @"_300_190"//


#define kNavPictureSize 30// 导航条图片的大小

// 图片的显示比例
#define kPicScale_ListCover 0.667f // 活动、场馆列表图片的高度与宽度之比( h/w )： 500/750.0f



#pragma mark - ——————————— Label外观的一些属性名 —————————————

#define kLabelTextColor    @"LabelTextColor" // 字体颜色
#define kLabelBgColor      @"LabelBackgroundColor" // 背景颜色
#define kLabelBorderColor  @"LabelBorderColor" // 边框颜色
#define kLabelBorderWidth  @"LabelBorderWidth" // 边框宽度
#define kLabelCornerRadius @"LabelCornerRadius" // 圆角大小


#pragma mark - 

#define     ISNull(dic)                 (dic  == nil || [dic isKindOfClass:[NSNull class]])
#define     COVERTNULLSTR(str)          ((str  == nil || [str isKindOfClass:[NSNull class]]) ? @"" : str)

#define     ALERTSHOW(alertMsg)     [WHYAlertActionUtil showAlertWithTitle:@"温馨提示" msg:alertMsg actionBlock:nil buttonTitles:@"确定", nil];



#endif /* AppConstantMacros_h */
