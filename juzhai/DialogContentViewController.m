//
//  DialogContentViewController.m
//  juzhai
//
//  Created by JiaJun Wu on 12-7-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DialogContentViewController.h"
#import "JZData.h"
#import "Pager.h"
#import "PagerCell.h"
#import "DialogContentListCell.h"
#import "DialogContentView.h"
#import "MBProgressHUD.h"
#import "HttpRequestSender.h"
#import "UrlUtils.h"
#import "UserView.h"
#import "SBJson.h"
#import "DialogService.h"
#import "ListHttpRequestDelegate.h"
#import "GrowingTextView.h"
#import "Constant.h"
#import <QuartzCore/QuartzCore.h>
#import "UserContext.h"
#import "CustomNavigationController.h"
#import "CheckNetwork.h"
#import "UIImage+UIImageExt.h"
#import "MessageShow.h"
#import "ASINetworkQueue.h"
#import "UIImage+fixOrientation.h"

@interface DialogContentViewController ()

@end

@implementation DialogContentViewController

@synthesize targetUser;
@synthesize inputAreaView;
@synthesize dialogContentTableView;
@synthesize textView;
@synthesize inputAreaBgImageView;
@synthesize imageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    _singlePan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    _singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    
    _data = [[JZData alloc] init];
    _listHttpRequestDelegate = [[ListHttpRequestDelegate alloc] init];
    _listHttpRequestDelegate.jzData = _data;
    _listHttpRequestDelegate.viewClassName = @"DialogContentView";
    _listHttpRequestDelegate.listViewController = self;
    _listHttpRequestDelegate.addToHead = YES;
    
    self.title = [NSString stringWithFormat:@"与 %@ 对话", self.targetUser.nickname];
    
    self.inputAreaBgImageView.image = [[UIImage imageNamed:@"send_area_bg.png"] stretchableImageWithLeftCapWidth:25 topCapHeight:0];
    //隐藏下方线条
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self.dialogContentTableView setTableFooterView:view];
    
    textView.backgroundImage = [[UIImage imageNamed:@"send_input_bgxy"] stretchableImageWithLeftCapWidth:7 topCapHeight:7];
    textView.font = [UIFont systemFontOfSize:15];
    [textView setCustomDelegate:self];
    [textView setMinNumberOfLines:1];
    [textView setMaxNumberOfLines:3];
    
    _textViewOriginalX = textView.frame.origin.x;
    _textVieworiginalWidth = textView.frame.size.width;
    
    [textView sizeToFit];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:APP_BG_IMG]];
    [inputAreaView sizeToFit];
    
    //load
    [self loadListDataWithPage:1];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:TIMER_INTERVAL target:self selector:@selector(refresh) userInfo:nil repeats:YES];
    
    _smsQueue = [ASINetworkQueue queue];
    _smsQueue.maxConcurrentOperationCount = 1;
    _smsQueue.delegate = self;
    _smsQueue.requestDidStartSelector = @selector(requestDidStartSelector:);
    //设置代理
    [_smsQueue go];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [_timer invalidate];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [_timer invalidate];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [_smsQueue reset];
    
    _singlePan = nil;
    _singleTap = nil;
    _data = nil;
    _dialogService = nil;
    _timer = nil;
    _listHttpRequestDelegate = nil;
    _image = nil;
    _smsQueue = nil;
    self.inputAreaView = nil;
    self.inputAreaBgImageView = nil;
    self.dialogContentTableView = nil;
    self.textView = nil;
    self.imageView = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    _image = nil;
    [_smsQueue reset];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)refresh
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:self.targetUser.uid, @"uid", nil];
    __unsafe_unretained __block ASIHTTPRequest *request = [HttpRequestSender backgroundGetRequestWithUrl:[UrlUtils urlStringWithUri:@"dialog/refreshDialogContent"] withParams:params];
    if (request != nil) {
        [request setCompletionBlock:^{
            NSString *responseString = [request responseString];
            NSMutableDictionary *jsonResult = [responseString JSONValue];
            if([jsonResult valueForKey:@"success"] == [NSNumber numberWithBool:YES]){
                NSMutableArray *dialogContentViewList = [[jsonResult valueForKey:@"result"] valueForKey:@"list"];
                for (int i = 0; i < dialogContentViewList.count; i++) {
                    DialogContentView *dialogContentView = [DialogContentView convertFromDictionary:[dialogContentViewList objectAtIndex:i]];
                    [_data addObject:dialogContentView withIdentity:[NSNumber numberWithInt:dialogContentView.dialogContentId]];
                }
                [self doneLoadingTableViewData];
            }
        }];
        [request setFailedBlock:^{
        }];
        [request startAsynchronous];
    }
}

