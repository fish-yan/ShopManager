//
//  ProductViewController.m
//  BTB
//
//  Created by 薛焱 on 16/2/16.
//  Copyright © 2016年 薛焱. All rights reserved.
//

#import "ProductViewController.h"
#import "TitleCell.h"
#import "ProductTitleCell.h"
#import "TypeCell.h"
#import "MoreValuationCell.h"
#import "ValuationTableViewCell.h"
#import "UIViewController+KNSemiModal.h"
#import "CartView.h"
#import "ProductDetailCell.h"
#import "SubmitOrderViewController.h"

@interface ProductViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIScrollView *headerScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *headerPageControl;
@property (weak, nonatomic) IBOutlet UITableView *productTableView;
@property (weak, nonatomic) IBOutlet UIButton *addCartButton;
@property (nonatomic, strong) UIButton *productDetailButton;
@property (nonatomic, strong) UIButton *productParameterButton;
@property (nonatomic, strong) NSLayoutConstraint *moveViewLeftMargin;
@property (nonatomic, strong) NSString *typeStr;

@end

@implementation ProductViewController

- (void)viewDidLoad {
   [super viewDidLoad];
   self.navigationController.navigationBar.hidden = NO;
   // Do any additional setup after loading the view.
}

- (IBAction)backButtonAction:(UIBarButtonItem *)sender {
   [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)addCartButtonAction:(UIButton *)sender {
   CartView *cartView = [[[NSBundle mainBundle]loadNibNamed:@"CartView" owner:self options:nil] lastObject];
   cartView.frame = CGRectMake(0, kScreenHeight - 380, kScreenWidth, 380);
   [cartView.closeButton addTarget:self action:@selector(closeButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
   [cartView.addCartButton setTitle:sender.titleLabel.text forState:(UIControlStateNormal)];
   [cartView.addCartButton addTarget:self action:@selector(addGoodsToCart:) forControlEvents:(UIControlEventTouchUpInside)];
   if (self.typeStr != nil) {
      cartView.typeLabel.text = self.typeStr;
   }
   [self presentSemiView:cartView];
}

- (void)addGoodsToCart:(UIButton *)sender{
   if ([sender.titleLabel.text isEqualToString:@"立即购买"]) {
      [self closeButtonAction:sender];
      [self performSelector:@selector(pushToSubmit:) withObject:nil afterDelay:0.5];
      
   }else{
      //加入购物车
      
      [self performSelector:@selector(closeButtonAction:) withObject:sender afterDelay:1];
   }
}
//跳转到确认订单页面
- (void)pushToSubmit:(UIButton *)sender{
   SubmitOrderViewController *submitOrderVC = [[UIStoryboard storyboardWithName:@"ShoppingCart" bundle:nil] instantiateViewControllerWithIdentifier:@"SubmitOrderViewController"];
   [self.navigationController pushViewController:submitOrderVC animated:YES];
}

- (void)closeButtonAction:(UIButton *)sender{
   CartView *cartView = (CartView *)sender.superview.superview;
   
   if (![cartView isKindOfClass:[CartView class]]) {
      cartView = (CartView *)sender.superview;
   }
   self.typeStr = cartView.typeLabel.text;
   NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
   [self.productTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationAutomatic)];
   [self dismissSemiModalView];
}

- (void)productDetailButtonAction:(UIButton *)sender{
   [self.productDetailButton setTitleColor:UIColorFromRGB(0x3c3c3c) forState:(UIControlStateNormal)];
   [self.productParameterButton setTitleColor:UIColorFromRGB(0xc3c3c3) forState:(UIControlStateNormal)];
   self.moveViewLeftMargin.constant = 0;
   [UIView animateWithDuration:0.3 animations:^{
      [self.view layoutIfNeeded];
   }];
}

- (void)productParameterButtonAction:(UIButton *)sender{
   [self.productDetailButton setTitleColor:UIColorFromRGB(0xc3c3c3) forState:(UIControlStateNormal)];
   [self.productParameterButton setTitleColor:UIColorFromRGB(0x3c3c3c) forState:(UIControlStateNormal)];
   self.moveViewLeftMargin.constant = kScreenWidth / 2;
   [UIView animateWithDuration:0.3 animations:^{
      [self.view layoutIfNeeded];
   }];
}

- (void)didReceiveMemoryWarning {
   [super didReceiveMemoryWarning];
   // Dispose of any resources that can be recreated.
}



#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
   return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
   switch (section) {
      case 0:
         return 1;
      case 1:
         return 1;
      case 2:
         return 3;
      default:
         return 1;
   }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   if (indexPath.section == 0) {
      ProductTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProductTitleCell" forIndexPath:indexPath];
      return cell;
   } else if (indexPath.section == 1) {
      TypeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TypeCell" forIndexPath:indexPath];
      if (self.typeStr != nil) {
         cell.typeLabel.text = self.typeStr;
      }
      return cell;
   } else if (indexPath.section == 2) {
      if (indexPath.row == 0) {
         TitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TitleCell" forIndexPath:indexPath];
         return cell;
      }else if (indexPath.row == 1) {
         ValuationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ValuationTableViewCell" forIndexPath:indexPath];
         [cell setStaredViewCount:2.5];
         return cell;
      }else{
         MoreValuationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MoreValuationCell" forIndexPath:indexPath];
         return cell;
      }
   }else{
      ProductDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProductDetailCell" forIndexPath:indexPath];
      self.productDetailButton = cell.productDetailButton;
      self.productParameterButton = cell.productParameterButton;
      [self.productDetailButton addTarget:self action:@selector(productDetailButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
      [self.productParameterButton addTarget:self action:@selector(productParameterButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
      self.moveViewLeftMargin = cell.moveViewLeftMargin;
      return cell;
   }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
   UIView *aView = [[UIView alloc]init];
   return aView;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
   [tableView deselectRowAtIndexPath:indexPath animated:YES];
   if (indexPath.section == 1) {
      [self addCartButtonAction:self.addCartButton];
   }
   if (indexPath.section == 2 && indexPath.row == 2) {
      [self performSegueWithIdentifier:@"moreValuation" sender:self];
   }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
   return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   switch (indexPath.section) {
      case 0:
         return 150;
      case 1:
         return 50;
      case 2:
         switch (indexPath.row) {
            case 1:
               tableView.estimatedRowHeight = 200;
               return UITableViewAutomaticDimension;
               
            default:
               return 50;
         }
         
      default:
         return 50;
   }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
   self.headerPageControl.currentPage = scrollView.contentOffset.x / [UIScreen mainScreen].bounds.size.width;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
