//
//  ActivityDetailInfomationCell.m
//  CultureHongshan
//
//  Created by ct on 16/1/25.
//  Copyright © 2016年 CT. All rights reserved.
//

#import "ActivityDetailInfomationCell.h"

@interface ActivityDetailInfomationCell ()
{
    UIImageView *_leftImgView;
    UIImageView *_rightImgView;
    UILabel *_titleLabel;
    
    UIView *_lineView;
}

@end



@implementation ActivityDetailInfomationCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _leftImgView = [UIImageView new];
        _leftImgView.center = CGPointMake(18, 23);
        [self.contentView addSubview:_leftImgView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 10, kScreenWidth-80, 0)];
        _titleLabel.numberOfLines = 0;
        _titleLabel.font = FONT(15);
        [self.contentView addSubview:_titleLabel];
        
        
        _rightImgView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-10-15, 0, 8.5, 14.5)];
        _rightImgView.image = IMG(@"arrow_right");
        [self.contentView addSubview:_rightImgView];
        _rightImgView.centerY = _leftImgView.centerY;
        
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth-20, 0.5)];
        _lineView.backgroundColor = ColorFromHex(@"DFDFDF");
        [self.contentView addSubview:_lineView];
    }
    return self;
}



- (void)setDataArray:(NSArray *)dataArray forIndexPath:(NSIndexPath *)indexPath
{
    NSString *leftImageName = dataArray[0];
    UIImage *image = IMG(leftImageName);
    
    [_titleLabel.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    _leftImgView.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
    _rightImgView.hidden = (indexPath.row != 1);
    
    _leftImgView.image = image;
    _titleLabel.originalY = _leftImgView.centerY - [UIToolClass fontHeight:FONT(15)]*0.5;
    
    if ([dataArray[1] isKindOfClass:[NSString class]]) {
        NSString *title = dataArray[1];
        _titleLabel.attributedText = [UIToolClass getAttributedStr:title font:_titleLabel.font lineSpacing:4];
        _titleLabel.height = [UIToolClass textHeight:title lineSpacing:4 font:_titleLabel.font width:_titleLabel.width];
        
        _titleLabel.textColor = (indexPath.row == 4) ? kThemeDeepColor : kDeepLabelColor;
    }else{//时间段数组
        
        NSArray *timeArray = dataArray[1];

        if (timeArray.count < 1) {
            _titleLabel.text = @"无活动时间段信息";
            _titleLabel.textColor = kDeepLabelColor;
            _titleLabel.height = [UIToolClass textHeight:_titleLabel.text font:_titleLabel.font width:_titleLabel.width];
        }else{
            if (timeArray.count == 1 && [[timeArray lastObject] hasPrefix:@"|"] ) {//只有时间备注
                _titleLabel.text = @"";
                NSString *timeDes = [[timeArray lastObject] substringFromIndex:1];
                
                UILabel *timeDesLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _titleLabel.width+25, 0)];
                timeDesLabel.numberOfLines = 0;
                timeDesLabel.backgroundColor = [UIColor greenColor];
                timeDesLabel.font = _titleLabel.font;
                timeDesLabel.textColor = kDeepLabelColor;
                timeDesLabel.attributedText = [UIToolClass getAttributedStr:timeDes font:timeDesLabel.font lineSpacing:4];
                timeDesLabel.height = [UIToolClass textHeight:timeDes lineSpacing:4 font:timeDesLabel.font width:timeDesLabel.width];
                [_titleLabel addSubview:timeDesLabel];
            }else
            {
                _titleLabel.text = @"";
                
                CGFloat textWidth = 0;
                CGFloat fontHeight = [UIToolClass fontHeight:_titleLabel.font];
                
                CGFloat offsetX = 0;
                CGFloat offsetY = 0;
                CGFloat spacingX = 10;
                CGFloat spacingY = 7;
                
                for (int i = 0; i < timeArray.count; i++)
                {
                    NSString *timeStr = timeArray[i];
                    
                    if (i == timeArray.count-1 && [timeStr hasPrefix:@"|"]){//时间备注
                        timeStr = [timeStr substringFromIndex:1];
                        offsetX = 0;
                        offsetY += fontHeight + spacingY;
                        
                        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(offsetX, offsetY, _titleLabel.width+25, 0)];
                        titleLabel.numberOfLines = 0;
                        titleLabel.attributedText = [UIToolClass getAttributedStr:timeStr font:_titleLabel.font lineSpacing:4];
                        titleLabel.textColor = kDeepLabelColor;
                        [_titleLabel addSubview:titleLabel];
                        titleLabel.height = [UIToolClass attributedTextHeight:titleLabel.attributedText width:titleLabel.width];
                    }else{
                        textWidth = [UIToolClass textWidth:timeStr font:_titleLabel.font];
                        
                        if (offsetX + textWidth > _titleLabel.width+25) {
                            offsetX = 0;
                            offsetY += fontHeight + spacingY;
                        }
                        //标题
                        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(offsetX, offsetY, textWidth, fontHeight)];
                        titleLabel.font = _titleLabel.font;
                        titleLabel.text = timeStr;
                        titleLabel.textColor = kDeepLabelColor;
                        [_titleLabel addSubview:titleLabel];
                        
                        offsetX += textWidth + spacingX;
                    }
                }
            }
        }
    }
    
    _lineView.originalY = self.height-0.5;
}





@end
