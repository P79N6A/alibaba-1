//
//  WebPhotoBrowserView.m
//  CultureHongshan
//
//  Created by ct on 16/5/17.
//  Copyright © 2016年 CT. All rights reserved.
//

#import "WebPhotoBrowserView.h"
#import "WebPhotoBrowser.h"
#import "ShareService.h"
#import "SharePresentView.h"

#define kIndicatorViewBgColor [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]

// 图片下载进度指示器内部控件间的间距
#define kIndicatorViewItemMargin 10

@interface WebPhotoBrowserView ()<UIScrollViewDelegate>
{
    UIImageView *_imageView;
}

@property (nonatomic, strong) WebPhotoBrowserIndicatorView *indicatorView;

@end



@implementation WebPhotoBrowserView


-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _scrollView.minimumZoomScale = 0.6;
    _scrollView.maximumZoomScale = 3;
    _scrollView.zoomScale = 1;
    [self addSubview:_scrollView];
    _scrollView.delegate = self;
    
    _imageView = [[UIImageView alloc] init];
    [_scrollView addSubview:_imageView];
    
    //双击手势
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureHandle:)];
    doubleTap.numberOfTapsRequired = 2;
    doubleTap.numberOfTouchesRequired = 1;
    [_scrollView addGestureRecognizer:doubleTap];
    
    //单击手势
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureHandle:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [singleTap requireGestureRecognizerToFail:doubleTap];//只能有一个手势存在
    [_scrollView addGestureRecognizer:singleTap];
    
    //长按手势
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(gestureHandle:)];
    longPressGesture.minimumPressDuration = 0.8;
    [_scrollView addGestureRecognizer:longPressGesture];
}


- (void)layoutSubviews {
    
    _scrollView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    if (_indicatorView) {
        _indicatorView.center = CGPointMake(self.width/2, self.height/2);
    }
    
    [self resetImageView];
    
    [super layoutSubviews];
}

- (void)resetImageView {
    CGFloat scale = _imageView.image.size.width > 0 ? _imageView.image.size.height*1.0/_imageView.image.size.width : 0.0f;
    _imageView.bounds = CGRectMake(0, 0, self.width, self.width*scale);
    _imageView.center = CGPointMake(self.width*0.5, self.height*0.5);
    
    _scrollView.zoomScale = 1.0f;
}


- (void)beginDownloadImage
{
    if ([self.imageUrl isKindOfClass:[NSString class]] && self.imageUrl.length) {
        __weak UIImageView *weakImgView = _imageView;
        WS(weakSelf);
        if (_imageView.image) {
            _imageView.image = nil;
        }
        
        self.indicatorView.progress = 0;
        
        [_imageView sd_setImageWithURL:[NSURL URLWithString:self.imageUrl] placeholderImage:nil options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            // 图片下载进度
            if (receivedSize >= 0 && expectedSize > 0) {
                if ([NSThread isMainThread]) {
                    weakSelf.indicatorView.progress = MIN(MAX(receivedSize*1.0/expectedSize, 0), 1);
                }else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        weakSelf.indicatorView.progress = MIN(MAX(receivedSize*1.0/expectedSize, 0), 1);
                    });
                }
            }
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            [_indicatorView removeFromSuperview];
            _indicatorView = nil;
            
            if (image && error == nil) {
                weakImgView.image = image;
                
                [weakSelf resetImageView];
            } else {
                if (weakSelf.isShowed) {
                    [SVProgressHUD showInfoWithStatus:@"图片加载失败，请稍后再试!"];
                }
            }
        }];
        
    }else if ([self.imageUrl isKindOfClass:[UIImage class]]) {
        if (_indicatorView) {
            [_indicatorView removeFromSuperview];
            _indicatorView = nil;
        }
        if (_imageView.image) {
            _imageView.image = nil; // 清除原有数据
        }
        _imageView.image = (UIImage *)self.imageUrl;
        
        [self resetImageView];
    }
}



- (void)dismiss
{
    WS(weakSelf);
    __weak WebPhotoBrowser *parentView = (WebPhotoBrowser *)self.superview.superview;
    
    [UIView animateWithDuration:0.5 animations:^
     {
         parentView.alpha = 0.0;
     } completion:^(BOOL finished) {
         if ([parentView isKindOfClass:[WebPhotoBrowser class]]) {
             if (parentView.completionHandler) {
                 parentView.completionHandler(parentView);
             }
             [parentView removeFromSuperview];
         }else{
             [weakSelf removeFromSuperview];
         }
     }];
}



