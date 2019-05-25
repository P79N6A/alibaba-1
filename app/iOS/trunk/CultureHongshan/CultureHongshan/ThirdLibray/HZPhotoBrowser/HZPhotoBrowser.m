//
//  HZPhotoBrowser.m
//  photoBrowser
//
//  Created by huangzhenyu on 15/6/23.
//  Copyright (c) 2015年 eamon. All rights reserved.
//

#import "HZPhotoBrowser.h"
#import "HZPhotoBrowserConfig.h"

#import "ShareService.h"


@interface HZPhotoBrowser() <UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,assign) BOOL hasShowedPhotoBrowser;
@property (nonatomic,strong) UILabel *indexLabel;
@property (nonatomic,strong) UIActivityIndicatorView *indicatorView;
@property (nonatomic,strong) UIButton *saveButton;

@end



@implementation HZPhotoBrowser

- (void)viewDidLoad
{
    [super viewDidLoad];
    _hasShowedPhotoBrowser = NO;
    self.view.backgroundColor = kPhotoBrowserBackgrounColor;
    [self addScrollView];
    [self addToolbars];
    [self setUpFrames];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!_hasShowedPhotoBrowser)
    {
        [self showPhotoBrowser];
    }
}



#pragma mark 重置各控件frame（处理屏幕旋转）
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    [self setUpFrames];
}

#pragma mark 设置各控件frame
- (void)setUpFrames
{
    CGRect rect = self.view.bounds;
    rect.size.width += kPhotoBrowserImageViewMargin * 2;
    _scrollView.bounds = rect;
    _scrollView.center = CGPointMake(kScreenWidth *0.5, kScreenHeight *0.5);
    
    CGFloat y = 0;
    __block CGFloat w = kScreenWidth;
    CGFloat h = kScreenHeight;
    
    //设置所有HZPhotoBrowserView的frame
    [_scrollView.subviews enumerateObjectsUsingBlock:^(HZPhotoBrowserView *obj, NSUInteger idx, BOOL *stop) {
        CGFloat x = kPhotoBrowserImageViewMargin + idx * (kPhotoBrowserImageViewMargin * 2 + w);
        obj.frame = CGRectMake(x, y, w, h);
    }];
    
    _scrollView.contentSize = CGSizeMake(_scrollView.subviews.count * _scrollView.frame.size.width, kScreenHeight);
    _scrollView.contentOffset = CGPointMake(self.currentImageIndex * _scrollView.frame.size.width, 0);
    
    _indexLabel.bounds = CGRectMake(0, 0, 80, 30);
    _indexLabel.center = CGPointMake(kScreenWidth * 0.5, HEIGHT_STATUS_BAR + 10);
    _saveButton.frame = CGRectMake(30, kScreenHeight - 70, 55, 30);
}

#pragma mark 显示图片浏览器
- (void)showPhotoBrowser
{
    UIView *sourceView = self.sourceImagesContainerView.subviews[self.currentImageIndex];
    UIView *parentView = [self getParsentView:sourceView];
    CGRect rect = [sourceView.superview convertRect:sourceView.frame toView:parentView];
    
    //如果是tableview，要减去偏移量
    if ([parentView isKindOfClass:[UIScrollView class]]) {
        UIScrollView *tableview = (UIScrollView *)parentView;
        rect.origin.y =  rect.origin.y - tableview.contentOffset.y;
    }
    
    UIImageView *tempImageView = [[UIImageView alloc] init];
    tempImageView.frame = rect;
    tempImageView.image = [self placeholderImageForIndex:self.currentImageIndex];
    [self.view addSubview:tempImageView];
    tempImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    CGFloat placeImageSizeW = tempImageView.image.size.width;
    CGFloat placeImageSizeH = tempImageView.image.size.height;
    CGRect targetTemp;
    
    if (!kIsFullWidthForLandScape) {
        if (kScreenWidth < kScreenHeight) {
            CGFloat placeHolderH = (placeImageSizeH * kScreenWidth)/placeImageSizeW;
            if (placeHolderH <= kScreenHeight) {
                targetTemp = CGRectMake(0, (kScreenHeight - placeHolderH) * 0.5 , kScreenWidth, placeHolderH);
            } else {
                targetTemp = CGRectMake(0, 0, kScreenWidth, placeHolderH);
            }
        } else {
            CGFloat placeHolderW = (placeImageSizeW * kScreenHeight)/placeImageSizeH;
            if (placeHolderW < kScreenWidth) {
                targetTemp = CGRectMake((kScreenWidth - placeHolderW)*0.5, 0, placeHolderW, kScreenHeight);
            } else {
                targetTemp = CGRectMake(0, 0, placeHolderW, kScreenHeight);
            }
        }
        
    } else {
        CGFloat placeHolderH = (placeImageSizeH * kScreenWidth)/placeImageSizeW;
        if (placeHolderH <= kScreenHeight) {
            targetTemp = CGRectMake(0, (kScreenHeight - placeHolderH) * 0.5 , kScreenWidth, placeHolderH);
        } else {
            targetTemp = CGRectMake(0, 0, kScreenWidth, placeHolderH);
        }
    }
    
    _scrollView.hidden = YES;
    _indexLabel.hidden = YES;
    _saveButton.hidden = YES;
    
    [UIView animateWithDuration:kPhotoBrowserShowDuration animations:^{
        tempImageView.frame = targetTemp;
    } completion:^(BOOL finished)
     {
         _hasShowedPhotoBrowser = YES;
         [tempImageView removeFromSuperview];
         _scrollView.hidden = NO;
         _indexLabel.hidden = NO;
         _saveButton.hidden = NO;
     }];
}

