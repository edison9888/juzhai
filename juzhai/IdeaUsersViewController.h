//
//  IdeaUsersViewController.h
//  juzhai
//
//  Created by JiaJun Wu on 12-7-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshHeaderTableViewController.h"

@class IdeaView;
@class JZData;
@class ListHttpRequestDelegate;

#define TABLE_HEAD_HEIGHT 35
#define TABLE_HEAD_BG_IMG @"want_go_pers_top_bg"

@interface IdeaUsersViewController : EGORefreshHeaderTableViewController
{
    JZData *_data;
    ListHttpRequestDelegate *_listHttpRequestDelegate;
}

@property (strong, nonatomic) IdeaView *ideaView;

@end
