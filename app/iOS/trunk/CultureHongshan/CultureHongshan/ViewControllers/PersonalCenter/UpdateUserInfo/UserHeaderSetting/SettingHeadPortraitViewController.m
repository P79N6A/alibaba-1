//
//  SettingHeadPortraitViewController.m
//  CultureHongshan
//
//  Created by ct on 16/5/18.
//  Copyright © 2016年 CT. All rights reserved.
//

#import "SettingHeadPortraitViewController.h"

@interface SettingHeadPortraitViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

@implementation SettingHeadPortraitViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initSubviews];
    
}



//上传头像
- (void)uploadImage:(UIImage *)image
{
    [SVProgressHUD showWithStatus:@"上传头像中..."];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    
    WS(weakSelf);
    [ProtocolBased uploadFileWithType:FileUploadTypeUserHeaderImage image:image dataId:nil progressBlock:nil responseBlock:^(HttpResponseCode responseCode, id responseObject) {
        
        if (responseCode == HttpResponseSuccess) {
            [SVProgressHUD showSuccessWithStatus:@"头像上传成功"];
            [weakSelf updateUserheaderSuccess:responseObject];
        }else {
            [SVProgressHUD showErrorWithStatus:responseObject];
        }
    }];
}

- (void)updateUserheaderSuccess:(NSString *)headImageUrl
{
    User *aUser = [UserService sharedService].user;
    aUser.userHeadImgUrl = headImageUrl;
    [UserService saveUser:aUser];
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)initSubviews
{
    CGFloat btnHeight = 47;
    UIColor *color = [UIToolClass colorFromHex:@"6F7179"];
    
    //取消按钮
    UIButton *cancleButton = [[UIButton alloc] initWithFrame:CGRectMake(0, kScreenHeight-btnHeight, kScreenWidth, btnHeight)];
    cancleButton.backgroundColor = [UIColor whiteColor];
    cancleButton.titleLabel.font = FontYT(18);
    [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancleButton setTitleColor:color forState:UIControlStateNormal];
    [cancleButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgImgView addSubview:cancleButton];
    
    for (int i = 0; i < 2; i++)
    {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, cancleButton.originalY-20-btnHeight-i*(btnHeight+0.7), kScreenWidth, btnHeight)];
        button.tag = i+1;
        button.backgroundColor = [UIColor whiteColor];
        button.titleLabel.font = FontYT(18);
        if (i < 1) {
            [button setTitle:@"从手机相册选择" forState:UIControlStateNormal];
        }else{
            [button setTitle:@"拍照" forState:UIControlStateNormal];
        }
        [button setTitleColor:color forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgImgView addSubview:button];
    }
}



- (void)buttonClick:(UIButton *)sender
{
    switch (sender.tag) {
        case 0://取消
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        case 1:// 从手机相册选取
        {
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                ALERTSHOW(PRIVACY_PHOTO_LIBRARY_ALERT)
                return;
            }
            
            [self selectImage:UIImagePickerControllerSourceTypePhotoLibrary];
        }
            break;
        case 2://拍照
        {
            if (![UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
                ALERTSHOW(PRIVACY_CAMERA_ALERT)
                return;
            }
            
            [self selectImage:UIImagePickerControllerSourceTypeCamera];
        }
            break;
            
        default:
            break;
    }
}


- (void)selectImage:(UIImagePickerControllerSourceType)type
{
    UIImagePickerController *imagePickerViewController = [[UIImagePickerController alloc] init];
    imagePickerViewController.delegate = self;
    imagePickerViewController.sourceType = type;
    imagePickerViewController.allowsEditing = YES;
    [self presentViewController:imagePickerViewController animated:YES completion:nil];
}


#pragma mark - 选取图片的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    [self uploadImage:[image orientationFixedImage]];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
