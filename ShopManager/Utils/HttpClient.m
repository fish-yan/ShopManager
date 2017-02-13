//
//  HttpClient.m
//  Repair
//
//  Created by Kassol on 15/9/9.
//  Copyright (c) 2015年 CJM. All rights reserved.
//

#import "HttpClient.h"
@import JDStatusBarNotification;


@interface HttpClient ()
@property (strong, nonatomic) AFHTTPSessionManager *manager;
@property (strong, nonatomic) NSString *baseURL;
@end

@implementation HttpClient

static HttpClient *sharedInstance = nil;

- (instancetype)init {
    self = [super init];
    _manager = [AFHTTPSessionManager manager];
    _manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //_manager.requestSerializer.timeoutInterval = 10.f;
    _baseURL = BASEURL;
    return self;
}

+ (instancetype)sharedHttpClient {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)setBaseURL:(NSString *)baseURL {
    _baseURL = baseURL;
}

- (void)loginWithUsername:(NSString *)username passward:(NSString *)password
                 complete:(void (^)(BOOL success))complete
                  failure:(void (^)())failure{
    NSString *url = [_baseURL stringByAppendingString:@"UserLogin"];
    NSString *deviceCode = [[NSUserDefaults standardUserDefaults] objectForKey:DEVICECODE];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (deviceCode != nil) {
        [parameters setObject:deviceCode forKey:DEVICECODE];
    }
    [parameters setObject:username forKey:LOGINNAME];
    [parameters setObject:password forKey:LOGINPWD];
    [parameters setObject:@"AppDZ" forKey:LOGINLIMIT];
    [parameters setObject:@"IOS" forKey:DEVICETYPE];
    
    [_manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        NSDictionary *response = responseObject;
        if ([[[response objectForKey:CODE] stringValue] isEqualToString:@"0"]) {
            NSDictionary *result = [response objectForKey:RESULT];
            [[User sharedUser] configureWithResult:result];
            complete(YES);
        } else {
            NSString *message = [response objectForKey:MESSAGE];
            [JDStatusBarNotification showWithStatus:message dismissAfter:2];
            complete(NO);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
        failure();
        [JDStatusBarNotification showWithStatus:ERROR_NETWORK dismissAfter:2];
    }];
}

- (void)getSaleFrontTotalWithCompletion:(void (^)(BOOL, NSArray *))complete
                           failure:(void (^)())failure {
    NSString *url = [_baseURL stringByAppendingString:@"GetSaleFrontTotal"];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[User sharedUser].companyID forKey:COMPANYID];
    [parameters setObject:[User sharedUser].storeID forKey:STOREID];
    [parameters setObject:[User sharedUser].positions forKey:POSITIONS];
    NSDictionary *userToken = @{
                                USERID:[User sharedUser].userID,
                                TOKEN:[User sharedUser].token
                                };
    [parameters setObject:userToken forKey:USERTOKEN];
    
    [_manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        NSDictionary *response = responseObject;
        if ([[[response objectForKey:CODE] stringValue] isEqualToString:@"0"]) {
            NSArray *result = [response objectForKey:RESULT];
            complete(YES, [AreaData saleTotalWithArray:result]);
        } else {
            NSString *message = [response objectForKey:MESSAGE];
            [JDStatusBarNotification showWithStatus:message dismissAfter:2];
            complete(NO, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
        failure();
        [JDStatusBarNotification showWithStatus:ERROR_NETWORK dismissAfter:2];
    }];
}

- (void)getSaleTotalWithStoreId:(NSString *)storeId completion:(void (^)(BOOL, NSArray *))complete
                           failure:(void (^)())failure {
    NSString *url = [_baseURL stringByAppendingString:@"GetSaleTotal"];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[User sharedUser].companyID forKey:COMPANYID];
	if (storeId == nil || [storeId isEqualToString:@""]) {
		[parameters setObject:@"1" forKey:POSITIONS];
	} else {
		[parameters setObject:storeId forKey:STOREID];
		[parameters setObject:@"4" forKey:POSITIONS];
	}

    NSDictionary *userToken = @{
                                USERID:[User sharedUser].userID,
                                TOKEN:[User sharedUser].token
                                };
    [parameters setObject:userToken forKey:USERTOKEN];
    
    [_manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        NSDictionary *response = responseObject;
        if ([[[response objectForKey:CODE] stringValue] isEqualToString:@"0"]) {
            NSArray *result = [response objectForKey:RESULT];
            complete(YES, [AreaData saleTotalWithArray:result]);
        } else {
            NSString *message = [response objectForKey:MESSAGE];
            [JDStatusBarNotification showWithStatus:message dismissAfter:2];
            complete(NO, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
        failure();
        [JDStatusBarNotification showWithStatus:ERROR_NETWORK dismissAfter:2];
    }];
}

