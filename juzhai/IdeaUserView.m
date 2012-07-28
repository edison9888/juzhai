//
//  IdeaUserView.m
//  juzhai
//
//  Created by JiaJun Wu on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IdeaUserView.h"
#import "UserView.h"

@implementation IdeaUserView

@synthesize ideaId;
@synthesize userView;
@synthesize createTime;

+ (id)convertFromDictionary:(NSDictionary *)info
{
    IdeaUserView *ideaUserView = [[IdeaUserView alloc] init];
    if (ideaUserView) {
        ideaUserView.ideaId = [[info objectForKey:@"ideaId"] intValue];
        ideaUserView.userView = [UserView convertFromDictionary:[info objectForKey:@"userView"]];
        ideaUserView.createTime = [[info objectForKey:@"createTime"] doubleValue] / 1000;
    }
    return ideaUserView;
}

- (id)objIdentity
{
    return self.userView.uid;
}

@end
