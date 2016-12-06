//
//  DMImageProccessing.m
//  Numbers
//
//  Created by Антон Спивак on 28/10/2016.
//  Copyright © 2016 Anton Spivak. All rights reserved.
//

#import "DMImageProcessing.h"

#import <TesseractOCR/TesseractOCR.h>
#import <opencv2/imgproc/imgproc.hpp>
#import <opencv2/text.hpp>
#import <opencv2/imgcodecs/ios.h>
#import <opencv2/objdetect/objdetect.hpp>
#import <opencv2/dpm.hpp>


using namespace std;
using namespace cv;
using namespace text;

@implementation DMImageProcessing

struct mysort {
    bool operator() (cv::Rect pt1, cv::Rect pt2) { return (pt1.x < pt2.x);}
} myobject;

- (UIImage *)findPlate:(UIImage*)srcImage withResourcePath:(NSString*) path{
    Mat src;
    UIImageToMat(srcImage, src, true);
    
    Mat resized;
    resize(src, resized, cv::Size(160, 213));
    
    Mat srcBGR;
    
    cvtColor(resized, srcBGR, COLOR_BGRA2BGR);
//    Mat srcConv;
//    src.convertTo(srcConv, CV_64F);
    

//    int channells = src.channels();
//    int depth = src.depth();
//    int cv64 = CV_64F;
    Mat srcCopy;
    srcBGR.copyTo(srcCopy);
    cv::String resourcePath = cv::String(path.UTF8String);
    cv::String carDPMpath = resourcePath + "/car.xml";
//
    std::vector<std::string> filenames(1,carDPMpath);
//    filenames.push_back();
//
    Ptr<dpm::DPMDetector> detectorptr =dpm::DPMDetector::create(filenames);
    dpm::DPMDetector* detector = detectorptr.get();
//
    vector<dpm::DPMDetector::ObjectDetection> results;
//
    detector->detect(srcCopy, results);
//
    int size = results.size();
    for(int i = 0; i < size; i++){
        dpm::DPMDetector::ObjectDetection car = results[i];
//        if(car.score > -0.5){
            rectangle(srcBGR, car.rect, Scalar(100, 100, 255));
//        }
        NSLog(@"score %f", car.score);
    }

    
    return MatToUIImage(srcBGR);
}



- (NSString*)extractText:(UIImage*)srcImage{
    return @"closed1";
}

@end
