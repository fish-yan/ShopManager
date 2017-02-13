//
//  ProfitAnalyseViewController.m
//  ShopManager
//
//  Created by 张旭 on 20/11/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import "ProfitAnalyseViewController.h"
#import "ProfitAnalyseTableViewCell.h"
#import "StoreBoardHeaderView.h"
#import "SaleAnalyseFilterView.h"
#import "StoreList.h"
#import "ProfitAnalyseDetailViewController.h"

#define itemCell @"itemCell"

@interface ProfitAnalyseViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) StoreBoardHeaderView *headerView;

@property (strong, nonatomic) SaleAnalyseFilterView *filterView;

@property (strong, nonatomic) NSArray<NSString *> *titleArray;

@end

@implementation ProfitAnalyseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.titleArray = @[@"商品毛利", @"项目毛利", @"配件毛利", @"卡业务毛利"];
	self.tableView.tableHeaderView = self.headerView;
	[self.tableView registerNib:[UINib nibWithNibName:@"ProfitAnalyseTableViewCell" bundle:nil] forCellReuseIdentifier:itemCell];
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
			weakSelf.viewModel.totalMoney = weakSelf.viewModel.chartDataSource[index].money;
			weakSelf.viewModel.selectedDate = weakSelf.viewModel.chartDataSource[index].date;
            [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
			[weakSelf firstRequest];
			[weakSelf secondRequest];
		};
	}
	return _headerView;
}

