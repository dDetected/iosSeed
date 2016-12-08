//
//  DMVideoProcessing.m
//  Numbers
//
//  Created by Michael Filippov on 17/11/2016.
//  Copyright © 2016 Anton Spivak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "DMVideoProcessing.h"
#import <opencv2/videoio/cap_ios.h>
#import <opencv2/imgproc/imgproc.hpp>

#import <GPUImage/GPUImage.h>

using namespace cv;

//////////
@class DMVideoCamera;

@interface DMVideoCamera : CvVideoCamera{
    
}

@end

@implementation DMVideoCamera


@end

//////////

@interface DMVideoProcessing () <GPUImageMovieDelegate>

@property (strong, nonatomic) GPUImageMovie *movie;
@property (strong, nonatomic) GPUImageBrightnessFilter *filter;

@end


@implementation DMVideoProcessing

- (instancetype)initWithOutputImageView:(GPUImageView *)imageView {
    if (self == [super init]) {
        NSURL *videoURL = [[NSBundle mainBundle] URLForResource:@"vidos" withExtension:@"MOV"];
        
        self.movie = [[GPUImageMovie alloc] initWithURL:videoURL];
        self.movie.delegate = self;
        self.movie.shouldRepeat = YES;
        self.movie.playAtActualSpeed = YES;
        
        self.filter = [[GPUImageBrightnessFilter alloc] init];
        [self.filter setInputRotation:kGPUImageRotateRight atIndex:0];
        self.filter.brightness = 0.0;
        
        [self.movie addTarget:self.filter];
        [self.filter addTarget: imageView];
    }
    return self;
}

- (void)start {
    [self.movie startProcessing];
}

- (void)stop {
    
}

#pragma mark - CvVideoCameraDelegate

- (void)didCompletePlayingMovie{
    
}

- (void)processImage:(cv::Mat &)image {

}

@end
