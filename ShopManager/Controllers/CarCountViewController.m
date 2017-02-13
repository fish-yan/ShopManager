//
//  CarCountViewController.m
//  ShopManager
//
//  Created by 张旭 on 2/23/16.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import "CarCountViewController.h"
#import "CarCountTableViewCell.h"
#import "HttpClient.h"
#import "ShopManager-Swift.h"
#import "UILabel+FlickerNumber.h"
#import <JavaScriptCore/JavaScriptCore.h>
@import DateTools;
@import MBProgressHUD;

@interface CarCountViewController ()<UITableViewDelegate, UITableViewDataSource, UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerConstraint;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (assign, nonatomic) BOOL isTransitionTouched;
@property (strong, nonatomic) NSArray *countTitleArray;
@property (strong, nonatomic) NSArray *countCountArray;
@property (strong, nonatomic) NSArray *transitionDeptArray;
@property (strong, nonatomic) NSString *comeInJS;
@property (strong, nonatomic) NSString *transferJS;

@property (assign, nonatomic) BOOL isLoaded;
@end

@implementation CarCountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isTransitionTouched = NO;
    self.countTitleArray = [NSArray arrayWithObjects:@"洗车台次", @"透明车间台次", @"预约台次", nil];
    self.webView.delegate = self;
    self.webView.alpha = 0;
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"area" withExtension:@"html"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    self.isLoaded = NO;
    [self comeInRequest];
    [self comeInDataRequest];
    [self transferRequest];
    [self transferDeptRequest];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (IBAction)countButtonDidTouch:(id)sender {
    if (self.centerConstraint.constant > 0) {
        self.centerConstraint.constant -= self.lineView.frame.size.width;
        [UIView animateWithDuration:0.5 animations:^{
            [self.view layoutIfNeeded];
        }];
        self.isTransitionTouched = NO;
        [self.tableView reloadData];
        [self.webView stringByEvaluatingJavaScriptFromString:self.comeInJS];
    }
}

- (IBAction)transitionButtonDidTouch:(id)sender {
    if (self.centerConstraint.constant == 0) {
        self.centerConstraint.constant += self.lineView.frame.size.width;
        [UIView animateWithDuration:0.5 animations:^{
            [self.view layoutIfNeeded];
        }];
        self.isTransitionTouched = YES;
        [self.tableView reloadData];
        [self.webView stringByEvaluatingJavaScriptFromString:self.transferJS];
    }
}

- (IBAction)backButtonDidTouch:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDelegate

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
    if (self.isTransitionTouched) {
        return [self.transitionDeptArray count];
    }
    return [self.countTitleArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CarCountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CarCountCell"];
    if (self.isTransitionTouched) {
        DeptTransfer *item = [self.transitionDeptArray objectAtIndex:indexPath.row];
        
        cell.titleLabel.text = item.deptName;
        cell.countLabel.text = [NSString stringWithFormat:@"%@%%", item.transferPer];
    } else {
        cell.titleLabel.text = [self.countTitleArray objectAtIndex:indexPath.row];
        if (self.countCountArray != nil && self.countCountArray.count != 0) {
            cell.countLabel.text = [self.countCountArray objectAtIndex:indexPath.row];
        } else {
            cell.countLabel.text = @"0";
        }
    }
    return cell;
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
	context[@"clickIndex"] = ^() {

		NSArray *args = [JSContext currentArguments];
		JSValue *jsVal = args[0];
		_selectedIndex = [jsVal toInt32];
		dispatch_async(dispatch_get_main_queue(), ^{
			if (_isTransitionTouched) {
				[self transferDeptRequest];
			} else {
				[self comeInDataRequest];
			}
		});
	};
    [UIView animateWithDuration:0.5 animations:^{
        webView.alpha = 1;
    } completion:^(BOOL finished) {
        self.isLoaded = YES;
    }];
}

#pragma mark - Request

- (void)comeInRequest {
    [[HttpClient sharedHttpClient] getComeInWithCompletion:^(BOOL success, NSArray *data) {
        if (success) {
            NSString *jsStr = @"var list = new Array();";
            NSDate *today = [NSDate date];
            NSInteger days = [today daysInMonth];
            NSInteger day = [today day];
            for (NSInteger i = 1; i <= days; ++i) {
                if (i <= data.count) {
                    ComeInItem *item = [data objectAtIndex:i-1];
                    jsStr = [jsStr stringByAppendingString:[NSString stringWithFormat:@"list[%ld] = new Item(%ld, %@);", i-1, i, item.comeInTotal]];
                } else {
                    jsStr = [jsStr stringByAppendingString:[NSString stringWithFormat:@"list[%ld] = new Item(%ld, 0);", i-1, i]];
                }
            }
            ComeInItem *item = nil;
            if (day <= data.count) {
                item = [data objectAtIndex:day-1];
            }
            
            jsStr = [jsStr stringByAppendingString:[NSString stringWithFormat:@"setData(list, %@, '进场台次（台）', '台', '进场台次');", item != nil ? item.comeInTotal : @"0"]];
            self.comeInJS = jsStr;
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

- (void)comeInDataRequest {
	NSDate *date = [NSDate date];
	NSString *dateString = nil;
	if (_selectedIndex != -1) {
		dateString = [NSString stringWithFormat:@"%ld-%02ld-%02ld", date.year, date.month, _selectedIndex+1];
	} else {
		dateString = [NSString stringWithFormat:@"%ld-%02ld-%02ld", date.year, date.month, date.day];
	}
    [[HttpClient sharedHttpClient] getComeInDataWithDateString:dateString Completion:^(BOOL success, NSArray *data) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (success) {
            self.countCountArray = data;
            [self.tableView reloadData];
        }
    } failure:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (void)transferRequest {
    [[HttpClient sharedHttpClient] getTransferWithCompletion:^(BOOL success, NSArray *data) {
        if (success) {
            NSString *jsStr = @"var list = new Array();";
            NSDate *today = [NSDate date];
            NSInteger days = [today daysInMonth];
            NSInteger day = [today day];
            for (NSInteger i = 1; i <= days; ++i) {
                if (i <= data.count) {
                    TransferItem *item = [data objectAtIndex:i-1];
                    jsStr = [jsStr stringByAppendingString:[NSString stringWithFormat:@"list[%ld] = new Item(%ld, %@);", i-1, i, item.transfer]];
                } else {
                    jsStr = [jsStr stringByAppendingString:[NSString stringWithFormat:@"list[%ld] = new Item(%ld, 0);", i-1, i]];
                }
            }
            TransferItem *item = nil;
            if (day <= data.count) {
                item = [data objectAtIndex:day-1];
            }
            
            jsStr = [jsStr stringByAppendingString:[NSString stringWithFormat:@"setData(list, %@, '部门转化率', '%%', '部门转化率');", item != nil ? item.transfer : @"0"]];
            self.transferJS = jsStr;
        }
    } failure:^{
        
    }];
}

- (void)transferDeptRequest {
	NSDate *date = [NSDate date];
	NSString *dateString = nil;
	if (_selectedIndex != -1) {
		dateString = [NSString stringWithFormat:@"%ld-%02ld-%02ld", date.year, date.month, _selectedIndex+1];
	} else {
		dateString = [NSString stringWithFormat:@"%ld-%02ld-%02ld", date.year, date.month, date.day];
	}
    [[HttpClient sharedHttpClient] getDeptTransferDataWithDateString:dateString Completion:^(BOOL success, NSArray *data) {
        if (success) {
            self.transitionDeptArray = data;
            [self.tableView reloadData];
        }
    } failure:^{
        
    }];
}

@end
