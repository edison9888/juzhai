//
//  GuidanceViewController.h
//  juzhai
//
//  Created by JiaJun Wu on 12-8-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define GUIDANCE_USED(appVersion) [NSString stringWithFormat:@"%@_guidance_used", appVersion]

@interface GuidanceViewController : UIViewController <UIScrollViewDelegate>
{
    NSArray *_imageArray;
    NSMutableArray *_imageViewArray;
    BOOL _pageControlUsed;
}
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;

- (IBAction)changePage:(id)sender;

@end
