//
//  LoginUser.h
//  juzhai
//
//  Created by JiaJun Wu on 12-5-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kFilename @"user"
#define kDataKey @"loginUser"

#define accountKey @"accountField"
#define passwordKey @"passwordField"
#define tokenKey @"tokenField"

@interface LoginUser : NSObject <NSCoding,NSCopying>

@property (strong,nonatomic) NSString *account;
@property (strong,nonatomic) NSString *password;
@property (strong,nonatomic) NSString *token;

-(id) initWithAccount:(NSString *)account password:(NSString *)password;
-(id) initFromData;
-(void) save;
-(void) reset;

@end
