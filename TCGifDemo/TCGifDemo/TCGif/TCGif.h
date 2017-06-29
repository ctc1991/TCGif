//
//  TCGif.h
//  TCGifDemo
//
//  Created by 程天聪 on 15/8/26.
//  Copyright (c) 2015年 CTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>

#import "UIImageView+TCGif.h"

@interface TCGif : NSObject

// 单例
+ (TCGif *)sharedGif;

// 清空GIF缓存
- (void)clearCacheWithCompletion:(void (^)(void))completion;
// 计算GIF缓存大小 单位是字节
- (void)calculateCacheSizeWithCompletion:(void (^)(NSUInteger fileCount, NSUInteger totalSize))completion;

// 根据url缓存图片
- (void)cacheWithImages:(NSArray *)images SPF:(CGFloat)SPF forURL:(NSURL *)url;
// 根据url得到gif图地址
- (NSString *)gifFromCacheWithURL:(NSURL *)url;

// 通过一组图片制作新的GIF
- (void)gifWithImages:(NSArray *)images SPF:(CGFloat)SPF completion:(void (^)(NSString *filePath))completion;
// 通过一组图片制作新的GIF 并制定存储名称
- (void)gifWithImages:(NSArray *)images SPF:(CGFloat)SPF forKey:(NSString *)key completion:(void (^)(NSString *filePath))completion;


// 根目录GIF生成图片数组
- (void)imagesWithGifName:(NSString *)name completion:(void (^)(NSArray *images, CGFloat duration))completion;
// 沙盒内GIF生成图片数组
- (void)imagesWithGifFilePath:(NSString *)filePath completion:(void (^)(NSArray *images, CGFloat duration))completion;
// 网络GIF生成图片数组
- (void)imagesWithGifURL:(NSURL *)url completion:(void (^)(NSArray *images, CGFloat duration))completion;

- (void)imagesWithData:(NSData *)data completion:(void (^)(NSArray *images, CGFloat duration))completion;
@end
