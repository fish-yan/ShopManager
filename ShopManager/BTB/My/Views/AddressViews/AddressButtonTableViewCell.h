//
//  AddressButtonTableViewCell.h
//  Cjmczh
//
//  Created by 张旭 on 12/17/15.
//  Copyright © 2015 Cjm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressButtonTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@end
