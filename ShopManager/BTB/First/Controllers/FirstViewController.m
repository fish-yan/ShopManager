//
//  FirstViewController.m
//  BTB
//
//  Created by 薛焱 on 16/2/3.
//  Copyright © 2016年 薛焱. All rights reserved.
//

#import "FirstViewController.h"
#import "HeaderView.h"
#import "FirstSectionViewCell.h"
#import "SecondSectionLargeCell.h"
#import "SecondSectionSmallCell.h"
#import "ThirdSectionCell.h"
#import "ForthSectionCell.h"
#import "SectionReusableView.h"
#import "ProductViewController.h"
#import "CustomPageControl.h"
#import "ProductModel.h"

#define kNavAlpha 144 / 170.0
#define kInsetTop 298

@interface FirstViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *naviView;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (nonatomic, strong) NSArray *sectionTitleArray;
@property (nonatomic, strong) NSArray *sectionImageArray;
@property (nonatomic, strong) NSArray *itemTitleArray;
@property (nonatomic, strong) NSArray *itemImageArray;
@property (nonatomic, strong) UICollectionView *headerCollectionView;
@property (nonatomic, strong) CustomPageControl *pageControl;
@property (nonatomic, strong) NSArray *kindTitleArray;
@property (nonatomic, strong) NSArray *kindImageArray;
@property (nonatomic, strong) NSMutableDictionary *paramter;
@property (nonatomic, strong)NSArray *recommendArray;
@end

@implementation FirstViewController

- (void)viewDidAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
    if (self.collectionView.contentOffset.y > -64) {
        self.naviView.alpha = kNavAlpha;
        [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
    }else{
        [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    }
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    self.paramter = [NSMutableDictionary dictionary];
    self.paramter = @{@"num":@"10"}.mutableCopy;
    __block NSInteger num = 10;
    [self loadHeadView];
    [self readDataSource];
    _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.paramter = @{@"num":@"10"}.mutableCopy;
        [self readDataSource];
    }];
    _collectionView.mj_header.ignoredScrollViewContentInsetTop = kInsetTop;
    _collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        num +=10;
        self.paramter = @{@"num":[NSString stringWithFormat:@"%ld", num]}.mutableCopy;
        [self readDataSource];
    }];
    
}

- (IBAction)exitButtonDidTouch:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


