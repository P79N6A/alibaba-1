//
//  PersonalSettingCell.m
//  CultureHongshan
//
//  Created by JackAndney on 16/4/17.
//  Copyright © 2016年 CT. All rights reserved.
//

#import "PersonalSettingCell.h"

#import "UIImage+Extensions.h"

@interface PersonalSettingCell ()
{
    UILabel *_leftLabel;
    UILabel *_rightLabel;
    UIImageView *_headImgView;
    UIImageView *_accessoryView;
    
    UIView *_lineView;
}

@property (nonatomic, strong) PersonalSettingModel *model;


@end



@implementation PersonalSettingCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        _leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 0, 35)];
        _leftLabel.textColor = kDeepLabelColor;
        _leftLabel.font = FONT(16);
        [self.contentView addSubview:_leftLabel];
        
        _rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 35)];
        _rightLabel.textColor = kLightLabelColor;
        _rightLabel.font = FONT(16);
        _rightLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_rightLabel];
        
        _accessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-20-10, 0, 20, 20)];
        _accessoryView.image = IMG(@"icon_arrow_right_gray");
        [self.contentView addSubview:_accessoryView];
        
        MYMaskView *containerView = [MYMaskView maskViewWithImage:IMG(@"icon_head_bg") frame:CGRectMake(_accessoryView.originalX - 78 - 15, 0, 78, 78) radius:0];
        [self.contentView addSubview:containerView];
        
        _headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 70, 70)];
        _headImgView.centerX = containerView.width/2;
        _headImgView.centerY = containerView.height/2;
        [containerView addSubview:_headImgView];
        
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
        _lineView.backgroundColor = kBgColor;
        [self.contentView addSubview:_lineView];
    }
    return self;
}

-(void)hiddenIndicatorArrow
{
    _accessoryView.hidden = YES;
    _rightLabel.frame = MRECT(_rightLabel.frame.origin.x + 30, _rightLabel.frame.origin.y, _rightLabel.frame.size.width, _rightLabel.frame.size.height);
}

- (void)setModel:(PersonalSettingModel *)model forIndexPath:(NSIndexPath *)indexPath
{
    if (model == nil || ![model isKindOfClass:[PersonalSettingModel class]]) {
        return;
    }
    if (_model) {
        _model = nil;
    }
    _model = model;
    
    _leftLabel.text = _model.leftTitle;
    _leftLabel.width = [UIToolClass textWidth:_leftLabel.text font:_leftLabel.font];
    
    _rightLabel.text = _model.rightTitle;
    _rightLabel.originalX = _leftLabel.maxX + 20;
    _rightLabel.width = _headImgView.superview.maxX - _rightLabel.originalX;
    
    
    //图片
    if (indexPath.row == 0 && indexPath.section == 0) {
        _headImgView.superview.hidden = NO;
        _rightLabel.hidden = YES;
        WEAK_VIEW(_headImgView)
        [_headImgView sd_setImageWithURL:[NSURL URLWithString:_model.imageUrl] placeholderImage:[IMG(@"sh_user_header_icon") circleImage] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
                weakView.image = [image circleImage];
            }
        }];
    }else {
        _headImgView.superview.hidden = YES;
        _headImgView.image = nil;
        _rightLabel.hidden = NO;
    }
    
    //手机号
    if (indexPath.row == 2 && indexPath.section ==1){
        LoginType type = [UserService sharedService].loginType;
        _accessoryView.hidden =  (type == LoginTypeWenHuaYun || type == LoginTypeWenHuaYunDynamic);
    }
    
    //密码
    if (indexPath.row == 1 && indexPath.section == 2) {
        if ([_rightLabel.text isEqualToString:@"修改"]) {
            _accessoryView.hidden = NO;
        }else{
            _accessoryView.hidden = YES;
        }
    }else{
        _accessoryView.hidden = NO;
    }
    
    _lineView.originalY = self.height - 1;
    if (indexPath.section == 0) {
        _lineView.originalX = 0;
    }else if (indexPath.section == 1){
        _lineView.originalX = 10;
    }else{
        _lineView.originalX = 30;
    }
    
    //调整高度方向的位置
    _leftLabel.centerY = _rightLabel.centerY = _headImgView.superview.centerY = _accessoryView.centerY = self.height*0.5;
}

@end
