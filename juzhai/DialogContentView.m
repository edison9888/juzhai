//
//  DialogContentView.m
//  juzhai
//
//  Created by JiaJun Wu on 12-7-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DialogContentView.h"

@implementation DialogContentView

@synthesize dialogContentId;
@synthesize content;
@synthesize senderUid;
@synthesize receiverUid;
@synthesize createTime;
@synthesize imgUrl;
@synthesize hasImg;

+ (id)convertFromDictionary:(NSDictionary *)info
{
    DialogContentView *dialogContentView = [[DialogContentView alloc] init];
    if (dialogContentView) {
        dialogContentView.dialogContentId = [[info objectForKey:@"dialogContentId"] intValue];
        dialogContentView.content = [info objectForKey:@"content"];
        dialogContentView.senderUid = [[info objectForKey:@"senderUid"] intValue];
        dialogContentView.receiverUid = [[info objectForKey:@"receiverUid"] intValue];
        dialogContentView.createTime = [[info objectForKey:@"createTime"] doubleValue] / 1000;
        dialogContentView.imgUrl = [info objectForKey:@"imgUrl"];
        dialogContentView.hasImg = dialogContentView.imgUrl != nil && ![dialogContentView.imgUrl isEqual:[NSNull null]] && ![dialogContentView.imgUrl isEqualToString:@""];
    }
    return dialogContentView;
}

- (id)objIdentity
{
    return [NSNumber numberWithInt:self.dialogContentId];
}


@end
