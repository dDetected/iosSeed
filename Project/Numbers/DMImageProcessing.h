//
//  DMImageProccessing.h
//  Numbers
//
//  Created by Антон Спивак on 28/10/2016.
//  Copyright © 2016 Anton Spivak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <opencv2/core/core_c.h>

extern NSNotificationName _Nonnull const DMImageProcessingDidFoundPlates;
extern NSNotificationName _Nonnull const DMImageProcessingDidLoosePlates;

extern NSString *_Nonnull const DMImageProcessingInfoFramesKey;

@interface DMImageProcessing : NSObject

- (void)processCvMat:(CvMat)cvMat;
- (void)processCvMat:(CvMat)cvMat withBlock:(void (^ _Nullable)())block;

@end
