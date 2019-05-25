//
//  FontService.m
//  CultureHongshan
//
//  Created by ct on 16/6/28.
//  Copyright © 2016年 CT. All rights reserved.
//

#import "FontService.h"
#import <CoreText/CoreText.h>
#import "ZipArchive.h"




@implementation FontService


+(void)unZipFontFile
{
    ZipArchive *za = [[ZipArchive alloc] init];
    NSString * zipPath = [[NSBundle mainBundle] pathForResource:@"yuanti001.TTF" ofType:@"zip"];
    NSString * documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString * dirPath = [documentPath stringByAppendingPathComponent:@"fonts"];
    if ([za UnzipOpenFile: zipPath])
    {
        BOOL ret = [za UnzipFileTo: dirPath overWrite: YES];
        if (NO == ret)
        {
            
        }
        [za UnzipCloseFile];
    }
}


+(UIFont*)customFontWithPath:(CGFloat)size
{
    NSString * documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString * dirPath = [documentPath stringByAppendingPathComponent:@"fonts"];
    NSString * path = [dirPath stringByAppendingPathComponent:@"yuanti001.TTF"];
    //NSString * path = [[NSBundle mainBundle] pathForResource:@"yuanti001" ofType:@"TTF"];
    
    NSURL *fontUrl = [NSURL fileURLWithPath:path];
    CGDataProviderRef fontDataProvider = CGDataProviderCreateWithURL((__bridge CFURLRef)fontUrl);
    CGFontRef fontRef = CGFontCreateWithDataProvider(fontDataProvider);
    CGDataProviderRelease(fontDataProvider);
    CTFontManagerRegisterGraphicsFont(fontRef, NULL);
    NSString *fontName = CFBridgingRelease(CGFontCopyPostScriptName(fontRef));
    UIFont *font = [UIFont fontWithName:fontName size:size];
    CGFontRelease(fontRef);
    return font;
    
    
//    
//    
//    CFErrorRef error;
//    CTFontManagerRegisterGraphicsFont(fontRef, &error);
//    
//    UIFont * fff = [UIFont fontWithName:fontName size:20];
//    
//    CTFontManagerUnregisterGraphicsFont(fontRef, &error);
//    CFRelease(fontRef);
//    
//    return font;
    
    
}
@end
