//
//  ToolClass+Extensions.m
//  CultureHongshan
//
//  Created by ct on 16/4/27.
//  Copyright © 2016年 CT. All rights reserved.
//

#import "ToolClass+Extensions.h"

#import "KeyChainStore.h"



#import "AppProtocolMacros.h"
#import "CitySwitchModel.h"
#import "AnimatedSpringPopupView.h"
#import "ActivityListViewController.h"

@implementation ToolClass (Extensions)

// 日志输出功能
void MYLog_Basic(const char *file, const int line, id format, ...)
{
    if (!DEBUG_MODE) return;
    
    NSString *filePath = [[[NSString alloc] initWithCString:file encoding:NSUTF8StringEncoding] lastPathComponent];
    
    if ([format isKindOfClass:[NSString class]]) {
        if ([format rangeOfString:@"%"].location != NSNotFound) {
            // 格式化内容的输出
            va_list args;
            va_start(args, format);
            NSString *result = [[NSString alloc] initWithFormat:format arguments:args];
            va_end(args);
            
            NSLog(@"输出结果: \n %@ \n文件：%@, 行号：%d \r\n\r\n", [result my_description], filePath, line);
            return;
        }
    }
    // 单个变量的输出
    NSLog(@"输出结果: \n %@ \n文件：%@, 行号：%d \r\n\r\n", [format my_description], filePath, line);
}




#pragma mark - 图片相关

//图片链接地址拼接
NSString *JointedImageURL(NSString *url , NSString *sizeString)
{
    
    if ([url isKindOfClass:[NSString class]] && url.length && [url hasPrefix:@"http"]) {
        if (sizeString.length) {
            // 检查是否已经包含了尺寸参数
            NSString *pathExtension = [FileService pathExtensionForPathOrURL:url];
            if ([url rangeOfString:[NSString stringWithFormat:@"_[\\d]{2,4}_[\\d]{2,4}\\.%@$", pathExtension] options:NSRegularExpressionSearch|NSCaseInsensitiveSearch range:NSMakeRange(0, url.length)].location != NSNotFound) {
                return url;
            }
            
            // 检查是否为阿里的图片链接
            if ([url containsSubString:kAliFileDomainIdentifier]) {
                
            }else {
                // 文化云自己的图片服务器链接
                NSUInteger dotLocation = [url rangeOfString:@"." options:NSBackwardsSearch range:NSMakeRange(0, url.length)].location;
                if (dotLocation != NSNotFound) { // 找到了"."的位置
                    NSMutableString *mutableString = [[NSMutableString alloc] initWithString:url];
                    [mutableString insertString:sizeString atIndex:dotLocation];
                    return [mutableString copy];
                }
            }
        }
        
        return url;
    }
    
    return @"";
}

// 由一张图片切成上下两部分图片
+ (NSArray *)getTwoScreenShotsWithImage:(UIImage *)img topHeight:(CGFloat)topHeight headimg:(UIImageView *)headimgView
{
    if (img) {
        CGFloat imgWidth = img.size.width*img.scale;
        CGFloat imgHeight = img.size.height*img.scale;
        
        CGFloat upHeight = imgHeight*topHeight*1.0/kScreenHeight;
        CGFloat downHeight = imgHeight - upHeight;
       
        CGFloat headOffsetHeight = 0;
        if (headimgView && headimgView.width > 0)
        {
            headOffsetHeight = imgWidth / headimgView.frame.size.width * headimgView.frame.size.height;
            if (upHeight  < headOffsetHeight)
            {
                upHeight = headOffsetHeight;
            }
        }
        UIImage *topImage = [img clipInRect:CGRectMake(0, 0, imgWidth, upHeight)];
        UIImage *bottomImage = [img clipInRect:CGRectMake(0, upHeight, imgWidth, downHeight)];

        if (headimgView && headOffsetHeight > 0)
        {
            UIGraphicsBeginImageContext(CGSizeMake(imgWidth, upHeight));
            [topImage drawAtPoint:CGPointMake(0,0)];
            [headimgView.image drawInRect:MRECT(0, upHeight - headOffsetHeight, imgWidth, headOffsetHeight)];
            UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            topImage = nil;
            topImage = newImage;
        }
       
        return @[topImage, bottomImage];
    }
    return nil;
}

// 给视图添加虚线边框
+ (UIView *)addDashBorderOnView:(UIView *)view
{
    CAShapeLayer *border = [CAShapeLayer layer];
    border.strokeColor = [UIColor lightGrayColor].CGColor;
    border.fillColor = [UIColor whiteColor].CGColor;
    border.path = [UIBezierPath bezierPathWithRect:view.bounds].CGPath;
    border.frame = view.bounds;
    border.lineWidth = 1.f;
    border.lineCap = @"square";
    border.lineDashPattern = @[@4, @2];
    [view.layer addSublayer:border];
    return view;
}

