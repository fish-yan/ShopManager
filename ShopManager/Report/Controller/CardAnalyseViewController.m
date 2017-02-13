//
//  CardAnalyseViewController.m
//  ShopManager
//
//  Created by 张旭 on 20/11/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import "CardAnalyseViewController.h"
#import "CardAnalyseTableViewCell.h"
#import "StoreBoardHeaderView.h"
#import "CardAnalyseFilterView.h"
#import "StoreList.h"
#import "CardAnalyseDetailViewController.h"

#define itemCell @"itemCell"

@interface CardAnalyseViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) StoreBoardHeaderView *headerView;

@property (strong, nonatomic) CardAnalyseFilterView *filterView;

@end

@implementation CardAnalyseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.tableView.tableHeaderView = self.headerView;
	[self.tableView registerNib:[UINib nibWithNibName:@"CardAnalyseTableViewCell" bundle:nil] forCellReuseIdentifier:itemCell];
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
            [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
			[weakSelf listRequest];
		};
	}
	return _headerView;
}

- (CardAnalyseFilterView *)filterView {
	if (_filterView == nil) {
		_filterView = [[CardAnalyseFilterView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64)];
		__weak typeof(self) weakSelf = self;
		_filterView.confirmBlock = ^(NSString *startDate, NSString *endDate, NSInteger storeIndex, BOOL both) {
			weakSelf.viewModel.startDate = startDate;
			weakSelf.viewModel.endDate = endDate;
			if (storeIndex != -1) {
				weakSelf.viewModel.storeName = [StoreList sharedList].dataSource[storeIndex].name;
				weakSelf.viewModel.storeId = [StoreList sharedList].dataSource[storeIndex].idStr;
			}
			weakSelf.headerView.nameL.text = weakSelf.viewModel.storeName;
			weakSelf.headerView.timeL.text = weakSelf.viewModel.showTime;
			weakSelf.viewModel.isSelected = both;
            [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
			[weakSelf chartRequest];
		};
		[self.view addSubview:_filterView];
	}
	return _filterView;
}

- (CardAnalyseVM *)viewModel {
	if (_viewModel == nil) {
		_viewModel = [[CardAnalyseVM alloc] init];
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
	CardAnalyseDetailViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CardAnalyseDetailVC"];
	CardAnalyseItemVM *item = self.viewModel.listDataSource[indexPath.row];
	vc.viewModel.storeName = item.storeName;
	vc.viewModel.storeId = item.storeId;
	if (self.viewModel.selectedDate == nil || [self.viewModel.selectedDate isEqualToString:@""]) {
		vc.viewModel.startDate = self.viewModel.startDate;
		vc.viewModel.endDate = self.viewModel.endDate;
	} else {
		vc.viewModel.startDate = self.viewModel.selectedDate;
		vc.viewModel.endDate = self.viewModel.selectedDate;
	}
	vc.viewModel.selectedDate = self.viewModel.selectedDate;
	[self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 129;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 36;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 36)];
	headerView.backgroundColor = UIColorFromRGB(0xf1f1f1);
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, kScreenWidth-15, 36)];
	label.font = [UIFont systemFontOfSize:14];
	label.textColor = UIColorFromRGB(0xa4a4a4);
	label.text = @"门店分析";
	[headerView addSubview:label];
	return headerView;
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
	CardAnalyseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:itemCell];
	CardAnalyseItemVM *item = self.viewModel.listDataSource[indexPath.row];
	cell.nameL.text = item.storeName;
	cell.numL.text = [NSString stringWithFormat:@"%zd", item.count];
	cell.moneyL.text = [NSString stringWithFormat:@"%.2f", item.money];
	cell.costL.text = [NSString stringWithFormat:@"%.2f", item.cost];
	return cell;
}

#pragma mark - Request

- (void)chartRequest {
	[self.viewModel chartRequestWithCompletion:^(BOOL success, NSString *jsStr, NSString *message) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
		[self.tableView reloadData];
		if (success) {
			self.headerView.jsStr = jsStr;
        } else {
            [self.view makeToast:message duration:2 position:CSToastPositionCenter];
        }
	} failure:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
		[self.tableView reloadData];
        [self.view makeToast:@"请求失败, 请重试" duration:2 position:CSToastPositionCenter];
	}];
}

- (void)listRequest {
	[self.viewModel listRequestWithCompletion:^(BOOL success, NSString *message) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
		[self.tableView reloadData];
        if (success) {

        } else  {
            [self.view makeToast:message duration:2 position:CSToastPositionCenter];
        }
	} failure:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
		[self.tableView reloadData];
        [self.view makeToast:@"请求失败, 请重试" duration:2 position:CSToastPositionCenter];
	}];
}

@end
