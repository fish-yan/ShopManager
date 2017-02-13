//
//  HttpClient.h
//  Repair
//
//  Created by Kassol on 15/9/9.
//  Copyright (c) 2015年 CJM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShopManager-Swift.h"
#import "AFNetWorking.h"

@interface HttpClient : NSObject

+ (instancetype)sharedHttpClient;

- (void)loginWithUsername:(NSString *)username passward:(NSString *)password
                 complete:(void (^)(BOOL success))complete
                  failure:(void (^)())failure;

- (void)getSaleTotalWithStoreId:(NSString *)storeId completion:(void (^)(BOOL success, NSArray *data))complete
                           failure:(void (^)())failure;

- (void)getSaleFrontTotalWithCompletion:(void (^)(BOOL success, NSArray *data))complete
                           failure:(void (^)())failure;

- (void)getComeInWithCompletion:(void (^)(BOOL success, NSArray *data))complete
                           failure:(void (^)())failure;

- (void)getComeInDataWithDateString:(NSString *)dateString Completion:(void (^)(BOOL success, NSArray *data))complete
                        failure:(void (^)())failure;

- (void)getTransferWithCompletion:(void (^)(BOOL success, NSArray *data))complete
                        failure:(void (^)())failure;

- (void)getStarDataWithStoreID:(NSString *)storeID
                     StartDate:(NSString *)startDate
                         endDate:(NSString *)endDate
                consumptionMoney:(NSString *)consumptionMoney
                consumptionTimes:(NSString *)consumptionTimes
                        complete:(void (^)(BOOL success, StarData *data))complete
                          failure:(void (^)())failure;

- (void)getHomeDataWithDateString:(NSString*)dateString Completion:(void (^)(BOOL success, NSArray *data))complete
                           failure:(void (^)())failure;

- (void)getSaleDataWithCompletion:(void (^)(BOOL success, NSArray *data))complete
                          failure:(void (^)())failure;

- (void)getCustomStarDataWithCompletion:(void (^)(BOOL success, NSArray *data))complete
                          failure:(void (^)())failure;

- (void)getCustomAnalyDataWithCompletion:(void (^)(BOOL success, CustomAnaly *data))complete
                                failure:(void (^)())failure;

- (void)getStoreDataWithCompletion:(void (^)(BOOL success, NSArray *data))complete
                                 failure:(void (^)())failure;

- (void)getDeptTransferDataWithDateString:(NSString *)dateString Completion:(void (^)(BOOL success, NSArray *data))complete
                                  failure:(void (^)())failure;

- (void)getSheQuListWithCompletion:(void (^)(BOOL success, NSArray *data))complete
                           failure:(void (^)())failure;

- (void)getBBSDetailWithID:(NSString *)idStr completion:(void (^)(BOOL success, BBSDetail *data))complete
                           failure:(void (^)())failure;

- (void)replyWithId:(NSString *)idStr Text:(NSString *)text completion:(void (^)(BOOL success))complete
              failure:(void (^)())failure;

- (void)getCostListWithDateString:(NSString *)dateString
						  storeId:(NSString *)storeId
					   Completion:(void (^)(BOOL success, NSArray *data))complete
                           failure:(void (^)())failure;

- (void)getCostOrderListWithName:(NSString *)name storeId:(NSString *)storeId dateString:(NSString *)dateString pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize completion:(void (^)(BOOL success, NSArray *data))complete
            failure:(void (^)())failure;

- (void)getCostOrderDescWithId:(NSString *)idStr completion:(void (^)(BOOL success, CostOrderDesc *desc))complete
                         failure:(void (^)())failure;
@end
