//
//  DMVideoProcessing.h
//  Numbers
//
//  Created by Michael Filippov on 17/11/2016.
//  Copyright © 2016 Anton Spivak. All rights reserved.
//

#import <GPUImage/GPUImage.h>

#ifndef DMVideoProcessing_h
#define DMVideoProcessing_h

@interface DMVideoProcessing : NSObject

- (instancetype _Nonnull)initWithOutputImageView:(GPUImageView * _Nonnull)imageView;

- (void)start;
- (void)stop;

@end


#endif /* DMVideoProcessing_h */
