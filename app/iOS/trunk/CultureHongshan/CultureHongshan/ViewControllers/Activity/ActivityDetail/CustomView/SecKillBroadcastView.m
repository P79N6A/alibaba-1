//
//  SecKillBroadcastView.m
//  CultureHongshan
//
//  Created by ct on 16/5/31.
//  Copyright © 2016年 CT. All rights reserved.
//

#import "SecKillBroadcastView.h"



#import "SecKillModel.h"

@implementation SecKillBroadcastView

- (id)initWithFrame:(CGRect)frame
              title:(NSString *)title
             notice:(NSString *)notice
         modelArray:(NSArray *)modelArray
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor whiteColor];
        if (notice.length < 1 || [notice hasPrefix:@"|"]){
            notice = @"  ";
        }
        if ([notice rangeOfString:@"|"].location != NSNotFound) {
            notice = [[notice componentsSeparatedByString:@"|"] firstObject];
        }
        
        //标题
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 0, 0)];
        titleLabel.font = FontYT(18);
        titleLabel.textColor = kDeepLabelColor;
        titleLabel.text = title;
        titleLabel.width = [UIToolClass textWidth:title font:titleLabel.font];
        [self addSubview:titleLabel];
        //提示信息
        UILabel *noticeLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.maxX+15, 23, kScreenWidth-10-titleLabel.maxX-15, 0)];
        noticeLabel.numberOfLines = 0;
        NSMutableAttributedString *attributedString = (NSMutableAttributedString *)[UIToolClass getAttributedStr:notice font:FontYT(13) lineSpacing:4 alignment:NSTextAlignmentRight];
        [attributedString addAttribute:NSForegroundColorAttributeName value:kDeepLabelColor range:NSMakeRange(0, notice.length)];
        
        NSArray *rangeArray = [ToolClass getDigitalNumberRanges:notice];
        for (NSValue *rangeValue in rangeArray) {
            [attributedString addAttribute:NSForegroundColorAttributeName value:kDarkRedColor range:rangeValue.rangeValue];
        }
        noticeLabel.attributedText = attributedString;
        noticeLabel.height = [UIToolClass attributedTextHeight:noticeLabel.attributedText width:noticeLabel.width];
        [self addSubview:noticeLabel];
        
        titleLabel.height = noticeLabel.maxY + 20;
        
        //播报信息
        if (modelArray.count) {
            
            CGFloat rightMaskWidth = ConvertSize(190);
            CGFloat leftMaskWidth = kScreenWidth-20-1-rightMaskWidth;
            CGFloat offsetY = titleLabel.maxY;
            
            CGFloat rightSpacing = (kScreenWidth < 321) ? 16 : 25;
            
            CGFloat ticketLabelWidth = [UIToolClass textWidth:[NSString stringWithFormat:@"%d张",[self getMaxTicketCount:modelArray]] font:FontYT(14)]+4;
            
            for (int i = 0; i < modelArray.count; i++) {
                SecKillModel *model = modelArray[i];
                
                UIColor *bgColor = nil;
                UIColor *textColor = nil;
                NSString *imageName = nil;
                [self setBgColor:&bgColor textColor:&textColor imgName:&imageName status:model.status];
                
                MYMaskView *leftMask = [MYMaskView maskViewWithBgColor:bgColor frame:CGRectMake(10, offsetY, leftMaskWidth, 40) radius:0];
                [self addSubview:leftMask];
                
                MYMaskView *rightMask = [MYMaskView maskViewWithBgColor:bgColor frame:CGRectMake(leftMask.maxX+1, leftMask.originalY, rightMaskWidth, leftMask.height) radius:0];
                [self addSubview:rightMask];
                
                //时钟图片
                UIImageView *clockImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 14, 14)];
                clockImgView.image = IMG(imageName);
                [leftMask addSubview:clockImgView];
                clockImgView.centerY = leftMask.height*0.5;
                
                //日期
                UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(clockImgView.maxX+15, 0, 0, leftMask.height)];
                dateLabel.font = FontYT(14);
                dateLabel.textColor = textColor;
                dateLabel.text = model.dateStr;
                [leftMask addSubview:dateLabel];
                dateLabel.width = [UIToolClass textWidth:dateLabel.text font:dateLabel.font];
                
                //时间点
                UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(dateLabel.maxX, 0, 0, leftMask.height)];
                timeLabel.font = dateLabel.font;
                timeLabel.textColor = textColor;
                timeLabel.textAlignment = NSTextAlignmentCenter;
                timeLabel.text = model.timeStr;
                [leftMask addSubview:timeLabel];
                
                //票数
                UILabel *ticketCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, leftMask.height)];
                ticketCountLabel.font = dateLabel.font;
                ticketCountLabel.textColor = textColor;
                ticketCountLabel.textAlignment = NSTextAlignmentRight;
                ticketCountLabel.text = [NSString stringWithFormat:@"%d张",model.ticketCount];
                [leftMask addSubview:ticketCountLabel];
                ticketCountLabel.width = [UIToolClass textWidth:ticketCountLabel.text font:ticketCountLabel.font];
                ticketCountLabel.originalX = leftMask.width-rightSpacing-ticketCountLabel.width;
                
                timeLabel.width = ticketCountLabel.maxX-ticketLabelWidth-timeLabel.originalX;//调整时间点Label的宽度
                
                //秒杀状态
                UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 0, rightMask.height)];
                statusLabel.font = dateLabel.font;
                statusLabel.textColor = dateLabel.textColor;
                statusLabel.text = model.showedStatus;
                [rightMask addSubview:statusLabel];
                statusLabel.width = [UIToolClass textWidth:statusLabel.text font:statusLabel.font];
                
                offsetY = leftMask.maxY + 1;
                
                if (i == modelArray.count-1) {
                    self.height = offsetY+35;
                }
            }
        }else{
            self.height = titleLabel.maxY;
        }
    }
    return self;
}


- (void)setBgColor:(UIColor **)bgColor textColor:(UIColor **)textColor imgName:(NSString **)imgName status:(NSInteger)status
{
    // 秒杀的状态：1-已结束， 2-正在秒杀， 3-即将开始，  4-未开始
    if (status == 1) {//已结束
        *bgColor = [UIToolClass colorFromHex:@"F2F2F2"];
        *textColor = [UIToolClass colorFromHex:@"B2B2B2"];
        *imgName = @"icon_clock_gray";
    } else if (status == 2) {//正在秒杀
        *bgColor = [UIToolClass colorFromHex:@"C05459"];
        *textColor = [UIColor whiteColor];
        *imgName = @"icon_clock_white";
    } else if (status == 3) {//即将开始
        *bgColor = [UIToolClass colorFromHex:@"7279A0"];
        *textColor = [UIColor whiteColor];
        *imgName = @"icon_clock_white";
    } else {//未开始
        *bgColor = [UIToolClass colorFromHex:@"DDE0F2"];
        *textColor = [UIToolClass colorFromHex:@"262626"];
        *imgName = @"icon_clock_black";
    }
}


- (int)getMaxTicketCount:(NSArray *)modelArray
{
    int count = 0;
    for (SecKillModel *model in modelArray) {
        if (model.ticketCount > count) {
            count = model.ticketCount;
        }
    }
    return count;
}


@end
