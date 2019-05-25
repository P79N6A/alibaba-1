//
//  ShowOtherActivityCell.m
//  CultureHongshan
//
//  Created by JackAndney on 16/7/24.
//  Copyright © 2016年 ct. All rights reserved.
//

#import "ShowOtherActivityCell.h"

#import "ShowOtherActivityModel.h"

@interface ShowOtherActivityCell ()

@property (nonatomic, strong) ShowOtherActivityModel *leftModel;
@property (nonatomic, strong) ShowOtherActivityModel *rightModel;

@end


@implementation ShowOtherActivityCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 360x228
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];

    }
    return self;
}

- (void)setLeftModel:(ShowOtherActivityModel *)leftModel
          rightModel:(ShowOtherActivityModel *)rightModel
          topSpacing:(CGFloat)topSpacing
       bottomSpacing:(CGFloat)bottomSpacing
{
    if (!leftModel) {
        return;
    }
    self.leftModel = nil;
    self.rightModel = nil;
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    self.leftModel = leftModel;
    self.rightModel = rightModel;
    
    NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:1];
    if (leftModel) {
        [tmpArray addObject:leftModel];
    }
    if (rightModel) {
        [tmpArray addObject:rightModel];
    }
    
    CGFloat imgWidth = (kScreenWidth-3*5)*0.5;
    CGFloat imgHeight = imgWidth*0.63;
    CGFloat textWidth = 0;
    
    UIImage *placeImg = [UIToolClass getPlaceholderWithViewSize:CGSizeMake(imgWidth, imgHeight) centerSize:CGSizeMake(20, 20) isBorder:NO];
    for (int i = 0; i < tmpArray.count; i++) {
        
        ShowOtherActivityModel *model = tmpArray[i];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(5+i*(5+imgWidth), topSpacing, imgWidth, imgHeight+38)];
        button.tag = i+1;
        button.backgroundColor = [UIColor whiteColor];
        button.layer.borderColor = [UIToolClass colorFromHex:@"DFDFDF"].CGColor;
        button.layer.borderWidth = 0.6;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];
        
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(-0.1, 0, imgWidth+0.2, imgHeight)];
        [imgView sd_setImageWithURL:[NSURL URLWithString:JointedImageURL(model.activityIconUrl,kImageSize_300_300)] placeholderImage:placeImg];
        [button addSubview:imgView];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, imgView.maxY, button.width-10, button.height-imgView.height)];
        nameLabel.textColor = kDeepLabelColor;
        nameLabel.text = model.activityName;
        nameLabel.font = FontYT(14);
        [button addSubview:nameLabel];
        
        // 标签
        if (model.activityType.length) {
            textWidth = MIN([UIToolClass textWidth:model.activityType font:FontYT(14)]+18,button.width-16);
            
            UILabel *typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, textWidth, 20)];
            typeLabel.text = model.activityType;
            typeLabel.textAlignment = NSTextAlignmentCenter;
            typeLabel.textColor = COLOR_IWHITE;
            typeLabel.font = FontYT(14);
            typeLabel.radius = 3;
            typeLabel.backgroundColor = RGBA(78, 80, 74, 0.9);
            typeLabel.layer.borderColor = RGB(33, 34, 37).CGColor;
            typeLabel.layer.borderWidth = 0.5;
            [button addSubview:typeLabel];
        }
    }
}

- (void)buttonClick:(UIButton *)sender
{
    if (self.block) {
        if (sender.tag == 1) {
            self.block(_leftModel);
        }else if (sender.tag == 2){
            self.block(_rightModel);
        }
    }
}


@end
