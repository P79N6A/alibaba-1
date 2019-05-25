//
//  CommonMultiTableView.h
//  CultureHongshan
//
//  Created by JackAndney on 16/7/28.
//  Copyright © 2016年 ct. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYTableView.h"

@protocol CommonMultiTableViewDelegate;


typedef enum : NSUInteger {
    TableViewCellTypeUnknown = 0,
    TableViewCellTypeTableView,
    TableViewCellTypeWebView,
} TableViewCellType;


@interface CommonMultiTableView : UIView

@property (nonatomic, assign) NSUInteger tableViewCount;//默认值为1
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign,getter=isIndicatorViewHidden) BOOL indicatorViewHidden;// Web View加载指示条


-(instancetype)initWithFrame:(CGRect)frame delegate:(id<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate,CommonMultiTableViewDelegate>)delegate;


- (void)tableViewScrollToTop:(BOOL)animated;
- (MYTableView *)getCurrentShowTableView;
- (UIWebView *)getCurrentShowWebView;
- (UIView *)getCurrentShowView;

- (void)reloadData;
- (void)reloadDataForIndex:(NSInteger)index;
- (void)tableViewChangeToIndex:(NSInteger)index animated:(BOOL)animated;
- (void)updateTableStatusForNoData:(NSString *)notice withBlock:(IndexBlock)block;
- (void)removeNoticeView;

- (void)endHeaderRefresh;
- (void)endFooterRefresh;
- (void)endLoadDataForIndex:(NSInteger)index;

- (void)startIndicatorAnimating;
- (void)stopIndicatorAnimating;

- (void)receiveMemoryWarning;


@end




@protocol CommonMultiTableViewDelegate <NSObject>

@optional
/**
 *  表视图的有关设置：单元格的注册、设置刷新控件等
 *
 *  @param tableView 表视图
 *  @param index     第几个表
 */
- (void)tableViewSetting:(UITableView *)tableView forIndex:(NSInteger)index;

/**
 *  WebView的设置
 *
 *  @param webView 需要设置的WebView
 *  @param index   WebView索引
 */
- (void)webViewSetting:(UIWebView *)webView forIndex:(NSInteger)index;

/**
 *  获取底部CollectionView的单元格的类型
 *
 *  @param index 第几个单元格
 *
 *  @return 单元格类型
 */
- (TableViewCellType)cellTypeForIndex:(NSInteger)index;// 默认为：TableViewCellTypeTableView

// 目前未实现
- (NoDataPromptStyle)promptStyleOfRequestDidFailForIndex:(NSInteger)index;//数据加载失败时的提示风格，默认为NoDataPromptStyleClickRefresh

- (NSString *)webViewUrlForIndex:(NSInteger)index;
- (void)tableViewDidEndScrollToIndex:(NSInteger)index forCell:(UICollectionViewCell *)cell;
- (void)tableViewDidScrollHorizontally:(CGFloat)position;


/**
 将要显示单元格视图调用的方法

 @param contentView UITableView或UIWebView
 */
- (void)willShowContentView:(UIView *)contentView;


@end








@interface CommonWebViewCell : UICollectionViewCell
@property (nonatomic,copy) NSString *url;
@property (nonatomic, strong) UIWebView *webView;
@end

@interface CommonTableViewCell : UICollectionViewCell
@property (nonatomic, strong) MYTableView *tableView;
@property (nonatomic, assign) BOOL isSetting;
@end

