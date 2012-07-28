//
//  ProfileValidation.h
//  juzhai
//
//  Created by JiaJun Wu on 12-7-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define PROFESSION_MIN_LENGTH 2
#define PROFESSION_MAX_LENGTH 20
#define PROFESSION_MIN_ERROR_TEXT @"职业描述不能少于1个字"
#define PROFESSION_MAX_ERROR_TEXT @"职业描述请不要超过10个字"

#define FEATURE_MIN_LENGTH 1
#define FEATURE_MAX_LENGTH 140
#define FEATURE_MIN_ERROR_TEXT @"自我评价不能为空"
#define FEATURE_MAX_ERROR_TEXT @"自我评价请不要超过70个字"

#define NICK_MIN_LENGTH 1
#define NICK_MAX_LENGTH 20
#define NICK_LENGTH_ERROR_TEXT @"昵称必须1-10个字以内"
#define NICK_EXIST_ERROR_TEXT @"昵称已存在了换一个吧"


@interface ProfileValidation : NSObject

+ (NSString *) validateNickname:(NSString *)nickname;
+ (NSString *) validateFeature:(NSString *)feature;
+ (NSString *) validateProfession:(NSString *)profession;

@end
