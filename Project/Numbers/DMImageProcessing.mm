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
#import <opencv2/imgcodecs/ios.h>
#import <opencv2/objdetect/objdetect.hpp>


using namespace std;
using namespace cv;

@implementation DMImageProcessing {
    
    CascadeClassifier cascade;
    CascadeClassifier checkcascade;
    
    int num;
    int scale;
    
    Mat image_input;
    Mat image_main_result;
    Mat storage;
}

- (instancetype)init {
    if (self == [super init]) {
        NSBundle *bundle = [NSBundle mainBundle];
        NSString *checkcascadePath = [bundle pathForResource:@"checkcas" ofType:@"xml"];
        checkcascade = CascadeClassifier(checkcascadePath.UTF8String);
        num = 0;
        scale = 5;
    }
    return self;
}

- (UIImage *)findPlate:(UIImage*)srcImage withResourcePath:(NSString *)path {
    
    Mat src;
    UIImageToMat(srcImage, src, true);
    
    image_main_result = src.clone();
    image_input = src.clone();
    storage = src.clone();
    
    num = 0;
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSDictionary *cascades = @{@"cas1" : @"xml",
                               @"cas2" : @"xml",
                               @"cas3" : @"xml"};
    
    std::vector<cv::Rect> regions;
    
    for (int i = 0; i < 3; i++) {
        NSString *name = cascades.allKeys[i];
        NSString *extension = cascades.allValues[i];
        NSString *cascadePath = [bundle pathForResource:name ofType:extension];
        
        Mat image = src.clone();
        resize(image, image, cv::Size(image.size().width/scale, image.size().height/scale), 0, 0, INTER_LINEAR);
        [self findcars:image cascade:cascadePath.UTF8String regions:regions];
    }
    
    
    cv::Rect maxRegion(0, 0, 0, 0);
    for (int i = 0; i < regions.size(); i++) {
        cv::Rect region = regions[i];
        if (region.width*region.height > maxRegion.width*maxRegion.height) {
            maxRegion = region;
        }
        
        cv::Point pt1 = cv::Point(region.x*scale, region.y*scale);
        cv::Point pt2 = cv::Point((region.x + region.width)*scale, (region.y + region.height)*scale);
        
        rectangle(src, pt1, pt2, Scalar(127, 255, 255, 255), 3);
    }
    
    cv::Point pt1 = cv::Point(maxRegion.x*scale, maxRegion.y*scale);
    cv::Point pt2 = cv::Point((maxRegion.x + maxRegion.width)*scale, (maxRegion.y + maxRegion.height)*scale);
    
    rectangle(src, pt1, pt2, Scalar(127, 255, 0, 255), 3);
    
    return MatToUIImage(src);
}


- (void)findcars:(cv::Mat&)img cascade:(const cv::String&)filename regions:(std::vector<cv::Rect>&)regions {
    std::vector<cv::Rect> cars;
    cascade.load(filename);
    cascade.detectMultiScale(img, cars, 1.1, 2, 0, cv::Size(10, 10));
    for (int i = 0; i < cars.size(); i++) {
        regions.push_back(cars[i]);
    }
}

- (void)findcars:(cv::Mat&)img cascade:(const cv::String&)filename {
    
    int i = 0;
    
    //for region of interest.If a car is detected(after testing) by one classifier,then it will not be available for other one
    Mat temp;

    int cen_x;
    int cen_y;
    std::vector<cv::Rect> cars;
    
    const static Scalar colors[] = {
        CV_RGB(0,0,255),
        CV_RGB(0,255,0),
        CV_RGB(255,0,0),
        CV_RGB(255,255,0),
        CV_RGB(255,0,255),
        CV_RGB(0,255,255),
        CV_RGB(255,255,255),
        CV_RGB(128,0,0),
        CV_RGB(0,128,0),
        CV_RGB(0,0,128),
        CV_RGB(128,128,128),
        CV_RGB(0,0,0)};
    
    Mat gray, resize_image(cvRound(img.rows), cvRound(img.cols), CV_8UC1);
    
    cvtColor(img, gray, CV_BGR2GRAY);
    resize(gray, resize_image, resize_image.size(), 0, 0, INTER_LINEAR);
    equalizeHist(resize_image, resize_image);
    
    //detection using main classifier
    cascade.load(filename);
    cascade.detectMultiScale(resize_image, cars, 1.1, 2, 0, cv::Size(10, 10));
    
    for (std::vector<cv::Rect>::const_iterator main = cars.begin(); main != cars.end(); main++, i++) {
        
        Mat resize_image_reg_of_interest;
        std::vector<cv::Rect> nestedcars;
        cv::Point center;
        cv::Scalar color = colors[i%8];
        
        //getting points for bouding a rectangle over the car detected by main
        int x0 = cvRound(main->x);
        int y0 = cvRound(main->y);
        int x1 = cvRound((main->x + main->width - 1));
        int y1 = cvRound((main->y + main->height - 1));
        
        resize_image_reg_of_interest = resize_image(*main);
        checkcascade.detectMultiScale(resize_image_reg_of_interest, nestedcars, 1.1, 2, 0, cv::Size(30, 30));
        
        // testing the detected car by main using checkcascade
        for (std::vector<cv::Rect>::const_iterator sub = nestedcars.begin(); sub != nestedcars.end(); sub++) {
            
            //getting center points for bouding a circle over the car detected by checkcascade
            center.x = cvRound((main->x + sub->x + sub->width*0.5));
            cen_x = center.x;
            center.y = cvRound((main->y + sub->y + sub->height*0.5));
            cen_y = center.y;
            
            if (cen_x > (x0 + 15) && cen_x < (x1 - 15) && cen_y > (y0 + 15) && cen_y < (y1 - 15)) {
                // if centre of bounding circle is inside the rectangle boundary over a threshold the the car is certified
                
                //detecting boundary rectangle over the final result
                rectangle(image_main_result, cvPoint(x0*scale, y0*scale), cvPoint(x1*scale,y1*scale), Scalar(127, 255, 0, 0), 3, 8, 0);
                
                //masking the detected car to detect second car if present
                cv::Rect region_of_interest = cv::Rect(x0*scale, y0*scale, (x1 - x0)*scale, (y1 - y0)*scale);
                temp = storage(region_of_interest);
                temp = Scalar(255, 255, 255);
                
                //num if number of cars detected
                num++;
            }
        }
    }
}

@end
