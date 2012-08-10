//
//  ShareIdeaInputViewController.h
//  juzhai
//
//  Created by JiaJun Wu on 12-8-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IdeaView;
@class CustomTextView;

@interface ShareIdeaInputViewController : UIViewController
{
    UIButton *_saveButton;
}

@property (strong, nonatomic) NSString *navTitle;
@property (strong, nonatomic) IdeaView *ideaView;
@property (strong, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (strong, nonatomic) IBOutlet CustomTextView *textView;

@end
