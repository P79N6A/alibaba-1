//
//  PopupWebView.m
//  CultureHongshan
//
//  Created by ct on 16/5/17.
//  Copyright © 2016年 CT. All rights reserved.
//

#import "PopupWebView.h"



#import "WebPhotoBrowser.h"


@interface PopupWebView ()<UIWebViewDelegate>

@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *navTitle;
@property (nonatomic, copy) NSArray *imageUrls;

@end





@implementation PopupWebView


+ (void)webViewWithUrl:(NSString *)url navTitle:(NSString *)title
{
    //一开始就超出屏幕，处于隐藏状态
    PopupWebView *webView = [[PopupWebView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight)];
    webView.url = url;
    webView.navTitle = title;
    [webView initSubviews];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:webView];
    
    [webView show];
}

- (void)show
{
    WS(weakSelf);
    
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.originalY = 0;
    }];
}


- (void)initSubviews
{
    // 70 + xxx + 70
    self.backgroundColor = [UIColor whiteColor];
    
    MYMaskView *line1 = [MYMaskView maskViewWithBgColor:kLineGrayColor frame:CGRectMake(0, 62, kScreenWidth, 0.7) radius:0];
    [self addSubview:line1];
    
    UILabel *navTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 30)];
    navTitleLabel.textAlignment = NSTextAlignmentCenter;
    navTitleLabel.font = FontYT(18);
    navTitleLabel.textColor = [UIToolClass colorFromHex:@"262626"];
    navTitleLabel.text = self.navTitle;
    [self addSubview:navTitleLabel];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 70, kScreenWidth, kScreenHeight-140)];
    webView.backgroundColor = [UIColor whiteColor];
    webView.delegate = self;
    [self addSubview:webView];
    
    
    MYMaskView *line2 = [MYMaskView maskViewWithBgColor:kLineGrayColor frame:CGRectMake(0, kScreenHeight-70+8, kScreenWidth, 0.7) radius:0];
    [self addSubview:line2];
    
    //关闭按钮
    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, line2.maxY+15, 100, 30)];
    closeButton.radius = 5;
    closeButton.layer.borderColor = kThemeDeepColor.CGColor;
    closeButton.layer.borderWidth = 1;
    closeButton.titleLabel.font = FontYT(17);
    [closeButton setTitle:@"关 闭" forState:UIControlStateNormal];
    [closeButton setTitleColor:kThemeDeepColor forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeButton];
    closeButton.centerX = self.width*0.5;
    
    //请求数据
    [webView loadHTMLString:self.url baseURL:nil];
    [webView request];
}




- (void)dismiss:(UIButton *)sender
{
    __weak UIView *popupView = sender.superview;
    
    [UIView animateWithDuration:0.5 animations:^{
        popupView.originalY = kScreenHeight;
    } completion:^(BOOL finished) {
        [popupView removeFromSuperview];
    }];
}


#pragma mark - UIWebViewDelegate


-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    // 查看大图
    if ([request.URL.scheme isEqualToString:@"image-preview"])
    {
        NSString *path = [request.URL.absoluteString substringFromIndex:[@"image-preview:" length]];
        path = [path stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        
        NSArray *pathArray = [ToolClass getComponentArray:path separatedBy:@";"];
        
        self.userInteractionEnabled = 0;
        WS(weakSelf);
        
        [WebPhotoBrowser photoBrowserWithImageUrlArray:[webView getImageUrlArrayFromWeb]
                                          currentIndex:[pathArray[1] integerValue]
                                       completionBlock:^(WebPhotoBrowser *photoBrowser) {
                                           weakSelf.userInteractionEnabled = 1;
                                       }];
        
        return NO;
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [webView addResizeWebImageJs];
    [webView addImageClickActionJs];
}


@end
