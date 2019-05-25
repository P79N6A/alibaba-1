//
//  FBLabel.m
//  ParkTour
//
//  Created by 李 兴 on 15-4-13.
//  Copyright (c) 2015年 李 兴. All rights reserved.
//

#import "FBLabel.h"

@implementation FBLabel

-(id)initWithStyle:(CGRect)frame font:(UIFont *)font fcolor:(UIColor *)fcolor  text:(NSString *)text
{
    if (self = [super init])
    {
        self.frame = frame;
        self.font = font;
        self.text = text;
        self.textColor = fcolor;
        _lineSpace = 0;
        _heightOffset = 0;
        [self create];
        if (self.frame.size.height > textSize.height || self.frame.size.height == 0)
        {
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, textSize.height);
        }
    }
    return self;
}

-(id)initWithStyle:(CGRect)frame font:(UIFont *)font fcolor:(UIColor *)fcolor text:(NSString *)text linespace:(CGFloat)linespace
{
    if (self = [super init])
    {
        if (text == nil)
        {
            text = @"";
        }
        self.frame = frame;
        self.font = font;
        self.text = text;
        self.textColor = fcolor;
        _lineSpace = linespace;
//        _heightOffset = 2.5;
        _heightOffset = 0;
        [self create];
        
        NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:text];
        NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle1 setLineSpacing:linespace];
        [paragraphStyle1 setLineBreakMode:NSLineBreakByTruncatingTail];
        [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [text length])];
        [self setAttributedText:attributedString1];
        
        self.textHeight = self.textHeight + self.numberOfLines * (linespace + _heightOffset);
        self.showTextHeight = self.showTextHeight + self.numberOfLines * (linespace + _heightOffset);
        if (self.frame.size.height > textSize.height || self.frame.size.height == 0)
        {
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.textHeight);
        }
        else
        {
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.showTextHeight);
        }
    }
    return self;
    
    
}


-(void)create
{
    
    self.backgroundColor = [UIColor clearColor];
    
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.alignment = self.textAlignment;
    paraStyle.lineSpacing = _lineSpace;
    NSDictionary * attribute = @{NSFontAttributeName: self.font, NSParagraphStyleAttributeName: paraStyle};
    NSInteger options =  NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading ;
    textSize = [self.text boundingRectWithSize:CGSizeMake(self.frame.size.width,0) options:options attributes:attribute context:nil].size;
    
    
    self.textWidth = textSize.width;
    self.textHeight = textSize.height;
    
    CGFloat fontHeight = self.font.xHeight;
    NSInteger lines = 0;
    if (self.frame.size.height < self.textHeight && self.frame.size.height > 0)
    {//如果高度小于给定的值
        self.showTextHeight = self.frame.size.height;
    }
    else
    {
        self.showTextHeight = self.textHeight;
    }
    if (self.frame.size.height > textSize.height || self.frame.size.height == 0)
    {
        lines = textSize.height/(fontHeight + _lineSpace);
    }
    else
    {
        lines = self.frame.size.height/(fontHeight + _lineSpace + _heightOffset);
    }
    self.numberOfLines = lines;
    
}


- (void)layoutSubviews
{
    [super layoutSubviews];
}


@end
