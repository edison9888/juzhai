//
//  ProfileValidation.m
//  juzhai
//
//  Created by JiaJun Wu on 12-7-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ProfileValidation.h"
#import "NSString+Chinese.h"
#import "HttpRequestSender.h"
#import "UrlUtils.h"
#import "SBJson.h"

@implementation ProfileValidation

+ (NSString *) validateNickname:(NSString *)nickname
{
    NSInteger textLength = [nickname chineseLength];
    if (textLength < FEATURE_MIN_LENGTH || textLength > FEATURE_MAX_LENGTH) {
        return NICK_LENGTH_ERROR_TEXT;
    }
    
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:nickname, @"nickname", nil];
    ASIFormDataRequest *request = [HttpRequestSender postRequestWithUrl:[UrlUtils urlStringWithUri:@"profile/validate/nickexist"] withParams:params];
    if (request) {
        [request startSynchronous];
        NSError *error = [request error];
        if (!error && [request responseStatusCode] == 200){
            NSString *response = [request responseString];
            NSMutableDictionary *jsonResult = [response JSONValue];
            if([jsonResult valueForKey:@"success"] == [NSNumber numberWithBool:NO]){
                if ([jsonResult valueForKey:@"result"] == [NSNumber numberWithBool:YES]) {
                    return [jsonResult valueForKey:@"errorInfo"];
                }
            }
        }else{
            NSLog(@"error: %@", [error description]);
        }
    }
    return nil;
}

+ (NSString *) validateFeature:(NSString *)feature
{
    NSInteger textLength = [feature chineseLength];
    if (textLength < FEATURE_MIN_LENGTH) {
        return FEATURE_MIN_ERROR_TEXT;
    }
    if (textLength > FEATURE_MAX_LENGTH) {
        return FEATURE_MAX_ERROR_TEXT;
    }
    return nil;
}

+ (NSString *) validateProfession:(NSString *)profession
{
    NSInteger textLength = [profession chineseLength];
    if (textLength < PROFESSION_MIN_LENGTH) {
        return PROFESSION_MIN_ERROR_TEXT;
    }
    if (textLength > PROFESSION_MAX_LENGTH) {
        return PROFESSION_MAX_ERROR_TEXT;
    }
    return nil;
}

@end
