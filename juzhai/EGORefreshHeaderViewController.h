//
//  EGORefreshHeaderViewController.h
//  juzhai
//
//  Created by JiaJun Wu on 12-7-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"

@interface EGORefreshHeaderViewController : UIViewController <EGORefreshTableHeaderDelegate, UIScrollViewDelegate>
{
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
    UITableView *_tableView;
}

- (void)loadListDataWithPage:(NSInteger)page;
- (void)doneLoadingTableViewData;

@end