// 由一个小图片生成一个带有虚线边框的视图
+ (UIImage *)getDashPlaceholder:(UIImage *)centerImage viewSize:(CGSize)size1 centerSize:(CGSize)size2
{
    UIWindow *window = [UIApplication sharedApplication].windows[0];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size1.width, size1.height)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView = [ToolClass addDashBorderOnView:bgView];
    [window addSubview:bgView];
    
    UIImageView *placeholderPic = [[UIImageView alloc] init];
    placeholderPic.bounds = CGRectMake(0, 0, size2.width, size2.height);
    placeholderPic.center = bgView.center;
    placeholderPic.image = centerImage;
    [bgView addSubview:placeholderPic];
    
    UIGraphicsBeginImageContextWithOptions(bgView.bounds.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [bgView.layer renderInContext:context];
    UIImage *placeholderImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [bgView removeFromSuperview];
    return placeholderImage;
}

// 带四个内圆角的图片
UIImage *roundedImageByInside(CGSize viewSize,UIImage *image,CGFloat radius)
{
    viewSize = CGSizeMake((int)viewSize.width, (int)viewSize.height);
    UIWindow *window = [UIApplication sharedApplication].windows[0];
    UIImageView *_accessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, viewSize.width*3, viewSize.height*3)];
    _accessoryView.image = image;
    [window addSubview:_accessoryView];
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(viewSize.width*3, viewSize.height*3), NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [_accessoryView.layer renderInContext:context];
    UIImage *imageSrc = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [_accessoryView removeFromSuperview];
    
    radius = imageSrc.size.height*radius/viewSize.height;
    
    CGFloat minX = 0;
    CGFloat minY = 0;
    CGFloat maxX = imageSrc.size.width;
    CGFloat maxY = imageSrc.size.height;
    
    CGColorSpaceRef colorRef = CGColorSpaceCreateDeviceRGB();
    CGContextRef contextRef = CGBitmapContextCreate(nil, imageSrc.size.width, imageSrc.size.height, 8, imageSrc.size.width*4, colorRef, kCGImageAlphaPremultipliedFirst);
    CGMutablePathRef mutPath = CGPathCreateMutable();
    CGPathMoveToPoint(mutPath, NULL, maxX*0.5, maxY);
    
    //左下角
    CGPathAddLineToPoint(mutPath, NULL, minX+radius, maxY);
    CGPathAddArcToPoint(mutPath, NULL, minX+radius, maxY-radius, minX, maxY-radius, radius);
    //左上角
    CGPathAddLineToPoint(mutPath, NULL, minX, minY+radius);
    CGPathAddArcToPoint(mutPath, NULL, minX+radius, minY+radius, minX+radius, minY, radius);
    //右上角
    CGPathAddLineToPoint(mutPath, NULL, maxX-radius, minY);
    CGPathAddArcToPoint(mutPath, NULL, maxX-radius, minY+radius, maxX, minY+radius, radius);
    //右下角
    CGPathAddLineToPoint(mutPath, NULL, maxX, maxY-radius);
    CGPathAddArcToPoint(mutPath, NULL, maxX-radius, maxY-radius, maxX-radius, maxY, radius);
    
    
    CGPathCloseSubpath(mutPath);
    CGContextAddPath(contextRef, mutPath);
    CGContextClip(contextRef);
    CGContextDrawImage(contextRef, CGRectMake(0, 0, imageSrc.size.width, imageSrc.size.height), imageSrc.CGImage);
    CGImageRef imageRef = CGBitmapContextCreateImage(contextRef);
    UIImage* imageDst = [UIImage imageWithCGImage:imageRef scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
    
    //释放对象
    CGContextRelease(contextRef);
    CGColorSpaceRelease(colorRef);
    CGPathRelease(mutPath);
    CGImageRelease(imageRef);
    
    return imageDst;
}

// 带四个外圆角的图片
UIImage *roundedImageByOutside(CGSize viewSize,UIImage *image,CGFloat radius)
{
    CGRect imageRect = CGRectMake(0, 0, viewSize.width, viewSize.height);
    
    UIGraphicsBeginImageContextWithOptions(viewSize, NO, 0);
    
    [[UIBezierPath bezierPathWithRoundedRect:imageRect cornerRadius:radius] addClip];
    
    [image drawInRect:imageRect];
    
    UIImage *targetImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return targetImage;
}



#pragma mark - Animation 动画

