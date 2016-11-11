//
//  DMImageProccessing.h
//  Numbers
//
//  Created by Антон Спивак on 28/10/2016.
//  Copyright © 2016 Anton Spivak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <opencv2/core/core_c.h>
#import <UIKit/UIKit.h>

@interface DMImageProcessing : NSObject

- (UIImage *)findPlate:(UIImage*)srcImage withResourcePath:(NSString*) path;
- (NSString*)extractText:(UIImage*)srcImage;

@end
