//
//  CollectCell.m
//  CultureHongshan
//
//  Created by ct on 16/4/12.
//  Copyright © 2016年 CT. All rights reserved.
//

#import "CollectCell.h"


#import "UIImageView+WebCache.h"

@interface CollectCell ()
{
    //图片
    UIImageView *_picView;
    
    //标题
    UILabel *_titleLabel;
    
    //日期
    UILabel *_dateLabel;
    
    //地图小图标
    UIImageView *_locationImgView;
    
    //地址：南京西路456号
    UILabel *_addressLabel;
    
    NSInteger _cellType;
}

@property (nonatomic, assign) CGFloat cellHeight;


@end





@implementation CollectCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        _cellHeight = 100;
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        CGFloat edge = 7.5;
        
        //图片
        _picView = [[UIImageView alloc] initWithFrame:CGRectMake(edge, edge, (_cellHeight-2*edge)*1.5, _cellHeight-2*edge)];
        [self.contentView addSubview:_picView];
        
        //标题
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_picView.maxX+10, _picView.originalY, kScreenWidth-_picView.maxX-10-edge, [UIToolClass fontHeight:FONT(15)])];
        _titleLabel.font = FONT(15);
        _titleLabel.textColor = kDeepLabelColor;
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:_titleLabel];
        
        //日期
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.originalX, _titleLabel.maxY + 8, _titleLabel.width, [UIToolClass fontHeight:FONT(13)])];
        _dateLabel.font = FONT(13);
        _dateLabel.textColor = kLightLabelColor;
        [self.contentView addSubview:_dateLabel];
        
        
        //地图小图标
        _locationImgView = [[UIImageView alloc] initWithFrame:CGRectMake(_titleLabel.originalX, 0, 10, 15)];
        _locationImgView.image = IMG(@"icon_address");
        [self.contentView addSubview:_locationImgView];
        
        //地址
        _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(_locationImgView.maxX+5, _dateLabel.maxY + 16, _titleLabel.maxX-_locationImgView.maxX-5, [UIToolClass fontHeight:FONT(13)])];
        _addressLabel.textColor = _dateLabel.textColor;
        _addressLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _addressLabel.font = _dateLabel.font;
        [self.contentView addSubview:_addressLabel];
        
        _locationImgView.centerY = _addressLabel.centerY;
    }
    
    return self;
}



- (void)setModel:(UserCollectModel *)model forIndexPath:(NSIndexPath *)indexPath
{
    if (!model || !([model isKindOfClass:[UserCollectModel class]]))
    {
        FBLOG(@"Model数据不对");
        return;
    }
    
    if (_model)
    {
        _model = nil;
    }
    _model = model;
    _cellType = _model.type;
    
    
    NSString *imageUrl = _model.imageUrl;
    NSString *title = _model.titleStr;
    NSString *dateString = _model.dateStr;
    NSString *addressString = _model.addressStr;
    
    //图片
    UIImage *placeImg = [UIToolClass getPlaceholderWithViewSize:_picView.viewSize centerSize:CGSizeMake(20, 20) isBorder:NO];
    [_picView sd_setImageWithURL:[NSURL URLWithString:JointedImageURL(imageUrl, @"_150_100")] placeholderImage:placeImg];
    
    //标题
    _titleLabel.text = title;
    
    //日期
    _dateLabel.text = dateString;
    _dateLabel.hidden = (_cellType == 1) ? NO : YES;//只有活动的显示日期
    
    //地址
    _addressLabel.text = addressString;
    _addressLabel.originalY = (_cellType == 1) ? _dateLabel.maxY + 15 : _dateLabel.maxY;
    _locationImgView.centerY = _addressLabel.centerY;
}


#pragma mark - Getting Methods

- (NSInteger)type
{
    return _cellType;
}

@end
