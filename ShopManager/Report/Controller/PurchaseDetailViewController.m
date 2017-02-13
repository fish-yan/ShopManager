//
//  PurchaseDetailViewController.m
//  ShopManager
//
//  Created by 张旭 on 07/11/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import "PurchaseDetailViewController.h"
#import "PurchaseDetailTableViewCell.h"
#import "PurchaseDetailFilterView.h"

#define detailCell @"detailCell"

@interface PurchaseDetailViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) PurchaseDetailFilterView *filterView;

@end

@implementation PurchaseDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	[self.tableView registerNib:[UINib nibWithNibName:@"PurchaseDetailTableViewCell" bundle:nil] forCellReuseIdentifier:detailCell];
	self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
		self.viewModel.currentPage = 1;
		[self listRequest];
	}];
	self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
		[self listRequest];
	}];
	[self.tableView.mj_header beginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[IQKeyboardManager sharedManager].enableAutoToolbar = YES;
}

- (PurchaseDetailFilterView *)filterView {
	if (_filterView == nil) {
		_filterView = [[PurchaseDetailFilterView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64)];
		_filterView.startDateText = self.viewModel.startDate;
		_filterView.endDateText = self.viewModel.endDate;
		__weak typeof(self) weakSelf = self;
		_filterView.confirmBlock = ^(NSString *startDate, NSString *endDate, NSString *searchText, NSString *storage, NSString *settleType, NSString *orderType) {
			weakSelf.viewModel.startDate = startDate;
			weakSelf.viewModel.endDate = endDate;
			weakSelf.viewModel.currentPage = 1;
			weakSelf.viewModel.keyVal = searchText;
			weakSelf.viewModel.storageName = storage;
			weakSelf.viewModel.settleType = settleType;
			weakSelf.viewModel.orderType = orderType;
			[weakSelf.tableView.mj_header beginRefreshing];
		};
		[self.view addSubview:_filterView];
	}
	return _filterView;
}

- (PurchaseDetailVM *)viewModel {
	if (_viewModel == nil) {
		_viewModel = [[PurchaseDetailVM alloc] init];
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
	PurchaseDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:detailCell];
	PurchaseDetailItemVM *item = self.viewModel.listDataSource[indexPath.row];
	cell.nameL.text = item.name;
	cell.priceL.text = [NSString stringWithFormat:@"%.2f", item.price];
	cell.numL.text = [NSString stringWithFormat:@"%zd", item.num];
	cell.orderTypeL.text = item.orderType;
	cell.settleTypeL.text = item.settleType;
	cell.totalPriceL.text = [NSString stringWithFormat:@"%.2f", item.totalPrice];
	cell.timeL.text = item.time;
	return cell;
}

#pragma mark - Request

- (void)listRequest {
	[self.viewModel listRequestWithCompletion:^(BOOL success, NSString *message) {
		[self.tableView reloadData];
		[self.tableView.mj_header endRefreshing];
		[self.tableView.mj_footer endRefreshing];
        if (success) {

        } else {
            [self.view makeToast:message duration:2 position:CSToastPositionCenter];
        }
	} failure:^{
		[self.tableView reloadData];
		[self.tableView.mj_header endRefreshing];
		[self.tableView.mj_footer endRefreshing];
        [self.view makeToast:@"请求失败, 请重试" duration:2 position:CSToastPositionCenter];
	}];
}

@end
