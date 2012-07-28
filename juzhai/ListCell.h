//
//  ListCell.h
//  juzhai
//
//  Created by JiaJun Wu on 12-7-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ListCell <NSObject>

@required
+ (id) cellFromNib;

@optional
- (void) redrawn:(id)objView;
- (void) setBackground;
+ (CGFloat) heightForCell:(id)objView;

@end
