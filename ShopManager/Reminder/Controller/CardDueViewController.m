//
//  CardDueViewController.m
//  ShopManager
//
//  Created by 张旭 on 19/10/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import "CardDueViewController.h"
#import "CardDueTableViewCell.h"
#import "StoreSelectView.h"

#define cardCell @"cardCell"

@interface CardDueViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *storeL;

@property (strong, nonatomic) StoreSelectView *storeSelectView;

@end

@implementation CardDueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.storeL.text = self.viewModel.storeName;
	[self.tableView registerNib:[UINib nibWithNibName:@"CardDueTableViewCell" bundle:nil] forCellReuseIdentifier:cardCell];
	self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
		self.viewModel.currentPage = 1;
		[self request];
	}];
	self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
		[self request];
	}];
	[self.tableView.mj_header beginRefreshing];
}

- (StoreSelectView *)storeSelectView {
	if (_storeSelectView == nil) {
		_storeSelectView = [[StoreSelectView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64)];
		[self.view addSubview:_storeSelectView];
		__weak typeof(self) weakSelf = self;
		_storeSelectView.confirmBlock = ^(NSString *name, NSString *idStr){
			weakSelf.viewModel.storeName = name;
			weakSelf.viewModel.storeId = idStr;
			weakSelf.storeL.text = weakSelf.viewModel.storeName;
			[weakSelf.tableView.mj_header beginRefreshing];
		};
	}
	return _storeSelectView;
}

- (CardDueVM *)viewModel {
	if (_viewModel == nil) {
		_viewModel = [[CardDueVM alloc] init];
	}
	return _viewModel;
}

- (IBAction)menuButtonDidTouch:(id)sender {
	[self.storeSelectView show];
}

- (IBAction)backButtonDidTouch:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 133;
}

#pragma mark - UITableViewDataSource;

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
	CardDueTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cardCell];
	CardDueItemVM *item = self.viewModel.dataSource[indexPath.row];
	cell.numL.text = item.carNum;
	cell.nameL.text = item.name;
	cell.phoneL.text = item.phone;
	cell.startL.text = item.startTime;
	cell.endL.text = item.dueTime;
	cell.storeL.text = item.storeName;
	cell.cardNameL.text = item.cardName;
	return cell;
}

#pragma mark - Request

- (void)request {
	[self.viewModel requestWithComplete:^(BOOL success, NSString *message) {
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