//两张图片合并与分裂开的动画
+ (void)animationWithTopImage:(UIImage *)topImg bottomImage:(UIImage *)bottomImg headOffset:(float)headOffset isTogether:(BOOL)isTogether  completion:(AnimationBlock)completionBlock
{
    if (topImg && bottomImg)
    {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        CGFloat topHeight = kScreenHeight*topImg.size.height*1.0/(topImg.size.height+bottomImg.size.height);
        CGFloat bottomHeight = kScreenHeight - topHeight;
        CGFloat animationDuration = 0.5;
        
        for (UIView *view in window.subviews){
            if (view.tag == 143234 || view.tag == 143235) {
                [view removeFromSuperview];
            }
        }
        
        //上方的图片
        __block UIImageView *topImgView = [[UIImageView alloc] init];
        topImgView.tag = 143234;
        topImgView.image = topImg;
        [window addSubview:topImgView];
        
        //下方的图片
        __block UIImageView *bottomImgView = [[UIImageView alloc] init];
        bottomImgView.image = bottomImg;
        bottomImgView.tag = 143235;
        [window addSubview:bottomImgView];
        
        if (isTogether){
            topImgView.alpha = 0.5;
            bottomImgView.alpha = 0.5;
            topImgView.frame = CGRectMake(0, -topHeight, kScreenWidth, topHeight);
            bottomImgView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, bottomHeight);
            
            [UIView animateWithDuration:animationDuration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                topImgView.alpha = 1;
                bottomImgView.alpha = 1;
                
                topImgView.frame = CGRectMake(0, 0, kScreenWidth, topHeight);
                bottomImgView.frame = CGRectMake(0, topHeight, kScreenWidth, bottomHeight);
                
            } completion:^(BOOL finished) {
                
                [topImgView removeFromSuperview];
                [bottomImgView removeFromSuperview];
                if (completionBlock) {
                    completionBlock(finished);
                }
            }];
            
        }else {
            topImgView.alpha = 1;
            bottomImgView.alpha = 1;
            topImgView.frame = CGRectMake(0, 0, kScreenWidth, topHeight);
            bottomImgView.frame = CGRectMake(0, topHeight, kScreenWidth, bottomHeight);
            
            
            [UIView animateWithDuration:animationDuration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                bottomImgView.alpha = 0.5;
                
                //topImgView.frame = CGRectMake(0, -topHeight, kScreenWidth, topHeight);
                topImgView.frame = CGRectMake(0,headOffset - topImgView.frame.size.height, kScreenWidth, topImgView.frame.size.height);
                bottomImgView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, bottomHeight);
                
            } completion:^(BOOL finished) {
                
                [UIView animateWithDuration:0.1f animations:^{
                    topImgView.alpha = 0;
                } completion:^(BOOL finished) {
                   [topImgView removeFromSuperview];
                }];
                
                
                [bottomImgView removeFromSuperview];
                if (completionBlock) {
                    completionBlock(finished);
                }
            }];
        }
    }
}


#pragma mark -  其它

+ (NSString *)getUUID {
    NSString * strUUID = (NSString *)[KeyChainStore load:DEFAULT_VALUE_UUID];
    
    //首次执行该方法时，uuid为空
    if ([strUUID isEqualToString:@""] || !strUUID) {
        //生成一个uuid的方法
        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
        strUUID = (NSString *)CFBridgingRelease(CFUUIDCreateString (kCFAllocatorDefault,uuidRef));
        //将该uuid保存到keychain
        [KeyChainStore save:DEFAULT_VALUE_UUID data:strUUID.lowercaseString];
        CFRelease(uuidRef);
    }
    return strUUID;
}

// 加密URL
+ (NSString *)genEncryptUrl:(NSString *)url {
    NSArray * a = [url componentsSeparatedByString:@"?"];
    if (a.count == 1) return url;
    
    NSString * query = @"";
    for (int i=1; i<a.count; i++) {
        if (i > 1) {
            query = [query stringByAppendingString:@"?"];
        }
        query = [query stringByAppendingString:a[i]];
    }
    
    NSArray * queryArray = [query componentsSeparatedByString:@"&"];
    NSArray * ay = [queryArray sortedArrayUsingComparator:^(NSString * obj1,NSString * obj2) {
        return [obj1 compare:obj2];
    }];
    
    NSString * urlpath = @"";
    for (NSString * query in ay) {
        NSArray * ary = [query componentsSeparatedByString:@"="];
        if (ary.count == 1 || [ary[1] length] == 0) {
            if ([ary[0] hasPrefix:@"{"]) {
                urlpath = ary[0];
                break;
            }
            continue;
        }
        if (urlpath.length == 0) {
            urlpath = [urlpath stringByAppendingString:[NSString stringWithFormat:@"%@",query]];
        } else {
            urlpath = [urlpath stringByAppendingString:[NSString stringWithFormat:@"&%@",query]];
        }
    }
    
    NSString * md5 = [EncryptTool md5Encode:[NSString stringWithFormat:@"%@%@",urlpath,MD5_PRIVATEKEY]];
    urlpath  = [urlpath stringByAppendingString:[NSString stringWithFormat:@"&sign=%@",md5]];
    NSString * path =[NSString stringWithFormat:@"%@?%@",a[0],urlpath];
    
    return path;
}

