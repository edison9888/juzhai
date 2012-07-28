//
//  GrowingTextViewDelegate.h
//  juzhai
//
//  Created by JiaJun Wu on 12-7-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomTextView.h"

@interface GrowingTextViewDelegate : NSObject <UITextViewDelegate>

@property (strong, nonatomic) id<CustomTextViewDelegate> customDelegate;

@end
