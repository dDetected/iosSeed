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
    cv::String haarPath = resourcePath + "/haar_plate.xml";
    CascadeClassifier haar = CascadeClassifier(haarPath);
    std::vector<cv::Rect> plates;
    haar.detectMultiScale(src, plates, 1.2, 6, 1);
    
    if(plates.size() > 0){
        Mat plate;
        src(plates[0]).copyTo(plate);
        
        Mat grayPlate;
        cvtColor(plate, grayPlate, COLOR_BGR2GRAY);
        Mat blurPlate;
        
        //GaussianBlur(grayPlate, blurPlate, cv::Size(3,3), 0);
        Mat binPlate;
        //threshold(grayPlate, binPlate, 0, 255, THRESH_BINARY | THRESH_OTSU);
        adaptiveThreshold(grayPlate, binPlate, 255, ADAPTIVE_THRESH_GAUSSIAN_C, THRESH_BINARY, 11, 2);
        
        //load classifier
        cv::String nm1Path = resourcePath + "/trained_classifierNM1.xml";
        cv::String nm2Path = resourcePath + "/trained_classifierNM2.xml";
        
        std::vector<vector<cv::Point>> characters;
        Ptr<ERFilter> nm1 = createERFilterNM1(loadClassifierNM1(nm1Path));
        Ptr<ERFilter> nm2 = createERFilterNM2(loadClassifierNM2(nm2Path));
        cv::text::detectRegions(binPlate, nm1, nm2, characters);
        
        std::vector<cv::Rect> bounding;
        for(int i = 0; i < characters.size(); i++){
            cv::Rect boundBox = boundingRect(characters[i]);
            if(boundBox.width * boundBox.height > 70){
                bounding.push_back(boundBox);
                rectangle(plate, boundBox, Scalar(255, 100, 100));
            }
        }
        
        sort(bounding.begin(), bounding.end(), myobject);
        
        //for all bounding rects launch tesseract
        G8Tesseract *tesseract = [[G8Tesseract alloc]initWithLanguage:@"eng"];
        [tesseract setPageSegmentationMode:G8PageSegmentationModeSingleChar];
        NSMutableString *strResult = [NSMutableString string];
        
        for(int i = 0; i < bounding.size(); i++) {
            cv::Rect r = bounding[i];
            if(r.x > 0){
                r.x -= 1;
                
                r.width += 1;
            }
            if(r.y > 0){
                r.y -= 1;
                r.height += 1;
            }

            Mat box;
            binPlate(r).copyTo(box);
            UIImage* letter = MatToUIImage(box);
            if(i == 0 || i == 4 || i == 5){
                tesseract.charWhitelist = @"etuopahkxcbmETUOPAHKYXCBM";
            }else{
                tesseract.charWhitelist = @"1234567890";
            }
            tesseract.image = letter;
            [tesseract recognize];
            NSString* text = tesseract.recognizedText;
            if(text != nil && text.length > 0){
                [strResult appendString:[text substringToIndex:1]];
            }
        }
         NSLog(strResult);
        
        
        
        return MatToUIImage(plate);
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
