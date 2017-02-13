//
//  FrontReportVM.h
//  ShopManager
//
//  Created by 张旭 on 10/11/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import "RequestViewModel.h"

@interface FrontReportItemVM : BaseViewModel

@property (strong, nonatomic) NSString *name;
@property (assign, nonatomic) CGFloat xkCount;		//现款销售
@property (assign, nonatomic) CGFloat txkCount;		//退现款
@property (assign, nonatomic) CGFloat gzCount;		//挂账销售
@property (assign, nonatomic) CGFloat tgzCount;		//退现款
@property (assign, nonatomic) CGFloat cysCount;		//冲预收
@property (assign, nonatomic) CGFloat ysxkCount;	//应收现款
@property (assign, nonatomic) CGFloat ysgzCount;	//收回挂账
@property (strong, nonatomic) UIColor *firstColor;
@property (strong, nonatomic) UIColor *secondColor;

@end

@interface FrontReportChartItemVM : BaseViewModel

@property (strong, nonatomic) NSString *type;
@property (assign, nonatomic) CGFloat money;

@end

@interface FrontReportVM : RequestViewModel

@property (strong, nonatomic) NSString *startDate;
@property (strong, nonatomic) NSString *endDate;
@property (strong, nonatomic) NSString *showTime;
@property (strong, nonatomic) NSString *storeName;
@property (strong, nonatomic) NSString *storeId;

@property (assign, nonatomic) CGFloat totalysCount;  //营收合计
@property (assign, nonatomic) CGFloat totalxkCount; //现款合计
@property (assign, nonatomic) CGFloat totaltxkCount; //退现款合计
@property (assign, nonatomic) CGFloat totalgzCount; //挂账合计
@property (assign, nonatomic) CGFloat totaltgzCount; //退挂账现款合计
@property (assign, nonatomic) CGFloat totalysCount2;	 //应收合计
@property (assign, nonatomic) CGFloat totalysxkCount; //应收现款合计
@property (assign, nonatomic) CGFloat totalysgzCount; //应收挂账合计
@property (assign, nonatomic) CGFloat totalcysCount; //冲预收合计

@property (assign, nonatomic) CGFloat totalskCount;

@property (assign, nonatomic) CGFloat yskCount;		//预收款
@property (assign, nonatomic) CGFloat bxyskCount;	//保险应收款
@property (assign, nonatomic) CGFloat bxyskCount2;	//保险预收款
@property (assign, nonatomic) CGFloat bxcysCount;	//保险冲预收

@property (assign, nonatomic) CGFloat alipay;
@property (assign, nonatomic) CGFloat card;		//会员卡
@property (assign, nonatomic) CGFloat point;	//积分
@property (assign, nonatomic) CGFloat jhk;		//建行卡
@property (assign, nonatomic) CGFloat wxsm;		//微信扫码
@property (assign, nonatomic) CGFloat wxzf;		//微信支付
@property (assign, nonatomic) CGFloat wxzz;		//微信转账
@property (assign, nonatomic) CGFloat cashier;

@property (strong, nonatomic) NSArray<FrontReportItemVM *> *listDataSource;

@property (strong, nonatomic) NSArray<FrontReportChartItemVM *> *chartDataSource;

- (void)firstRequestWithCompletion:(void(^)(BOOL success, NSString *jsStr1, NSString *jsStr2, NSString *message))complete failure:(void(^)())failure;


- (void)secondRequestWithCompletion:(void(^)(BOOL success, NSString *jsStr, NSString *message))complete failure:(void(^)())failure;

@end
