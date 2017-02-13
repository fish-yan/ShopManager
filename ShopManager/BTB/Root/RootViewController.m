//
//  RootViewController.m
//  BTB
//
//  Created by 薛焱 on 16/2/3.
//  Copyright © 2016年 薛焱. All rights reserved.
//

#import "RootViewController.h"
#import "FirstViewController.h"


@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UITabBar appearance] setTintColor:UIColorFromRGB(0x049CD4)];
    
    UINavigationController *firstNVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController];
    firstNVC.title = @"首页";
    firstNVC.tabBarItem.image = [UIImage imageNamed:@"shouye-normal"];
    
    UINavigationController *brandNVC = [[UIStoryboard storyboardWithName:@"Brand" bundle:nil] instantiateInitialViewController];
    brandNVC.title = @"品牌";
    brandNVC.tabBarItem.image = [UIImage imageNamed:@"pinpai"];
    
    UINavigationController *shopingCartNVC = [[UIStoryboard storyboardWithName:@"ShoppingCart" bundle:nil] instantiateInitialViewController];
    shopingCartNVC.title = @"购物车";
    shopingCartNVC.tabBarItem.image = [UIImage imageNamed:@"gouwuche-normal"];
    
    UINavigationController *mineNVC = [[UIStoryboard storyboardWithName:@"My" bundle:nil] instantiateInitialViewController];
    mineNVC.title = @"我的";
    mineNVC.tabBarItem.image = [UIImage imageNamed:@"wode-normal"];
    
    self.viewControllers = @[firstNVC, brandNVC, shopingCartNVC, mineNVC];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
