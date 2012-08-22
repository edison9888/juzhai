//
//  IdeaViewController.h
//  juzhai
//
//  Created by JiaJun Wu on 12-5-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FPPopoverController.h"
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshHeaderViewController.h"
#import "CustomSegmentedControl.h"

@class EGORefreshTableHeaderView;
@class IdeaDetailViewController;
@class JZData;
@class ListHttpRequestDelegate;

enum {
    OrderTypeTime = 0,
    OrderTypeRecommend = 1
};

#define ALL_CATEGORY_ID 0

#define HOT_ORDER_BTN_IMG @"zuire_btn"
#define TIME_ORDER_BTN_IMG @"zuixin_btn"

#define CATEGORY_DOWN_LINK_IMG @"select_down_link"
#define CATEGORY_DOWN_HOVER_IMG @"select_down_hover"
#define CATEGORY_UP_LINK_IMG @"select_up_link"
#define CATEGORY_up_HOVER_IMG @"select_up_hover"

@interface IdeaViewController : EGORefreshHeaderViewController <FPPopoverControllerDelegate, CustomSegmentedControlDelegate, UITableViewDelegate, UITableViewDataSource>
{	
	JZData *_data;
    FPPopoverController *_categoryPopver;
    CustomSegmentedControl *_segmentedControl;
    UIButton *_categoryButton;
    UIImage *_categoryDownLinkImg;
    UIImage *_categoryDownHoverImg;
    UIImage *_categoryUpLinkImg;
    UIImage *_categoryUpHoverImg;
    ListHttpRequestDelegate *_listHttpRequestDelegate;
    NSMutableDictionary *_imageDictory;
}

//- (void)reloadTableViewDataSource;
//- (void)doneLoadingTableViewData;

@end
