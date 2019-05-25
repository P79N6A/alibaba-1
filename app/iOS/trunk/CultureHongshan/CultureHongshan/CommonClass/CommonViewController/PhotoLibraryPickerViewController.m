//
//  PhotoLibraryPickerViewController.m
//  WhereIsMyForward
//
//  Created by 李 兴 on 15-5-18.
//  Copyright (c) 2015年 李 兴. All rights reserved.
//

#import "PhotoLibraryPickerViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import <ImageIO/ImageIO.h>

#define  VIEWTAG_LABEL          9125
#define  kMaxShowImageNum       30
#define  WIDTH_IMAGE            (WIDTH_SCREEN/3)

@interface PhotoLibraryPickerViewController ()

@end

@implementation PhotoLibraryPickerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"选择图片";
    ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
    if(status == ALAuthorizationStatusDenied || status == ALAuthorizationStatusRestricted)
    {
        ALERTSHOW(@"您没有权限访问相册，请到设置中打开相册访问权限，谢谢！");
    }
    _selectedAssetArray = [NSMutableArray new];
    _assetsLibrary = [[ALAssetsLibrary alloc]init];//生成整个photolibrary句柄的实例
    UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    [button setTitle:@"完成" forState:UIControlStateNormal];
    button.titleLabel.font = FONTBOLD(14);
    [button setTitleColor:kDeepLabelColor forState:UIControlStateNormal];
    [button addTarget:self action:@selector(selectDone) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    if (_maxImageNum == 0)
    {
        _maxImageNum = 9;
    }
    _assetArray = [NSMutableArray new];
    [self disablefreshTableCell];
    _tableView.frame = MRECT(0, 0, WIDTH_SCREEN, HEIGHT_SCREEN);
    _bottomView = [[UIView alloc] initWithFrame:MRECT(0, HEIGHT_SCREEN-40, WIDTH_SCREEN, 40)];
    _bottomView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    FBButton * selectGroupButton = [[FBButton alloc] initWithText:MRECT(0, 0, 100, 40) font:FONT_MIDDLE fcolor:COLOR_IWHITE bgcolor:COLOR_CLEAR text:@"选择相册"];
    [selectGroupButton addTarget:self action:@selector(selectAssetGroup) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:selectGroupButton];
    [self.view addSubview:_bottomView];

    urls_queue = dispatch_queue_create("com.xianxia.ykqnl.image", NULL);

    [self loadPhotoLibrary];
}



-(void)selectAssetGroup
{
    if (_assetGroupArray.count == 0)
    {
        return;
    }

    _assetGroupTableviewHeight =  (_assetGroupArray.count + 1) * 40;

    if (_assetGroupTableviewHeight > (WIDTH_SCREEN/3) * 2)
    {
        _assetGroupTableviewHeight = (WIDTH_SCREEN/3)*2;
    }
    if (_assetGroupTableView == nil)
    {
        _assetGroupTableView  = [[UITableView alloc] initWithFrame:MRECT(0, HEIGHT_SCREEN - 40 +_assetGroupTableviewHeight, WIDTH_SCREEN, _assetGroupTableviewHeight) style:UITableViewStylePlain];
        _assetGroupTableView.dataSource = self;
        _assetGroupTableView.backgroundColor = COLOR_IWHITE;
        _assetGroupTableView.delegate = self;
        [self.view insertSubview:_assetGroupTableView aboveSubview:_tableView];

    }
    CGRect newFrame;
    if (_assetGroupTableView.frame.origin.y == HEIGHT_SCREEN -40 +_assetGroupTableviewHeight)
    {
        newFrame = MRECT(0, HEIGHT_SCREEN -40-_assetGroupTableviewHeight, WIDTH_SCREEN, _assetGroupTableviewHeight);
    }
    else
    {
        newFrame = MRECT(0, HEIGHT_SCREEN -40 +_assetGroupTableviewHeight, WIDTH_SCREEN, _assetGroupTableviewHeight);
    }
    [UIView animateWithDuration:0.4 animations:^{

        _assetGroupTableView.frame = newFrame;

    } completion:^(BOOL finished) {

    }];


}