- (void)getComeInWithCompletion:(void (^)(BOOL, NSArray *))complete
                        failure:(void (^)())failure {
    NSString *url = [_baseURL stringByAppendingString:@"GetComeInByDay"];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[User sharedUser].companyID forKey:COMPANYID];
    [parameters setObject:[User sharedUser].storeID forKey:STOREID];
    [parameters setObject:[User sharedUser].positions forKey:POSITIONS];
    NSDictionary *userToken = @{
                                USERID:[User sharedUser].userID,
                                TOKEN:[User sharedUser].token
                                };
    [parameters setObject:userToken forKey:USERTOKEN];
    
    [_manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        NSDictionary *response = responseObject;
        if ([[[response objectForKey:CODE] stringValue] isEqualToString:@"0"]) {
            NSArray *result = [response objectForKey:RESULT];
            complete(YES, [AreaData comeInWithArray:result]);
        } else {
            NSString *message = [response objectForKey:MESSAGE];
            [JDStatusBarNotification showWithStatus:message dismissAfter:2];
            complete(NO, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
        failure();
        [JDStatusBarNotification showWithStatus:ERROR_NETWORK dismissAfter:2];
    }];
}

- (void)getComeInDataWithDateString:(NSString *)dateString Completion:(void (^)(BOOL, NSArray *))complete
                        failure:(void (^)())failure {
    NSString *url = [_baseURL stringByAppendingString:@"GetComeInPage"];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[User sharedUser].companyID forKey:COMPANYID];
    [parameters setObject:[User sharedUser].storeID forKey:STOREID];
    [parameters setObject:[User sharedUser].positions forKey:POSITIONS];
	[parameters setObject:dateString forKey:STARTDATE];
    NSDictionary *userToken = @{
                                USERID:[User sharedUser].userID,
                                TOKEN:[User sharedUser].token
                                };
    [parameters setObject:userToken forKey:USERTOKEN];
    
    [_manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        NSDictionary *response = responseObject;
        if ([[[response objectForKey:CODE] stringValue] isEqualToString:@"0"]) {
            NSDictionary *result = [response objectForKey:RESULT];
            complete(YES, [ListData comInPageDataWithDict:result]);
        } else {
            NSString *message = [response objectForKey:MESSAGE];
            [JDStatusBarNotification showWithStatus:message dismissAfter:2];
            complete(NO, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
        failure();
        [JDStatusBarNotification showWithStatus:ERROR_NETWORK dismissAfter:2];
    }];
}

- (void)getTransferWithCompletion:(void (^)(BOOL, NSArray *))complete
                          failure:(void (^)())failure {
    NSString *url = [_baseURL stringByAppendingString:@"GetTransfer"];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[User sharedUser].companyID forKey:COMPANYID];
    [parameters setObject:[User sharedUser].storeID forKey:STOREID];
    [parameters setObject:[User sharedUser].positions forKey:POSITIONS];
    NSDictionary *userToken = @{
                                USERID:[User sharedUser].userID,
                                TOKEN:[User sharedUser].token
                                };
    [parameters setObject:userToken forKey:USERTOKEN];
    
    [_manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        NSDictionary *response = responseObject;
        if ([[[response objectForKey:CODE] stringValue] isEqualToString:@"0"]) {
            NSArray *result = [response objectForKey:RESULT];
            complete(YES, [AreaData transferWithArray:result]);
        } else {
            NSString *message = [response objectForKey:MESSAGE];
            [JDStatusBarNotification showWithStatus:message dismissAfter:2];
            complete(NO, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
        failure();
        [JDStatusBarNotification showWithStatus:ERROR_NETWORK dismissAfter:2];
    }];
}

