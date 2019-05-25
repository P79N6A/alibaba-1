//
//  PersonalSettingViewController.m
//  CultureHongshan
//
//  Created by ct on 15/11/13.
//  Copyright © 2015年 CT. All rights reserved.
//

#import "PersonalSettingViewController.h"
#import "CacheServices.h"

// ViewControllers
#import "SettingHeadPortraitViewController.h"//拍照或者上传本地图片作为头像的选择视图

#import "SettingNickNameViewController.h"//设置昵称
#import "SettingSexViewController.h"//设置性别
#import "SettingPhoneViewController.h"//第三方账号设置（绑定）手机号
#import "LocationViewController.h"//设置地区

#import "PasswordModifyViewController.h"//修改密码
#import "LogoutViewController.h"//退出登录

#import "PersonalSettingCell.h"
#import "UserDataCacheTool.h"


#define TIPS_NOPHONE    @"未填写手机号"

static NSString *reuseID_Cell = @"Cell";
static NSString *reuseID_HeaderView = @"HeaderView";


@interface PersonalSettingViewController ()<UITableViewDataSource,UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;

@end



@implementation PersonalSettingViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    [self refreshTableData];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"个人设置";
    
    self.view.backgroundColor = kBgColor;
    
    
    [self setupTableView];
}


- (void)refreshTableData
{
    [self initDataArray];
    [_tableView reloadData];
}

- (void)initDataArray
{
    if (_dataArray)
    {
        self.dataArray = nil;
    }
    _dataArray = [NSMutableArray new];
    User *user = [UserService sharedService].user;
    
    //第0区
    NSMutableArray *sectionArray1 = [NSMutableArray new];
    PersonalSettingModel *model = [PersonalSettingModel new];
    model.leftTitle = @"头像";
    model.imageUrl = user.userHeadImgUrl;
    [sectionArray1 addObject:model];
    [_dataArray addObject:sectionArray1];
    
    //第1区
    NSMutableArray *sectionArray2 = [NSMutableArray new];
    
    //昵称
    model = [PersonalSettingModel new];
    model.leftTitle = @"昵称";
    model.rightTitle = user.userNameFull;
    [sectionArray2 addObject:model];
    
    //性别
    model = [PersonalSettingModel new];
    model.leftTitle = @"性别";
    model.rightTitle = (user.userSex == 2) ? @"女" : @"男";
    [sectionArray2 addObject:model];
    
    //手机
    model = [PersonalSettingModel new];
    model.leftTitle = @"手机";
    model.rightTitle = user.userTelephone;
    if (model.rightTitle.length < 1 || model.rightTitle == nil) {
        model.rightTitle = user.userMobileNo;
    }
    if (model.rightTitle.length < 1 || model.rightTitle == nil) {
        model.rightTitle = TIPS_NOPHONE;
    }
    [sectionArray2 addObject:model];
        
    [_dataArray addObject:sectionArray2];
    
    //第2区
    NSMutableArray *sectionArray3 = [NSMutableArray new];
    
    //清除缓存
    model = [PersonalSettingModel new];
    model.leftTitle = @"清除缓存";
    model.rightTitle = [NSString stringWithFormat:@"%.2fM",[[SDImageCache sharedImageCache] getSize]/(1024*1024.0)];
    [sectionArray3 addObject:model];
    
    //修改密码
    model = [PersonalSettingModel new];
    model.leftTitle = @"修改密码";
    LoginType loginType = [UserService sharedService].loginType;
    if (loginType == LoginTypeWenHuaYun || loginType == LoginTypeWenHuaYunDynamic) {
        model.rightTitle = @"修改";
    }else{
        model.rightTitle = @"不支持修改";
    }
    [sectionArray3 addObject:model];
    
    //退出登录
    model = [PersonalSettingModel new];
    model.leftTitle = @"退出登录";
    model.rightTitle = @"已登录";
    [sectionArray3 addObject:model];
    
    [_dataArray addObject:sectionArray3];
}

- (void)setupTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.backgroundColor = kBgColor;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.sectionHeaderHeight = 0;
    _tableView.sectionFooterHeight = 0;
    [self.view addSubview:_tableView];
    
    [_tableView registerClass:[PersonalSettingCell class] forCellReuseIdentifier:reuseID_Cell];
    [_tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:reuseID_HeaderView];
    
    [_tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}



- (void)navigationLeftButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray[section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PersonalSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID_Cell forIndexPath:indexPath];
    PersonalSettingModel *model = _dataArray[indexPath.section][indexPath.row];
    [cell setModel:model forIndexPath:indexPath];
    if(indexPath.row == 2 && indexPath.section == 1 && ![model.rightTitle isEqualToString:TIPS_NOPHONE])
    {//手机不显示箭头
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell hiddenIndicatorArrow];
    }
    return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:reuseID_HeaderView];
    if (!headerView)
    {
        headerView = [[UITableViewHeaderFooterView alloc] init];
        headerView.contentView.backgroundColor = RGB(238, 244, 247);
    }
    return headerView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 100;
    }else{
        return 50;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    }else{
        return 8;
    }
}

//  选取图片的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    [self uploadHeaderImage:[image orientationFixedImage]];
}



