//
//  PurchaseViewController.m
//  ShopManager
//
//  Created by 张旭 on 07/11/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import "PurchaseViewController.h"
#import "PurchaseTableViewCell.h"
#import "StoreBoardHeaderView.h"
#import "PurchaseFilterView.h"
#import "StoreList.h"
#import "PurchaseDetailViewController.h"

#define itemCell @"itemCell"

@interface PurchaseViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) StoreBoardHeaderView *headerView;

@property (strong, nonatomic) PurchaseFilterView *filterView;

@end

@implementation PurchaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.tableView.contentInset = UIEdgeInsetsMake(301, 0, 0, 0);
	[self.tableView addSubview:self.headerView];
	[self.tableView registerNib:[UINib nibWithNibName:@"PurchaseTableViewCell" bundle:nil] forCellReuseIdentifier:itemCell];
	self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
		[self listRequest];
	}];
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
			weakSelf.viewModel.currentPage = 1;
            [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
			[weakSelf listRequest];
		};
	}
	return _headerView;
}

- (PurchaseFilterView *)filterView {
	if (_filterView == nil) {
		_filterView = [[PurchaseFilterView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64)];
		__weak typeof(self) weakSelf = self;
		_filterView.confirmBlock = ^(NSString *startDate, NSString *endDate, NSInteger storeIndex, NSString *supplier, BOOL both) {
			weakSelf.viewModel.startDate = startDate;
			weakSelf.viewModel.endDate = endDate;
			if (storeIndex != -1) {
				weakSelf.viewModel.storeName = [StoreList sharedList].dataSource[storeIndex].name;
				weakSelf.viewModel.storeId = [StoreList sharedList].dataSource[storeIndex].idStr;
			}
			weakSelf.viewModel.isSelected = both;
			weakSelf.headerView.nameL.text = weakSelf.viewModel.storeName;
			weakSelf.headerView.timeL.text = weakSelf.viewModel.showTime;
            [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
			[weakSelf chartRequest];
		};
		[self.view addSubview:_filterView];
	}
	return _filterView;
}

- (PurchaseVM *)viewModel {
	if (_viewModel == nil) {
		_viewModel = [[PurchaseVM alloc] init];
	}
	return _viewModel;
}

- (IBAction)filterButtonDidTouch:(id)sender {
	[self.filterView show];
}

- (IBAction)backButtonDidTouch:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	PurchaseDetailViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"PurchaseDetailVC"];
	vc.viewModel.startDate = self.viewModel.startDate;
	vc.viewModel.endDate = self.viewModel.endDate;
	vc.viewModel.storeName = self.viewModel.storeName;
	vc.viewModel.storeId = self.viewModel.storeId;

	PurchaseItemVM *item = self.viewModel.listDataSource[indexPath.row];
	vc.viewModel.supplier = item.name;
	vc.viewModel.supplierId = item.supplierId;
	[self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 129;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (self.viewModel.listDataSource == nil) {
		return 0;
	}
	return self.viewModel.listDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	PurchaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:itemCell];
	PurchaseItemVM *item = self.viewModel.listDataSource[indexPath.row];
	cell.nameL.text = item.name;
	cell.inCountL.text = [NSString stringWithFormat:@"%.2f", item.inCount];
	cell.backCountL.text = [NSString stringWithFormat:@"%.2f", item.backCount];
	cell.totalCountL.text = [NSString stringWithFormat:@"%.2f", item.totalCount];
	return cell;
}

#pragma mark - Request

- (void)chartRequest {
	[self.viewModel chartRequestWithCompletion:^(BOOL success, NSString *jsStr, NSString *message) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
		if (success) {
			self.headerView.jsStr = jsStr;
        } else {
            [self.view makeToast:message duration:2 position:CSToastPositionCenter];
        }
		[self.tableView reloadData];
	} failure:^{
		[MBProgressHUD hideHUDForView:self.view animated:YES];
		[self.tableView reloadData];
        [self.view makeToast:@"请求失败, 请重试" duration:2 position:CSToastPositionCenter];
	}];
}

- (void)listRequest {
	if (self.viewModel.currentPage == 0) {
		[self.tableView.mj_footer endRefreshing];
		return;
	}
	[self.viewModel listRequestWithCompletion:^(BOOL success, NSString *message) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
		[self.tableView.mj_footer endRefreshing];
		[self.tableView reloadData];
        if (success) {

        } else {
            [self.view makeToast:message duration:2 position:CSToastPositionCenter];
        }
	} failure:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
		[self.tableView.mj_footer endRefreshing];
		[self.tableView reloadData];
        [self.view makeToast:@"请求失败, 请重试" duration:2 position:CSToastPositionCenter];
	}];
}

@end
