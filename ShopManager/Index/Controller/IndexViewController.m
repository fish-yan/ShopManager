//
//  IndexViewController.m
//  ShopManager
//
//  Created by 张旭 on 18/10/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import "IndexViewController.h"
#import "IndexHeaderCollectionViewCell.h"
#import "IndexCountCollectionViewCell.h"
#import "IndexCountTendencyCollectionViewCell.h"
#import "IndexTendencyCollectionViewCell.h"
#import "IndexHeaderView.h"
#import "WashCarViewController.h"
#import "OnBoardCarViewController.h"
#import "SectorConversionViewController.h"
#import "UnSettleCarViewController.h"
#import "NewClientViewController.h"
#import "ClientLevelViewController.h"
#import "ReceiveClientViewController.h"
#import "UserInfoViewController.h"

#import "CostListViewController.h"
#import "ReportIndexViewController.h"
#import "MicroCommunityViewController.h"
#import "UnFinishedViewController.h"

#import "BirthdayViewController.h"
#import "AppointMentViewController.h"
#import "ServiceDueViewController.h"

#import "IndexHeaderVM.h"
#import "IndexReminderVM.h"
#import "IndexClientBoardVM.h"
#import "IndexStoreBoardVM.h"
#import "CardDueViewController.h"

#import "StoreList.h"
#import "StoreSelectView.h"

#define headerCell @"headerCell"
#define countCell @"countCell"
#define countTendencyCell @"countTendencyCell"
#define tendencyCell @"tendencyCell"

@interface IndexViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) IndexHeaderView *headerView;

@property (strong, nonatomic) StoreSelectView *storeSelectView;

@property (strong, nonatomic) NSArray<NSString *> *countArray;
@property (strong, nonatomic) NSArray<NSString *> *countImageArray;
@property (strong, nonatomic) NSArray<NSString *> *firstTendencyArray;
@property (strong, nonatomic) NSArray<NSString *> *firstTendencyImageArray;
@property (strong, nonatomic) NSArray<NSString *> *secondTendencyArray;
@property (strong, nonatomic) NSArray<NSString *> *secondTendencyImageArray;

@property (strong, nonatomic) IndexHeaderVM *headerViewModel;
@property (strong, nonatomic) IndexReminderVM *reminderViewModel;
@property (strong, nonatomic) IndexClientBoardVM *clientBoardViewModel;
@property (strong, nonatomic) IndexStoreBoardVM *storeBoardViewModel;

@property (assign, nonatomic) NSInteger selectedIndex;

@end

@implementation IndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
	self.title = [User sharedUser].companyName;
