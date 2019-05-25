//
//  PhotoLibraryPickerViewController.h
//  WhereIsMyForward
//
//  Created by 李 兴 on 15-5-18.
//  Copyright (c) 2015年 李 兴. All rights reserved.
//

#import "CommonTableViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

typedef void(^PhotoLibraryPicker)(NSArray * imgary);
@interface PhotoLibraryPickerViewController : CommonTableViewController <UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSDictionary * _assetUrls;
    ALAssetsLibrary * _assetsLibrary;
    NSMutableArray * _assetArray;
    NSArray * imageArray;
    UITableView * _assetGroupTableView;
    UIView * _bottomView;
    NSMutableArray * _assetGroupArray;
    NSInteger _assetGroupTableviewHeight;
    NSMutableArray * _selectedAssetArray;
    dispatch_queue_t urls_queue;

}
@property(assign,nonatomic)NSInteger maxImageNum;
@property(nonatomic,retain) NSMutableArray * selectedImageArray;
@property(copy,nonatomic) PhotoLibraryPicker block;
-(void)pickerResult:(PhotoLibraryPicker)block;
@end
