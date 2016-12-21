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


@implementation DMImageProcessing

struct mysort {
    bool operator() (cv::Rect pt1, cv::Rect pt2) { return (pt1.x < pt2.x);}
} myobject;

- (UIImage *)findPlate:(UIImage*)srcImage withResourcePath:(NSString*) path{
    Mat src;
    UIImageToMat(srcImage, src, true);
    
    cv::String resourcePath = cv::String(path.UTF8String);
    cv::String haarPath = resourcePath + "/haar_plate.xml";
    CascadeClassifier haar = CascadeClassifier(haarPath);
    std::vector<cv::Rect> plates;
    haar.detectMultiScale(src, plates, 1.2, 6, 1);
    
    if(plates.size() > 0){
    }
    
    return MatToUIImage(src);
}



- (NSString*)extractText:(UIImage*)srcImage{
    return @"no";
}

@end