//	[self.titleButton setTitle:[User sharedUser].companyName forState:UIControlStateNormal];
//	[self.titleButton sizeToFit];
	[self.collectionView registerNib:[UINib nibWithNibName:@"IndexHeaderCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:headerCell];
	[self.collectionView registerNib:[UINib nibWithNibName:@"IndexCountCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:countCell];
	[self.collectionView registerNib:[UINib nibWithNibName:@"IndexCountTendencyCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:countTendencyCell];
	[self.collectionView registerNib:[UINib nibWithNibName:@"IndexTendencyCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:tendencyCell];
	self.collectionView.contentInset = UIEdgeInsetsMake(237, 0, 0, 0);
	[self.collectionView addSubview:self.headerView];
	self.countArray = @[@"生日提醒", @"预约提醒", @"服务到期", @"卡到期"];
	self.countImageArray = @[@"icon_srtx", @"icon_yytx", @"icon_fwdq", @"icon_kdq"];
	self.firstTendencyArray = @[@"服务客户", @"新增客户", @"客户准流失", @"客户流失", @"星级客户", @"领养客户"];
	self.firstTendencyImageArray = @[@"icon_fwkh", @"icon_xzkh", @"icon_khzls", @"icon_khls", @"icon_xjkh", @"icon_khrl"];
	self.secondTendencyArray = @[@"洗车台数", @"进厂台数", @"部门转化率", @"未交车台数", @"应收账款额", @"均单毛利"];
	self.secondTendencyImageArray = @[@"icon_xcts", @"icon_jcts", @"icon_bmzhl", @"icon_wjcts", @"icon_yszke", @"icon_jdml"];
	self.selectedIndex = -1;
	//[[StoreList sharedList] requestWithComplete:nil failure:nil];//不用时去掉
	[self dataRequest];
}

- (StoreSelectView *)storeSelectView {
	if (_storeSelectView == nil) {
		_storeSelectView = [[StoreSelectView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
		[self.view addSubview:_storeSelectView];
		__weak typeof(self) weakSelf = self;
		_storeSelectView.confirmBlock = ^(NSString *name, NSString *idStr){
			[StoreList sharedList].selectedName = name;
			[StoreList sharedList].selectedId = idStr;
			weakSelf.title = [StoreList sharedList].selectedName;
//			[weakSelf.titleButton setTitle:[StoreList sharedList].selectedName forState:UIControlStateNormal];
//			[weakSelf.titleButton sizeToFit];
			[weakSelf dataRequest];
		};
	}
	return _storeSelectView;
}

- (IndexHeaderVM *)headerViewModel {
    if (_headerViewModel == nil) {
        _headerViewModel = [[IndexHeaderVM alloc] init];
    }
    return _headerViewModel;
}

- (IndexReminderVM *)reminderViewModel {
	if (_reminderViewModel == nil) {
		_reminderViewModel = [[IndexReminderVM alloc] init];
	}
	return _reminderViewModel;
}

- (IndexClientBoardVM *)clientBoardViewModel {
	if (_clientBoardViewModel == nil) {
		_clientBoardViewModel = [[IndexClientBoardVM alloc] init];
	}
	return _clientBoardViewModel;
}

- (IndexStoreBoardVM *)storeBoardViewModel {
	if (_storeBoardViewModel == nil) {
		_storeBoardViewModel = [[IndexStoreBoardVM alloc] init];
	}
	return _storeBoardViewModel;
}

- (IndexHeaderView *)headerView {
	if (_headerView == nil) {
		_headerView = [[IndexHeaderView alloc] initWithFrame:CGRectMake(0, -237, kScreenWidth, 236)];
		__weak typeof(self) weakSelf = self;
		_headerView.chartBlock = ^(NSInteger index) {
			weakSelf.selectedIndex = index;
		};
	}
	return _headerView;
}

- (IBAction)titleButtonDidTouch:(id)sender {
	[self.storeSelectView show];
}

- (IBAction)menuButtonDidTouch:(id)sender {
	UserInfoViewController *vc = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"UserInfoVC"];
	[self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 1) {
		if (indexPath.row == 0) {
			BirthdayViewController *vc = [[UIStoryboard storyboardWithName:@"Reminder" bundle:nil] instantiateViewControllerWithIdentifier:@"BirthdayVC"];
			vc.viewModel.code = self.reminderViewModel.birthdayCode;
			vc.viewModel.storeName = [StoreList sharedList].selectedName;
			vc.viewModel.storeId = [StoreList sharedList].selectedId;
			[self.navigationController pushViewController:vc animated:YES];
		} else if (indexPath.row == 1) {
			AppointMentViewController *vc = [[UIStoryboard storyboardWithName:@"Reminder" bundle:nil] instantiateViewControllerWithIdentifier:@"AppointmentVC"];
			vc.viewModel.code = self.reminderViewModel.appointmentCode;
			vc.viewModel.storeName = [StoreList sharedList].selectedName;
			vc.viewModel.storeId = [StoreList sharedList].selectedId;
			[self.navigationController pushViewController:vc animated:YES];
		} else if (indexPath.row == 2) {
			ServiceDueViewController *vc = [[UIStoryboard storyboardWithName:@"Reminder" bundle:nil] instantiateViewControllerWithIdentifier:@"ServiceDueVC"];
			vc.viewModel.code = self.reminderViewModel.serviceDueCode;
			vc.viewModel.storeName = [StoreList sharedList].selectedName;
			vc.viewModel.storeId = [StoreList sharedList].selectedId;
			[self.navigationController pushViewController:vc animated:YES];
		} else if (indexPath.row == 3) {
			CardDueViewController *vc = [[UIStoryboard storyboardWithName:@"Reminder" bundle:nil] instantiateViewControllerWithIdentifier:@"CardDueVC"];
			vc.viewModel.code = self.reminderViewModel.cardDueCode;
			vc.viewModel.storeName = [StoreList sharedList].selectedName;
			vc.viewModel.storeId = [StoreList sharedList].selectedId;
			[self.navigationController pushViewController:vc animated:YES];
		}
	} else if (indexPath.section == 2) {
		if (indexPath.row == 0) {
			ReceiveClientViewController *vc = [[UIStoryboard storyboardWithName:@"ClientBoard" bundle:nil] instantiateViewControllerWithIdentifier:@"ReceiveClientVC"];
			vc.viewModel.code = @"CRM_DESK_STORE_DDKHL";
			vc.viewModel.type = 0;
			vc.title = @"服务客户";
			vc.viewModel.storeName = [StoreList sharedList].selectedName;
			vc.viewModel.storeId = [StoreList sharedList].selectedId;
			[self.navigationController pushViewController:vc animated:YES];
		} else if (indexPath.row == 1) {
			NewClientViewController *vc = [[UIStoryboard storyboardWithName:@"ClientBoard" bundle:nil] instantiateViewControllerWithIdentifier:@"NewClientVC"];
			vc.viewModel.code = @"CRM_DESK_STORE_XZHYS";
			vc.viewModel.storeName = [StoreList sharedList].selectedName;
			vc.viewModel.storeId = [StoreList sharedList].selectedId;
			vc.title = @"新增客户";
			[self.navigationController pushViewController:vc animated:YES];
		} else if (indexPath.row == 2) {
			NewClientViewController *vc = [[UIStoryboard storyboardWithName:@"ClientBoard" bundle:nil] instantiateViewControllerWithIdentifier:@"NewClientVC"];
			vc.viewModel.code = @"CRM_DESK_STORE_QZKHLS";
			vc.viewModel.storeName = [StoreList sharedList].selectedName;
			vc.viewModel.storeId = [StoreList sharedList].selectedId;
			vc.title = @"客户准流失";
			[self.navigationController pushViewController:vc animated:YES];
		} else if (indexPath.row == 3) {
			NewClientViewController *vc = [[UIStoryboard storyboardWithName:@"ClientBoard" bundle:nil] instantiateViewControllerWithIdentifier:@"NewClientVC"];
			vc.viewModel.code = @"CRM_DESK_STORE_KHLSL";
			vc.viewModel.storeName = [StoreList sharedList].selectedName;
			vc.viewModel.storeId = [StoreList sharedList].selectedId;
			vc.title = @"客户流失";
			[self.navigationController pushViewController:vc animated:YES];
		} else if (indexPath.row == 4) {
			ClientLevelViewController *vc = [[UIStoryboard storyboardWithName:@"ClientBoard" bundle:nil] instantiateViewControllerWithIdentifier:@"ClientLevelVC"];
			vc.viewModel.code = @"CRM_DESK_STORE_STAR";
			vc.viewModel.storeName = [StoreList sharedList].selectedName;
			vc.viewModel.storeId = [StoreList sharedList].selectedId;
			[self.navigationController pushViewController:vc animated:YES];
		} else if (indexPath.row == 5) {
			ReceiveClientViewController *vc = [[UIStoryboard storyboardWithName:@"ClientBoard" bundle:nil] instantiateViewControllerWithIdentifier:@"ReceiveClientVC"];
			vc.viewModel.code = @"CRM_DESK_STORE_ADOPT";
			vc.viewModel.type = 1;
			vc.viewModel.storeName = [StoreList sharedList].selectedName;
			vc.viewModel.storeId = [StoreList sharedList].selectedId;
			[self.navigationController pushViewController:vc animated:YES];
		}
	} else if (indexPath.section == 3) {
		if (indexPath.row == 0) {
			WashCarViewController *vc = [[UIStoryboard storyboardWithName:@"StoreBoard" bundle:nil] instantiateViewControllerWithIdentifier:@"WashCarVC"];
			vc.viewModel.code = @"CRM_DESK_STORE_CARWASH";
			vc.viewModel.storeName = [StoreList sharedList].selectedName;
			vc.viewModel.storeId = [StoreList sharedList].selectedId;
			[self.navigationController pushViewController:vc animated:YES];
		} else if (indexPath.row == 1) {
			OnBoardCarViewController *vc = [[UIStoryboard storyboardWithName:@"StoreBoard" bundle:nil] instantiateViewControllerWithIdentifier:@"OnBoardVC"];
			vc.viewModel.code = @"CRM_DESK_STORE_APPROACH";
			vc.viewModel.storeName = [StoreList sharedList].selectedName;
			vc.viewModel.storeId = [StoreList sharedList].selectedId;
			[self.navigationController pushViewController:vc animated:YES];
		} else if (indexPath.row == 2) {
			SectorConversionViewController *vc = [[UIStoryboard storyboardWithName:@"StoreBoard" bundle:nil] instantiateViewControllerWithIdentifier:@"SectorVC"];
			vc.viewModel.code = @"CRM_DESK_STORE_ZHUANHUANLV";
			vc.viewModel.storeName = [StoreList sharedList].selectedName;
			vc.viewModel.storeId = [StoreList sharedList].selectedId;
			[self.navigationController pushViewController:vc animated:YES];
		} else if (indexPath.row == 3) {
			UnSettleCarViewController *vc = [[UIStoryboard storyboardWithName:@"StoreBoard" bundle:nil] instantiateViewControllerWithIdentifier:@"UnSettleVC"];
			vc.viewModel.code = @"CRM_DESK_STORE_NOTDELIVERY";
			vc.viewModel.storeName = [StoreList sharedList].selectedName;
			vc.viewModel.storeId = [StoreList sharedList].selectedId;
			[self.navigationController pushViewController:vc animated:YES];
		}
	}
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return 4;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	if (section == 0) {
		return 1;
	} else if (section == 1) {
		return 4;
	} else if (section == 2) {
		return 6;
	} else if (section == 3) {
		return 6;
	}
	return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) {
		IndexHeaderCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:headerCell forIndexPath:indexPath];
		cell.buttonBlock = ^(NSInteger index) {
			if (index == 0) {
				CostListViewController *vc = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"CostListVC"];
				vc.selectedIndex = self.selectedIndex;
				vc.storeName = [StoreList sharedList].selectedName;
				vc.storeId = [StoreList sharedList].selectedId;
				[self.navigationController pushViewController:vc animated:YES];
			} else if (index == 1) {
				ReportIndexViewController *vc = [[UIStoryboard storyboardWithName:@"Report" bundle:nil] instantiateViewControllerWithIdentifier:@"ReportIndexVC"];
				vc.storeName = [StoreList sharedList].selectedName;
				vc.storeId = [StoreList sharedList].selectedId;
				[self.navigationController pushViewController:vc animated:YES];
			} else if (index == 2) {
				MicroCommunityViewController *vc = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"MicroVC"];
				[self.navigationController pushViewController:vc animated:YES];
			} else if (index == 3) {
				UnFinishedViewController *vc = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"UnFinishedVC"];
				[self.navigationController pushViewController:vc animated:YES];
			}
		};
		return cell;
	} else if (indexPath.section == 1) {
		IndexCountCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:countCell forIndexPath:indexPath];
		cell.imageV.image = [UIImage imageNamed:self.countImageArray[indexPath.row]];
		cell.titleL.text = self.countArray[indexPath.row];
		if (indexPath.row == 0) {
			cell.numL.text = self.reminderViewModel.birthdayNum;
		} else if (indexPath.row == 1) {
			cell.numL.text = self.reminderViewModel.appointmentNum;
		} else if (indexPath.row == 2) {
			cell.numL.text = self.reminderViewModel.serviceDueNum;
		} else if (indexPath.row == 3) {
			cell.numL.text = self.reminderViewModel.cardDueNum;
		}
		return cell;
	} else if (indexPath.section == 2) {
		IndexCountTendencyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:countTendencyCell forIndexPath:indexPath];
		cell.imageV.image = [UIImage imageNamed:self.firstTendencyImageArray[indexPath.row]];
		cell.titleL.text = self.firstTendencyArray[indexPath.row];
//		cell.subTitle1L.text = @"本月";
//		cell.subTitle2L.text = @"上月";
		if (indexPath.row == 0) {
			cell.numL.text = self.clientBoardViewModel.serviceClientNum;
			if (self.clientBoardViewModel.serviceClientIsUp == 1) {
				cell.tendencyV.image = [UIImage imageNamed:@"icon_up"];
			} else if (self.clientBoardViewModel.serviceClientIsUp == -1) {
				cell.tendencyV.image = [UIImage imageNamed:@"icon_down"];
			} else {
				cell.tendencyV.image = nil;
			}
		} else if (indexPath.row == 1) {
			cell.numL.text = self.clientBoardViewModel.newlyClientNum;
			if (self.clientBoardViewModel.newlyClientIsUp == 1) {
				cell.tendencyV.image = [UIImage imageNamed:@"icon_up"];
			} else if (self.clientBoardViewModel.newlyClientIsUp == -1) {
				cell.tendencyV.image = [UIImage imageNamed:@"icon_down"];
			} else {
				cell.tendencyV.image = nil;
			}
		} else if (indexPath.row == 2) {
			cell.numL.text = self.clientBoardViewModel.preLoseClientNum;
			if (self.clientBoardViewModel.preLoseClientIsUp == 1) {
				cell.tendencyV.image = [UIImage imageNamed:@"icon_up"];
			} else if (self.clientBoardViewModel.preLoseClientIsUp == -1) {
				cell.tendencyV.image = [UIImage imageNamed:@"icon_down"];
			} else {
				cell.tendencyV.image = nil;
			}
		} else if (indexPath.row == 3) {
			cell.numL.text = self.clientBoardViewModel.loseClientNum;
			if (self.clientBoardViewModel.loseClientIsUp == 1) {
				cell.tendencyV.image = [UIImage imageNamed:@"icon_up"];
			} else if (self.clientBoardViewModel.loseClientIsUp == -1) {
				cell.tendencyV.image = [UIImage imageNamed:@"icon_down"];
			} else {
				cell.tendencyV.image = nil;
			}
		} else if (indexPath.row == 4) {
			cell.numL.text = self.clientBoardViewModel.starClientNum;
			if (self.clientBoardViewModel.starClientIsUp == 1) {
				cell.tendencyV.image = [UIImage imageNamed:@"icon_up"];
			} else if (self.clientBoardViewModel.starClientIsUp == -1) {
				cell.tendencyV.image = [UIImage imageNamed:@"icon_down"];
			} else {
				cell.tendencyV.image = nil;
			}
		} else if (indexPath.row == 5) {
			cell.numL.text = self.clientBoardViewModel.adoptClientNum;
			if (self.clientBoardViewModel.adoptClientIsUp == 1) {
				cell.tendencyV.image = [UIImage imageNamed:@"icon_up"];
			} else if (self.clientBoardViewModel.adoptClientIsUp == -1) {
				cell.tendencyV.image = [UIImage imageNamed:@"icon_down"];
			} else {
				cell.tendencyV.image = nil;
			}
		}
		return cell;
	} else if (indexPath.section == 3) {
		IndexTendencyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:tendencyCell forIndexPath:indexPath];
		cell.imageV.image = [UIImage imageNamed:self.secondTendencyImageArray[indexPath.row]];
		cell.titleL.text = self.secondTendencyArray[indexPath.row];
		cell.subTitle1L.text = @"本月";
		cell.subTitle2L.text = @"上月";
		if (indexPath.row == 0) {
			cell.num1L.text = self.storeBoardViewModel.washCarNum;
			cell.num2L.text = self.storeBoardViewModel.washCarLastNum;
			if (self.storeBoardViewModel.washCarIsUp == 1) {
				cell.tendencyV.image = [UIImage imageNamed:@"icon_up"];
			} else if (self.storeBoardViewModel.washCarIsUp == -1) {
				cell.tendencyV.image = [UIImage imageNamed:@"icon_down"];
			} else {
				cell.tendencyV.image = nil;
			}
		} else if (indexPath.row == 1) {
			cell.num1L.text = self.storeBoardViewModel.comeInNum;
			cell.num2L.text = self.storeBoardViewModel.comeInLastNum;
			if (self.storeBoardViewModel.comeInIsUp == 1) {
				cell.tendencyV.image = [UIImage imageNamed:@"icon_up"];
			} else if (self.storeBoardViewModel.comeInIsUp == -1) {
				cell.tendencyV.image = [UIImage imageNamed:@"icon_down"];
			} else {
				cell.tendencyV.image = nil;
			}
		} else if (indexPath.row == 2) {
			cell.num1L.text = self.storeBoardViewModel.sectorNum;
			cell.num2L.text = self.storeBoardViewModel.sectorLastNum;
			if (self.storeBoardViewModel.sectorIsUp == 1) {
				cell.tendencyV.image = [UIImage imageNamed:@"icon_up"];
			} else if (self.storeBoardViewModel.sectorIsUp == -1) {
				cell.tendencyV.image = [UIImage imageNamed:@"icon_down"];
			} else {
				cell.tendencyV.image = nil;
			}
		} else if (indexPath.row == 3) {
			cell.num1L.text = self.storeBoardViewModel.unSettleNum;
			cell.num2L.text = self.storeBoardViewModel.unSettleLastNum;
			if (self.storeBoardViewModel.unSettleIsUp == 1) {
				cell.tendencyV.image = [UIImage imageNamed:@"icon_up"];
			} else if (self.storeBoardViewModel.unSettleIsUp == -1) {
				cell.tendencyV.image = [UIImage imageNamed:@"icon_down"];
			} else {
				cell.tendencyV.image = nil;
			}
		} else if (indexPath.row == 4) {
			cell.num1L.text = self.storeBoardViewModel.receivableNum;
			cell.num2L.text = self.storeBoardViewModel.receivableLastNum;
			if (self.storeBoardViewModel.receivableIsUp == 1) {
				cell.tendencyV.image = [UIImage imageNamed:@"icon_up"];
			} else if (self.storeBoardViewModel.receivableIsUp == -1) {
				cell.tendencyV.image = [UIImage imageNamed:@"icon_down"];
			} else {
				cell.tendencyV.image = nil;
			}
		} else if (indexPath.row == 5) {
			cell.num1L.text = self.storeBoardViewModel.profitNum;
			cell.num2L.text = self.storeBoardViewModel.profitLastNum;
			if (self.storeBoardViewModel.profitIsUp == 1) {
				cell.tendencyV.image = [UIImage imageNamed:@"icon_up"];
			} else if (self.storeBoardViewModel.profitIsUp == -1) {
				cell.tendencyV.image = [UIImage imageNamed:@"icon_down"];
			} else {
				cell.tendencyV.image = nil;
			}
		}
		return cell;
	}
	return nil;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) {
		return CGSizeMake(kScreenWidth, 120);
	} else if (indexPath.section == 1) {
		CGFloat width = (kScreenWidth-1)/2;
		return CGSizeMake((int)width, 122);
	} else if (indexPath.section == 2) {
		CGFloat width = (kScreenWidth-1)/2;
		return CGSizeMake((int)width, 122);
	} else if (indexPath.section == 3) {
		CGFloat width = (kScreenWidth-1)/2;
		return CGSizeMake((int)width, 145);
	}
	return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
	if (section == 0) {
		return CGSizeMake(kScreenWidth, 10);
	} else if (section == 1) {
		return CGSizeMake(kScreenWidth, 10);
	} else if (section == 2) {
		return CGSizeMake(kScreenWidth, 10);
	} else if (section == 3) {
		return CGSizeMake(kScreenWidth, 10);
	}
	return CGSizeZero;
}