- (void)loadHeadView {
    
    self.collectionView.contentInset = UIEdgeInsetsMake(kInsetTop, 0, 0, 0);
    HeaderView *headerView = [[[NSBundle mainBundle]loadNibNamed:@"HeaderView" owner:self options:nil] lastObject];
    headerView.frame = CGRectMake(0, -kInsetTop, kScreenWidth, kInsetTop);
    [self.collectionView addSubview:headerView];
    self.headerCollectionView = headerView.collectionView;
    self.pageControl = headerView.collectionPageControl;
    self.headerCollectionView.delegate = self;
    self.headerCollectionView.dataSource = self;
    [self.headerCollectionView registerNib:[UINib nibWithNibName:@"FirstSectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"FirstSectionViewCell"];
}

- (void)readDataSource {
    self.sectionTitleArray = @[ @"热门市场", @"限时促销", @"推荐商品"];
    self.sectionImageArray = @[ @"huo", @"xianshi", @"tuijian"];
    
    NSArray *hotTitleArray = @[@"限时抢购", @"限量抢购", @"影音电子电器", @"GPS导航记录仪", @"清洁用品", @"汽车零配件"];
    NSArray *hotImageArray = @[@"zuodian", @"fangxiangpantao", @"dianzi", @"gps", @"qingjie", @"peijian"];
    NSArray *xianshiImageArray = @[@"huodong1", @"huodong-2", @"huodong-2"];
    NSArray *xianshiTitleArray = @[@"", @"", @""];
    [DataHelper loadDataWithSuffixUrlStr:kRecommend parameters:self.paramter block:^(id responseObject) {
        self.recommendArray = [DataHelper praserRecommendDataWithResponseObject:responseObject];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
            [_collectionView.mj_header endRefreshing];
            [_collectionView.mj_footer endRefreshing];
        });
    }];
    
    self.itemImageArray = @[ hotImageArray, xianshiImageArray];
    self.itemTitleArray = @[ hotTitleArray, xianshiTitleArray];
    self.kindTitleArray = @[@"坐垫", @"轮胎轮毂", @"电子影音", @"导航电器", @"坐垫", @"轮胎轮毂", @"电子影音", @"导航电器"];
    self.kindImageArray = @[@"dian", @"luntai", @"yingyin", @"daohang", @"dian", @"luntai", @"yingyin", @"daohang"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == self.headerCollectionView) {
        return CGSizeMake(kScreenWidth / 4, 70);
    }else{
        switch (indexPath.section) {
            case 0:
                if (indexPath.row < 2) {
                    return CGSizeMake((kScreenWidth - 1) / 2, 90);
                }else{
                    return CGSizeMake((kScreenWidth - 3) / 4, 90);
                }
                
            case 1:
                return CGSizeMake(kScreenWidth - 20, (kScreenWidth - 20) / 5 * 2);
            default:
                return CGSizeMake((kScreenWidth - 1) / 2, (kScreenWidth - 1) / 2 + 60);
        }
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    if (collectionView == self.headerCollectionView) {
        return 0;
    }else{
        switch (section) {
            case 0:
                return 1;
            case 1:
                return 10;
            default:
                return 1;
        }
    }
    
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    if (collectionView == self.headerCollectionView) {
        return 0;
    }else{
        switch (section) {
            case 0:
                return 1;
            case 1:
                return 1;
            default:
                return 1;
        }
    }
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (collectionView == self.collectionView) {
        return CGSizeMake(kScreenWidth, 37);
    }else{
        return CGSizeMake(0, 0);
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if (collectionView == self.collectionView) {
        return 3;
    }else{
        return 1;
    }
    
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView == self.collectionView) {
        if (section == 2) {
            return self.recommendArray.count;
        }else{
            return [self.itemTitleArray[section] count];
        }
    }else{
        return 8;
    }
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == self.headerCollectionView) {
        FirstSectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FirstSectionViewCell" forIndexPath:indexPath];
        cell.itemImage.image = [UIImage imageNamed:self.kindImageArray[indexPath.row]];
        cell.titleLabel.text = self.kindTitleArray[indexPath.row];
        return cell;
    }else{
     
    
    if (indexPath.section == 0){
        UIImage *image = [UIImage imageNamed:self.itemImageArray[indexPath.section][indexPath.row]];
        NSString *title = self.itemTitleArray[indexPath.section][indexPath.row];
        if (indexPath.row < 2) {
            SecondSectionLargeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SecondSectionLargeCell" forIndexPath:indexPath];
            cell.itemImage.image = image;
            cell.titleLabel.text = title;
            
            return cell;
        }else{
            SecondSectionSmallCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SecondSectionSmallCell" forIndexPath:indexPath];
            cell.itemImage.image = image;
            cell.titleLabel.text = title;
            return cell;
        }
    }else if (indexPath.section == 1){
        UIImage *image = [UIImage imageNamed:self.itemImageArray[indexPath.section][indexPath.row]];
        ThirdSectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ThirdSectionCell" forIndexPath:indexPath];
        cell.itemImage.image = image;
        return cell;
    }else{
        ForthSectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ForthSectionCell" forIndexPath:indexPath];
        ProductModel *model = self.recommendArray[indexPath.row];
        NSString *imageStr = [NSString stringWithFormat:@"%@%@",kRequestHeader, model.image];
        [cell.itemImage sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:@"loading"]];
        
        cell.titleLabel.text = model.productName;
        cell.priceLabel.text = [NSString stringWithFormat:@"¥%@", model.price];
        NSString *oldPrice = [NSString stringWithFormat:@"¥%@", model.priceBefore];
        NSRange range = NSMakeRange(1, [oldPrice length] - 1);
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:oldPrice];
        [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:range];
        [attri addAttribute:NSStrikethroughColorAttributeName value:cell.oldPriceLabel.textColor range:range];
        [cell.oldPriceLabel setAttributedText:attri];
        return cell;
    }
        
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{

        SectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SectionReusableView" forIndexPath:indexPath];
    reusableView.titleLabel.text = self.sectionTitleArray[indexPath.section];
    reusableView.sectionImage.image = [UIImage imageNamed:self.sectionImageArray[indexPath.section]];
        return reusableView;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ProductViewController *productVC = [storyboard instantiateViewControllerWithIdentifier:@"detail"];
        [self.navigationController pushViewController:productVC animated:YES];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    self.pageControl.currentPage = self.headerCollectionView.contentOffset.x / kScreenWidth;
    self.naviView.alpha = (self.collectionView.contentOffset.y + 208) / 170;
    if (self.collectionView.contentOffset.y > -64) {
        self.naviView.alpha = kNavAlpha;
        [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
    }else{
        [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark - request
- (void)request {
    [_collectionView.mj_header endRefreshing];
}
#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (self.navigationController.viewControllers.count == 1) {
        return NO;
    }
    return YES;
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
