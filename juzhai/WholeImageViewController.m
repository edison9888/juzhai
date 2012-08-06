//
//  WholeImageViewController.m
//  juzhai
//
//  Created by JiaJun Wu on 12-8-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "WholeImageViewController.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "UIImage+UIImageExt.h"
#import "UIViewController+MJPopupViewController.h"

@interface WholeImageViewController ()
@end

@implementation WholeImageViewController

@synthesize image;
@synthesize imageUrl;
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id) init
{
    self = [super init];
    if (self) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.userInteractionEnabled = YES;
    }
    return self;
}

- (void)redrawView
{
    CGRect imageViewFrame = _imageView.frame;
    imageViewFrame.size = CGSizeMake(_imageView.image.size.width/2, _imageView.image.size.height/2);
    _imageView.frame = imageViewFrame;
    self.view.bounds = _imageView.frame;
}

- (void)closePopup{
    if (self.delegate && [delegate respondsToSelector:@selector(cancelButtonClicked:)]) {
        [delegate performSelector:@selector(cancelButtonClicked:) withObject:self];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.view addSubview:_imageView];
    
    _loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _loadingView.hidesWhenStopped = YES;
    [self.view addSubview:_loadingView];
     
    if (nil != image) {
        _imageView.image = image;
        [self redrawView];
        [_loadingView setCenter:CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2)];
        [_loadingView startAnimating];
    }
    if (nil != imageUrl && ![imageUrl isEqualToString:@""]) {
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        NSURL *imageURL = [NSURL URLWithString:(imageUrl)];
        [manager downloadWithURL:imageURL delegate:self options:0 success:^(UIImage *img) {
            CGSize screenSize = [[UIScreen mainScreen] bounds].size;
            if (img.size.width > screenSize.width*2 || img.size.height > screenSize.height*2) {
                CGFloat widthFactor = (screenSize.width*2)/img.size.width;
                CGFloat heightFactor = (screenSize.height*2)/img.size.height;
                CGFloat factor = MIN(widthFactor, heightFactor);
                
                UIGraphicsBeginImageContext(CGSizeMake(img.size.width*factor, img.size.height*factor)); // this will crop
                CGRect thumbnailRect = CGRectZero;
                thumbnailRect.origin = CGPointMake(0, 0);
                thumbnailRect.size.width= img.size.width*factor;
                thumbnailRect.size.height = img.size.height*factor;
                [img drawInRect:thumbnailRect];
                img = UIGraphicsGetImageFromCurrentImageContext();
            }
            _imageView.image = img;
            [self redrawView];
            [_loadingView stopAnimating];
        } failure:^(NSError *error){
            [_loadingView stopAnimating];
        }];
    }else {
        [_loadingView stopAnimating];
    }
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closePopup)];
    [_imageView addGestureRecognizer:singleTap];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.imageUrl = nil;
    self.image = nil;
    _imageView = nil;
    _loadingView = nil;
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
