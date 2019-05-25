//
//  VenueRelatedActivityViewController.m
//  CultureHongshan
//
//  Created by ct on 16/4/22.
//  Copyright © 2016年 CT. All rights reserved.
//

#import "VenueRelatedActivityViewController.h"
#import "ActivityModel.h"
#import "ActivityDetailViewController.h"


@interface VenueRelatedActivityViewController ()
{
    UIImage *_placeholderImg;
}
@end

@implementation VenueRelatedActivityViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"活动列表";
    
    _placeholderImg = [UIToolClass getPlaceholderWithViewSize:CGSizeMake(300, 200) centerSize:CGSizeMake(35, 35) isBorder:NO];
    
    [self loadTableData];
}

- (void)loadTableData
{
    WS(weakSelf);
    
    [AppProtocol getVenueRelatedActivityListWithVenueId:_venueId pageIndex:_pageNo * kPageSize pageNum:kPageSize cacheMode:CACHE_MODE_REALTIME UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        [_tableView.header endRefreshing];
        [_tableView.footer endRefreshing];
        
        if (responseCode == HttpResponseSuccess) {
            NSArray * ary = (NSArray *)[responseObject lastObject];
            if ([ary count] == 0) {
                if (_dataList.count > 0) {
                    [SVProgressHUD showInfoWithStatus:@"没有更多活动啦!"];
                }
                _haveNextPage = NO;
            } else {
                [_dataList addObjectsFromArray:ary];
            }
            [_tableView reloadData];
        }else {
            
            if ([responseObject isKindOfClass:[NSString class]]) {
                if (_dataList.count) {
                    [SVProgressHUD showErrorWithStatus:responseObject];
                } else {
                    [weakSelf noMessageNotice:responseObject];
                }
            }
        }
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 132;
}


-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    cell.contentView.backgroundColor = COLOR_IGRAY;
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if([self dataIsValid:indexPath.row])
    {
        __weak UITableViewCell * weakCell = cell;
    
        ActivityModel * actModel = _dataList[indexPath.row];
        FBButton * view = [[FBButton alloc] initWithImage:CGRectZero bgcolor:COLOR_IWHITE img:nil clickEvent:^(FBButton *owner) {
        }];
        view.userInteractionEnabled = NO;
        view.tag = 100;
        [cell.contentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.right.equalTo(@0);
            make.size.mas_equalTo(CGSizeMake(WIDTH_SCREEN, 122));
            make.top.equalTo(@0);
        }];
        
        UIImageView  * imgView = [UIImageView new];
        [view addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(@WIDTH_LEFT_SPAN);
            make.size.mas_equalTo(CGSizeMake(136, 88));
            make.centerY.equalTo(weakCell);
        }];
        [imgView sd_setImageWithURL:[NSURL URLWithString:JointedImageURL(actModel.activityIconUrl, kImageSize_300_300)] placeholderImage:_placeholderImg];
        
        // 活动名称
        MYSmartLabel *actNameLabel = [MYSmartLabel al_labelWithMaxRow:2 text:actModel.activityName font:FONT_MIDDLE color:kDeepLabelColor lineSpacing:3];
        [view addSubview:actNameLabel];
        [actNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(160));
            make.top.equalTo(imgView.mas_top);
            make.width.equalTo(@(kScreenWidth-170));
        }];
        
        // 活动类型
        FBLabel * actLabelLabel = [[FBLabel alloc] initWithStyle:CGRectZero font:FONT_SMALL fcolor:kThemeDeepColor text:actModel.activityType];
        [view addSubview:actLabelLabel];
        [actLabelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(@160);
            make.top.equalTo(actNameLabel.mas_bottom).offset(10);
            make.width.equalTo(@(WIDTH_SCREEN - 170));
        }];
        
        // 活动日期
        FBLabel * actDateLabel = [[FBLabel alloc] initWithStyle:CGRectZero font:FONT_SMALL fcolor:kDeepLabelColor text:actModel.showedActivityDate];
        [view addSubview:actDateLabel];
        [actDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@160);
            make.bottom.equalTo(view.mas_bottom).offset(-17);
            make.width.equalTo(@(WIDTH_SCREEN - 170));
        }];
        
        // 活动价格
        FBLabel * actPriceLabel = [[FBLabel alloc] initWithStyle:CGRectZero font:FONT_MIDDLE fcolor:kDeepLabelColor text:actModel.showedPrice];
        [view addSubview:actPriceLabel];
        actPriceLabel.textAlignment = NSTextAlignmentRight;
        [actPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@-10);
            make.centerY.equalTo(actDateLabel);
            make.width.equalTo(@100);
        }];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ActivityModel * actModel = _dataList[indexPath.row];
    
    ActivityDetailViewController *activityDetailVC = [[ActivityDetailViewController alloc] init];
    activityDetailVC.activityId = actModel.activityId;
    [self.navigationController pushViewController:activityDetailVC animated:YES];
}


//无消息时的提示
- (void)noMessageNotice:(NSString *)message
{
    WS(weakSelf);
    
    NoDataNoticeView *noticeView = [NoDataNoticeView noticeViewWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-HEIGHT_TAB_BAR-HEIGHT_HOME_INDICATOR) bgColor:[UIColor whiteColor] message:message promptStyle:NoDataPromptStyleClickRefreshForError callbackBlock:^(id object, NSInteger index, BOOL isSameIndex) {
        [weakSelf loadTableData];
    }];
    [self.view addSubview:noticeView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
