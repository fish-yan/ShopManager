//
//  ProfitAnalyseDetailVM.h
//  ShopManager
//
//  Created by 张旭 on 20/11/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import "RequestViewModel.h"

@interface ProfitAnalyseDetailItemVM : BaseViewModel

@property (strong, nonatomic) NSString *name;
@property (assign, nonatomic) CGFloat count;
@property (assign, nonatomic) CGFloat profitRatio;
@property (assign, nonatomic) CGFloat percent;

@end

@interface ProfitAnalyseDetailVM : RequestViewModel

@property (strong, nonatomic) NSString *code;
@property (strong, nonatomic) NSString *startDate;
@property (strong, nonatomic) NSString *endDate;
@property (strong, nonatomic) NSString *showTime;
@property (strong, nonatomic) NSString *storeName;
@property (strong, nonatomic) NSString *storeId;

@property (assign, nonatomic) NSInteger detailType;
@property (assign, nonatomic) NSInteger type;

@property (strong, nonatomic) NSString *keyWord;

@property (assign, nonatomic) CGFloat totalMoney;

@property (strong, nonatomic) NSArray<ProfitAnalyseDetailItemVM *> *listDataSource;

- (void)listRequestWithCompletion:(void(^)(BOOL success, NSString *jsStr, NSString *message))complete failure:(void(^)())failure;

- (void)listRequest2WithCompletion:(void(^)(BOOL success, NSString *jsStr, NSString *message))complete failure:(void(^)())failure;

@end
