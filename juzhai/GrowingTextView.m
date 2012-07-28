//
//  GrowingTextView.m
//  juzhai
//
//  Created by JiaJun Wu on 12-7-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GrowingTextView.h"
#import "GrowingTextViewDelegate.h"

@implementation GrowingTextView

@synthesize minNumberOfLines;
@synthesize maxNumberOfLines;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _growingTextViewDelegate = [[GrowingTextViewDelegate alloc] init];
        self.delegate = _growingTextViewDelegate;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _growingTextViewDelegate = [[GrowingTextViewDelegate alloc] init];
        self.delegate = _growingTextViewDelegate;
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        _growingTextViewDelegate = [[GrowingTextViewDelegate alloc] init];
        self.delegate = _growingTextViewDelegate;
    }
    return self;
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    [_growingTextViewDelegate performSelector:@selector(textViewDidChange:) withObject:self];
}

- (void)sizeToFit
{
	CGRect r = self.frame;
    
    // check if the text is available in text view or not, if it is available, no need to set it to minimum lenth, it could vary as per the text length
    // fix from Ankit Thakur
    if ([self.text length] > 0) {
        return;
    } else {
        r.size.height = minHeight;
        self.frame = r;
    }
}

- (void)setCustomDelegate:(id<CustomTextViewDelegate>)customDelegate
{
    _growingTextViewDelegate.customDelegate = customDelegate;
}

- (void)setMaxNumberOfLines:(NSInteger)maxLines
{
    NSString *saveText = self.text;
    NSString *newText = @"-";
    
    self.delegate = nil;
    self.hidden = YES;
    
    for (int i = 1; i < maxLines; ++i)
        newText = [newText stringByAppendingString:@"\n|W|"];
    
    self.text = newText;
    
    maxHeight = self.contentSize.height;
    
    self.text = saveText;
    self.hidden = NO;
    self.delegate = _growingTextViewDelegate;
    
    [self sizeToFit];
    
    maxNumberOfLines = maxLines;
}

- (void)setMinNumberOfLines:(NSInteger)minLines
{
    NSString *saveText = self.text;
    NSString *newText = @"-";
    
    self.delegate = nil;
    self.hidden = YES;
    
    for (int i = 1; i < minLines; ++i)
        newText = [newText stringByAppendingString:@"\n|W|"];
    
    self.text = newText;
    
    minHeight = self.contentSize.height;
    
    self.text = saveText;
    self.hidden = NO;
    self.delegate = _growingTextViewDelegate;
    
    [self sizeToFit];
    
    minNumberOfLines = minLines;
}

- (CGFloat)getMinHeight
{
    return minHeight;
}

- (CGFloat)getMaxHeight
{
    return maxHeight;
}

@end
