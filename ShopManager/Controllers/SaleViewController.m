//
//  SaleViewController.m
//  ShopManager
//
//  Created by 张旭 on 2/23/16.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import "HttpClient.h"
#import "SaleViewController.h"
#import "ShopManager-Swift.h"
#import "UILabel+FlickerNumber.h"
@import DateTools;
@import MBProgressHUD;

@interface SaleViewController () <UIWebViewDelegate>
@property(weak, nonatomic) IBOutlet UIWebView *webView;
@property(strong, nonatomic) IBOutletCollection(UILabel) NSArray *saleLabels;

@property (copy, nonatomic) NSString *saleMoney;
@property (assign, nonatomic) BOOL isLoaded;
@end

@implementation SaleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView.delegate = self;
    self.webView.alpha = 0;
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"area" withExtension:@"html"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    self.isLoaded = NO;
    [self saleDataRequest];
    [self costListRequest];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (IBAction)backButtonDidTouch:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadJS:(NSString *)jsStr {
    [self.webView stringByEvaluatingJavaScriptFromString:jsStr];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [UIView animateWithDuration:0.5 animations:^{
        webView.alpha = 1;
    } completion:^(BOOL finished) {
        self.isLoaded = YES;
    }];
}

#pragma mark - Request

- (void)saleTotalRequest {
//    [[HttpClient sharedHttpClient] getSaleTotalWithCompletion:^(BOOL success, NSArray *data) {
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        if (success) {
//            NSString *jsStr = @"var list = new Array();";
//            NSDate *today = [NSDate date];
//            NSInteger days = [today daysInMonth];
//            for (NSInteger i = 1; i <= days; ++i) {
//                if (i <= data.count) {
//                    SaleTotalItem *item = [data objectAtIndex:i - 1];
//                    jsStr = [jsStr stringByAppendingString:[NSString stringWithFormat:@"list[%ld] = new Item(%ld, %@);", i - 1, i, item.saleTotal]];
//                } else {
//                    jsStr = [jsStr stringByAppendingString:[NSString stringWithFormat:@"list[%ld] = new Item(%ld, 0);", i - 1, i]];
//                }
//            }
//            
//            jsStr = [jsStr stringByAppendingString:[NSString stringWithFormat:@"setData(list, %@, '销售额（元）', '元', '销售额');", self.saleMoney]];
//            dispatch_async(dispatch_queue_create("load", nil), ^{
//                while (/*self.webView.isLoading &&*/ !self.isLoaded) {
//                    NSLog(@"fail");
//                    usleep(300000);
//                }
//                [self performSelectorOnMainThread:@selector(loadJS:) withObject:jsStr waitUntilDone:YES];
//            });
//        }
//    } failure:^{
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//    }];
}

- (void)saleDataRequest {
    [[HttpClient sharedHttpClient] getSaleDataWithCompletion:^(BOOL success, NSArray *data) {
        if (success) {
            for (NSInteger i = 0; i < self.saleLabels.count; ++i) {
                UILabel *label = [self.saleLabels objectAtIndex:i];
                [label fn_setNumber:[NSNumber numberWithDouble:[[data objectAtIndex:i] doubleValue]] format:@"%.2f"];
                if (i == 0) {
                    self.saleMoney = [[data objectAtIndex:i] stringValue];
                }
            }
            [self saleTotalRequest];
        }
    } failure:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (void)costListRequest {
//    [[HttpClient sharedHttpClient] getCostListWithCompletion:^(BOOL success, NSArray *data) {
//        if (success) {
//            
//        }
//    } failure:^{
//        
//    }];
}

@end
