//
//  CartView.m
//  BTB
//
//  Created by 薛焱 on 16/2/17.
//  Copyright © 2016年 薛焱. All rights reserved.
//

#import "CartView.h"
#import "CartBuyCountCell.h"
#import "CartCategoryCell.h"

@interface CartView ()
@property (nonatomic ,strong) NSArray *buttonArray;

@end

@implementation CartView


- (void)awakeFromNib{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.photo.layer.borderColor = UIColorFromRGB(0xe5e5e5).CGColor;
    self.photo.layer.borderWidth = 1;
    self.photo.layer.cornerRadius = 3;
    self.photo.layer.masksToBounds = YES;
    [self.tableView registerNib:[UINib nibWithNibName:@"CartCategoryCell" bundle:nil] forCellReuseIdentifier:@"CartCategoryCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"CartBuyCountCell" bundle:nil] forCellReuseIdentifier:@"CartBuyCountCell"];
    
}

- (void)buttonAction:(UIButton *)sender{
    for (UIButton *button in self.buttonArray) {
        button.backgroundColor = [UIColor whiteColor];
        [button setTitleColor:UIColorFromRGB(0x3c3c3c) forState:(UIControlStateNormal)];
    }
    sender.backgroundColor = UIColorFromRGB(0x049CD4);
    [sender setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",sender.tag * 100.00];
    self.countLabel.text = [NSString stringWithFormat:@"库存: %ld", sender.tag * 345];
    self.typeLabel.text = [NSString stringWithFormat:@"已选: %@", sender.titleLabel.text];
    
}
- (IBAction)addGoodsToCart:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"立即购买"]) {
        //立即购买不执行动画
        return;
    }
    UIImageView *cartAnimView = [[UIImageView alloc] initWithFrame:self.photo.frame];
    cartAnimView.image = self.photo.image;
    [self addSubview:cartAnimView];
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 11.0 ];
    rotationAnimation.duration = 1.0;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 0;
    
    //这个是让旋转动画慢于缩放动画执行
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [cartAnimView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    });
    
    [UIView animateWithDuration:1.0 animations:^{
        cartAnimView.frame=CGRectMake(kScreenWidth-55, -(kScreenHeight - CGRectGetHeight(self.frame) - 40), 0, 0);
    } completion:^(BOOL finished) {
        [cartAnimView removeFromSuperview];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        CartCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CartCategoryCell" forIndexPath:indexPath];
        self.buttonArray = cell.categoryButtons;
        for (UIButton *button in cell.categoryButtons) {
            
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:(UIControlEventTouchUpInside)];
            
            if ([[NSString stringWithFormat:@"已选: %@", button.titleLabel.text] isEqualToString:self.typeLabel.text]) {
                [self buttonAction:button];
            }
        }
        return cell;
    }else{
        CartBuyCountCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CartBuyCountCell" forIndexPath:indexPath];
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            return 150;
            
        default:
            return 50;
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
