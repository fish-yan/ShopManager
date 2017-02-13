//
//  OnBoardVM.h
//  ShopManager
//
//  Created by 张旭 on 01/11/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import "RequestViewModel.h"

@interface OnBoardChartItemVM : BaseViewModel

@property (strong, nonatomic) NSString *date;
@property (assign, nonatomic) NSInteger count;
@property (assign, nonatomic) NSInteger xcCount;
@property (assign, nonatomic) NSInteger wxCount;
@property (assign, nonatomic) NSInteger otherCount;

@end

@interface OnBoardVM : RequestViewModel

@property (strong, nonatomic) NSString *code;
@property (strong, nonatomic) NSString *startDate;
@property (strong, nonatomic) NSString *endDate;
@property (strong, nonatomic) NSString *showTime;
@property (strong, nonatomic) NSString *selectedDate;
@property (strong, nonatomic) NSString *storeName;
@property (strong, nonatomic) NSString *storeId;

@property (strong, nonatomic) NSString *xcCount;
@property (strong, nonatomic) NSString *wxCount;
@property (strong, nonatomic) NSString *otherCount;

- (void)chartRequestWithComplete:(void(^)(BOOL success, NSString *jsStr, NSString *message))complete failure:(void(^)())failure;

@property (strong, nonatomic) NSArray<OnBoardChartItemVM *> *chartDataSource;

@end
