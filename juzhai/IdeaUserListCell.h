//
//  IdeaUserListCell.h
//  juzhai
//
//  Created by JiaJun Wu on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListCell.h"

@class IdeaUserView;

@interface IdeaUserListCell : UITableViewCell <ListCell>
{
    IdeaUserView *_ideaUserView;
}
@property (strong, nonatomic) IBOutlet UIImageView *userLogoView;
@property (strong, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (strong, nonatomic) IBOutlet UILabel *infoLabel;
@property (strong, nonatomic) IBOutlet UIButton *sendDateButton;

@property (strong, nonatomic) NSMutableDictionary *logoDictionary;

- (IBAction)dateHim:(id)sender;

@end
