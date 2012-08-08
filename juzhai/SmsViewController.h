//
//  SmsViewController.h
//  juzhai
//
//  Created by JiaJun Wu on 12-7-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshHeaderViewController.h"

@class JZData;
@class HomeViewController;
@class ListHttpRequestDelegate;

@interface SmsViewController : EGORefreshHeaderViewController <UITableViewDelegate, UITableViewDataSource>
{
    JZData *_data;
    UIButton *_editButton;
    ListHttpRequestDelegate *_listHttpRequestDelegate;
}

@end
