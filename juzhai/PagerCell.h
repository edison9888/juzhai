//
//  PagerCell.h
//  juzhai
//
//  Created by JiaJun Wu on 12-7-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define PAGER_CELL_HEIGHT 40

@interface PagerCell : UITableViewCell
{
    UILabel *_titleLabel;
    UIActivityIndicatorView *_loadingView;
}

- (void) reset;

+ (PagerCell *)dequeueReusablePagerCell:(UITableView *)tableView;

@end
