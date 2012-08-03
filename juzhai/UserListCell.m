//
//  UserListCell.m
//  juzhai
//
//  Created by JiaJun Wu on 12-5-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "UserListCell.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "UserView.h"
#import "PostView.h"
#import "Constant.h"
#import "MBProgressHUD.h"
#import "ASIHTTPRequest.h"
#import "HttpRequestSender.h"
#import "SBJson.h"
#import "TaHomeViewController.h"
#import "MessageShow.h"
#import "UrlUtils.h"

@implementation UserListCell

//@synthesize userView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

+ (id)cellFromNib
{
    UserListCell *cell = nil;
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"UserListCell" owner:self options:nil];
    for(id oneObject in nib){
        if([oneObject isKindOfClass:[UserListCell class]]){
            cell = (UserListCell *) oneObject;
        }
    }
    [cell setBackground];
    return cell;
}

- (void)logoClick:(UIGestureRecognizer *)gestureRecognizer {  
    TaHomeViewController *taHomeViewController = [[TaHomeViewController alloc] initWithNibName:@"TaHomeViewController" bundle:nil];
    taHomeViewController.hidesBottomBarWhenPushed = YES;
    taHomeViewController.userView = _userView;
    UIViewController *viewController = (UIViewController *)self.nextResponder.nextResponder;
    [viewController.navigationController pushViewController:taHomeViewController animated:YES];
}

- (void) setBackground{
    UIImage *image = [UIImage imageNamed:BG_PNG];
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.frame.size.width, image.size.height + 30.0), NO, 0.0);
    [image drawInRect:CGRectMake(0.0, 0 + 30.0, image.size.width, image.size.height)];
    UIImage* resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, resultImage.size.width, self.frame.size.height)]; 
    [imageview setImage:[resultImage stretchableImageWithLeftCapWidth:0 topCapHeight:BG_CAP_HEIHGT + 30]];
    [self setBackgroundView: imageview];
}

