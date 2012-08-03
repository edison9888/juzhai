//
//  Category.h
//  juzhai
//
//  Created by JiaJun Wu on 12-6-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Category : NSObject
    
@property (nonatomic) NSInteger categoryId;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *icon;

- (id) initWithCategoryId:(NSInteger)categoryId withName:(NSString *)name withIcon:(NSString *)icon;

@end
