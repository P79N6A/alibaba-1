//
//  MYMultiItemsEnumView.m
//  WHYUIToolKit
//
//  Created by JackAndney on 2017/10/30.
//  Copyright © 2017年 Creatoo. All rights reserved.
//

#import "MYMultiItemsEnumView.h"


@interface MYMultiItemsEnumView ()
{
    NSLayoutConstraint *_heigthConstraint;
}
@end


@implementation MYMultiItemsEnumView

- (instancetype)initWithFrame:(CGRect)frame itemTitles:(NSArray<NSString *> *)itemTitles configLabelBlock:(void(^)(UILabel *itemLabel, NSInteger index))block showBgColor:(BOOL)showBgColor {
    frame.size.height = 0;
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        self.spacingX = 8.0f;
        self.spacingY = 8.0f;
        self.numberOfLines = 0.0f;
        
        self.padding = 18.0f;
        self.itemHeight = 22.0f;
        self.cornerRadius = 0.0f;
        
        self.itemTitles = itemTitles;
        self.configLabelBlock = block;
        self.showBgColor = showBgColor;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (CGRectEqualToRect(self.bounds, CGRectZero) == YES) {
        return;
    }
    
    CGFloat offsetX = 0;
    CGFloat offsetY = 0;
    CGFloat itemWidth = 0;
    CGFloat containerWidth = CGRectGetWidth(self.frame); // 容器的宽度
    CGFloat realItemHeight = -1;
    BOOL updateItemFrameOnNewLine = NO; // 是否已经在新的一行更新过Frame
    BOOL didUpdateItemFrame = NO; // 是否更新过Frame
    NSInteger lineNum = 0; // 行数
    NSMutableArray<UILabel *> *longTitleArray = [[NSMutableArray alloc] initWithCapacity:0]; // 超长文本的label数组
    
    // ————————————————————————————— 开始 —————————————————————————————
    for (UILabel *label in self.subviews) {
        if ([label isKindOfClass:[UILabel class]]) {
            
            // 计算item的显示宽度 和 高度
            if (self.showBgColor) {
                itemWidth = ceilf([label.text sizeWithAttributes:@{NSFontAttributeName : label.font}].width) + 2 * self.padding;
                if (realItemHeight < 0) {
                    if (self.itemHeight == 0) {
                        realItemHeight = ceilf(label.font.lineHeight);
                    }else {
                        realItemHeight = self.itemHeight;
                    }
                }
            }else {
                itemWidth = ceilf([label.text sizeWithAttributes:@{NSFontAttributeName : label.font}].width);
                realItemHeight = ceilf(label.font.lineHeight);
            }
            
            if (offsetX + itemWidth > containerWidth) {
                 updateItemFrameOnNewLine = NO;
                // 需要换行
                if (itemWidth >= containerWidth*0.8) {
                    // 对宽度进行赋值，后续就不需要再次计算其宽度了
                    CGRect labelFrame = label.frame;
                    labelFrame.size.width = MIN(itemWidth, containerWidth);
                    label.frame = labelFrame;
                    [longTitleArray addObject:label];
                    continue;
                }
                
                offsetX = 0;
                offsetY += self.spacingY + realItemHeight;
                lineNum++;
                
            }else {
                updateItemFrameOnNewLine = YES;
            }
            
            label.frame = CGRectMake(offsetX, offsetY, itemWidth, realItemHeight);
            offsetX += itemWidth + self.spacingX;
            
            if (didUpdateItemFrame == NO) didUpdateItemFrame = YES;
            if (updateItemFrameOnNewLine == NO) updateItemFrameOnNewLine = YES;
            
            
            if (self.numberOfLines > 0 && lineNum == self.numberOfLines) {
                // 达到最大显示行数
                [self updateSelfHeight:offsetY - self.spacingY];
                return;
            }
            
        }
    }
    // ————————————————————————————— 结束 —————————————————————————————
    
    if (longTitleArray.count) {
        offsetX = 0;
        if (didUpdateItemFrame == NO) didUpdateItemFrame = YES;
        
        for (UILabel *itemLabel in longTitleArray) {
            if (updateItemFrameOnNewLine) {
                // 在新的一行，更新过Label的Frame
                offsetY +=  self.spacingY + realItemHeight;
            }
            
            itemLabel.frame = CGRectMake(offsetX, offsetY, CGRectGetWidth(itemLabel.frame), realItemHeight);
            
            updateItemFrameOnNewLine = NO;
            offsetY += self.spacingY + realItemHeight;
        }
    }
    
    if (didUpdateItemFrame == NO) {
        // 没有更新过Label的frame
        [self updateSelfHeight:0];
    }else {
        
        if (updateItemFrameOnNewLine == NO) {
            // 没有在新的一行，更新过Label的frame
            [self updateSelfHeight:offsetY - self.spacingY];
        }else {
            [self updateSelfHeight:offsetY + realItemHeight];
        }
    }
}

- (void)updateSelfHeight:(CGFloat)height {
    
    if (self.translatesAutoresizingMaskIntoConstraints == NO) {
        if (_heigthConstraint == nil) {
            _heigthConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:0];
            _heigthConstraint.active = YES;
        }
        
        _heigthConstraint.constant = height;
    }else {
        CGRect frame = self.frame;
        frame.size.height = height;
        self.frame = frame;
    }
}


#pragma mark -

- (void)reloadSubviews {
    [self m_reloadSubviews];
}

- (void)m_reloadSubviews {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    // 没有要显示的内容
    if (self.itemTitles.count == 0) {
        [self updateSelfHeight:0];
        return;
    }
    
    NSInteger index = 0;
    for (NSString *itemTitle in self.itemTitles) {
        index++;
        if (![itemTitle isKindOfClass:[NSString class]] || itemTitle.length == 0) {
            continue;
        }
        
        UILabel *itemLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        itemLabel.textAlignment = NSTextAlignmentCenter;
        itemLabel.font = [UIFont systemFontOfSize:14];
        itemLabel.text = itemTitle;
        itemLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        // 圆角
        if (self.cornerRadius > 0) {
            itemLabel.layer.masksToBounds = YES;
            itemLabel.layer.cornerRadius = self.cornerRadius;
        }
        [self addSubview:itemLabel];
        // 外部修改Label的属性
        if (self.configLabelBlock) self.configLabelBlock(itemLabel, index);
    }
}

- (CGFloat)getContentHeight {
    if (self.itemTitles.count > 0 && self.subviews.count > 0) {
        [self setNeedsLayout];
        [self layoutIfNeeded];
        
        return CGRectGetHeight(self.frame);
    }
    
    return 0.0f;
}

@end
