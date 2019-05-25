//
//  LikeTableViewCell.h
//  TableVIewCellTest
//
//  Created by JackAndney on 16/4/18.
//  Copyright © 2016年 Andney. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LikeTableViewCell : UITableViewCell

//点赞数和浏览量
- (void)setLikeCount:(NSInteger)likeCount scanCount:(NSInteger)scanCount;
- (void)setModelArray:(NSArray *)modelArray;


@end
