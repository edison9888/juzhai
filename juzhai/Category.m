//
//  Category.m
//  juzhai
//
//  Created by JiaJun Wu on 12-6-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Category.h"

@implementation Category

@synthesize categoryId;
@synthesize name;

- (id) initWithCategoryId:(NSDecimalNumber *)cId withName:(NSString *)cName{
    self = [super init];
    if(self){
        self.categoryId = cId;
        self.name = cName;
    }
    return self;
}

@end
