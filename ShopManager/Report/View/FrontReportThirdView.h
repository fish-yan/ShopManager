//
//  FrontReportThirdView.h
//  ShopManager
//
//  Created by 张旭 on 10/11/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FrontReportVM.h"

@interface FrontReportThirdView : UIView

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;

@property (strong, nonatomic) NSString *jsStr;

@property (strong, nonatomic) FrontReportVM *viewModel;

@end