// 移除子视图
+ (UIView *)removeAllSubViews:(UIView *)view {
    NSArray * vs = nil;
    if ([view isKindOfClass:[UITableViewCell class]])
    {   //ios 7下uitableviewcell的层次发生变化：UITableViewCell --> UITableViewCellScrollView --> UITableViewCellContentView
        for (UIView *subView in view.subviews) {
            
            if ([subView isKindOfClass:NSClassFromString(@"UITableViewCellScrollView")]) {
                [subView.subviews[0].subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            }else if ([subView isKindOfClass:NSClassFromString(@"UITableViewCellContentView")]){
                [subView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            }else{
                [subView removeFromSuperview];
            }
        }
        return view;
    }
    else
    {
        vs = [view subviews];
    }
    
    for (int i=0; i<vs.count; i++)
    {
        UIView * d = [vs objectAtIndex:i];
        if ([d isKindOfClass:[UIButton class]] || [d isKindOfClass:[UILabel class]] ||[d isKindOfClass:[UIImageView class]] || d.tag > 0)
        {
            [d removeFromSuperview];
        }
    }
    return  view;
}

+ (NSString *)getDistance:(double)d {
    d = d * 1000;
    if(d < 1000) {
        return [NSString stringWithFormat:@"%.0fM",d];
    }else if (d < 20000) {
        return [NSString stringWithFormat:@"%.1fKM",d/1000];
    }else {
        return [NSString stringWithFormat:@"%.0fKM",d/1000];
    }
    return @"--米";
}


// 是否第一次选择城市
+ (BOOL)isFirstVisitForSelectCity {
    NSString *ret = [ToolClass getDefaultValue:@"first_visit_for_select_city"];
    return ret.length < 1;
}

+ (void)updateFirstVisitStateForSelectCity {
    [ToolClass setDefaultValue:@"1" forKey:@"first_visit_for_select_city"];
}



+ (BOOL)shouldNoticeUserAllowLocating {
    NSDate *lastLoginDate = [[NSUserDefaults standardUserDefaults] valueForKey:@"user_last_Notice_Locating_date"];
    if (lastLoginDate) {
        //一天之内不需要提示
        if ([DateTool dayCompare:lastLoginDate comparedDate:[NSDate date]] == DaySame) {
            return NO;
        }
    }
    return YES;
}

+ (void)updateAllowLocatingNoticeStatus {
    [ToolClass setDefaultValue:[NSDate date] forKey:@"user_last_Notice_Locating_date"];
}







#pragma mark -


// 获取倒计时时间
+ (NSAttributedString *)getCountdownTimeStr:(NSTimeInterval)remainedSeconds
{
    if (remainedSeconds < 1) {
        NSString *string = remainedSeconds == 0 ? @"00秒 后开始" : @"已结束";
        
        return [[NSAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName:FontYT(17), NSForegroundColorAttributeName:[UIColor whiteColor]}];
    }else{
        int day,hour,minute,second;
        day = (int)remainedSeconds/86400;
        remainedSeconds -= day*86400;
        
        hour = (int)remainedSeconds/3600;
        remainedSeconds -= hour*3600;
        
        minute = (int)remainedSeconds/60;
        remainedSeconds -= minute*60;
        
        second = (int)remainedSeconds;
        
        NSMutableString *tmpString = [[NSMutableString alloc] initWithCapacity:14];
        if (day  > 0) {
            [tmpString appendFormat:@"%d天",day];
        }
        
        if (hour > 0 || tmpString.length > 0) {
            [tmpString appendFormat:@"%02d小时",hour];
        }
        
        if (minute > 0 || tmpString.length > 0) {
            [tmpString appendFormat:@"%02d分",minute];
        }
        if (second > 0 || tmpString.length > 0) {
            [tmpString appendFormat:@"%02d秒",second];
        }
        [tmpString appendString:@" 后开始"];
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:tmpString attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:FontSystemBold(16)}];
        NSRange dayRange = [tmpString rangeOfString:@"天"];
        NSRange hourRange = [tmpString rangeOfString:@"小时"];
        NSRange minuteRange = [tmpString rangeOfString:@"分"];
        NSRange secondRange = [tmpString rangeOfString:@"秒"];
        NSRange beginRange = NSMakeRange(tmpString.length-3, 3);
        
        if (dayRange.location != NSNotFound){
            [attributedString addAttribute:NSFontAttributeName value:FontYT(12) range:dayRange];
        }
        if (hourRange.location != NSNotFound){
            [attributedString addAttribute:NSFontAttributeName value:FontYT(12) range:hourRange];
        }
        if (minuteRange.location != NSNotFound){
            [attributedString addAttribute:NSFontAttributeName value:FontYT(12) range:minuteRange];
        }
        [attributedString addAttribute:NSFontAttributeName value:FontYT(12) range:secondRange];
        [attributedString addAttribute:NSFontAttributeName value:FontYT(13) range:beginRange];
        
        return attributedString;
    }
}

