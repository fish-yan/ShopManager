//
//  DataHelper.h
//  BTB
//
//  Created by 薛焱 on 16/3/4.
//  Copyright © 2016年 薛焱. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataHelper : NSObject

+ (void)loadDataWithSuffixUrlStr:(NSString *)suffixUrlStr parameters:(id)parameters block:(void (^) (id responseObject))block;
/**
 *  搜索商品类目
 */
+ (NSDictionary *)praserCategoryDataWithResponseObject:(id)responseObject;
/**
 *  搜索页面
 */
+ (NSArray *)praserSearchBeforDataWithResponseObject:(id)responseObject;
/**
 *  车型车系
 */
+ (NSDictionary *)praserCarTypeDataWithResponseObject:(id)responseObject;
/**
 *首页推荐
 */
+ (NSArray *)praserRecommendDataWithResponseObject:(id)responseObject;
/**
 *
 */

@end