- (void)getStarDataWithStoreID:(NSString *)storeID
                     StartDate:(NSString *)startDate
                       endDate:(NSString *)endDate
              consumptionMoney:(NSString *)consumptionMoney
              consumptionTimes:(NSString *)consumptionTimes
                      complete:(void (^)(BOOL, StarData *))complete
                       failure:(void (^)())failure {
    NSString *url = [_baseURL stringByAppendingString:@"GetCustomConsumption"];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[User sharedUser].companyID forKey:COMPANYID];
    if (storeID != nil) {
        [parameters setObject:storeID forKey:STOREID];
    } else {
        [parameters setObject:@"" forKey:STOREID];
    }
    if (startDate != nil) {
        [parameters setObject:startDate forKey:STARTDATE];
    }
    if (endDate != nil) {
        [parameters setObject:endDate forKey:ENDDATE];
    }
    if (consumptionMoney != nil) {
        [parameters setObject:consumptionMoney forKey:CONSUMPTIONMONEY];
    }
    if (consumptionTimes != nil) {
        [parameters setObject:consumptionTimes forKey:CONSUMPTIONTIMES];
    }
    [parameters setObject:[User sharedUser].positions forKey:POSITIONS];
    NSDictionary *userToken = @{
                                USERID:[User sharedUser].userID,
                                TOKEN:[User sharedUser].token
                                };
    [parameters setObject:userToken forKey:USERTOKEN];
    [_manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        NSDictionary *response = responseObject;
        if ([[[response objectForKey:CODE] stringValue] isEqualToString:@"0"]) {
            NSDictionary *result = [response objectForKey:RESULT];
            complete(YES, [PointData dataWithDict:result]);
        } else {
            NSString *message = [response objectForKey:MESSAGE];
            [JDStatusBarNotification showWithStatus:message dismissAfter:2];
            complete(NO, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
        failure();
        [JDStatusBarNotification showWithStatus:ERROR_NETWORK dismissAfter:2];
    }];
}

- (void)getHomeDataWithDateString:(NSString*)dateString Completion:(void (^)(BOOL, NSArray *))complete
                          failure:(void (^)())failure {
    NSString *url = [_baseURL stringByAppendingString:@"GetFirstPage"];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[User sharedUser].companyID forKey:COMPANYID];
    [parameters setObject:[User sharedUser].storeID forKey:STOREID];
    [parameters setObject:[User sharedUser].positions forKey:POSITIONS];
	[parameters setObject:dateString forKey:STARTDATE];
    NSDictionary *userToken = @{
                                USERID:[User sharedUser].userID,
                                TOKEN:[User sharedUser].token
                                };
    [parameters setObject:userToken forKey:USERTOKEN];
    
    [_manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        NSDictionary *response = responseObject;
        if ([[[response objectForKey:CODE] stringValue] isEqualToString:@"0"]) {
            NSDictionary *result = [response objectForKey:RESULT];
            complete(YES, [ListData homeDataWithDict:result]);
        } else {
            NSString *message = [response objectForKey:MESSAGE];
            [JDStatusBarNotification showWithStatus:message dismissAfter:2];
            complete(NO, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
        failure();
        [JDStatusBarNotification showWithStatus:ERROR_NETWORK dismissAfter:2];
    }];
}

- (void)getSaleDataWithCompletion:(void (^)(BOOL, NSArray *))complete
                          failure:(void (^)())failure {
    NSString *url = [_baseURL stringByAppendingString:@"GetSalePage"];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[User sharedUser].companyID forKey:COMPANYID];
    [parameters setObject:[User sharedUser].storeID forKey:STOREID];
    [parameters setObject:[User sharedUser].positions forKey:POSITIONS];
    NSDictionary *userToken = @{
                                USERID:[User sharedUser].userID,
                                TOKEN:[User sharedUser].token
                                };
    [parameters setObject:userToken forKey:USERTOKEN];
    
    [_manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        NSDictionary *response = responseObject;
        if ([[[response objectForKey:CODE] stringValue] isEqualToString:@"0"]) {
            NSDictionary *result = [response objectForKey:RESULT];
            complete(YES, [ListData saleDataWithDict:result]);
        } else {
            NSString *message = [response objectForKey:MESSAGE];
            [JDStatusBarNotification showWithStatus:message dismissAfter:2];
            complete(NO, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
        failure();
        [JDStatusBarNotification showWithStatus:ERROR_NETWORK dismissAfter:2];
    }];
}