// 音频播放的时间显示字符串
+ (NSString *)getMusicPlayTimeString:(NSTimeInterval)duration
{
    if (duration <= 0) {
        return @"00:00";
    }
    
    int day,hour,minute,second;
    day = (int)duration/86400;
    duration -= day*86400;
    
    hour = (int)duration/3600;
    duration -= hour*3600;
    
    minute = (int)duration/60;
    duration -= minute*60;
    
    second = (int)duration;
    
    if (hour > 0) {
        return [NSString stringWithFormat:@"%d:%02d:%02d",hour,minute,second];
    }else{
        return [NSString stringWithFormat:@"%02d:%02d",minute,second];
    }
}

// html字符串 转换成 属性字符串
+ (NSAttributedString *)getHtmlBodyAttributedText:(NSString *)htmlStr
{
    NSAttributedString *bodyText = [NSAttributedString new];
    if ([htmlStr isKindOfClass:[NSString class]]) {
        if (htmlStr.length) {
            NSData *htmlData = [htmlStr dataUsingEncoding:NSUnicodeStringEncoding];
            NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:htmlData options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
            bodyText = attributedString;
        }
    }
    return bodyText;
}


+ (void)setButtonTitle:(NSString *)title defaultFontSize:(NSInteger)defaultSize forState:(UIControlState)state withButton:(UIButton **)sender
{
    UIButton *button = *sender;
    if (title.length < 1) {
        [button setTitle:title forState:state];
        button.titleLabel.font = FontYT(defaultSize);
        return;
    }
    
    CGFloat maxWidth = button.width-fabs(button.titleEdgeInsets.left)-fabs(button.titleEdgeInsets.right);
    
    CGFloat textWidth = [UIToolClass textWidth:title font:FontYT(defaultSize)];
    if (textWidth+10 <= maxWidth) { // 可以显示完
        [button setTitle:title forState:state];
        button.titleLabel.font = FontYT(defaultSize);
        return;
    }else if (textWidth+4 <= maxWidth){ // 稍微显示不完
        CGFloat fontSize = 10;//提供一个最小字号
        for (CGFloat size = defaultSize-1; size >= fontSize; size--) {
            textWidth = [UIToolClass textWidth:title font:FontYT(size)];
            if (textWidth+10 <= maxWidth) {
                fontSize = size;
                break;
            }
        }
        [button setTitle:title forState:state];
        button.titleLabel.font = FontYT(fontSize);
        return;
        
    }else{ // 完全显示不完
        int firstLineLength = ceill(title.length/2.0);
        
        NSString *firstLineStr = [title substringToIndex:firstLineLength];
        NSString *secondLineStr = [title substringFromIndex:firstLineLength];
        
        textWidth = [UIToolClass textWidth:firstLineStr font:FontYT(10)];
        if (textWidth +10 <= maxWidth) {
            title = [NSString stringWithFormat:@"%@\n%@",firstLineStr, secondLineStr];
        }
        
        [button setTitle:title forState:state];
        button.titleLabel.font = FontYT(12);
    }
}

// 将 “请求参数字典” 转换成 “Get请求形式的参数字符串”
+ (NSString *)convertParaDictToString:(NSDictionary *)paraDict
{
    if ([paraDict isKindOfClass:[NSDictionary class]]) {
        if (paraDict.count) {
            
            NSMutableString *param = [[NSMutableString alloc] initWithString:@""];
            
            for (NSString *key in paraDict.allKeys) {
                //去掉指定的一些请求参数标志
                if ([key isEqualToString:kFixedProtocolKey]) {
                    continue;
                }
                
                if (param.length > 0) { [param appendString:@"&"]; }
                
                [param appendString:[NSString stringWithFormat:@"%@=%@",key,paraDict[key]]];
            }
            return param;
        }
    }
    return @"";
}


//  禁止用户操作的提示
+ (BOOL)showForbiddenNotice
{
    NSString *userIsDisable = [UserService sharedService].user.userIsDisable;
    
    if ([userIsDisable isEqualToString:@"0"]) {//未激活
        [AnimatedSpringPopupView popupViewWithTitle:@"温馨提示" message:@"您的帐号还未激活，请激活后再使用!" callbackBlock:^(id object, NSInteger index, BOOL isSameIndex) {
            
        }];
        return YES;
    }
    if ([userIsDisable isEqualToString:@"2"]) {//冻结
        [AnimatedSpringPopupView popupViewWithTitle:@"抱歉!" message:@"您的帐号当前已被冻结，无法进行此操作!" callbackBlock:^(id object, NSInteger index, BOOL isSameIndex) {
        }];
        return YES;
    }
    return NO;
}

