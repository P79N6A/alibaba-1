//
//  MYImageContainerView.m
//  CultureHongshan
//
//  Created by JackAndney on 2017/7/10.
//  Copyright © 2017年 CT. All rights reserved.
//

#import "MYImageContainerView.h"

#define OFFSET_X_REMOVE_ICON  6 // 右上角的 删除图片图标的右侧 距离 图片的右侧 的间距
#define OFFSET_Y_REMOVE_ICON  6 // 右上角的 删除图片图标的顶部 距离 图片的顶部 的间距

@interface MYImageEditView ()
@property (nonatomic, copy) void (^tapActionHandler)(UIImageView *imgView, NSInteger index); // 点击事件
@property (nonatomic, copy) void (^longPressActionHandler)(UIImageView *imgView, NSInteger index);// 长按事件
@property (nonatomic, copy) void (^removePhotoActionHandler)(UIImageView *imgView, NSInteger index);// 移除图片
@end


#pragma mark - ———————— MYImageContainerView ————————

@interface MYImageContainerView ()
@property (nonatomic, assign) int  imgRowNum; // 一行之内有几张图片
@end

@implementation MYImageContainerView

- (instancetype)initWithFrame:(CGRect)frame maxImgCount:(NSInteger)maxCount adjustType:(MYImageContainerAdjustType)adjustType {
    return [[MYImageContainerView alloc] initWithFrame:frame maxImgCount:maxCount adjustType:adjustType tapHandler:nil longPressHandler:nil removePhotoHandler:nil];
}


- (instancetype)initWithFrame:(CGRect)frame maxImgCount:(NSInteger)maxCount adjustType:(MYImageContainerAdjustType)adjustType tapHandler:(void (^)(UIImageView *, NSInteger))tapHandler longPressHandler:(void (^)(UIImageView *, NSInteger))longPressHandler removePhotoHandler:(void (^)(UIImageView *, NSInteger))removePhotoHandler {
    self = [super initWithFrame:frame];
    if (self) {
        _adjustType = adjustType;
        _maxImgCount = maxCount;
        self.imgScale = 1;
        self.minValue = 8;
        self.imgSpacing = 10;
        
        self.tapActionHandler = tapHandler;
        self.longPressActionHandler = longPressHandler;
        self.removePhotoActionHandler = removePhotoHandler;
        
        [self createImageViews];
        
        // 添加图片按钮
        WS(weakSelf)
        MYSmartButton *addPhotoBtn = [[MYSmartButton alloc] initWithFrame:CGRectZero image:nil selectedImage:nil actionBlock:^(MYSmartButton *sender) {
            if (weakSelf.addPhotoActionHandler) {
                weakSelf.addPhotoActionHandler();
            }
        }];
        
        UIImage *addPhotoImage = [ToolClass getDashPlaceholder:IMG(@"sh_icon_addPhoto") viewSize:CGSizeMake(75, 75) centerSize:CGSizeMake(40, 32)];

        [addPhotoBtn setBackgroundImage:addPhotoImage forState:UIControlStateNormal];
        [self addSubview:addPhotoBtn];
    }
    return self;
}



- (void)awakeFromNib {
    [super awakeFromNib];
    _adjustType = MYImageContainerAdjustTypeSizeFixed;
    self.imgScale = 1;
}


/** 创建子视图 */
- (void)createImageViews {
    if (self.maxImgCount < 1) return;
    
    for (int i = 0; i < _maxImgCount; i++) {
        MYImageEditView *imgEditView = [[MYImageEditView alloc] init];
        imgEditView.tag = i;
        imgEditView.tapActionHandler = self.tapActionHandler;
        imgEditView.longPressActionHandler = self.longPressActionHandler;
        imgEditView.removePhotoActionHandler = self.removePhotoActionHandler;
        [self addSubview:imgEditView];
    }
}

- (void)layoutSubviews {
    if (self.frame.size.width < 1) {
        [super layoutSubviews];
        return;
    }
    
    if (self.adjustType == MYImageContainerAdjustTypeSizeFixed) {
        // 大小固定
        int elementNum = 0;
        self.imgSpacing = [ToolClass getElementSpacingWithMinSpacing:self.minValue elementWidth:self.imgSize containerWidth:self.width-OFFSET_X_REMOVE_ICON elementNum:&elementNum];
        self.imgRowNum = elementNum;
    }else {
        // 间距固定
        int elementNum = 0;
        self.imgSize = [ToolClass getElementWidthWithMinWidth:self.minValue elementSpacing:self.imgSpacing containerWidth:self.width-OFFSET_X_REMOVE_ICON elementNum:&elementNum];
        self.imgRowNum = elementNum;
    }
    
    NSInteger imgViewCount = [self getImageViewCount];
    
    for (int i = 0; i < imgViewCount; i++) {
        MYImageEditView *imgEditView = [self.subviews objectAtIndex:i];
        imgEditView.hidden = (i >= self.currentImgCount);
        imgEditView.frame = CGRectMake(i%_imgRowNum*((_imgSize + OFFSET_X_REMOVE_ICON)+_imgSpacing-OFFSET_X_REMOVE_ICON), i/_imgRowNum*(_imgSize*_imgScale+OFFSET_Y_REMOVE_ICON+_imgSpacing-OFFSET_Y_REMOVE_ICON), _imgSize+OFFSET_X_REMOVE_ICON, _imgSize*_imgScale+OFFSET_Y_REMOVE_ICON);
        
        [imgEditView.imgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(_imgSize, _imgSize));
        }];
        
        if (i == self.currentImgCount || (i == imgViewCount-1 && self.currentImgCount== imgViewCount)) {
            
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(imgEditView.maxY);
            }];
            
            // 如果最后一个视图是按钮，调整按钮的位置
            UIButton *button = (UIButton *)[self getLastView];
            if ([button isKindOfClass:[UIButton class]]) {
                button.frame = CGRectMake(CGRectGetMinX(imgEditView.frame), CGRectGetMinY(imgEditView.frame) + OFFSET_Y_REMOVE_ICON, self.imgSize, self.imgSize);
            }
            button.hidden = (self.currentImgCount >= imgViewCount);
        }
    }
    
    // 没有ImageView时，根据是否有Button，调整高度
    if (imgViewCount == 0) {
        UIButton *button = (UIButton *)[self getLastView];
        if (button && [button isKindOfClass:[UIButton class]]) {
            button.hidden = NO;
            CGSize imgSize = CGSizeMake(self.imgSize, self.imgSize*self.imgScale);
            
            WS(weakSelf)
            [button mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(imgSize);
                make.left.equalTo(weakSelf);
                make.top.equalTo(weakSelf).offset(OFFSET_Y_REMOVE_ICON);
            }];
            
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(imgSize.height);
            }];
        }
    }

    [super layoutSubviews];
}

