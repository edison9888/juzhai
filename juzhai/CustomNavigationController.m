//
//  CustomNavigationController.m
//  juzhai
//
//  Created by JiaJun Wu on 12-5-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CustomNavigationController.h"
#import "Constant.h"

@interface CustomNavigationController ()

@end

@implementation CustomNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    if (IOS_VERSION >= 5.0){
        [self.navigationBar setBackgroundImage:TOP_BG_IMG forBarMetrics:UIBarMetricsDefault];
    }
//    else{
        // Override point for customization after application launch.
//        UIImageView* imageView = [[UIImageView alloc] initWithFrame:self.navigationBar.frame];
//        imageView.contentMode = UIViewContentModeLeft;
//        imageView.image = [UIImage imageNamed:TOP_BG_PIC_NAME];
//        [self.navigationBar insertSubview:imageView atIndex:0];
//        UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:TOP_BG_PIC_NAME]]; 
//        [self.navigationBar insertSubview:backgroundView atIndex:0];
//        self.navigationBar.barStyle. = backgroundView;
//    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    _backItem = nil;
    _homeItem = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (UIBarButtonItem*) backButton
{
    if(_backItem == nil){
        UIImage *backImage = [UIImage imageNamed:BACK_NORMAL_PIC_NAME];
        UIImage *activeBackImage = [UIImage imageNamed:BACK_HIGHLIGHT_PIC_NAME];
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.frame = CGRectMake(0, 0, backImage.size.width, backImage.size.height);
        [backButton setBackgroundImage:backImage forState:UIControlStateNormal];
        [backButton setBackgroundImage:activeBackImage forState:UIControlStateHighlighted];
        [backButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
        _backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    }
    return _backItem;
}

- (UIBarButtonItem*) homeButton
{
    if (_homeItem == nil) {
        UIImage *homeImage = [UIImage imageNamed:HOME_NORMAL_PIC_NAME];
        UIImage *activeHomeImage = [UIImage imageNamed:HOME_HIGHLIGHT_PIC_NAME];
        UIButton *homeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        homeButton.frame = CGRectMake(0, 0, homeImage.size.width, homeImage.size.height);
        [homeButton setBackgroundImage:homeImage forState:UIControlStateNormal];
        [homeButton setBackgroundImage:activeHomeImage forState:UIControlStateHighlighted];
        [homeButton addTarget:self action:@selector(popToRootViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
        _homeItem = [[UIBarButtonItem alloc] initWithCustomView:homeButton];
    }
    return _homeItem;
}

- (UIViewController *)popViewController
{
    return [super popViewControllerAnimated:YES];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated 
{
    if (viewController.navigationItem.leftBarButtonItem == nil && [self.viewControllers count] > 0) { 
        viewController.navigationItem.leftBarButtonItem =[self backButton];
        viewController.navigationItem.rightBarButtonItem =[self homeButton];
    }
    viewController.navigationItem.hidesBackButton = YES;
    [super pushViewController:viewController animated:animated]; 
} 



- (void)customBackButton{
//    if(self.visibleViewController.navigationItem.hidesBackButton){
//        NSLog(@"true");
//    }else {
//        NSLog(@"false");
//    }
//    [self.visibleViewController.navigationItem setHidesBackButton:YES];
}

-(void)customHomeButton{
    
}

@end

@implementation UINavigationBar (CustomImage2)   
- (void)drawRect:(CGRect)rect {
    [TOP_BG_IMG drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];   
} 

@end