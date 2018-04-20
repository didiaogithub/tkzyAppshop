
//  CleanCache.h
//  TinyShoppingCenter
//
//  Created by 二壮 on 17/7/20.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^cleanCacheBlock)();


@interface CleanCache : NSObject

/**
 *  清理缓存
 */
+(void)cleanCache:(cleanCacheBlock)block;

/**
 *  整个缓存目录的大小
 */
+(float)folderSizeAtPath;
/**
 *  计算单个文件大小
 */
+(long long)fileSizeAtPath:(NSString *)filePath;

@end
