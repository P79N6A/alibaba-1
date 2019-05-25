//
//  CommonMultiTableView.m
//  CultureHongshan
//
//  Created by JackAndney on 16/7/28.
//  Copyright © 2016年 ct. All rights reserved.
//

#import "CommonMultiTableView.h"

#import "NoDataNoticeView.h"
#import "MJRefresh.h"

static NSString *reuseID_TableViewCell = @"TableViewCell";
static NSString *reuseID_WebViewCell   = @"WebViewCell";

#define kAutolayout_Method  1


@interface CommonMultiTableView () <UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate>

@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@property (nonatomic, strong) UICollectionView *bgCollectionView;
@property (nonatomic,weak) id<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate,CommonMultiTableViewDelegate> delegate;

@end



@implementation CommonMultiTableView


- (instancetype)initWithFrame:(CGRect)frame delegate:(id<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate,CommonMultiTableViewDelegate>)delegate
{
    if (self = [super initWithFrame:frame]) {
        self.tableViewCount = 1;
        self.backgroundColor = [UIColor whiteColor];
        self.delegate = delegate;
        
        [self initTabelView];
    }
    return self;
}

- (void)initTabelView
{
    if (_bgCollectionView) {
        [_bgCollectionView removeFromSuperview];
        _bgCollectionView = nil;
    }
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    if (kAutolayout_Method == NO) {
        flowLayout.itemSize = CGSizeMake(self.width, self.height);
        _bgCollectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    }else {
        _bgCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    }
    [self addSubview:_bgCollectionView];
    
    _bgCollectionView.backgroundColor = kBgColor;
    _bgCollectionView.bounces = NO;
    _bgCollectionView.scrollsToTop = NO;
    _bgCollectionView.pagingEnabled = YES;
    _bgCollectionView.delegate = self;
    _bgCollectionView.dataSource = self;
    _bgCollectionView.showsVerticalScrollIndicator = NO;
    _bgCollectionView.showsHorizontalScrollIndicator = NO;
    
    [_bgCollectionView registerClass:[CommonTableViewCell class] forCellWithReuseIdentifier:reuseID_TableViewCell];
    [_bgCollectionView registerClass:[CommonWebViewCell class] forCellWithReuseIdentifier:reuseID_WebViewCell];
    
    if (kAutolayout_Method) {
        WS(weakSelf)
        [_bgCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf);
        }];
    }
}

- (UIActivityIndicatorView *)indicatorView
{
    if (_indicatorView) {
        if (!kAutolayout_Method) {
            _indicatorView.center = CGPointMake(self.width*0.5, self.height*0.5);
        }
        [self bringSubviewToFront:_indicatorView];
        return _indicatorView;
    }
    
    if (kAutolayout_Method) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectZero];
        [_indicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _indicatorView.color = [UIColor colorWithWhite:0 alpha:0.8];
        [self addSubview:_indicatorView];
        
        WS(weakSelf)
        [_indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(weakSelf);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
    }else {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        _indicatorView.center = CGPointMake(self.width*0.5, self.height*0.5);
        [_indicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _indicatorView.color = [UIColor colorWithWhite:0 alpha:0.8];
        
        [self addSubview:_indicatorView];
    }

    return _indicatorView;
}

#pragma mark - UICollectionView DataSource And Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _tableViewCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cellTypeForIndex:)]) {
        
        TableViewCellType type = [self.delegate cellTypeForIndex:indexPath.row];
        
        if (type == TableViewCellTypeWebView) {
            CommonWebViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseID_WebViewCell forIndexPath:indexPath];
            if (!kAutolayout_Method) {
                cell.webView.frame = CGRectMake(0, 0, self.width, self.height);
            }
            cell.webView.delegate = self.delegate;
            cell.webView.scrollView.delegate = self.delegate;
            cell.webView.tag = indexPath.row;
            cell.webView.scrollView.tag = indexPath.row;
            if (self.delegate && [self.delegate respondsToSelector:@selector(webViewSetting:forIndex:)]) {
                [self.delegate webViewSetting:cell.webView forIndex:indexPath.row];
            }
            
            return cell;
        }
    }
    
    CommonTableViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseID_TableViewCell forIndexPath:indexPath];
    if (!kAutolayout_Method)  cell.tableView.frame = CGRectMake(0, 0, self.width, self.height);
    cell.tableView.tag = indexPath.row;
    cell.tableView.delegate = self.delegate;
    cell.tableView.dataSource = self.delegate;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableViewSetting:forIndex:)]) {
        [self.delegate tableViewSetting:cell.tableView forIndex:indexPath.row];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return collectionView.viewSize;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[CommonTableViewCell class]]) {
        self.indicatorViewHidden = YES;
        
        MYTableView *tableView = ((CommonTableViewCell *)cell).tableView;
        tableView.scrollsToTop = YES;
        
        if (kAutolayout_Method) {
            WS(weakSelf)
            [tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.and.bottom.equalTo(tableView.superview);
                make.top.equalTo(weakSelf);
            }];
        } else {
            tableView.frame = CGRectMake(0, 0, self.width, self.height);
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(willShowContentView:)]) {
            [self.delegate willShowContentView:tableView];
        }
        
        [tableView reloadData];
    }else if ([cell isKindOfClass:[CommonWebViewCell class]]) {
        UIWebView *webView = ((CommonWebViewCell *)cell).webView;
        webView.scrollView.scrollsToTop = YES;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(webViewUrlForIndex:)]) {
            ((CommonWebViewCell *)cell).url = [self.delegate webViewUrlForIndex:indexPath.row];
        }
        
        if (kAutolayout_Method) {
            WS(weakSelf)
            [webView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.and.bottom.equalTo(webView.superview);
                make.top.equalTo(weakSelf);
            }];
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(willShowContentView:)]) {
            [self.delegate willShowContentView:webView];
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[CommonTableViewCell class]]) {
        ((CommonTableViewCell *)cell).tableView.scrollsToTop = NO;
    }else if ([cell isKindOfClass:[CommonWebViewCell class]]) {
        ((CommonWebViewCell *)cell).webView.scrollView.scrollsToTop = NO;
    }
}

