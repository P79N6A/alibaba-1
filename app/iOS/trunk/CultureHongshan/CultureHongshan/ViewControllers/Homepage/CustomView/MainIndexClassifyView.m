//
//  MainIndexClassifyView.m
//  CultureHongshan
//
//  Created by ct on 16/7/25.
//  Copyright © 2016年 CT. All rights reserved.
//

#import "MainIndexClassifyView.h"

#import "AdvertModel.h"

@interface MainIndexClassifyView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;


@property (nonatomic, strong) NSArray *modelArray;
@property (nonatomic, copy) AdvertBlock block;


@end


@implementation MainIndexClassifyView



- (instancetype)initWithFrame:(CGRect)frame modelArray:(NSArray *)modelArray callBackBlock:(AdvertBlock)block
{
    if (self = [super initWithFrame:frame]) {
        // 110
        if (modelArray.count < 1) {
            return nil;
        }
        
        self.backgroundColor = [UIColor whiteColor];
        self.block = block;
        self.modelArray = modelArray;
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.height)];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        [self addSubview:_scrollView];
        
        CGFloat itemWidth = kScreenWidth/4.0;
        CGFloat itemHeight = _scrollView.height;
        
        CGFloat imgWidth = 70; // 140x120
        CGFloat imgHeight = 60;
        
        UIImage *placeImg = [UIToolClass getPlaceholderWithViewSize:CGSizeMake(imgWidth, imgHeight) centerSize:CGSizeMake(20, 20) isBorder:NO];
        for (int i = 0; i < modelArray.count; i++) {
            
            AdvertModel *model = modelArray[i];
            
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i*itemWidth, 0, itemWidth, itemHeight)];
            button.tag = i;
            button.backgroundColor = [UIColor whiteColor];
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [_scrollView addSubview:button];
            
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, imgWidth, imgHeight)];
//            imgView.contentMode = UIViewContentModeScaleAspectFit;
            imgView.backgroundColor = [UIColor whiteColor];
            [imgView sd_setImageWithURL:[NSURL URLWithString:JointedImageURL(model.advImgUrl,kImageSize_Adv_140_120)] placeholderImage:placeImg];
            [button addSubview:imgView];
            imgView.centerX = button.width*0.5;
            
            UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, imgView.maxY, button.width-10, 18)];
            nameLabel.textColor = kLabelBlueColor;
            nameLabel.attributedText = [UIToolClass boldString:model.advertName font:FontYT(12) lineSpacing:0 alignment:NSTextAlignmentCenter];
            [button addSubview:nameLabel];
            
            if (i == modelArray.count-1) {
                _scrollView.height = button.height;
                _scrollView.contentSize = CGSizeMake(_scrollView.width*[ToolClass  getGroupNum:modelArray.count perGroupCount:4], _scrollView.height);
            }
        }
        
        [self initPageControl];
    }
    return self;
}

- (void)initPageControl
{
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(10, self.height-20, kScreenWidth-20, 10)];
    _pageControl.currentPageIndicatorTintColor = kOrangeYellowColor;  // kThemeDeepColor
    _pageControl.pageIndicatorTintColor = RGB(217, 217, 217);
    _pageControl.currentPage = 0;
    _pageControl.numberOfPages = [ToolClass  getGroupNum:_modelArray.count perGroupCount:4];
    _pageControl.hidesForSinglePage = YES;
    [self addSubview:_pageControl];
}



- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger currentIndex = scrollView.contentOffset.x / scrollView.bounds.size.width;
    _pageControl.currentPage = currentIndex;
}


- (void)buttonClick:(UIButton *)sender
{
    if (self.block) {
        self.block(_modelArray[sender.tag], sender.currentImage);
    }
}


- (void)setContentOffsetX:(CGFloat)contentOffsetX {
    _scrollView.contentOffset = CGPointMake(contentOffsetX, 0);
    _pageControl.currentPage = contentOffsetX / _scrollView.width;
}


- (CGFloat)contentOffsetX
{
    return _scrollView.contentOffset.x;
}

@end
