//
//  PostListCell.h
//  juzhai
//
//  Created by JiaJun Wu on 12-6-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListCell.h"

@class PostView;

@interface PostListCell : UITableViewCell <ListCell>
{
    PostView *_postView;
}

@property (strong, nonatomic) IBOutlet UILabel *contentLabel;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

//- (void) redrawn:(PostView *)postView;
//- (void) setBackground;
//+ (CGFloat) heightForCell:(PostView *)postView;

@end
