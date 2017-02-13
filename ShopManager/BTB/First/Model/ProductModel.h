//
//  ProductModel.h
//  BTB
//
//  Created by 薛焱 on 16/3/7.
//  Copyright © 2016年 薛焱. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductModel : NSObject
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *productName;
@property (nonatomic, copy) NSNumber *price;
@property (nonatomic, copy) NSNumber *priceBefore;
@end
