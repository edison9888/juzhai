//
//  CustomActionSheet.m
//  juzhai
//
//  Created by JiaJun Wu on 12-6-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CustomActionSheet.h"

@implementation CustomActionSheet

@synthesize view;
@synthesize toolBar;

-(id)initWithHeight:(float)height withSheetTitle:(NSString*)title delegate:(id<CustomActionSheetDelegate>)deletage
{
    self = [super init];
    if (self) 
    {
        _customDelegate = deletage;
        int theight = height;
        int btnnum = theight/16;
        self.title = @"";
        for(int i=0; i<btnnum; i++)
        {
            self.title = [self.title stringByAppendingString:@"\n"];
        }
        toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        toolBar.barStyle = UIBarStyleBlackTranslucent;
        UIBarButtonItem *titleButton = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:nil action:nil];
        
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(done)];
        
        UIBarButtonItem *leftButton  = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(docancel)];
        
        UIBarButtonItem *fixedButton  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        NSArray *array = [[NSArray alloc] initWithObjects:leftButton,fixedButton,titleButton,fixedButton,rightButton,nil];
        [toolBar setItems: array];
        [self addSubview:toolBar];
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 44, 320, height)];
        view.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self addSubview:view];
    }
    return self;
}
-(void)done
{
    if (_customDelegate && [_customDelegate respondsToSelector:@selector(done:)]) {
        [_customDelegate done:self];
    }
    [self dismissWithClickedButtonIndex:0 animated:YES];
}
-(void)docancel
{
    if (_customDelegate && [_customDelegate respondsToSelector:@selector(docancel:)]) {
        [_customDelegate docancel:self];
    }
    [self dismissWithClickedButtonIndex:0 animated:YES];
}

@end