// 获取小尺寸的用户头像地址
+ (NSString *)getSmallHeaderImgUrl:(NSString *)imgUrl
{
    if (imgUrl.length) {
        // 用户头像加尺寸后缀（第三方的图片链接，不能加后缀）
        if ([imgUrl pathExtension].length < 1) {
            return [imgUrl copy];
        }
        
        if ([imgUrl containsSubString:@"qlogo.cn/"] || [imgUrl containsSubString:@"sinaimg.cn/"]) {
            return [imgUrl copy];
        }else {
            return JointedImageURL(imgUrl, @"_150_150");
        }
        
    }else {
        return @"";
    }
}

// 添加不定个数的Label标签到容器视图中
+ (void)addSubview:(UIView *)parentView titleArray:(NSArray *)titleArray attributes:(NSDictionary *)attributes labelAttributes:(NSDictionary *)labelAttr clearSubviews:(BOOL)clearSubviews contentHeight:(CGFloat *)height
{
    if (parentView) {
        if (clearSubviews) {
            [parentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        }
        
        CGFloat originalOffsetX = 0;
        CGFloat originalOffsetY = 0;
        CGFloat margin = 0;
        CGFloat spacingX = 10;
        CGFloat spacingY = 10;
        CGFloat itemPadding = 12;// 内边距
        CGFloat itemHeight = 20;
        CGFloat maxWidth = parentView.width;
        CGFloat itemMaxWidth = maxWidth;
        UIFont *font = FontYT(13);
        BOOL onlySingleLine = NO;
        
        if ([attributes isKindOfClass:[NSDictionary class]] && attributes.count) {
            // 水平方向的起始位置
            if ([attributes safeDoubleForKey:MYOffsetXAttributeName] > 0) {
                originalOffsetX = [attributes safeDoubleForKey:MYOffsetXAttributeName];
            }
            // 垂直方向的起始位置
            if ([attributes safeDoubleForKey:MYOffsetYAttributeName] > 0) {
                originalOffsetY = [attributes safeDoubleForKey:MYOffsetYAttributeName];
            }
            // 左、右边距
            if ([attributes safeDoubleForKey:MYHorizontalMarginAttributeName] > 0) {
                margin = [attributes safeDoubleForKey:MYHorizontalMarginAttributeName];
            }
            // 水平方向，两个item之间的间距
            if ([attributes safeDoubleForKey:MYSpacingXAttributeName] > 0) {
                spacingX = [attributes safeDoubleForKey:MYSpacingXAttributeName];
            }
            // 竖直方向，两个item之间的间距
            if ([attributes safeDoubleForKey:MYSpacingYAttributeName] > 0) {
                spacingY = [attributes safeDoubleForKey:MYSpacingYAttributeName];
            }
            // item的高度
            if ([attributes safeDoubleForKey:MYItemHeightAttributeName] > 0) {
                itemHeight = [attributes safeDoubleForKey:MYItemHeightAttributeName];
            }
            // 内边距
            if ([attributes safeDoubleForKey:MYLabelPaddingAttributeName] > 0) {
                itemPadding = [attributes safeDoubleForKey:MYLabelPaddingAttributeName];
            }
            // 字体
            if ([[attributes valueForKey:MYFontAttributeName] isKindOfClass:[UIFont class]]) {
                font = [attributes valueForKey:MYFontAttributeName];
            }
            // 容器的宽度
            if ([attributes safeDoubleForKey:MYContainerWidthAttributeName] > 0) {
                maxWidth = [attributes safeDoubleForKey:MYContainerWidthAttributeName];
            }
            // 是否只显示一行
            if ([[attributes valueForKey:MYShowOnlySingleLineAttributeName] boolValue]) {
                onlySingleLine = YES;
            }
            
            if (margin > 0) {
                originalOffsetX = margin;
                itemMaxWidth = maxWidth - 2*margin;
//                maxWidth -= margin;
            }else {
                itemMaxWidth = maxWidth - originalOffsetX;
//                maxWidth = maxWidth - originalOffsetX;
            }
        }
        
        
        
        
        if (titleArray.count) {
            // Label的外观
            UIColor *textColor = nil;
            UIColor *bgColor = nil;
            UIColor *borderColor = nil;
            CGFloat borderWidth = 0.8;
            CGFloat cornerRadius = 4;
            
            if ([labelAttr isKindOfClass:[NSDictionary class]] && labelAttr.count) {
                
                if ([[labelAttr valueForKey:kLabelTextColor] isKindOfClass:[UIColor class]]) {
                    textColor = [labelAttr valueForKey:kLabelTextColor];
                }
                if ([[labelAttr valueForKey:kLabelBgColor] isKindOfClass:[UIColor class]]) {
                    bgColor = [labelAttr valueForKey:kLabelBgColor];
                }
                if ([[labelAttr valueForKey:kLabelBorderColor] isKindOfClass:[UIColor class]]) {
                    borderColor = [labelAttr valueForKey:kLabelBorderColor];
                }
                if ([labelAttr safeDoubleForKey:kLabelBorderWidth] > 0) {
                    borderWidth = [labelAttr safeDoubleForKey:kLabelBorderWidth];
                }
                if ([labelAttr safeDoubleForKey:kLabelCornerRadius] > 0) {
                    cornerRadius = [labelAttr safeDoubleForKey:kLabelCornerRadius];
                }
            }
            
            CGFloat itemWidth = 0;
            CGFloat offsetX = originalOffsetX;
            CGFloat offsetY = originalOffsetY;
            BOOL addItem = NO; // 是否已经添加过Item
            
            NSMutableArray *longTitleArray = [[NSMutableArray alloc] initWithCapacity:0];
            
            for (int i = 0; i < titleArray.count; i++)
            {
                NSString *itemName = titleArray[i];
                if ([itemName isKindOfClass:[NSString class]] && itemName.length)
                {
                    itemWidth = [UIToolClass textWidth:itemName font:font]+itemPadding;
                    
                    if (offsetX + itemWidth > maxWidth) {
                        if (onlySingleLine) {
                            if (height != NULL && height != nil) {
                                *height = parentView.height;
                            }
                            return;
                        }
                        
                        if (itemWidth >= itemMaxWidth*0.8) {
                            [longTitleArray addObject:itemName];
                            continue;
                        }
                        
                        offsetX = originalOffsetX;
                        offsetY += spacingY + itemHeight;
                    }
                    
                    UILabel *itemLabel = [[UILabel alloc] initWithFrame:CGRectMake(offsetX, offsetY, itemWidth, itemHeight)];
                    itemLabel.backgroundColor = bgColor;
                    itemLabel.radius = cornerRadius;
                    itemLabel.layer.borderColor = borderColor.CGColor;
                    itemLabel.layer.borderWidth = borderWidth;
                    itemLabel.font = font;
                    itemLabel.text = itemName;
                    itemLabel.textColor = textColor;
                    itemLabel.textAlignment = NSTextAlignmentCenter;
                    [parentView addSubview:itemLabel];
                    
                    offsetX += itemWidth + spacingX;
                    if (!addItem) {
                        addItem = YES;
                    }
                }
            }
            
            // 如果有比较长的字符串，移到最下边显示
            if (longTitleArray.count) {
                if (addItem) { // 如果上面已经添加过Label，则需要另起一行
                    offsetX = originalOffsetX;
                    offsetY += spacingY + itemHeight;
                }
                
                for (int i = 0; i < longTitleArray.count; i++) {
                    
                    NSString *itemName = longTitleArray[i];
                    itemWidth = MIN([UIToolClass textWidth:itemName font:font]+itemPadding, itemMaxWidth);
                    
                    UILabel *itemLabel = [[UILabel alloc] initWithFrame:CGRectMake(offsetX, offsetY, itemWidth, itemHeight)];
                    itemLabel.backgroundColor = bgColor;
                    itemLabel.radius = cornerRadius;
                    itemLabel.layer.borderColor = borderColor.CGColor;
                    itemLabel.layer.borderWidth = borderWidth;
                    itemLabel.font = font;
                    itemLabel.text = itemName;
                    itemLabel.textColor = textColor;
                    itemLabel.textAlignment = NSTextAlignmentCenter;
                    itemLabel.lineBreakMode = NSLineBreakByCharWrapping;
                    [parentView addSubview:itemLabel];
                    
                    if (i < longTitleArray.count-1) {
                        offsetY += spacingY + itemHeight;
                    }
                    
                    if (!addItem) {
                        addItem = YES;
                    }
                }
            }
            
            if (height != NULL && height != nil) {
                if (addItem) {
//                    parentView.height = offsetY+itemHeight;
                    *height = offsetY+itemHeight - originalOffsetY;
                }else {
//                    parentView.height = offsetY; //没有添加过Label时，以offsetY作为父视图的高度
                    *height = 0;
                }
            }
        }
    }
}

/**
 根据经纬度，获取地址信息
 */
+ (void)getAddressWithLatitude:(double)lat longitude:(double)lon completion:(void (^)(NSArray *placemarks, NSError *error))block
{
    CLGeocoder *geocoder = [CLGeocoder new];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (block) {
            block(placemarks, error);
        }
    }];
}

