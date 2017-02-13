//
//  StockVM.h
//  ShopManager
//
//  Created by 张旭 on 08/11/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import "RequestViewModel.h"

@interface StockChartItemVM : BaseViewModel

@property (strong, nonatomic) NSString *date;
@property (assign, nonatomic) CGFloat count;

@end

@interface StockVM : RequestViewModel

@property (strong, nonatomic) NSString *startDate;
@property (strong, nonatomic) NSString *endDate;
@property (strong, nonatomic) NSString *showTime;
@property (strong, nonatomic) NSString *selectedDate;
@property (strong, nonatomic) NSString *storeName;
@property (strong, nonatomic) NSString *storeId;

@property (assign, nonatomic) BOOL isSelected;

@property (strong, nonatomic) NSArray<StockChartItemVM *> *chartDataSource;
@property (strong, nonatomic) NSArray<StockChartItemVM *> *chartDataSource2;

- (void)chartRequestWithCompletion:(void(^)(BOOL success, NSString *jsStr, NSString *message))complete failure:(void(^)())failure;

@end
