//
//  ClientLevelViewController.m
//  ShopManager
//
//  Created by 张旭 on 19/10/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import "ClientLevelViewController.h"
#import "ClientLevelTableViewCell.h"
#import "ClientBoardHeaderView.h"
#import "StoreSelectView.h"
#import "ClientLevelDetailTableViewCell.h"

#define clientCell @"clientCell"
#define detailCell @"detailCell"

@interface ClientLevelViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) ClientBoardHeaderView *headerView;

@property (strong, nonatomic) StoreSelectView *selectView;

@end

@implementation ClientLevelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.tableView.contentInset = UIEdgeInsetsMake(301, 0, 0, 0);
	[self.tableView addSubview:self.headerView];
	[self.tableView registerNib:[UINib nibWithNibName:@"ClientLevelTableViewCell" bundle:nil] forCellReuseIdentifier:clientCell];
	[self.tableView registerNib:[UINib nibWithNibName:@"ClientLevelDetailTableViewCell" bundle:nil] forCellReuseIdentifier:detailCell];
	[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self listRequest];
    }];
	[self chartRequest];
}

- (ClientBoardHeaderView *)headerView {
	if (_headerView == nil) {
		_headerView = [[ClientBoardHeaderView alloc] initWithFrame:CGRectMake(0, -301, kScreenWidth, 300)];
		_headerView.nameL.text = self.viewModel.storeName;
		__weak typeof(self) weakSelf = self;
		_headerView.chartBlock = ^(NSInteger index) {
			weakSelf.viewModel.currentPage = 1;
			weakSelf.viewModel.selectedStar = weakSelf.viewModel.chartDataSource[index].star;
			[weakSelf listRequest];
		};
	}
	return _headerView;
}

- (StoreSelectView *)selectView {
	if (_selectView == nil) {
		_selectView = [[StoreSelectView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64)];
		[self.view addSubview:_selectView];
		__weak typeof(self) weakSelf = self;
		_selectView.confirmBlock = ^(NSString *name, NSString *idStr){
			weakSelf.viewModel.storeName = name;
			weakSelf.viewModel.storeId = idStr;
			weakSelf.headerView.nameL.text = weakSelf.viewModel.storeName;
			[MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
			[weakSelf chartRequest];
		};
	}
	return _selectView;
}

- (ClientLevelVM *)viewModel {
	if (_viewModel == nil) {
		_viewModel = [[ClientLevelVM alloc] init];
	}
	return _viewModel;
}

- (IBAction)menuButtonDidTouch:(id)sender {
	[self.selectView show];
}

- (IBAction)backButtonDidTouch:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 0) {
		return 123;
	} else if (indexPath.row == 1) {
		return 129;
	}
	return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	UIView *view = [[UIView alloc] init];
	view.backgroundColor = [UIColor clearColor];
	return view;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if (self.viewModel.listDataSource == nil) {
		return 0;
	}
	return self.viewModel.listDataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	ClientLevelItemVM *item = self.viewModel.listDataSource[section];
	if (item.showDetail) {
		return 2;
	}
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 0) {
		ClientLevelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:clientCell];
		ClientLevelItemVM *item = self.viewModel.listDataSource[indexPath.section];
		cell.nameL.text = item.name;
		cell.carNumL.text = item.carNum;
		cell.phoneL.text = item.phone;
		cell.adoptL.text = item.adopter;
		cell.star = self.viewModel.selectedStar;
		if (item.showDetail) {
			[cell.detailButton setImage:[UIImage imageNamed:@"zhankai"] forState:UIControlStateNormal];
		} else {
			[cell.detailButton setImage:[UIImage imageNamed:@"shouqi"] forState:UIControlStateNormal];
		}
		cell.clickBlock = ^{
			item.showDetail = !item.showDetail;
			[tableView reloadData];
		};
		return cell;
	} else if (indexPath.row == 1) {
		ClientLevelDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:detailCell];
		ClientLevelItemVM *item = self.viewModel.listDataSource[indexPath.section];
		cell.xcStar = item.xc;
		cell.mrStar = item.mr;
		cell.jxStar = item.jx;
		cell.bxStar = item.bx;
		cell.ltStar = item.lt;
		cell.bpStar = item.bp;
		cell.ypStar = item.yp;
		return cell;
	}
	return nil;

}

#pragma mark - Request

- (void)listRequest {
	[self.viewModel listRequestWithComplete:^(BOOL success, NSString *message) {
		[self.tableView.mj_header endRefreshing];
		[self.tableView.mj_footer endRefreshing];
		[self.tableView reloadData];
		if (success) {

		} else {
			[self.view makeToast:message duration:2 position:CSToastPositionCenter];
		}
	} failure:^{
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
	}];
}

@end
