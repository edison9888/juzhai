//
//  IdeaListCell.h
//  juzhai
//
//  Created by JiaJun Wu on 12-5-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListCell.h"
@class IdeaView;

#define IDEA_IMAGE_TAG 1
#define IDEA_CONTENT_TAG 2
#define IDEA_WANT_TO_TAG 3

#define NORMAL_WANT_BUTTON_IMAGE @"idea_wgo_btn_link.png"
#define HIGHLIGHT_WANT_BUTTON_IMAGE @"idea_wgo_btn_hover.png"
#define DISABLE_WANT_BUTTON_IMAGE @"idea_wgo_btn_done.png"
#define WANT_BUTTON_CAP_WIDTH 26.0

@interface IdeaListCell : UITableViewCell <ListCell>
{
    IdeaView *_ideaView;
}

@property (strong, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)wantGo:(id)sender;

@end
