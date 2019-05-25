//
//  AccumulativeScoreCell.m
//  CultureHongshan
//
//  Created by ct on 16/5/27.
//  Copyright © 2016年 CT. All rights reserved.
//

#import "AccumulativeScoreCell.h"
#import "UserAccumulativeScoreModel.h"


@interface AccumulativeScoreCell ()
{
    UILabel *_typeLabel;//积分的类型:登录、注册、违规等
    UILabel *_descriptionLabel;//积分获取来源的描述
    UILabel *_scoreLabel;//积分值
    UILabel *_dateLabel;//日期
    MYMaskView *_lineView;
}

@end

@implementation AccumulativeScoreCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        // cellHeight = 66
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        CGFloat fontHeight = [UIToolClass fontHeight:FontYT(15)];
        CGFloat rightWidth = [UIToolClass textWidth:@"2015-02-12" font:FontYT(12)]+5;
        
        //积分的类型
        _typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, 17.5, kScreenWidth-2*18-rightWidth-10, fontHeight)];
        _typeLabel.font = FontYT(15);
        _typeLabel.textColor = [UIToolClass colorFromHex:@"262626"];
        [self.contentView addSubview:_typeLabel];
        
        //积分来源的描述
        fontHeight = [UIToolClass fontHeight:FontYT(12)];
        _descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(_typeLabel.originalX, _typeLabel.maxY+8, _typeLabel.width, fontHeight)];
        _descriptionLabel.font = FontYT(12);
        _descriptionLabel.textColor = [UIToolClass colorFromHex:@"999999"];
        [self.contentView addSubview:_descriptionLabel];
        
        //积分值
        _scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-18-rightWidth, _typeLabel.originalY, rightWidth, _typeLabel.height)];
        _scoreLabel.font = _typeLabel.font;
        _scoreLabel.textColor = _typeLabel.textColor;
        [self.contentView addSubview:_scoreLabel];
        
        //日期
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(_scoreLabel.originalX, _descriptionLabel.originalY, rightWidth, _descriptionLabel.height)];
        _dateLabel.font = _descriptionLabel.font;
        _dateLabel.textColor = _descriptionLabel.textColor;
        [self.contentView addSubview:_dateLabel];
        
        //分割线
        _lineView = [MYMaskView maskViewWithBgColor:kBgColor frame:CGRectMake(8, 66-1, kScreenWidth-2*8, 1) radius:0];
        [self.contentView addSubview:_lineView];
    }
    return self;
}



- (void)setModel:(UserAccumulativeScoreModel *)model isLineHiddden:(BOOL)isHidden
{
    _lineView.hidden = isHidden;
    
    _typeLabel.text = model.scoreType;
    _descriptionLabel.text = model.scoreDescription;
    _scoreLabel.text = model.scoreValue;
    _dateLabel.text = model.scoreDate;
    
    _scoreLabel.textColor = model.changeType == 1 ? kDeepLabelColor : kDarkRedColor;
}


@end
