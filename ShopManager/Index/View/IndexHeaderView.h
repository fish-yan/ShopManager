//
//  IndexHeaderView.h
//  ShopManager
//
//  Created by 张旭 on 18/10/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IndexHeaderView : UIView

@property (strong, nonatomic) NSString *jsStr;

@property (copy, nonatomic) void(^ chartBlock)(NSInteger index);

@end
