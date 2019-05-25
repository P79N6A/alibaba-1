//
//  HZImagesGroupView.m
//  photoBrowser
//
//  Created by huangzhenyu on 15/6/23.
//  Copyright (c) 2015年 eamon. All rights reserved.
//

#import "HZImagesGroupView.h"
#import "HZPhotoBrowser.h"
#import "UIButton+WebCache.h"
#import "HZPhotoItemModel.h"

#define kImagesMargin 8

@interface HZImagesGroupView() <HZPhotoBrowserDelegate>

@end

@implementation HZImagesGroupView


- (void)setPhotoItemArray:(NSArray *)photoItemArray
{
    _photoItemArray = photoItemArray;
    [photoItemArray enumerateObjectsUsingBlock:^(HZPhotoItemModel *obj, NSUInteger idx, BOOL *stop) {
        UIButton *btn = [[UIButton alloc] init];
        
        
        if([obj isKindOfClass:[NSString class]])
        {
            
        }
        else if ([obj isKindOfClass:[UIImage class]])
        {
            
        }
        
        //让图片不变形，以适应按钮宽高，按钮中图片部分内容可能看不到
        btn.imageView.contentMode = UIViewContentModeScaleAspectFill;
        btn.clipsToBounds = YES;
        
        CGSize size = CGSizeMake(150, 150);
        if (_picScale)
        {
            size = CGSizeMake(150, 150*_picScale);
        }
        
        UIImage *placeImg = [UIToolClass getPlaceholderWithViewSize:size centerSize:CGSizeMake(22, 22) isBorder:YES];
        
        [btn sd_setImageWithURL:[NSURL URLWithString:obj.lowImageUrl] forState:UIControlStateNormal placeholderImage:placeImg completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
         {
             if (error)
             {
                 [btn sd_setImageWithURL:[NSURL URLWithString:obj.highImageUrl] forState:UIControlStateNormal placeholderImage:placeImg];
             }
         }];
        btn.tag = idx;
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat w = (_viewWidth-2*kImagesMargin-2*_spacing)/3.0;
    CGFloat h = _picScale ? _picScale*w : w;
    
    [self.subviews enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL *stop)
     {
         btn.frame = CGRectMake(_spacing + idx*(w+kImagesMargin), 0, w, h);
     }];
    self.frame = CGRectMake(0, 0, _viewWidth, h);
}

- (void)buttonClick:(UIButton *)button
{
    //启动图片浏览器
    HZPhotoBrowser *browserVc = [[HZPhotoBrowser alloc] init];
    browserVc.sourceImagesContainerView = self; // 原图的父控件
    browserVc.imageCount = self.photoItemArray.count; // 图片总数
    browserVc.currentImageIndex = (int)button.tag;
    browserVc.delegate = self;
    [browserVc show];
}

#pragma mark - photobrowser代理方法
- (UIImage *)photoBrowser:(HZPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    return [self.subviews[index] currentImage];
}


- (id)photoBrowser:(HZPhotoBrowser *)browser highQualityImageOrImageURLForIndex:(NSInteger)index
{
    id imageOrUrlStr = _photoItemArray[index];
    if ([imageOrUrlStr isKindOfClass:[NSString class]])
    {
        return [NSURL URLWithString:imageOrUrlStr];
    }
    else if ([imageOrUrlStr isKindOfClass:[UIImage class]])
    {
        return imageOrUrlStr;
    }
    return nil;
}


@end
