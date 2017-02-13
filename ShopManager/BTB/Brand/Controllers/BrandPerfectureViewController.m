//
//  BrandPerfectureViewController.m
//  BTB
//
//  Created by 薛焱 on 16/2/15.
//  Copyright © 2016年 薛焱. All rights reserved.
//

#import "BrandPerfectureViewController.h"
#import "SearchResultCell.h"
#import "ProductViewController.h"
#import "CategoryView.h"

@interface BrandPerfectureViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *categoryButton;
@end

@implementation BrandPerfectureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self headerRequest];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self footRequest];
    }];
    // Do any additional setup after loading the view.
}
- (IBAction)backItemAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)categoryButtonAction:(UIButton *)sender {
    CategoryView *categoryView = [[[NSBundle mainBundle]loadNibNamed:@"CategoryView" owner:self options:nil]lastObject];
    categoryView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    categoryView.topMargin.constant = 172;
    categoryView.widthMargin.constant = kScreenWidth/3;
    [self.tabBarController.view addSubview:categoryView];
    categoryView.block = ^(){
        [self.tableView.mj_header beginRefreshing];
    };
}
- (IBAction)priceButton:(UIButton *)sender {
    [self.tableView.mj_header beginRefreshing];
}
- (IBAction)sellButtonAction:(UIButton *)sender {
    [self.tableView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchResultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchResultCell" forIndexPath:indexPath];
    //    cell.photo.image =
    cell.titleLabel.text = @"快美特正品 双层耐热太阳能烟灰缸 车载烟灰缸 led灯烟灰缸";
    cell.priceLabel.text = @"￥41.22";
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ProductViewController *productVC = [storyboard instantiateViewControllerWithIdentifier:@"detail"];
    [self.navigationController pushViewController:productVC animated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - request
- (void)headerRequest {
    [self.tableView.mj_header endRefreshing];
}

- (void)footRequest {
    [self.tableView.mj_footer endRefreshing];
}
@end