#pragma mark - Request

- (void)dataRequest {

    [self.headerViewModel chartRequestWithCompletion:^(BOOL success, NSString *jsStr, NSString *message) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (success) {
            self.headerView.jsStr = jsStr;
        } else {
            [self.view makeToast:message duration:2 position:CSToastPositionCenter];
        }
    } failure:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
	//[MBProgressHUD showHUDAddedTo:self.view animated:YES];
	[self.reminderViewModel requestWithComplete:^(BOOL success) {
		[MBProgressHUD hideHUDForView:self.view animated:YES];
		[self.collectionView reloadData];
	} failure:^{
		[MBProgressHUD hideHUDForView:self.view animated:YES];
	}];
	//[MBProgressHUD showHUDAddedTo:self.view animated:YES];
	[self.clientBoardViewModel requestWithComplete:^(BOOL success) {
		[MBProgressHUD hideHUDForView:self.view animated:YES];
		[self.collectionView reloadData];
	} failure:^{
		[MBProgressHUD hideHUDForView:self.view animated:YES];
	}];
	//[MBProgressHUD showHUDAddedTo:self.view animated:YES];
	[self.storeBoardViewModel requestWithComplete:^(BOOL success) {
		[MBProgressHUD hideHUDForView:self.view animated:YES];
		[self.collectionView reloadData];
	} failure:^{
		[MBProgressHUD hideHUDForView:self.view animated:YES];
	}];
}

@end
