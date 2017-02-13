//
//  ShoppingCartViewController.m
//  Cjmczh
//
//  Created by cjm-ios on 15/12/21.
//  Copyright © 2015年 Cjm. All rights reserved.
//

#import "ShoppingCartViewController.h"
#import "ShoppingCartTableViewCell.h"
#import "ShoppingCart.h"
#import "ProductViewController.h"
NSString *sctCell = @"sctCell";

@interface ShoppingCartViewController ()
@property (weak, nonatomic) IBOutlet UIView *settlementView;
@property (weak, nonatomic) IBOutlet UIButton *deleteAllSelectButton;
@property (weak, nonatomic) IBOutlet UIButton *settleAllSelectButton;

@property (strong, nonatomic) UIBarButtonItem *rightBarButton;
@property (assign, nonatomic) BOOL isEditting;
@end

@implementation ShoppingCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self request];
    }];
    _goBtn.layer.borderColor = UIColorFromRGB(0x049CD4).CGColor;
    UINib *nib = [UINib nibWithNibName:@"ShoppingCartTableViewCell" bundle:nil];
    [_tableView registerNib:nib forCellReuseIdentifier:sctCell];
    
    for (NSInteger i = 0; i < 3; ++i) {
        [[ShoppingCart cart] addNewGood:[[ShoppingCartItem alloc] init]];
    }
    self.rightBarButton = self.navigationItem.rightBarButtonItem;
    if ([[ShoppingCart cart] goods].count == 0) {
        [self.dataView setHidden:YES];
        [self.emptyView setHidden:NO];
        self.navigationItem.rightBarButtonItem = nil;
    } else {
        [self.dataView setHidden:NO];
        [self.emptyView setHidden:YES];
        self.navigationItem.rightBarButtonItem = self.rightBarButton;
    }
}

- (IBAction)editClick:(id)sender {
    UIBarButtonItem *button = sender;
    if ([button.title isEqualToString:@"编辑"]) {
        self.isEditting = YES;
        self.settlementView.hidden = YES;
        [button setTitle:@"完成"];
        [self.tableView reloadData];
    } else {
        self.isEditting = NO;
        self.settlementView.hidden = NO;
        [button setTitle:@"编辑"];
        [self.tableView reloadData];
    }
}

