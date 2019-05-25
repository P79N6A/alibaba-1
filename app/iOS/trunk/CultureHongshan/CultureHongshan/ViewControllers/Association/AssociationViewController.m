//
//  AssociationViewController.m
//  CultureHongshan
//
//  Created by ct on 16/7/27.
//  Copyright © 2016年 CT. All rights reserved.
//

#import "AssociationViewController.h"
#import "AppProtocolMacros.h"

#import "WebViewController.h"
#import "UIWebView+TS_JavaScriptContext.h"
#import "MJRefresh.h"
#import "WebSDKService.h"

#import "WHYHttpRequest.h"


@interface AssociationViewController ()<UIWebViewDelegate>
{
    WebSDKService *_sdkService;
    BOOL _webDidLoad;
}

@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@property (nonatomic, strong) UIWebView *webView;

@end

@implementation AssociationViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    if (!_webView) {
        [self loadWebViewData];
    }else {
        [_webView setSdkFunction];
        if ([[_webView stringByEvaluatingJavaScriptFromString:@"typeof window.userId"] isEqualToString:@"string"]) {
            [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.userId = '%@';", [UserService sharedService].userId]];
        }else {
            [_webView reload];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _sdkService = [WebSDKService new];
    _sdkService.sourceVC = self;
    
    [self loadWebViewData];
}


- (void)loadWebViewData
{
    [self initWebView];
    [self startIndicatorAnimating];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:kAssociationListUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:kHttpTimeOutDuration];
    [_webView loadRequest:request];
}


- (void)initWebView
{
    self.webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    _webView.backgroundColor = kBgColor;
    _webView.scalesPageToFit = YES;
    _webView.delegate = self;
    [self.view addSubview:_webView];
    
    WS(weakSelf)
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
    
    [self initRefreshControl];
}

- (void)initRefreshControl
{
    WEAK_VIEW(_webView)
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakView reload];
    }];
    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"释放刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"文化生活加载中..." forState:MJRefreshStateRefreshing];
    header.stateLabel.font = FONT(14);
    header.lastUpdatedTimeLabel.font = FONT(12);
    header.stateLabel.textColor = kLightLabelColor;
    header.lastUpdatedTimeLabel.textColor = kLightLabelColor;
    _webView.scrollView.header = header;
}

- (UIActivityIndicatorView *)indicatorView
{
    if (_indicatorView) {
        [self.view bringSubviewToFront:_indicatorView];
        return _indicatorView;
    }
    
    _indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectZero];
    [_indicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _indicatorView.color = [UIColor colorWithWhite:0 alpha:0.8];
    [self.view addSubview:_indicatorView];
    
    WS(weakSelf)
    [_indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf.view);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    return _indicatorView;
}


- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self startIndicatorAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    _webDidLoad = YES;
    [webView.scrollView.header endRefreshing];
    [self stopIndicatorAnimating];
    
    NSString *navTitle = [webView getWebViewNavTitle];
    if (navTitle.length) {
        self.navigationItem.title = navTitle;
    }
}

- (void)webView:(UIWebView *)webView didCreateJavaScriptContext:(JSContext*) ctx;
{
    [webView setSdkFunction];
    ctx[kAppJsSDK] = _sdkService;
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self stopIndicatorAnimating];
    if (error) {
        
        NSString *errorMsg = @"";
        
        switch (error.code) {
            case NSURLErrorUnknown: {
                errorMsg = @"出现未知错误!";
            }
                break;
            case NSURLErrorCancelled: {
                //[SVProgressHUD showInfoWithStatus:@"出现未知错误!"];
            }
                break;
            case NSURLErrorBadURL: {
                errorMsg = @"网络链接有误!";
            }
                break;
            case NSURLErrorTimedOut: {
                errorMsg = @"连接超时，请稍候再试!";
            }
                break;
            case NSURLErrorNotConnectedToInternet: {
                errorMsg = @"网络连接已断开，请检查网络!";
            }
                break;
            default:
                break;
        }
        
        // 有错误提示时
        if (errorMsg.length) {
            if (_webDidLoad) { // 已经加载过页面数据时，弹出会自动消失的弹窗
                [SVProgressHUD showInfoWithStatus:errorMsg];
            }else {
                WEAK_VIEW(webView);
                WEAK_VIEW1(_indicatorView);
                
                // 如果添加在_webView上，需要在下拉刷新时，移除这个视图
                [self showErrorMessage:errorMsg
                                 frame:CGRectMake(0, 0, kScreenWidth, _webView.height)
                           promptStyle:NoDataPromptStyleClickRefreshForError
                            parentView:self.view
                         callbackBlock:^(id object, NSInteger index, BOOL isSameIndex)
                 {
                     [weakView1 startAnimating];
                     NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:kAssociationListUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:kHttpTimeOutDuration];
                     [weakView loadRequest:request];
                 }];
            }
        }
    }
}


- (void)startIndicatorAnimating
{
    [self.indicatorView startAnimating];
}

- (void)stopIndicatorAnimating
{
    [self.indicatorView stopAnimating];
}


- (void)loadRedirectUrlAfterLogining:(NSString *)redirectUrl
{
    NSString *currentUrl = [_webView getCurrentUrl];
    if (redirectUrl.length && ![redirectUrl isEqualToString:currentUrl] && ![redirectUrl isEqualToString:kLoginDefaultRedirectUrl]) {
        [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.location.href='%@'",redirectUrl]];
    }else
    {
        [_webView reload];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    if (self.tabBarController && self.tabBarController.selectedIndex != 3) {
        _webView.delegate = nil;
        [_webView removeFromSuperview];
        _webView = nil;
    }
    
    FBLOG(@"内存警告：%@",self.class);
}



@end
