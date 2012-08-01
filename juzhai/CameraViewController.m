//
//  HomeViewController.m
//  juzhai
//
//  Created by JiaJun Wu on 12-5-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CameraViewController.h"
#import "ASIFormDataRequest.h"
#import "HttpRequestSender.h"
#import "SBJson.h"
#import "MBProgressHUD.h"
#import "SDWebImage/UIImageView+WebCache.h"

@interface CameraViewController ()

@end

@implementation CameraViewController

@synthesize imageView;

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
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)takePic:(id)sender{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
		sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	}
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = sourceType;
    [self presentModalViewController:picker animated:YES];
}

-(void) savePic:(UIImage *) image{
    NSLog(@"save image");
//    imageView.image = image;
    
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    int maxFileSize = 2*1024*1024;
    
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    while ([imageData length] > maxFileSize && compression > maxCompression){
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(image, compression);
    }
    ASIFormDataRequest *request = [HttpRequestSender postRequestWithUrl:@"http://test.51juzhai.com/app/ios/upload" withParams:nil];
    [request setData:imageData withFileName:@"myFace.jpg" andContentType:@"image/jpeg" forKey:@"photo"];
    [request startSynchronous];
    NSError *error = [request error];
    NSString *errorInfo;
    if (!error){
        NSMutableDictionary *jsonResult = [[request responseString] JSONValue];
        if([jsonResult valueForKey:@"success"] == [NSNumber numberWithBool:YES]){
            //成功
            SDWebImageManager *manager = [SDWebImageManager sharedManager];
            NSURL *imageURL = [NSURL URLWithString:[jsonResult valueForKey:@"result"]];
            [manager downloadWithURL:imageURL delegate:self options:0 success:^(UIImage *image) {
                imageView.image = image;
            } failure:nil];
        }else{
            errorInfo = [jsonResult valueForKey:@"errorInfo"];
        }
    }else {
        errorInfo = [NSString stringWithFormat:@"error: %@", [request responseStatusMessage]];
    }
    if(errorInfo != nil){
        MBProgressHUD *hud2 = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud2.mode = MBProgressHUDModeText;
        hud2.margin = 10.f;
        hud2.yOffset = 150.f;
        hud2.removeFromSuperViewOnHide = YES;
        [hud2 hide:YES afterDelay:1];
        hud2.labelText = errorInfo;
    }
}

#pragma mark -
#pragma mark Image Picker Controller Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissModalViewControllerAnimated:YES];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [self performSelector:@selector(savePic:) withObject:image afterDelay:0.5];
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissModalViewControllerAnimated:YES];
}

@end
