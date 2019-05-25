//
//  WebViewController.m
//  徐家汇
//
//  Created by 李 兴 on 13-10-12.
//  Copyright (c) 2013年 李 兴. All rights reserved.
//

#import "WebViewController.h"

#import "UIWebView+TS_JavaScriptContext.h"

#import "SharePresentView.h"
#import "ShareService.h"

#import "WebPhotoBrowser.h"
#import "LogService.h"
#import "AppDelegate.h"

#import "WebSDKService.h"
#import "WHYHttpRequest.h"


@interface WebViewController () <UIWebViewDelegate>
{
    WebSDKService *_sdkService;
    
    BOOL _webDidLoad;
    BOOL _shareButtonHidden;
    
    NSString *_currentPageShareContent;//当前页用于分享的内容
    UIImage *_currentPageShareImage;//当前页用于分享的图片
}

@property (nonatomic, strong) UIWebView * webView;
/** 当前页面是否已加载完毕 */
@property (nonatomic, assign) BOOL currentPageDidLoad;

@end



@implementation WebViewController

@synthesize currentPageNavTitleChanged;
@synthesize firstWebImgUrl;
@synthesize currentPageShareImage;

@synthesize indicatorView = _indicatorView;

#pragma mark - 

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _shareButtonHidden = YES;
    }
    return self;
}




-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;

    // 进入全屏
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(begainFullScreen) name:UIWindowDidBecomeVisibleNotification object:nil];
    // 退出全屏
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endFullScreen) name:UIWindowDidBecomeHiddenNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [LogService updateLogKey:[_url stringByReplacingOccurrencesOfString:@"=" withString:@"@@"]  addr:[NSString stringWithFormat:@"%p",self]];
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIWindowDidBecomeVisibleNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIWindowDidBecomeHiddenNotification object:nil];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = kBgColor;
    
    _sdkService = [WebSDKService new];
    _sdkService.sourceVC = self;
    
    [self loadUI];
    
    // 去除URL中的e空白字符、中文字符
    self.url = [_url stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.url = [_url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:_url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:kHttpTimeOutDuration];
    [_webView loadRequest:request];
}


- (void)loadUI {
    if ([SharePresentView canShowShareView]) {
        //分享按钮
        UIButton *shareButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kNavPictureSize, kNavPictureSize)];
        shareButton.hidden = _shareButtonHidden;
        shareButton.userInteractionEnabled = _shareButtonHidden==NO;
        [shareButton setImage:IMG(@"icon_share") forState:UIControlStateNormal];
        [shareButton addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:shareButton];
    }

    // 浏览器视图
    _webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    _webView.delegate = self;
    _webView.scalesPageToFit = YES;
    [self.view addSubview:_webView];
    
    // 加载进度指示器
    _indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectZero];
    [_indicatorView startAnimating];
    [_indicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _indicatorView.color = [UIColor colorWithWhite:0 alpha:0.8];
    [self.view addSubview:_indicatorView];
    
    WS(weakSelf)
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, HEIGHT_HOME_INDICATOR, 0));
    }];
    
    [_indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.centerX.equalTo(weakSelf.view);
        make.centerY.equalTo(weakSelf.view).offset(-80);
    }];
}


- (void)dealloc
{
    if (_webView)
    {
        [_webView stopLoading];
        [_webView removeFromSuperview];
        _webView.delegate = nil;
        _webView = nil;
    }
    
    if (_indicatorView)
    {
        [_indicatorView stopAnimating];
        [_indicatorView removeFromSuperview];
        _indicatorView = nil;
    }
}


