//
//  WashCarListVM.h
//  ShopManager
//
//  Created by 张旭 on 31/10/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import "RequestViewModel.h"

@interface WashCarListItemVM : BaseViewModel

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *carNum;
@property (strong, nonatomic) NSString *phone;

@end

@interface WashCarChartItemVM : BaseViewModel

@property (strong, nonatomic) NSString *date;
@property (assign, nonatomic) NSInteger count;

@end

@interface WashCarVM : RequestViewModel

@property (strong, nonatomic) NSString *code;
@property (strong, nonatomic) NSString *startDate;
@property (strong, nonatomic) NSString *endDate;
@property (strong, nonatomic) NSString *showTime;
@property (strong, nonatomic) NSString *selectedDate;
@property (strong, nonatomic) NSString *storeName;
@property (strong, nonatomic) NSString *storeId;
@property (assign, nonatomic) NSInteger currentPage;

@property (strong, nonatomic) NSString *num;

- (void)listRequestWithComplete:(void(^)(BOOL success, NSString *message))complete failure:(void(^)())failure;

- (void)chartRequestWithComplete:(void(^)(BOOL success, NSString *jsStr, NSString *message))complete failure:(void(^)())failure;

@property (strong, nonatomic) NSArray<WashCarListItemVM *> *listDataSource;
@property (strong, nonatomic) NSArray<WashCarChartItemVM *> *chartDataSource;

- (void)clearList;

@end
