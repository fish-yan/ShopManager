//
//  ShoppingCart.h
//  Cjmczh
//
//  Created by 张旭 on 1/28/16.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShoppingCartItem.h"

@interface ShoppingCart : NSObject

@property (strong, nonatomic) NSMutableArray *goods;
@property (readonly, nonatomic) NSInteger selectedGoodsCount;

+ (instancetype)cart;

- (void)addNewGood:(ShoppingCartItem *)good;

- (void)selectAllGoods;

- (void)unselectAllGoods;

- (void)triggerGoodAtIndex:(NSInteger)index;

- (void)deleteSelectedGood;

- (void)addAmountAtIndex:(NSInteger)index;

- (void)minusAmountAtIndex:(NSInteger)index;

@end