-(void)loadPhotoLibrary
{
    _assetGroupArray = [NSMutableArray new];
    _assetsLibrary = [[ALAssetsLibrary alloc]init];//生成整个photolibrary句柄的实例
    //NSMutableArray *mediaArray = [[NSMutableArray alloc]init];//存放media的数组
    [_assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll ^ ALAssetsGroupPhotoStream usingBlock:^(ALAssetsGroup *group, BOOL *stop)
     {
         if (group && [group numberOfAssets] > 0)
         {
             [_assetGroupArray addObject:group];
              [self loadAssetsGroup:group array:_assetArray];
         }
        [_tableView   reloadData];
    }
    failureBlock:^(NSError *error)
    {
         FBLOG(@"Enumerate the asset groups failed.");
     }];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tableView)
    {
        return WIDTH_IMAGE;
    }
    else
    {
        return 40;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _tableView)
    {
        NSInteger row = (_assetArray.count + 1)/3;
        if ((_assetArray.count +1) %3 ==0)
        {
            return row;
        }
        else
        {
            return row + 1 ;
        }
    }
    else
    {
        return _assetGroupArray.count + 1;
    }


}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _assetGroupTableView)
    {
        //[_selectedAssetArray removeAllObjects];
        [_assetArray removeAllObjects];
        if (indexPath.row == 0)
        {
            for (int i=0; i<_assetGroupArray.count; i++)
            {
                [self loadAssetsGroup:_assetGroupArray[i] array:_assetArray];
            }

        }
        else
        {
            [self loadAssetsGroup:_assetGroupArray[indexPath.row - 1] array:_assetArray];
        }
        [UIView animateWithDuration:0.4 animations:^{

            _assetGroupTableView.frame = MRECT(0, HEIGHT_SCREEN -40 +_assetGroupTableviewHeight, WIDTH_SCREEN, _assetGroupTableviewHeight);

        } completion:^(BOOL finished) {
            
        }];

        if (_assetArray.count > 0)
        {
            [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }

        [_tableView reloadData];
    }
}



-(void)loadAssetsGroup:(ALAssetsGroup *)group array:(NSMutableArray *)array
{


    [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop)
     {
         NSString* assetType = [result valueForProperty:ALAssetPropertyType];
         if ([assetType isEqualToString:ALAssetTypePhoto])
         {
             /*
              NSDictionary *assetUrls = [result valueForProperty:ALAssetPropertyURLs];
              for (NSString *assetURLKey in assetUrls)
              {
              [_assetUrlArray addObject:assetUrls[assetURLKey]];

              }
              */
             
             [array addObject:result];

         }

     }];

}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    
    if (tableView == _tableView)
    {

        if (indexPath.row == 0)
        {
            FBButton * cameraButton = [[FBButton alloc] initWithImage:MRECT(0, 0, WIDTH_IMAGE, WIDTH_IMAGE) bgcolor:COLOR_IGRAY img:IMG(@"icon_camera")];
            cameraButton.layer.borderWidth = 1;
            cameraButton.layer.borderColor = COLOR_IBLACK.CGColor;
            [cameraButton addTarget:self action:@selector(cameraTap) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:cameraButton];
        }
        NSMutableArray * imgAry = [self getImageArrayByIndexPath:indexPath];
        
        for (int i=0;i<imgAry.count;i++)
        {
            if (imgAry[i] == nil)
            {
                continue;
            }

            NSDictionary * assetUrls = [imgAry[i] valueForProperty:ALAssetPropertyURLs];
            NSURL * picUrl = [assetUrls allValues][0];
            CGRect imgRec;
            if (indexPath.row == 0)
            {
                imgRec = MRECT((i+1)*WIDTH_IMAGE, 0, WIDTH_IMAGE, WIDTH_IMAGE);
            }
            else
            {
                imgRec = MRECT(i*WIDTH_IMAGE, 0, WIDTH_IMAGE, WIDTH_IMAGE);
            }
            UIImageView * imageView = [[UIImageView alloc] initWithFrame:imgRec];
            //FBButton  * imgButton = [[FBButton alloc] initWithImage:imgRec bgcolor:COLOR_CLEAR img:nil];
            if (indexPath.row == 0)
            {
                 imageView.tag = i;
            }
            else
            {
                 imageView.tag = indexPath.row * 3 + i - 1;
            }

            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            imageView.layer.borderWidth = 1;
            imageView.layer.borderColor = COLOR_IBLACK.CGColor;
            [cell.contentView addSubview:imageView];

            imageView.userInteractionEnabled = YES;
            UITapGestureRecognizer * tapGesuture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgtap:)];
            [imageView addGestureRecognizer:tapGesuture];
            
            [_assetsLibrary assetForURL:picUrl resultBlock:^(ALAsset * asset)
             {
                 UIImage * assetImg = [[UIImage alloc] initWithCGImage:[asset aspectRatioThumbnail]];
                 //[imgButton setImage:assetImg forState:UIControlStateNormal];
                 imageView.image = assetImg;

                 /*
                ALAssetRepresentation* representation = [asset defaultRepresentation];

                 // Retrieve the image orientation from the ALAsset
                 UIImageOrientation orientation = UIImageOrientationUp;
                 NSNumber* orientationValue = [asset valueForProperty:@"ALAssetPropertyOrientation"];
                 if (orientationValue != nil)
                 {
                     orientation = [orientationValue intValue];
                 }

                 CGFloat scale  = 1;
                 UIImage* assetImg = [UIImage imageWithCGImage:[representation fullResolutionImage] scale:scale orientation:orientation];
                 //[imgButton setImage:assetImg forState:UIControlStateNormal];
                 imageView.image = assetImg;
                  */
                 /*
                 UILabel * labelInButton = (UILabel *)[imgButton viewWithTag:VIEWTAG_LABEL];

                 for(NSData * selImgData in _selectImageDataArray)
                 {
                     
                     NSData * assetImgData = UIImagePNGRepresentation(assetImg);
                     if ([selImgData isEqual:assetImgData])
                     {
                         
                         labelInButton.text =  @"✓";
                         //[_selectImageDataArray removeObject:selImgData];
                         break;
                     }
                     
                 }
                  */
                 
             }
                           failureBlock:^(NSError * error)
             {
                 
             }];
            
            UILabel * label = [[UILabel alloc] initWithFrame:MRECT(imageView.frame.size.width-20, 5, 15, 15)];
            if ([_selectedAssetArray indexOfObject:picUrl.absoluteString] != NSNotFound)
            {
                label.text = @"✓";
            }
            else
            {
                label.text = @"";
            }
            label.tag = VIEWTAG_LABEL;
            label.clipsToBounds = YES;
            label.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
            //label.radius = 10;
            label.layer.borderColor = COLOR_IWHITE.CGColor;
            label.layer.borderWidth = 1;
            label.textAlignment = NSTextAlignmentCenter;
            label.font = FONT(13);
            label.textColor = [UIColor greenColor];
            [imageView addSubview:label];

            ALAsset * set = _assetArray[imageView.tag];
            NSString * url = [self getAssetUrlString:set];
            if ([_selectedAssetArray indexOfObject:url] != NSNotFound)
            {
                label.text = @"✓";
            }
            
            
            
        }
        
    }
    else
    {
        FBLabel * label = [[FBLabel alloc] initWithStyle:MRECT(15, 16, 200, 20) font:FONT_MIDDLE fcolor:kDeepLabelColor text:@""];
        [cell.contentView addSubview:label];
        if (indexPath.row == 0)
        {
            label.text = @"所有图片";
        }
        else
        {
             ALAssetsGroup * group = _assetGroupArray[indexPath.row - 1];
            label.text = [NSString stringWithFormat:@"%@(%ld)",[group valueForProperty:ALAssetsGroupPropertyName],(long)[group numberOfAssets]];

        }

    }


    return cell;
}

