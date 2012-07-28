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

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame buttonText:(NSString *)buttonText buttonImage:(UIImage *)image buttonPressedImage:(UIImage *)pressedImage{
    self = [UIButton buttonWithType:UIButtonTypeCustom];
    if (self) {
        self.frame = frame;
        self.titleLabel.font = [UIFont fontWithName:DEFAULT_FONT_FAMILY size:12.0];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.shadowOffset = CGSizeMake(0,-1);
        self.titleLabel.shadowColor = [UIColor darkGrayColor];
        [self setTitle:buttonText forState:UIControlStateNormal];
        
        [self setBackgroundImage:image forState:UIControlStateNormal];
        [self setBackgroundImage:pressedImage forState:UIControlStateHighlighted];
        [self setBackgroundImage:pressedImage forState:UIControlStateSelected];
        self.adjustsImageWhenHighlighted = NO;
    }
    return self;
}

- (id)initWithWidth:(NSUInteger)width buttonText:(NSString *)buttonText CapLocation:(CapLocation)location
{
    UIImage* buttonImage = nil;
    UIImage* buttonPressedImage = nil;
    if (location == CapLeftAndRight)
    {
        buttonImage = [[UIImage imageNamed:[self.delegate buttonNormalBackgroundImageName]] stretchableImageWithLeftCapWidth:[self.delegate buttonCapWidth] topCapHeight:0.0];
        buttonPressedImage = [[UIImage imageNamed:[self.delegate buttonHighlightedBackgroundImageName]] stretchableImageWithLeftCapWidth:[self.delegate buttonCapWidth] topCapHeight:0.0];
    }
    else
    {
        buttonImage = [self image:[[UIImage imageNamed:[self.delegate buttonNormalBackgroundImageName]] stretchableImageWithLeftCapWidth:[self.delegate buttonCapWidth] topCapHeight:0.0] withCap:location capWidth:[self.delegate buttonCapWidth] buttonWidth:width];
        buttonPressedImage = [self image:[[UIImage imageNamed:[self.delegate buttonHighlightedBackgroundImageName]] stretchableImageWithLeftCapWidth:[self.delegate buttonCapWidth] topCapHeight:0.0] withCap:location capWidth:[self.delegate buttonCapWidth] buttonWidth:width];
    }
    return [self initWithFrame:CGRectMake(0, 0, width, buttonImage.size.height) buttonText:buttonText buttonImage:buttonImage buttonPressedImage:buttonPressedImage];
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
