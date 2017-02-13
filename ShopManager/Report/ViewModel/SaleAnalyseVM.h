//
//  SaleAnalyseVM.h
//  ShopManager
//
//  Created by 张旭 on 08/11/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import "RequestViewModel.h"

@interface SaleAnalyseItemVM : BaseViewModel

@property (strong, nonatomic) NSString *name;
@property (assign, nonatomic) CGFloat count;
@property (assign, nonatomic) CGFloat percent;

@end

@interface SaleAnalyseChartItemVM : BaseViewModel

@property (strong, nonatomic) NSString *date;
@property (assign, nonatomic) CGFloat money;

@end

@interface SaleAnalyseVM : RequestViewModel

@property (strong, nonatomic) NSString *startDate;
@property (strong, nonatomic) NSString *endDate;
@property (strong, nonatomic) NSString *showTime;
@property (strong, nonatomic) NSString *selectedDate;
@property (strong, nonatomic) NSString *storeName;
@property (strong, nonatomic) NSString *storeId;

@property (assign, nonatomic) NSInteger type;
@property (assign, nonatomic) BOOL isSelected;

@property (assign, nonatomic) CGFloat goodsMoney;
@property (assign, nonatomic) CGFloat projectMoney;
@property (assign, nonatomic) CGFloat productMoney;
@property (assign, nonatomic) CGFloat cardMoney;

@property (assign, nonatomic) CGFloat goodsRatio;
@property (assign, nonatomic) CGFloat projectRatio;
@property (assign, nonatomic) CGFloat productRatio;
@property (assign, nonatomic) CGFloat cardRatio;

@property (assign, nonatomic) CGFloat totalMoney;

@property (strong, nonatomic) NSArray<SaleAnalyseItemVM *> *listDataSource;

@property (strong, nonatomic) NSArray<SaleAnalyseChartItemVM *> *chartDataSource;
@property (strong, nonatomic) NSArray<SaleAnalyseChartItemVM *> *chartDataSource2;

- (void)chartRequestWithCompletion:(void(^)(BOOL success, NSString *jsStr, NSString *message))complete failure:(void(^)())failure;

- (void)firstRequestWithCompletion:(void(^)(BOOL success, NSString *message))complete failure:(void(^)())failure;

- (void)secondRequestWithCompletion:(void(^)(BOOL success, NSString *message))complete failure:(void(^)())failure;

@end
