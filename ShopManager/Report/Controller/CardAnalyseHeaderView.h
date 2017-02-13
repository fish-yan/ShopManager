//
//  CardAnalyseHeaderView.h
//  ShopManager
//
//  Created by 张旭 on 20/11/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardAnalyseHeaderView : UIView

@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UILabel *moneyL;
@property (weak, nonatomic) IBOutlet UILabel *costL;
@property (weak, nonatomic) IBOutlet UILabel *profitL;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UIView *thirdImage;
@property (weak, nonatomic) IBOutlet UILabel *thirdTitleL;

@property (strong, nonatomic) NSString *jsStr;

@end
