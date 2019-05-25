//
//  PublishCommentViewController.m
//  CultureHongshan
//
//  Created by one on 16/1/25.
//  Copyright © 2016年 CT. All rights reserved.
//

#import "PublishCommentViewController.h"
#import "ZYQAssetPickerController.h"//第三方相册多选


#import "ActivityDetailViewController.h"
#import "VenueDetailViewController.h"

#import "CommentModel.h"
#import "MYImage.h"

#import "MYTextInputView.h"
#import "MYImageContainerView.h"
#import "WebPhotoBrowser.h"


#define kMaxLength      500//最大字数
#define kImgSize        76
#define kBaseTag        100
#define kMaxSelectCount 9





@interface PublishCommentViewController ()<UIActionSheetDelegate, ZYQAssetPickerControllerDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextViewDelegate>
{
    MYTextView *_inputView; // 文本输入框
    MYImageContainerView *_photoContainerView; // 选取图片的容器视图
    
    NSMutableArray<MYImage *> *_imageArray; // 存放图片
    
    CGFloat _imgSize;// 图片的大小
    CGFloat _imgSpacing; // 图片之间的间距
}

@end



@implementation PublishCommentViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    _imageArray = [NSMutableArray arrayWithCapacity:0];
    
    _scrollView.backgroundColor = kBgColor;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    WS(weakSelf)
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
    
    [self initNavigationBar];
    
    [self loadUI];
    
    // 弹出键盘
    [_inputView becomeFirstResponder];
}


- (void)initNavigationBar {
    self.navigationItem.title = @"添加评论";
    
    // 发布
    WS(weakSelf)
    MYSmartButton *publishButton = [[MYSmartButton alloc] initWithFrame:CGRectMake(0, 0, 45, 30) title:@"发布" font:FontSystem(18) tColor:kWhiteColor bgColor:nil actionBlock:^(MYSmartButton *sender) {
        [weakSelf publishButtonClick:sender];
    }];
    publishButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:publishButton];
}


- (void)loadUI {
    
    WS(weakSelf)
    
    _inputView = [MYTextView new];
    _inputView.maxLength = kMaxLength;
    _inputView.font = FONT(14);
    _inputView.textColor = kDeepLabelColor;
    _inputView.textContainerInset = UIEdgeInsetsMake(10, 7, 10, 7);
    _inputView.hideKeyboardWhenTapReturnkey = NO;
    [_inputView setPlaceholder:@"请留下你的评论..." andColor:kPlaceholderColor];
    [_scrollView addSubview:_inputView];
    
    
    // 创建需要的UIImageView
    [self loadImageContainerView];
    
    // 添加约束
    [_photoContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view).offset(10);
        make.right.equalTo(weakSelf.view).offset(-10);
        make.top.equalTo(_inputView.mas_bottom).offset(20);
        make.bottom.equalTo(_scrollView).offset(-50);
    }];
    
    [_inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view);
        make.right.equalTo(weakSelf.view);
        make.top.equalTo(_scrollView);
        make.height.equalTo(_inputView.mas_width).multipliedBy(0.553);
    }];
}

- (void)loadImageContainerView {
    WS(weakSelf)
    
    _photoContainerView = [[MYImageContainerView alloc] initWithFrame:CGRectZero maxImgCount:kMaxSelectCount adjustType:MYImageContainerAdjustTypeSizeFixed tapHandler:^(UIImageView *imgView, NSInteger index) {
        
        // 点击查看大图
        NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:_imageArray.count];
        
        for (MYImage *image in _imageArray) {
            [tmpArray addObject:image.imageObj];
        }
        
        [WebPhotoBrowser photoBrowserWithImageUrlArray:tmpArray currentIndex:index completionBlock:nil];
        
    } longPressHandler:^(UIImageView *imgView, NSInteger index) {
        // 长按图片
        
    } removePhotoHandler:^(UIImageView *imgView, NSInteger index) {
        [weakSelf removePhotoButtonAction:index];
    }];
    
    _photoContainerView.addPhotoActionHandler = ^{
        [weakSelf addPhotoButtonAction];
    };
    _photoContainerView.imgSize = 84;
    _photoContainerView.minValue = 10;
    [_scrollView addSubview:_photoContainerView];
}




#pragma mark - 点击事件


// 添加图片点击事件
- (void)addPhotoButtonAction {
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
            
            // 选取图片
            ZYQAssetPickerController *imagePicker = [[ZYQAssetPickerController alloc] init];
            imagePicker.maximumNumberOfSelection = kMaxSelectCount - _imageArray.count;
            imagePicker.assetsFilter = [ALAssetsFilter allPhotos];
            imagePicker.showEmptyGroups = NO;
            imagePicker.delegate = weakSelf;
            [weakSelf presentViewController:imagePicker animated:YES completion:nil];
        }
        
    } otherButtonTitles:@"拍照", @"从手机相册选取", nil];
}

// 移除图片点击事件
- (void)removePhotoButtonAction:(NSInteger)index {
    [_imageArray removeObjectAtIndex:index];
    
    [_photoContainerView updatePhotoWithImageArray:[self getAllImageObjects]];
}


