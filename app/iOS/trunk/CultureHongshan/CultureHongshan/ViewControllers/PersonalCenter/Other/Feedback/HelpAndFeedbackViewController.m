//
//  HelpAndFeedbackViewController.m
//  CultureHongshan
//
//  Created by ct on 15/11/12.
//  Copyright © 2015年 CT. All rights reserved.
//

#import "HelpAndFeedbackViewController.h"
#import "AppProtocolMacros.h"

#import "ZYQAssetPickerController.h"
#import "WebViewController.h"
#import "MYTextInputView.h"

#define kMaxContentLength 200
#define kMinTag           30
#define kPageMargin       10
#define kMaxSelectNum     3

@interface HelpAndFeedbackViewController ()<MYTextInputViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate, ZYQAssetPickerControllerDelegate>
{
    MYTextView *_inputView;
    UIView *_photoContainerView;
    UIButton *_addPhotoBtn;
    
    UILabel *_numberLabel;//还可以输入多少字
    
    NSMutableArray *_photoArray;//存放图片
    NSMutableArray *_imageUrlArray;
}

@end


@implementation HelpAndFeedbackViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"帮助与反馈";
    _scrollView.height = kScreenHeight-HEIGHT_TOP_BAR;
    _scrollView.backgroundColor = kBgColor;
    _photoArray = [NSMutableArray arrayWithCapacity:0];
    _imageUrlArray = [NSMutableArray arrayWithCapacity:0];
    
    [self layoutSubviews];
    
    [_scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

- (void)layoutSubviews {
    WS(weakSelf)
    MYSmartButton *lookHelpButton = [[MYSmartButton alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 56) contentLayout:ButtonContentLayoutJustifiedImageRight font:FontSystem(16) actionBlock:^(id sender) {
        WebViewController *webVC = [WebViewController new];
        webVC.url = kHelpCenterUrl;
        webVC.navTitle = @"使用帮助";
        [weakSelf.navigationController pushViewController:webVC animated:YES];
    }];
    lookHelpButton.backgroundColor = [UIColor whiteColor];
    lookHelpButton.leftMargin = 15;
    lookHelpButton.rightMargin = 6;
    [lookHelpButton setTitle:@"使用帮助" forState:UIControlStateNormal];
    [lookHelpButton setTitleColor:kDeepLabelColor forState:UIControlStateNormal];
    [lookHelpButton setImage:IMG(@"icon_arrow_right_gray") forState:UIControlStateNormal];
    [_scrollView addSubview:lookHelpButton];
    
    MYSmartLabel *titleLabel = [[MYSmartLabel alloc] initWithFrame:CGRectMake(15, lookHelpButton.maxY, kScreenWidth-30, 60) text:@"欢迎留下宝贵意见" font:FontSystem(17) color:kDeepLabelColor breakMode:0 maxWidth:0];
    [_scrollView addSubview:titleLabel];
    
    // 输入框
    _inputView = [[MYTextView alloc] initWithFrame:CGRectMake(kPageMargin, titleLabel.maxY+2, kScreenWidth-2*kPageMargin, 180)];
    _inputView.font = FontYT(16);
    _inputView.placeholder = @"您有什么建议,请提给我们";
    _inputView.maxLength = kMaxContentLength;
    _inputView.textColor = kDeepLabelColor;
    _inputView.delegateObject = self;
    _inputView.hideKeyboardWhenTapReturnkey = NO;
    _inputView.radius = 4;
    
    [_scrollView addSubview:_inputView];
    
    //还可以输入多少字
    _numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-200-15, _inputView.maxY+10, 200, [UIToolClass fontHeight:FONT(14)])];
    _numberLabel.font = FontSystem(14);
    _numberLabel.textColor = [UIColor lightGrayColor];
    _numberLabel.textAlignment = NSTextAlignmentRight;
    _numberLabel.text = [NSString stringWithFormat:@"还可以输入%d字",kMaxContentLength];
    [_scrollView addSubview:_numberLabel];
    
    CGFloat imgWidth = 78;
    _photoContainerView = [[UIView alloc] initWithFrame:CGRectMake(_inputView.originalX, _numberLabel.maxY+10, _inputView.width, imgWidth)];
    [_scrollView addSubview:_photoContainerView];
    
    for (int i = 0; i < kMaxSelectNum; i++)
    {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(i*(imgWidth+15), 0, imgWidth, imgWidth)];
        imgView.userInteractionEnabled = YES;
        imgView.tag = kMinTag+i;
        [_photoContainerView addSubview:imgView];
        
        UIButton *removeBtn = [[UIButton alloc] initWithFrame:CGRectMake(imgView.width-18, -6, 24, 24)];
        removeBtn.hidden = YES;
        [removeBtn setBackgroundImage:IMG(@"removeImg") forState:UIControlStateNormal];
        [removeBtn addTarget:self action:@selector(removeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [imgView addSubview:removeBtn];
    }
    
    _addPhotoBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, imgWidth, imgWidth)];
    _addPhotoBtn.hidden  = NO;
    _addPhotoBtn.backgroundColor = [UIColor whiteColor];
    UIImage *bgImage = [ToolClass getDashPlaceholder:IMG(@"sh_icon_addPhoto") viewSize:CGSizeMake(75, 75) centerSize:CGSizeMake(40, 32)];
    [_addPhotoBtn setBackgroundImage:bgImage forState:UIControlStateNormal];
    [_addPhotoBtn addTarget:self action:@selector(addPhotoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_photoContainerView addSubview:_addPhotoBtn];
    
    // 提交按钮
    MYSmartButton *commitButton = [[MYSmartButton alloc] initWithFrame:CGRectMake(kPageMargin, _photoContainerView.maxY+30, kScreenWidth-2*kPageMargin, 45) title:@"提 交" font:FontSystem(16) tColor:COLOR_IWHITE bgColor:kThemeDeepColor actionBlock:^(id sender) {
        [weakSelf commitButtonClick];
    }];
    commitButton.radius = 5;
    [_scrollView addSubview:commitButton];
    
    _scrollView.contentSize = CGSizeMake(_scrollView.width, commitButton.maxY + 40);
}


