//
//  DialogView.m
//  juzhai
//
//  Created by JiaJun Wu on 12-7-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DialogView.h"
#import "UserView.h"
#import "UserContext.h"

@implementation DialogView

@synthesize dialogId;
@synthesize receiverUid;
@synthesize latestContent;
@synthesize createTime;
@synthesize dialogContentCount;
@synthesize targetUser;

+ (id) convertFromDictionary:(NSDictionary *)info{
    DialogView *dialogView = [[DialogView alloc] init];
    if (dialogView) {
        dialogView.dialogId = [[info objectForKey:@"dialogId"] intValue];
        dialogView.receiverUid = [[info objectForKey:@"receiverUid"] intValue];
        dialogView.latestContent = [info objectForKey:@"latestContent"];
        dialogView.createTime = [[info objectForKey:@"createTime"] doubleValue] / 1000;
        dialogView.dialogContentCount = [[info objectForKey:@"dialogContentCount"] intValue];
        dialogView.targetUser = [UserView convertFromDictionary:[info objectForKey:@"targetUser"]];
    }
    return dialogView;
}

- (id)objIdentity
{
    return [NSNumber numberWithInt:self.dialogId];
}

- (BOOL) isSendToMe
{
    return self.receiverUid == [UserContext getUid];
}

@end
