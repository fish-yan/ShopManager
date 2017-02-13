
//
//  MyFavouriteCarViewController.m
//  MyFavouriteCar
//
//  Created by 薛焱 on 16/1/6.
//  Copyright © 2016年 薛焱. All rights reserved.
//
#import "MyFavouriteCarViewController.h"
#import "SearchViewController.h"
#import "MyCarModelTableViewCell.h"
#import "MyCarCollectionViewCell.h"
#import "MyCarKindTableViewCell.h"
#import "CarModel.h"

#define kLeftConstant -50
#define kRightConstant -340

struct {
    NSInteger section;
    NSInteger row;
    NSInteger tag;
}buttonTag;

@interface MyFavouriteCarViewController ()<UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UITableView *myCarTableView;
@property (weak, nonatomic) IBOutlet UITableView *myCarKindTableView;
@property (weak, nonatomic) IBOutlet UICollectionView *myCarCollectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *subViewRightMargin;
@property (weak, nonatomic) IBOutlet UIView *myCarKindView;
@property (nonatomic, strong) NSArray *sectionArray;
@property (nonatomic, strong) NSIndexPath *tableViewIndexPath;
@property (nonatomic, strong) NSMutableArray *cellHeightArray;
@property (nonatomic, strong) NSDictionary *dataDict;
@end

@implementation MyFavouriteCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    self.cellHeightArray = [NSMutableArray array];
    buttonTag.section = 0;
    buttonTag.row = 0;
    buttonTag.tag =0;
    [self configureMyCarKindView];
    [self readDataSource];
    
}

- (void)readDataSource{
    [DataHelper loadDataWithSuffixUrlStr:kCarType parameters:nil block:^(id responseObject) {
        self.dataDict = [DataHelper praserCarTypeDataWithResponseObject:responseObject];
        self.sectionArray = [self.dataDict.allKeys  sortedArrayUsingSelector:@selector(compare:)];
        for (NSString *zmNameKey in self.sectionArray) {
            NSDictionary *nameDict = self.dataDict[zmNameKey];
            NSMutableArray *array = [NSMutableArray array];
            for (NSString *carBrandKey in nameDict) {
                [array addObject:[NSNumber numberWithFloat:(([[nameDict[carBrandKey] allKeys]count] + 1) / 2) * 38]];
            }
            [self.cellHeightArray addObject:array];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.myCarCollectionView reloadData];
            [self.myCarKindTableView reloadData];
            [self.myCarTableView reloadData];
        });
    }];
}

//配置myCarKindView
- (void)configureMyCarKindView{
    self.myCarKindView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.myCarKindView.layer.shadowOffset = CGSizeMake(-2, 0);
    self.myCarKindView.layer.shadowOpacity = 0.3;
    self.subViewRightMargin.constant = kRightConstant;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGestureRecognizerAction:)];
    [self.myCarKindView addGestureRecognizer:pan];
}

//pan手势
- (void)panGestureRecognizerAction:(UIPanGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateChanged) {
        self.subViewRightMargin.constant = -[sender translationInView:self.view].x + kLeftConstant;
        if (self.subViewRightMargin.constant >= kLeftConstant) {
            self.subViewRightMargin.constant = kLeftConstant;
        }
    }
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (self.subViewRightMargin.constant < kLeftConstant - 50) {
            self.subViewRightMargin.constant = kRightConstant;
        } else {
            self.subViewRightMargin.constant = kLeftConstant;
        }
    }
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:20 options:(UIViewAnimationOptionTransitionNone) animations:^{
        [self.view layoutIfNeeded];
    } completion:nil];
}

