//
//  DMCameraProcessing.m
//  Numbers
//
//  Created by Michael Filippov on 17/11/2016.
//  Copyright © 2016 Anton Spivak. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <opencv2/videoio/cap_ios.h>
#import <opencv2/imgproc/imgproc.hpp>

#import "DMCameraProcessing.h"

@interface DMCameraProcessing () <CvVideoCameraDelegate>

@property (strong, nonatomic) CvVideoCamera *camera;

@end

@implementation DMCameraProcessing

- (instancetype)initWithOutputImageView:(UIImageView *)imageView {
    if (self == [super init]) {
        
        self.camera = [[CvVideoCamera alloc] initWithParentView:imageView];
        self.camera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionBack;
        self.camera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset1920x1080;
        self.camera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
        self.camera.defaultFPS = 30;
        self.camera.grayscaleMode = NO;
        self.camera.delegate = self;
    }
    return self;
}

- (void)startCapture {
    [self.camera start];
}

- (void)stopCapture {
    [self.camera stop];
}

#pragma mark - CvVideoCameraDelegate

- (void)processImage:(cv::Mat &)image {
    //do magic!
    static unsigned int i = 0;
    if(i % 5 == 0){
        rectangle(image, cv::Rect(200, 500, 400, 300), cv::Scalar(255, 100, 100), 5);
    }
    
    i += 1;
    
}

@end