- (UIImageView *)imageViewAtIndex:(NSInteger)index {
    NSInteger imgViewCount = [self getImageViewCount];
    if (index > -1 && index < imgViewCount) {
        MYImageEditView *imgEditView = [self.subviews objectAtIndex:index];
        return imgEditView.imgView;
    }else {
        return nil;
    }
}

/**
 获取该视图下一共有多少个ImageView
 */
- (NSInteger)getImageViewCount {
    NSInteger num = 0;
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:[MYImageEditView class]]) {
            num++;
        }
    }
    return num;
}

- (UIView *)getLastView {
    if (self.subviews.count) {
        return self.subviews[self.subviews.count-1];
    }
    return nil;
}

- (NSInteger)imageViewBaseTag {
    NSInteger tag = 0;
    if (self.subviews.count) {
        tag = [[self.subviews firstObject] tag];
    }
    return tag;
}

// 更新子视图的数据
- (void)updatePhotoWithImageArray:(NSArray *)imageArray {
    for (int i = 0; i < imageArray.count; i++) {
        MYImageEditView *imgEditView = (MYImageEditView *)[self.subviews objectAtIndex:i];
        id obj = imageArray[i];
        
        if ([obj isKindOfClass:[UIImage class]]) {
            imgEditView.imgView.image = obj;
        }else if ([obj isKindOfClass:[NSString class]]) {
            [imgEditView.imgView sd_setImageWithURL:[NSURL URLWithString:obj] placeholderImage:self.placeholderImage];
        }else {
            imgEditView.imgView.image = nil;
        }
    }
    self.currentImgCount = imageArray.count;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}


@end


#pragma mark - MYImageEditView


@implementation MYImageEditView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.imgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.imgView.userInteractionEnabled = YES;
        self.imgView.contentMode = UIViewContentModeScaleAspectFill;
        self.imgView.layer.masksToBounds = YES;
        [self addSubview:self.imgView];
        
        UIButton *removeButton = [UIButton new];
        [removeButton setImage:IMG(@"removeImg") forState:UIControlStateNormal];
        [removeButton addTarget:self action:@selector(removePhotoAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:removeButton];
        
        WS(weakSelf)
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.bottom.equalTo(weakSelf);
        }];
        
        [removeButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(_imgView.mas_right).offset(OFFSET_X_REMOVE_ICON);
//            make.top.equalTo(_imgView.mas_top).offset(-OFFSET_Y_REMOVE_ICON);
            make.centerX.equalTo(_imgView.mas_right).offset(-5);
            make.centerY.equalTo(_imgView.mas_top).offset(5);
            make.size.mas_equalTo(CGSizeMake(24, 24));
        }];

        // —————————————— 添加手势 ——————————————

        // 点击手势
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgTapGesture:)];
        tapGesture.numberOfTapsRequired = 1;
        tapGesture.numberOfTouchesRequired = 1;
        [self.imgView addGestureRecognizer:tapGesture];

        // 长按手势
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGesture:)];
        longPressGesture.minimumPressDuration = 0.8;
        [self.imgView addGestureRecognizer:longPressGesture];
    }
    return self;
}

- (void)imgTapGesture:(UITapGestureRecognizer *)tapGesture {
    if (tapGesture.state == UIGestureRecognizerStateEnded) { // 点击事件在结束时判断
        if (self.tapActionHandler) {
            self.tapActionHandler(self.imgView, self.tag);
        }else if ([(MYImageContainerView *)self.superview tapActionHandler]) {
            ( (MYImageContainerView *)self.superview ).tapActionHandler(self.imgView, self.tag);
        }
    }
}

- (void)longPressGesture:(UILongPressGestureRecognizer *)longPressGesture {
    if (longPressGesture.state == UIGestureRecognizerStateBegan) {
        if (self.longPressActionHandler) {
            self.longPressActionHandler(self.imgView, self.tag);
        }else if ([(MYImageContainerView *)self.superview longPressActionHandler]) {
            ( (MYImageContainerView *)self.superview ).longPressActionHandler(self.imgView, self.tag);
        }
    }
}

- (void)removePhotoAction:(UIButton *)sender {
    if (self.removePhotoActionHandler) {
        self.removePhotoActionHandler(self.imgView, self.tag);
    }else if ([(MYImageContainerView *)self.superview removePhotoActionHandler]) {
        ( (MYImageContainerView *)self.superview ).removePhotoActionHandler(self.imgView, self.tag);
    }
}


@end