- (void)getCustomStarDataWithCompletion:(void (^)(BOOL, NSArray *))complete
                                failure:(void (^)())failure {
    NSString *url = [_baseURL stringByAppendingString:@"GetCustomTotalsByStar"];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[User sharedUser].companyID forKey:COMPANYID];
    [parameters setObject:[User sharedUser].storeID forKey:STOREID];
    [parameters setObject:[User sharedUser].positions forKey:POSITIONS];
    NSDictionary *userToken = @{
                                USERID:[User sharedUser].userID,
                                TOKEN:[User sharedUser].token
                                };
    [parameters setObject:userToken forKey:USERTOKEN];
    
    [_manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        NSDictionary *response = responseObject;
        if ([[[response objectForKey:CODE] stringValue] isEqualToString:@"0"]) {
            NSArray *result = [response objectForKey:RESULT];
            complete(YES, [ListData starDataWithArray:result]);
        } else {
            NSString *message = [response objectForKey:MESSAGE];
            [JDStatusBarNotification showWithStatus:message dismissAfter:2];
            complete(NO, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
        failure();
        [JDStatusBarNotification showWithStatus:ERROR_NETWORK dismissAfter:2];
    }];
}

- (void)getCustomAnalyDataWithCompletion:(void (^)(BOOL, CustomAnaly *))complete
                                 failure:(void (^)())failure {
    NSString *url = [_baseURL stringByAppendingString:@"GetCustomAnaly"];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[User sharedUser].companyID forKey:COMPANYID];
    [parameters setObject:[User sharedUser].storeID forKey:STOREID];
    [parameters setObject:[User sharedUser].positions forKey:POSITIONS];
    NSDictionary *userToken = @{
                                USERID:[User sharedUser].userID,
                                TOKEN:[User sharedUser].token
                                };
    [parameters setObject:userToken forKey:USERTOKEN];
    
    [_manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        NSDictionary *response = responseObject;
        if ([[[response objectForKey:CODE] stringValue] isEqualToString:@"0"]) {
            NSDictionary *result = [response objectForKey:RESULT];
            complete(YES, [ListData customAnalyDataWithDict:result]);
        } else {
            NSString *message = [response objectForKey:MESSAGE];
            [JDStatusBarNotification showWithStatus:message dismissAfter:2];
            complete(NO, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
        failure();
        [JDStatusBarNotification showWithStatus:ERROR_NETWORK dismissAfter:2];
    }];
}

- (void)getStoreDataWithCompletion:(void (^)(BOOL, NSArray *))complete
                           failure:(void (^)())failure {
    NSString *url = [_baseURL stringByAppendingString:@"GetStoreList"];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[User sharedUser].companyID forKey:COMPANYID];
    NSDictionary *userToken = @{
                                USERID:[User sharedUser].userID,
                                TOKEN:[User sharedUser].token
                                };
    [parameters setObject:userToken forKey:USERTOKEN];
    [_manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        NSDictionary *response = responseObject;
        if ([[[response objectForKey:CODE] stringValue] isEqualToString:@"0"]) {
            NSArray *result = [response objectForKey:RESULT];
            complete(YES, [ListData storeDataWithArray:result]);
        } else {
            NSString *message = [response objectForKey:MESSAGE];
            [JDStatusBarNotification showWithStatus:message dismissAfter:2];
            complete(NO, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
        failure();
        [JDStatusBarNotification showWithStatus:ERROR_NETWORK dismissAfter:2];
    }];
}

- (void)getDeptTransferDataWithDateString:(NSString *)dateString Completion:(void (^)(BOOL, NSArray *))complete
                                  failure:(void (^)())failure {
    NSString *url = [_baseURL stringByAppendingString:@"GetTransferDept"];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[User sharedUser].companyID forKey:COMPANYID];
	[parameters setObject:[User sharedUser].storeID forKey:STOREID];
	[parameters setObject:[User sharedUser].positions forKey:POSITIONS];
	[parameters setObject:dateString forKey:STARTDATE];
    NSDictionary *userToken = @{
                                USERID:[User sharedUser].userID,
                                TOKEN:[User sharedUser].token
                                };
    [parameters setObject:userToken forKey:USERTOKEN];
    [_manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        NSDictionary *response = responseObject;
        if ([[[response objectForKey:CODE] stringValue] isEqualToString:@"0"]) {
            NSArray *result = [response objectForKey:RESULT];
            complete(YES, [ListData deptTransferDataWithArray:result]);
        } else {
            NSString *message = [response objectForKey:MESSAGE];
            [JDStatusBarNotification showWithStatus:message dismissAfter:2];
            complete(NO, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
        failure();
        [JDStatusBarNotification showWithStatus:ERROR_NETWORK dismissAfter:2];
    }];
}

