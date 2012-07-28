//
//  DialogView.h
//  juzhai
//
//  Created by JiaJun Wu on 12-7-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataView.h"

@class UserView;

@interface DialogView : NSObject <DataView>

@property (nonatomic) NSInteger dialogId;
@property (nonatomic) NSInteger receiverUid;
@property (strong, nonatomic) NSString *latestContent;
@property (nonatomic) NSTimeInterval createTime;
@property (nonatomic) NSInteger dialogContentCount;
@property (strong, nonatomic) UserView *targetUser;

- (BOOL) isSendToMe;
@end
