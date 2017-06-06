//
//  UIImageView+TCGif.h
//  TCGifDemo
//
//  Created by 程天聪 on 15/8/26.
//  Copyright (c) 2015年 CTC. All rights reserved.
//

#import "TCGif.h"

@interface UIImageView (TCGif)

// frames per second
@property (readonly) CGFloat tc_FPS;
// seconds per frame
@property (readonly) CGFloat tc_SPF;

// 根目录GIF
- (void)tc_setGifWithName:(NSString *)name;
- (void)tc_setGifWithName:(NSString *)name placeholderImage:(UIImage *)placeholderImage;

// 沙盒内GIF
- (void)tc_setGifWithFilePath:(NSString *)filePath;
- (void)tc_setGifWithFilePath:(NSString *)filePath placeholderImage:(UIImage *)placeholderImage;

// 网络GIF
- (void)tc_setGifWithURL:(NSURL *)url;
- (void)tc_setGifWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage;

@end
