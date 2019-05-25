//
//  FileService.h
//  WHYFoundationKit
//
//  Created by JackAndney on 2017/5/14.
//  Copyright © 2017年 Creatoo. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 文件的类型 */
typedef enum : NSUInteger {
    /** 未知文件类型 */
    FileTypeUnkonwn,
    /** 图片文件 */
    FileTypeImage,
    /** 音频文件 */
    FileTypeAudio,
    /** 视频文件 */
    FileTypeVideo,
    /** 文本文件 */
    FileTypePlainText,
} FileType;


/**
 *  文件、文件夹的有关操作
 */
@interface FileService : NSObject

#pragma mark - File Attributes Getter

/**
 *  判断本地文件是否存在
 *
 *  @param filePathOrURL 本地文件的路径或URL
 *
 *  @return 布尔值
 */
+ (BOOL)fileExistsAtPathOrURL:(id)filePathOrURL;

/**
 *  获取本地文件的属性
 *
 *  @param filePathOrURL 本地文件的路径或URL
 *  @param error         获取失败时的错误信息
 *
 *  @return 文件属性字典
 */
+ (NSDictionary *)attributesOfFileAtPathOrURL:(id)filePathOrURL error:(NSError **)error;

/**
 *  获取本地文件的大小
 *
 *  @param filePathOrURL 本地文件的路径或URL
 *
 *  @return 本地文件的实际大小：如果获取文件属性成功，则返回文件的大小；否则返回0
 */
+ (unsigned long long)fileSizeAtPathOrURL:(id)filePathOrURL;

/**
 *  遍历文件夹获得文件夹大小
 *
 *  @param  folderPathOrURL 文件夹路径或URL
 *
 *  @return 文件夹大小（字节数）
 */
+ (unsigned long long)fileFolderSizeAtPathOrURL:(id)folderPathOrURL;

/**
 *  获取文件的扩展名
 *
 *  @param filePathOrURL 文件的路径或URL
 *
 *  @return 文件的扩展名：不存在时，返回空字符串。
 */
+ (NSString *)pathExtensionForPathOrURL:(id)filePathOrURL;

/**
 *  根据文件的扩展名获取文件的类型
 *
 *  @param pathExtension 文件扩展名
 *
 *  @return 对应的文件类型
 */
+ (FileType)fileTypeForPathExtension:(NSString *)pathExtension;

/**
 *  获取文件全名
 *
 * @discussion 返回的是路径的最后一部分
 *
 *  @param filePathOrURL 文件路径或URL
 *
 *  @return 含扩展名的文件名
 */
+ (NSString *)fileFullNameForItem:(id)filePathOrURL;

/**
 *  获取文件名
 *
 *  @param filePathOrURL 文件路径或URL
 *
 *  @return 不含扩展名的文件名
 */
+ (NSString *)fileNameForItem:(id)filePathOrURL;




#pragma mark - Rename File

/**
 *  文件重命名
 *
 *  @param filePathOrURL 文件的原路径或URL
 *  @param newFileName   新的文件名（不含扩展名）
 *
 *  @return 布尔值
 */
+ (BOOL)renameFileAtPathOrURL:(id)filePathOrURL newFileName:(NSString *)newFileName;


#pragma mark - Delete File

/**
 *  删除指定文件夹下的文件
 *
 *  @discussion 如果removedFileNames有值，则删除指定文件名的文件；否则会删除该文件夹下的所有文件
 *
 *  @param directoryPathOrURL   指定的文件夹路径或URL
 *  @param subdirectoryIncluded 是否包含子文件夹下的文件
 *  @param removedFileNames     指定要删除的文件名（不含扩展名）
 */
+ (void)deleteFilesUnderDirectory:(id)directoryPathOrURL subdirectoryIncluded:(BOOL)subdirectoryIncluded removedFileNames:(NSString *)removedFileNames, ...;

/**
 *  删除文件
 *
 *  @param filePathOrURL 要删除的文件路径或URL
 *  @param error         删除失败时的错误信息
 *
 *  @return 布尔值
 */
+ (BOOL)removeFileAtPathOrURL:(id)filePathOrURL error:(NSError **)error;



#pragma mark - File Path Or Directory Create

/**
 *  创建文件/文件夹
 *
 *  @param filePathOrURL 要创建的文件路径或URL
 *  @param contents      要写入的NSData数据对象
 *
 *  @return 布尔值
 */
+ (BOOL)createFile:(id)filePathOrURL contents:(NSData *)contents;



@end
