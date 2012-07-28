//
//  Post.m
//  juzhai
//
//  Created by JiaJun Wu on 12-5-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PostView.h"

@implementation PostView

@synthesize postId;
@synthesize purpose;
@synthesize content;
@synthesize place;
@synthesize pic;
@synthesize bigPic;
@synthesize categoryName;
@synthesize date;
@synthesize respCnt;
@synthesize hasResp;

+ (id) convertFromDictionary:(NSDictionary *)info{
    PostView *post = [PostView alloc];
    post.postId = [info valueForKey:@"postId"];
    post.purpose = [info valueForKey:@"purpose"];
    post.content = [info valueForKey:@"content"];
    post.place = [info valueForKey:@"place"];
    post.pic = [info valueForKey:@"pic"];
    post.bigPic = [info valueForKey:@"bigPic"];
    post.categoryName = [info valueForKey:@"categoryName"];
    post.date = [info valueForKey:@"date"];
    post.respCnt = [info valueForKey:@"respCnt"];
    post.hasResp = [info valueForKey:@"hasResp"];
    return post;
}

- (id)objIdentity
{
    return self.postId;
}

- (BOOL) hasPlace{
    return self.place != nil && ![self.place isEqual:[NSNull null]] && ![self.place isEqualToString:@""];
}

- (BOOL) hasTime{
    return self.date != nil && ![self.date isEqual:[NSNull null]] && ![self.date isEqualToString:@""];
}

- (BOOL) hasCategory{
    return self.categoryName != nil && ![self.categoryName isEqual:[NSNull null]] && ![self.categoryName isEqualToString:@""];
}

@end
