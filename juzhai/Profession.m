//
//  Profession.m
//  juzhai
//
//  Created by JiaJun Wu on 12-6-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Profession.h"

@implementation Profession

@synthesize professionId;
@synthesize name;

- (id) initWithProfessionId:(NSDecimalNumber *)pId withName:(NSString *)pName{
    self = [super init];
    if(self){
        self.professionId = pId;
        self.name = pName;
    }
    return self;
}
@end
