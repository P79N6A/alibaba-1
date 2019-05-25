//
//  ActivityDetailActivityUnitCell.m
//  CultureHongshan
//
//  Created by ct on 16/4/18.
//  Copyright © 2016年 CT. All rights reserved.
//

#import "ActivityDetailActivityUnitCell.h"

@implementation ActivityDetailActivityUnitCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setDataArray:(NSArray *)dataArray forIndexPath:(NSIndexPath *)indexPath
{
    if (dataArray.count)
    {
        //移除之前的视图
        [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        CGFloat leftSpacing = 10;
        CGFloat lineSpacing = 10;
        CGFloat offsetY = 27; // 22
//        CGFloat separateLinePosition = 0;// 分割线的位置
        
        CGFloat leftTextWidth = [UIToolClass textWidth:@"活动日期：" font:FONT(14)] + 2;

        CGFloat middleTextWidth = 0;
        
        CGFloat fontHeight = [UIToolClass fontHeight:FONT(14)];
        CGFloat textHeight = 0;
        
        
        for (int i = 0;  i < dataArray.count; i++)
        {
            NSArray *array = dataArray[i];
            
            NSString *leftTitle = array[0];
            NSString *rightTitle = array[1];
            
            if (rightTitle.length)
            {
                if (array.count > 2 && [array[3] length] > 0) {
                    middleTextWidth = kScreenWidth - leftSpacing - leftTextWidth - 10 - 18.5; // 右侧的箭头图标
                }else {
                    middleTextWidth = kScreenWidth - leftSpacing - leftTextWidth - 10;
                }
                
                textHeight = [UIToolClass textHeight:rightTitle lineSpacing:4 font:FONT(14) width:middleTextWidth];
                
                //左侧
                UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftSpacing, offsetY, leftTextWidth, fontHeight)];
                leftLabel.textColor = kDeepLabelColor;
                leftLabel.text = leftTitle;
                leftLabel.font = FONT(14);
                [self.contentView addSubview:leftLabel];
                
                //右侧
                UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftSpacing+leftTextWidth, offsetY, middleTextWidth, textHeight)];
                rightLabel.numberOfLines = 0;
                rightLabel.lineBreakMode = NSLineBreakByTruncatingTail;
                rightLabel.font = leftLabel.font;
                rightLabel.textColor = leftLabel.textColor;
                rightLabel.attributedText = [UIToolClass getAttributedStr:rightTitle font:rightLabel.font lineSpacing:4];
                [self.contentView addSubview:rightLabel];
                
                MYMaskView *separetedLine = [MYMaskView maskViewWithBgColor:kLineGrayColor frame:CGRectMake(10, rightLabel.maxY+lineSpacing, kScreenWidth-20, kLineThick) radius:0];
                [self.contentView addSubview:separetedLine];
                
                offsetY = separetedLine.maxY+lineSpacing;
                
                if (array.count > 2) {
                    NSArray *unitTagArray = array[2];
                    NSString *activityUnitId = array[3];
                    
                    if (unitTagArray.count) {
                        rightLabel.textColor = kThemeLightColor;
                        
                        CGFloat offsetX = rightLabel.originalX;
                        CGFloat tagOffsetY = rightLabel.maxY+8;
                        CGFloat textWidth = 0;
                        CGFloat tagHeight = 18;
                        for (int j = 0; j < unitTagArray.count; j++) {
                            NSString *tagName = unitTagArray[j];
                            if (tagName.length) {
                                textWidth = MIN([UIToolClass textWidth:tagName font:FontYT(12)]+20, rightLabel.width);
                                
                                if (textWidth + offsetX > rightLabel.maxX) {
                                    offsetX = rightLabel.originalX;
                                    tagOffsetY += tagHeight+8;
                                }
                                
                                UILabel *tagLabel = [[UILabel alloc] initWithFrame:CGRectMake(offsetX, tagOffsetY, textWidth, tagHeight)];
                                tagLabel.radius = 4;
                                tagLabel.textColor = kDeepLabelColor;
                                tagLabel.text = tagName;
                                tagLabel.textAlignment = NSTextAlignmentCenter;
                                tagLabel.font = FontYT(12);
                                tagLabel.layer.borderColor = COLOR_IBLACK.CGColor;
                                tagLabel.layer.borderWidth = 0.6;
                                [self.contentView addSubview:tagLabel];
                                
                                offsetX += textWidth + 5;
                            }
                            
                            if (j == unitTagArray.count-1) {
                                separetedLine.originalY = tagOffsetY + tagHeight + lineSpacing;
                                offsetY = separetedLine.maxY+lineSpacing;
                            }
                        }
                    }
                    if (activityUnitId.length) {
                        
                        UIImageView *arrowImg = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-20-8.5, 0, 8.5, 14.5)];
                        arrowImg.image = IMG(@"arrow_right");
                        [self.contentView addSubview:arrowImg];
                        arrowImg.centerY = leftLabel.centerY;
                        
                        WS(weakSelf);
                        FBButton *button = [[FBButton alloc] initWithImage:CGRectMake(0, leftLabel.originalY-10, kScreenWidth, separetedLine.originalY-(leftLabel.originalY-10)) bgcolor:nil img:nil clickEvent:^(FBButton *owner) {
                            if (weakSelf.block) {
                                weakSelf.block([NSString stringWithFormat:@"%@",activityUnitId]);
                            }
                        }];
                        button.animation = NO;
                        [self.contentView addSubview:button];
                    }
                }
                
                //移除最后一行的分割线
                if (i == dataArray.count-1) {
                    [separetedLine removeFromSuperview];
                    separetedLine = nil;
                }
            }
        }
    }
}


@end
