//
//  EditableTableViewCell.m
//  Cjmczh
//
//  Created by 张旭 on 12/17/15.
//  Copyright © 2015 Cjm. All rights reserved.
//

#import "EditableTableViewCell.h"

@implementation EditableTableViewCell

- (void)awakeFromNib {
    [self.editText setReturnKeyType:UIReturnKeyDone];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
