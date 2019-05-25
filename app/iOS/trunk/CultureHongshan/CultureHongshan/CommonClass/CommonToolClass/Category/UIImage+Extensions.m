//
//  UIImage+Extensions.m
//  CultureHongshan
//
//  Created by ct on 17/3/1.
//  Copyright © 2017年 CT. All rights reserved.
//

#import "UIImage+Extensions.h"

@implementation UIImage (Extensions)

- (UIImage *)circleImage {
    if (self.size.width > 0 && self.size.height > 0) {
        UIGraphicsBeginImageContext(self.size);
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
        CGContextAddEllipseInRect(ctx, rect);
        CGContextClip(ctx);
        [self drawInRect:rect];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image;
    }
    return nil;
}




@end

/*
 
 if (self.size.width > 0 && self.size.height > 0) {
        UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
        [[UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.size.width, self.size.height) cornerRadius:self.size.width/2.0] addClip];
        [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
        UIImage *clipedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return clipedImage;
    }
    return nil;
 
 */
