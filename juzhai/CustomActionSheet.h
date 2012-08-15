//
//  CustomActionSheet.h
//  juzhai
//
//  Created by JiaJun Wu on 12-6-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomActionSheet;

@protocol CustomActionSheetDelegate <NSObject>

@required
- (void)done:(CustomActionSheet *)actionSheet;

@optional
- (void)docancel:(CustomActionSheet *)actionSheet;

@end

@interface CustomActionSheet : UIActionSheet
{
    UIToolbar* toolBar;
    UIView* view;
    id<CustomActionSheetDelegate> _customDelegate;
}
@property (nonatomic,strong) UIView* view;
@property (nonatomic,strong) UIToolbar* toolBar;

/*因为是通过给ActionSheet 加 Button来改变ActionSheet, 所以大小要与actionsheet的button数有关
 *height = 84, 134, 184, 234, 284, 334, 384, 434, 484
 *如果要用self.view = anotherview.  那么another的大小也必须与view的大小一样
 */
-(id)initWithHeight:(float)height withSheetTitle:(NSString*)title delegate:(id<CustomActionSheetDelegate>)deletage;

-(id)initWithHeight:(float)height withSheetTitle:(NSString*)title withCancelTitle:(NSString *)cancelTitle withDoneTitle:(NSString *)doneTitle delegate:(id<CustomActionSheetDelegate>)deletage;

@end
