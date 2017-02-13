//
//  CostListHeaderView.h
//  ShopManager
//
//  Created by 张旭 on 07/11/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CostListHeaderView : UIView

@property (weak, nonatomic) IBOutlet UILabel *storeNameL;

@property (strong, nonatomic) NSString *jsStr;

@property (copy, nonatomic) void(^ chartBlock)(NSInteger i);

@end
