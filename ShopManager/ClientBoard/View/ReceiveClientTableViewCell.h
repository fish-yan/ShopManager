//
//  ReceiveClientTableViewCell.h
//  ShopManager
//
//  Created by 张旭 on 19/10/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReceiveClientTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *carNumL;
@property (weak, nonatomic) IBOutlet UILabel *phoneL;
@property (weak, nonatomic) IBOutlet UILabel *birthdayL;
@property (weak, nonatomic) IBOutlet UILabel *clientManagerL;

@end
