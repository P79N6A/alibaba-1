//
//  MainIndexSixBannerView.m
//  CultureHongshan
//
//  Created by ct on 16/7/26.
//  Copyright © 2016年 CT. All rights reserved.
//

#import "MainIndexSixBannerView.h"

#import "AdvertModel.h"

@interface MainIndexSixBannerView ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSArray *modelArray;
@property (nonatomic, copy) AdvertBlock block;

@end




@implementation MainIndexSixBannerView


- (instancetype)initWithFrame:(CGRect)frame modelArray:(NSArray *)modelArray callBackBlock:(AdvertBlock)block
{
    // (kScreenWidth-1)*0.5*0.59 + 1 + (kScreenWidth-3)/4.0*1.163
    if (self = [super initWithFrame:frame]) {
        if (modelArray.count < 6) {
            return nil;
        }
        self.backgroundColor = ColorFromHex(@"E8E8E8");
        self.block = block;
        self.modelArray = modelArray;
        
        CGFloat lineWidth = 0.6;
        CGFloat bigImgWidth = (kScreenWidth-lineWidth)*0.5;//
        CGFloat bigImgHeight = bigImgWidth*0.59;//374x221 375x220
        
        CGFloat smallImgWidth = (kScreenWidth-3*lineWidth)/4.0;//184x214 == 1.163    187x215
        CGFloat smallImgHeight = smallImgWidth*1.163;
        
        UIImage *placeImg1 = [UIToolClass getPlaceholderWithViewSize:CGSizeMake(bigImgWidth, bigImgHeight) centerSize:CGSizeMake(20, 20) isBorder:NO];
        UIImage *placeImg2 = [UIToolClass getPlaceholderWithViewSize:CGSizeMake(smallImgWidth, smallImgHeight) centerSize:CGSizeMake(20, 20) isBorder:NO];
    
        for (int i = 0; i < modelArray.count && i < 6; i++) {
            
            AdvertModel *model = modelArray[i];
            
            UIButton *button = [[UIButton alloc] init];
            button.frame = (i < 2) ? CGRectMake(i*(bigImgWidth+lineWidth), 0, bigImgWidth, bigImgHeight) : CGRectMake((i-2)*(smallImgWidth+lineWidth), bigImgHeight+lineWidth, smallImgWidth, smallImgHeight);
            button.tag = i;
            button.backgroundColor = [UIColor whiteColor];
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            
            if (i < 2) {
                [button sd_setImageWithURL:[NSURL URLWithString:JointedImageURL(model.advImgUrl, kImageSize_Adv_375_220)] forState:UIControlStateNormal placeholderImage:placeImg1];
            }else{
                [button sd_setImageWithURL:[NSURL URLWithString:JointedImageURL(model.advImgUrl, kImageSize_Adv_187_215)] forState:UIControlStateNormal placeholderImage:placeImg2];
            }
            
            if (i == 5 || i == modelArray.count-1) {
                MYMaskView *lineView = [MYMaskView maskViewWithBgColor:kBgColor frame:CGRectMake(0, button.maxY+1, kScreenWidth, self.height-button.maxY-1) radius:0];
                [self addSubview:lineView];
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


@end
