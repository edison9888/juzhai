//
//  LoginUser.m
//  juzhai
//
//  Created by JiaJun Wu on 12-5-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LoginUser.h"

@implementation LoginUser

@synthesize account;
@synthesize password;
@synthesize token;

- (NSString *) dataFilePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:kFilename];
}

-(id)initWithAccount:(NSString *)acc password:(NSString *)pwd{
    self = [super init];
    if(self){
        self.account = acc;
        self.password = pwd;
    }
    return self;
}

-(id)initFromData{
    NSMutableData *data = [[NSMutableData alloc] initWithContentsOfFile:[self dataFilePath]];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    self = [unarchiver decodeObjectForKey:kDataKey];
    [unarchiver finishDecoding];
    return self;
}

-(void) save{
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:self forKey:kDataKey];
    [archiver finishEncoding];
    [data writeToFile:[self dataFilePath] atomically:YES];
}

-(void) reset{
    self.account = @"";
    self.password = @"";
    self.token = @"";
    [self save];
}

#pragma mark - NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:account forKey:accountKey];
    [aCoder encodeObject:password forKey:passwordKey];
    [aCoder encodeObject:token forKey:tokenKey];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super init]){
        self.account = [aDecoder decodeObjectForKey:accountKey];
        self.password = [aDecoder decodeObjectForKey:passwordKey];
        self.token = [aDecoder decodeObjectForKey:tokenKey];
    }
    return self;
}

#pragma mark - NSCopying
-(id) copyWithZone:(NSZone *)zone{
    LoginUser *copy = [[[self class] allocWithZone:zone] init];
    if(copy){
        copy.account = [self.account copyWithZone:zone];
        copy.password = [self.password copyWithZone:zone];
        copy.token = [self.token copyWithZone:zone];
    }
    return copy;
}

@end
