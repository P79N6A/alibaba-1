//
//  FBWebView.h
//  CultureHongshan
//
//  Created by ct on 16/6/21.
//  Copyright © 2016年 CT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FBWebView : UIWebView
{
    NSMutableArray * imagesUrls;
}
-(id)initWithFrame:(CGRect)frame;
-(void)loadHTMLString:(NSString *)string baseURL:(NSURL *)baseURL;
-(void)restoreImagesUrl;
@end
