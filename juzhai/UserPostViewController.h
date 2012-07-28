//
//  UserPostViewController.h
//  juzhai
//
//  Created by JiaJun Wu on 12-7-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EGORefreshHeaderTableViewController.h"

@class JZData;
@class ListHttpRequestDelegate;

@interface UserPostViewController : EGORefreshHeaderTableViewController
{
    JZData *_data;
    ListHttpRequestDelegate *_listHttpRequestDelegate;
}
@end
