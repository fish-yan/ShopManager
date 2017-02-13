//
//  UserInfoViewController.m
//  ShopManager
//
//  Created by 张旭 on 2/23/16.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import "UserInfoViewController.h"
#import "ShopManager-Swift.h"

@interface UserInfoViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.nameLabel setText:[[User sharedUser] showName]];
    [self.storeNameLabel setText:[User sharedUser].storeName];
}

- (IBAction)backButtonDidTouch:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)exitButtonDidTouch:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
