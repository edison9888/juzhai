//
//  NSString+Chinese.m
//  juzhai
//
//  Created by JiaJun Wu on 12-6-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NSString+Chinese.h"

@implementation NSString (Chinese)

-(NSInteger) chineseLength{
    if ([self isEqual:[NSNull null]] || [self isEqualToString:@""]) {
        return 0;
    }
    NSInteger length = 0;
    for (int i = 0; i < [self length]; i++) {
        if ([self characterAtIndex:i] < 0x80) {
            length += 1;
        }else {
            length += 2;
        }
    }
    return length;
}

@end
