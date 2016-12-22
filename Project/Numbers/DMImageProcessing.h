//
//  DMImageProccessing.h
//  Numbers
//
//  Created by Антон Спивак on 28/10/2016.
//  Copyright © 2016 Anton Spivak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DMImageProcessing : NSObject

- (instancetype)initWithOuputImageFrame:(CGRect)frame;
- (UIImage *)findPlate:(UIImage*)srcImage withResourcePath:(NSString*) path;
- (void)processImageBuffer:(CVImageBufferRef _Nonnull)buffer withBlock:(void(^ _Nullable)(void))block;


@end
