//
//  MessageNavigationController.m
//  juzhai
//
//  Created by JiaJun Wu on 12-7-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MessageNavigationController.h"
#import "CustomSegmentedControl.h"
#import "RectButton.h"

@interface MessageNavigationController ()

@end

@implementation MessageNavigationController

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
//    //中央切换按钮
//    UIImage* dividerImage = [UIImage imageNamed:@"menu_line.png"];
//    CustomSegmentedControl *_segmentedControl = [[CustomSegmentedControl alloc] initWithSegmentCount:2 segmentsize:CGSizeMake(51, dividerImage.size.height) dividerImage:dividerImage tag:0 delegate:self];
//    self.navigationBar.topItem.titleView = _segmentedControl;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark CustomSegmentedControlDelegate
- (UIButton*) buttonFor:(CustomSegmentedControl*)segmentedControl atIndex:(NSUInteger)segmentIndex;
{
    CapLocation location;
    if (segmentIndex == 0)
        location = CapLeft;
    else if (segmentIndex == segmentedControl.buttons.count - 1)
        location = CapMiddle;
    else
        location = CapRight;
    
    NSString *buttonText;
    switch (segmentIndex) {
        case 0:
            buttonText = @"私信";
            break;
        case 1:
            buttonText = @"留言";
            break;    
        default:
            break;
    }
    UIButton* button = [[RectButton alloc] initWithWidth:51 buttonText:buttonText CapLocation:location];
    if (segmentIndex == 0)
        button.selected = YES;
    return button;
}

- (void) touchDownAtSegmentIndex:(NSUInteger)segmentIndex
{
    switch (segmentIndex) {
        case 0:
            break;
        case 1:
            break;
    }
}

@end
