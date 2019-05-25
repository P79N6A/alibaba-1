//
//  MyMessageListViewController.m
//  CultureHongshan
//
//  Created by ct on 15/11/12.
//  Copyright © 2015年 CT. All rights reserved.
//

#import "MyMessageListViewController.h"
#import "MessageListCell.h"

#import "UserMessage.h"

#import "MyMessageDetailViewController.h"



static NSString *reuseId_Cell = @"Cell";


@interface MyMessageListViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) UITableView *tableView;


@end


@implementation MyMessageListViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"我的消息";
    self.view.backgroundColor = kBgColor;
    _dataArray = [NSMutableArray new];
    
    [self startRequestMessageData:YES];
}





#pragma mark - —————— 数据请求 ——————

- (void)startRequestMessageData:(BOOL)isClearData
{
    [SVProgressHUD showLoading];
    
    WS(weakSelf);
    [AppProtocol getUserMessageWithUserId:[UserService sharedService].userId UsingBlock:^(HttpResponseCode responseCode, id responseObject)
     {
         if (responseCode == HttpResponseSuccess) {
             if ([responseObject count]) {
                 _dataArray = [NSMutableArray arrayWithArray:responseObject];
                 [weakSelf initTableView];
             }else{
                 [weakSelf noMessageNotice:@"暂无消息!"];
             }
             [SVProgressHUD dismiss];
         }else{
             if ([responseObject isKindOfClass:[NSString class]]) {
                 [weakSelf noMessageNotice:responseObject];
             }else{
                 [weakSelf noMessageNotice:@"网络开小差了^_^!"];
             }
             [SVProgressHUD dismiss];
         }
     }];
}

- (void)deleteUserMessageRequestWithIndex:(NSInteger)index
{
    [SVProgressHUD showWithStatus:@"请稍等..."];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    
    WS(weakSelf);
    UserMessage *model = _dataArray[index];
    
    [AppProtocol userMessageDeleteWithMsgId:model.messageId UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        if (responseCode == HttpResponseSuccess) {
            [_dataArray removeObjectAtIndex:index];
            if (_dataArray.count < 1) {//消息删除完了
                [weakSelf noMessageNotice:@"已经没有消息了"];
            }else {
                [_tableView reloadData];
            }
            [SVProgressHUD dismiss];
        } else {
            [SVProgressHUD showErrorWithStatus:(NSString *)responseObject];
        }
    }];
}



#pragma mark - —————— init UI ——————




- (void)initTableView
{
    if (_tableView) {
        [_tableView reloadData];
        return;
    }
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.backgroundColor = kBgColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    [_tableView registerClass:[MessageListCell class] forCellReuseIdentifier:reuseId_Cell];
    
    [_tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger number = 0;
    if (_dataArray.count) {
        number = _dataArray.count*2+1;//偶数行为灰色的分割线单元格
    }
    return number;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row%2)
    {
        MessageListCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId_Cell forIndexPath:indexPath];
        
        [cell setModel:_dataArray[(indexPath.row-1)/2] forIndexPath:indexPath];
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LineCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LineCell"];
            cell.contentView.backgroundColor = RGBA(239, 242, 244, 1);
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row%2) {
        UserMessage *model = _dataArray[(indexPath.row-1)/2];
        
        return 10+40+10+[UIToolClass textHeight:model.messageContent font:FontSystem(14) width:kScreenWidth-20 maxRow:4]+10;
    }else{
        return 8;
    }
}


//进入消息详情页面
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row%2)
    {
        UserMessage *model = _dataArray[(indexPath.row-1)/2];
        MyMessageDetailViewController *vc = [MyMessageDetailViewController new];
        vc.model = model;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.row%2 ? YES : NO;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSInteger index = (indexPath.row-1)/2;
        [self deleteUserMessageRequestWithIndex:index];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {}
}



//无消息时的提示
- (void)noMessageNotice:(NSString *)message
{
    WS(weakSelf);
    
    NoDataNoticeView *noticeView = [NoDataNoticeView noticeViewWithFrame:CGRectMake(0, 0, kScreenWidth, HEIGHT_TOP_BAR-HEIGHT_HOME_INDICATOR) bgColor:[UIColor whiteColor] message:message promptStyle:NoDataPromptStyleClickRefreshForError callbackBlock:^(id object, NSInteger index, BOOL isSameIndex) {
        [weakSelf startRequestMessageData:YES];
    }];
    [self.view addSubview:noticeView];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
