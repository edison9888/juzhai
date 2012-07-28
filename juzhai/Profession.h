//
//  Profession.h
//  juzhai
//
//  Created by JiaJun Wu on 12-6-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Profession : NSObject

@property (nonatomic, retain) NSDecimalNumber *professionId;
@property (nonatomic, retain) NSString *name;

- (id) initWithProfessionId:(NSDecimalNumber *)professionId withName:(NSString *)name;

@end
