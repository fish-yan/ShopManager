//
//  RequestViewModel.h
//  BTBSeller
//
//  Created by 张旭 on 8/18/16.
//  Copyright © 2016 CJM. All rights reserved.
//

#import "BaseViewModel.h"

@interface RequestViewModel : BaseViewModel

@property(strong, nonatomic) AFHTTPSessionManager *sessionManager;
@property(strong, nonatomic) AFHTTPSessionManager *oldSessionManager;

@end
