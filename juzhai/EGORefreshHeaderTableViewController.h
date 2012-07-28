//
//  EGORefreshTableHeaderViewController.h
//  juzhai
//
//  Created by JiaJun Wu on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"

@interface EGORefreshHeaderTableViewController : UITableViewController <EGORefreshTableHeaderDelegate>
{
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
}

- (void)loadListDataWithPage:(NSInteger)page;
- (void)doneLoadingTableViewData;

@end
