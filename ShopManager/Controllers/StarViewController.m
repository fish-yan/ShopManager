//
//  StarViewController.m
//  ShopManager
//
//  Created by 张旭 on 2/24/16.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import "StarViewController.h"
#import "StarCollectionViewCell.h"
#import "StoreTableViewCell.h"
#import "TimeSelectTableViewCell.h"
#import "InputTableViewCell.h"
#import "PointChartView.h"
#import "HttpClient.h"
#import "ShopManager-Swift.h"
#import "UILabel+FlickerNumber.h"
@import DateTools;
@import MBProgressHUD;

@interface StarViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource, UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *BlurView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (strong, nonatomic) PointChartView *pointChartView;
@property (strong, nonatomic) NSArray *starData;
@property (strong, nonatomic) NSArray *storeData;
@property (assign, nonatomic) NSIndexPath *selectedIndexPath;
@property (strong, nonatomic) NSDate *startDate;
@property (strong, nonatomic) NSDate *endDate;
@property (copy, nonatomic) NSString *consumptionMoney;
@property (copy, nonatomic) NSString *consumptionTimes;
@property (strong, nonatomic) NSIndexPath *selectedStore;

@end

@implementation StarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.topConstraint.constant -= 400;
    self.bottomConstraint.constant -= 260;
    [self.BlurView setHidden:YES];
    UITapGestureRecognizer *blurTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(blurViewDidTouch)];
    [self.BlurView addGestureRecognizer:blurTap];
    self.collectionView.contentInset = UIEdgeInsetsMake(236, 0, 0, 0);
    self.pointChartView = [[[NSBundle mainBundle] loadNibNamed:@"PointChartView" owner:self options:nil] lastObject];
    self.pointChartView.frame = CGRectMake(0, -236, [UIScreen mainScreen].bounds.size.width, 236);
    [self.collectionView addSubview:self.pointChartView];
    self.pointChartView.webView.delegate = self;
    self.pointChartView.webView.alpha = 0;
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"point" withExtension:@"html"];
    [self.pointChartView.webView loadRequest:[NSURLRequest requestWithURL:url]];
    self.consumptionMoney = @"6000";
    self.consumptionTimes = @"6";
    [self storeListRequest];
    [self starDataRequestWithStoreID:nil startDate:nil endDate:nil consumptionMoney:nil consumptionTimes:nil];
    [self customTotalsRequest];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)blurViewDidTouch {
    if (!self.BlurView.isHidden) {
        [self.BlurView setHidden:YES];
        self.topConstraint.constant -= 400;
        [UIView animateWithDuration:0.5 animations:^{
            [self.view layoutIfNeeded];
        } completion:nil];
    }
}

- (IBAction)filterButtonDidTouch:(id)sender {
    if (self.BlurView.isHidden) {
        [self.BlurView setHidden:NO];
        self.topConstraint.constant += 400;
        if ([[User sharedUser] isBoss]) {
            self.heightConstraint.constant = 400;
        } else {
            self.heightConstraint.constant = 280;
        }
        [UIView animateWithDuration:0.5 animations:^{
            [self.view layoutIfNeeded];
        } completion:nil];
    }
}

- (IBAction)okButtonDidTouch:(id)sender {
    [self.view endEditing:YES];
    if (!self.BlurView.isHidden) {
        [self.BlurView setHidden:YES];
        self.topConstraint.constant -= 400;
        [UIView animateWithDuration:0.5 animations:^{
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            NSString *storeid = @"";
            
            if (self.selectedStore != nil) {
                Store *store = [self.storeData objectAtIndex:self.selectedStore.row];
                storeid = store.storeID;
            }
            NSString *startString = nil;
            NSString *endString = nil;
            if (self.startDate != nil) {
                startString = [NSString stringWithFormat:@"%ld/%ld", self.startDate.year, self.startDate.month];
            }
            if (self.endDate != nil) {
                endString = [NSString stringWithFormat:@"%ld/%ld", self.endDate.year, self.endDate.month];
            }
            self.consumptionMoney = ((InputTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]]).inputTextField.text;
            self.consumptionTimes = ((InputTableViewCell *) [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:1]]).inputTextField.text;
            [self starDataRequestWithStoreID:storeid startDate:startString endDate:endString consumptionMoney:self.consumptionMoney consumptionTimes:self.consumptionTimes];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        }];
    }
}

- (IBAction)dateOkButtonDidTouch:(id)sender {
    if (self.selectedIndexPath.row == 0) {
        self.startDate = [self.datePicker date];
    } else {
        self.endDate = [self.datePicker date];
    }
    if (self.bottomConstraint.constant == 0) {
        self.bottomConstraint.constant -= 260;
        [UIView animateWithDuration:0.5 animations:^{
            [self.view layoutIfNeeded];
        }];
    }
    [self.tableView reloadData];
}

- (IBAction)dateCancelButtonDidTouch:(id)sender {
    if (self.bottomConstraint.constant == 0) {
        self.bottomConstraint.constant -= 260;
        [UIView animateWithDuration:0.5 animations:^{
            [self.view layoutIfNeeded];
        }];
    }
}