- (IBAction)backButtonDidTouch:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(kScreenWidth / 7, 123 / 3);
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.sectionArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MyCarCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"myCarCell" forIndexPath:indexPath];
    cell.indexLabel.text = self.sectionArray[indexPath.row];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.tableViewIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.row];
    if ([[self.dataDict[self.sectionArray[indexPath.row]]allKeys]count] != 0) {
        [self.myCarTableView scrollToRowAtIndexPath:self.tableViewIndexPath atScrollPosition:(UITableViewScrollPositionTop) animated:YES];
    }
    
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == self.myCarTableView) {
        return self.sectionArray.count;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.myCarTableView) {
        return [[self.dataDict[self.sectionArray[section]]allKeys] count];
    }
    NSDictionary *carbrandDict = self.dataDict[self.sectionArray[buttonTag.section]];
    if (carbrandDict.allKeys.count != 0) {
        NSDictionary *carseriesDict = carbrandDict[[carbrandDict allKeys][buttonTag.row]];
        NSArray *carModelArray = carseriesDict[carseriesDict.allKeys[buttonTag.tag]];
        return carModelArray.count;
    }else{
        return 0;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.myCarTableView) {
        MyCarModelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCarCell" forIndexPath:indexPath];
        NSDictionary *carbrandDict = self.dataDict[self.sectionArray[indexPath.section]];
        NSArray *carseriesArray = [carbrandDict[[carbrandDict allKeys][indexPath.row]] allKeys];
        [self addMyCarKindButtonWithMyCarKindArray:carseriesArray indexPath:indexPath cell:cell];
        
        return cell;
    } else {
        MyCarKindTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCarKindCell" forIndexPath:indexPath];
        NSDictionary *carbrandDict = self.dataDict[self.sectionArray[buttonTag.section]];
        NSDictionary *carseriesDict = carbrandDict[[carbrandDict allKeys][buttonTag.row]];
        NSArray *carModelArray = carseriesDict[carseriesDict.allKeys[buttonTag.tag]];
        CarModel *model = carModelArray[indexPath.row];
        cell.myCarKindNameLabel.text = model.CarmodelName;
        return cell;
    }
    
}

//cell上添加button
- (void)addMyCarKindButtonWithMyCarKindArray:(NSArray *)myCarKindArray indexPath:(NSIndexPath *)indexPath cell:(MyCarModelTableViewCell *)cell{
    UIView *buttonView = [[UIView alloc]initWithFrame:CGRectMake(120, 0, kScreenWidth - 120, 38 * (myCarKindArray.count / 2))];
    for (int i = 0; i < myCarKindArray.count; i++) {
        UIButton *myCarKindButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
        myCarKindButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        myCarKindButton.tag = i;
        myCarKindButton.frame = CGRectMake((kScreenWidth - 120) / 2 * (i % 2), 38 * (i / 2), (kScreenWidth - 120) / 2, 38);
        [myCarKindButton setTitle:myCarKindArray[i] forState:(UIControlStateNormal)];
        [myCarKindButton setTitleColor:UIColorFromRGB(0x999999) forState:(UIControlStateNormal)];
        myCarKindButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [myCarKindButton addTarget:self action:@selector(myCarKindButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [buttonView addSubview:myCarKindButton];
    }
    [cell addSubview:buttonView];
}

//button点击事件
- (void)myCarKindButtonAction:(UIButton *)sender {
    MyCarModelTableViewCell *cell = (MyCarModelTableViewCell *)sender.superview.superview;
    NSIndexPath *indexPath = [self.myCarTableView indexPathForCell:cell];
    
    buttonTag.section = indexPath.section;
    buttonTag.row = indexPath.row;
    buttonTag.tag = sender.tag;
    [self.myCarKindTableView reloadData];
    self.subViewRightMargin.constant = kLeftConstant;
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:20 options:(UIViewAnimationOptionTransitionNone) animations:^{
        [self.view layoutIfNeeded];
    } completion:nil];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == self.myCarKindTableView) {
        MyCarKindTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [self performSegueWithIdentifier:@"UnWindSegue" sender:cell.myCarKindNameLabel.text];
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.myCarTableView) {
        [cell.subviews.lastObject removeFromSuperview];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView == self.myCarTableView) {
        UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
        sectionView.backgroundColor = UIColorFromRGB(0xEFF5F6);
        
        UILabel *indexLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 30, 30)];
        indexLabel.text = self.sectionArray[section];
        indexLabel.textColor = UIColorFromRGB(0x049CD4);
        [sectionView addSubview:indexLabel];
        return sectionView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == self.myCarTableView) {
        return 30;
    } else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.myCarTableView) {
        return [self.cellHeightArray[indexPath.section][indexPath.row] floatValue];
    } else {
        return 37;
    }
    
}




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    SearchViewController *searchVC = segue.destinationViewController;
    searchVC.carModel = sender;
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
