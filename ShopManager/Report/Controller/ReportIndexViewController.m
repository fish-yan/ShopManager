//
//  ReportIndexViewController.m
//  ShopManager
//
//  Created by 张旭 on 07/11/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import "ReportIndexViewController.h"
#import "ReportIndexCollectionViewCell.h"
#import "PurchaseStockViewController.h"
#import "SaleAnalyseViewController.h"
#import "FrontReportViewController.h"
#import "ProfitAnalyseViewController.h"
#import "CardAnalyseViewController.h"
#import "CardSaleAnalyseViewController.h"
#import "WashCarAnalyseViewController.h"
#import "StoreList.h"

#define indexCell @"indexCell"

@interface ReportIndexViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) NSArray<NSString *> *titleArray;
@property (strong, nonatomic) NSArray<NSString *> *imageArray;

@end

@implementation ReportIndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.titleArray = @[@"采购及库存趋势图", @"前台营业日报表", @"销售分析", @"毛利分析", @"套餐卡分析", @"发行卡统计分析", @"洗车数量分析", @""];
	self.imageArray = @[@"icon_cgqs", @"icon_qtbb", @"icon_xsfx", @"icon_mlfx", @"icon_tckfx", @"icon_fxkfx", @"icon_xcfx", @""];
	[self.collectionView registerNib:[UINib nibWithNibName:@"ReportIndexCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:indexCell];
}

- (IBAction)backButtonDidTouch:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	[collectionView deselectItemAtIndexPath:indexPath animated:YES];
	if (indexPath.row == 0) {
		PurchaseStockViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"PSVC"];
		vc.viewModel.storeName = self.storeName;
		vc.viewModel.storeId = self.storeId;
		[self.navigationController pushViewController:vc animated:YES];
	} else if (indexPath.row == 1) {
		FrontReportViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"FrontReportVC"];
//		vc.viewModel.storeName = @"沧浪店";
//		vc.viewModel.storeId = @"4028862644f6e5610144f6f2b5490005";
		if ([self.storeId isEqualToString:@""]) {
			vc.viewModel.storeName = [StoreList sharedList].dataSource[1].name;
			vc.viewModel.storeId = [StoreList sharedList].dataSource[1].idStr;
		} else {
			vc.viewModel.storeName = self.storeName;
			vc.viewModel.storeId = self.storeId;
		}

		[self.navigationController pushViewController:vc animated:YES];
	} else if (indexPath.row == 2) {
		SaleAnalyseViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SaleAnalyseVC"];
		vc.viewModel.storeName = self.storeName;
		vc.viewModel.storeId = self.storeId;
		[self.navigationController pushViewController:vc animated:YES];
	} else if (indexPath.row == 3) {
		ProfitAnalyseViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfitAnalyseVC"];
		vc.viewModel.storeName = self.storeName;
		vc.viewModel.storeId = self.storeId;
		[self.navigationController pushViewController:vc animated:YES];
	} else if (indexPath.row == 4) {
		CardAnalyseViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CardAnalyseVC"];
		vc.viewModel.storeName = self.storeName;
		vc.viewModel.storeId = self.storeId;
		[self.navigationController pushViewController:vc animated:YES];
	} else if (indexPath.row == 5) {
		CardSaleAnalyseViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CardSaleAnalyseVC"];
		vc.viewModel.storeName = self.storeName;
		vc.viewModel.storeId = self.storeId;
		[self.navigationController pushViewController:vc animated:YES];
	} else if (indexPath.row == 6) {
		WashCarAnalyseViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"WashCarAnalyseVC"];
		vc.viewModel.storeName = self.storeName;
		vc.viewModel.storeId = self.storeId;
		[self.navigationController pushViewController:vc animated:YES];
	}
}

#pragma  mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return self.titleArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	ReportIndexCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:indexCell forIndexPath:indexPath];
	cell.titleL.text = self.titleArray[indexPath.row];
	cell.imageV.image = [UIImage imageNamed:self.imageArray[indexPath.row]];
	return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	CGFloat width = (NSInteger)((kScreenWidth-1)/2);
	CGFloat height = 149;
	return CGSizeMake(width, height);
}

@end
