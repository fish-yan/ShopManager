//
//  SaleAnalyseDetailViewController.m
//  ShopManager
//
//  Created by 张旭 on 09/11/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import "SaleAnalyseDetailViewController.h"
#import "SaleAnalyseTableViewCell.h"
#import "SaleAnalyseHeaderView.h"
#import "StoreBoardFilterView.h"
#import "StoreList.h"
#import "SaleAnalyseDetailFilterView.h"

#define itemCell @"itemCell"

@interface SaleAnalyseDetailViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) SaleAnalyseHeaderView *headerView;

@property (strong, nonatomic) StoreBoardFilterView *normalFilterView;
@property (strong, nonatomic) SaleAnalyseDetailFilterView *specialFilterView;

@end

@implementation SaleAnalyseDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	if (self.viewModel.detailType == 0) {
		self.title = @"商品销售分析";
	} else if (self.viewModel.detailType == 1) {
		self.title = @"项目销售分析";
	} else if (self.viewModel.detailType == 2) {
		self.title = @"配件销售分析";
	} else if (self.viewModel.detailType == 3) {
		self.title = @"业务归属销售分析";
	}
	self.tableView.tableHeaderView = self.headerView;
	[self.tableView registerNib:[UINib nibWithNibName:@"SaleAnalyseTableViewCell" bundle:nil] forCellReuseIdentifier:itemCell];
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

- (SaleAnalyseHeaderView *)headerView {
	if (_headerView == nil) {
		_headerView = [[SaleAnalyseHeaderView alloc] initWithFrame:CGRectMake(0, -301, kScreenWidth, 300)];
		_headerView.nameL.text = self.viewModel.storeName;
		_headerView.timeL.text = self.viewModel.showTime;
	}
	return _headerView;
}

- (StoreBoardFilterView *)normalFilterView {
	if (_normalFilterView == nil) {
		_normalFilterView = [[StoreBoardFilterView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64)];
		_normalFilterView.startDateText = self.viewModel.startDate;
		_normalFilterView.endDateText = self.viewModel.endDate;
		__weak typeof(self) weakSelf = self;
		_normalFilterView.confirmBlock = ^(NSString *startDate, NSString *endDate, NSInteger storeIndex) {
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
		[self.view addSubview:_normalFilterView];
	}
	return _normalFilterView;
}

- (SaleAnalyseDetailFilterView *)specialFilterView {
	if (_specialFilterView == nil) {
		_specialFilterView = [[SaleAnalyseDetailFilterView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64)];
		_specialFilterView.type = self.viewModel.type;
		_specialFilterView.startDateText = self.viewModel.startDate;
		_specialFilterView.endDateText = self.viewModel.endDate;
		__weak typeof(self) weakSelf = self;
		_specialFilterView.confirmBlock = ^(NSString *startDate, NSString *endDate, NSInteger storeIndex, NSInteger statisticType) {
			weakSelf.viewModel.startDate = startDate;
			weakSelf.viewModel.endDate = endDate;
			if (storeIndex != -1) {
				weakSelf.viewModel.storeName = [StoreList sharedList].dataSource[storeIndex].name;
				weakSelf.viewModel.storeId = [StoreList sharedList].dataSource[storeIndex].idStr;
			}
			weakSelf.headerView.nameL.text = weakSelf.viewModel.storeName;
			weakSelf.headerView.timeL.text = weakSelf.viewModel.showTime;
			weakSelf.viewModel.type = statisticType;
            [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
			[weakSelf listRequest];
		};
		[self.view addSubview:_specialFilterView];
	}
	return _specialFilterView;
}


- (SaleAnalyseDetailVM *)viewModel {
	if (_viewModel == nil) {
		_viewModel = [[SaleAnalyseDetailVM alloc] init];
	}
	return _viewModel;
}

- (IBAction)filterButtonDidTouch:(id)sender {
	if (self.viewModel.detailType == 3) {
		[self.normalFilterView show];
	} else {
		[self.specialFilterView show];
	}
}

- (IBAction)backButtonDidTouch:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 65;
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
	if (self.viewModel.detailType ==3) {
		label.text = @"商品/项目/配件销售分析";
	} else {
		if (self.viewModel.type == 0) {
			label.text = @"业务归属销售分析";
		} else if (self.viewModel.type == 1) {
			label.text = @"部门销售分析";
		}
	}
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
	SaleAnalyseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:itemCell];
	SaleAnalyseDetailItemVM *item = self.viewModel.listDataSource[indexPath.row];
	cell.titleL.text = item.name;
	cell.moneyL.text = [NSString stringWithFormat:@"%.2f", item.count];
	cell.percentL.text = [NSString stringWithFormat:@"%.2f%%", item.percent];
	return cell;
}

#pragma mark - Request

- (void)listRequest {
	if (self.viewModel.detailType == 3) {
		[self.viewModel listRequest2WithCompletion:^(BOOL success, NSString *jsStr, NSString *message) {
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
	} else {
		[self.viewModel listRequestWithCompletion:^(BOOL success, NSString *jsStr, NSString *message) {
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
}

@end
