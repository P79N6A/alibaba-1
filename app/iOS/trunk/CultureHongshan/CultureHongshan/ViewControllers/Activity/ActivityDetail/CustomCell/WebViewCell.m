//
//  WebViewCell.m
//  CultureHongshan
//
//  Created by ct on 16/1/26.
//  Copyright © 2016年 CT. All rights reserved.
//

#import "WebViewCell.h"



@interface WebViewCell ()

@property (nonatomic, assign) BOOL isLoaded;

@end



@implementation WebViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = kBgColor;
 
        self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,10)];
        _webView.scrollView.scrollEnabled = YES;
        _webView.scrollView.bounces = NO;
        _webView.backgroundColor = [UIColor whiteColor];
        [UIToolClass setupDontAutoAdjustContentInsets:_webView.scrollView forController:nil];
        [self.contentView addSubview:_webView];
        
        //按钮
        self.moreButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
        _moreButton.backgroundColor = [UIColor whiteColor];
        [_moreButton setImage:IMG(@"icon_arrow_down_gray") forState:UIControlStateNormal];
        [self.contentView addSubview:_moreButton];
    }
    return self;
}

- (void)setHtmlString:(NSString *)htmlString
{
    if (self.webView.height < 5) {
        _isLoaded = NO;
    }
    
    if (htmlString.length && _isLoaded == NO)
    {
        if (_htmlString) {
            _htmlString = nil;
        }
        _isLoaded = YES;
        
        _htmlString = htmlString;
        
        [self.webView loadHTMLString:_htmlString baseURL:nil];
        [self.webView request];
    }
}




@end
