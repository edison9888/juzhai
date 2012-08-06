//
//  WholeImageViewController.h
//  juzhai
//
//  Created by JiaJun Wu on 12-8-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WholeImageViewDelegate;

@interface WholeImageViewController : UIViewController
{
    UIActivityIndicatorView *_loadingView;
    UIImageView *_imageView;
}
@property (strong, nonatomic) id<WholeImageViewDelegate> delegate;
@property (strong, nonatomic) NSString *imageUrl;
@property (strong, nonatomic) UIImage *image;

@end

@protocol WholeImageViewDelegate<NSObject>

@optional
- (void)cancelButtonClicked:(WholeImageViewController*)wholeImageViewController;

@end
