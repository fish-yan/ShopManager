//
//  ReceiveClientVM.h
//  ShopManager
//
//  Created by 张旭 on 04/11/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import "RequestViewModel.h"

@interface ReceiveClientItemVM : BaseViewModel

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *carNum;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *clientManager;
@property (strong, nonatomic) NSString *birthday;

@end

@interface ReceiveClientChartItemVM : BaseViewModel

@property (strong, nonatomic) NSString *date;
@property (assign, nonatomic) NSInteger count;

@end

@interface ReceiveClientVM : RequestViewModel

@property (strong, nonatomic) NSString *code;
@property (strong, nonatomic) NSString *startDate;
@property (strong, nonatomic) NSString *endDate;
@property (strong, nonatomic) NSString *showTime;
@property (strong, nonatomic) NSString *selectedDate;
@property (strong, nonatomic) NSString *storeName;
@property (strong, nonatomic) NSString *storeId;
@property (assign, nonatomic) NSInteger currentPage;

@property (assign, nonatomic) NSInteger type;

- (void)listRequestWithComplete:(void(^)(BOOL success, NSString *message))complete failure:(void(^)())failure;

- (void)chartRequestWithComplete:(void(^)(BOOL success, NSString *jsStr, NSString *message))complete failure:(void(^)())failure;

@property (strong, nonatomic) NSArray<ReceiveClientItemVM *> *listDataSource;
@property (strong, nonatomic) NSArray<ReceiveClientChartItemVM *> *chartDataSource;

- (void)clearList;

@end
