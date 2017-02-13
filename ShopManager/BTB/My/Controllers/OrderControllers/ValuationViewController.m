//
//  ValuationViewController.m
//  BTB
//
//  Created by 薛焱 on 16/2/17.
//  Copyright © 2016年 薛焱. All rights reserved.
//

#import "ValuationViewController.h"
#import "ValuationCell.h"
#import "ValuationStarCell.h"

@interface ValuationViewController ()<UITableViewDataSource, UITableViewDelegate, UITextViewDelegate>

@end

@implementation ValuationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)backItem:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)submit:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        ValuationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ValuationCell" forIndexPath:indexPath];
        cell.valuationTextView.delegate = self;
        return cell;
    }else{
        ValuationStarCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ValuationStarCell" forIndexPath:indexPath];
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 150;
    }else{
        return 50;
    }
}


#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView{
    if ([textView.text  isEqual: @"写下对商品的感受, 对别人帮助很大哦"]) {
       textView.text = nil;
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"写下对商品的感受, 对别人帮助很大哦";
    }
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
