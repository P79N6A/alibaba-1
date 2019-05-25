//
//  HZPhotoBrowserView.h
//  photoBrowser
//
//  Created by huangzhenyu on 15/6/23.
//  Copyright (c) 2015年 eamon. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum {
    PhotoBrowserImageTypeNone  = 1,
    PhotoBrowserImageTypeImage = 2,
    PhotoBrowserImageTypeURL   = 3,
} PhotoBrowserImageType;



@interface HZPhotoBrowserView : UIView

@property (nonatomic, assign) PhotoBrowserImageType imageType;

@property (nonatomic,strong) UIScrollView *scrollview;
@property (nonatomic,strong) UIImageView *imageview;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) BOOL beginLoadingImage;
@property (nonatomic, assign) BOOL hasLoadedImage;//图片下载成功为YES 否则为NO

//单击和长按手势的回调
@property (nonatomic, copy) void (^gestureBlock)(UIGestureRecognizer *recognizer);

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;

- (void)adjustFrames;

@end
