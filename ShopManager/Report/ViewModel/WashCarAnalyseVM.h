//
//  WashCarAnalyseVM.h
//  ShopManager
//
//  Created by 张旭 on 22/11/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import "RequestViewModel.h"

@interface WashCarAnalyseItemVM : BaseViewModel

@property (strong, nonatomic) NSString *source;
@property (assign, nonatomic) NSInteger count;
@property (assign, nonatomic) CGFloat money;

@end

@interface WashCarAnalyseVM : RequestViewModel

@property (strong, nonatomic) NSString *startDate;
@property (strong, nonatomic) NSString *endDate;
@property (strong, nonatomic) NSString *showTime;
@property (strong, nonatomic) NSString *storeName;
@property (strong, nonatomic) NSString *storeId;

@property (assign, nonatomic) CGFloat totalCount;
@property (assign, nonatomic) CGFloat totalMoney;

@property (strong, nonatomic) NSArray<WashCarAnalyseItemVM *> *listDataSource;

- (void)listRequestWithCompletion:(void(^)(BOOL sucess, NSString *jsStr, NSString *message))complete failure:(void(^)())failure;

@end
