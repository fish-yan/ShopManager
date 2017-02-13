//
//  AddressViewController.h
//  Cjmczh
//
//  Created by 张旭 on 12/17/15.
//  Copyright © 2015 Cjm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Address.h"

@interface AddressViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

- (void)addNewAddress:(Address *)addr;
@end
