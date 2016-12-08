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
    
    cv::String resourcePath = cv::String(path.UTF8String);
    cv::String haarPath = resourcePath + "/cas1.xml";
    CascadeClassifier haar = CascadeClassifier(haarPath);
    std::vector<cv::Rect> plates;
    haar.detectMultiScale(src, plates, 1.2, 5, 1);
    
    //resize to approx 300,150
    //load check cascade
    //for 1..3 cascade
    // load
    // detect
    // validate
    // store region
    // return biggest region
    
    
    int size = plates.size();
    for(int i = 0; i < size; i++){
        rectangle(src, plates[i], Scalar(255, 100, 100, 255), 3);
    }
    
    
    return MatToUIImage(src);
}



- (NSString*)extractText:(UIImage*)srcImage{
    
    G8Tesseract *tesseract = [[G8Tesseract alloc]initWithLanguage:@"eng"];
    tesseract.charWhitelist = @"1234567890ETUOPAHKXCBM";
    tesseract.image = [srcImage g8_blackAndWhite];
    [tesseract recognize];
    
    return tesseract.recognizedText;

    
}

@end
