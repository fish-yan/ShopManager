//
//  CardAnalyseVM.h
//  ShopManager
//
//  Created by 张旭 on 20/11/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import "RequestViewModel.h"

@interface CardAnalyseItemVM : BaseViewModel

@property (strong, nonatomic) NSString *storeName;
@property (strong, nonatomic) NSString *storeId;
@property (assign, nonatomic) NSInteger count;
@property (assign, nonatomic) CGFloat money;
@property (assign, nonatomic) CGFloat cost;

@end

@interface CardAnalyseChartItemVM : BaseViewModel

@property (strong, nonatomic) NSString *date;
@property (assign, nonatomic) CGFloat money;

@end

@interface CardAnalyseVM : RequestViewModel

@property (strong, nonatomic) NSString *startDate;
@property (strong, nonatomic) NSString *endDate;
@property (strong, nonatomic) NSString *showTime;
@property (strong, nonatomic) NSString *selectedDate;
@property (strong, nonatomic) NSString *storeName;
@property (strong, nonatomic) NSString *storeId;

@property (assign, nonatomic) BOOL isSelected;

@property (strong, nonatomic) NSArray<CardAnalyseItemVM *> *listDataSource;

@property (strong, nonatomic) NSArray<CardAnalyseChartItemVM *> *chartDataSource;
@property (strong, nonatomic) NSArray<CardAnalyseChartItemVM *> *chartDataSource2;

- (void)chartRequestWithCompletion:(void(^)(BOOL success, NSString *jsStr, NSString *message))complete failure:(void(^)())failure;

- (void)listRequestWithCompletion:(void(^)(BOOL success, NSString *message))complete failure:(void(^)())failure;

@end