#pragma mark - 图片上传
- (void)uploadImageForIndex:(NSInteger)index
{
    if (_photoArray.count && index < _photoArray.count)
    {
        UIImage *image = _photoArray[index];
        WS(weakSelf);
        
        [ProtocolBased uploadFileWithType:FileUploadTypeUserFeedbackImage image:image dataId:nil progressBlock:nil responseBlock:^(HttpResponseCode responseCode, id responseObject) {
            
            if (responseCode == HttpResponseSuccess) {
                [_imageUrlArray addObject:responseObject];
            }else {
                FBLOG(@"上传第 %ld 张图片失败",(long)index);
            }
            
            if (index == _photoArray.count - 1) {
                [weakSelf uploadTextAndPicture];
            }else{
                [weakSelf uploadImageForIndex:index+1];
            }
        }];
        
    } else {
        //无需要上传的图片
        [self uploadTextAndPicture];
    }
}

- (void)uploadTextAndPicture
{
    WS(weakSelf);
    [AppProtocol userFeedbackWithFeedContent:MYInputTextHandle(_inputView.text) feedImgUrl:[ToolClass getComponentString:_imageUrlArray combinedBy:@","] feedType:nil UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        
        [SVProgressHUD showProgress:2.0];
        
        if (responseCode == 0) {
            [SVProgressHUD showSuccessWithStatus:responseObject];
            [weakSelf commitSuccess];
        }else {
            [SVProgressHUD showErrorWithStatus:responseObject];
        }
    }];
}


- (void)commitSuccess
{
    _inputView.text = @"";
    [_photoArray removeAllObjects];
    [_imageUrlArray removeAllObjects];
    
    for (UIImageView *imgView in _photoContainerView.subviews) {
        if ([imgView isKindOfClass:[UIButton class]]) {
            [UIView animateWithDuration:0.3f animations:^{
                imgView.originalX = 0;
                imgView.originalY = 0;
            }];
        }else {
            imgView.hidden = YES;
        }
    }
}

#pragma mark -  代理方法

