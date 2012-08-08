//
//  CustomIdeaListCell.h
//  juzhai
//
//  Created by JiaJun Wu on 12-8-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IdeaView;

@interface CustomIdeaListCell : UITableViewCell
{
    UIImage *_ideaPic;
}

@property (strong, nonatomic) IdeaView *ideaView;

- (void)reset;
- (void)addAllSubView;

@end
