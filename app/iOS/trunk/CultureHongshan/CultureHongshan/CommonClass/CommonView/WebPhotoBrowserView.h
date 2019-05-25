//
//  WebPhotoBrowserView.h
//  CultureHongshan
//
//  Created by ct on 16/5/17.
//  Copyright © 2016年 CT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebPhotoBrowserView : UIView

@property (nonatomic, assign) BOOL         isShowed;
@property (nonatomic, copy  ) NSString     *imageUrl;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImage      *currentImage;

- (void)beginDownloadImage;

/** 恢复默认状态 */
- (void)resetImageView;

@end


/*  ——————————————————  WebPhotoBrowserIndicatorView  ——————————————————  */


@interface WebPhotoBrowserIndicatorView : UIView

@property (nonatomic, assign) CGFloat progress;

@end