- (IBAction)deleteButtonDidTouch:(id)sender {
    [[ShoppingCart cart] deleteSelectedGood];
    [self.tableView reloadData];
    if ([ShoppingCart cart].selectedGoodsCount == 0) {
        [self.settleAllSelectButton setSelected:NO];
        [self.settleAllSelectButton setImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
        [self.deleteAllSelectButton setSelected:NO];
        [self.deleteAllSelectButton setImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
    } else if ([ShoppingCart cart].selectedGoodsCount == [ShoppingCart cart].goods.count) {
        [self.settleAllSelectButton setSelected:YES];
        [self.settleAllSelectButton setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
        [self.deleteAllSelectButton setSelected:YES];
        [self.deleteAllSelectButton setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
    }
    
    if ([[ShoppingCart cart] goods].count == 0) {
        self.isEditting = NO;
        self.navigationItem.rightBarButtonItem = nil;
        [self.dataView setHidden:YES];
        [self.emptyView setHidden:NO];
    } else {
        self.navigationItem.rightBarButtonItem = self.rightBarButton;
        [self.dataView setHidden:NO];
        [self.emptyView setHidden:YES];
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.isEditting = NO;
    [self.tableView reloadData];
    if (self.navigationItem.rightBarButtonItem != nil) {
        [self.navigationItem.rightBarButtonItem setTitle:@"编辑"];
    }
    if ([[ShoppingCart cart] goods].count == 0) {
        self.navigationItem.rightBarButtonItem = nil;
        [self.dataView setHidden:YES];
        [self.emptyView setHidden:NO];
    } else {
        self.navigationItem.rightBarButtonItem = self.rightBarButton;
        [self.dataView setHidden:NO];
        [self.emptyView setHidden:YES];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
}

- (IBAction)commitClick:(id)sender {
    [self performSegueWithIdentifier:@"submitOrder" sender:self];
}

- (IBAction)selectButtonDidTouch:(id)sender {
    UIButton *btn = sender;
    [[ShoppingCart cart] triggerGoodAtIndex:btn.tag];
    if ([ShoppingCart cart].selectedGoodsCount < [ShoppingCart cart].goods.count) {
        [self.settleAllSelectButton setSelected:NO];
        [self.settleAllSelectButton setImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
        [self.deleteAllSelectButton setSelected:NO];
        [self.deleteAllSelectButton setImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
    } else if ([ShoppingCart cart].selectedGoodsCount == [ShoppingCart cart].goods.count) {
        [self.settleAllSelectButton setSelected:YES];
        [self.settleAllSelectButton setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
        [self.deleteAllSelectButton setSelected:YES];
        [self.deleteAllSelectButton setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
    }
    [self.tableView reloadData];
}

- (IBAction)addButtonDidTouch:(id)sender {
    UIButton *button = sender;
    [[ShoppingCart cart] addAmountAtIndex:button.tag];
    [self.tableView reloadData];
}

- (IBAction)minusButtonDidTouch:(id)sender {
    UIButton *button = sender;
    [[ShoppingCart cart] minusAmountAtIndex:button.tag];
    [self.tableView reloadData];
}

- (IBAction)settleAllSelectButtonDidTouch:(id)sender {
    UIButton *button = sender;
    if (!button.isSelected) {
        [button setSelected:YES];
        [button setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
        [self.deleteAllSelectButton setSelected:YES];
        [self.deleteAllSelectButton setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
        [[ShoppingCart cart] selectAllGoods];
        [self.tableView reloadData];
    } else {
        [button setSelected:NO];
        [button setImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
        [self.deleteAllSelectButton setSelected:NO];
        [self.deleteAllSelectButton setImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
        [[ShoppingCart cart] unselectAllGoods];
        [self.tableView reloadData];
    }
}

- (IBAction)deleteAllSelectButtonDidTouch:(id)sender {
    UIButton *button = sender;
    if (!button.isSelected) {
        [button setSelected:YES];
        [button setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
        [self.settleAllSelectButton setSelected:YES];
        [self.settleAllSelectButton setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
        [[ShoppingCart cart] selectAllGoods];
        [self.tableView reloadData];
    } else {
        [button setSelected:NO];
        [button setImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
        [self.settleAllSelectButton setSelected:NO];
        [self.settleAllSelectButton setImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
        [[ShoppingCart cart] unselectAllGoods];
        [self.tableView reloadData];
    }
}

- (void)configureCell:(ShoppingCartTableViewCell *)cell withIndex:(NSIndexPath *)indexPath {
    ShoppingCartItem *good = [[ShoppingCart cart].goods objectAtIndex:indexPath.row];
    cell.checkButton.tag = indexPath.row;
    cell.addButton.tag = indexPath.row;
    cell.minusButton.tag = indexPath.row;
    if (good.isSelected) {
        [cell.checkButton setSelected:YES];
        [cell.checkButton setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
    } else {
        [cell.checkButton setSelected:NO];
        [cell.checkButton setImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
    }
    cell.amountTextField.text = [NSString stringWithFormat:@"%ld", (long)good.amount];
    cell.amountLabel.text = [NSString stringWithFormat:@"x%ld", (long)good.amount];
    if (self.isEditting) {
        [cell.amountLabel setHidden: YES];
        [cell.amountTextField setHidden:NO];
        [cell.addButton setHidden:NO];
        [cell.minusButton setHidden:NO];
    } else {
        [cell.amountLabel setHidden: NO];
        [cell.amountTextField setHidden:YES];
        [cell.addButton setHidden:YES];
        [cell.minusButton setHidden:YES];
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.rightBarButton.title isEqualToString:@"完成"]) {
        return;
    }
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ProductViewController *productVC = [storyboard instantiateViewControllerWithIdentifier:@"detail"];
    [self.navigationController pushViewController:productVC animated:YES];

}


#pragma mark -UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[ShoppingCart cart] goods].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShoppingCartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sctCell];
    [self configureCell:cell withIndex:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 86;
}
#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (self.navigationController.viewControllers.count == 1) {
        return NO;
    }
    return YES;
}


#pragma mark - request
- (void)request {
    [_tableView.mj_header endRefreshing];
}

@end