#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    // 查看大图
    if ([request.URL.scheme isEqualToString:@"image-preview"]) {
        NSString *path = [request.URL.absoluteString substringFromIndex:[@"image-preview:" length]];
        path = [path stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]];
        
        NSArray *pathArray = [ToolClass getComponentArray:path separatedBy:@";"];
        
        [WebPhotoBrowser photoBrowserWithImageUrlArray:[webView getImageUrlArrayFromWeb]//图片链接数组
                                          currentIndex:[pathArray[1] integerValue]
                                       completionBlock:^(WebPhotoBrowser *photoBrowser) {
                                           
                                       }];
        
        return NO;
    }
    
    NSString *url = request.URL.absoluteString;
    FBLOG(@"-------当前加载链接：%@", url);
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    self.currentPageNavTitleChanged = NO;
    self.currentPageDidLoad = NO;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [_indicatorView stopAnimating];
    self.currentPageDidLoad = YES;
    
    // 导航栏标题设置
    if (self.currentPageNavTitleChanged==NO && self.navTitleLocked == NO) {
        self.navigationItem.title = [webView getWebViewNavTitle];
    }
    
    // 提前下载网页中的第一张图片
    if (self.shareButtonHidden == NO) {
        [self downloadWebPageFirstImage];
    }
    
    // 防止injs变量不存在
    if (![webView functionDidExist:[NSString stringWithFormat:@"%@.getUserInfo", kAppJsSDK]]) {
        JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
        context[kAppJsSDK] = _sdkService;
        context.exceptionHandler =  ^ (JSContext *con , JSValue *exception){
            FBLOG(@"网页加载出现问题：%@", exception);
        };
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [_indicatorView stopAnimating];
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
        
        if ([_url hasPrefix:@"http"] == NO) {
            errorMsg = @"无效的链接地址!";
        }
        
        // 有错误提示时
        if (errorMsg.length) {
            if (_webDidLoad) { // 已经加载过页面数据时，弹出会自动消失的弹窗
                [SVProgressHUD showInfoWithStatus:errorMsg];
            }else {
                WEAK_VIEW(webView);
                WEAK_VIEW1(_indicatorView);
                [self showErrorMessage:errorMsg
                                 frame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-HEIGHT_TAB_BAR-HEIGHT_HOME_INDICATOR)
                           promptStyle:NoDataPromptStyleClickRefreshForError
                            parentView:self.view
                         callbackBlock:^(id object, NSInteger index, BOOL isSameIndex)
                 {
                     [weakView1 startAnimating];
                     NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:_url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:kHttpTimeOutDuration];
                     [weakView loadRequest:request];
                 }];
            }
        }
    }
}


- (void)webView:(UIWebView *)webView didCreateJavaScriptContext:(JSContext *)context {
    [webView setSdkFunction];
    
    //写在这里的原因是：H5页面在未加载之前需要判断用户是否已经登录，而不是等到页面已经加载完了才判断是否登录.
    context[kAppJsSDK] = _sdkService;
    
    // 不要删除下面的这句话，H5页面有使用.
    context[@"Log"] = ^(id msg) {
        FBLOG(@"%@",msg);
    };
    
    context.exceptionHandler = ^(JSContext *context, JSValue *exception) {
        FBLOG(@"网页加载出现问题：%@", exception);
    };
}




#pragma mark - 按钮的点击事件

- (void)shareButtonClick:(UIButton *)sender {
    // 网页未加载完毕时，不能进行分享
    if (!self.currentPageDidLoad) return;
    
    if ([SharePresentView canShowShareView] == NO) {
        [SVProgressHUD showInfoWithStatus:STRING_FOR_CANT_SHARE];
        return;
    }
    
    if ([self.webView functionDidExist:@"appShareButtonClick"]) {
        // 调用H5的分享方法
        [_webView stringByEvaluatingJavaScriptFromString:@"appShareButtonClick();"];
        return;
    }
    
    NSMutableDictionary *shareInfo = [NSMutableDictionary dictionaryWithCapacity:4];
    
    if ([self.webView functionDidExist:@"getShareInfo"]) {
        NSString *jsonString = [_webView stringByEvaluatingJavaScriptFromString:@"getShareInfo();"];
        NSDictionary *shareDict = [JsonTool jsonObjectFromString:jsonString];
        if (shareDict.count) {
            [shareInfo setValuesForKeysWithDictionary:shareDict];
        }
    }
    
    [self shareByApp:shareInfo];
}

