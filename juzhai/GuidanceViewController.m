//
//  GuidanceViewController.m
//  juzhai
//
//  Created by JiaJun Wu on 12-8-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GuidanceViewController.h"
#import "LoginService.h"
#import "Constant.h"

@interface GuidanceViewController ()
- (void)loadPage:(NSInteger)page;
- (void)finish;
@end

@implementation GuidanceViewController

@synthesize scrollView, pageControl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"guidance_images" ofType:@"plist"];
        _imageArray = [NSArray arrayWithContentsOfFile:path];
        
        _imageViewArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < [_imageArray count]; i++) {
            [_imageViewArray addObject:[NSNull null]];
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * ([_imageArray count] + 1), scrollView.frame.size.height);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.scrollsToTop = NO;
    scrollView.delegate = self;
//    scrollView.backgroundColor = [UIColor colorWithRed:0.90f green:0.90f blue:0.90f alpha:1.00f];
    scrollView.backgroundColor = [UIColor blackColor];
    
//    CGRect frame = scrollView.frame;
//    frame.origin.x = frame.size.width * [_imageArray count];
//    frame.origin.y = 0;
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
//    imageView.image = [UIImage imageNamed:@"ca_hd_hover.png"];
//    [scrollView addSubview:imageView];
    
    pageControl.numberOfPages = [_imageArray count];
    pageControl.currentPage = 0;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yd5.jpg"]];
    imageView.frame = CGRectMake(scrollView.frame.size.width * [_imageArray count], 0, scrollView.frame.size.width, scrollView.frame.size.height);
    [scrollView addSubview:imageView];
    
    [self loadPage:pageControl.currentPage];
    [self loadPage:pageControl.currentPage + 1];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.scrollView = nil;
    self.pageControl = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)loadPage:(NSInteger)page
{
    if (page < 0 || page >= [_imageArray count]) {
        return;
    }
    UIImageView *imageView = [_imageViewArray objectAtIndex:page];
    if ([imageView isEqual:[NSNull null]]) {
        imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[_imageArray objectAtIndex:page]]];
        CGRect frame = scrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        imageView.frame = frame;
        [scrollView addSubview:imageView];
        [_imageViewArray replaceObjectAtIndex:page withObject:imageView];
        
        if (page == [_imageArray count] - 1) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setBackgroundImage:[UIImage imageNamed:@"yd4_btn"] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"yd4_btn_hover"] forState:UIControlStateHighlighted];
            [button addTarget:self action:@selector(finish) forControlEvents:UIControlEventTouchUpInside];
            button.frame = CGRectMake(scrollView.frame.size.width * page + 85, 350, 150, 40);
            [scrollView addSubview:button];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{	
    if (_pageControlUsed) {
        return;
    }
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
    
    [self loadPage:page - 1];
    [self loadPage:page];
    [self loadPage:page + 1];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)sender
{
    _pageControlUsed = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)sender
{
    _pageControlUsed = NO;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)sender willDecelerate:(BOOL)decelerate
{
    if (scrollView.contentOffset.x >= scrollView.frame.size.width * ([_imageArray count] - 1 + 0.5)) {
        [self finish];
    }
}

- (IBAction)changePage:(id)sender
{
    int page = pageControl.currentPage;
	
    [self loadPage:page - 1];
    [self loadPage:page];
    [self loadPage:page + 1];
    
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [scrollView scrollRectToVisible:frame animated:YES];
    _pageControlUsed = YES;
}

- (void)finish
{
    UIViewController *viewController = [[LoginService getInstance] loginTurnToViewController];
    [UIView animateWithDuration:0.32 animations:^{
        self.scrollView.alpha = 0.2;
    } completion:^(BOOL finished) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        self.view.window.rootViewController = viewController;
        viewController.view.alpha = 0.5;
        [self.view.window makeKeyAndVisible];
        [UIView animateWithDuration:0.32 animations:^{
            viewController.view.alpha = 1.0;
        } completion:^(BOOL finished) {
        }];
    }];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:YES forKey:GUIDANCE_USED([Constant appVersion])];
}

@end
