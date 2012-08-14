//
//  SmsListCell.h
//  juzhai
//
//  Created by JiaJun Wu on 12-7-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListCell.h"

@class DialogView;

@interface SmsListCell : UITableViewCell <ListCell>
{
    DialogView *_dialogView;
}

@property (strong, nonatomic) IBOutlet UIImageView *userLogoView;
@property (strong, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (strong, nonatomic) IBOutlet UILabel *infoLabel;
@property (strong, nonatomic) IBOutlet UIImageView *targetImageView;
@property (strong, nonatomic) IBOutlet UILabel *latestContentLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

@property (strong, nonatomic) NSMutableDictionary *logoDictionary;

@end
