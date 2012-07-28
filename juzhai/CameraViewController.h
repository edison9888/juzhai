//
//  HomeViewController.h
//  juzhai
//
//  Created by JiaJun Wu on 12-5-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CameraViewController : UIViewController <UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property IBOutlet UIImageView *imageView;

- (IBAction)takePic:(id)sender;

@end
