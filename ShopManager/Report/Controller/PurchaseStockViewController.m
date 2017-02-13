//
//  PurchaseStockViewController.m
//  ShopManager
//
//  Created by 张旭 on 07/11/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import "PurchaseStockViewController.h"
#import "PurchaseStockCollectionViewCell.h"
#import "StoreBoardHeaderView.h"
#import "PurchaseViewController.h"
#import "StockViewController.h"
#import "DueAnalyseViewController.h"

#import "StoreBoardFilterView.h"
#import "StoreList.h"


#define itemCell @"itemCell"

@interface PurchaseStockViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) StoreBoardHeaderView *headerView;

@property (strong, nonatomic) StoreBoardFilterView *filterView;

@property (strong, nonatomic) NSArray<NSString *> *titleArray;

@end

@implementation PurchaseStockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = self.viewModel.storeName;
	self.titleArray = @[@"采购金额", @"累积采购金额", @"库存金额", @"应付账款金额"];
	self.collectionView.contentInset = UIEdgeInsetsMake(301, 0, 0, 0);
	[self.collectionView addSubview:self.headerView];
	[self.collectionView registerNib:[UINib nibWithNibName:@"PurchaseStockCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:itemCell];
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
			weakSelf.viewModel.purchaseCount = weakSelf.viewModel.chartDataSource[index].purchaseCount;
			weakSelf.viewModel.sumPurchaseCount = weakSelf.viewModel.chartDataSource[index].sumPurchaseCount;
			weakSelf.viewModel.stockCount = weakSelf.viewModel.chartDataSource[index].stockCount;
			weakSelf.viewModel.dueCount = weakSelf.viewModel.chartDataSource[index].dueCount;
			[weakSelf.collectionView reloadData];
		};
	}
	return _headerView;
}

- (StoreBoardFilterView *)filterView {
	if (_filterView == nil) {
		_filterView = [[StoreBoardFilterView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64)];
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

- (PurchaseStockVM *)viewModel {
	if (_viewModel == nil) {
		_viewModel = [[PurchaseStockVM alloc] init];
	}
	return _viewModel;
}

- (IBAction)filterButtonDidTouch:(id)sender {
	[self.filterView show];
}

- (IBAction)backButtonDidTouch:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	[collectionView deselectItemAtIndexPath:indexPath animated:YES];
	if (indexPath.row == 0) {
		PurchaseViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"PurchaseVC"];
		vc.viewModel.storeName = self.viewModel.storeName;
		vc.viewModel.storeId = self.viewModel.storeId;
		vc.viewModel.type = 0;
		if (self.viewModel.selectedDate == nil || [self.viewModel.selectedDate isEqualToString:@""]) {
			vc.viewModel.startDate = self.viewModel.startDate;
			vc.viewModel.endDate = self.viewModel.endDate;
		} else {
			vc.viewModel.startDate = self.viewModel.selectedDate;
			vc.viewModel.endDate = self.viewModel.selectedDate;
		}
		vc.title = @"采购分析";
		[self.navigationController pushViewController:vc animated:YES];
	} else if (indexPath.row == 1) {
		PurchaseViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"PurchaseVC"];
		vc.viewModel.storeName = self.viewModel.storeName;
		vc.viewModel.storeId = self.viewModel.storeId;
		vc.viewModel.type = 1;
		vc.title = @"累计采购分析";
		if (self.viewModel.selectedDate == nil || [self.viewModel.selectedDate isEqualToString:@""]) {
			vc.viewModel.startDate = self.viewModel.startDate;
			vc.viewModel.endDate = self.viewModel.endDate;
		} else {
			vc.viewModel.startDate = self.viewModel.selectedDate;
			vc.viewModel.endDate = self.viewModel.selectedDate;
		}
		[self.navigationController pushViewController:vc animated:YES];
	} else if (indexPath.row == 2) {
		StockViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"StockVC"];
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
	} else if (indexPath.row == 3) {
		DueAnalyseViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"DueAnalyseVC"];
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
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return self.titleArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	PurchaseStockCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:itemCell forIndexPath:indexPath];
	cell.titleL.text = self.titleArray[indexPath.row];
	
	if (indexPath.row == 0) {
		cell.moneyL.text = [NSString stringWithFormat:@"%.2f", self.viewModel.purchaseCount];
	} else if (indexPath.row == 1) {
		cell.moneyL.text = [NSString stringWithFormat:@"%.2f", self.viewModel.sumPurchaseCount];
	} else if (indexPath.row == 2) {
		cell.moneyL.text = [NSString stringWithFormat:@"%.2f", self.viewModel.stockCount];
	} else if (indexPath.row == 3) {
		cell.moneyL.text = [NSString stringWithFormat:@"%.2f", self.viewModel.dueCount];
	}
	return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	CGFloat width = (NSInteger)((kScreenWidth-1)/2);
	CGFloat height = 176;
	return CGSizeMake(width, height);
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
		[self.collectionView reloadData];
	} failure:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
		[self.collectionView reloadData];
        [self.view makeToast:@"请求失败, 请重试" duration:2 position:CSToastPositionCenter];
	}];
}

@end
