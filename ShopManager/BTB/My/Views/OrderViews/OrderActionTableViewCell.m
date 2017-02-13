//
//  OrderActionTableViewCell.m
//  Cjmczh
//
//  Created by cjm-ios on 15/12/25.
//  Copyright © 2015年 Cjm. All rights reserved.
//

#import "OrderActionTableViewCell.h"

@implementation OrderActionTableViewCell

- (void)awakeFromNib {
    
    self.cancelBtn.layer.borderWidth = 0.5;
    self.cancelBtn.layer.borderColor = UIColorFromRGB(0xdddddd).CGColor;
    self.commitBtn.layer.borderColor = UIColorFromRGB(0xdddddd).CGColor;
    self.cancelBtn.layer.cornerRadius = 3;
    self.commitBtn.layer.cornerRadius = 3;
    
}

- (void)setOrderType:(NSString *)orderType{
    _orderType = orderType;
    if ([_orderType isEqualToString:ReadySend]) {
        self.cancelBtn.hidden = YES;
        self.commitBtn.layer.borderWidth = 0.5;
        self.commitBtn.backgroundColor = [UIColor clearColor];
        [self.commitBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    }else{
        self.cancelBtn.hidden = NO;
        self.commitBtn.layer.borderWidth = 0;
        [self.commitBtn setBackgroundColor:UIColorFromRGB(0x049CD4)];
        [self.commitBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    }
    if ([_orderType isEqualToString:ReadyPay]) {
        [self.commitBtn setTitle:@"付款" forState:UIControlStateNormal];
        [self.cancelBtn setTitle:@"取消订单" forState:UIControlStateNormal];
    }else if ([_orderType isEqualToString:ReadyRecev]) {
        [self.cancelBtn setTitle:@"查看物流" forState:UIControlStateNormal];
        [self.commitBtn setTitle:@"确认收货" forState:UIControlStateNormal];
    }else if ([_orderType isEqualToString:ReadySend]) {
        
        [self.commitBtn setTitle:@"提醒发货" forState:UIControlStateNormal];
    }else if ([_orderType isEqualToString:ReadyCheck]){
        [self.cancelBtn setTitle:@"取消订单" forState:UIControlStateNormal];
        [self.commitBtn setTitle:@"待审核" forState:UIControlStateNormal];
    }else{
        [self.cancelBtn setTitle:@"查看物流" forState:UIControlStateNormal];
        [self.commitBtn setTitle:@"待评价" forState:UIControlStateNormal];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}



@end
