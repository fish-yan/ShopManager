//
//  ShoppingCart.m
//  Cjmczh
//
//  Created by 张旭 on 1/28/16.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import "ShoppingCart.h"

@interface ShoppingCart ()

@property (assign, nonatomic) NSInteger selectedGoodsCount;

@end

@implementation ShoppingCart

static ShoppingCart *sharedInstance = nil;

- (instancetype)init {
    self = [super init];
    self.goods = [NSMutableArray array];
    return self;
}

+ (instancetype)cart {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)addNewGood:(ShoppingCartItem *)good {
    [self.goods addObject:good];
}

- (void)selectAllGoods {
    for (ShoppingCartItem *good in self.goods) {
        if (!good.isSelected) {
            self.selectedGoodsCount += 1;
        }
        good.isSelected = YES;
    }
}

- (void)unselectAllGoods {
    for (ShoppingCartItem *good in self.goods) {
        if (good.isSelected) {
            self.selectedGoodsCount -= 1;
        }
        good.isSelected = NO;
    }
}

- (void)triggerGoodAtIndex:(NSInteger)index {
    ShoppingCartItem *item = [self.goods objectAtIndex:index];
    if (item.isSelected) {
        item.isSelected = NO;
        self.selectedGoodsCount -= 1;
    } else {
        item.isSelected = YES;
        self.selectedGoodsCount += 1;
    }
}

- (void)deleteSelectedGood {
    NSMutableArray *deleteArray = [NSMutableArray array];
    for (NSInteger i = 0; i < self.goods.count; ++i) {
        ShoppingCartItem *good = [self.goods objectAtIndex:i];
        if (good.isSelected) {
            [deleteArray addObject:good];
            self.selectedGoodsCount -= 1;
        }
    }
    [self.goods removeObjectsInArray:deleteArray];
}

- (void)addAmountAtIndex:(NSInteger)index {
    ShoppingCartItem *good = [self.goods objectAtIndex:index];
    good.amount += 1;
}

- (void)minusAmountAtIndex:(NSInteger)index {
    ShoppingCartItem *good = [self.goods objectAtIndex:index];
    good.amount -= 1;
    good.amount = good.amount < 0 ? 0 : good.amount;
}

@end
