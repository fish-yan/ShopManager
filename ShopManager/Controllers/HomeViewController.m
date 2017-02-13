//
//  HomeViewController.m
//  ShopManager
//
//  Created by 张旭 on 2/22/16.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import "HomeViewController.h"
#import <WebKit/WebKit.h>
#import "HttpClient.h"
#import "UILabel+FlickerNumber.h"
#import "RootViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "CostListViewController.h"
#import "CarCountViewController.h"
#import "UnFinishedViewController.h"
@import DateTools;
@import MBProgressHUD;

@interface HomeViewController ()<UIGestureRecognizerDelegate, UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *chartView;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *homeLabels;

@property (assign, nonatomic) NSInteger selectedIndex;


@property (strong, nonatomic) NSArray *segueArrays;
@property (assign, nonatomic) BOOL isLoaded;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.webView.delegate = self;
    self.webView.alpha = 0;
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"area" withExtension:@"html"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    self.segueArrays = [NSArray arrayWithObjects:@"CarCountSegue", @"CarCountSegue", @"CustomerSegue", @"CustomerSegue", nil];
    self.isLoaded = NO;
	_selectedIndex = -1;
    [self homeDataRequestWithIndex];
    [self saleTotalRequest];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (IBAction)menuButtonDidTouch:(id)sender {
    [self performSegueWithIdentifier:@"UserSegue" sender:self];
}

- (IBAction)saleButtonDidTouch:(id)sender {
    [self performSegueWithIdentifier:@"CostSegue" sender:self];
}

- (IBAction)microButtonDidTouch:(id)sender {
    [self performSegueWithIdentifier:@"MicroSegue" sender:self];
}

- (IBAction)starButtonDidTouch:(id)sender {
    [self performSegueWithIdentifier:@"StarSegue" sender:self];
}

- (IBAction)BTBSegue:(id)sender {
	UIStoryboard *mainSB = [UIStoryboard storyboardWithName:@"ShopManager" bundle:nil];
	UnFinishedViewController *vc = [mainSB instantiateViewControllerWithIdentifier:@"UnFinishedVC"];
	[self.navigationController pushViewController:vc animated:YES];
//    RootViewController *btb = [[RootViewController alloc] init];
//    [self.navigationController presentViewController:btb animated:YES completion:nil];
}

- (IBAction)listButtonDidTouch:(id)sender {
    UIButton *button = sender;
    if (button.tag < self.segueArrays.count) {
        [self performSegueWithIdentifier:[self.segueArrays objectAtIndex:button.tag] sender:self];
    }
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"CostSegue"]) {
		CostListViewController *vc = segue.destinationViewController;
		vc.selectedIndex = _selectedIndex;
	} else if ([segue.identifier isEqualToString:@"CarCountSegue"]) {
		CarCountViewController *vc = segue.destinationViewController;
		vc.selectedIndex = _selectedIndex;
	}
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (self.navigationController.viewControllers.count > 1) {
        return YES;
    }
    return NO;
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
	context[@"clickIndex"] = ^() {

		NSArray *args = [JSContext currentArguments];
		JSValue *jsVal = args[0];
		_selectedIndex = [jsVal toInt32];

		dispatch_async(dispatch_get_main_queue(), ^{

			[self homeDataRequestWithIndex];
		});
	};
    [UIView animateWithDuration:0.5 animations:^{
        webView.alpha = 1;
    } completion:^(BOOL finished) {
        self.isLoaded = YES;
    }];
}

#pragma mark - Request

- (void)saleTotalRequest {
    [[HttpClient sharedHttpClient] getSaleFrontTotalWithCompletion:^(BOOL success, NSArray *data) {
        if (success) {
            NSString *jsStr = @"var list = new Array();";
            NSDate *today = [NSDate date];
            NSInteger days = [today daysInMonth];
            NSInteger day = [today day];
            for (NSInteger i = 1; i <= days; ++i) {
                if (i <= data.count) {
                    SaleTotalItem *item = [data objectAtIndex:i-1];
                    jsStr = [jsStr stringByAppendingString:[NSString stringWithFormat:@"list[%ld] = new Item(%ld, %@);", i-1, i, item.saleTotal]];
                } else {
                    jsStr = [jsStr stringByAppendingString:[NSString stringWithFormat:@"list[%ld] = new Item(%ld, 0);", i-1, i]];
                }
            }
            SaleTotalItem *item = nil;
            if (day < data.count) {
                item = [data objectAtIndex:day-1];
            }
            jsStr = [jsStr stringByAppendingString:[NSString stringWithFormat:@"setData(list, %@, '今日前台营业额（元）', '元', '前台营业额');", item != nil ? item.saleTotal : @"0"]];
            dispatch_async(dispatch_queue_create("load", nil), ^{
                while (/*self.webView.isLoading &&*/ !self.isLoaded) {
                    NSLog(@"fail");
                    usleep(300000);
                }
                [self performSelectorOnMainThread:@selector(loadJS:) withObject:jsStr waitUntilDone:YES];
            });
        }

    } failure:^{
        
    }];
}

- (void)loadJS:(NSString *)jsStr {
    [self.webView stringByEvaluatingJavaScriptFromString:jsStr];
}

- (void)homeDataRequestWithIndex {
	NSDate *date = [NSDate date];
	NSString *dateString = nil;
	if (_selectedIndex != -1) {
		dateString = [NSString stringWithFormat:@"%ld-%02ld-%02ld", date.year, date.month, _selectedIndex+1];
	} else {
		dateString = [NSString stringWithFormat:@"%ld-%02ld-%02ld", date.year, date.month, date.day];
	}
    [[HttpClient sharedHttpClient] getHomeDataWithDateString:dateString Completion:^(BOOL success, NSArray *data) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (success) {
            for (NSInteger i = 0; i < self.homeLabels.count; ++i) {
                UILabel *label = [self.homeLabels objectAtIndex:i];
                [label fn_setNumber:[NSNumber numberWithInteger:[[data objectAtIndex:i] integerValue]]];
            }
        }
    } failure:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

@end
