//
//  CustomTextView.h
//  juzhai
//
//  Created by JiaJun Wu on 12-7-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomTextView;

@protocol CustomTextViewDelegate <UITextViewDelegate>

@optional
- (void)textView:(CustomTextView *)textView willChangeHeight:(float)addHeight;
- (void)textView:(CustomTextView *)textView didChangeHeight:(float)addHeight;

@end

@interface CustomTextView : UITextView
{
    UIImageView *_backgroundImageView;
}

@property (strong, nonatomic) UIImage *backgroundImage;

- (void)setCustomDelegate:(id<CustomTextViewDelegate>)customDelegate;

@end
