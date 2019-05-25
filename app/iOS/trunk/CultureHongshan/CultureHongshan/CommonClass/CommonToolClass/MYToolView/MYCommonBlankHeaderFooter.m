//
//  MYCommonBlankHeaderFooter.m
//  CultureHongshan
//
//  Created by JackAndney on 2017/11/28.
//  Copyright © 2017年 CT. All rights reserved.
//

#import "MYCommonBlankHeaderFooter.h"

@interface MYCommonBlankHeaderFooter ()
@property (nonatomic, strong) UIView *bgView;
@end

@implementation MYCommonBlankHeaderFooter
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = kBgColor;
        
//        self.bgView = [UIView new];
//        [self.contentView addSubview:self.bgView];
//
//        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.mas_equalTo(UIEdgeInsetsZero);
//        }];
    }
    return self;
}

//- (void)updateEstimatedHeight:(CGFloat)height {
//    [self.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(height);
//    }];
//}

@end