- (void) redrawn:(UserView *)userView{
    _userView = userView;
    UIImageView *imageView = (UIImageView *)[self viewWithTag:USER_LOGO_TAG];
    imageView.image = [UIImage imageNamed:FACE_LOADING_IMG];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    NSURL *imageURL = [NSURL URLWithString:userView.logo];
    [manager downloadWithURL:imageURL delegate:self options:0 success:^(UIImage *image) {
        imageView.image = image;
        imageView.layer.shouldRasterize = YES;
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 5.0;
    } failure:nil];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(logoClick:)];
    [imageView addGestureRecognizer:singleTap];
    
    UILabel *nicknameLabel = (UILabel *)[self viewWithTag:USER_NICKNAME_TAG];
    nicknameLabel.font = [UIFont fontWithName:DEFAULT_FONT_FAMILY size:12.0];
    if(userView.gender.intValue == 0){
        nicknameLabel.textColor = FEMALE_NICKNAME_COLOR;
    }else {
        nicknameLabel.textColor = MALE_NICKNAME_COLOR;
    }
    CGSize nicknameSize = [userView.nickname sizeWithFont:nicknameLabel.font constrainedToSize:CGSizeMake(120.0f, nicknameLabel.frame.size.height) lineBreakMode:UILineBreakModeTailTruncation];
    [nicknameLabel setFrame:CGRectMake(nicknameLabel.frame.origin.x, nicknameLabel.frame.origin.y, nicknameSize.width, nicknameSize.height)];
    nicknameLabel.text = userView.nickname;
    
    UILabel *infoLabel = (UILabel *)[self viewWithTag:USER_INFO_TAG];
    infoLabel.font = [UIFont fontWithName:DEFAULT_FONT_FAMILY size:12.0];
    infoLabel.textColor = [UIColor colorWithRed:0.60f green:0.60f blue:0.60f alpha:1.00f];;
    infoLabel.text = [userView basicInfo];
    CGSize infoSize = [infoLabel.text sizeWithFont:infoLabel.font constrainedToSize:CGSizeMake(120.0f, infoLabel.frame.size.height) lineBreakMode:UILineBreakModeTailTruncation];
    [infoLabel setFrame:CGRectMake(nicknameLabel.frame.origin.x + nicknameLabel.frame.size.width + 10.0, infoLabel.frame.origin.y, infoSize.width, infoSize.height)];

    
    UILabel *contentLabel = (UILabel *)[self viewWithTag:POST_CONTENT_TAG];
    contentLabel.font = [UIFont fontWithName:DEFAULT_FONT_FAMILY size:14.0];
    contentLabel.textColor = [UIColor colorWithRed:0.40f green:0.40f blue:0.40f alpha:1.00f];;
    contentLabel.text = [NSString stringWithFormat:@"%@：%@", userView.post.purpose, userView.post.content];
    CGSize contentSize = [contentLabel.text sizeWithFont:contentLabel.font constrainedToSize:CGSizeMake(220, 500.0) lineBreakMode:UILineBreakModeCharacterWrap];
    [contentLabel setFrame:CGRectMake(contentLabel.frame.origin.x, contentLabel.frame.origin.y, contentSize.width, contentSize.height)];
    
    UIImageView *postImageView = (UIImageView *)[self viewWithTag:POST_IMAGE_TAG];
    if(![userView.post.pic isEqual:[NSNull null]]){
        postImageView.image = [UIImage imageNamed:SMALL_PIC_LOADING_IMG];
        NSURL *postImageURL = [NSURL URLWithString:userView.post.pic];
        [postImageView setFrame:CGRectMake(postImageView.frame.origin.x, contentLabel.frame.origin.y + contentSize.height + 10.0, postImageView.frame.size.width, postImageView.frame.size.height)];
        [manager downloadWithURL:postImageURL delegate:self options:0 success:^(UIImage *image) {
            CGFloat imageHeight = image.size.height*(postImageView.frame.size.width/image.size.width);
            if (imageHeight > postImageView.frame.size.height) {
                UIGraphicsBeginImageContext(CGSizeMake(postImageView.frame.size.width, postImageView.frame.size.height));
                [image drawInRect:CGRectMake(0, 0, postImageView.frame.size.width, imageHeight)];
                UIImage* resultImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                postImageView.image = resultImage;
            } else {
                postImageView.image = image;
            }
            
            postImageView.layer.shouldRasterize = YES;
            postImageView.layer.masksToBounds = YES;
            postImageView.layer.cornerRadius = 5.0;
        } failure:nil];
        [postImageView setHidden:NO];
    }else {
        [postImageView setHidden:YES];
    }
    
    UIButton *respButton = (UIButton *)[self viewWithTag:RESPONSE_BUTTON_TAG];
    NSString *buttonTitle = [NSString stringWithFormat:@"%d", userView.post.respCnt.intValue];
    CGSize respButtonTitleSize = [buttonTitle sizeWithFont:[UIFont fontWithName:DEFAULT_FONT_FAMILY size:11.0] constrainedToSize:CGSizeMake(100.0f, 25.0f)lineBreakMode:UILineBreakModeHeadTruncation];
    [respButton setTitle:buttonTitle forState:UIControlStateNormal];
    [respButton setTitleColor:[UIColor colorWithRed:0.40f green:0.40f blue:0.40f alpha:1.00f] forState:UIControlStateNormal];
    [respButton setTitleColor:[UIColor colorWithRed:0.80f green:0.80f blue:0.80f alpha:1.00f] forState:UIControlStateDisabled];
    [respButton setTitleColor:[UIColor colorWithRed:1.00f green:1.00f blue:1.00f alpha:1.00f] forState:UIControlStateHighlighted];
    respButton.titleLabel.font = [UIFont fontWithName:DEFAULT_FONT_FAMILY size:11.0];
    
    respButton.enabled = ![userView.post.hasResp boolValue];
    UIImage *normalImg = [[UIImage imageNamed:NORMAL_RESP_BUTTON_IMAGE] stretchableImageWithLeftCapWidth:WANT_BUTTON_CAP_WIDTH topCapHeight:0.0];
    UIImage *highlightedImg = [[UIImage imageNamed:HIGHLIGHT_RESP_BUTTON_IMAGE] stretchableImageWithLeftCapWidth:WANT_BUTTON_CAP_WIDTH topCapHeight:0.0];
    UIImage *disabledImg = [[UIImage imageNamed:DISABLE_RESP_BUTTON_IMAGE] stretchableImageWithLeftCapWidth:WANT_BUTTON_CAP_WIDTH topCapHeight:0.0];
    
    [respButton setBackgroundImage:normalImg forState:UIControlStateNormal];
    [respButton setBackgroundImage:highlightedImg forState:UIControlStateHighlighted];
    [respButton setBackgroundImage:disabledImg forState:UIControlStateDisabled];
    
    float respButtonX = 320.0 - 20.0 - (normalImg.size.width + respButtonTitleSize.width);
    float respButtonY = 0.0;
    if(postImageView.hidden){
        respButtonY = contentLabel.frame.origin.y + contentSize.height + 10;
    }else {
        respButtonY = postImageView.frame.origin.y + postImageView.frame.size.height + 10;
    }
    respButton.frame = CGRectMake(respButtonX, respButtonY, normalImg.size.width + respButtonTitleSize.width, respButton.frame.size.height);
    [respButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 20.0, 0.0, 0.0)];
}

