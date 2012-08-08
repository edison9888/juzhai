//
//  UIImage+UIImageExt.h
//  juzhai
//
//  Created by JiaJun Wu on 12-8-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

@interface UIImage (UIImageExt)

- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;
- (UIImage *)createRoundedRectImage:(CGFloat)radius;
@end
