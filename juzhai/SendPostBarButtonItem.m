//
//  SendPostBarButtonItem.m
//  juzhai
//
//  Created by JiaJun Wu on 12-7-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SendPostBarButtonItem.h"
#import "SendPostViewController.h"

@implementation SendPostBarButtonItem

- (id) initWithOwnerViewController:(UIViewController *)ownerViewController
{
    self = [super init];
    if (self) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *image = [UIImage imageNamed:@"send_icon.png"];
        UIImage *activeImage = [UIImage imageNamed:@"send_icon_hover.png"];
        button.frame = CGRectMake(0, 0, image.size.width, image.size.height);
        [button setBackgroundImage:image forState:UIControlStateNormal];
        [button setBackgroundImage:activeImage forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(goToSendPost:) forControlEvents:UIControlEventTouchUpInside];
        self.customView = button;
        _ownerViewController = ownerViewController;
    }
    
    return self;
}

-(IBAction)goToSendPost:(id)sender{
    SendPostViewController *sendPostViewController = [[SendPostViewController alloc] initWithNibName:@"SendPostViewController" bundle:nil];
    [_ownerViewController presentModalViewController:sendPostViewController animated:YES];
}

@end