/** 发布评论 */
- (void)publishButtonClick:(UIButton *)sender {
    
    NSString *commentContent = MYInputTextHandle(_inputView.text);
    if (commentContent.length < 4) {
        [SVProgressHUD showInfoWithStatus:@"评论内容不能少于4个字哟!"]; return;
    }
    
    [SVProgressHUD showWithStatus:@"正在上传..."];
    
    [self uploadImageForIndex:0];
}


#pragma mark - 图片选取

// 相册选取图片
- (void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets {
    
    for (ALAsset *asset in assets) {
        if (_imageArray.count < kMaxSelectCount) {
            UIImage *tempImg = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
            tempImg = [UIImage imageWithData:UIImageJPEGRepresentation(tempImg, 0.95)];

            [_imageArray addObject:[MYImage imageWithLocalURL:asset.defaultRepresentation.url image:tempImg]];
        }else {
            break;
        }
    }
    
    [_photoContainerView updatePhotoWithImageArray:[self getAllImageObjects]];
}

// 相机拍照图片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *tempImg = info[UIImagePickerControllerEditedImage];
    if (tempImg == nil) {
        tempImg = info[UIImagePickerControllerOriginalImage];
    }
    NSURL *imageURL = info[UIImagePickerControllerMediaURL];
    
    // 保存图片至相册
    UIImageWriteToSavedPhotosAlbum(tempImg, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    
    tempImg = [UIImage imageWithData:UIImageJPEGRepresentation([tempImg orientationFixedImage], 0.95)];
    
    if (tempImg) {
        [_imageArray addObject:[MYImage imageWithLocalURL:imageURL image:tempImg]];
        [_photoContainerView updatePhotoWithImageArray:[self getAllImageObjects]];
    }
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

// 保存图片至相册的回调事件
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
}





#pragma mark - 图片上传

- (void)uploadImageForIndex:(NSInteger)index {
    
    if (_imageArray.count && index < _imageArray.count) {
        
        if (_imageArray[index].networkUrl.length > 0) {
            // 如果图片网络链接已存在，不用再上传了
            
            if (index == _imageArray.count - 1) {
                [self beginUploadCommentTextAndPicture]; // 全部上传完毕
            }else {
                [self uploadImageForIndex:index+1]; // 继续下一张
            }
            return;
        }
        
        WS(weakSelf);
        FileUploadType uploadType = (_dataType==DataTypeActivity) ? FileUploadTypeActivityCommentImage : FileUploadTypeVenueCommentImage;
        
        [ProtocolBased uploadFileWithType:uploadType image:_imageArray[index].imageObj dataId:self.modelId progressBlock:nil responseBlock:^(HttpResponseCode responseCode, id responseObject) {
            
            if (responseCode == HttpResponseSuccess) {
                // 上传成功
                _imageArray[index].networkUrl = responseObject;
            }
            
            if (index == _imageArray.count - 1) {
                [weakSelf beginUploadCommentTextAndPicture];
            }else {
                [weakSelf uploadImageForIndex:index+1];
            }
            
        }];
        
    }else {
        // 无需要上传的图片
        [self beginUploadCommentTextAndPicture];
    }
}

// 图片上传完成，开始发布评论
- (void)beginUploadCommentTextAndPicture {
    NSString *textContent = MYInputTextHandle(_inputView.text);
    NSString *imageUrls = [ToolClass getComponentString:[self getAllImageNetworkUrls] combinedBy:@";"];
    
    WS(weakSelf)
    [AppProtocol publishCommentWithDataType:self.dataType modelId:self.modelId commentContent:textContent commentImageUrls:imageUrls commentStarLevel:nil UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        
        if (responseCode == HttpResponseSuccess) {
            
            [SVProgressHUD showProgress:1.5];
            [SVProgressHUD showSuccessWithStatus:@"评论成功！"];
            [weakSelf commentSuccessWithText:textContent imageUrls:imageUrls];
            
        }else {
            [SVProgressHUD showProgress:2.0];
            [SVProgressHUD showInfoWithStatus:responseObject];
        }
        
    }];
}

// 发表评论成功
- (void)commentSuccessWithText:(NSString *)text imageUrls:(NSString * )imageUrls {
    
    User *user = [UserService sharedService].user;
    
    CommentModel *model = [CommentModel new];
    model.commentRemark = MYInputTextHandle(_inputView.text);
    model.commentImgUrl = [[self getAllImageNetworkUrls] componentsJoinedByString:@","];
    model.imageOrUrlStrArray = [self getAllImageObjects];
    model.commentUserNickName = user.userNameFull;
    model.commentTime = [DateTool dateStringForDate:[NSDate date] formatter:@"yyyy.MM.dd HH:mm"];
    model.commentStar = @"0";
    model.userHeadImgUrl = user.userHeadImgUrl;
    model.userSex = user.userSex;
    
    if (self.successBlock) {
        self.successBlock(model);
    }
    
    [self popViewController];
}


#pragma mark - 

// 获取所有的图片
- (NSArray *)getAllImageObjects {
    NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:_imageArray.count];
    
    for (MYImage *image in _imageArray) {
        [tmpArray addObject:image.imageObj];
    }
    return tmpArray;
}


// 获取所有的图片链接
- (NSArray *)getAllImageNetworkUrls {
    NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:_imageArray.count];
    
    for (MYImage *image in _imageArray) {
        if ([image.networkUrl isValidImgUrl]) {
            [tmpArray addObject:image.networkUrl];
        }
    }
    
    return tmpArray;
}









@end
