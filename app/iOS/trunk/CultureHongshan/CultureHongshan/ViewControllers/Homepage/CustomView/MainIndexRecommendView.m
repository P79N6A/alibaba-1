//
//  MainIndexRecommendView.m
//  CultureHongshan
//
//  Created by ct on 16/7/25.
//  Copyright © 2016年 CT. All rights reserved.
//

#import "MainIndexRecommendView.h"

#import "AdvertModel.h"

@interface MainIndexRecommendView ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSArray *modelArray;
@property (nonatomic, copy) AdvertBlock block;


@end


@implementation MainIndexRecommendView



- (instancetype)initWithFrame:(CGRect)frame modelArray:(NSArray *)modelArray callBackBlock:(AdvertBlock)block
{
    if (self = [super initWithFrame:frame]) {
        if (modelArray.count < 1) {
            return nil;
        }
        
        self.backgroundColor = [UIColor whiteColor];
        self.block = block;
        self.modelArray = modelArray;
        
        CGFloat imgSize = 21;
        CGFloat textWidth = [UIToolClass textWidth:@"为您推荐" font:FontYT(15)];
        
        //标题
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, textWidth, 47.5)];
        titleLabel.textColor = kLabelBlueColor;
        titleLabel.attributedText = [UIToolClass boldString:@"为您推荐" font:FontYT(15) lineSpacing:0 alignment:NSTextAlignmentCenter];
        [self addSubview:titleLabel];
        
        //图片
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth-imgSize-6-textWidth)*0.5, (titleLabel.height-imgSize)*0.5, imgSize, imgSize)];
        imgView.image = IMG(@"icon_为您推荐");
        [self addSubview:imgView];
        titleLabel.originalX = imgView.maxX+6;
        
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, titleLabel.maxY, kScreenWidth-10, 140)];
        _scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_scrollView];
        
        // 47.5 + 150*0.63 + 35 + 20
        
        
        //300x260
        CGFloat imgWidth = 150;//(kScreenWidth-3*5)*0.5
        CGFloat imgHeight = imgWidth*0.63;
        
        UIImage *placeImg = [UIToolClass getPlaceholderWithViewSize:CGSizeMake(imgWidth, imgHeight) centerSize:CGSizeMake(20, 20) isBorder:NO];
        for (int i = 0; i < modelArray.count; i++) {
            
            AdvertModel *model = modelArray[i];
            
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i*(5+imgWidth), 0, imgWidth, imgHeight+35)];
            button.tag = i;
            button.backgroundColor = [UIColor whiteColor];
            button.layer.borderColor = [UIToolClass colorFromHex:@"DFDFDF"].CGColor;
            button.layer.borderWidth = 0.6;
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [_scrollView addSubview:button];
            
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(-0.1, 0, imgWidth+0.2, imgHeight)];
            [imgView sd_setImageWithURL:[NSURL URLWithString:JointedImageURL(model.advImgUrl,kImageSize_Adv_300_190)] placeholderImage:placeImg];
            [button addSubview:imgView];
            
            UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, imgView.maxY, button.width-10, button.height-imgView.height)];
            nameLabel.textColor = kDeepLabelColor;
            nameLabel.textAlignment = NSTextAlignmentCenter;
            nameLabel.text = model.advertName;
            nameLabel.font = FontYT(13);
            [button addSubview:nameLabel];
            
            if (i == modelArray.count-1) {
                _scrollView.height = button.height;
                _scrollView.contentSize = CGSizeMake(button.maxX, _scrollView.height);
            }
        }
    }
    return self;
}

- (void)buttonClick:(UIButton *)sender
{
    if (self.block) {
        self.block(_modelArray[sender.tag], sender.currentImage);
    }
}


- (void)setContentOffsetX:(CGFloat)contentOffsetX {
    _scrollView.contentOffset = CGPointMake(contentOffsetX, 0);
}


- (CGFloat)contentOffsetX
{
    return _scrollView.contentOffset.x;
}


@end
