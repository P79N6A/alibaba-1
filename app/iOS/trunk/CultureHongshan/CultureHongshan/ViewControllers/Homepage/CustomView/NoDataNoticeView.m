//
//  NoDataNoticeView.m
//  CultureHongshan
//
//  Created by JackAndney on 16/4/24.
//  Copyright © 2016年 CT. All rights reserved.
//

#import "NoDataNoticeView.h"

#import "WebSDKService.h"

@interface NoDataNoticeView ()

@property (nonatomic, assign) NoDataPromptStyle style;
@property (nonatomic, copy  ) NSString   *message;
@property (nonatomic, copy  ) IndexBlock block;

@end



@implementation NoDataNoticeView


+ (NoDataNoticeView *)noticeViewWithFrame:(CGRect)frame
                                  bgColor:(UIColor *)bgColor
                                  message:(NSString *)message
                              promptStyle:(NoDataPromptStyle)style
                            callbackBlock:(IndexBlock)block
{
    if (message == nil || [message isKindOfClass:[NSString class]] == NO) {
        return nil;
    }
    
    NoDataNoticeView *noticeView = [[NoDataNoticeView alloc] initWithFrame:frame];
    noticeView.backgroundColor = bgColor ? bgColor : [UIColor whiteColor];
    noticeView.block = block;
    noticeView.style = style;
    noticeView.message = message;
    if ([WebSDKService currentNetworkState] == NotReachable) {
        noticeView.style = NoDataPromptStyleClickRefreshForNoNetwork;
        noticeView.message = @"咦～～怎么木有网了?";
    }
    
    [noticeView initSubviews];
    
    return noticeView;
}

- (void)initSubviews
{
    /*
     
     NoDataPromptStyleNone,
     NoDataPromptStyleClickRefreshForNoContent,// 没有内容
     NoDataPromptStyleClickRefreshForNoNetwork, // 断网
     NoDataPromptStyleClickRefreshForError,
     NoDataPromptStyleTextOnly, // 只显示文本
     
     */
    if (_style == NoDataPromptStyleClickRefreshForNoContent ||
        _style == NoDataPromptStyleClickRefreshForNoNetwork ||
        _style == NoDataPromptStyleClickRefreshForError)
    {
        if (_style==NoDataPromptStyleClickRefreshForNoContent && _message.length==0) {
            self.message = @"内容还在采集，请等等再来。";
        }
        
        // 400x315   0.7875  1.27
        UIImage *errorImg = _style==NoDataPromptStyleClickRefreshForNoContent ? IMG(@"img_for_no_content") : IMG(@"img_for_no_network");
        CGSize imgSize = CGSizeMake(158*1.27, 158);
        
        CGFloat spacingY1 = 5;
        CGFloat spacingY2 = 22;
        CGFloat labelHeight = 28;
        UIFont *messageFont = FontYT(15);
        
        
        // 最上边和最下边的间距最小为30、30
        NSMutableAttributedString *attributedString = [UIToolClass boldString:_message font:messageFont lineSpacing:5 alignment:NSTextAlignmentCenter];
        
        CGFloat textHeight = MIN([UIToolClass attributedTextHeight:attributedString width:self.width-50], self.height-30-imgSize.height-spacingY1-spacingY2-labelHeight-30);
        CGFloat btnHeight = 28;
        CGFloat btnWidth = ConvertSize(200);
        CGFloat offsetY = (self.height - (imgSize.height+spacingY1+textHeight+spacingY2+labelHeight))*0.5*0.8;
        
        // 图标
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, offsetY, imgSize.width, imgSize.height)];
        imgView.image = errorImg;
        [self addSubview:imgView];
        imgView.centerX = self.width*0.5;
        
        //消息
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, imgView.maxY+spacingY1, self.width-50, textHeight)];
        messageLabel.font = messageFont;
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.textColor = [UIToolClass colorFromHex:@"808080"];
        messageLabel.attributedText = attributedString;
        [self addSubview:messageLabel];
        
        // Label
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, messageLabel.maxY+spacingY2, btnWidth, btnHeight)];
        label.radius = 3;
        label.textColor = messageLabel.textColor;
        label.layer.borderColor = label.textColor.CGColor;
        label.layer.borderWidth = 0.8;
        label.font = FontYT(13);
        label.text = @"点击刷新";
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        label.centerX = self.width*0.5;

        //按钮
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, btnWidth*2, btnHeight*2)];
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        btn.center = label.center;
        
    }else {
        //按钮
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        btn.backgroundColor = COLOR_IWHITE;
        btn.titleLabel.font = FontYT(16);
        btn.titleLabel.numberOfLines = 0;
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [btn setTitle:_message forState:UIControlStateNormal];
        [btn setTitleColor:kLightLabelColor forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
}

- (void)buttonClick:(UIButton *)sender
{
    if (_block) {
        _block(sender,0,NO);//这些参数都没有用
    }
    [self removeFromSuperview];
}

@end
