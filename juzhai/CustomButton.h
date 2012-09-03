//
//  CustomButton.h
//  juzhai
//
//  Created by JiaJun Wu on 12-5-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomButtonDelegate

@required
- (CGFloat)buttonCapWidth;
- (NSString *)buttonNormalBackgroundImageName;

@optional
- (NSString *)buttonHighlightedBackgroundImageName;
- (NSString *)buttonDisabledBackgroundImageName;

@end

typedef enum {
    CapLeft          = 0,
    CapMiddle        = 1,
    CapRight         = 2,
    CapLeftAndRight  = 3
} CapLocation;

@interface CustomButton : UIButton
{
    id _delegate;
}

@property (strong, nonatomic) id<CustomButtonDelegate> delegate;

- (id)initWithWidth:(NSUInteger)width buttonText:(NSString *)buttonText CapLocation:(CapLocation)location;

//- (id)initWithFrame:(CGRect)frame buttonText:(NSString *)buttonText buttonImage:(UIImage *)image buttonPressedImage:(UIImage *)pressedImage;

@end
