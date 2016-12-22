//
//  DMImageProccessing.m
//  Numbers
//
//  Created by Антон Спивак on 28/10/2016.
//  Copyright © 2016 Anton Spivak. All rights reserved.
//

#import "DMImageProcessing.h"


#import <opencv2/imgproc/imgproc.hpp>

#import <opencv2/imgcodecs/ios.h>
#import <opencv2/objdetect/objdetect.hpp>



using namespace std;
using namespace cv;

@interface DMImageProcessing ()

@property (nonatomic) CascadeClassifier haar;
@property (nonatomic) CGRect outputImageFrame;


@end


@implementation DMImageProcessing

- (instancetype)initWithOuputImageFrame:(CGRect)frame {
    if (self == [super init]) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"haar_plate" ofType:@"xml"];
        self.haar = CascadeClassifier(cv::String(path.UTF8String));
        self.outputImageFrame = frame;
    }
    return self;
}

- (UIImage *)findPlate:(UIImage*)srcImage withResourcePath:(NSString*) path{
    Mat src;
    UIImageToMat(srcImage, src, true);
    
    cv::String resourcePath = cv::String(path.UTF8String);
    cv::String haarPath = resourcePath + "/haar_plate.xml";
    CascadeClassifier haar = CascadeClassifier(haarPath);

    
    return MatToUIImage(src);
}

- (void)processImageBuffer:(CVImageBufferRef)buffer withBlock:(void (^)())block {
    
    cv::Mat src = [self matFromBuffer:buffer];
    
    Mat copy;
    copy = src.clone();
    UIImage * res  = MatToUIImage(copy);
    usleep(1000);
    
    std::vector<cv::Rect> plates;
    self.haar.detectMultiScale(src, plates, 1.2, 6, 1);
    
    if(plates.size() > 0){
        cv::Rect plate = plates[0];
        CGRect __plate = CGRectMake(plate.x, plate.y , plate.width, plate.height);
        NSLog(@"visible plate!");
        NSNotification *n1 = [NSNotification notificationWithName:@"plate0"
                                                           object:nil
                                                         userInfo:@{@"rect" : [NSValue valueWithCGRect:__plate]}];
        [self postNotificationAtMainQueue: n1];
    }
    block();
}

- (cv::Mat)matFromBuffer:(CVImageBufferRef)imageBuffer {
    
    void *bufferAddress;
    size_t width;
    size_t height;
    size_t bytesPerRow;
    
    int format_opencv;
    
    OSType format = CVPixelBufferGetPixelFormatType(imageBuffer);
    if (format == kCVPixelFormatType_420YpCbCr8BiPlanarFullRange) {
        
        format_opencv = CV_8UC1;
        
        bufferAddress = CVPixelBufferGetBaseAddressOfPlane(imageBuffer, 0);
        width = CVPixelBufferGetWidthOfPlane(imageBuffer, 0);
        height = CVPixelBufferGetHeightOfPlane(imageBuffer, 0);
        bytesPerRow = CVPixelBufferGetBytesPerRowOfPlane(imageBuffer, 0);
        
    } else {
        
        format_opencv = CV_8UC4;
        
        bufferAddress = CVPixelBufferGetBaseAddress(imageBuffer);
        width = CVPixelBufferGetWidth(imageBuffer);
        height = CVPixelBufferGetHeight(imageBuffer);
        bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    }
    
    cv::Mat image((int)height, (int)width, format_opencv, bufferAddress, bytesPerRow);
    return image;
}

- (void)postNotificationAtMainQueue:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    });
}

@end
