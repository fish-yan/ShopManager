//
//  ViewController.m
//  ShopManager
//
//  Created by 张旭 on 2/22/16.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import "LoginViewController.h"
#import "HttpClient.h"
#import <Crashlytics/Crashlytics.h>
#import "GuideView.h"
#import "StoreList.h"


@import JDStatusBarNotification;
@import MBProgressHUD;

#define REDCOLOR    [UIColor colorWithRed:240.0/255.0 green:84.0/255.0 blue:84.0/255.0 alpha:1.0]

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwardTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIView *firstContainerView;
@property (weak, nonatomic) IBOutlet UIView *secondContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *loginBG;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UIView *logoContainerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoCenterConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstCenterConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondCenterConstraint;


@property (strong, nonatomic) GuideView *guideView;
@property (strong, nonatomic) NSString *token;
@property (assign, nonatomic) BOOL shouldShowStatusBar;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [JDStatusBarNotification setDefaultStyle:^JDStatusBarStyle *(JDStatusBarStyle *style) {
        style.barColor = REDCOLOR;
        style.textColor = [UIColor whiteColor];
        return style;
    }];
    
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:LOGINNAME];
    if (userName != nil) {
        [_usernameTextField setText:userName];
    }
    
    NSAttributedString *usernamePlaceholder = [[NSAttributedString alloc] initWithString:@"用户名" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:0.44 green:0.69 blue:0.81 alpha:1] }];
    self.usernameTextField.attributedPlaceholder = usernamePlaceholder;
    NSAttributedString *passwardPlaceholder = [[NSAttributedString alloc] initWithString:@"密码" attributes:@{ NSForegroundColorAttributeName :  [UIColor colorWithRed:0.44 green:0.69 blue:0.81 alpha:1] }];
    self.passwardTextField.attributedPlaceholder = passwardPlaceholder;
    self.loginButton.layer.cornerRadius = 3.0f;


	self.shouldShowStatusBar = NO;
	[self setNeedsStatusBarAppearanceUpdate];
	//[self.view addSubview:self.guideView];
	__weak typeof(self) weakSelf = self;
	self.guideView.finishBlock = ^{
		weakSelf.shouldShowStatusBar = YES;
		[weakSelf setNeedsStatusBarAppearanceUpdate];
		[UIView animateWithDuration:0.6 animations:^{
			weakSelf.loginBG.alpha = 1.0f;
			weakSelf.logoCenterConstraint.constant = 0;
			weakSelf.firstCenterConstraint.constant = 0;
			weakSelf.secondCenterConstraint.constant = 0;
			[weakSelf.view layoutIfNeeded];
		}];
	};
}

- (GuideView *)guideView {
	if (_guideView == nil) {
		_guideView = [[GuideView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
	}
	return _guideView;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
	if (self.shouldShowStatusBar) {
		return NO;
	} else {
		return YES;
	}
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[self.guideView show];
    self.loginBG.alpha = 0.0f;
	self.logoCenterConstraint.constant = -kScreenWidth;
	self.firstCenterConstraint.constant = kScreenWidth;
	self.secondCenterConstraint.constant = kScreenWidth;
	[self.view layoutIfNeeded];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

}

- (IBAction)loginButtonDidTouch:(id)sender {
    if ([_usernameTextField.text isEqualToString:@""] || [_passwardTextField.text isEqualToString:@""]) {
        [JDStatusBarNotification showWithStatus:ERROR_EMPTYUSERINFO dismissAfter:2];
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self loginRequest];
}

#pragma mark - Request

- (void)loginRequest {
    [[HttpClient sharedHttpClient] loginWithUsername:self.usernameTextField.text passward:self.passwardTextField.text
                                            complete:^(BOOL success) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (success) {
            [[NSUserDefaults standardUserDefaults] setObject:self.usernameTextField.text forKey:LOGINNAME];
            [self.passwardTextField setText:@""];
			[[StoreList sharedList] requestWithComplete:nil failure:nil];
			UINavigationController *vc = [[UIStoryboard storyboardWithName:@"Index" bundle:nil] instantiateViewControllerWithIdentifier:@"IndexNV"];
			[self showViewController:vc sender:self];
        }
    } failure:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

@end