- (void)textInputViewTextDidChange:(MYTextView *)inputView {
    int number  = MAX(kMaxContentLength- (int)inputView.text.length, 0);
    _numberLabel.text = [NSString stringWithFormat:@"还可以输入%d个字",number];
}


// 相册选取图片
- (void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    for (ALAsset *asset in assets) {
        if (_photoArray.count < kMaxSelectNum) {
            UIImage *tempImg = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
            tempImg = [UIImage imageWithData:UIImageJPEGRepresentation(tempImg, 0.65)];
            [_photoArray addObject:tempImg];
        }
    }
    _addPhotoBtn.hidden = NO;
    [self addPhotoImgToArray:_photoArray];
}

// 相机拍照图片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    if (portraitImg == nil) {
        portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    }
    portraitImg = [UIImage imageWithData:UIImageJPEGRepresentation(portraitImg, 0.95)];
    UIImage *adjustedImage = [portraitImg orientationFixedImage];
    if (adjustedImage) {
        [_photoArray addObject:adjustedImage];
        [self addPhotoImgToArray:_photoArray];
    }
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
}


#pragma mark - Button Actions

// 开始选取添加图片
- (void)addPhotoBtnClick:(UIButton *)btn
{
    [_inputView resignFirstResponder];
    
    WS(weakSelf)
    [WHYAlertActionUtil showActionSheetWithTitle:nil msg:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil actionBlock:^(NSInteger index, NSString *buttonTitle) {
        
        if (index == 1) {
            if (![UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
                ALERTSHOW(PRIVACY_CAMERA_ALERT)
                return;
            }
            // 拍照
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = weakSelf;
            imagePicker.allowsEditing = NO;
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [weakSelf presentViewController:imagePicker animated:YES completion:^{}];
            
        }else if (index == 2) {
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                ALERTSHOW(PRIVACY_PHOTO_LIBRARY_ALERT)
                return;
            }
            
            ZYQAssetPickerController *ZYQpicker = [[ZYQAssetPickerController alloc] init];
            ZYQpicker.maxSelePhotoNum = kMaxSelectNum;
            ZYQpicker.maximumNumberOfSelection = kMaxSelectNum- _photoArray.count;
            ZYQpicker.assetsFilter = [ALAssetsFilter allPhotos];
            ZYQpicker.showEmptyGroups = NO;
            ZYQpicker.delegate = weakSelf;
            [self presentViewController:ZYQpicker animated:YES completion:nil];
        }
        
    } otherButtonTitles:@"拍照", @"从手机相册选取", nil];
}

// 删除图片
- (void)removeBtnClick:(UIButton *)btn
{
    //先让所有的图片都不显示
    for (int i=0; i<kMaxSelectNum; i++) {
        UIImageView *imgPhotoView = (UIImageView *)[_photoContainerView viewWithTag:kMinTag+i];
        imgPhotoView.image = nil;
        UIButton *removeBtnPhoto = (UIButton *)imgPhotoView.subviews[0];
        removeBtnPhoto.hidden = YES;
    }
    [_photoArray removeObjectAtIndex:btn.superview.tag-kMinTag];
    [self addPhotoImgToArray:_photoArray];
}

- (void)addPhotoImgToArray:(NSMutableArray *)array
{
    for (int i=0; i < array.count; i++)
    {
        UIImageView *imgView = (UIImageView *)[_photoContainerView viewWithTag:kMinTag+i];
        imgView.image = array[i];
        UIButton *removeBtnPhoto = (UIButton *)imgView.subviews[0];
        removeBtnPhoto.hidden = NO;
    }
    
    UIImageView *imgView = [_photoContainerView viewWithTag:kMinTag+array.count];
    if (imgView) {
        _addPhotoBtn.center = imgView.center;
        _addPhotoBtn.hidden = NO;
    }else{
        _addPhotoBtn.hidden = YES;
    }
}

- (void)commitButtonClick
{
    if ([self userCanOperateAfterLogin]) {
        NSString *content = [_inputView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (content.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"提交的内容不能为空哟！"];
            return;
        }else {
            [SVProgressHUD showWithStatus:@"正在为您提交..."];
            [self uploadImageForIndex:0];
        }
    }
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