- (void)keyboardWillShow:(NSNotification *)note
{
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
	// get a rect for the textView frame
	CGRect inputAreaViewFrame = inputAreaView.frame;
    inputAreaViewFrame.origin.y = self.view.bounds.size.height - (keyboardBounds.size.height + inputAreaViewFrame.size.height);
    
	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
	
	// set views with new info
	inputAreaView.frame = inputAreaViewFrame;
    
    CGRect tableViewFrame = dialogContentTableView.frame;
    if (self.dialogContentTableView.contentOffset.y == self.dialogContentTableView.contentSize.height - self.dialogContentTableView.frame.size.height)
    {
        tableViewFrame.origin.y = -keyboardBounds.size.height;
        dialogContentTableView.frame = tableViewFrame;
    } else if (self.dialogContentTableView.contentSize.height < self.dialogContentTableView.frame.size.height)  {
        tableViewFrame.size.height = inputAreaViewFrame.origin.y;
        dialogContentTableView.frame = tableViewFrame;
        [self doneLoadingTableViewData];
    }
	
	// commit animations
	[UIView commitAnimations];
    
    [self.dialogContentTableView addGestureRecognizer:_singlePan];
    [self.dialogContentTableView addGestureRecognizer:_singleTap];
}

- (void)keyboardWillHide:(NSNotification *)note
{
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
	
	// get a rect for the textView frame
	CGRect inputAreaViewFrame = inputAreaView.frame;
    inputAreaViewFrame.origin.y = self.view.bounds.size.height - inputAreaViewFrame.size.height;
    
    CGRect tableViewFrame = dialogContentTableView.frame;
    tableViewFrame.origin.y = 0;
    tableViewFrame.size.height = inputAreaViewFrame.origin.y;
	
	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
	// set views with new info
	inputAreaView.frame = inputAreaViewFrame;
    dialogContentTableView.frame = tableViewFrame;
	
	// commit animations
	[UIView commitAnimations];
    
    [self.dialogContentTableView removeGestureRecognizer:_singlePan];
    [self.dialogContentTableView removeGestureRecognizer:_singleTap];
}

- (void) loadListDataWithPage:(NSInteger)page
{
    if(page <= 0)
        page = 1;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:self.targetUser.uid, @"uid", [NSNumber numberWithInt:page], @"page", nil];
    ASIHTTPRequest *request = [HttpRequestSender getRequestWithUrl:[UrlUtils urlStringWithUri:@"dialog/dialogContentList"] withParams:params];
    if (request) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            [request setDelegate:_listHttpRequestDelegate];
            [request startAsynchronous];
        });
    } else {
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    }
}


- (void)hideKeyboard{  
    [self.textView resignFirstResponder];
}

