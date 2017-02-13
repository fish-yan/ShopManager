//
//  OnBoardCarViewController.m
//  ShopManager
//
//  Created by 张旭 on 19/10/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import "OnBoardCarViewController.h"
#import "StoreBoardHeaderView.h"
#import "SBCarCountTableViewCell.h"
#import "StoreBoardFilterView.h"
#import "StoreList.h"
#import "OnBoardDetailViewController.h"

#define carCell @"carCell"

@interface OnBoardCarViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) StoreBoardHeaderView *headerView;
@property (strong, nonatomic) StoreBoardFilterView *filterView;

@property (strong, nonatomic) NSArray<NSString *> *titleArray;

@end

@implementation OnBoardCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	[self.tableView registerNib:[UINib nibWithNibName:@"SBCarCountTableViewCell" bundle:nil] forCellReuseIdentifier:carCell];
	self.titleArray = @[@"洗车台次", @"透明车间台次", @"其他"];
	self.tableView.contentInset = UIEdgeInsetsMake(301, 0, 0, 0);
	[self.tableView addSubview:self.headerView];
	[MBProgressHUD showHUDAddedTo:self.view animated:YES];
	[self chartRequest];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[IQKeyboardManager sharedManager].enableAutoToolbar = YES;
}

- (StoreBoardHeaderView *)headerView {
	if (_headerView == nil) {
		_headerView = [[StoreBoardHeaderView alloc] initWithFrame:CGRectMake(0, -301, kScreenWidth, 300)];
		_headerView.nameL.text = self.viewModel.storeName;
		_headerView.timeL.text = self.viewModel.showTime;
		__weak typeof(self) weakSelf = self;
		_headerView.chartBlock = ^(NSInteger index) {
			weakSelf.viewModel.selectedDate = weakSelf.viewModel.chartDataSource[index].date;
			weakSelf.viewModel.xcCount = [NSString stringWithFormat:@"%zd", weakSelf.viewModel.chartDataSource[index].xcCount];
			weakSelf.viewModel.wxCount = [NSString stringWithFormat:@"%zd", weakSelf.viewModel.chartDataSource[index].wxCount];
			weakSelf.viewModel.otherCount = [NSString stringWithFormat:@"%zd", weakSelf.viewModel.chartDataSource[index].otherCount];
			[weakSelf.tableView reloadData];
		};
	}
	return _headerView;
}

- (StoreBoardFilterView *)filterView {
	if (_filterView == nil) {
		_filterView = [[StoreBoardFilterView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64)];
		__weak typeof(self) weakSelf = self;
		_filterView.confirmBlock = ^(NSString *startDate, NSString *endDate, NSInteger storeIndex) {
			weakSelf.viewModel.startDate = startDate;
			weakSelf.viewModel.endDate = endDate;
			if (storeIndex != -1) {
				weakSelf.viewModel.storeName = [StoreList sharedList].dataSource[storeIndex].name;
				weakSelf.viewModel.storeId = [StoreList sharedList].dataSource[storeIndex].idStr;
			}
			weakSelf.headerView.nameL.text = weakSelf.viewModel.storeName;
			weakSelf.headerView.timeL.text = weakSelf.viewModel.showTime;
			[MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
			[weakSelf chartRequest];
		};
		[self.view addSubview:_filterView];
	}
	return _filterView;
}

- (OnBoardVM *)viewModel {
	if (_viewModel == nil) {
		_viewModel = [[OnBoardVM alloc] init];
	}
	return _viewModel;
}

- (IBAction)menuButtonDidTouch:(id)sender {
	[self.filterView show];
}

- (IBAction)backButtonDidTouch:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	OnBoardDetailViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"OnBoardDetailVC"];
	vc.viewModel.code = self.viewModel.code;
	vc.viewModel.selectedDate = self.viewModel.selectedDate;
	vc.viewModel.storeName = self.viewModel.storeName;
	vc.viewModel.storeId = self.viewModel.storeId;
	if (indexPath.row == 0) {
		vc.viewModel.type = @"xc";
	} else if (indexPath.row == 1) {
		vc.viewModel.type = @"tmcj";
	} else if (indexPath.row == 2) {
		vc.viewModel.type = @"qt";
	}
	[self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	SBCarCountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:carCell];
	cell.titleL.text = self.titleArray[indexPath.row];
	if (indexPath.row == 0) {
		cell.countL.text = self.viewModel.xcCount;
	} else if (indexPath.row == 1) {
		cell.countL.text = self.viewModel.wxCount;
	} else if (indexPath.row == 2) {
		cell.countL.text = self.viewModel.otherCount;
	}
	return cell;
}

#pragma mark - Request

- (void)chartRequest {
	[self.viewModel chartRequestWithComplete:^(BOOL success, NSString *jsStr, NSString *message) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
		if (success) {
			self.headerView.jsStr = jsStr;
		} else {
			[self.view makeToast:message duration:2 position:CSToastPositionCenter];
		}
		[self.tableView reloadData];
	} failure:^{
		[MBProgressHUD hideHUDForView:self.view animated:YES];
		[self.view makeToast:@"请求失败, 请重试" duration:2 position:CSToastPositionCenter];
		[self.tableView reloadData];
	}];
}

@end
