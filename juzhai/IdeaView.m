//
//  Idea.m
//  juzhai
//
//  Created by JiaJun Wu on 12-5-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IdeaView.h"
#import "SBJson.h"

@implementation IdeaView

@synthesize ideaId;
@synthesize content;
@synthesize place;
@synthesize startTime;
@synthesize endTime;
@synthesize charge;
@synthesize cityName;
@synthesize townName;
@synthesize categoryName;
@synthesize useCount;
@synthesize pic;
@synthesize bigPic;
@synthesize hasUsed;

+ (id)convertFromDictionary:(NSDictionary *)info
{
    IdeaView *idea = [IdeaView alloc];
    idea.ideaId = [[info valueForKey:@"ideaId"] intValue];
    idea.content = [info valueForKey:@"content"];
    idea.place = [info valueForKey:@"place"];
    idea.startTime = [info valueForKey:@"startTime"];
    idea.endTime = [info valueForKey:@"endTime"];
    id charge = [info valueForKey:@"charge"];
    idea.charge = [charge isEqual:[NSNull null]] ? 0 : [charge intValue];
    idea.cityName = [info valueForKey:@"cityName"];
    idea.townName = [info valueForKey:@"townName"];
    idea.categoryName = [info valueForKey:@"categoryName"];
    idea.useCount = [[info valueForKey:@"useCount"] intValue];
    idea.hasUsed = [[info valueForKey:@"hasUsed"] boolValue];
    idea.pic = [info valueForKey:@"pic"];
    idea.bigPic = [info valueForKey:@"bigPic"];
    return idea;
}

- (id)objIdentity
{
    return [NSNumber numberWithInt:self.ideaId];
}

- (BOOL)hasPlace
{
    return self.place != nil && ![self.place isEqual:[NSNull null]] && ![self.place isEqualToString:@""];
}

- (BOOL)hasTime
{
    return [self hasStartTime] || [self hasEndTime];
}

- (BOOL)hasStartTime
{
    return self.startTime != nil && ![self.startTime isEqual:[NSNull null]] && ![self.startTime isEqualToString:@""];
}

- (BOOL)hasEndTime
{
    return self.endTime != nil && ![self.endTime isEqual:[NSNull null]] && ![self.endTime isEqualToString:@""];
}

- (BOOL)hasCategory
{
    return self.categoryName != nil && ![self.categoryName isEqual:[NSNull null]] && ![self.categoryName isEqualToString:@""];
}

- (BOOL)hasPerson
{
    return self.useCount > 0;
}

- (NSString *)shareSmsText
{
    return [NSString stringWithFormat:@"想一起去：%@么？（来自 拒宅iphone版）%@", self.content, @"http://www.51juzhai.com"];
}

- (NSString *)shareMailText
{
    NSMutableString *text = [NSMutableString stringWithFormat:@"想一起去：%@么？", self.content];
    if ([self hasPlace]) {
        [text appendFormat:@"地点：%@", self.place];
    }
    [text appendFormat:@" <a href=\"http://www.51juzhai.com/idea/%d\">去看看</a>", self.ideaId];
    if (self.bigPic != nil && ![self.bigPic isEqual:[NSNull null]] && ![self.bigPic isEqualToString:@""]) {
        [text appendFormat:@"<br /><br /><a href=\"http://www.51juzhai.com/idea/%d\"><img width=\"225\" src=\"%@\" /></a>", self.ideaId, self.bigPic];    
    }
    return text;
}

- (NSString *)shareThirdpartyText
{
    NSMutableString *text = [NSMutableString stringWithFormat:@"想一起去：%@么？", self.content];
    if ([self hasPlace]) {
        [text appendFormat:@"地点：%@", self.place];
    }
    [text appendFormat:@" http://www.51juzhai.com/idea/%d", self.ideaId];
    return text;
}

@end