- (void)gestureHandle:(UIGestureRecognizer *)gesture
{
    if ([gesture isKindOfClass:[UITapGestureRecognizer class]]) {
        if ( ((UITapGestureRecognizer *)gesture).numberOfTapsRequired == 2 ){//双击手势
            // 图片的双击放大或缩小
            CGPoint touchPoint = [gesture locationInView:gesture.view];
            
            if (_scrollView.zoomScale <= 1.0)
            {
                CGFloat scaleX = touchPoint.x + _scrollView.contentOffset.x;//需要放大的图片的X点
                CGFloat sacleY = touchPoint.y + _scrollView.contentOffset.y;//需要放大的图片的Y点
                [_scrollView zoomToRect:CGRectMake(scaleX, sacleY, 10, 10) animated:YES];
            }
            else
            {
                [_scrollView setZoomScale:1.0 animated:YES]; //还原
            }
        }else{//单击手势
            [self dismiss];
        }
    }
    //长按手势
    else if ([gesture isKindOfClass:[UILongPressGestureRecognizer class]])
    {
        if (gesture.state == UIGestureRecognizerStateBegan)
        {
            WS(weakSelf)
            void (^actionBlock) (NSInteger, NSString *) = ^(NSInteger index, NSString *buttonTitle) {
                
                if ([buttonTitle isEqualToString:@"保存到手机"]) {
                    [weakSelf shareWithType:1];
                }else if ([buttonTitle isEqualToString:@"分享到微信"]) {
                    [weakSelf shareWithType:2];
                }else if ([buttonTitle isEqualToString:@"分享给QQ好友"]) {
                    [weakSelf shareWithType:3];
                }
            };
            
            
#ifndef FUNCTION_ENABLED_SHARE
            // 保存到手机
            [WHYAlertActionUtil showActionSheetWithTitle:nil msg:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil actionBlock:actionBlock otherButtonTitles:@"保存到手机", nil];
#else
            BOOL wechatInstall = [ShareService isWeiXinInstalled];
            BOOL qqInstall = [ShareService isQQInstalled];
//            BOOL weiboInstall = [ShareService isSinaWeiboInstalled];
            
            if (wechatInstall && qqInstall) {
                [WHYAlertActionUtil showActionSheetWithTitle:nil msg:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil actionBlock:actionBlock otherButtonTitles:@"分享给QQ好友", @"分享到微信", @"保存到手机", nil];
            }else if (wechatInstall && qqInstall == NO) {
                [WHYAlertActionUtil showActionSheetWithTitle:nil msg:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil actionBlock:actionBlock otherButtonTitles:@"分享到微信", @"保存到手机", nil];
            }else if (qqInstall && wechatInstall == NO) {
                [WHYAlertActionUtil showActionSheetWithTitle:nil msg:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil actionBlock:actionBlock otherButtonTitles:@"分享给QQ好友", @"保存到手机", nil];
            }else {
                [WHYAlertActionUtil showActionSheetWithTitle:nil msg:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil actionBlock:actionBlock otherButtonTitles:@"保存到手机", nil];
            }
#endif

        }
    }
}

#pragma mark - 代理方法

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return scrollView.subviews[0];
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    UIImageView *webImageView = scrollView.subviews[0];
    webImageView.center = [self centerOfScrollViewContent:scrollView];
}

- (CGPoint)centerOfScrollViewContent:(UIScrollView *)scrollView
{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    CGPoint actualCenter = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                       scrollView.contentSize.height * 0.5 + offsetY);
    return actualCenter;
}

#pragma mark - —————————— 分享 ——————————


/**
 分享操作

 @param type 类型：1-保存到手机  2-微信  3-QQ
 */
- (void)shareWithType:(NSInteger)type {
    UIImageView *webImageView = _scrollView.subviews[0];
    
    switch (type) {
        case 3: { // QQ
            [ShareService shareWithPlatformType:SSDKPlatformSubTypeQQFriend title:nil content:nil sharedImage:webImageView.image imageUrl:nil shareUrl:nil addIntegral:NO onStateChanged:^(NSUInteger status) {}];
        }
            break;
            
        case 2: { // 微信
            [ShareService shareWithPlatformType:SSDKPlatformSubTypeWechatSession title:nil content:nil sharedImage:webImageView.image imageUrl:nil shareUrl:nil addIntegral:NO onStateChanged:^(NSUInteger status) {}];
        }
            break;
            
        case 1: { // 保存到手机
            [self saveImageToDocumentsDirectotyWithImage:webImageView.image];
        }
            break;
            
        default:
            break;
    }
}


//保存图片至本地
- (void)saveImageToDocumentsDirectotyWithImage:(UIImage *)image {
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    [SVProgressHUD setMinimumDismissTimeInterval:1];
    if (error) {
        [SVProgressHUD showErrorWithStatus:@"保存失败"];
    } else  {
        [SVProgressHUD showSuccessWithStatus:@"保存成功"];
    }
}

#pragma mark -

- (UIImage *)currentImage {
    return _imageView.image;
}


- (WebPhotoBrowserIndicatorView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[WebPhotoBrowserIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 42, 42)];
        [self addSubview:_indicatorView];
        
        _indicatorView.center = CGPointMake(self.width*0.5, self.height*0.5);
    }
    return _indicatorView;
}


@end



/*  ——————————————————  WebPhotoBrowserIndicatorView  ——————————————————  */


@implementation WebPhotoBrowserIndicatorView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = kIndicatorViewBgColor;
        self.radius = self.height*0.5;
    }
    return self;
}

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    [self setNeedsDisplay];
    if (progress >= 1) {
        [self removeFromSuperview];
    }
}


- (void)drawRect:(CGRect)rect {
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    CGFloat xCenter = rect.size.width * 0.5;
    CGFloat yCenter = rect.size.height * 0.5;
    
    [[UIColor whiteColor] set];
    
    CGContextSetLineWidth(contextRef, 4);
    CGContextSetLineCap(contextRef, kCGLineCapRound);
    CGFloat to = - M_PI * 0.5 + self.progress * M_PI * 2 + 0.05;// 初始值0.05
    CGFloat radius = MIN(rect.size.width, rect.size.height) * 0.5 - kIndicatorViewItemMargin;
    CGContextAddArc(contextRef, xCenter, yCenter, radius, - M_PI * 0.5, to, 0);
    CGContextStrokePath(contextRef);
}



@end




