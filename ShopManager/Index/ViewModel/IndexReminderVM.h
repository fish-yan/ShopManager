//
//  ReminderVM.h
//  ShopManager
//
//  Created by 张旭 on 24/10/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import "RequestViewModel.h"

@interface IndexReminderVM : RequestViewModel

@property (strong, nonatomic) NSString *birthdayNum;
@property (strong, nonatomic) NSString *appointmentNum;
@property (strong, nonatomic) NSString *serviceDueNum;
@property (strong, nonatomic) NSString *cardDueNum;

@property (strong, nonatomic) NSString *birthdayCode;
@property (strong, nonatomic) NSString *appointmentCode;
@property (strong, nonatomic) NSString *serviceDueCode;
@property (strong, nonatomic) NSString *cardDueCode;

- (void)requestWithComplete:(void(^)(BOOL success))complete failure:(void(^)())failure;

@end
