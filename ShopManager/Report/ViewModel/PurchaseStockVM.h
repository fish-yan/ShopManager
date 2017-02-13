//
//  PurchaseStockVM.h
//  ShopManager
//
//  Created by 张旭 on 07/11/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import "RequestViewModel.h"

@interface PurchaseStockChartItemVM : BaseViewModel

@property (strong, nonatomic) NSString *date;
@property (assign, nonatomic) CGFloat purchaseCount;
@property (assign, nonatomic) CGFloat sumPurchaseCount;
@property (assign, nonatomic) CGFloat stockCount;
@property (assign, nonatomic) CGFloat dueCount;

@end

@interface PurchaseStockVM : RequestViewModel

@property (strong, nonatomic) NSString *startDate;
@property (strong, nonatomic) NSString *endDate;
@property (strong, nonatomic) NSString *showTime;
@property (strong, nonatomic) NSString *selectedDate;
@property (strong, nonatomic) NSString *storeName;
@property (strong, nonatomic) NSString *storeId;

@property (assign, nonatomic) CGFloat purchaseCount;
@property (assign, nonatomic) CGFloat sumPurchaseCount;
@property (assign, nonatomic) CGFloat stockCount;
@property (assign, nonatomic) CGFloat dueCount;

@property (strong, nonatomic) NSArray<PurchaseStockChartItemVM *> *chartDataSource;

- (void)chartRequestWithCompletion:(void(^)(BOOL success, NSString *jsStr, NSString *message))complete failure:(void(^)())failure;

@end