#pragma mark 添加scrollview
- (void)addScrollView
{
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.frame = self.view.bounds;
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.hidden = YES;
    [self.view addSubview:_scrollView];
    
    for (int i = 0; i < self.imageCount; i++)
    {
        HZPhotoBrowserView *view = [[HZPhotoBrowserView alloc] init];
        view.imageview.tag = i;
        
        //处理单击
        __weak __typeof(self)weakSelf = self;
        view.gestureBlock = ^(UIGestureRecognizer *recognizer)
        {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if ([recognizer isKindOfClass:[UITapGestureRecognizer class]])//单击手势
            {
                [strongSelf hidePhotoBrowser:recognizer];
            }
            else if ([recognizer isKindOfClass:[UILongPressGestureRecognizer class]])//长按手势
            {
                [strongSelf handleLongPressGesture:recognizer];
            }
        };
        
        [_scrollView addSubview:view];
    }
    [self setupImageOfImageViewForIndex:self.currentImageIndex];
}

#pragma mark 添加操作按钮
- (void)addToolbars
{
    // 序号
    UILabel *indexLabel = [[UILabel alloc] init];
    indexLabel.textAlignment = NSTextAlignmentCenter;
    indexLabel.textColor = [UIColor whiteColor];
    indexLabel.font = [UIFont boldSystemFontOfSize:20];
    indexLabel.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.3f];
    indexLabel.bounds = CGRectMake(0, 0, 100, 40);
    indexLabel.center = CGPointMake(kScreenWidth * 0.5, 30);
    indexLabel.radius = 15;
    indexLabel.clipsToBounds = YES;
    
    if (self.imageCount > 1) {
        indexLabel.text = [NSString stringWithFormat:@"%ld/%ld", (long)self.currentImageIndex+1, (long)self.imageCount];
        _indexLabel = indexLabel;
        [self.view addSubview:indexLabel];
    }
    
    //    // 2.保存按钮
    //    UIButton *saveButton = [[UIButton alloc] init];
    //    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    //    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    saveButton.layer.borderWidth = 0.1;
    //    saveButton.layer.borderColor = [UIColor whiteColor].CGColor;
    //    saveButton.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.3f];
    //    saveButton.radius = 2;
    //    saveButton.clipsToBounds = YES;
    //    [saveButton addTarget:self action:@selector(saveImage) forControlEvents:UIControlEventTouchUpInside];
    //    _saveButton = saveButton;
    //    [self.view addSubview:saveButton];
}

