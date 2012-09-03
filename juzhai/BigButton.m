//
//  BigButton.m
//  juzhai
//
//  Created by JiaJun Wu on 12-8-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BigButton.h"

@implementation BigButton

- (id)initWithWidth:(NSUInteger)width buttonText:(NSString *)buttonText CapLocation:(CapLocation)location
{
    self.delegate = self;
    return [super initWithWidth:width buttonText:buttonText CapLocation:location];
}

- (CGFloat)buttonCapWidth
{
    return BIG_BUTTON_CAP_WIDTH;
}

- (NSString *)buttonNormalBackgroundImageName
{
    return BIG_BUTTON_IMAGE;
}

//- (NSString *)buttonHighlightedBackgroundImageName
//{
//    return nil;
//}

@end
