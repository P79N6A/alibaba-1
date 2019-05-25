//
//  WebPhotoBrowser.m
//  CultureHongshan
//
//  Created by ct on 16/7/19.
//  Copyright © 2016年 ct. All rights reserved.
//

#import "WebPhotoBrowser.h"

#import "WebPhotoBrowserView.h"


#define kPhotoViewMargin 20

@interface WebPhotoBrowser ()<UIScrollViewDelegate>
{
    UIImage   *_currentImg;
    UIScrollView *_bgScrollView;
    
    WebPhotoBrowserView *_previousPhotoView;
    WebPhotoBrowserView *_currentPhotoView;
    WebPhotoBrowserView *_nextPhotoView;
    
    
    UILabel *_indexLabel;//显示当前图片的索引
}

@property (nonatomic, assign) NSInteger currentIdx;
@property (nonatomic, strong) NSArray *imageUrlArray;

@end



@implementation WebPhotoBrowser

+ (void)photoBrowserWithImageUrlArray:(NSArray *)imgUrls
                         currentIndex:(NSInteger)currentIndex
                      completionBlock:(void (^)(WebPhotoBrowser *photoBrowser))block
{
    if (imgUrls.count < 1) {
        return;
    }else{
        if (currentIndex < 0 || currentIndex > imgUrls.count-1) {
            currentIndex = 0;
        }
    }
    
    WebPhotoBrowser *photoBrowser = [[WebPhotoBrowser alloc] init];
    photoBrowser.backgroundColor = [UIColor blackColor];
    photoBrowser.imageUrlArray = imgUrls;
    photoBrowser.currentIdx = currentIndex;
    photoBrowser.completionHandler = block;
    
    UIWindow *window = [UIToolClass getKeyWindow];
    [window addSubview:photoBrowser];
    
    [photoBrowser mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(window);
    }];
    
    [photoBrowser show];
}

- (void)show
{
    [[UIApplication sharedApplication].keyWindow.rootViewController prefersStatusBarHidden];
    
    
    _bgScrollView.scrollEnabled = _imageUrlArray.count > 1;
    
    [self updatePhotoViewImages];
    
    __weak UIScrollView *weakScrollView = _bgScrollView;
    [UIView animateWithDuration:0.5 animations:^{
         weakScrollView.alpha = 1;
     }];
}


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor blackColor];
        
        [self initScrollView];
        [self initPhotoViews];
        
        [self initIndexIndicatorLabel];
    }
    return self;
}


- (void)initScrollView
{
    if (_bgScrollView) {
        [_bgScrollView removeFromSuperview]; _bgScrollView = nil;
    }
    
    _bgScrollView = [[UIScrollView alloc] init];
    _bgScrollView.alpha = 0;
    _bgScrollView.showsVerticalScrollIndicator = NO;
    _bgScrollView.showsHorizontalScrollIndicator = NO;
    _bgScrollView.delegate = self;
    _bgScrollView.bounces = NO;
    _bgScrollView.pagingEnabled = YES;
    [self addSubview:_bgScrollView];
    
    WS(weakSelf)
    [_bgScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.and.bottom.equalTo(weakSelf);
        make.width.equalTo(weakSelf).offset(kPhotoViewMargin);
    }];
}

- (void)initPhotoViews
{
    _previousPhotoView = [[WebPhotoBrowserView alloc] init];
    [_bgScrollView addSubview:_previousPhotoView];
    
    _currentPhotoView = [[WebPhotoBrowserView alloc] init];
    [_bgScrollView addSubview:_currentPhotoView];
    
    _nextPhotoView = [[WebPhotoBrowserView alloc] init];
    [_bgScrollView addSubview:_nextPhotoView];
    
    // 添加约束
    [_previousPhotoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.and.height.equalTo(_bgScrollView);
        make.width.equalTo(_bgScrollView).offset(-kPhotoViewMargin);
    }];
    
    [_currentPhotoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_previousPhotoView.mas_right).offset(kPhotoViewMargin);
        make.top.bottom.and.width.equalTo(_previousPhotoView);
    }];
    
    [_nextPhotoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_currentPhotoView.mas_right).offset(kPhotoViewMargin);
        make.top.bottom.and.width.equalTo(_previousPhotoView);
        make.right.equalTo(_bgScrollView.mas_right).offset(-kPhotoViewMargin);
    }];
    
    _bgScrollView.contentOffset = CGPointMake(kScreenWidth+kPhotoViewMargin, 0);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _bgScrollView.contentOffset = CGPointMake(_bgScrollView.width, 0);
}

- (void)initIndexIndicatorLabel
{
    //序号显示
    _indexLabel = [[UILabel alloc] init];
    _indexLabel.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.4f];
    _indexLabel.radius = 16;
    _indexLabel.font = [UIFont systemFontOfSize:18];
    _indexLabel.numberOfLines = 0;
    _indexLabel.textColor = [UIColor whiteColor];
    _indexLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_indexLabel];
    
    WS(weakSelf)
    [_indexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.size.mas_equalTo(CGSizeMake(100, 32));
        make.top.equalTo(weakSelf).offset(HEIGHT_STATUS_BAR + 8);
    }];
}


- (void)updatePhotoViewImages
{
    if (_imageUrlArray.count) {
        NSInteger previousIndex = [self getPreviousIndex];
        NSInteger nextIndex = [self getNextIndex];
        
        _previousPhotoView.imageUrl = _imageUrlArray[previousIndex];
        _currentPhotoView.imageUrl = _imageUrlArray[_currentIdx];
        _nextPhotoView.imageUrl = _imageUrlArray[nextIndex];
        
        [_previousPhotoView resetImageView];
        [_currentPhotoView resetImageView];
        [_nextPhotoView resetImageView];
        
        _previousPhotoView.isShowed = NO;
        _currentPhotoView.isShowed = YES;
        _nextPhotoView.isShowed = NO;
        
        [_previousPhotoView beginDownloadImage];
        [_currentPhotoView beginDownloadImage];
        [_nextPhotoView beginDownloadImage];
        
        if (_imageUrlArray.count > 1) {
            _indexLabel.hidden = NO;
            _indexLabel.text = [NSString stringWithFormat:@"%d / %d",(int)_currentIdx+1, (int)_imageUrlArray.count];
        }else {
            _indexLabel.hidden = YES;
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = (scrollView.contentOffset.x+kPhotoViewMargin)/scrollView.bounds.size.width;
    if (index == 1) {
        return;
    }
    
    if (index == 0){ //查看上一张
        _currentIdx = [self getPreviousIndex];
    } else if (index == 2){ //查看下一张
        _currentIdx = [self getNextIndex];
    }
    
    scrollView.contentOffset = CGPointMake(kScreenWidth+kPhotoViewMargin, 0);
    
    [self updatePhotoViewImages];//重新布局图片
}



#pragma mark - Other Methods

- (NSInteger)currentIndex
{
    return _currentIdx;
}

- (UIImage *)currentImage
{
    return _currentPhotoView.currentImage;
}


- (NSInteger)getPreviousIndex
{
    NSInteger index = _currentIdx - 1;
    return index < 0 ? _imageUrlArray.count - 1 : index;
}

- (NSInteger)getNextIndex
{
    NSInteger index = _currentIdx + 1;
    return  index > _imageUrlArray.count - 1 ? 0 : index;
}


@end
