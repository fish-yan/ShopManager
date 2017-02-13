//
//  DrawbackViewController.m
//  BTB
//
//  Created by 薛焱 on 16/2/17.
//  Copyright © 2016年 薛焱. All rights reserved.
//

#import "DrawbackViewController.h"
#import "DrawbackReasonCell.h"
#import "ImportPicCell.h"
#import "ItemOrderTableViewCell.h"
#import "ProductViewController.h"
#import "ZLPhotoActionSheet.h"

@interface DrawbackViewController ()<UITableViewDataSource, UITableViewDelegate, UITextViewDelegate>{
    ZLPhotoActionSheet *actionSheet;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<UIImage *> *imageArray;
@end

@implementation DrawbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageArray = [NSMutableArray array];
    actionSheet = [[ZLPhotoActionSheet alloc] init];
    actionSheet.maxSelectCount = 3;
    actionSheet.maxPreviewCount = 20;
    UINib *itemONib = [UINib nibWithNibName:@"ItemOrderTableViewCell" bundle:nil];
    [_tableView registerNib:itemONib forCellReuseIdentifier:itemOCell];
    // Do any additional setup after loading the view.
}
- (IBAction)backItem:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)submintButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)importPicButtonAction:(UIButton *)sender{
    actionSheet.maxSelectCount = 3 - self.imageArray.count;
    [actionSheet showWithSender:self animate:YES completion:^(NSArray<UIImage *> * _Nonnull selectPhotos) {
            self.imageArray = [NSMutableArray arrayWithArray:[self.imageArray arrayByAddingObjectsFromArray:selectPhotos]];
        actionSheet.maxSelectCount = 3 - self.imageArray.count;
        [self.tableView reloadData];
    }];
}

- (void)closeButtonAction:(UIButton *)sender{
    [self.imageArray removeObjectAtIndex:sender.tag];
    [self.tableView reloadData];
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
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        ItemOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:itemOCell forIndexPath:indexPath];
        return cell;
    }else if (indexPath.row == 1){
        DrawbackReasonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DrawbackReasonCell" forIndexPath:indexPath];
        cell.textView.delegate = self;
        return cell;
    }else{
        ImportPicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ImportPicCell" forIndexPath:indexPath];
        [cell.importPicButton addTarget:self action:@selector(importPicButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [cell.closeImageButton0 addTarget:self action:@selector(closeButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [cell.closeImageButton1 addTarget:self action:@selector(closeButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [cell.closeImageButton2 addTarget:self action:@selector(closeButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
        
        if (self.imageArray.count > 0) {
            cell.closeImageButton0.hidden = NO;
            cell.importPic1.image = self.imageArray[0];
        }
        if (self.imageArray.count > 1) {
            cell.closeImageButton1.hidden = NO;
            cell.importPic2.image = self.imageArray[1];
        }
        if (self.imageArray.count > 2) {
            cell.closeImageButton2.hidden = NO;
            cell.importPic3.image = self.imageArray[2];
        }
        
        if (self.imageArray.count <= 0) {
            cell.closeImageButton0.hidden = YES;
            cell.importPic1.image = nil;
        }
        if (self.imageArray.count <= 1) {
            cell.closeImageButton1.hidden = YES;
            cell.importPic2.image = nil;
        }
        if (self.imageArray.count <= 2) {
            cell.closeImageButton2.hidden = YES;
            cell.importPic3.image = nil;
        }
        
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            return 80;
        case 1:
            return 150;
        default:
            return 100;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ProductViewController *productVC = [storyboard instantiateViewControllerWithIdentifier:@"detail"];
        [self.navigationController pushViewController:productVC animated:YES];
    }
}

#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@"请描述退货原因, 后期会有客服人员与你联系"]) {
        textView.text = @"";
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"请描述退货原因, 后期会有客服人员与你联系";
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
