//
//  IndexHeaderVM.m
//  ShopManager
//
//  Created by Xu Zhang on 27/11/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import "IndexHeaderVM.h"
#import "StoreList.h"

@implementation IndexHeaderChartItemVM

@end

@interface IndexHeaderVM ()

@property (strong, nonatomic) NSMutableArray<IndexHeaderChartItemVM *> *chartItemList;

@end

@implementation IndexHeaderVM

- (NSMutableArray<IndexHeaderChartItemVM *> *)chartItemList {
    if (_chartItemList == nil) {
        _chartItemList = [NSMutableArray array];
    }
    return _chartItemList;
}

- (void)chartRequestWithCompletion:(void (^)(BOOL, NSString *, NSString *))complete failure:(void (^)())failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[User sharedUser].companyID forKey:COMPANYID];
    if ([StoreList sharedList].selectedId == nil || [[StoreList sharedList].selectedId isEqualToString:@""]) {
        [parameters setObject:@"1" forKey:POSITIONS];
    } else {
        [parameters setObject:@"4" forKey:POSITIONS];
        [parameters setObject:[StoreList sharedList].selectedId forKey:STOREID];
    }
    NSDictionary *userToken = @{
                                USERID:[User sharedUser].userID,
                                TOKEN:[User sharedUser].token
                                };
    [parameters setObject:userToken forKey:USERTOKEN];

    [self.oldSessionManager POST:@"GetSaleFrontTotal" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        NSDictionary *response = responseObject;
        if ([[response[CODE] stringValue] isEqualToString:@"0"]) {
            NSArray *chartList = response[RESULT];
			[self.chartItemList removeAllObjects];
            for (NSDictionary *chart in chartList) {
                IndexHeaderChartItemVM *item = [[IndexHeaderChartItemVM alloc] init];
                item.date = chart[@"DateTime"];
                item.money = [chart[@"SaleTotal"] doubleValue];
                [self.chartItemList addObject:item];
            }
            self.chartDataSource = [self.chartItemList copy];
            NSString *jsStr = [self jsStr];
            if (complete) {
                complete(YES, jsStr, nil);
            }
        } else {
            if (complete) {
                complete(NO, nil, response[MESSAGE]);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error.localizedDescription);
        if (failure) {
            failure();
        }
    }];
}

- (NSString *)jsStr {
    NSString *jsStr = @"var list = new Array();";
    NSDate *today = [NSDate date];
    NSInteger days = [today daysInMonth];
    NSInteger day = [today day];
    for (NSInteger i = 1; i <= days; ++i) {
        if (i <= self.chartDataSource.count) {
            IndexHeaderChartItemVM *item = self.chartDataSource[i-1];
            jsStr = [jsStr stringByAppendingString:[NSString stringWithFormat:@"list[%ld] = new Item(%ld, %.2f);", i-1, i, item.money]];
        } else {
            jsStr = [jsStr stringByAppendingString:[NSString stringWithFormat:@"list[%ld] = new Item(%ld, 0);", i-1, i]];
        }
    }
    IndexHeaderChartItemVM *item = nil;
    if (day <= self.chartDataSource.count) {
        item = self.chartDataSource[day-1];
    }
    jsStr = [jsStr stringByAppendingString:[NSString stringWithFormat:@"setData(list, %.2f, '今日前台营业额（元）', '元', '前台营业额');", item != nil ? item.money : 0]];
    return jsStr;
}

@end
