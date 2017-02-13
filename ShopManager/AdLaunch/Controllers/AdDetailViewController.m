//
//  AdDetailViewController.m
//  BTB
//
//  Created by 张旭 on 9/6/16.
//  Copyright © 2016 薛焱. All rights reserved.
//

#import "AdDetailViewController.h"

@interface AdDetailViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation AdDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
	[self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
}

- (BOOL)prefersStatusBarHidden {
	return NO;
}

- (IBAction)backButtonDidTouch:(id)sender {
	[self.navigationController popViewControllerAnimated:NO];
}

@end
