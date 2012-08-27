//
//  DialogContentView.h
//  juzhai
//
//  Created by JiaJun Wu on 12-7-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataView.h"

#define REQUEST_USER_INFO_KEY @"kDialog"

typedef enum {
    SendStatusWaiting = 1,
    SendStatusSending = 2,
    SendStatusFailure = 3,
    SendStatusFinish = 4,
} SendStatus;

@interface DialogContentView : NSObject <DataView>

@property (nonatomic) NSInteger dialogContentId;
@property (strong, nonatomic) NSString *content;
@property (nonatomic) NSInteger senderUid;
@property (nonatomic) NSInteger receiverUid;
@property (nonatomic) NSTimeInterval createTime;
@property (strong, nonatomic) NSString *imgUrl;
@property (nonatomic) BOOL hasImg;
@property (strong, nonatomic) UIImage *image;
@property (nonatomic) SendStatus sendStatus;
@end
