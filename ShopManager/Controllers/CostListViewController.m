//
//  CostListViewController.m
//  ShopManager
//
//  Created by 张旭 on 6/14/16.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import "CostListViewController.h"
@import MBProgressHUD;
@import DateTools;
#import "ShopManager-Swift.h"
#import "UILabel+FlickerNumber.h"
#import "HttpClient.h"
#import "CostListCollectionViewCell.h"
#import "CostOrderListViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "CostListHeaderView.h"
#import "StoreSelectView.h"

@interface CostListViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (copy, nonatomic) NSString *saleMoney;
@property (assign, nonatomic) BOOL isLoaded;

@property (strong, nonatomic) NSArray *imageArray;

@property (strong, nonatomic) CostListHeaderView *headerView;

@property (strong, nonatomic) StoreSelectView *storeSelectView;

@property (strong, nonatomic) NSArray<CostItem *> *data;
@end

@implementation CostListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _imageArray = [NSArray arrayWithObjects:@"btn-xse", @"btn-xcml", @"btn-mrml", @"btn-ypml", @"btn-wxml", @"ltml", @"icon-axml", @"icon-yxml", @"icon-cardml", @"btn-cxxs", @"btn-bpml", nil];
    self.isLoaded = NO;
    self.collectionView.contentInset = UIEdgeInsetsMake(277, 0, 0, 0);
	[self.collectionView addSubview:self.headerView];
	[MBProgressHUD showHUDAddedTo:self.view animated:YES];
	[self saleTotalRequest];
	[self costListRequest];
}

- (CostListHeaderView *)headerView {
	if (_headerView == nil) {
		_headerView = [[CostListHeaderView alloc] initWithFrame:CGRectMake(0, -277, kScreenWidth, 276)];
		_headerView.storeNameL.text = self.storeName;
		__weak typeof(self) weakSelf = self;
		_headerView.chartBlock = ^(NSInteger index){
			_selectedIndex = index;
			[MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
			[weakSelf costListRequest];
		};
	}
	return _headerView;
}

- (StoreSelectView *)storeSelectView {
	if (_storeSelectView == nil) {
		_storeSelectView = [[StoreSelectView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64)];
		__weak typeof(self) weakSelf = self;
		_storeSelectView.confirmBlock = ^(NSString *name, NSString *idStr) {
			weakSelf.storeName = name;
			weakSelf.storeId = idStr;
			weakSelf.headerView.storeNameL.text = weakSelf.storeName;
			[MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
			[weakSelf saleTotalRequest];
			[weakSelf costListRequest];
		};
		[self.view addSubview:_storeSelectView];
	}
	return _storeSelectView;
}

- (IBAction)menuButtonDidTouch:(id)sender {
	[self.storeSelectView show];
}

- (IBAction)backButtonDidTouch:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"CostOrderSegue"]) {
        CostOrderListViewController *vc = segue.destinationViewController;
        NSIndexPath *indexPath = sender;
        vc.costObjectName = _data[indexPath.row].costObjectName;
		vc.selectedIndex = _selectedIndex;
		vc.storeName = self.storeName;
		vc.storeId = self.storeId;
    }
}

#pragma mark - UIWebViewDelegate

//- (void)webViewDidFinishLoad:(UIWebView *)webView {
//	JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
//	context[@"clickIndex"] = ^() {
//
//		NSArray *args = [JSContext currentArguments];
//
//		JSValue *jsVal = args[0];
//		_selectedIndex = [jsVal toInt32];
//
//		dispatch_async(dispatch_get_main_queue(), ^{
//			[self costListRequest];
//		});
//	};
//    [UIView animateWithDuration:0.5 animations:^{
//        webView.alpha = 1;
//    } completion:^(BOOL finished) {
//        self.isLoaded = YES;
//    }];
//}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"CostOrderSegue" sender:indexPath];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_data == nil) {
        return 0;
    }
    return _data.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CostListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CostListCollectionViewCell" forIndexPath:indexPath];
    CostItem *item = _data[indexPath.row];
    cell.titleL.text = item.costObjectName;
    cell.numL.text = item.taxSaleTotal;
	UIImage *image = [[UIImage imageNamed:item.costObjectName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
	if (image == nil) {
		cell.imageView.image = [UIImage imageNamed:self.imageArray[0]];
	} else {
		cell.imageView.image = image;
	}
    return cell;
}


#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (kScreenWidth-1)/2;
    return CGSizeMake(width, 122);
}



#pragma mark - Request

- (void)saleTotalRequest {
    [[HttpClient sharedHttpClient] getSaleTotalWithStoreId:self.storeId completion:^(BOOL success, NSArray *data) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (success) {
            NSString *jsStr = @"var list = new Array();";
            NSDate *today = [NSDate date];
            NSInteger days = [today daysInMonth];
			NSInteger day = today.day;
            for (NSInteger i = 1; i <= days; ++i) {
                if (i <= data.count) {
                    SaleTotalItem *item = [data objectAtIndex:i - 1];
                    jsStr = [jsStr stringByAppendingString:[NSString stringWithFormat:@"list[%ld] = new Item(%ld, %@);", i - 1, i, item.saleTotal]];
                } else {
                    jsStr = [jsStr stringByAppendingString:[NSString stringWithFormat:@"list[%ld] = new Item(%ld, 0);", i - 1, i]];
                }
            }
//            SaleTotalItem *item = [data objectAtIndex:today.day-2];
//            self.saleMoney = item.saleTotal;
			SaleTotalItem *item = nil;
			if (day <= data.count) {
				item = data[day-1];
			}
			jsStr = [jsStr stringByAppendingString:[NSString stringWithFormat:@"setData(list, %@, '今日销售额（元）', '元', '销售额');", item != nil ? item.saleTotal : @"0"]];
			self.headerView.jsStr = jsStr;
//            dispatch_async(dispatch_queue_create("load", nil), ^{
//                while (/*self.webView.isLoading &&*/ !self.isLoaded) {
//                    NSLog(@"fail");
//                    usleep(300000);
//                }
//                [self performSelectorOnMainThread:@selector(loadJS:) withObject:jsStr waitUntilDone:YES];
//            });
        }
    } failure:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (void)costListRequest {
	NSDate *date = [NSDate date];
	NSString *dateString = nil;
	if (_selectedIndex != -1) {
		dateString = [NSString stringWithFormat:@"%ld-%02ld-%02ld", date.year, date.month, _selectedIndex+1];
	} else {
		dateString = [NSString stringWithFormat:@"%ld-%02ld-%02ld", date.year, date.month, date.day];
	}
	[[HttpClient sharedHttpClient] getCostListWithDateString:dateString storeId:self.storeId Completion:^(BOOL success, NSArray *data) {
		[MBProgressHUD hideHUDForView:self.view animated:YES];
        if (success) {
            self.data = data;
            [self.collectionView reloadData];
		} else {
			self.data = nil;
			[self.collectionView reloadData];
		}
    } failure:^{
		self.data = nil;
		[self.collectionView reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

@end
