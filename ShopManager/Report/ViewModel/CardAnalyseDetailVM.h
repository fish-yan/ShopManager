//
//  CardAnalyseDetailVM.h
//  ShopManager
//
//  Created by 张旭 on 20/11/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import "RequestViewModel.h"

@interface CardAnalyseDetailItemVM : BaseViewModel

@property (strong, nonatomic) NSString *name;
@property (assign, nonatomic) CGFloat money;
@property (assign, nonatomic) CGFloat cost;
@property (assign, nonatomic) CGFloat profit;

@end

@interface CardAnalyseDetailVM : RequestViewModel

@property (strong, nonatomic) NSString *startDate;
@property (strong, nonatomic) NSString *endDate;
@property (strong, nonatomic) NSString *showTime;
@property (strong, nonatomic) NSString *selectedDate;
@property (strong, nonatomic) NSString *storeName;
@property (strong, nonatomic) NSString *storeId;

@property (assign, nonatomic) CGFloat totalMoney;
@property (assign, nonatomic) CGFloat totalCost;
@property (assign, nonatomic) CGFloat totalProfit;

@property (strong, nonatomic) NSArray<CardAnalyseDetailItemVM *> *listDataSource;

- (void)listRequestWithCompletion:(void(^)(BOOL sucess, NSString *jsStr, NSString *message))complete failure:(void(^)())failure;

@end
