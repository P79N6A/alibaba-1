//
//  VenueListCell.m
//  CultureHongshan
//
//  Created by JackAndney on 16/7/24.
//  Copyright © 2016年 ct. All rights reserved.
//

#import "VenueListCell.h"

#import "VenueModel.h"

@interface VenueListCell ()
{
    UIImageView *_picView;
    UILabel *_titleLabel;
    UIImageView *_locationImgView;
    UILabel *_addressLabel;
    UIView *_containerView;
    
    UIView *_bgPositionView;
}

@end



@implementation VenueListCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = kBgColor;
        
        
        _picView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth*kPicScale_ListCover)];
        [self.contentView addSubview:_picView];
        
        MYMaskView *maskView = [MYMaskView maskViewWithBgColor:[UIColor colorWithWhite:0 alpha:0.4] frame:_picView.bounds radius:0];
        [_picView addSubview:maskView];
        
        _bgPositionView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, kScreenWidth-40, 0)];
        [_picView addSubview:_bgPositionView];
        
        CGFloat fontHeight = [UIToolClass fontHeight:FontYTBold(20)];
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _bgPositionView.width, fontHeight)];
        _titleLabel.font = FontYTBold(18);
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [_bgPositionView addSubview:_titleLabel];
        
        MYMaskView *lineView = [MYMaskView maskViewWithBgColor:[UIColor whiteColor] frame:CGRectMake(0, _titleLabel.maxY+6, kScreenWidth*0.63, 0.8) radius:0];
        [_bgPositionView addSubview:lineView];
        lineView.centerX = _bgPositionView.width*0.5;
        
        _locationImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, lineView.maxY+6, 11, 15)];
        _locationImgView.image = IMG(@"sh_icon_location_white");
        [_bgPositionView addSubview:_locationImgView];
        
        fontHeight = [UIToolClass fontHeight:FontYT(14)];
        _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, fontHeight)];
        _addressLabel.textColor = [UIColor whiteColor];
        _addressLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _addressLabel.font = FontYT(14);
        [_bgPositionView addSubview:_addressLabel];
        _addressLabel.centerY = _locationImgView.centerY;
        
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, _addressLabel.maxY+9, _bgPositionView.width, 22)];
        [_bgPositionView addSubview:_containerView];
        
        _bgPositionView.height = _containerView.maxY;
        _bgPositionView.originalY = (_picView.height - _bgPositionView.height)*0.5;
    }
    return self;
}


- (void)setModel:(VenueModel *)model forIndexPath:(NSIndexPath *)indexPath
{
    if (!model || model.venueName.length < 1) {
        return;
    }
    
    
    //图片
    UIImage *placeImg = [UIToolClass getPlaceholderWithViewSize:_picView.viewSize centerSize:CGSizeMake(30, 30) isBorder:NO];
    [_picView sd_setImageWithURL:[NSURL URLWithString:JointedImageURL(model.venueIconUrl,kImageSize_750_500)] placeholderImage:placeImg];
    
    
    _titleLabel.attributedText = [UIToolClass boldString:model.venueName font:_titleLabel.font lineSpacing:4 alignment:_titleLabel.textAlignment];
    
    
    _addressLabel.text = model.venueAddress;
    CGFloat textWidth = [UIToolClass textWidth:model.venueAddress font:_addressLabel.font];
    if (textWidth + 3 + _locationImgView.width > _bgPositionView.width) {
        _locationImgView.originalX = 0;
        _addressLabel.originalX = _locationImgView.maxX+3;
        _addressLabel.width = _bgPositionView.width-_addressLabel.originalX;
    }else{
        _locationImgView.originalX = (_bgPositionView.width-textWidth-3-_locationImgView.width)*0.5;
        _addressLabel.originalX = _locationImgView.maxX+3;
        _addressLabel.width = textWidth;
    }
    
    [_containerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (model.venueRoomCount < 1 && model.venueOnlineActivityCount < 1) {//都不存在
        _containerView.width = 0;
        _bgPositionView.height = _addressLabel.maxY;
    }else{
        _bgPositionView.height = _containerView.maxY;
        if (model.venueRoomCount < 1 && model.venueOnlineActivityCount > 0){//只显示在线活动数
            NSString *str = [NSString stringWithFormat:@"%@个在线活动",StrFromLong(model.venueOnlineActivityCount)];
            UILabel *label = [self addLabelToContainerView:str];
            _containerView.width = label.width;
        }else if (model.venueRoomCount > 0 && model.venueOnlineActivityCount < 1){//只显示活动室数
            NSString *str = [NSString stringWithFormat:@"%@个活动室",StrFromLong(model.venueRoomCount)];
            UILabel *label = [self addLabelToContainerView:str];
            _containerView.width = label.width;
        }else {//两个都显示
            NSString *leftStr = [NSString stringWithFormat:@"%@个在线活动",StrFromLong(model.venueOnlineActivityCount)];
            UILabel *leftLabel = [self addLabelToContainerView:leftStr];
            NSString *rightStr = [NSString stringWithFormat:@"%@个活动室",StrFromLong(model.venueRoomCount)];
            UILabel *rightLabel = [self addLabelToContainerView:rightStr];
            
            rightLabel.originalX = leftLabel.maxX + 10;
            if (rightLabel.maxX > _bgPositionView.width) {
                [rightLabel removeFromSuperview];
                _containerView.width = leftLabel.width;
            }else{
                _containerView.width = rightLabel.maxX;
            }
        }
    }
    _containerView.originalX = (_bgPositionView.width - _containerView.width)*0.5;
    _bgPositionView.originalY = (_picView.height-_bgPositionView.height)*0.5;
}


- (UILabel *)addLabelToContainerView:(NSString *)title
{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:kOrangeYellowColor range:NSMakeRange(0, [title rangeOfString:@"个"].location)];
    
    CGFloat textWidth = MIN([UIToolClass textWidth:title font:_addressLabel.font]+20, _bgPositionView.width);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, textWidth, _containerView.height)];
    label.radius = 4;
    label.font = _addressLabel.font;
    label.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    label.textAlignment = NSTextAlignmentCenter;
    label.attributedText = attributedStr;
    [_containerView addSubview:label];
    
    return label;
}

- (UIImageView *)getImageView
{
    return _picView;
}

@end
