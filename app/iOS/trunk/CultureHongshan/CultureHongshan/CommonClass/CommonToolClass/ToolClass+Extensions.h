//
//  ToolClass+Extensions.h
//  CultureHongshan
//
//  Created by ct on 16/4/27.
//  Copyright © 2016年 CT. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MYBoldLabel.h"


@interface ToolClass (Extensions)


// 日志输出功能
void MYLog_Basic(const char *file, const int line, id format, ...);


#pragma mark - 图片相关


/**
 图片URL地址拼接

 @param url        原图链接
 @param sizeString 拼接的图片尺寸(格式：_750_500)

 @return 拼接后的图片链接
 */
NSString *JointedImageURL(NSString *url, NSString *sizeString);



/**
 *  由一张图片切成上下两部分图片
 *
 *  @param topHeight 上半部分图片的高度
 *
 */
+ (NSArray *)getTwoScreenShotsWithImage:(UIImage *)img topHeight:(CGFloat)topHeight headimg:(UIImageView *)headimgView;


/**
 * 给视图添加虚线边框
 */
+ (UIView *)addDashBorderOnView:(UIView *)view;

/**
 *  由一个小图片生成一个带有虚线边框的视图
 *
 *  @param centerImage 中心的小图片
 *  @param size1    占位图的大小
 *  @param size2  中心小图片的大小
 *
 *  @return 占位图
 */
+ (UIImage *)getDashPlaceholder:(UIImage *)centerImage viewSize:(CGSize)size1 centerSize:(CGSize)size2;

/**
 *  带四个内圆角的图片
 *
 *  @param viewSize 图片大小
 *  @param image    图片
 *  @param radius   圆角半径
 *
 */
UIImage *roundedImageByInside(CGSize viewSize,UIImage *image,CGFloat radius);

/**
 *  带四个外圆角的图片
 *
 *  @param viewSize 图片大小
 *  @param image    图片
 *  @param radius   圆角半径
 *
 */
UIImage *roundedImageByOutside(CGSize viewSize,UIImage *image,CGFloat radius);


#pragma mark - Animation 动画

/**
 *  两张图片合并与分裂开的动画
 */
+ (void)animationWithTopImage:(UIImage *)topImg bottomImage:(UIImage *)bottomImg headOffset:(float)headOffset isTogether:(BOOL)isTogether completion:(AnimationBlock)completionBlock;

#pragma mark - 其它方法

+ (NSString *)getUUID;
+ (NSString *)genEncryptUrl:(NSString *)url;
+ (UIView *)removeAllSubViews:(UIView *)view;
+ (NSString *)getDistance:(double)d;
+ (BOOL)isFirstVisitForSelectCity; // 是否第一次选择城市
+ (void)updateFirstVisitStateForSelectCity; // 更新选择城市的状态


/**
 *  @brief 是否需要提示用户定位
 *
 *  一天之内不需要重复提示，只需提示一次即可
 */
+ (BOOL)shouldNoticeUserAllowLocating;
+ (void)updateAllowLocatingNoticeStatus;










#pragma mark -


/**
 *  获取倒计时时间
 *
 *  @param remainedSeconds 剩余的秒数
 *
 */
+ (NSAttributedString *)getCountdownTimeStr:(NSTimeInterval)remainedSeconds;

/**
 *  音频播放的时长显示
 *
 *  @param duration 音频播放的剩余时长
 */
+ (NSString *)getMusicPlayTimeString:(NSTimeInterval)duration;

/**
 *  html字符串 转换成 属性字符串
 */
+ (NSAttributedString *)getHtmlBodyAttributedText:(NSString *)htmlStr;

+ (void)setButtonTitle:(NSString *)title defaultFontSize:(NSInteger)defaultSize forState:(UIControlState)state withButton:(UIButton **)sender;

/**
 *  将 “请求参数字典” 转换成 “Get请求形式的参数字符串”
 */
+ (NSString *)convertParaDictToString:(NSDictionary *)paraDict;


/**
 *  禁止用户操作的提示
 */
+ (BOOL)showForbiddenNotice;

/**
 *  获取小尺寸的用户头像地址
 */
+ (NSString *)getSmallHeaderImgUrl:(NSString *)imgUrl;

/**
 添加不定个数的Label标签到容器视图中
 
 @discussion 只添加单行时，不会设置父视图的高度。否则会自动计算添加完Label时父视图的高度。
 
 @param parentView       容器（父）视图
 @param titleArray       所有Label的标题数组
 @param attributes       有关属性的设置
 @param labelAttributes  Label外观的一些属性（必须设置）：kLabelTextColor、kLabelBgColor、kLabelBorderColor、kLabelBorderWidth、kLabelCornerRadius
 @param clearSubviews    是否先清除父视图的所有子视图
 @param contentHeight    添加的内容区域的高度：（即从第一行的顶部 到 最后一行到底部间距）
 */
+ (void)addSubview:(UIView *)parentView titleArray:(NSArray *)titleArray attributes:(NSDictionary *)attributes labelAttributes:(NSDictionary *)labelAttr clearSubviews:(BOOL)clearSubviews contentHeight:(CGFloat *)height;


// 根据经纬度，获取地址信息【获取的信息没有高德地图的全面】
+ (void)getAddressWithLatitude:(double)lat longitude:(double)lon completion:(void (^)(NSArray *placemarks, NSError *error))block;


/**
 将用户选中的标签 转为 Json字符串

 @param tags      标签数组
 @param serverTag 是否为服务器的标签数据
 @return  Json字符串
 */
+ (NSString *)jsonActTagsForTagArray:(NSArray *)tags isServerTag:(BOOL)serverTag;

/**
 活动列表标签数据需要更新
 */
+ (void)settingActivityListNeedUpdate;




#pragma mark - 辅助的方法

/**
 *  城市名显示处理
 *
 *  @param cityName 城市名
 */
+ (NSString *)cityNameHandle:(NSString *)cityName;


/**
 活动价格处理
 
 @param actIsFree    是否免费: 1-免费 2-收费 3-支付
 @param priceType    价格类型：0：XX元起  1:XX元/人  2:XX元/张   3:XX元/份  其它:XX元/张
 @param actPrice     原先的活动价格
 @param actPayPrice  活动支付价格
 @return 显示的价格字符串
 */
NSString *MYActPriceHandle(NSInteger actIsFree, NSInteger priceType, NSString *actPrice, NSString *actPayPrice);

/** 根据orderSeats 获取座位数组 */
+ (NSArray *)seatsArrayForOrderSeats:(NSString *)orderSeats;

// 是否包含Emoji表情
BOOL MYStringIncludeEmoji(NSString *string);

/** 在URL中插入一个字段（若已存在该字段，则更新此值） */
NSString *MYURLByInsertField(NSString *url, NSString *fieldName, NSString *fieldValue);


@end

