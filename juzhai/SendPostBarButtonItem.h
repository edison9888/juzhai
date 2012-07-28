//
//  SendPostBarButtonItem.h
//  juzhai
//
//  Created by JiaJun Wu on 12-7-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendPostBarButtonItem : UIBarButtonItem
{
    UIViewController *_ownerViewController;
}

- (id) initWithOwnerViewController:(UIViewController *)ownerViewController;
@end