-(NSMutableArray *)getImageArrayByIndexPath:(NSIndexPath *)indexPath
{
    NSInteger totatl = _assetArray.count;
    NSMutableArray * imgAry = [NSMutableArray new];
    if (indexPath.row == 0)
    {
        if ((totatl - 1) >= 0)
        {
            [imgAry addObject:_assetArray[totatl - 1 ]];
        }
        if ((totatl - 2) >= 0)
        {
            [imgAry addObject:_assetArray[totatl - 2]];
        }

    }
    else
    {

        NSInteger base =  totatl - indexPath.row * 3;

        if ((base) >= 0)
        {
            [imgAry addObject:_assetArray[base]];
        }
        if  ((base - 1) >= 0)
        {
            [imgAry addObject:_assetArray[base - 1]];
        }
        if  ((base - 2) >= 0)
        {
            [imgAry addObject:_assetArray[base - 2]];
        }

    }
    return imgAry;
}


-(NSString * )getAssetUrlString:(ALAsset *)set
{
    NSDictionary * assetUrls = [set valueForProperty:ALAssetPropertyURLs];
    NSURL * picUrl = [assetUrls allValues][0];
    return picUrl.absoluteString;
}


-(void)imgtap:(UITapGestureRecognizer *)tap
{
    NSInteger tag = tap.view.tag;

    UILabel * labelInButton = (UILabel *)[tap.view viewWithTag:VIEWTAG_LABEL];;
    ALAsset * set = _assetArray[_assetArray.count -  tag - 1];
    NSString * url = [self getAssetUrlString:set];
    //ALAssetRepresentation* representation = [set defaultRepresentation];
//    UIImageOrientation orientation = UIImageOrientationUp;
//    NSNumber* orientationValue = [set valueForProperty:@"ALAssetPropertyOrientation"];
//    if (orientationValue != nil)
//    {
//        orientation = [orientationValue intValue];
//    }
    //UIImage * image = [[UIImage alloc] initWithCGImage:[representation fullResolutionImage]];
    //

    NSUInteger idx = [_selectedAssetArray indexOfObject:url];
    if (idx == NSNotFound)
    {
        if (_selectedImageArray.count >= self.maxImageNum)
        {
            NSString * str = [NSString stringWithFormat:@"最多选择%ld张图片~",(long)self.maxImageNum];
            ALERTSHOW(str);
            return;
        }
         labelInButton.text = @"✓";
        dispatch_async(urls_queue, ^{

            /*
            CGImageRef imgreg = [representation CGImageWithOptions:@{}];

            UIImage * image = [[UIImage alloc] initWithCGImage:imgreg scale:1 orientation:orientation];
            imgreg = nil;
             */
            UIImage * image =  [self thumbnailForAsset:set maxPixelSize:1000];
            [_selectedImageArray addObject:image];
            image = nil;
            [_selectedAssetArray addObject:url];


        });


    }
    else
    {
        id obj = [_selectedImageArray objectAtIndex:idx];
        if (obj)
        {
            labelInButton.text = @"";
            [_selectedAssetArray removeObjectAtIndex:idx];
            [_selectedImageArray removeObjectAtIndex:idx];
        }

    }

}



