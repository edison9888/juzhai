//
//  DataView.h
//  juzhai
//
//  Created by JiaJun Wu on 12-7-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DataView <NSObject>

@required
+ (id) convertFromDictionary:(NSDictionary *)info;
- (id)objIdentity;

@optional
- (void) updateFromDictionary:(NSDictionary *)info;

@end
