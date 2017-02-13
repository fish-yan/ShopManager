//
//  SearchViewController.m
//  BTB
//
//  Created by 薛焱 on 16/2/15.
//  Copyright © 2016年 薛焱. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchResultCell.h"
#import "CategoryView.h"
#import "ProductModel.h"

@interface SearchViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *sortImageView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *buttonView;
@property (weak, nonatomic) IBOutlet UILabel *carModelLab;
@property (nonatomic, strong) CategoryView *categoryView;
@property (nonatomic, strong) NSMutableDictionary *paramsDict;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger page;
@end

@implementation SearchViewController

- (void)viewDidAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
    [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self addCategoryView];
    self.dataArray = [NSMutableArray array];
    self.paramsDict = [NSMutableDictionary dictionary];
    self.paramsDict = @{@"pageIndex":@"1", @"pageSize":@"10", @"orderType":@"1", @"priceOrder":@"a", @"twoId":@"", @"searchWord":@""}.mutableCopy;
    self.page = 1;
    [self readDataSource];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.paramsDict[@"pageIndex"] = @"1";
        self.dataArray = [NSMutableArray array];
        [self readDataSource];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.page++;
        self.paramsDict[@"pageIndex"] = [NSString stringWithFormat:@"%ld", self.page];
        [self readDataSource];
    }];
    // Do any additional setup after loading the view.
}

- (void)readDataSource{
    [DataHelper loadDataWithSuffixUrlStr:kSearach parameters:self.paramsDict block:^(id responseObject) {
        NSArray *array = [DataHelper praserSearchBeforDataWithResponseObject:responseObject];
        [self.dataArray addObjectsFromArray:array];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        });
    }];
}

- (void)addCategoryView{
    self.categoryView = [[[NSBundle mainBundle]loadNibNamed:@"CategoryView" owner:self options:nil]lastObject];
    self.categoryView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    self.categoryView.widthMargin.constant = kScreenWidth/4;
    [self.tabBarController.view addSubview:self.categoryView];
    self.categoryView.hidden = YES;
    __block typeof(self) wkSelf = self;
    self.categoryView.block = ^(){
        [wkSelf.tableView.mj_header beginRefreshing];
    };
}

- (IBAction)categoryButtonAction:(UIButton *)sender {
    self.categoryView.hidden = NO;
}

- (IBAction)brandButtonAction:(UIButton *)sender {
    
    [self.tableView.mj_header beginRefreshing];
}
- (IBAction)priceButtonAction:(UIButton *)sender {
    self.paramsDict[@"orderType"] = @"1";
    if ([self.paramsDict[@"priceOrder"] isEqualToString:@"a"]) {
        self.paramsDict[@"priceOrder"] = @"b";
    }else{
        self.paramsDict[@"priceOrder"] = @"a";
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.sortImageView.transform = CGAffineTransformRotate(self.sortImageView.transform, M_PI);
    }];
    [self.tableView.mj_header beginRefreshing];
}
- (IBAction)sellButtonAction:(UIButton *)sender {
    self.paramsDict[@"orderType"] = @"2";
    [self.tableView.mj_header beginRefreshing];
}


- (IBAction)dismissButtonAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)unwindSegueToSearchViewController:(UIStoryboardSegue *)sender{
    self.carModelLab.text = self.carModel;
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
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ProductModel *model = self.dataArray[indexPath.row];
    SearchResultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchResultCell" forIndexPath:indexPath];
    [cell.photo sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kRequestHeader, model.image]] placeholderImage:[UIImage imageNamed:@"loading"]];
    cell.titleLabel.text = model.productName;
    cell.priceLabel.text = [NSString stringWithFormat:@"￥%@",model.price];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"detail" sender:self];
}

#pragma mark - request
- (void)headerRequest {
    [self.tableView.mj_header endRefreshing];
}

- (void)footRequest {
    [self.tableView.mj_footer endRefreshing];
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
