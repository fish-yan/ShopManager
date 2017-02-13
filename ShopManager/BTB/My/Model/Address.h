//
//  Address.h
//  Cjmczh
//
//  Created by 张旭 on 12/24/15.
//  Copyright © 2015 Cjm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Address : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *province;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *area;
@property (strong, nonatomic) NSString *addressDetail;
@property (assign, nonatomic) BOOL isDefault;

@end
