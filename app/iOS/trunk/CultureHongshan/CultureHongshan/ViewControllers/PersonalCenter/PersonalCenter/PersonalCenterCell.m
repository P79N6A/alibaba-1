//
//  PersonalCenterCell.m
//  CultureHongshan
//
//  Created by ct on 16/5/26.
//  Copyright © 2016年 CT. All rights reserved.
//

#import "PersonalCenterCell.h"

#import "PersonalSettingModel.h"



@interface PersonalCenterCell ()

@property (nonatomic,strong) UILabel *leftLabel;
@property (nonatomic,strong) UILabel *rightLabel;
@property (nonatomic,strong) UIImageView *rightImgView;
@property (nonatomic,strong) MYMaskView *lineView;

@end


@implementation PersonalCenterCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        CGFloat cellHeight = 50;
        CGFloat leftWidth = [UIToolClass textWidth:[NSString stringWithFormat:@"关于%@", APP_SHOW_NAME] font:FontYT(15)]+1;
        
        self.leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(28, 0, leftWidth, cellHeight)];
        _leftLabel.textColor = kDeepLabelColor;
        _leftLabel.font = FontYT(15);
        [self.contentView addSubview:_leftLabel];
        
        self.rightImgView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-20-10, 0, 20, 20)];
        _rightImgView.image = IMG(@"icon_arrow_right_gray");
        [self.contentView addSubview:_rightImgView];
        _rightImgView.centerY = _leftLabel.centerY;
        
        self.rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(_leftLabel.maxX+10, 0, _rightImgView.originalX-7-_leftLabel.maxX-10, cellHeight)];
        _rightLabel.textColor = ColorFromHex(@"999999");
        _rightLabel.font = FontYT(13);
        _rightLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_rightLabel];
        
        self.lineView = [MYMaskView maskViewWithBgColor:RGB(226, 226, 226) frame:CGRectMake(0, cellHeight-0.8, kScreenWidth, 0.8) radius:0];
        [self.contentView addSubview:_lineView];
    }
    return self;
}


- (void)setModel:(PersonalSettingModel *)model lineOffset:(CGFloat)offset
{
    _lineView.originalX = offset;
    
    _leftLabel.text = model.leftTitle;
    _rightLabel.text = model.rightTitle.length ? model.rightTitle : @"";
}


@end
