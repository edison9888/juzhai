//
//  CustomNavigationController.h
//  juzhai
//
//  Created by JiaJun Wu on 12-5-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TOP_BG_CAP_WIDTH 6

#define TOP_BG_PIC_NAME @"app_top_nav_bg.png"
#define BACK_NORMAL_PIC_NAME @"back_btn_link.png"
#define BACK_HIGHLIGHT_PIC_NAME @"back_btn_hover.png"
#define HOME_NORMAL_PIC_NAME @"home_btn_link.png"
#define HOME_HIGHLIGHT_PIC_NAME @"home_btn_hover.png"

#define TOP_BG_IMG [[UIImage imageNamed:TOP_BG_PIC_NAME] stretchableImageWithLeftCapWidth:TOP_BG_CAP_WIDTH topCapHeight:0]

@interface CustomNavigationController : UINavigationController
{
    UIBarButtonItem *_backItem;
    UIBarButtonItem *_homeItem;
}
- (void) customBackButton;
- (void) customHomeButton;

@end
