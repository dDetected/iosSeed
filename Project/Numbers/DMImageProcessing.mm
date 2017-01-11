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

NSNotificationName const DMImageProcessingDidFoundPlates = @"DMImageProcessingDidFoundPlates";
NSNotificationName const DMImageProcessingDidLoosePlates = @"DMImageProcessingDidLoosePlates";

NSString *const DMImageProcessingInfoFramesKey = @"DMImageProcessingInfoFramesKey";

using namespace std;
using namespace cv;

@interface DMImageProcessing ()

@property (nonatomic) CascadeClassifier haar;

@end


@implementation DMImageProcessing

- (instancetype)init {
    if (self == [super init]) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"haar_plate" ofType:@"xml"];
        self.haar = CascadeClassifier(cv::String(path.UTF8String));
    }
    return self;
}

- (void)processCvMat:(CvMat)mat {
    [self processCvMat:mat withBlock:nil];
}

- (void)processCvMat:(CvMat)mat withBlock:(void (^)())block {
    
    cv::Mat source = cvarrToMat(&mat);
    
    std::vector<cv::Rect> plates;
    self.haar.detectMultiScale(source, plates, 1.2, 6, 1);
    
    NSNotification *notification;
    if (plates.size() > 0) {
        NSMutableArray *frames = [NSMutableArray new];
        for (NSInteger i = 0; i < plates.size(); i++) {
            cv::Rect rect = plates[i];
            NSValue *value = [NSValue valueWithCGRect:CGRectMake(rect.x, rect.y, rect.width, rect.height)];
            [frames addObject:value];
        }
        notification = [NSNotification notificationWithName:DMImageProcessingDidFoundPlates
                                                     object:nil
                                                   userInfo:@{DMImageProcessingInfoFramesKey : [frames copy]}];
    } else {
        notification = [NSNotification notificationWithName:DMImageProcessingDidLoosePlates
                                                     object:nil
                                                   userInfo:nil];
    }
    
    [self postNotification:notification atQueue:dispatch_get_main_queue()];
    
    if (nil != block) {
        block();
    }
}

- (void)postNotification:(NSNotification *)notification atQueue:(dispatch_queue_t)queue {
    dispatch_async(queue, ^{
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    });
}

@end