- (void)shareByApp:(NSDictionary *)shareInfo {
    if ([SharePresentView canShowShareView] == NO) {
        [SVProgressHUD showInfoWithStatus:STRING_FOR_CANT_SHARE];
        return;
    }
    
    // 第一步：获取WebView中的分享参数
    NSString *shareUrl     = [_webView getCurrentUrl];
    NSString *shareTitle   = self.navigationItem.title.length ? self.navigationItem.title : APP_DISPLAY_NAME;
    NSString *shareContent = [UIToolClass getHTMLContentFromWebView:_webView];
    NSString *shareImgUrl  = self.firstWebImgUrl;
    
    if (shareImgUrl.length == 0) {
        // 不存在时，再次从网页里获取一次
        NSString *webImgUrl = [_webView getWebFirstImageUrl];
        if ([webImgUrl isValidImgUrl]) {
            shareImgUrl = webImgUrl;
        }
    }
    
    
    // 第二步：通过API获取的参数在有值的情况下替换掉原有的值
    if ([[shareInfo safeStringForKey:@"title"] length] > 0) {
        shareTitle = [shareInfo safeStringForKey:@"title"];
    }
    if ([[shareInfo safeStringForKey:@"desc"] length] > 0) {
        shareContent = [shareInfo safeStringForKey:@"desc"];
    }
    if ([[shareInfo safeStringForKey:@"imgUrl"] length] > 0) {
        NSString *webImgUrl = [shareInfo safeStringForKey:@"imgUrl"];
        if ([webImgUrl isValidImgUrl]) {
            shareImgUrl = webImgUrl;
        }
    }
    if ([[shareInfo safeStringForKey:@"link"] length] > 0) {
        shareUrl = [shareInfo safeStringForKey:@"link"];
    }
    
    // 第三步：文字长度处理
    if (shareTitle.length > 30) shareTitle = [shareTitle substringToIndex:30];
    if (shareContent.length > 40) shareContent = [shareContent substringToIndex:40];
    
    
    NSMutableDictionary *shareAttributes = [NSMutableDictionary dictionaryWithCapacity:4];
    
    [shareAttributes setValue:shareTitle forKey:@"shareTitle"];
    [shareAttributes setValue:shareContent forKey:@"shareContent"];
    [shareAttributes setValue:shareImgUrl forKey:@"shareImgUrl"];
    [shareAttributes setValue:shareUrl forKey:@"shareUrl"];
    // 第四步：设置分享平台
    SSDKPlatformType platformType = SSDKPlatformTypeUnknown;
    
    NSString *platform = [shareInfo safeStringForKey:@"platform"];
    if ([@"wechat_session" isEqualToString:platform]) {
        platformType = SSDKPlatformSubTypeWechatSession;
    }else if ([@"wechat_timeline" isEqualToString:platform]) {
        platformType = SSDKPlatformSubTypeWechatTimeline;
    }else if ([@"qq_friend" isEqualToString:platform]) {
        platformType = SSDKPlatformSubTypeQQFriend;
    }else if ([@"weibo_sina" isEqualToString:platform]) {
        platformType = SSDKPlatformTypeSinaWeibo;
    }
    
    if (platformType == SSDKPlatformTypeUnknown) {
        // 选取分享平台后，再分享
        [SharePresentView showShareViewWithActionHandler:^(NSInteger index) {
            
            if (index >= 1 && index <= 4) {
                SSDKPlatformType selectedPlatform = SSDKPlatformTypeUnknown;
                
                if (index == 2) {
                    // 微信朋友圈
                    selectedPlatform = SSDKPlatformSubTypeWechatTimeline;
                }else if (index == 1) {
                    // 微信好友
                    selectedPlatform = SSDKPlatformSubTypeWechatSession;
                }else if (index == 3) {
                    // QQ好友
                    selectedPlatform = SSDKPlatformSubTypeQQFriend;
                }else if (index == 4) {
                    // 新浪微博
                    selectedPlatform = SSDKPlatformTypeSinaWeibo;
                }
                
                [self beginShareWithPlatform:selectedPlatform shareInfo:shareAttributes];
            }
        }];
        
    }else {
        [self beginShareWithPlatform:platformType shareInfo:shareAttributes];
    }
}


