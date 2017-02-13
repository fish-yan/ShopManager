//
//  ShoppingCartItem.m
//  Cjmczh
//
//  Created by 张旭 on 1/28/16.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import "ShoppingCartItem.h"

@implementation ShoppingCartItem

- (instancetype)init {
    self.isSelected = NO;
    self.image = nil;
    self.title = @"";
    self.price = 20.00;
    self.amount = 1;
    self.id = @"";
    return self;
}

@end
