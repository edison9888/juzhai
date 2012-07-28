//
//  RefreshButton.m
//  juzhai
//
//  Created by JiaJun Wu on 12-7-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RefreshButton.h"

@implementation RefreshButton

- (id)init
{
    UIImage *linkImage = [UIImage imageNamed:@"shuaxin_link"];
    UIImage *hoverImage = [UIImage imageNamed:@"shuaxin_hover"];
    CGRect frame = CGRectMake(0, 0, linkImage.size.width, linkImage.size.height);
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundImage:linkImage forState:UIControlStateNormal];
        [self setBackgroundImage:hoverImage forState:UIControlStateHighlighted];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
