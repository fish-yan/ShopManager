//
//  BrandViewController.m
//  Cjmczh
//
//  Created by cjm-ios on 15/12/31.
//  Copyright © 2015年 Cjm. All rights reserved.
//

#import "BrandViewController.h"
#import "BrandCollectionViewCell.h"
#import "BrandCollectionReusableView.h"

@interface BrandViewController () {
    BrandCollectionReusableView *headerView;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *menuButtons;


@property (strong, nonatomic) UIButton *selectedButton;
@end

@implementation BrandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    [self.tableView registerNib:[UINib nibWithNibName:@"BrandSpecialSaleCell" bundle:nil] forCellReuseIdentifier:@"BrandSpecialSaleCell"];
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self request];
    }];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self request];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self request];
    }];
    self.selectedButton = [self.menuButtons objectAtIndex:0];
}

- (void)selectMenuButtonAtIndex:(NSInteger)index {
    [[self.menuButtons objectAtIndex:index-1] setTitleColor:UIColorFromRGB(0x2c2c2c) forState:UIControlStateNormal];
}

- (void)unselectMenuButtonAtIndex:(NSInteger)index {
    [[self.menuButtons objectAtIndex:index-1] setTitleColor:UIColorFromRGB(0x939393) forState:UIControlStateNormal];
}

- (IBAction)menuClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    [self unselectMenuButtonAtIndex:self.selectedButton.tag];
    self.selectedButton = btn;
    [self selectMenuButtonAtIndex:self.selectedButton.tag];
    if (btn.tag == 1) {
        [UIView animateWithDuration:0.3 animations:^{
            _leftConstraint.constant = 0;
            [self.view layoutIfNeeded];
        }];
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }else {
        [UIView animateWithDuration:0.3 animations:^{
            _leftConstraint.constant = _middleConstraint.constant + CGRectGetWidth(btn.frame);
            [self.view layoutIfNeeded];
        }];
        [self.scrollView setContentOffset:CGPointMake(self.view.frame.size.width, 0) animated:YES];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.scrollView) {
        if (scrollView.contentOffset.x == 0) {
            [UIView animateWithDuration:0.3 animations:^{
                _leftConstraint.constant = 0;
                [self.view layoutIfNeeded];
            }];
            [self unselectMenuButtonAtIndex:self.selectedButton.tag];
            self.selectedButton = [self.menuButtons objectAtIndex:0];
            [self selectMenuButtonAtIndex:self.selectedButton.tag];
        } else {
            [UIView animateWithDuration:0.3 animations:^{
                _leftConstraint.constant = _middleConstraint.constant + 60;
                [self.view layoutIfNeeded];
            }];
            [self unselectMenuButtonAtIndex:self.selectedButton.tag];
            self.selectedButton = [self.menuButtons objectAtIndex:1];
            [self selectMenuButtonAtIndex:self.selectedButton.tag];
        }
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 24;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BrandCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"brandCollectionCell" forIndexPath:indexPath];
    cell.imageV.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld", indexPath.row + 1]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    float width = ([UIScreen mainScreen].bounds.size.width - 10 * 2 - 3 * 2) / 3 - 1;
    return CGSizeMake(width, width * 43 / 88);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reusableView = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]){
         headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"brandHeaderView" forIndexPath:indexPath];
         reusableView = headerView;
    }
    return reusableView;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"brandSub" sender:self];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (self.navigationController.viewControllers.count == 1) {
        return NO;
    }
    return YES;
}



#pragma mark -request
- (void)request {
    [self.collectionView reloadData];
    [self.collectionView.mj_header endRefreshing];
    
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

@end
