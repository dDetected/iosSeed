//
//  DMCameraProcessing.h
//  Numbers
//
//  Created by Michael Filippov on 17/11/2016.
//  Copyright © 2016 Anton Spivak. All rights reserved.
//

#ifndef DMCameraProcessing_h
#define DMCameraProcessing_h


@interface DMCameraProcessing : NSObject

- (instancetype _Nonnull)initWithOutputImageView:(UIImageView * _Nonnull)imageView;

- (void)startCapture;
- (void)stopCapture;

@end

#endif /* DMCameraProcessing_h */