#pragma mark - 代理方法

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetX = scrollView.contentOffset.x;
    CGFloat position = offsetX / (NSInteger)scrollView.width;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableViewDidScrollHorizontally:)]) {
        [_delegate tableViewDidScrollHorizontally:position];
    }
}


- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self tableViewScrollToTop:NO];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger currentIndex = scrollView.contentOffset.x / (NSInteger)scrollView.width;
    if (self.currentIndex == currentIndex) {
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableViewDidEndScrollToIndex:forCell:)]) {
        UICollectionViewCell *cell = [_bgCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:currentIndex inSection:0]];
        [_delegate tableViewDidEndScrollToIndex:currentIndex forCell:cell];
    }
    self.currentIndex = currentIndex;
}


#pragma mark - Other Methods

- (void)setFrame:(CGRect)frame
{
    if (CGRectEqualToRect(frame,self.frame)) {
        return;
    }
    super.frame = frame;
    
    ((UICollectionViewFlowLayout *)(_bgCollectionView.collectionViewLayout)).itemSize = self.viewSize;
    
    for (UIView *subView in self.subviews) {
        subView.frame = CGRectMake(0, 0, self.width, self.height);
    }
    
    [_bgCollectionView reloadData];
}

- (void)updateFrame:(CGRect)frame
{
    self.frame = frame;
}

- (void)reloadData
{
    [_bgCollectionView reloadData];
}

- (void)reloadDataForIndex:(NSInteger)index
{
    if (_tableViewCount==0 || index < 0 || index >= [_bgCollectionView numberOfItemsInSection:0]) {
        return;
    }
    
    UICollectionViewCell *cell = [_bgCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    if ([cell isKindOfClass:[CommonTableViewCell class]]) {
        [((CommonTableViewCell *)cell).tableView reloadData];
    }else if ([cell isKindOfClass:[CommonWebViewCell class]]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(cellTypeForIndex:)] && [self.delegate cellTypeForIndex:index]==TableViewCellTypeWebView) {
            if ([(CommonWebViewCell *)cell url].length > 0) {
                UIWebView *webView = ((CommonWebViewCell *)cell).webView;
                if (webView.isLoading) { [webView stopLoading]; }
                [webView reload];
            }else {
                [self reloadData];
            }
        }
    }
}

- (void)endHeaderRefresh
{
    UICollectionViewCell *cell = [_bgCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0]];
    if ([cell isKindOfClass:[CommonTableViewCell class]]) {
        [((CommonTableViewCell *)cell).tableView.header endRefreshing];
    }else if ([cell isKindOfClass:[CommonWebViewCell class]]) {
        [((CommonWebViewCell *)cell).webView.scrollView.header endRefreshing];
    }
}

- (void)endFooterRefresh
{
    UICollectionViewCell *cell = [_bgCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0]];
    if ([cell isKindOfClass:[CommonTableViewCell class]]) {
        [((CommonTableViewCell *)cell).tableView.footer endRefreshing];
    }else if ([cell isKindOfClass:[CommonWebViewCell class]]) {
        [((CommonWebViewCell *)cell).webView.scrollView.footer endRefreshing];
    }
}

