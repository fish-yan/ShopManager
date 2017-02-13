//
//  OnBoardDetailViewController.m
//  ShopManager
//
//  Created by 张旭 on 03/11/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import "OnBoardDetailViewController.h"
#import "SBWashCarItemTableViewCell.h"

#define itemCell @"itemCell"

@interface OnBoardDetailViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation OnBoardDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	[self.tableView registerNib:[UINib nibWithNibName:@"SBWashCarItemTableViewCell" bundle:nil] forCellReuseIdentifier:itemCell];
	self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
		self.viewModel.currentPage = 1;
		[self request];
	}];
	if ([self.viewModel.type isEqualToString:@"xc"]) {
		self.title = @"洗车台次";
	} else if ([self.viewModel.type isEqualToString:@"tmcj"]) {
		self.title = @"透明车间台次";
	} else if ([self.viewModel.type isEqualToString:@"qt"]) {
		self.title = @"其他台次";
	}
	self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
		[self request];
	}];
	[self.tableView.mj_header beginRefreshing];
}

- (OnBoardDetailVM *)viewModel {
	if (_viewModel == nil) {
		_viewModel = [[OnBoardDetailVM alloc] init];
	}
	return _viewModel;
}

- (IBAction)backButtonDidTouch:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 71;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (self.viewModel.dataSource == nil) {
		return 0;
	}
	return self.viewModel.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	SBWashCarItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:itemCell];
	OnBoardDetailItemVM *item = self.viewModel.dataSource[indexPath.row];
	cell.nameL.text = item.name;
	cell.carNumL.text = item.carNum;
	cell.phoneL.text = item.phone;
	return cell;
}

#pragma mark - Request

- (void)request {
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

@end
