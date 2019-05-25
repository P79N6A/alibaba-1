//
//  AntiqueListCell.h
//  CultureHongshan
//
//  Created by one on 15/11/23.
//  Copyright © 2015年 CT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AntiqueModel;

@interface AntiqueListCell : UICollectionViewCell


- (void)setModel:(AntiqueModel *)model forIndexPath:(NSIndexPath *)indexPath;

@end
