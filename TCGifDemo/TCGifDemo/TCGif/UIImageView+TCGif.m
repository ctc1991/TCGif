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
    [[TCGif sharedGif] imagesWithGifName:name completion:^(NSArray *images, CGFloat duration) {
        [self playGif:images duration:duration];
    }];
}

// 沙盒内GIF
- (void)tc_setGifWithFilePath:(NSString *)filePath {
        [self tc_setGifWithFilePath:filePath placeholderImage:nil];
}
- (void)tc_setGifWithFilePath:(NSString *)filePath placeholderImage:(UIImage *)placeholderImage {
        if (placeholderImage) {
            self.image = placeholderImage;
        }
        [[TCGif sharedGif] imagesWithGifFilePath:filePath completion:^(NSArray *images, CGFloat duration) {
            [self playGif:images duration:duration];
        }];
    
}

// 网络GIF
- (void)tc_setGifWithURL:(NSURL *)url {
    [self tc_setGifWithURL:url placeholderImage:nil];
}
- (void)tc_setGifWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage {
    if (placeholderImage) {
        self.image = placeholderImage;
    }
    [[TCGif sharedGif] imagesWithGifURL:url completion:^(NSArray *images, CGFloat duration) {
        [self playGif:images duration:duration];
    }];
}

// 加载 GIF data
- (void)tc_setGifWithData:(NSData *)data {
    [self tc_setGifWithData:data needCache:NO URL:nil];
}

- (void)tc_setGifWithData:(NSData *)data needCache:(BOOL)needCache URL:(NSURL *)url {
    if (data == nil) {
        return;
    }
    [[TCGif sharedGif] imagesWithData:data completion:^(NSArray *images, CGFloat duration) {
        [self playGif:images duration:duration];
    }];
}

// 播放动画
- (void)playGif:(NSArray *)images duration:(CGFloat)duration {
    self.animationImages = images;
    self.animationDuration = duration;
    [self startAnimating];
}

@end
