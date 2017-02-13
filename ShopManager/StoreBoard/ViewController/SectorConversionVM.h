//
//  SectorConversionVM.h
//  ShopManager
//
//  Created by 张旭 on 01/11/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import "RequestViewModel.h"

@interface SectorConversionItemVM : BaseViewModel

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *rate;

@end

@interface SectorConversionChartItemVM : BaseViewModel

@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) NSString *rate;

@end

@interface SectorConversionVM : RequestViewModel

@property (strong, nonatomic) NSString *code;
@property (strong, nonatomic) NSString *startDate;
@property (strong, nonatomic) NSString *endDate;
@property (strong, nonatomic) NSString *showTime;
@property (strong, nonatomic) NSString *selectedDate;
@property (strong, nonatomic) NSString *storeName;
@property (strong, nonatomic) NSString *storeId;

- (void)listRequestWithComplete:(void(^)(BOOL success, NSString *message))complete failure:(void(^)())failure;

- (void)chartRequestWithComplete:(void(^)(BOOL success, NSString *jsStr, NSString *message))complete failure:(void(^)())failure;

@property (strong, nonatomic) NSArray<SectorConversionItemVM *> *listDataSource;
@property (strong, nonatomic) NSArray<SectorConversionChartItemVM *> *chartDataSource;

- (void)clearList;

@end
