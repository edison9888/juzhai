//
//  UserPostViewController.h
//  juzhai
//
//  Created by JiaJun Wu on 12-7-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EGORefreshHeaderViewController.h"

@class JZData;
@class ListHttpRequestDelegate;

@interface UserPostViewController : EGORefreshHeaderViewController <UITableViewDataSource, UITableViewDelegate>
{
    JZData *_data;
    ListHttpRequestDelegate *_listHttpRequestDelegate;
}
@end