-(void)cameraTap
{
    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])//判断camera是否可用。
    {
        ALERTSHOW(@"当前照相机不可用！");
        return;
    }

    UIImagePickerController * picker = [[UIImagePickerController alloc]  init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.modalPresentationStyle = UIModalPresentationFullScreen;
    //picker.view.frame = MRECT(0, 100, WIDTH_SCREEN, 200);
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;


    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(status == AVAuthorizationStatusAuthorized)
    {

        [self  presentViewController:picker animated:YES completion:nil];

    }
    else if(status == AVAuthorizationStatusDenied)
    {

        ALERTSHOW(@"请到设置中打开照相机的使用权限！");

    } else if(status == AVAuthorizationStatusRestricted)
    {
        // restricted
    } else if(status == AVAuthorizationStatusNotDetermined)
    {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if(granted)
            {

                [self  presentViewController:picker animated:YES completion:nil];


            } else
            {
                return;
            }
        }];
    }
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{

    [picker dismissViewControllerAnimated:NO completion:^(){

        [_selectedImageArray removeAllObjects];
        [_selectedImageArray addObject:[info objectForKey:UIImagePickerControllerOriginalImage]];
        [self selectDone];

    }];


}

-(void)pickerResult:(PhotoLibraryPicker)block;
{
    self.block = block;
}

-(void)selectDone
{
    self.block(_selectedImageArray);
    [self.navigationController popViewControllerAnimated:NO];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





static size_t getAssetBytesCallback(void *info, void *buffer, off_t position, size_t count) {
    ALAssetRepresentation *rep = (__bridge id)info;
    
    NSError *error = nil;
    size_t countRead = [rep getBytes:(uint8_t *)buffer fromOffset:position length:count error:&error];
    
    if (countRead == 0 && error) {
        // We have no way of passing this info back to the caller, so we log it, at least.
        FBLOG(@"thumbnailForAsset:maxPixelSize: got an error reading an asset: %@", error);
    }
    
    return countRead;
}

static void releaseAssetCallback(void *info) {
    // The info here is an ALAssetRepresentation which we CFRetain in thumbnailForAsset:maxPixelSize:.
    // This release balances that retain.
    CFRelease(info);
}

// Returns a UIImage for the given asset, with size length at most the passed size.
// The resulting UIImage will be already rotated to UIImageOrientationUp, so its CGImageRef
// can be used directly without additional rotation handling.
// This is done synchronously, so you should call this method on a background queue/thread.
- (UIImage *)thumbnailForAsset:(ALAsset *)asset maxPixelSize:(NSUInteger)size {
    NSParameterAssert(asset != nil);
    NSParameterAssert(size > 0);
    
    ALAssetRepresentation *rep = [asset defaultRepresentation];
    
    CGDataProviderDirectCallbacks callbacks = {
        .version = 0,
        .getBytePointer = NULL,
        .releaseBytePointer = NULL,
        .getBytesAtPosition = getAssetBytesCallback,
        .releaseInfo = releaseAssetCallback,
    };
    
    CGDataProviderRef provider = CGDataProviderCreateDirect((void *)CFBridgingRetain(rep), [rep size], &callbacks);
    CGImageSourceRef source = CGImageSourceCreateWithDataProvider(provider, NULL);
    
    CGImageRef imageRef = CGImageSourceCreateThumbnailAtIndex(source, 0, (CFDictionaryRef) @{
                                                                                            (NSString *)kCGImageSourceCreateThumbnailFromImageAlways : @YES,
                                                                                                      (NSString *)kCGImageSourceThumbnailMaxPixelSize : [NSNumber numberWithInt:(int)size],
                                                                                                      (NSString *)kCGImageSourceCreateThumbnailWithTransform : @YES,
                                                                                                      });
    CFRelease(source);
    CFRelease(provider);
    
    if (!imageRef) {
        return nil;
    }
    
    UIImage *toReturn = [UIImage imageWithCGImage:imageRef];
    
    CFRelease(imageRef);
    
    return toReturn;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