- (IBAction)backButtonDidTouch:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (self.selectedStore == indexPath) {
            self.selectedStore = nil;
        } else {
            self.selectedStore = indexPath;
        }
        [tableView reloadData];
    } else if (indexPath.row == 0 || indexPath.row == 1) {
        self.selectedIndexPath = indexPath;
        if (self.bottomConstraint.constant != 0) {
            self.bottomConstraint.constant += 260;
            [UIView animateWithDuration:0.5 animations:^{
                [self.view layoutIfNeeded];
            }];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }

    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }

    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 20;
    }
    return 0;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.alpha = 0;
    return view;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.storeData == nil ? 0 : self.storeData.count;
    }
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        StoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StoreCell"];
        Store *store = [self.storeData objectAtIndex:indexPath.row];
        [cell.storeLabel setText:store.storeName];
        if (indexPath != self.selectedStore) {
            [cell.selectImage setImage:[UIImage imageNamed:@"btn-dg-gray"]];
        } else {
            [cell.selectImage setImage:[UIImage imageNamed:@"btn-dg-red"]];
        }
        return cell;
    }
    if (indexPath.row == 0) {
        TimeSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TimeSelectCell"];
        cell.titleLabel.text = @"开始时间";
        if (self.startDate != nil) {
            cell.contentLabel.text = [NSString stringWithFormat:@"%ld-%ld-%ld", self.startDate.year, self.startDate.month, self.startDate.day];
        } else {
            cell.contentLabel.text = @"";
        }
        return cell;
    } else if (indexPath.row == 1) {
        TimeSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TimeSelectCell"];
        cell.titleLabel.text = @"结束时间";
        if (self.endDate != nil) {
            cell.contentLabel.text = [NSString stringWithFormat:@"%ld-%ld-%ld", self.endDate.year, self.endDate.month, self.endDate.day];
        } else {
            cell.contentLabel.text = @"";
        }
        return cell;
    } else {
        InputTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InputCell"];
        if (indexPath.row == 2) {
            cell.titleLabel.text = @"消费基准";
            cell.inputTextField.text = self.consumptionMoney;
        } else {
            cell.titleLabel.text = @"频次基准";
            cell.inputTextField.text = self.consumptionTimes;
        }
        return cell;
    }
}


#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = collectionView.frame.size.width;
    return CGSizeMake((width-2)/3, 150);
}


#pragma mark - UICollectionViewDelegate



#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 11;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    StarCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"StarCell" forIndexPath:indexPath];
    cell.starWidthConstraint.constant = cell.starWidth*((10-indexPath.row)/10.0);
    if (self.starData != nil) {
        [cell.countLabel setText:[NSString stringWithFormat:@"%ld", (long)[[self.starData objectAtIndex:10-indexPath.row] integerValue]]];
    }
    return cell;
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [UIView animateWithDuration:0.5 animations:^{
        webView.alpha = 1;
    }];
}

#pragma mark - Request

- (void)updatePointChartViewWithLL:(NSInteger)ll LH:(NSInteger)lh HH:(NSInteger)hh HL:(NSInteger)hl {
    NSString *jsStr = [NSString stringWithFormat:@"setData(%ld, %ld, %ld, %ld)", (long)ll, (long)lh, (long)hh, (long)hl];
    [self.pointChartView.webView stringByEvaluatingJavaScriptFromString:jsStr];
    [self.pointChartView.llLabel setText:[NSString stringWithFormat:@"低频次低消费：%ld个", (long)ll]];
    [self.pointChartView.lhLabel setText:[NSString stringWithFormat:@"低频次高消费：%ld个", (long)lh]];
    [self.pointChartView.hhLabel setText:[NSString stringWithFormat:@"高频次高消费：%ld个", (long)hh]];
    [self.pointChartView.hlLabel setText:[NSString stringWithFormat:@"高频次低消费：%ld个", (long)hl]];
}

- (void)starDataRequestWithStoreID:(NSString *)storeId
                         startDate:(NSString *)startDate
                           endDate:(NSString *)endDate
                  consumptionMoney:(NSString *)consumptionMoney
                  consumptionTimes:(NSString *)consumptionTimes{
    [[HttpClient sharedHttpClient] getStarDataWithStoreID:storeId StartDate:startDate endDate:endDate consumptionMoney:consumptionMoney consumptionTimes:consumptionTimes complete:^(BOOL success, StarData *data) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (success) {
            [self updatePointChartViewWithLL:[data.lowTimesLowConsump integerValue] LH:[data.lowTimesHighConsump integerValue] HH:[data.highTimesHighConsump integerValue] HL:[data.highTimesLowConsump integerValue]];
        }
    } failure:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (void)customTotalsRequest {
    [[HttpClient sharedHttpClient] getCustomStarDataWithCompletion:^(BOOL success, NSArray *data) {
        if (success) {
            self.starData = data;
            [self.collectionView reloadData];
        }
    } failure:^{
        
    }];
}

- (void)storeListRequest {
    [[HttpClient sharedHttpClient] getStoreDataWithCompletion:^(BOOL success, NSArray *data) {
        if (success) {
            if ([[User sharedUser] isBoss]) {
                self.storeData = data;
            } else {
                self.storeData = nil;
            }
            [self.tableView reloadData];
        }
    } failure:^{
    }];
}

@end
