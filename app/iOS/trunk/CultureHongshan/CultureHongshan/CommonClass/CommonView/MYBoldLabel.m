//
//  MYBoldLabel.m
//  CultureHongshan
//
//  Created by ct on 16/8/26.
//  Copyright © 2016年 ct. All rights reserved.
//

#import "MYBoldLabel.h"

@implementation MYBoldLabel


- (void)setText:(NSString *)text
{
    self.numberOfLines = 0;
    
    if ([text isKindOfClass:[NSString class]] && text.length) {
        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
        paraStyle.lineSpacing = (_spacingOfLine > 0) ? _spacingOfLine : 4; // 遇到个奇怪的Bug，使用_lineSpacing会导致字体不显示
        paraStyle.alignment = self.textAlignment;
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:
                                                       @{NSFontAttributeName:self.font,
                                                         NSForegroundColorAttributeName : self.textColor,
                                                         NSParagraphStyleAttributeName:paraStyle,
                                                         NSStrokeWidthAttributeName:[NSNumber numberWithFloat:-1.9]
                                                         }];
        self.attributedText = attributedString;
        
        if (!_isAutoLayout) {
            self.height = [UIToolClass attributedTextHeight:attributedString width:self.width];
        }
    }else {
        self.attributedText = nil;
        self.height = 0;
    }
}

- (NSString *)text
{
    return self.attributedText.string;
}


@end
