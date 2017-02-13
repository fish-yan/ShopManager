//
//  WashCarViewController.m
//  ShopManager
//
//  Created by 张旭 on 19/10/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import "WashCarViewController.h"
#import "StoreBoardHeaderView.h"
#import "SBCarCountTableViewCell.h"
#import "SBWashCarItemTableViewCell.h"
#import "StoreBoardFilterView.h"
#import "StoreList.h"

#define carCell @"carCell"
#define itemCell @"itemCell"

@interface WashCarViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) StoreBoardHeaderView *headerView;

@property (strong, nonatomic) StoreBoardFilterView *filterView;

@end

@implementation WashCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.tableView.contentInset = UIEdgeInsetsMake(301, 0, 0, 0);
	[self.tableView addSubview:self.headerView];
	[self.tableView registerNib:[UINib nibWithNibName:@"SBCarCountTableViewCell" bundle:nil] forCellReuseIdentifier:carCell];
	[self.tableView registerNib:[UINib nibWithNibName:@"SBWashCarItemTableViewCell" bundle:nil] forCellReuseIdentifier:itemCell];
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
			weakSelf.viewModel.currentPage = 1;
			weakSelf.viewModel.selectedDate = weakSelf.viewModel.chartDataSource[index].date;
			weakSelf.viewModel.num = [NSString stringWithFormat:@"%zd", weakSelf.viewModel.chartDataSource[index].count];
			[weakSelf.tableView reloadData];
			[MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
			[weakSelf listRequest];
		};
	}
	return _headerView;
}

- (StoreBoardFilterView *)filterView {
	if (_filterView == nil) {
		_filterView = [[StoreBoardFilterView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64)];
		_filterView.startDateText = self.viewModel.startDate;
		_filterView.endDateText = self.viewModel.endDate;
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

- (WashCarVM *)viewModel {
	if (_viewModel == nil) {
		_viewModel = [[WashCarVM alloc] init];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 0) {
		return 44;
	} else if (indexPath.row <= self.viewModel.listDataSource.count) {
		return 71;
	}
	return 0;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (self.viewModel.listDataSource == nil) {
		return 1;
	}
	return self.viewModel.listDataSource.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 0) {
		SBCarCountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:carCell];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.titleL.text = @"洗车台次";
		cell.countL.text = self.viewModel.num;
		return cell;
	} else if (indexPath.row <= self.viewModel.listDataSource.count) {
		SBWashCarItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:itemCell];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		WashCarListItemVM *item = self.viewModel.listDataSource[indexPath.row-1];
		cell.nameL.text = item.name;
		cell.carNumL.text = item.carNum;
		cell.phoneL.text = item.phone;
		return cell;
	}
	return nil;
}

#pragma mark - Request

- (void)listRequest {
	[self.viewModel listRequestWithComplete:^(BOOL success, NSString *message) {
		[MBProgressHUD hideHUDForView:self.view animated:YES];
		[self.tableView.mj_header endRefreshing];
		[self.tableView.mj_footer endRefreshing];
		[self.tableView reloadData];
		if (success) {

		} else {
			[self.view makeToast:message duration:2 position:CSToastPositionCenter];
		}
	} failure:^{
		[MBProgressHUD hideHUDForView:self.view animated:YES];
		[self.tableView.mj_header endRefreshing];
		[self.tableView.mj_footer endRefreshing];
		[self.view makeToast:@"请求失败, 请重试" duration:2 position:CSToastPositionCenter];
	}];
}

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
