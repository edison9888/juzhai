//
//  CustomButton.m
//  juzhai
//
//  Created by JiaJun Wu on 12-5-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CustomButton.h"
#import "Constant.h"

@implementation CustomButton

@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame buttonText:(NSString *)buttonText buttonImage:(UIImage *)image buttonPressedImage:(UIImage *)pressedImage buttonDisabledImage:(UIImage *)disabledImage{
    self = [UIButton buttonWithType:UIButtonTypeCustom];
    if (self) {
        self.frame = frame;
        self.titleLabel.font = DEFAULT_FONT(12);
        self.titleLabel.shadowOffset = CGSizeMake(0,-1);
        self.titleLabel.shadowColor = [UIColor darkGrayColor];
        [self setTitle:buttonText forState:UIControlStateNormal];
        
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [self setTitleColor:[UIColor colorWithRed:0.50f green:0.67f blue:0.83f alpha:1.00f] forState:UIControlStateDisabled];
        [self setBackgroundImage:image forState:UIControlStateNormal];
        [self setBackgroundImage:pressedImage forState:UIControlStateHighlighted];
        [self setBackgroundImage:pressedImage forState:UIControlStateSelected];
        if (disabledImage != nil) {
            [self setBackgroundImage:disabledImage forState:UIControlStateDisabled];
        }
        self.adjustsImageWhenHighlighted = NO;
    }
    return self;
}

- (id)initWithWidth:(NSUInteger)width buttonText:(NSString *)buttonText CapLocation:(CapLocation)location
{
    UIImage* buttonImage = nil;
    UIImage* buttonPressedImage = nil;
    UIImage* buttonDisableImage = nil;
    if (location == CapLeftAndRight)
    {
        buttonImage = [[UIImage imageNamed:[self.delegate buttonNormalBackgroundImageName]] stretchableImageWithLeftCapWidth:[self.delegate buttonCapWidth] topCapHeight:0.0];
        buttonPressedImage = [[UIImage imageNamed:[self.delegate buttonHighlightedBackgroundImageName]] stretchableImageWithLeftCapWidth:[self.delegate buttonCapWidth] topCapHeight:0.0];
        if ([_delegate respondsToSelector:@selector(buttonDisabledBackgroundImageName)]) {
            buttonDisableImage = [[UIImage imageNamed:[self.delegate buttonDisabledBackgroundImageName]] stretchableImageWithLeftCapWidth:[self.delegate buttonCapWidth] topCapHeight:0.0];
        }
    }
    else
    {
        buttonImage = [self image:[[UIImage imageNamed:[self.delegate buttonNormalBackgroundImageName]] stretchableImageWithLeftCapWidth:[self.delegate buttonCapWidth] topCapHeight:0.0] withCap:location capWidth:[self.delegate buttonCapWidth] buttonWidth:width];
        buttonPressedImage = [self image:[[UIImage imageNamed:[self.delegate buttonHighlightedBackgroundImageName]] stretchableImageWithLeftCapWidth:[self.delegate buttonCapWidth] topCapHeight:0.0] withCap:location capWidth:[self.delegate buttonCapWidth] buttonWidth:width];
        if ([_delegate respondsToSelector:@selector(buttonDisabledBackgroundImageName)]) {
            buttonDisableImage = [self image:[[UIImage imageNamed:[self.delegate buttonDisabledBackgroundImageName]] stretchableImageWithLeftCapWidth:[self.delegate buttonCapWidth] topCapHeight:0.0] withCap:location capWidth:[self.delegate buttonCapWidth] buttonWidth:width];
        }
    }
    return [self initWithFrame:CGRectMake(0, 0, width, buttonImage.size.height) buttonText:buttonText buttonImage:buttonImage buttonPressedImage:buttonPressedImage buttonDisabledImage:buttonDisableImage];
}

-(UIImage*)image:(UIImage*)image withCap:(CapLocation)location capWidth:(NSUInteger)capWidth buttonWidth:(NSUInteger)buttonWidth
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(buttonWidth, image.size.height), NO, 0.0);
    
    if (location == CapLeft)
        // To draw the left cap and not the right, we start at 0, and increase the width of the image by the cap width to push the right cap out of view
        [image drawInRect:CGRectMake(0, 0, buttonWidth + capWidth, image.size.height)];
    else if (location == CapRight)
        // To draw the right cap and not the left, we start at negative the cap width and increase the width of the image by the cap width to push the left cap out of view
        [image drawInRect:CGRectMake(0.0-capWidth, 0, buttonWidth + capWidth, image.size.height)];
    else if (location == CapMiddle)
        // To draw neither cap, we start at negative the cap width and increase the width of the image by both cap widths to push out both caps out of view
        [image drawInRect:CGRectMake(0.0-capWidth, 0, buttonWidth + (capWidth * 2), image.size.height)];
    
    UIImage* resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultImage;
}

@end
