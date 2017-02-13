//
//  FrontReportFirstView.h
//  ShopManager
//
//  Created by 张旭 on 10/11/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FrontReportVM.h"

@interface FrontReportFirstView : UIView

@property (strong, nonatomic) NSString *jsStr;

@property (copy, nonatomic) void(^ detailBlock)();

@property (strong, nonatomic) FrontReportVM *viewModel;

@end