+(CGFloat) heightForCell:(UserView *)userView{
    float height = 85.0;
    NSString *content = [NSString stringWithFormat:@"%@：%@", userView.post.purpose, userView.post.content];
    CGSize contentSize = [content sizeWithFont:[UIFont fontWithName:DEFAULT_FONT_FAMILY size:14.0] constrainedToSize:CGSizeMake(220, 200.0) lineBreakMode:UILineBreakModeCharacterWrap];
    height += contentSize.height;
    if(![userView.post.pic isEqual:[NSNull null]]){
        height += 80.0;
    }
    return height;
}

-(IBAction)respPost:(id)sender{
    UIView *coverView = self.superview.superview.superview.superview;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:coverView animated:YES];
    hud.labelText = @"操作中...";
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:_userView.post.postId, @"postId", nil];
        __unsafe_unretained __block ASIFormDataRequest *request = [HttpRequestSender postRequestWithUrl:[UrlUtils urlStringWithUri:@"post/respPost"] withParams:params];
        if (request) {
            [request setCompletionBlock:^{
                NSString *responseString = [request responseString];
                NSMutableDictionary *jsonResult = [responseString JSONValue];
                if([jsonResult valueForKey:@"success"] == [NSNumber numberWithBool:YES]){
                    _userView.post.hasResp = [NSNumber numberWithInt:1];
                    _userView.post.respCnt = [NSNumber numberWithInt:(_userView.post.respCnt.intValue + 1)];
                    UIButton *respButton = (UIButton *)[self viewWithTag:RESPONSE_BUTTON_TAG];
                    respButton.enabled = NO;
                    [respButton setTitle:[NSString stringWithFormat:@"%d", respButton.titleLabel.text.intValue + 1] forState:UIControlStateNormal];
                    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
                    hud.mode = MBProgressHUDModeCustomView;
                    hud.labelText = @"保存成功";
                    [hud hide:YES afterDelay:1];
                    return;
                }
                NSString *errorInfo = [jsonResult valueForKey:@"errorInfo"];
                NSLog(@"%@", errorInfo);
                if (errorInfo == nil || [errorInfo isEqual:[NSNull null]] || [errorInfo isEqualToString:@""]) {
                    errorInfo = SERVER_ERROR_INFO;
                }
                [MBProgressHUD hideHUDForView:coverView animated:YES];
                [MessageShow error:errorInfo onView:coverView];
            }];
            [request setFailedBlock:^{
                [MBProgressHUD hideHUDForView:coverView animated:YES];
                [HttpRequestDelegate requestFailedHandle:request];
            }];
            [request startAsynchronous];
        } else {
            [MBProgressHUD hideHUDForView:coverView animated:YES];
        }
    });
}

@end
