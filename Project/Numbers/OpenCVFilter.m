//
//  OpenCVFilter.m
//  Numbers
//
//  Created by Michael Filippov on 21/12/2016.
//  Copyright © 2016 Anton Spivak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "OpenCVFilter.h"
#import "DMImageProcessing.h"


@interface OpenCVFilter ()

@property (nonatomic) dispatch_queue_t processingQueue;
@property (strong, nonatomic) DMImageProcessing * _Nonnull processing;
@property (nonatomic) BOOL isBusy;


@end

@implementation OpenCVFilter

- (id)init {
    if (self == [super initWithFragmentShaderFromString:kGPUImagePassthroughFragmentShaderString]) {
        _processing = [[DMImageProcessing alloc] initWithOuputImageFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        _processingQueue = dispatch_queue_create("com.domoby.opencv", DISPATCH_QUEUE_SERIAL);
        _isBusy = NO;
    }
    return self;
}

- (void)renderToTextureWithVertices:(const GLfloat *)vertices textureCoordinates:(const GLfloat *)textureCoordinates {
    if (self.isBusy) {
        return [super renderToTextureWithVertices:vertices textureCoordinates:textureCoordinates];
    }
    
    if (self.preventRendering) {
        [firstInputFramebuffer unlock];
        return;
    }
    
    usingNextFrameForImageCapture = YES;
    
    outputFramebuffer = [[GPUImageContext sharedFramebufferCache] fetchFramebufferForSize:[self sizeOfFBO] textureOptions:self.outputTextureOptions onlyTexture:NO];
    [outputFramebuffer activateFramebuffer];
    
    runSynchronouslyOnVideoProcessingQueue(^{
        if (usingNextFrameForImageCapture) {
            [outputFramebuffer lock];
        }
        
        CVPixelBufferRef buffer;
        Ivar renderTargetIvar = class_getInstanceVariable([outputFramebuffer class], "renderTarget");
        buffer = (__bridge CVPixelBufferRef)(object_getIvar(outputFramebuffer, renderTargetIvar));
        
        glFinish();
        CFRetain(buffer);
        [outputFramebuffer lockForReading];
        
        CVPixelBufferRef bufferCopy = NULL;
        CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault,
                                              CVPixelBufferGetWidth(buffer),
                                              CVPixelBufferGetHeight(buffer),
                                              kCVPixelFormatType_32BGRA,
                                              NULL,
                                              &bufferCopy);
        
        if (status == kCVReturnSuccess) {
            CVPixelBufferLockBaseAddress(bufferCopy, 0);
            uint8_t *copyBaseAddress = CVPixelBufferGetBaseAddress(bufferCopy);
            
            memcpy(copyBaseAddress,
                   CVPixelBufferGetBaseAddress(buffer),
                   CVPixelBufferGetWidth(buffer) *
                   CVPixelBufferGetBytesPerRow(buffer));
            
            __weak typeof(self) welf = self;
            dispatch_async(_processingQueue, ^{
                //[self.processing processImageBuffer:bufferCopy withBlock:^{
                //    welf.isBusy = NO;
                    
                    CVPixelBufferUnlockBaseAddress(bufferCopy, 0);
                    CVPixelBufferRelease(bufferCopy);
                //}];
            });
        }
        
        [outputFramebuffer restoreRenderTarget];
        [outputFramebuffer unlock];
    });
    
    [firstInputFramebuffer unlock];
    
    if (usingNextFrameForImageCapture) {
        dispatch_semaphore_signal(imageCaptureSemaphore);
    }

    
}

@end
