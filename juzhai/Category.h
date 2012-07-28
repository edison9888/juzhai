//
//  Category.h
//  juzhai
//
//  Created by JiaJun Wu on 12-6-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Category : NSObject
    
@property (nonatomic, retain) NSDecimalNumber *categoryId;
@property (nonatomic, retain) NSString *name;

- (id) initWithCategoryId:(NSDecimalNumber *)categoryId withName:(NSString *)name;

@end
