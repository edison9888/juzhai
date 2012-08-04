//
//  User.h
//  juzhai
//
//  Created by JiaJun Wu on 12-5-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataView.h"

@class PostView;

@interface UserView : NSObject <DataView,NSCopying>

@property (strong,nonatomic) NSDecimalNumber *uid;
@property (strong,nonatomic) NSString *nickname;
@property (strong,nonatomic) NSNumber *gender;
@property (strong,nonatomic) NSString *logo;
@property (strong,nonatomic) NSString *smallLogo;
@property (strong,nonatomic) NSString *bigLogo;
@property (strong,nonatomic) NSString *rawLogo;
@property (strong,nonatomic) NSNumber *logoVerifyState;
@property (strong,nonatomic) NSNumber *birthYear;
@property (strong,nonatomic) NSNumber *birthMonth;
@property (strong,nonatomic) NSNumber *birthDay;
@property (strong,nonatomic) NSString *constellation;
@property (strong,nonatomic) NSDecimalNumber *professionId;
@property (strong,nonatomic) NSString *profession;
@property (strong,nonatomic) NSDecimalNumber *provinceId;
@property (strong,nonatomic) NSString *provinceName;
@property (strong,nonatomic) NSDecimalNumber *cityId;
@property (strong,nonatomic) NSString *cityName;
@property (strong,nonatomic) NSDecimalNumber *townId;
@property (strong,nonatomic) NSString *townName;
@property (strong,nonatomic) NSString *feature;
@property (strong,nonatomic) NSNumber *interestUserCount;
@property (strong,nonatomic) NSNumber *interestMeCount;
@property (strong,nonatomic) NSNumber *postCount;
@property (strong,nonatomic) NSNumber *hasGuided;
@property (strong,nonatomic) NSNumber *hasInterest;
@property (strong,nonatomic) PostView *post;


- (NSString *)basicInfo;

@end