- (void)doneLoadingTableViewData
{
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    [self.dialogContentTableView reloadData];
    if ([_data count] > 0) {
        [self.dialogContentTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[_data count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}

- (IBAction)sendSms:(id)sender
{
    //初始化要插入的对象
    DialogContentView *view = [[DialogContentView alloc] init];
    view.content = textView.text;
    view.senderUid = [UserContext getUid];
    view.receiverUid = self.targetUser.uid.intValue;
    view.createTime = [[NSDate date] timeIntervalSince1970];
    view.image = _image;
    view.hasImg = (_image != nil);
    view.sendStatus = SendStatusWaiting;
    
    if (_dialogService == nil) {
        _dialogService = [[DialogService alloc] init];
    }
    [textView resignFirstResponder];
    BOOL success = [_dialogService sendSms:view inQueue:_smsQueue onSuccess:^(NSDictionary *info) {
        DialogContentView *dialogContentView = [DialogContentView convertFromDictionary:info];
        view.imgUrl = dialogContentView.imgUrl;
        view.dialogContentId = dialogContentView.dialogContentId;
        view.createTime = dialogContentView.createTime;
        //隐藏警告icon
        view.sendStatus = SendStatusFinish;
        [_data addIdentity:[NSNumber numberWithInt:view.dialogContentId]];
        [self.dialogContentTableView reloadData];
    } onFailure:^(NSString *error, BOOL hasSent) {
        if (nil != error && ![error isEqual:[NSNull null]] && ![error isEqualToString:@""]) {
            //显示错误
            [MessageShow error:error onView:nil];
        }
        if (hasSent) {
            //显示警告标志
            view.sendStatus = SendStatusFailure;
            [self.dialogContentTableView reloadData];
        }
    }];
    
    if (success) {
        //默认显示队列中icon
        [_data addObject:view];
        [self doneLoadingTableViewData];
        textView.text = @"";
        [self resetSendForm];
    }
}

- (IBAction)imageButtonClick:(id)sender
{
//    [textView resignFirstResponder];
    UIActionSheet *actionSheet = [[UIActionSheet alloc] 
                                  initWithTitle:@"上传图片" 
                                  delegate:self 
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"用户相册", @"拍照", nil];
    [actionSheet showInView:self.view];
}

- (void)uploadImageClick:(UIGestureRecognizer *)gestureRecognizer {  
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"确定删除吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
    [alertView show];
}

- (void)resetSendForm
{
    _image = nil;
    imageView.image = nil;
    imageView.hidden = YES;
    
    CGRect textViewFrame = textView.frame;
    textViewFrame.origin.x = _textViewOriginalX;
    textViewFrame.size.width = _textVieworiginalWidth;
    textView.frame = textViewFrame;
}

#pragma mark -
#pragma mark Custom Text View Delegate

- (void)textView:(CustomTextView *)aTextView didChangeHeight:(float)addHeight
{
    CGRect inputAreaFrame = inputAreaView.frame;
    inputAreaFrame.size.height = inputAreaFrame.size.height + addHeight;
    inputAreaFrame.origin.y = inputAreaFrame.origin.y - addHeight;
    inputAreaView.frame = inputAreaFrame;
    
    inputAreaBgImageView.frame = inputAreaView.bounds;
}

#pragma mark -
#pragma mark Table View Data Source & Delegate

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *DialogContentListCellIdentifier = @"DialogContentListCellIdentifier";
    DialogContentListCell *cell = (DialogContentListCell *)[tableView dequeueReusableCellWithIdentifier:DialogContentListCellIdentifier];
    if(cell == nil){
        cell = [DialogContentListCell cellFromNib];
    }
    cell.targetUser = self.targetUser;
    if (indexPath.row < [_data count]) {
        DialogContentView *dialogContentView = (DialogContentView *)[_data objectAtIndex:indexPath.row];
        [cell redrawn:dialogContentView];
    }
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [DialogContentListCell heightForCell:[_data objectAtIndex:indexPath.row]];
}

#pragma mark - 
#pragma mark Action Sheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet
didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == [actionSheet cancelButtonIndex]){
        [textView becomeFirstResponder];
        return;
    }
    UIImagePickerControllerSourceType sourceType;
    if(buttonIndex == 0){
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }else {
        if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }else {
            sourceType = UIImagePickerControllerSourceTypeCamera;
        }
    }
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = sourceType;
    [self presentModalViewController:picker animated:YES];
}

#pragma mark -
#pragma mark Image Picker Controller Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    _image = [info objectForKey:UIImagePickerControllerEditedImage];
    imageView.image = _image;
    imageView.hidden = NO;
    
    CGRect textViewFrame = textView.frame;
    textViewFrame.origin.x = _textViewOriginalX + 40;
    textViewFrame.size.width = _textVieworiginalWidth - 40;
    textView.frame = textViewFrame;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(uploadImageClick:)];
    [imageView addGestureRecognizer:singleTap];
    
    [self imagePickerControllerDidCancel:picker];
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissModalViewControllerAnimated:YES];
//    [textView becomeFirstResponder];
}

#pragma mark -
#pragma mark Navigation Delegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (IOS_VERSION >= 5.0){
        [navigationController.navigationBar setBackgroundImage:TOP_BG_IMG forBarMetrics:UIBarMetricsDefault];
    }
    navigationController.navigationBar.barStyle = UIBarStyleDefault;
}

#pragma mark - 
#pragma mark Alert Delegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex) {
        [self resetSendForm];
    }
}

#pragma mark - 
#pragma mark ASINetworkQueue
- (void)requestDidStartSelector:(ASIHTTPRequest *)request
{
    DialogContentView *view = [request.userInfo objectForKey:REQUEST_USER_INFO_KEY];
    if (view) {
        view.sendStatus = SendStatusSending;
        [self.dialogContentTableView reloadData];
    }
}

@end