- (void)endLoadDataForIndex:(NSInteger)index
{
    if ([ToolClass dataIsValid:index forArrayCount:_tableViewCount]) {
        UICollectionViewCell *cell = [_bgCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        if ([cell isKindOfClass:[CommonTableViewCell class]]) {
            [((CommonTableViewCell *)cell).tableView.header endRefreshing];
            [((CommonTableViewCell *)cell).tableView.footer endRefreshing];
        }else if ([cell isKindOfClass:[CommonWebViewCell class]]) {
            [((CommonWebViewCell *)cell).webView stopLoading];
        }
    }
}

- (void)tableViewChangeToIndex:(NSInteger)index animated:(BOOL)animated
{
    if (self.currentIndex != index && [ToolClass dataIsValid:index forArrayCount:_tableViewCount]) {
        [_bgCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:animated];
        self.currentIndex = index;
    }
}

- (void)updateTableStatusForNoData:(NSString *)notice withBlock:(IndexBlock)block
{
    NoDataPromptStyle style = NoDataPromptStyleClickRefreshForNoContent;
    if (self.delegate && [self.delegate respondsToSelector:@selector(promptStyleOfRequestDidFailForIndex:)]) {
        style = [self.delegate promptStyleOfRequestDidFailForIndex:self.currentIndex];
    }
    
    [self tableViewScrollToTop:NO];
    
    [self removeNoticeView];
    
    
    NoDataNoticeView *noticeView = [NoDataNoticeView noticeViewWithFrame:CGRectMake(_currentIndex*_bgCollectionView.width, 0, _bgCollectionView.width, _bgCollectionView.height) bgColor:kBgColor message:notice promptStyle:style callbackBlock:^(id object, NSInteger index, BOOL isSameIndex) {
        
        if (block) {
            block(object, index, isSameIndex);
        }
    }];
    [_bgCollectionView addSubview:noticeView];
}

- (void)removeNoticeView
{
    for (UIView *subView in _bgCollectionView.subviews) {
        if ([subView isKindOfClass:[NoDataNoticeView class]] || [subView isKindOfClass:[FBButton class]]) {
            [subView removeFromSuperview];
        }
    }
}

- (void)removeNoticeViewForView:(UIView *)view
{
    for (UIView *subView in view.subviews) {
        if ([subView isKindOfClass:[NoDataNoticeView class]] || [subView isKindOfClass:[FBButton class]]) {
            [subView removeFromSuperview];
        }
    }
}

- (UIView *)getCurrentShowView
{
    UICollectionViewCell *cell = [_bgCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0]];
    if ([cell isKindOfClass:[CommonTableViewCell class]]) {
        return ((CommonTableViewCell *)cell).tableView;
    }else {
        return ((CommonWebViewCell *)cell).webView;
    }
}


- (MYTableView *)getCurrentShowTableView
{
    UICollectionViewCell *cell = [_bgCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0]];
    if ([cell isKindOfClass:[CommonTableViewCell class]]) {
        return ((CommonTableViewCell *)cell).tableView;
    }
    return nil;
}

- (UIWebView *)getCurrentShowWebView
{
    UICollectionViewCell *cell = [_bgCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0]];
    if ([cell isKindOfClass:[CommonWebViewCell class]]) {
        return ((CommonWebViewCell *)cell).webView;
    }
    return nil;
}


- (void)tableViewScrollToTop:(BOOL)animated
{
    MYTableView *tableView = [self getCurrentShowTableView];
    if (tableView) {
        [tableView setContentOffset:CGPointMake(0, -tableView.contentInset.top) animated:animated];
    }else {
        UIWebView *webView = [self getCurrentShowWebView];
        if (webView) {
            [webView.scrollView setContentOffset:CGPointZero animated:animated];
        }
    }
}

- (void)setIndicatorViewHidden:(BOOL)indicatorViewHidden
{
    _indicatorViewHidden = indicatorViewHidden;
    _indicatorView.hidden = indicatorViewHidden;
}

- (void)startIndicatorAnimating
{
    self.indicatorViewHidden = NO;
    [self.indicatorView startAnimating];
}

- (void)stopIndicatorAnimating
{
    [self.indicatorView stopAnimating];
    self.indicatorViewHidden = YES;
    [_indicatorView removeFromSuperview];
    _indicatorView = nil;
}


- (void)receiveMemoryWarning
{
    
}


@end






/*      ——————————————————————     CommonWebViewCell     ——————————————————————     */

@implementation CommonWebViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    
    if (self = [super initWithFrame:frame])
    {
        self.contentView.backgroundColor = [UIColor clearColor];
        self.webView = [UIWebView new];
        _webView.backgroundColor = kBgColor;
        _webView.scrollView.backgroundColor = kBgColor;
        _webView.scalesPageToFit = YES;
        [self.contentView addSubview:_webView];
        
        if (kAutolayout_Method) {
            WS(weakSelf)
            [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.right.and.bottom.equalTo(weakSelf.contentView);
                make.top.equalTo(weakSelf.contentView);
            }];
        }
    }
    return self;
}
- (void)setUrl:(NSString *)url
{
    if (url.length) {
        if ([url isEqualToString:_url]) {
            
        }else {
            if ([_webView isLoading]) [_webView stopLoading];
            
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
            [self.webView loadRequest:request];
        }
    }
    
    _url = url;
}
@end


/*      ——————————————————————     CommonTableViewCell     ——————————————————————     */



@implementation CommonTableViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    
    if (self = [super initWithFrame:frame])
    {
        self.contentView.backgroundColor = [UIColor clearColor];
        self.tableView = [MYTableView new];
        self.tableView.backgroundColor = kBgColor;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.contentView addSubview:_tableView];
        
        if (kAutolayout_Method) {
            WS(weakSelf)
            [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(weakSelf.contentView);
            }];
        }
    }
    
    return self;
}
@end
