//
//  WashCarAnalyseViewController.m
//  ShopManager
//
//  Created by 张旭 on 22/11/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import "WashCarAnalyseViewController.h"
#import "WashCarAnalyseTableViewCell.h"
#import "CardAnalyseHeaderView.h"
#import "StoreBoardFilterView.h"
#import "StoreList.h"

#define itemCell @"itemCell"

@interface WashCarAnalyseViewController ()<UITabBarDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) CardAnalyseHeaderView *headerView;

@property (strong, nonatomic) StoreBoardFilterView *filterView;

@end

@implementation WashCarAnalyseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.tableView.contentInset = UIEdgeInsetsMake(301, 0, 0, 0);
	[self.tableView addSubview:self.headerView];
	[self.tableView registerNib:[UINib nibWithNibName:@"WashCarAnalyseTableViewCell" bundle:nil] forCellReuseIdentifier:itemCell];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
	[self listRequest];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[IQKeyboardManager sharedManager].enableAutoToolbar = YES;
}

- (CardAnalyseHeaderView *)headerView {
	if (_headerView == nil) {
		_headerView = [[CardAnalyseHeaderView alloc] initWithFrame:CGRectMake(0, -301, kScreenWidth, 300)];
		_headerView.nameL.text = self.viewModel.storeName;
		_headerView.timeL.text = self.viewModel.showTime;
		_headerView.thirdImage.hidden = YES;
		_headerView.thirdTitleL.hidden = YES;
		_headerView.profitL.hidden = YES;
		_headerView.titleL.text = @"洗车来源分析";
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
			[weakSelf listRequest];
		};
		[self.view addSubview:_filterView];
	}
	return _filterView;
}

- (WashCarAnalyseVM *)viewModel {
	if (_viewModel == nil) {
		_viewModel = [[WashCarAnalyseVM alloc] init];
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
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 100;
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
	WashCarAnalyseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:itemCell];
	WashCarAnalyseItemVM *item = self.viewModel.listDataSource[indexPath.row];
	cell.sourceL.text = item.source;
	cell.moneyL.text = [NSString stringWithFormat:@"%.2f", item.money];
	cell.countL.text = [NSString stringWithFormat:@"%zd", item.count];
	return cell;
}

#pragma mark - Request

- (void)listRequest {
	[self.viewModel listRequestWithCompletion:^(BOOL sucess, NSString *jsStr, NSString *message) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
		[self.tableView reloadData];
		if (sucess) {
			self.headerView.jsStr = jsStr;
			self.headerView.moneyL.text = [NSString stringWithFormat:@"%.2f", self.viewModel.totalMoney];
			self.headerView.costL.text = [NSString stringWithFormat:@"%.2f", self.viewModel.totalCount];
		} else {
			self.headerView.moneyL.text = @"-";
			self.headerView.costL.text = @"-";
            [self.view makeToast:message duration:2 position:CSToastPositionCenter];
		}
	} failure:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
		[self.tableView reloadData];
        [self.view makeToast:@"请求失败, 请重试" duration:2 position:CSToastPositionCenter];
	}];
}

@end
