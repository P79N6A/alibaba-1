//
//  CommonTableViewController.h
//  时尚五角场
//
//  Created by 李 兴 on 14-8-13.
//  Copyright (c) 2014年 李 兴. All rights reserved.
//

#import "BasicViewController.h"
#import "MJRefresh.h"
#define HTTPTAG_COMMONTABLEDATA     13551
#define PAGE_START_INDEX   0

typedef enum
{
    FBDIRECTION_UP = 0,
    FBDIRECTION_DOWN = 1,
}DIRECTION;

@interface CommonTableViewController : BasicViewController<UITableViewDataSource,UITableViewDelegate>
{
    __block NSMutableArray * _dataList;
    __block NSMutableDictionary *_cellHeightCache;
    __block UITableView * _tableView;
    int _cellHeight;
    UIButton * _noneDataTipsButton;
    int _pageNo;
    Boolean _haveNextPage;
    Boolean _reloading;
    NSString * _tableDataUrl;
    Boolean _showStatus;
    UITapGestureRecognizer * navtapGesture;
    BOOL _isRefresh;
    float  _lastOffsetY;
    float _lastOffset;
    DIRECTION _direction;
    Boolean _isDragAnimation;

}

@property (nonatomic, copy) NSArray *screenshotImages;

-(void)cleanPageInfo;
-(void)setNoneDataTipsText:(NSString * )tipText;
-(void)noneDataTipsTap;
-(void)reloadTableData;
-(void)updateTableViewStatus;
-(void)loadTableData;
-(void)disablefreshTableCell;
-(void)setShowTableStaus:(Boolean)show;
-(void)checkHavePage:(NSDictionary *)results;
-(Boolean)dataHavePage;
-(Boolean)dataIsValid:(NSUInteger)idx;
-(void)initTableView:(UITableView *)tableview;
- (void)setupRefresh:(UITableView *)tableview;
@end
