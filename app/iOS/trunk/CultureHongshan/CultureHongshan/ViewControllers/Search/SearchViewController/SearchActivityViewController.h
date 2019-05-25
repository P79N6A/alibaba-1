//
//  SearchActivityViewController.h
//  CultureHongshan
//
//  Created by ct on 16/4/13.
//  Copyright © 2016年 CT. All rights reserved.
//

#import "BasicScrollViewController.h"
#import "UserDataCacheTool.h"

/**
 *  活动与场馆的搜索
 */
@interface SearchActivityViewController : BasicScrollViewController
{
    NSArray * _hotTypeArray;
    NSArray * _hotAreaArray;
    NSArray * _hotKeyArray;
    NSArray * _hotKeyActivityArray;
    NSArray * _hotKeyVenueArray;
    UISearchBar *_searchBar;
    UserDataCacheTool *cacheTool;
    UIView * _searchHistoryView;
    UIView * _searchHotView;
}

@property(nonatomic,assign) SearchType searchType;
-(id)initWithSearchType:(SearchType)searchType;

@end