- (void)getSheQuListWithCompletion:(void (^)(BOOL, NSArray *))complete failure:(void (^)())failure {
    NSString *url = [_baseURL stringByAppendingString:@"GetSheQuList"];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSDictionary *userToken = @{
                                USERID:[User sharedUser].userID,
                                TOKEN:[User sharedUser].token
                                };
    [parameters setObject:userToken forKey:USERTOKEN];
    [_manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        NSDictionary *response = responseObject;
        if ([[[response objectForKey:CODE] stringValue] isEqualToString:@"0"]) {
            NSArray *result = [response objectForKey:RESULT];
            complete(YES, [ListData shequListDataWithArray:result]);
        } else {
            NSString *message = [response objectForKey:MESSAGE];
            [JDStatusBarNotification showWithStatus:message dismissAfter:2];
            complete(NO, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
        failure();
        [JDStatusBarNotification showWithStatus:ERROR_NETWORK dismissAfter:2];
    }];
}

- (void)getBBSDetailWithID:(NSString *)idStr completion:(void (^)(BOOL, BBSDetail *))complete failure:(void (^)())failure {
    NSString *url = [_baseURL stringByAppendingString:@"GetSheQuDesc"];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:idStr forKey:ASKID];
    NSDictionary *userToken = @{
                                USERID:[User sharedUser].userID,
                                TOKEN:[User sharedUser].token
                                };
    [parameters setObject:userToken forKey:USERTOKEN];
    [_manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        NSDictionary *response = responseObject;
        if ([[[response objectForKey:CODE] stringValue] isEqualToString:@"0"]) {
            NSDictionary *result = [response objectForKey:RESULT];
            complete(YES, [ListData bbsDetailWithDict:result]);
        } else {
            NSString *message = [response objectForKey:MESSAGE];
            [JDStatusBarNotification showWithStatus:message dismissAfter:2];
            complete(NO, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
        failure();
        [JDStatusBarNotification showWithStatus:ERROR_NETWORK dismissAfter:2];
    }];
}

- (void)replyWithId:(NSString *)idStr Text:(NSString *)text completion :(void (^)(BOOL))complete failure:(void (^)())failure {
    NSString *url = [_baseURL stringByAppendingString:@"GetSheQuReply"];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:idStr forKey:ASKID];
    [parameters setObject:text forKey:CONTENT];
    [parameters setObject:[User sharedUser].userName forKey:USERNAME];
    NSDictionary *userToken = @{
                                USERID:[User sharedUser].userID,
                                TOKEN:[User sharedUser].token
                                };
    [parameters setObject:userToken forKey:USERTOKEN];
    
    [_manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        NSDictionary *response = responseObject;
        if ([[[response objectForKey:CODE] stringValue] isEqualToString:@"0"]) {
            if (complete) {
                complete(YES);
            }
        } else {
            NSString *message = [response objectForKey:MESSAGE];
            [JDStatusBarNotification showWithStatus:message dismissAfter:2];
            if (complete) {
                complete(NO);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
        if (failure) {
            failure();
        }
        [JDStatusBarNotification showWithStatus:ERROR_NETWORK dismissAfter:2];
    }];
}

- (void)getCostListWithDateString:(NSString *)dateString storeId:(NSString *)storeId Completion:(void (^)(BOOL, NSArray *))complete failure:(void (^)())failure {
    NSString *url = [_baseURL stringByAppendingString:@"GetTaxsaletotalbyobjectname"];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[User sharedUser].companyID forKey:COMPANYID];
	if (storeId == nil || [storeId isEqualToString:@""]) {
		[parameters setObject:@"1" forKey:POSITIONS];
	} else {
		[parameters setObject:storeId forKey:STOREID];
		[parameters setObject:@"4" forKey:POSITIONS];
	}

	[parameters setObject:dateString forKey:STARTDATE];
    NSDictionary *userToken = @{
                                USERID:[User sharedUser].userID,
                                TOKEN:[User sharedUser].token
                                };
    [parameters setObject:userToken forKey:USERTOKEN];
    
    [_manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        NSDictionary *response = responseObject;
        if ([[[response objectForKey:CODE] stringValue] isEqualToString:@"0"]) {
            NSArray *result = [response objectForKey:RESULT];
            NSArray *costList = [ListData costListWithResult:result];
            if (complete) {
                complete(YES, costList);
            }
        } else {
            NSString *message = [response objectForKey:MESSAGE];
            [JDStatusBarNotification showWithStatus:message dismissAfter:2];
            if (complete) {
                complete(NO, nil);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
        if (failure) {
            failure();
        }
        [JDStatusBarNotification showWithStatus:ERROR_NETWORK dismissAfter:2];
    }];
}

- (void)getCostOrderListWithName:(NSString *)name
						 storeId:(NSString *)storeId
					  dateString:(NSString *)dateString
                       pageIndex:(NSInteger)pageIndex
                       pageSize:(NSInteger)pageSize
                      completion:(void (^)(BOOL, NSArray *))complete failure:(void (^)())failure {
    NSString *url = [_baseURL stringByAppendingString:@"GetTaxsaletotaldescbyobjectname"];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[User sharedUser].companyID forKey:COMPANYID];
	if (storeId == nil || [storeId isEqualToString:@""]) {
		[parameters setObject:@"1" forKey:POSITIONS];
	} else {
		[parameters setObject:storeId forKey:STOREID];
		[parameters setObject:@"4" forKey:POSITIONS];
	}
	[parameters setObject:dateString forKey:STARTDATE];
    [parameters setObject:name forKey:@"CostObjectName"];
    [parameters setObject:[NSNumber numberWithInteger:pageIndex] forKey:@"pageIndex"];
    [parameters setObject:[NSNumber numberWithInteger:pageSize] forKey:@"pageSize"];
    NSDictionary *userToken = @{
                                USERID:[User sharedUser].userID,
                                TOKEN:[User sharedUser].token
                                };
    [parameters setObject:userToken forKey:USERTOKEN];
    
    [_manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        NSDictionary *response = responseObject;
        if ([[[response objectForKey:CODE] stringValue] isEqualToString:@"0"]) {
            NSArray *result = [response objectForKey:RESULT];
            NSArray *costOrderList = [ListData costOrderListWithResult:result];
            if (complete) {
                complete(YES, costOrderList);
            }
        } else {
            NSString *message = [response objectForKey:MESSAGE];
            [JDStatusBarNotification showWithStatus:message dismissAfter:2];
            if (complete) {
                complete(NO, nil);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
        if (failure) {
            failure();
        }
        [JDStatusBarNotification showWithStatus:ERROR_NETWORK dismissAfter:2];
    }];
}

- (void)getCostOrderDescWithId:(NSString *)idStr completion:(void (^)(BOOL, CostOrderDesc *))complete failure:(void (^)())failure {
    NSString *url = [_baseURL stringByAppendingString:@"GetTaxsaletotalDesc"];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:idStr forKey:@"Id"];
    NSDictionary *userToken = @{
                                USERID:[User sharedUser].userID,
                                TOKEN:[User sharedUser].token
                                };
    [parameters setObject:userToken forKey:USERTOKEN];
    
    [_manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        NSDictionary *response = responseObject;
        if ([[[response objectForKey:CODE] stringValue] isEqualToString:@"0"]) {
            NSDictionary *result = [response objectForKey:RESULT];
            CostOrderDesc *desc = [ListData costOrderDescWithResult:result];
            if (complete) {
                complete(YES, desc);
            }
        } else {
            NSString *message = [response objectForKey:MESSAGE];
            [JDStatusBarNotification showWithStatus:message dismissAfter:2];
            if (complete) {
                complete(NO, nil);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
        if (failure) {
            failure();
        }
        [JDStatusBarNotification showWithStatus:ERROR_NETWORK dismissAfter:2];
    }];
}

@end
