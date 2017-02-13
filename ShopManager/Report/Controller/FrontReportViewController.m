//
//  FrontReportViewController.m
//  ShopManager
//
//  Created by 张旭 on 10/11/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import "FrontReportViewController.h"
#import "StoreBoardFilterView.h"
#import "StoreList.h"

#import "FrontReportFirstView.h"
#import "FrontReportSecondView.h"
#import "FrontReportThirdView.h"

#import "FrontReportDetailViewController.h"

@interface FrontReportViewController ()

@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;

@property (weak, nonatomic) IBOutlet FrontReportFirstView *firstView;
@property (weak, nonatomic) IBOutlet FrontReportSecondView *secondView;
@property (weak, nonatomic) IBOutlet FrontReportThirdView *thirdView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraints;

@property (strong, nonatomic) StoreBoardFilterView *filterView;

@end

@implementation FrontReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.nameL.text = self.viewModel.storeName;
	self.timeL.text = self.viewModel.showTime;
	self.firstView.viewModel = self.viewModel;
	self.secondView.viewModel = self.viewModel;
	self.thirdView.viewModel = self.viewModel;
	self.firstView.detailBlock = ^{
		FrontReportDetailViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"FrontReportDetailVC"];
		vc.viewModel = self.viewModel;
		[self.navigationController pushViewController:vc animated:YES];
	};
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
	[self firstRequest];
//	self.firstView.jsStr = @"var starList = [];starList.push(new PieItem('3', 495));starList.push(new PieItem('3.5', 193));starList.push(new PieItem('4.0', 48));starList.push(new PieItem('5.0', 2));setPieData(starList, ['#ffbdb4', '#ffbdb4', '#ffbdb4', '#ffbdb4', '#ffbdb4', '#ffbdb4', '#ffbdb4', '#ffbdb4', '#ffbdb4', '#ffbdb4', '#ffbdb4']);";
//	self.secondView.jsStr = @"var starList = [];starList.push(new PieItem('3', 495));starList.push(new PieItem('3.5', 193));starList.push(new PieItem('4.0', 48));starList.push(new PieItem('5.0', 2));setPieData(starList, ['#ffbdb4', '#ffbdb4', '#ffbdb4', '#ffbdb4', '#ffbdb4', '#ffbdb4', '#ffbdb4', '#ffbdb4', '#ffbdb4', '#ffbdb4', '#ffbdb4']);";
//	self.thirdView.jsStr = @"var starList = [];starList.push(new PieItem('3', 495));starList.push(new PieItem('3.5', 193));starList.push(new PieItem('4.0', 48));starList.push(new PieItem('5.0', 2));setPieData(starList, ['#ffbdb4', '#ffbdb4', '#ffbdb4', '#ffbdb4', '#ffbdb4', '#ffbdb4', '#ffbdb4', '#ffbdb4', '#ffbdb4', '#ffbdb4', '#ffbdb4']);";
	[self secondRequest];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[IQKeyboardManager sharedManager].enableAutoToolbar = YES;
}

- (FrontReportVM *)viewModel {
	if (_viewModel == nil) {
		_viewModel = [[FrontReportVM alloc] init];
	}
	return _viewModel;
}

- (StoreBoardFilterView *)filterView {
	if (_filterView == nil) {
		_filterView = [[StoreBoardFilterView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) type:1];
		__weak typeof(self) weakSelf = self;
		_filterView.confirmBlock = ^(NSString *startDate, NSString *endDate, NSInteger storeIndex) {
			weakSelf.viewModel.startDate = startDate;
			weakSelf.viewModel.endDate = endDate;
			if (storeIndex != -1) {
				weakSelf.viewModel.storeName = [StoreList sharedList].dataSource2[storeIndex].name;
				weakSelf.viewModel.storeId = [StoreList sharedList].dataSource2[storeIndex].idStr;
			}
			weakSelf.nameL.text = weakSelf.viewModel.storeName;
			weakSelf.timeL.text = weakSelf.viewModel.showTime;
            [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
			[weakSelf firstRequest];
			[weakSelf secondRequest];
		};
		[self.view addSubview:_filterView];
	}
	return _filterView;
}

- (IBAction)menuButtonDidTouch:(id)sender {
	[self.filterView show];
}

- (IBAction)backButtonDidTouch:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Request

- (void)firstRequest {
	[self.viewModel firstRequestWithCompletion:^(BOOL success, NSString *jsStr1, NSString *jsStr2, NSString *message) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
		if (success) {
			self.firstView.jsStr = jsStr1;
			self.secondView.jsStr = jsStr2;
			self.firstView.viewModel = self.viewModel;
			self.secondView.viewModel = self.viewModel;
        } else {
            [self.view makeToast:message duration:2 position:CSToastPositionCenter];
        }
	} failure:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
		[self.view makeToast:@"请求失败, 请重试" duration:2 position:CSToastPositionCenter];
	}];
}

- (void)secondRequest {
	[self.viewModel secondRequestWithCompletion:^(BOOL success, NSString *jsStr, NSString *message) {
		if (success) {
			self.thirdView.jsStr = jsStr;
			self.heightConstraints.constant = 357+(self.viewModel.chartDataSource.count+1)/2*49-15;
			[self.view layoutIfNeeded];
			self.thirdView.viewModel = self.viewModel;
        } else {
            [self.view makeToast:message duration:2 position:CSToastPositionCenter];
        }
	} failure:^{
        [self.view makeToast:@"请求失败, 请重试" duration:2 position:CSToastPositionCenter];
	}];
}

@end