// 将用户选中的标签 转为 Json字符串
+ (NSString *)jsonActTagsForTagArray:(NSArray *)tags isServerTag:(BOOL)serverTag
{
    if (tags.count) {
        
        NSMutableArray *tagArray = serverTag ? [NSMutableArray arrayWithCapacity:0] : [NSMutableArray arrayWithArray:tags];
        if (serverTag) {
            // 服务器直接请求下来的标签字典，需要进行解析
            for (NSDictionary *tagDict in tags) {
                NSString *tagId = [tagDict safeStringForKey:@"tagId"];
                NSString *tagName = [tagDict safeStringForKey:@"tagName"];
                NSInteger tagStatus = [tagDict safeIntegerForKey:@"status"];
                if (tagStatus == 1 && tagId.length && tagName.length) {
                    [tagArray addObject:@{
                                          @"tagId":tagId,
                                          @"tagName":tagName
                                          }];
                }
            }
        }
        
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:tagArray options:NSJSONWritingPrettyPrinted error:&error];
        if (!error && jsonData) {
            
            NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            FBLOG(str);
            return str.length ? str : @"";
        }
    }
    return @"";
}

/**
 活动列表标签数据需要更新
 */
+ (void)settingActivityListNeedUpdate {
    UITabBarController *tabBarVC = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    if ([tabBarVC isKindOfClass:[UITabBarController class]] && tabBarVC.viewControllers.count > 1) {
        UINavigationController *navVC = [tabBarVC.viewControllers objectAtIndex:1];
        ActivityListViewController *actListVC = (ActivityListViewController *)[navVC.viewControllers firstObject];
        if ([actListVC respondsToSelector:@selector(setNeedUpdateSelectTagView:)]) {
            [actListVC setNeedUpdateSelectTagView:YES];
        }
    }
}



