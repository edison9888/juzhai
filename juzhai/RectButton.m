//
//  RectButton.m
//  juzhai
//
//  Created by JiaJun Wu on 12-7-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RectButton.h"

@implementation RectButton

- (id)initWithWidth:(NSUInteger)width buttonText:(NSString *)buttonText CapLocation:(CapLocation)location
{
    self.delegate = self;
    return [super initWithWidth:width buttonText:buttonText CapLocation:location];
}

- (CGFloat)buttonCapWidth
{
    return CAP_WIDTH;
}

- (NSString *)buttonNormalBackgroundImageName
{
    return BUTTON_IMAGE;
}

- (NSString *)buttonHighlightedBackgroundImageName
{
    return BUTTON_HOVER_IMAGE;
}

- (NSString *)buttonDisabledBackgroundImageName
{
    return BUTTON_DISABLE_IMAGE;
}

@end
