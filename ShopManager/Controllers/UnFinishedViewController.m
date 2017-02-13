//
//  UnFinishedViewController.m
//  ShopManager
//
//  Created by 张旭 on 7/5/16.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import "UnFinishedViewController.h"

@interface UnFinishedViewController ()

@end

@implementation UnFinishedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)backButtonDidTouch:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

@end