#pragma mark - 辅助的方法

// 城市名显示处理
+ (NSString *)cityNameHandle:(NSString *)cityName
{
    if ([cityName isKindOfClass:[NSString class]] && cityName.length) {
        if (cityName.length > 2) {
            if ([cityName hasSuffix:@"市"]) {
                return [cityName substringToIndex:cityName.length-1];
            }
        }
        return [cityName copy];
    }
    return @"未知";
}


// 活动价格处理
NSString *MYActPriceHandle(NSInteger actIsFree, NSInteger priceType, NSString *actPrice, NSString *actPayPrice) {
    if (actIsFree == 3 && actPayPrice.length > 0) {
        actPrice = actPayPrice;
    }
    
    if (actIsFree == 2 || actIsFree == 3) {
        if (actPrice.length > 0 && [DataValidate isPureFloat:actPrice]) {
            if (priceType == 0) {
                return [NSString stringWithFormat:@"%@元起", actPrice];
            }else if (priceType == 1) {
                return [NSString stringWithFormat:@"%@元/人", actPrice];
            }else if (priceType == 2) {
                return [NSString stringWithFormat:@"%@元/张", actPrice];
            }else if (priceType == 3) {
                return [NSString stringWithFormat:@"%@元/份", actPrice];
            }else {
                return [NSString stringWithFormat:@"%@元/张", actPrice];
            }
        }else {
            return @"收费";
        }
    }
    return @"免费";
}


// 根据orderLine 获取座位数组
+ (NSArray *)seatsArrayForOrderSeats:(NSString *)orderSeats {
    if (orderSeats.length && [orderSeats containsSubString:@"_"]) {
        NSArray *array = [orderSeats componentsSeparatedByString:@","];
        
        NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < array.count; i++) {
            NSString *aSeat = array[i];
            if (aSeat.length) {
                NSArray *tmpArray = [aSeat componentsSeparatedByString:@"_"];
                if (tmpArray.count == 2) {
                    [mutableArray addObject:[NSString stringWithFormat:@"%@排%@座",tmpArray[0],tmpArray[1]]];
                }
            }
        }
        return [mutableArray copy];
    }
    return nil;
}


// 是否包含Emoji表情
BOOL MYStringIncludeEmoji(NSString *string) {
    if (string.length) {
        return [string rangeOfString:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]" options:NSRegularExpressionSearch|NSCaseInsensitiveSearch range:NSMakeRange(0, string.length)].location != NSNotFound;
    }
    return NO;
}

/**
 在URL中插入一个字段（若已存在该字段，则更新此值）
 */
NSString *MYURLByInsertField(NSString *url, NSString *fieldName, NSString *fieldValue) {
    if (url.length) {
        // 先检查url中是否已有该字段
        NSUInteger location = [url rangeOfString:[NSString stringWithFormat:@"%@=", fieldName]].location;
        if (location != NSNotFound) {
            // 若已存在，则更新原有值
            return [url stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"([\\?|&]%@=)([^&]*)(&)?", fieldName] withString:[NSString stringWithFormat:@"$1%@$3", fieldValue] options:NSRegularExpressionSearch range:NSMakeRange(0, url.length)];
        }else {
            // 原先不包含userId的情况下
            if ([url rangeOfString:@"?"].location != NSNotFound) {
                return [NSString stringWithFormat:@"%@&%@=%@", url, fieldName, fieldValue];
            }else {
                return [NSString stringWithFormat:@"%@?%@=%@", url, fieldName, fieldValue];
            }
        }
    }
    
    return @"";
}


@end