#pragma mark - 单元格点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0)
    {
        // 设置头像
        WS(weakSelf)
        [WHYAlertActionUtil showActionSheetWithTitle:nil msg:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil actionBlock:^(NSInteger index, NSString *buttonTitle) {
            
            if (index==1 && ![UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
                ALERTSHOW(PRIVACY_CAMERA_ALERT)
                return;
            }
            if (index==2 && ![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                ALERTSHOW(PRIVACY_PHOTO_LIBRARY_ALERT)
                return;
            }
            
            if (index == 1) {
                [weakSelf selectImageFromMobile:UIImagePickerControllerSourceTypeCamera];
            }else if (index == 2) {
                [weakSelf selectImageFromMobile:UIImagePickerControllerSourceTypePhotoLibrary];
            }

        } otherButtonTitles:@"拍照",@"从手机相册选择", nil];
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0){//设置昵称
            SettingNickNameViewController *vc = [[SettingNickNameViewController alloc]init];
            vc.navTitle = @"编辑昵称";
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if (indexPath.row == 1){//设置性别
            WS(weakSelf)
            [WHYAlertActionUtil showActionSheetWithTitle:nil msg:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil actionBlock:^(NSInteger index, NSString *buttonTitle) {
                if (index == 1) { // 男
                    [weakSelf updateUserSexRequestWithBoy:YES];
                }else if (index == 2) { // 女
                    [weakSelf updateUserSexRequestWithBoy:NO];
                }
            } otherButtonTitles:@"男", @"女", nil];
        }
        else if (indexPath.row == 2){//修改手机号
            LoginType type = [UserService sharedService].loginType;
            if (type != LoginTypeWenHuaYun && type != LoginTypeWenHuaYunDynamic) {
                SettingPhoneViewController *vc = [[SettingPhoneViewController alloc]init];
                vc.navTitle = @"修改手机号";
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
        else if (indexPath.row == 3){//地区
            LocationViewController *view = [[LocationViewController alloc]init];
            [self.navigationController pushViewController:view animated:YES];
        }
    }
    else if (indexPath.section == 2)
    {
        if (indexPath.row == 0)//清理缓存
        {
            [SVProgressHUD showWithStatus:@"清理中..."];
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
            
            // 统一的清除缓存的方法
            [CacheServices clearAllCacheData];
            
            WS(weakSelf)
            [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
                [SVProgressHUD showSuccessWithStatus:@"清除完成"];
                
                // 重新下载启动页图片
                NSString *oldImageUrl = [ToolClass getDefaultValue:kUserDefault_LaunchImageURL];
                if (oldImageUrl.length) {
                    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:oldImageUrl] options:SDWebImageDownloaderLowPriority progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                    }];
                }
                
                PersonalSettingModel *model = weakSelf.dataArray[indexPath.section][indexPath.row];
                model.rightTitle = @"0.0M";
                [weakSelf.tableView reloadData];
            }];
        }
        else if (indexPath.row == 1)//修改密码
        {
            LoginType type = [UserService sharedService].loginType;
            if (type == LoginTypeWenHuaYun || type == LoginTypeWenHuaYunDynamic)
            {
                PasswordModifyViewController *vc = [PasswordModifyViewController new];
                vc.navTitle = @"修改密码";
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
        else if (indexPath.row == 2){// 退出登录
            WS(weakSelf)
            [WHYAlertActionUtil showActionSheetWithTitle:@"" msg:@"" cancelButtonTitle:@"取消" destructiveButtonTitle:nil actionBlock:^(NSInteger index, NSString *buttonTitle) {
                if (index == 1) {
                    [CacheServices clearCacheDataWhenLogout];
                    [ToolClass settingActivityListNeedUpdate];
                    [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                }
            } otherButtonTitles:@"退出登录", nil];
        }
    }
}





#pragma mark - 子页面的一些方法


- (void)selectImageFromMobile:(UIImagePickerControllerSourceType)type
{
    UIImagePickerController *imagePickerViewController = [[UIImagePickerController alloc] init];
    imagePickerViewController.delegate = self;
    imagePickerViewController.sourceType = type;
    imagePickerViewController.allowsEditing = YES;
    [self presentViewController:imagePickerViewController animated:YES completion:nil];
}

// 上传用户的头像
- (void)uploadHeaderImage:(UIImage *)image
{
    [SVProgressHUD showWithStatus:@"上传头像中..."];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    
    WS(weakSelf);
    [ProtocolBased uploadFileWithType:FileUploadTypeUserHeaderImage image:image dataId:nil progressBlock:nil responseBlock:^(HttpResponseCode responseCode, id responseObject) {
        
        if (responseCode == HttpResponseSuccess) {
            [SVProgressHUD showSuccessWithStatus:@"头像上传成功"];
            User *aUser = [UserService sharedService].user;
            aUser.userHeadImgUrl = responseObject;
            [UserService saveUser:aUser];
            
            [weakSelf refreshTableData];
        }else {
            [SVProgressHUD showInfoWithStatus:responseObject];
        }
    }];
}

// 设置性别
- (void)updateUserSexRequestWithBoy:(BOOL)isBoy
{
    User *aUser = [UserService sharedService].user;
    aUser.userSex = isBoy ? 1 : 2;
    [UserService saveUser:aUser];
    
    // 不用管修改是否成功
    [AppProtocol updateUserInfoWithUserId:aUser.userId userName:nil userSex:StrFromInt(aUser.userSex) userTelephone:nil userArea:nil UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        if (responseCode == HttpResponseSuccess) {
            
        }else {
//            [SVProgressHUD showInfoWithStatus:@"修改性别失败!"];
        }
    }];
    
    [self refreshTableData];
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