// 调用分享方法
- (void)beginShareWithPlatform:(SSDKPlatformType)platform shareInfo:(NSDictionary *)shareInfo {
    
    NSString *shareTitle   = [shareInfo safeStringForKey:@"shareTitle"];
    NSString *shareContent = [shareInfo safeStringForKey:@"shareContent"];
    NSString *shareImgUrl  = [shareInfo safeStringForKey:@"shareImgUrl"];
    NSString *shareUrl     = [shareInfo safeStringForKey:@"shareUrl"];
    BOOL addIntegral = [shareInfo safeIntForKey:@"addIntegral"] == 1;
    
    if (shareTitle.length == 0) shareTitle = APP_SHOW_NAME;
    
    if (shareImgUrl.length) {
        WS(weakSelf)
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:shareImgUrl] options:SDWebImageDownloaderHighPriority | SDWebImageDownloaderUseNSURLCache progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
            if (image) {
                [ShareService shareWithPlatformType:platform title:shareTitle content:shareContent sharedImage:image imageUrl:nil shareUrl:shareUrl addIntegral:addIntegral onStateChanged:^(SSDKResponseState state) {
                }];
            }else {
                if (weakSelf.currentPageShareImage) {
                    [ShareService shareWithPlatformType:platform title:shareTitle content:shareContent sharedImage:weakSelf.currentPageShareImage imageUrl:nil shareUrl:shareUrl addIntegral:addIntegral onStateChanged:^(SSDKResponseState state) {
                    }];
                }else {
                    [ShareService shareWithPlatformType:platform title:shareTitle content:shareContent sharedImage:nil imageUrl:shareImgUrl shareUrl:shareUrl addIntegral:addIntegral onStateChanged:^(SSDKResponseState state) {
                    }];
                }
            }
        }];
    }else {
        [ShareService shareWithPlatformType:platform title:shareTitle content:shareContent sharedImage:self.currentPageShareImage imageUrl:nil shareUrl:shareUrl addIntegral:addIntegral onStateChanged:^(SSDKResponseState state) {
        }];
    }
}

#pragma mark -  网页视频播放屏幕旋转

// 进入全屏
-(void)begainFullScreen {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.allowRotation = YES;
}

// 退出全屏
-(void)endFullScreen {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.allowRotation = NO;
}




#pragma mark - WebViewControllerProtocol

// 设置分享按钮状态
- (void)setShareButtonHidden:(BOOL)shareButtonHidden {
    _shareButtonHidden = shareButtonHidden;
    UIButton *navShareButton = self.navigationItem.rightBarButtonItem.customView;
    if (navShareButton) {
        navShareButton.hidden = shareButtonHidden;
        navShareButton.userInteractionEnabled = (shareButtonHidden==NO);
    }
}

- (BOOL)shareButtonHidden {
    return _shareButtonHidden;
}




#pragma mark - 其它方法

// 下载网页中的首张图片
- (void)downloadWebPageFirstImage {
    
    self.firstWebImgUrl = [self.webView getWebFirstImageUrl];
    
    if ([self.firstWebImgUrl isValidImgUrl]) {
        WS(weakSelf)
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:self.firstWebImgUrl] options:SDWebImageDownloaderHighPriority progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
            if (image && data && error == nil) {
                weakSelf.currentPageShareImage = image;
            }
        }];
    }
}



- (void)popViewController {
    [self backToLastPage];
}

// 返回前一页
- (void)backToLastPage {
    NSLog(@"————————————————————");
    
    if ([_webView canGoBack]) {
        if (_isBookPage &&  ([_webView.request.URL.absoluteString rangeOfString:@"wechatActivity/preActivityOrder.do"].location != NSNotFound || [_webView.request.URL.absoluteString rangeOfString:@"wechatActivity/finishSeat.do"].location != NSNotFound) ) {
            
            [self clearWebView];
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            [_webView goBack];
        }
        
    }else  {
        [self clearWebView];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)clearWebView {
    if (_webView) {
        [_webView stopLoading];
        [_webView removeFromSuperview];
        _webView = nil;
        
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
    }
}


// 登录后的重定向
- (void)loadRedirectUrlAfterLogining:(NSString *)redirectUrl {
    NSString *userId = [UserService sharedService].userId;
    
    NSString *currentUrl = [_webView getCurrentUrl];
    if (redirectUrl.length>0 && ![redirectUrl isEqualToString:currentUrl] && ![redirectUrl isEqualToString:kLoginDefaultRedirectUrl]) {
        // 跳转到H5指定的链接
        NSString *reloadUrl = MYURLByInsertField(redirectUrl, @"userId", userId);
        [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.location.href='%@'",reloadUrl]];
    }else {
        NSString *reloadUrl = MYURLByInsertField(currentUrl, @"userId", userId);
        [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.location.replace(\"%@\");", reloadUrl]];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
