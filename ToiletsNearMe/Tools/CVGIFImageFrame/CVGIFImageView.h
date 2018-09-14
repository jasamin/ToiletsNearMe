//
//  CVGIFImageFrame.h
//  TestGIF
//
//  Created by 邱嘉敏 on 16/11/23.
//  Copyright © 2016年 邱嘉敏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CVGIFImageFrame : NSObject {
    
}
@property (nonatomic) double duration;
@property (nonatomic, retain) UIImage* image;

@end

@interface CVGIFImageView : UIImageView {
    NSInteger _currentImageIndex;
}
@property (nonatomic, retain) NSArray* imageFrameArray;
@property (nonatomic, retain) NSTimer* timer;

//Setting this value to pause or continue animation;
@property (nonatomic) BOOL animating;

- (void)setData:(NSData*)imageData;

@end
