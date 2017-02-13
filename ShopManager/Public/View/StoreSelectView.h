//
//  StoreSelectView.h
//  ShopManager
//
//  Created by 张旭 on 28/10/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoreSelectView : UIView

- (void)show;

@property (copy, nonatomic) void(^ confirmBlock)(NSString * name, NSString *idStr);

@end
