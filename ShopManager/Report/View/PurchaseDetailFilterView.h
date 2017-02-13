//
//  PurchaseDetailFilterView.h
//  ShopManager
//
//  Created by 张旭 on 07/11/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PurchaseDetailFilterView : UIView

- (void)show;

@property (strong, nonatomic) NSString *startDateText;
@property (strong, nonatomic) NSString *endDateText;

@property (copy, nonatomic) void(^ confirmBlock)(NSString *startDate, NSString *endDate, NSString *searchText, NSString *storage, NSString *settleType, NSString *orderType);

@end
