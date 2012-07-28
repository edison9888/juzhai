//
//  GrowingTextView.h
//  juzhai
//
//  Created by JiaJun Wu on 12-7-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CustomTextView.h"
@class GrowingTextViewDelegate;

@interface GrowingTextView : CustomTextView
{
    GrowingTextViewDelegate *_growingTextViewDelegate;
    CGFloat minHeight;
	CGFloat maxHeight;
}

//growing
@property (nonatomic,setter = setMaxNumberOfLines:) NSInteger maxNumberOfLines;
@property (nonatomic,setter = setMinNumberOfLines:) NSInteger minNumberOfLines;

- (CGFloat)getMinHeight;
- (CGFloat)getMaxHeight;
- (void)setMaxNumberOfLines:(NSInteger)maxNumberOfLines;
- (void)setMinNumberOfLines:(NSInteger)minNumberOfLines;


@end
