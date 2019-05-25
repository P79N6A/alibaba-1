//
//  FBWebView.m
//  CultureHongshan
//
//  Created by ct on 16/6/21.
//  Copyright © 2016年 CT. All rights reserved.
//

#import "FBWebView.h"

@implementation FBWebView


-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        
    }
    return self;
}

-(void)loadHTMLString:(NSString *)string baseURL:(NSURL *)baseURL
{
    NSString * newcontent = [self replaceImageUrl:string];
    
    [super loadHTMLString:[self replaceStyleWidthAndHeight:newcontent] baseURL:baseURL];
}

-(NSString *)replaceImageUrl:(NSString *)string
{
    NSRegularExpression * imgRegular = [NSRegularExpression regularExpressionWithPattern:@"src=['\"]([^>'\"]*)['\"]" options:0 error:nil];
    NSArray * regexAry = [imgRegular matchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, string.length)];
    NSString * newcontent = [string copy];
    if (regexAry && regexAry.count > 0)
    {
        imagesUrls = [[NSMutableArray alloc] initWithCapacity:regexAry.count];
        for(NSTextCheckingResult *result in regexAry)
        {
            if(result.range.location != NSNotFound)
            {
                NSString *str = [string substringWithRange:NSMakeRange(result.range.location, result.range.length)];
                if (str.length > 6)
                {
                    
                    [imagesUrls addObject:[str substringWithRange:NSMakeRange(5, str.length - 6)]];
                }
                
            }
        }
        newcontent = [imgRegular stringByReplacingMatchesInString:string options:0 range:NSMakeRange(0, string.length) withTemplate:[NSString stringWithFormat:@"src=\"%@\"",DEFAULT_IMAGE_URL]];
    }
    return newcontent;
}


-(NSString *)replaceStyleWidthAndHeight:(NSString *) string
{
    //style="line-height: 20.7999992370605px; width: 750px; height: 562px;" /></p>
    NSRegularExpression * imgRegular = [NSRegularExpression regularExpressionWithPattern:@"style=['\"]{1}[^'\"]*['\"]{1}" options:0 error:nil];
    NSArray * regexAry = [imgRegular matchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, string.length)];
    NSString * newcontent = [string copy];
    NSRegularExpression * reg = [NSRegularExpression regularExpressionWithPattern:@"[\\D]" options:0 error:nil];
    if (regexAry && regexAry.count > 0)
    {
        for(NSTextCheckingResult *result in regexAry)
        {
            if(result.range.location != NSNotFound)
            {
                NSString *str = [string substringWithRange:NSMakeRange(result.range.location, result.range.length)];
                NSString *new = [str copy];
                @try
                {
                    
                    NSRange range = [str  rangeOfString:@"width[\\D]{1,}[\\d]{3,}" options:NSRegularExpressionSearch];
                    if (range.location == NSNotFound)
                    {
                        continue;
                    }
                    NSString * tt = [str substringWithRange:range];
                    NSString * width = [reg stringByReplacingMatchesInString:tt options:0 range:NSMakeRange(0, tt.length) withTemplate:@""];
                    int x = [width intValue];
                    if (x < WIDTH_SCREEN - 15)
                    {
                        continue;
                    }
                    float scale = (WIDTH_SCREEN - 15) / x ;
                    new  = [new stringByReplacingOccurrencesOfString:width withString:[NSString stringWithFormat:@"%d",(int)(WIDTH_SCREEN - 15)]];
                    NSRange range1 = [str  rangeOfString:@"height[\\D]{1,}[\\d]{3,}" options:NSRegularExpressionSearch];
                    tt = [str substringWithRange:range1];
                    NSString * height = [reg stringByReplacingMatchesInString:tt options:0 range:NSMakeRange(0, tt.length) withTemplate:@""];
                    int y = [height intValue];
                    new  = [new stringByReplacingOccurrencesOfString:height withString:[NSString stringWithFormat:@"%d",(int)(y * scale)]];
                    
//                    new  = [new stringByReplacingOccurrencesOfString:height withString:@"auto"];
                    
                } @catch (NSException *exception) {
                    
                    continue;
                }
                
                newcontent = [newcontent stringByReplacingOccurrencesOfString:str withString:new];
            }
        }
        
    }
    return newcontent;
}


-(void)getImagesUrl
{
    
}

-(void)restoreImagesUrl
{
    NSMutableString * scriptStr = [NSMutableString new];
    [scriptStr appendString:@"var myimages=new Array("];
    for (NSString * url in imagesUrls)
    {
        [scriptStr appendString:[NSString stringWithFormat:@"'%@',",url]];
    }
    [scriptStr appendString:@"'');"];
    [scriptStr appendString:
     @"for(var i=0;i <document.images.length;i++){"
     "myimg = document.images[i];"
     "myimg.src=myimages[i];"
     "}"
     ];
    [self stringByEvaluatingJavaScriptFromString:scriptStr];
}



@end
