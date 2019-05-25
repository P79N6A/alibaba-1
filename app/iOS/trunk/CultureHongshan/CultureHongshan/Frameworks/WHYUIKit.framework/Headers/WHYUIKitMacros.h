//
//  WHYUIKitMacros.h
//  WHYUIKit
//
//  Created by JackAndney on 2017/5/14.
//  Copyright © 2017年 Creatoo. All rights reserved.
//


#ifndef WHYUIKitMacros_h
#define WHYUIKitMacros_h

//#define FONT_ADAPTIVE // 字体适配

#define IOS_VERSION  [[[UIDevice currentDevice] systemVersion] floatValue]
// iOS系统版本号是否大于等于指定的版本号
#define IOS_VERSION_GREATER_OR_EQUAL(ver)   ([[UIDevice currentDevice].systemVersion floatValue] >= ver)


#define kPlaceholderImageName @"placeholder"
#define IMG(img_name)  [UIImage imageNamed:(img_name)]

// 尺寸定义
#define kScreenWidth  ([[UIScreen mainScreen] bounds].size.width * 1.0f)
#define kScreenHeight ([[UIScreen mainScreen] bounds].size.height * 1.0f)
#define ConvertSize(aSize) ((aSize)*[[UIScreen mainScreen] bounds].size.width/750.0f)
#define ConvertSizeWithMin(aSize) MAX((aSize)*[[UIScreen mainScreen] bounds].size.width/750.0f, (aSize)/2.0f)


// 字体
#ifdef FONT_ADAPTIVE
#define FONT_SCALE  0.9
#define FONT_CUSTOME_NAME @"STYuanti-SC-Light"
#else
#define FONT(fontSize)      [UIFont fontWithName:@"STYuanti-SC-Light" size:fontSize] // 普通的圆体字体
#define FONTBOLD(fontSize)  [UIFont fontWithName:@"STYuanti-SC-Light" size:fontSize] // 粗体的圆体字体
#endif


// 颜色
#define RGB(r,g,b)       [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1]
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

#define kWhiteColor          [UIColor whiteColor]
#define kBlackColor          [UIColor blackColor]
#define kBgColor             RGB(242, 242, 242)// 背景色
#define kDeepLabelColor      RGB(0x26, 0x26, 0x26)
#define kLightLabelColor     RGB(0x80, 0x80, 0x80)

#endif /* WHYUIKitMacros_h */