#pragma mark 保存图像
- (void)saveImage
{
    if (_indicatorView)//已经在保存中
    {
        return;
    }
    
    int index = _scrollView.contentOffset.x / _scrollView.bounds.size.width;
    
    HZPhotoBrowserView *currentView = _scrollView.subviews[index];
    
    UIImageWriteToSavedPhotosAlbum(currentView.imageview.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] init];
    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    indicator.center = self.view.center;
    _indicatorView = indicator;
    [[UIApplication sharedApplication].keyWindow addSubview:indicator];
    [indicator startAnimating];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
{
    [_indicatorView removeFromSuperview];
    _indicatorView = nil;
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.50f];
    label.radius = 5;
    label.clipsToBounds = YES;
    label.bounds = CGRectMake(0, 0, 150, 60);
    label.center = self.view.center;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:21];
    [[UIApplication sharedApplication].keyWindow addSubview:label];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:label];
    if (error)
    {
        label.text = @"保存失败";
    }   else {
        label.text = @"保存成功";
    }
    [label performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:1.0];
}

- (void)show
{
    [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:self animated:NO completion:nil];
}


#pragma mark 网络加载图片
- (void)setupImageOfImageViewForIndex:(NSInteger)index
{
    HZPhotoBrowserView *view = _scrollView.subviews[index];
    
    
    if (view.imageType == PhotoBrowserImageTypeImage)
        return;
    if (view.beginLoadingImage)
        return;
    
    
    id imageOrUrl = [self highQualityImageOrImageURLForIndex:index];
    
    if (imageOrUrl)
    {
        if ([imageOrUrl isKindOfClass:[NSURL class]])//图片链接URL
        {
            view.imageType = PhotoBrowserImageTypeURL;
            [view setImageWithURL:imageOrUrl placeholderImage:[self placeholderImageForIndex:index]];
        }
        else if ([imageOrUrl isKindOfClass:[NSString class]])//图片链接String
        {
            view.imageType = PhotoBrowserImageTypeURL;
            [view setImageWithURL:[NSURL URLWithString:imageOrUrl] placeholderImage:[self placeholderImageForIndex:index]];
        }
        else if ([imageOrUrl isKindOfClass:[UIImage class]])//图片Image
        {
            view.imageType = PhotoBrowserImageTypeImage;
            view.hasLoadedImage = YES;
            view.imageview.image = imageOrUrl;
        }
        else
        {
            view.imageType = PhotoBrowserImageTypeNone;
            view.imageview.image = nil;
        }
    }
    else
    {
        view.imageview.image = [self placeholderImageForIndex:index];
    }
    view.beginLoadingImage = YES;
}

#pragma mark 获取控制器的view
- (UIView *)getParsentView:(UIView *)view{
    if ([[view nextResponder] isKindOfClass:[UIViewController class]] || view == nil) {
        return view;
    }
    return [self getParsentView:view.superview];
}

#pragma mark 获取低分辨率（占位）图片
- (UIImage *)placeholderImageForIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(photoBrowser:placeholderImageForIndex:)])
    {
        UIImage *placeholderImage = [self.delegate photoBrowser:self placeholderImageForIndex:index];
        if ([placeholderImage isKindOfClass:[UIImage class]])
        {
            return placeholderImage;
        }
    }
    return nil;
}

#pragma mark 获取高分辨率图片或图片URL
- (id)highQualityImageOrImageURLForIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(photoBrowser:highQualityImageOrImageURLForIndex:)])
    {
        return [self.delegate photoBrowser:self highQualityImageOrImageURLForIndex:index];
    }
    return nil;
}


#pragma mark - scrollview代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int index = (scrollView.contentOffset.x + _scrollView.bounds.size.width * 0.5) / _scrollView.bounds.size.width;
    
    _indexLabel.text = [NSString stringWithFormat:@"%d/%ld", index + 1, (long)self.imageCount];
    long left = index - 2;
    long right = index + 2;
    left = left>0 ? left : 0;
    right = right>self.imageCount ? self.imageCount : right;
    
    //预加载三张图片
    for (long i = left; i < right; i++)
    {
        [self setupImageOfImageViewForIndex:i];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int autualIndex = scrollView.contentOffset.x  / _scrollView.bounds.size.width;
    //设置当前下标
    self.currentImageIndex = autualIndex;
    
    //将不是当前imageview的缩放全部还原 (这个方法有些冗余，后期可以改进)
    for (HZPhotoBrowserView *view in _scrollView.subviews)
    {
        if (view.imageview.tag != autualIndex)
        {
            view.scrollview.zoomScale = 1.0;
            [view adjustFrames];
        }
    }
}