- (SaleAnalyseFilterView *)filterView {
	if (_filterView == nil) {
		_filterView = [[SaleAnalyseFilterView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64)];
		__weak typeof(self) weakSelf = self;
		_filterView.confirmBlock = ^(NSString *startDate, NSString *endDate, NSInteger storeIndex, NSInteger statisticType, BOOL both) {
			weakSelf.viewModel.startDate = startDate;
			weakSelf.viewModel.endDate = endDate;
			if (storeIndex != -1) {
				weakSelf.viewModel.storeName = [StoreList sharedList].dataSource[storeIndex].name;
				weakSelf.viewModel.storeId = [StoreList sharedList].dataSource[storeIndex].idStr;
			}
			weakSelf.headerView.nameL.text = weakSelf.viewModel.storeName;
			weakSelf.headerView.timeL.text = weakSelf.viewModel.showTime;
			weakSelf.viewModel.type = statisticType;
			weakSelf.viewModel.isSelected = both;
            [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
			[weakSelf chartRequest];
		};
		[self.view addSubview:_filterView];
	}
	return _filterView;
}

- (ProfitAnalyseVM *)viewModel {
	if (_viewModel == nil) {
		_viewModel = [[ProfitAnalyseVM alloc] init];
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
	if (indexPath.section == 0) {
		if (indexPath.row < 3) {
			ProfitAnalyseDetailViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfitAnalyseDetailVC"];
			vc.viewModel.detailType = indexPath.row;
			vc.viewModel.type = self.viewModel.type;
			vc.viewModel.storeName = self.viewModel.storeName;
			vc.viewModel.storeId = self.viewModel.storeId;
			if (self.viewModel.selectedDate == nil || [self.viewModel.selectedDate isEqualToString:@""]) {
				vc.viewModel.startDate = self.viewModel.startDate;
				vc.viewModel.endDate = self.viewModel.endDate;
			} else {
				vc.viewModel.startDate = self.viewModel.selectedDate;
				vc.viewModel.endDate = self.viewModel.selectedDate;
			}
			[self.navigationController pushViewController:vc animated:YES];
		}
	} else if (indexPath.section == 1) {
		ProfitAnalyseItemVM *item = self.viewModel.listDataSource[indexPath.row];
		if ([item.name isEqualToString:@"卡销售"]) {
			return;
		}
		ProfitAnalyseDetailViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfitAnalyseDetailVC"];
		vc.viewModel.detailType = 3;
		vc.viewModel.type = self.viewModel.type;
		vc.viewModel.storeName = self.viewModel.storeName;
		vc.viewModel.storeId = self.viewModel.storeId;
		if (self.viewModel.selectedDate == nil || [self.viewModel.selectedDate isEqualToString:@""]) {
			vc.viewModel.startDate = self.viewModel.startDate;
			vc.viewModel.endDate = self.viewModel.endDate;
		} else {
			vc.viewModel.startDate = self.viewModel.selectedDate;
			vc.viewModel.endDate = self.viewModel.selectedDate;
		}
		vc.viewModel.keyWord = self.viewModel.listDataSource[indexPath.row].name;
		[self.navigationController pushViewController:vc animated:YES];
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 100;
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
	if (section == 0) {
		label.text = @"商品/项目/配件毛利分析";
	} else if (section == 1) {
		if (self.viewModel.type == 0) {
			label.text = @"业务归属分析";
		} else {
			label.text = @"部门销售分析";
		}
	}
	[headerView addSubview:label];
	return headerView;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0) {
		return 3;
	} else if (section == 1) {
		if (self.viewModel.listDataSource == nil) {
			return 0;
		}
		return self.viewModel.listDataSource.count;
	}
	return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	ProfitAnalyseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:itemCell];
	if (indexPath.section == 0) {
		cell.titleL.text = self.titleArray[indexPath.row];
		if (indexPath.row == 0) {
			cell.moneyL.text = [NSString stringWithFormat:@"%.2f", self.viewModel.goodsMoney];
			cell.percentL.text = [NSString stringWithFormat:@"%.2f%%", self.viewModel.goodsRatio];
			cell.ratioL.text = [NSString stringWithFormat:@"%.2f%%", self.viewModel.goodsProfitRatio];
		} else if (indexPath.row == 1) {
			cell.moneyL.text = [NSString stringWithFormat:@"%.2f", self.viewModel.projectMoney];
			cell.percentL.text = [NSString stringWithFormat:@"%.2f%%", self.viewModel.projectRatio];
			cell.ratioL.text = [NSString stringWithFormat:@"%.2f%%", self.viewModel.projectProfitRatio];
		} else if (indexPath.row == 2) {
			cell.moneyL.text = [NSString stringWithFormat:@"%.2f", self.viewModel.productMoney];
			cell.percentL.text = [NSString stringWithFormat:@"%.2f%%", self.viewModel.productRatio];
			cell.ratioL.text = [NSString stringWithFormat:@"%.2f%%", self.viewModel.productProfitRatio];
		} else if (indexPath.row == 3) {
			cell.moneyL.text = [NSString stringWithFormat:@"%.2f", self.viewModel.cardMoney];
			cell.percentL.text = [NSString stringWithFormat:@"%.2f%%", self.viewModel.cardRatio];
			cell.ratioL.text = [NSString stringWithFormat:@"%.2f%%", self.viewModel.cardProfitRatio];
		}
	} else if (indexPath.section ==1) {
		ProfitAnalyseItemVM *item = self.viewModel.listDataSource[indexPath.row];
		cell.titleL.text = item.name;
		cell.moneyL.text = [NSString stringWithFormat:@"%.2f", item.count];
		cell.percentL.text = [NSString stringWithFormat:@"%.2f%%", item.percent];
		cell.ratioL.text = [NSString stringWithFormat:@"%.2f%%", item.profitRatio];
	}
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

- (void)firstRequest {
	[self.viewModel firstRequestWithCompletion:^(BOOL success, NSString *message) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
		[self.tableView reloadData];
        if (success) {

        } else {
            [self.view makeToast:message duration:2 position:CSToastPositionCenter];
        }
	} failure:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
		[self.tableView reloadData];
        [self.view makeToast:@"请求失败, 请重试" duration:2 position:CSToastPositionCenter];
	}];
}

- (void)secondRequest {
	[self.viewModel secondRequestWithCompletion:^(BOOL success, NSString *message) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
		[self.tableView reloadData];
        if (success) {

        } else {
            [self.view makeToast:message duration:2 position:CSToastPositionCenter];
        }
	} failure:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
		[self.tableView reloadData];
        [self.view makeToast:@"请求失败, 请重试" duration:2 position:CSToastPositionCenter];
	}];
}

@end
