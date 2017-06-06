//
//  TCGif.m
//  TCGifDemo
//
//  Created by 程天聪 on 15/8/26.
//  Copyright (c) 2015年 CTC. All rights reserved.
//

#import "TCGif.h"

@interface TCGif ()
@property (nonatomic, copy) NSString *cachePath;
@property (nonatomic, strong) NSFileManager *fileManager;
@end

@implementation TCGif

+ (TCGif *)sharedGif {
    static TCGif *singleton = nil;
    static dispatch_once_t onceBlock;
    dispatch_once(&onceBlock, ^{
        singleton = [TCGif new];
        singleton.cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"com.ctc.TCGif.cache"];
        singleton.fileManager = [NSFileManager new];
        [singleton.fileManager createDirectoryAtPath:singleton.cachePath withIntermediateDirectories:YES attributes:nil error:nil];
    });
    return singleton;
}

- (void)clearCacheWithCompletion:(void (^)(void))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [_fileManager removeItemAtPath:self.cachePath error:nil];
        [_fileManager createDirectoryAtPath:self.cachePath
                withIntermediateDirectories:YES
                                 attributes:nil
                                      error:NULL];
        if (completion) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion();
            });
        }
    });
}

- (void)calculateCacheSizeWithCompletion:(void (^)(NSUInteger fileCount, NSUInteger totalSize))completion {
    NSURL *cacheURL = [NSURL fileURLWithPath:self.cachePath isDirectory:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSUInteger fileCount = 0;
        NSUInteger totalSize = 0;
        
        NSDirectoryEnumerator *fileEnumerator = [_fileManager enumeratorAtURL:cacheURL
                                                   includingPropertiesForKeys:@[NSFileSize]
                                                                      options:NSDirectoryEnumerationSkipsHiddenFiles
                                                                 errorHandler:NULL];
        
        for (NSURL *fileURL in fileEnumerator) {
            NSNumber *fileSize;
            [fileURL getResourceValue:&fileSize forKey:NSURLFileSizeKey error:NULL];
            totalSize += [fileSize unsignedIntegerValue];
            fileCount += 1;
        }
        
        if (completion) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(fileCount, totalSize);
            });
        }
    });
}

- (NSString *)gifFromCacheWithURL:(NSURL *)url {
    NSString *key;
    key = url.lastPathComponent;
    if ([_fileManager fileExistsAtPath:[_cachePath stringByAppendingPathComponent: key]]) {
        NSLog(@"已经缓存过");
        return [_cachePath stringByAppendingPathComponent: key];
    } else {
        NSLog(@"这是一张新图");
        return nil;
    }
}

- (void)cacheWithImages:(NSArray *)images SPF:(CGFloat)SPF forURL:(NSURL *)url {
    NSString *key;
    key = url.lastPathComponent;
    [self gifWithImages:images SPF:SPF forKey:key completion:nil];
}

- (void)gifWithImages:(NSArray *)images SPF:(CGFloat)SPF completion:(void (^)(NSString *filePath))completion {
    [self gifWithImages:images SPF:SPF forKey:nil completion:completion];
}

- (void)gifWithImages:(NSArray *)images SPF:(CGFloat)SPF forKey:(NSString *)key completion:(void (^)(NSString *filePath))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //图像目标
        CGImageDestinationRef destination;
        
        //创建输出路径
        NSString *fileName;
        if (!key || [key isEqualToString:@""]) {
            fileName = @"new.gif";
        } else {
            fileName = key;
        }
        NSString *path = [_cachePath stringByAppendingPathComponent: fileName];
        
        
        NSLog(@"GIF图保存路径：%@",path);
        
        //创建CFURL对象
        /*
         CFURLCreateWithFileSystemPath(CFAllocatorRef allocator, CFStringRef filePath, CFURLPathStyle pathStyle, Boolean isDirectory)
         
         allocator : 分配器,通常使用kCFAllocatorDefault
         filePath : 路径
         pathStyle : 路径风格,我们就填写kCFURLPOSIXPathStyle 更多请打问号自己进去帮助看
         isDirectory : 一个布尔值,用于指定是否filePath被当作一个目录路径解决时相对路径组件
         */
        CFURLRef url = CFURLCreateWithFileSystemPath (kCFAllocatorDefault,(CFStringRef)path,kCFURLPOSIXPathStyle,false);
        
        //通过一个url返回图像目标
        destination = CGImageDestinationCreateWithURL(url, kUTTypeGIF, images.count, NULL);
        
        //设置gif整体信息
        NSDictionary *gifInfo = @{
                                  (NSString *)kCGImagePropertyGIFHasGlobalColorMap:@YES,
                                  (NSString *)kCGImagePropertyColorModel:(NSString *)kCGImagePropertyColorModelRGB,
                                  (NSString *)kCGImagePropertyDepth:@8,
                                  (NSString *)kCGImagePropertyGIFLoopCount:@0
                                  };
        NSDictionary *gifDic = @{(NSString *)kCGImagePropertyGIFDictionary:gifInfo};
        CGImageDestinationSetProperties(destination, (__bridge CFDictionaryRef)gifDic);
        
        //设置frame信息,播放间隔时间,基本数据,和delay时间
        NSDictionary *frameInfo = @{
                                    (NSString *)kCGImagePropertyGIFDelayTime:@(SPF)
                                    };
        NSDictionary *frameDic = @{(NSString *)kCGImagePropertyGIFDictionary:frameInfo};
        
        for (UIImage* img in images) {
            CGImageDestinationAddImage(destination, img.CGImage, (__bridge CFDictionaryRef)frameDic);
        }
        CGImageDestinationFinalize(destination);
        CFRelease(destination);
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (completion) {
                completion(path);
            }
        });
    });

}

@end

