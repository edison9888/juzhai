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
@synthesize icon;

- (id) initWithCategoryId:(NSInteger)cId withName:(NSString *)cName withIcon:(NSString *)ico{
    self = [super init];
    if(self){
        self.categoryId = cId;
        self.name = cName;
        self.icon = ico;
    }
    return self;
}

@end
