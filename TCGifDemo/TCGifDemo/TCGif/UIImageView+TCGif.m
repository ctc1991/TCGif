//
//  UIImageView+TCGif.m
//  TCGifDemo
//
//  Created by 程天聪 on 15/8/26.
//  Copyright (c) 2015年 CTC. All rights reserved.
//

#import "UIImageView+TCGif.h"

@implementation UIImageView (TCGif)

// frames per second
- (CGFloat)tc_FPS {
    return self.animationImages.count/self.animationDuration;
}

// seconds per frame
- (CGFloat)tc_SPF {
    return self.animationDuration/self.animationImages.count;
}

// 根目录GIF
- (void)tc_setGifWithName:(NSString *)name {
    [self tc_setGifWithName:name placeholderImage:nil];
}
- (void)tc_setGifWithName:(NSString *)name placeholderImage:(UIImage *)placeholderImage {
    if (placeholderImage) {
        self.image = placeholderImage;
    }
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle]pathForResource:name ofType:@"gif"]];
    [self tc_setGifWithData:data];
}

// 沙盒内GIF
- (void)tc_setGifWithFilePath:(NSString *)filePath {
        [self tc_setGifWithFilePath:filePath placeholderImage:nil];
}
- (void)tc_setGifWithFilePath:(NSString *)filePath placeholderImage:(UIImage *)placeholderImage {
        if (placeholderImage) {
            self.image = placeholderImage;
        }
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        [self tc_setGifWithData:data];
}

// 网络GIF
- (void)tc_setGifWithURL:(NSURL *)url {
    [self tc_setGifWithURL:url placeholderImage:nil];
}
- (void)tc_setGifWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage {
    if (placeholderImage) {
        self.image = placeholderImage;
    }
    NSData *data = [NSData dataWithContentsOfURL:url];
    [self tc_setGifWithData:data];
}

// 加载 GIF data
- (void)tc_setGifWithData:(NSData *)data {
    if (data == nil) {
        return;
    }
    NSLog(@"图片大小：%.2f KB", data.length/1024.0);
    NSMutableArray *imgs = [NSMutableArray array];
    CGFloat duration = 0;
    // 通过data获取image的数据源
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    // 获取帧数
    size_t frames = CGImageSourceGetCount(source);
    for (size_t i = 0; i < frames; i++) {
        // 获取gif图一帧的时间
        NSDictionary *info = (__bridge NSDictionary *)CGImageSourceCopyPropertiesAtIndex(source, i, NULL);
        NSDictionary *timeDic = [info objectForKey:(__bridge NSString *)kCGImagePropertyGIFDictionary];
        CGFloat time = [[timeDic objectForKey:(__bridge NSString *)kCGImagePropertyGIFDelayTime] floatValue];
        duration += time;
        
        //获取图像
        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(source, i, NULL);
        
        //生成image
        UIImage *image = [UIImage imageWithCGImage:imageRef scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
        
        [imgs addObject:image];
        
        CGImageRelease(imageRef);
    }
    CFRelease(source);
    self.animationImages = imgs;
    self.animationDuration = duration;
    [self startAnimating];
}

@end
