//
//  CVGIFImageFrame.m
//  TestGIF
//
//  Created by shichangone on 11-7-12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CVGIFImageView.h"
#import <ImageIO/ImageIO.h>

@implementation CVGIFImageFrame
@synthesize image = _image;
@synthesize duration = _duration;



@end

@interface CVGIFImageView ()

- (void)resetTimer;

- (void)showNextImage;

@end

@implementation CVGIFImageView
@synthesize imageFrameArray = _imageFrameArray;
@synthesize timer = _timer;
@synthesize animating = _animating;

- (void)dealloc
{
    [self resetTimer];
}

- (void)resetTimer {
    if (_timer && _timer.isValid) {
        [_timer invalidate];
    }
    
    self.timer = nil;
}

- (void)setData:(NSData *)imageData {
    if (!imageData) {
        return;
    }
    [self resetTimer];
    
    CGImageSourceRef source = CGImageSourceCreateWithData((CFDataRef)imageData, NULL);
    size_t count = CGImageSourceGetCount(source);
    
    NSMutableArray* tmpArray = [NSMutableArray array];
    
    for (size_t i = 0; i < count; i++) {
        CVGIFImageFrame* gifImage = [[CVGIFImageFrame alloc] init];
        
        CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
        gifImage.image = [UIImage imageWithCGImage:image scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
        
        //NSDictionary* frameProperties = (NSDictionary*)CGImageSourceCopyPropertiesAtIndex(source, i, NULL) ;
        NSDictionary* frameProperties = (NSDictionary*)CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(source, i, NULL)) ;
        gifImage.duration = [[[frameProperties objectForKey:(NSString*)kCGImagePropertyGIFDictionary] objectForKey:(NSString*)kCGImagePropertyGIFDelayTime] doubleValue];
        gifImage.duration = 0.04; // MAX(gifImage.duration, 0.01);
        
        [tmpArray addObject:gifImage];
        
        CGImageRelease(image);
    }
    CFRelease(source);
    
    self.imageFrameArray = nil;
    if (tmpArray.count > 1) {
        self.imageFrameArray = tmpArray;
        _currentImageIndex = -1;
        _animating = YES;
        [self showNextImage];
    } else {
        self.image = [UIImage imageWithData:imageData];
    }
}

- (void)setImage:(UIImage *)image {
    [super setImage:image];
    [self resetTimer];
    self.imageFrameArray = nil;
    _animating = NO;
}

- (void)showNextImage {
    if (!_animating) {
        return;
    }
    
    _currentImageIndex = (++_currentImageIndex) % _imageFrameArray.count;
    CVGIFImageFrame* gifImage = [_imageFrameArray objectAtIndex:_currentImageIndex];
    [super setImage:[gifImage image]];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:gifImage.duration target:self selector:@selector(showNextImage) userInfo:nil repeats:NO];
}

- (void)setAnimating:(BOOL)animating {
    if (_imageFrameArray.count < 2) {
        _animating = animating;
        return;
    }
    
    if (!_animating && animating) {
        //continue
        _animating = animating;
        if (!_timer) {
            [self showNextImage];
        }
    } else if (_animating && !animating) {
        //stop
        _animating = animating;
        [self resetTimer];
    }
}

@end
