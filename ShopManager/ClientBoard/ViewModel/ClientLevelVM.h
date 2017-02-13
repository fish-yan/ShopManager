//
//  ClientLevelVM.h
//  ShopManager
//
//  Created by 张旭 on 04/11/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import "RequestViewModel.h"

@interface ClientLevelItemVM : BaseViewModel

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *carNum;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *adopter;
@property (assign, nonatomic) CGFloat star;
@property (assign, nonatomic) CGFloat xc;
@property (assign, nonatomic) CGFloat mr;
@property (assign, nonatomic) CGFloat jx;
@property (assign, nonatomic) CGFloat bx;
@property (assign, nonatomic) CGFloat bp;
@property (assign, nonatomic) CGFloat lt;
@property (assign, nonatomic) CGFloat yp;
@property (assign, nonatomic) BOOL showDetail;

@end

@interface ClientLevelChartItemVM : BaseViewModel

@property (assign, nonatomic) CGFloat star;
@property (assign, nonatomic) NSInteger count;

@end

@interface ClientLevelVM : RequestViewModel

@property (strong, nonatomic) NSString *code;
@property (strong, nonatomic) NSString *storeName;
@property (strong, nonatomic) NSString *storeId;
@property (assign, nonatomic) CGFloat selectedStar;
@property (assign, nonatomic) NSInteger currentPage;

- (void)listRequestWithComplete:(void(^)(BOOL success, NSString *message))complete failure:(void(^)())failure;

- (void)chartRequestWithComplete:(void(^)(BOOL success, NSString *jsStr, NSString *message))complete failure:(void(^)())failure;

@property (strong, nonatomic) NSArray<ClientLevelItemVM *> *listDataSource;
@property (strong, nonatomic) NSArray<ClientLevelChartItemVM *> *chartDataSource;

- (void)clearList;

@end
