//
//  CustomerViewController.m
//  ShopManager
//
//  Created by 张旭 on 2/23/16.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import "CustomerViewController.h"
#import "HttpClient.h"
#import "ShopManager-Swift.h"
#import "UILabel+FlickerNumber.h"
#import "CustomerTableViewCell.h"
@import MBProgressHUD;

@interface CustomerViewController ()<UITableViewDelegate, UITableViewDataSource, UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (strong, nonatomic) CustomAnaly *customAnalyData;
@property (assign, nonatomic) BOOL isLoaded;
@end

@implementation CustomerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView.delegate = self;
    self.webView.alpha = 0;
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"funnel" withExtension:@"html"];
    self.isLoaded = NO;
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    [self customAnalyDataRequest];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (IBAction)backButtonDidTouch:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.customAnalyData == nil ? 0 : self.customAnalyData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomerCell"];
    [cell.titleLabel setText:[[CustomAnaly title] objectAtIndex:indexPath.row]];
    [cell.valueLabel fn_setNumber:[NSNumber numberWithInteger:[self.customAnalyData objectAtIndex:indexPath.row]]];
    return cell;
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [UIView animateWithDuration:0.5 animations:^{
        webView.alpha = 1;
    } completion:^(BOOL finished) {
        self.isLoaded = YES;
    }];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"%@", error);
}

#pragma mark - Request

- (void)customAnalyDataRequest {
    [[HttpClient sharedHttpClient] getCustomAnalyDataWithCompletion:^(BOOL success, CustomAnaly *data) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (success) {
            self.customAnalyData = data;
            [self.tableView reloadData];
            NSString *jsStr = @"var list = new Array();";
            for (NSInteger i = 0; i < self.customAnalyData.count; ++i) {
                jsStr = [jsStr stringByAppendingString:[NSString stringWithFormat:@"list[%ld] = new Item('%@', %ld);", i, [[CustomAnaly title] objectAtIndex:i], [self.customAnalyData objectAtIndex:i]]];
            }
            jsStr = [jsStr stringByAppendingString:@"setData(list);"];
            dispatch_async(dispatch_queue_create("load", nil), ^{
                while (/*self.webView.isLoading &&*/ !self.isLoaded) {
                    NSLog(@"fail");
                    usleep(300000);
                }
                [self performSelectorOnMainThread:@selector(loadJS:) withObject:jsStr waitUntilDone:YES];
            });
        }
    } failure:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (void)loadJS:(NSString *)jsStr {
    [self.webView stringByEvaluatingJavaScriptFromString:jsStr];
}

@end
