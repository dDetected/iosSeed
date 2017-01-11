//
//  OpenCVFilter.m
//  Numbers
//
//  Created by Michael Filippov on 21/12/2016.
//  Copyright © 2016 Anton Spivak. All rights reserved.
//

#import "OpenCVFilter.h"
#import <objc/runtime.h>
#import <opencv2/core/mat.hpp>
#import <opencv2/imgcodecs/ios.h>

@interface OpenCVFilter ()

@property (nonatomic) dispatch_queue_t processingQueue;
@property (nonatomic) BOOL isBusy;

@end

@implementation OpenCVFilter

- (id)init {
    if (self == [super initWithFragmentShaderFromString:kGPUImagePassthroughFragmentShaderString]) {
        _processing = [[DMImageProcessing alloc] init];
        _processingQueue = dispatch_queue_create("com.domoby.opencv", DISPATCH_QUEUE_SERIAL);
        _isBusy = NO;
    }
    return self;
}

- (void)setInputFramebuffer:(GPUImageFramebuffer *)newInputFramebuffer atIndex:(NSInteger)textureIndex {
    [newInputFramebuffer lockForReading];
    
    CVPixelBufferRef buffer;
    Ivar renderTargetIvar = class_getInstanceVariable([newInputFramebuffer class], "renderTarget");
    buffer = (__bridge CVPixelBufferRef)(object_getIvar(newInputFramebuffer, renderTargetIvar));
    
    if (!self.isBusy) {
        void *bufferAddress;
        size_t width;
        size_t height;
        size_t bytesPerRow;
        int format_opencv;
        
        OSType format = CVPixelBufferGetPixelFormatType(buffer);
        if (format == kCVPixelFormatType_420YpCbCr8BiPlanarFullRange) {
            format_opencv = CV_8UC1;
            bufferAddress = CVPixelBufferGetBaseAddressOfPlane(buffer, 0);
            width = CVPixelBufferGetWidthOfPlane(buffer, 0);
            height = CVPixelBufferGetHeightOfPlane(buffer, 0);
            bytesPerRow = CVPixelBufferGetBytesPerRowOfPlane(buffer, 0);
        } else {
            format_opencv = CV_8UC4;
            bufferAddress = CVPixelBufferGetBaseAddress(buffer);
            width = CVPixelBufferGetWidth(buffer);
            height = CVPixelBufferGetHeight(buffer);
            bytesPerRow = CVPixelBufferGetBytesPerRow(buffer);
        }
        
        cv::Mat image((int)height, (int)width, format_opencv, bufferAddress, bytesPerRow);
        CvMat cvMat = CvMat(image);
        __weak typeof(self) welf = self;
        dispatch_async(_processingQueue, ^{
            [self.processing processCvMat:cvMat withBlock:^{
                welf.isBusy = NO;
            }];
        });
    }
    
    [newInputFramebuffer unlockAfterReading];
    [super setInputFramebuffer:newInputFramebuffer atIndex:textureIndex];
}

@end
