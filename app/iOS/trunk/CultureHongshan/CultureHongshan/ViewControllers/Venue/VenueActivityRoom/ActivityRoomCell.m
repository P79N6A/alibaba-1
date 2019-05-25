//
//  ActivityRoomCell.m
//  CultureHongshan
//
//  Created by one on 15/11/10.
//  Copyright © 2015年 CT. All rights reserved.
//

#import "ActivityRoomCell.h"

#import "ActivityRoomModel.h"


@interface ActivityRoomCell ()

@property (nonatomic, strong) UIImageView *picView;//图片
@property (nonatomic, strong) UILabel *titleLabel;//标题
@property (nonatomic, strong) UILabel *addressLabel;//地址
@property (nonatomic, strong) UIView *tagContainerView;//标签容器
@property (nonatomic, strong) UILabel *areaAndCapacityLabel;//面积与客容量

@end





@implementation ActivityRoomCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = kBgColor;
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 6, kScreenWidth, 100)];
        bgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:bgView];
        
        CGFloat fontHeight = 0;
        CGFloat spacing = 7;
        CGFloat picHeight = bgView.height-2*spacing;
        CGFloat picWidth = picHeight*1.5;
        
        //图片
        _picView = [[UIImageView alloc] initWithFrame: CGRectMake(spacing, spacing, picWidth, picHeight)];
        [bgView addSubview:_picView];
        
        //名称
        fontHeight = [UIToolClass fontHeight:FontYT(17)];
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_picView.maxX+10, _picView.originalY, bgView.width-10-_picView.maxX-10,fontHeight)];
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _titleLabel.textColor = [UIToolClass colorFromHex:@"262626"];
        _titleLabel.font = FontYT(17);
        [bgView addSubview:_titleLabel];
        
        UIImageView *locationView = [[UIImageView alloc] initWithFrame:CGRectMake(_titleLabel.originalX, _titleLabel.maxY+5, 12, 16)];
        locationView.image = IMG(@"icon_mapon");
        [bgView addSubview:locationView];
        
        //地址
        fontHeight = [UIToolClass fontHeight:FontYT(15)];
        _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(locationView.maxX+4, 0, _titleLabel.maxX-locationView.maxX-4, fontHeight)];
        _addressLabel.font = FontYT(15);
        _addressLabel.textColor = [UIToolClass colorFromHex:@"808080"];
        [bgView addSubview:_addressLabel];
        _addressLabel.centerY = locationView.centerY;
        
        //标签容器视图
        _tagContainerView = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.originalX, _addressLabel.maxY+6, _titleLabel.width, 18)];
        [bgView addSubview:_tagContainerView];
        
        //面积与客容量
        _areaAndCapacityLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.originalX, _tagContainerView.maxY+10, _titleLabel.width, fontHeight)];
        _areaAndCapacityLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _areaAndCapacityLabel.font = _addressLabel.font;
        _areaAndCapacityLabel.textColor = _titleLabel.textColor;
        [bgView addSubview:_areaAndCapacityLabel];
    }
    
    return self;
}


- (void)setModel:(ActivityRoomModel *)model forIndexPath:(NSIndexPath *)indexPath
{
    if ([model isKindOfClass:[ActivityRoomModel class]] && model)
    {
        //图片
        UIImage *placeImg = [UIToolClass getPlaceholderWithViewSize:_picView.viewSize centerSize:CGSizeMake(30, 30) isBorder:NO];
        [_picView sd_setImageWithURL:[NSURL URLWithString:JointedImageURL(model.roomPicUrl,kImageSize_300_300)] placeholderImage:placeImg];
        
        //名称
        _titleLabel.text = model.roomName;
        
        //地址
        _addressLabel.text = model.roomAddress;
        
        //标签
        [_tagContainerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        if (model.roomTagArray.count) {
            _areaAndCapacityLabel.originalY = _tagContainerView.maxY + 10;
            
            CGFloat offsetX = 0;
            CGFloat tagWidth = 0;
            UIFont *font = _addressLabel.font;
            for (int i = 0; i < model.roomTagArray.count; i++) {
                NSString *tagName = model.roomTagArray[i];
                if (tagName.length) {
                    tagWidth = [UIToolClass textWidth:tagName font:font] + 10;
                    if (offsetX + tagWidth > _tagContainerView.width) {
                        break;
                    }
                    
                    UILabel *tagLabel = [[UILabel alloc] initWithFrame:CGRectMake(offsetX, 0, tagWidth, _tagContainerView.height)];
                    tagLabel.layer.borderColor = [UIToolClass colorFromHex:@"343434"].CGColor;
                    tagLabel.layer.borderWidth = 0.7;
                    tagLabel.radius = 3;
                    tagLabel.backgroundColor = kBgColor;
                    tagLabel.textColor = [UIToolClass colorFromHex:@"808080"];
                    tagLabel.textAlignment = NSTextAlignmentCenter;
                    tagLabel.text = tagName;
                    [_tagContainerView addSubview:tagLabel];
                    
                    offsetX += tagWidth + 5;
                }
            }
            
        }else{
            _areaAndCapacityLabel.originalY = _tagContainerView.centerY;
        }
        
        //面积与客容量
        _areaAndCapacityLabel.text = [NSString stringWithFormat:@"面积：%@m²    人数：%@人",model.roomArea, model.roomCapacity];
    }
}




@end
