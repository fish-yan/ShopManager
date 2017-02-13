//
//  CostOrderListViewController.h
//  ShopManager
//
//  Created by 张旭 on 6/14/16.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CostOrderListViewController : UIViewController

@property (strong, nonatomic) NSString *costObjectName;
@property (assign, nonatomic) NSInteger selectedIndex;

@property (strong, nonatomic) NSString *storeName;
@property (strong, nonatomic) NSString *storeId;

@end
