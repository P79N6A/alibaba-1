//
//  SeatContentView.m
//  CultureHongshan
//
//  Created by ct on 17/2/24.
//  Copyright © 2017年 CT. All rights reserved.
//

#import "SeatContentView.h"

@interface SeatContentView ()
@property (nonatomic, strong) NSArray *seatArray;
@end

@implementation SeatContentView

- (instancetype)initWithFrame:(CGRect)frame seatArray:(NSArray<NSString *> *)seatArray font:(UIFont *)font tColor:(UIColor *)tColor {
    if (seatArray.count == 0) {
        return nil;
    }
    if (self = [super initWithFrame:frame]) {
        if (!font) font = FontYT(15);
        if (!tColor) tColor = RGB(117, 134, 181);
        
        for (NSString *seat in seatArray) {
            MYSmartLabel *seatLabel = [MYSmartLabel al_labelWithMaxRow:1 text:seat font:font color:tColor lineSpacing:0];
            [self addSubview:seatLabel];
        }
    }
    return self;
}

- (void)layoutSubviews {
    UIView *preView = nil;
    WS(weakSelf)
    CGFloat textWidth = 0;
    for (UILabel *seatLabel in self.subviews) {
        if ([seatLabel isKindOfClass:[UILabel class]]) {
            
            textWidth = [UIToolClass textWidth:seatLabel.text font:seatLabel.font];
            
            if (preView && preView.maxX + 10 + textWidth > self.width) {
                // 换行
                [seatLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(textWidth);
                    make.left.equalTo(weakSelf);
                    make.top.equalTo(preView.mas_bottom).offset(8);
                }];
            }else {
                [seatLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(textWidth);
                    if (preView) {
                        make.left.equalTo(preView.mas_right).offset(10);
                        make.top.equalTo(preView);
                    }else {
                        make.left.equalTo(weakSelf);
                        make.top.equalTo(preView);
                    }
                }];
            }
            preView = seatLabel;
        }
    }
    
    [preView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf);
    }];
    
    [super layoutSubviews];
}

@end
