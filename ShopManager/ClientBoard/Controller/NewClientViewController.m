//
//  NewClientViewController.m
//  ShopManager
//
//  Created by 张旭 on 19/10/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import "NewClientViewController.h"
#import "StoreBoardHeaderView.h"
#import "CBNewClientTableViewCell.h"
#import "StoreSelectView.h"

#define clientCell @"clientCell"

@interface NewClientViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *storeL;

@property (strong, nonatomic) StoreSelectView *selectView;

@end

@implementation NewClientViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.storeL.text = self.viewModel.storeName;
	[self.tableView registerNib:[UINib nibWithNibName:@"CBNewClientTableViewCell" bundle:nil] forCellReuseIdentifier:clientCell];
	self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
		self.viewModel.currentPage = 1;
		[self listRequest];
	}];
	self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
		[self listRequest];
	}];
	[self.tableView.mj_header beginRefreshing];
}

- (StoreSelectView *)selectView {
	if (_selectView == nil) {
		_selectView = [[StoreSelectView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64)];
		__weak typeof(self) weakSelf = self;
		_selectView.confirmBlock = ^(NSString *name, NSString *idStr){
			weakSelf.viewModel.storeName = name;
			weakSelf.viewModel.storeId = idStr;
			weakSelf.storeL.text = weakSelf.viewModel.storeName;
			[weakSelf.tableView.mj_header beginRefreshing];
		};
		[self.view addSubview:_selectView];
	}
	return _selectView;
}

- (NewClientVM *)viewModel {
	if (_viewModel == nil) {
		_viewModel = [[NewClientVM alloc] init];
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
	return 108;
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
	CBNewClientTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:clientCell];
	NewClientItemVM *item = self.viewModel.dataSource[indexPath.row];
	cell.nameL.text = item.name;
	cell.carNumL.text = item.carNum;
	cell.phoneL.text = item.phone;
	cell.timeL.text = item.time;
	cell.storeNameL.text = item.storeName;
	return cell;
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

@end
