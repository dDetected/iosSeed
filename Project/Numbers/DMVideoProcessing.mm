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

using namespace cv;

//////////
@class DMVideoCamera;

@interface DMVideoCamera : CvVideoCamera{
    
}

@end

@implementation DMVideoCamera


@end

//////////

@interface DMVideoProcessing () <CvVideoCameraDelegate>

@property (strong, nonatomic) DMVideoCamera *camera;

@end


@implementation DMVideoProcessing

- (instancetype)initWithOutputImageView:(UIImageView *)imageView {
    if (self == [super init]) {
        self.camera = [[DMVideoCamera alloc] initWithParentView:imageView];
        self.camera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionBack;
        self.camera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset1920x1080;
        self.camera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
        self.camera.defaultFPS = 30;
        self.camera.grayscaleMode = NO;
        self.camera.delegate = self;        
    }
    return self;
}

- (void)start {
    [self.camera start];
}

- (void)stop {
    [self.camera stop];
}

#pragma mark - CvVideoCameraDelegate

- (void)processImage:(cv::Mat &)image {
    static int i = 0;
    if(i % 5 == 0){
        rectangle(image, cv::Rect(200, 500, 400, 300), cv::Scalar(255, 100, 100), 5);
    }
    
    i += 1;
}

@end
