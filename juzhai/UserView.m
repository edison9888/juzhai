//
//  User.m
//  juzhai
//
//  Created by JiaJun Wu on 12-5-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UserView.h"
#import "PostView.h"

@implementation UserView

@synthesize uid;
@synthesize nickname;
@synthesize gender;
@synthesize logo;
@synthesize smallLogo;
@synthesize bigLogo;
@synthesize originalLogo;
@synthesize rawLogo;
@synthesize logoVerifyState;
@synthesize hasLogo;
@synthesize birthYear;
@synthesize birthMonth;
@synthesize birthDay;
@synthesize constellation;
@synthesize professionId;
@synthesize profession;
@synthesize provinceId;
@synthesize provinceName;
@synthesize cityId;
@synthesize cityName;
@synthesize townId;
@synthesize townName;
@synthesize feature;
@synthesize post;
@synthesize interestMeCount;
@synthesize interestUserCount;
@synthesize postCount;
@synthesize hasGuided;
@synthesize hasInterest;

+ (id) convertFromDictionary:(NSDictionary *)info{
    UserView *user = [UserView alloc];
    [user updateFromDictionary:info];
    NSDictionary *postInfo = [info valueForKey:@"postView"];
    if(![postInfo isEqual:[NSNull null]]){
        user.post = [PostView convertFromDictionary:postInfo];
    }
    return user;
}

- (void) updateFromDictionary:(NSDictionary *)info{
    self.uid = [info valueForKey:@"uid"];
    self.nickname = [info valueForKey:@"nickname"];
    self.gender = [info valueForKey:@"gender"];
    self.logo = [info valueForKey:@"logo"];
    self.smallLogo = [info valueForKey:@"smallLogo"];
    self.bigLogo = [info valueForKey:@"bigLogo"];
    self.originalLogo = [info valueForKey:@"originalLogo"];
    self.rawLogo = [info valueForKey:@"newLogo"];
    self.logoVerifyState = [info valueForKey:@"logoVerifyState"];
    self.hasLogo = [[info valueForKey:@"hasLogo"] boolValue];
    self.birthYear = [info valueForKey:@"birthYear"];
    self.birthMonth = [info valueForKey:@"birthMonth"];
    self.birthDay = [info valueForKey:@"birthDay"];
    self.constellation = [info valueForKey:@"constellation"];
    self.professionId = [info valueForKey:@"professionId"];
    self.profession = [info valueForKey:@"profession"];
    self.provinceId = [info valueForKey:@"provinceId"];
    self.provinceName = [info valueForKey:@"provinceName"];
    self.cityId = [info valueForKey:@"cityId"];
    self.cityName = [info valueForKey:@"cityName"];
    self.townId = [info valueForKey:@"townId"];    
    self.townName = [info valueForKey:@"townName"];
    self.feature = [info valueForKey:@"feature"];
    self.interestUserCount = [info valueForKey:@"interestUserCount"];
    self.interestMeCount = [info valueForKey:@"interestMeCount"];
    self.postCount = [info valueForKey:@"postCount"];
    self.hasGuided = [info valueForKey:@"hasGuided"];
    self.hasInterest = [info valueForKey:@"hasInterest"];
}

- (NSString *)basicInfo
{
    NSMutableString *info = [NSMutableString stringWithCapacity:0];
    if(![self.birthYear isEqual:[NSNull null]]){
        NSDate *now = [NSDate date];
        NSCalendar *cal = [NSCalendar currentCalendar];
        unsigned int unitFlags = NSYearCalendarUnit;
        NSDateComponents *dd = [cal components:unitFlags fromDate:now];
        int age = [dd year] - self.birthYear.intValue;
        [info appendFormat:@"%d岁 ", age];
    }
    if(![self.constellation isEqual:[NSNull null]] && ![self.constellation isEqualToString:@""]){
        [info appendFormat:@"%@ ", self.constellation];
    }
    if (![self.profession isEqual:[NSNull null]] && ![self.profession isEqualToString:@""]) {
        [info appendFormat:@"%@", self.profession];
    }
    return info;
}

- (id)objIdentity
{
    return self.uid;
}

#pragma mark - NSCopying
-(id) copyWithZone:(NSZone *)zone{
    UserView *copy = [[[self class] allocWithZone:zone] init];
    if(copy){
        copy.uid = self.uid;
        copy.nickname = self.nickname;
        copy.gender = self.gender;
        copy.logo = self.logo;
        copy.smallLogo = self.smallLogo;
        copy.bigLogo = self.bigLogo;
        copy.rawLogo = self.rawLogo;
        copy.logoVerifyState = self.logoVerifyState;
        copy.birthYear = self.birthYear;
        copy.birthMonth = self.birthMonth;
        copy.birthDay = self.birthDay;
        copy.constellation = self.constellation;
        copy.professionId = self.professionId;
        copy.profession = self.profession;
        copy.provinceId = self.provinceId;
        copy.provinceName = self.provinceName;
        copy.cityId = self.cityId;
        copy.cityName = self.cityName;
        copy.townId = self.townId;
        copy.townName = self.townName;
        copy.feature = self.feature;
        copy.interestUserCount = self.interestMeCount;
        copy.interestMeCount = self.interestMeCount;
        copy.postCount = self.postCount;
        copy.hasGuided = self.hasGuided;
        copy.hasInterest = self.hasInterest;
        copy.post = self.post;
    }
    return copy;
}

@end
