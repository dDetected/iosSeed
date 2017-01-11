//
//  OpenCVFilter.h
//  Numbers
//
//  Created by Michael Filippov on 21/12/2016.
//  Copyright © 2016 Anton Spivak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GPUImage/GPUImage.h>
#import "DMImageProcessing.h"

@interface OpenCVFilter : GPUImageFilter

@property (strong, nonatomic) DMImageProcessing * _Nonnull processing;

@end