#pragma mark - 横竖屏设置
- (BOOL)shouldAutorotate
{
    return shouldSupportLandscape;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if (shouldSupportLandscape) {
        return UIInterfaceOrientationMaskAll;
    } else{
        return UIInterfaceOrientationMaskPortrait;
    }
    
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}


#pragma mark  - 单击隐藏图片浏览器
- (void)hidePhotoBrowser:(UIGestureRecognizer *)recognizer
{
    HZPhotoBrowserView *view = (HZPhotoBrowserView *)recognizer.view;
    UIImageView *currentImageView = view.imageview;
    
    UIView *sourceView = self.sourceImagesContainerView.subviews[self.currentImageIndex];
    UIView *parentView = [self getParsentView:sourceView];
    
    CGRect targetTemp = CGRectZero;
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    if (window) {
        targetTemp = [sourceView.superview convertRect:sourceView.frame toView:window];
    }else {
        targetTemp = [sourceView.superview convertRect:sourceView.frame toView:parentView];
    }
    
    // 减去偏移量
    if ([parentView isKindOfClass:[UIScrollView class]])
    {
        UIScrollView *tableview = (UIScrollView *)parentView;
        targetTemp.origin.y =  targetTemp.origin.y - tableview.contentOffset.y;
    }
    
    CGFloat appWidth;
    CGFloat appHeight;
    if (kScreenWidth < kScreenHeight) {
        appWidth = kScreenWidth;
        appHeight = kScreenHeight;
    } else {
        appWidth = kScreenHeight;
        appHeight = kScreenWidth;
    }
    
    UIImageView *tempImageView = [[UIImageView alloc] init];
    tempImageView.image = currentImageView.image;
    if (tempImageView.image) {
        CGFloat tempImageSizeH = tempImageView.image.size.height;
        CGFloat tempImageSizeW = tempImageView.image.size.width;
        CGFloat tempImageViewH = (tempImageSizeH * appWidth)/tempImageSizeW;
        if (tempImageViewH < appHeight) {
            tempImageView.frame = CGRectMake(0, (appHeight - tempImageViewH)*0.5, appWidth, tempImageViewH);
        } else {
            tempImageView.frame = CGRectMake(0, 0, appWidth, tempImageViewH);
        }
    } else {
        tempImageView.backgroundColor = [UIColor whiteColor];
        tempImageView.frame = CGRectMake(0, (appHeight - appWidth)*0.5, appWidth, appWidth);
    }
    
    [self.view.window addSubview:tempImageView];
    
    [self dismissViewControllerAnimated:NO completion:nil];
    
    
    
    [UIView animateWithDuration:kPhotoBrowserHideDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        tempImageView.frame = targetTemp;
    } completion:^(BOOL finished)
     {
         [tempImageView removeFromSuperview];
     }];
}


#pragma mark - 图片长按事件

- (void)handleLongPressGesture:(UIGestureRecognizer *)gesture
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

#pragma mark - —————————— 分享 ——————————


/**
 分享操作
 
 @param type 类型：1-保存到手机  2-微信  3-QQ
 */
- (void)shareWithType:(NSInteger)type {
    
    int index = _scrollView.contentOffset.x / _scrollView.bounds.size.width;
    
    HZPhotoBrowserView *currentView = _scrollView.subviews[index];
    
    switch (type) {
        case 3: { // QQ
            [ShareService shareWithPlatformType:SSDKPlatformSubTypeQQFriend title:nil content:nil sharedImage:currentView.imageview.image imageUrl:nil shareUrl:nil addIntegral:NO onStateChanged:^(NSUInteger status) {}];
        }
            break;
            
        case 2: { // 微信
            [ShareService shareWithPlatformType:SSDKPlatformSubTypeWechatSession title:nil content:nil sharedImage:currentView.imageview.image imageUrl:nil shareUrl:nil addIntegral:NO onStateChanged:^(NSUInteger status) {}];
        }
            break;
            
        case 1: { // 保存到手机
            if (_indicatorView) {
                return; // 已经在保存
            }
            
            UIImageWriteToSavedPhotosAlbum(currentView.imageview.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
            
            UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] init];
            indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
            indicator.center = self.view.center;
            _indicatorView = indicator;
            [[UIApplication sharedApplication].keyWindow addSubview:indicator];
            [indicator startAnimating];
        }
            break;
            
        default:
            break;
    }
}





@end
