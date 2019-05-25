//
//  AntiqueListCell.m
//  CultureHongshan
//
//  Created by one on 15/11/23.
//  Copyright © 2015年 CT. All rights reserved.
//

#import "AntiqueListCell.h"

#import "AntiqueModel.h"

@interface AntiqueListCell ()

@property (nonatomic, strong) UIImageView *picView;
@property (nonatomic, strong) UILabel     *titleLabel;
@property (nonatomic, strong) UIImage     *placeImg;


@end




@implementation AntiqueListCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 10 + ((kScreenWidth - 30)/2)*0.667 + 30
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        self.picView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, self.width-20, (self.width-20)*0.667)];
        [self.contentView addSubview:_picView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_picView.originalX, _picView.maxY, _picView.width, 30)];
        _titleLabel.textColor = kDeepLabelColor;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = FontYT(14);
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:_titleLabel];
        
        self.placeImg = [UIToolClass getPlaceholderWithViewSize:_picView.viewSize centerSize:CGSizeMake(26, 26) isBorder:YES];
    }
    return self;
}

- (void)setModel:(AntiqueModel *)model forIndexPath:(NSIndexPath *)indexPath
{
    if ([model isKindOfClass:[AntiqueModel class]]) {
        
        [_picView sd_setImageWithURL:[NSURL URLWithString:JointedImageURL(model.antiqueImageUrl, kImageSize_300_300)] placeholderImage:_placeImg];
        
        _titleLabel.text = model.antiqueName;
    }
}

@end
