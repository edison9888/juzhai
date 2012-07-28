//
//  GrowingTextViewDelegate.m
//  juzhai
//
//  Created by JiaJun Wu on 12-7-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GrowingTextViewDelegate.h"
#import "GrowingTextView.h"

@implementation GrowingTextViewDelegate

@synthesize customDelegate;


- (void)resizeTextView:(UITextView *)textView height:(NSInteger)newSizeH
{
    if (customDelegate && [customDelegate respondsToSelector:@selector(textView:willChangeHeight:)]) {
        [customDelegate textView:(CustomTextView *)textView willChangeHeight:(newSizeH - textView.frame.size.height)];
    }
    
    CGRect textViewFrame = textView.frame;
    textViewFrame.size.height = newSizeH; // + padding
    textView.frame = textViewFrame;
}

#pragma mark -
#pragma mark UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if (customDelegate && [customDelegate respondsToSelector:@selector(textViewShouldBeginEditing:)]) {
        return [customDelegate textViewShouldBeginEditing:textView];
    }
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if (customDelegate && [customDelegate respondsToSelector:@selector(textViewShouldEndEditing:)]) {
        return [customDelegate textViewShouldEndEditing:textView];
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if (customDelegate && [customDelegate respondsToSelector:@selector(textViewDidBeginEditing:)]) {
        [customDelegate textViewDidBeginEditing:textView];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (customDelegate && [customDelegate respondsToSelector:@selector(textViewDidEndEditing:)]) {
        [customDelegate textViewDidEndEditing:textView];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (customDelegate && [customDelegate respondsToSelector:@selector(textView:shouldChangeTextInRange:replacementText:)]) {
        return [customDelegate textView:textView shouldChangeTextInRange:range replacementText:text];
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    GrowingTextView *growingTextView = (GrowingTextView *)textView;
    CGFloat minHeight = [growingTextView getMinHeight];
    CGFloat maxHeight = [growingTextView getMaxHeight];
    if (minHeight <= 0 || maxHeight <= 0) {
        return;
    }
    
    CGFloat newSizeH = growingTextView.contentSize.height;
    
    //安全校验
	if(newSizeH < minHeight || !growingTextView.hasText)
    {
        newSizeH = minHeight;
    }
    if (growingTextView.frame.size.height > maxHeight)
    {
        newSizeH = maxHeight;
    }
    
    //开始转变
    if (growingTextView.frame.size.height != newSizeH)
    {
        if (newSizeH > maxHeight && growingTextView.frame.size.height <= maxHeight)
        {
            newSizeH = maxHeight;
        }
        
		if (newSizeH <= maxHeight)
		{
            CGFloat addHeight = newSizeH - growingTextView.frame.size.height;
            [self resizeTextView:growingTextView height:newSizeH];
            if (customDelegate && [customDelegate respondsToSelector:@selector(textView:didChangeHeight:)]) {
                [customDelegate textView:(CustomTextView *)textView didChangeHeight:addHeight];
            }
        }
        if (newSizeH >= maxHeight)
        {
            if(!growingTextView.scrollEnabled){
                growingTextView.scrollEnabled = YES;
                [growingTextView flashScrollIndicators];
            }
            
        } else {
            growingTextView.scrollEnabled = NO;
        }
    }
    
    if (customDelegate && [customDelegate respondsToSelector:@selector(textViewDidChange:)]) {
        [customDelegate textViewDidChange:textView];
    }
}

- (void)textViewDidChangeSelection:(UITextView *)textView
{
    if (customDelegate && [customDelegate respondsToSelector:@selector(textViewDidChangeSelection:)]) {
        [customDelegate textViewDidChangeSelection:textView];
    }
}

@end
