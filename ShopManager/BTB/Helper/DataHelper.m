//
//  DataHelper.m
//  BTB
//
//  Created by 薛焱 on 16/3/4.
//  Copyright © 2016年 薛焱. All rights reserved.
//

#import "DataHelper.h"
#import "CategoryModel.h"
#import "ProductModel.h"
#import "CarModel.h"

@implementation DataHelper
+ (void)loadDataWithSuffixUrlStr:(NSString *)suffixUrlStr parameters:(id)parameters block:(void (^) (id responseObject))block{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", kRequestHeader, suffixUrlStr];
    NSLog(@"%@",urlStr);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    [manager GET:urlStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        block(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error.description);
    }];
}

+ (NSDictionary *)praserCategoryDataWithResponseObject:(id)responseObject{
    NSArray *resultArray = responseObject[@"result"];
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    for (NSDictionary *pDict in resultArray) {
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *dict in pDict[@"arr"]) {
            CategoryModel *model = [[CategoryModel alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            [array addObject:model];
        }
        [dataDict setObject:array forKey:pDict[@"pname"]];
    }
    return dataDict;
}

+ (NSArray *)praserSearchBeforDataWithResponseObject:(id)responseObject{
    NSMutableArray *dataArray = [NSMutableArray array];
    for (NSDictionary *dict in responseObject[@"reslist"]) {
        ProductModel *model = [[ProductModel alloc]init];
        [model setValuesForKeysWithDictionary:dict];
        [dataArray addObject:model];
    }
    return dataArray;
}

+ (NSDictionary *)praserCarTypeDataWithResponseObject:(id)responseObject{
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    for (NSDictionary *zmNameDict in responseObject[@"reslist"]) {
        NSMutableDictionary *carbrandNamedic = [NSMutableDictionary dictionary];
        for (NSDictionary *carbrandNameDict in zmNameDict[@"CarbrandList"]) {
            NSMutableDictionary *carseriesNameDic = [NSMutableDictionary dictionary];
            for (NSDictionary *carseriesNameDict in carbrandNameDict[@"CarseriesList"]) {
                NSMutableArray *carmodelNameArray = [NSMutableArray array];
                for (NSDictionary *carmodelNameDict in carseriesNameDict[@"CarModelList"]) {
                    CarModel *model = [[CarModel alloc]init];
                    model.CarmodelName = [NSString stringWithFormat:@"%@ %@ %@",carbrandNameDict[@"CarbrandName"],carseriesNameDict[@"CarseriesName"],carmodelNameDict[@"CarmodelName"]];
                    [carmodelNameArray addObject:model];
                }
                [carseriesNameDic setObject:carmodelNameArray forKey:carseriesNameDict[@"CarseriesName"]];
            }
            [carbrandNamedic setObject:carseriesNameDic forKey:carbrandNameDict[@"CarbrandName"]];
        }
        [dataDict setObject:carbrandNamedic forKey:zmNameDict[@"ZmName"]];
    }
    return dataDict;
}

+ (NSArray *)praserRecommendDataWithResponseObject:(id)responseObject{
    NSMutableArray *dataArray = [NSMutableArray array];
    for (NSDictionary *dict in responseObject[@"reslist"]) {
        ProductModel *model = [[ProductModel alloc]init];
        [model setValuesForKeysWithDictionary:dict];
        [dataArray addObject:model];
    }
    return dataArray;
}

@end
