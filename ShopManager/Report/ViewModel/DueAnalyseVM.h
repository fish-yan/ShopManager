//
//  DueAnalyseVM.h
//  ShopManager
//
//  Created by 张旭 on 08/11/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import "RequestViewModel.h"

@interface DueAnalyseItemVM : BaseViewModel

@property (strong, nonatomic) NSString *name;
@property (assign, nonatomic) CGFloat totalMoney;
@property (assign, nonatomic) CGFloat settledMoney;
@property (assign, nonatomic) CGFloat unsettledMoney;
@property (strong, nonatomic) NSString *memberId;

@end

@interface DueAnalyseChartItemVM : BaseViewModel

@property (strong, nonatomic) NSString *date;
@property (assign, nonatomic) CGFloat money;

@end

@interface DueAnalyseVM : RequestViewModel

@property (strong, nonatomic) NSString *code;
@property (strong, nonatomic) NSString *startDate;
@property (strong, nonatomic) NSString *endDate;
@property (strong, nonatomic) NSString *showTime;
@property (strong, nonatomic) NSString *selectedDate;
@property (strong, nonatomic) NSString *storeName;
@property (strong, nonatomic) NSString *storeId;
@property (assign, nonatomic) NSInteger currentPage;

@property (assign, nonatomic) BOOL isSelected;

@property (strong, nonatomic) NSArray<DueAnalyseItemVM *> *listDataSource;
@property (strong, nonatomic) NSArray<DueAnalyseChartItemVM *> *chartDataSource;
@property (strong, nonatomic) NSArray<DueAnalyseChartItemVM *> *chartDataSource2;

- (void)chartRequestWithCompletion:(void(^)(BOOL success, NSString *jsStr, NSString *message))complete failure:(void(^)())failure;
- (void)listRequestWithCompletion:(void(^)(BOOL success, NSString *message))complete failure:(void(^)())failure;

@end
