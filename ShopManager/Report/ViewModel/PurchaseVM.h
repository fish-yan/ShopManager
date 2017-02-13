//
//  PurchaseVM.h
//  ShopManager
//
//  Created by 张旭 on 07/11/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import "RequestViewModel.h"

@interface PurchaseItemVM : BaseViewModel

@property (strong, nonatomic) NSString *name;
@property (assign, nonatomic) CGFloat inCount;
@property (assign, nonatomic) CGFloat backCount;
@property (assign, nonatomic) CGFloat totalCount;
@property (strong, nonatomic) NSString *supplierId;

@end

@interface PurchaseChartItemVM : BaseViewModel

@property (strong, nonatomic) NSString *date;
@property (assign, nonatomic) CGFloat count;

@end

@interface PurchaseVM : RequestViewModel

@property (strong, nonatomic) NSString *startDate;
@property (strong, nonatomic) NSString *endDate;
@property (strong, nonatomic) NSString *showTime;
@property (strong, nonatomic) NSString *selectedDate;
@property (strong, nonatomic) NSString *storeName;
@property (strong, nonatomic) NSString *storeId;
@property (assign, nonatomic) NSInteger currentPage;

@property (assign, nonatomic) NSInteger type;

@property (assign, nonatomic) BOOL isSelected;

@property (strong, nonatomic) NSArray<PurchaseItemVM *> *listDataSource;
@property (strong, nonatomic) NSArray<PurchaseChartItemVM *> *chartDataSource;
@property (strong, nonatomic) NSArray<PurchaseChartItemVM *> *chartDataSource2;

- (void)chartRequestWithCompletion:(void(^)(BOOL success, NSString *jsStr, NSString *message))complete failure:(void(^)())failure;

- (void)listRequestWithCompletion:(void(^)(BOOL success, NSString *message))complete failure:(void(^)())failure;

@end
