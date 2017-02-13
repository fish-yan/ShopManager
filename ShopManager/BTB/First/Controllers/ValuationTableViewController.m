//
//  ValuationTableViewController.m
//  BrandPerfecture
//
//  Created by 薛焱 on 16/1/5.
//  Copyright © 2016年 薛焱. All rights reserved.
//

#import "ValuationTableViewController.h"
#import "ValuationTableViewCell.h"
@interface ValuationTableViewController ()

@property (nonatomic, assign) BOOL isSupport;
@property (nonatomic, assign) NSInteger usecount;

@end

@implementation ValuationTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.usecount = 23;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
}
- (IBAction)backItem:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ValuationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"valuationCell" forIndexPath:indexPath];
    cell.photoImageView.image = [UIImage imageNamed:@"photo"];
    cell.userNameLabel.text = @"张***莉";
    [cell setStaredViewCount:2.5];
    cell.valuationContent.text = @"美光正品汽车蜡新车蜡美光正品汽车蜡新车蜡美光正品汽车蜡新车蜡";
    NSString *explanContent = @"美光正品汽车蜡新车蜡美光正品汽车蜡新车蜡美光正品汽车蜡新车蜡";
    cell.explainContentLabel.text = explanContent;
    if (explanContent.length == 0) {
        cell.explainLabel.text = nil;
        cell.explainContentLabel.text = nil;
    }
    cell.goodsKindLabel.text = @"魅影黑色";
    cell.timeLabel.text = @"2015-07-23";
    return cell;
}

/**
 *  点赞/取消点赞
 */
- (void)supportButtonAction:(UIButton *)sender {
    if (self.isSupport) {
        [sender setImage:[UIImage imageNamed:@"noSupport"] forState:(UIControlStateNormal)];
        self.usecount--;
    } else {
        [sender setImage:[UIImage imageNamed:@"support"] forState:(UIControlStateNormal)];
        self.usecount++;
    }
    self.isSupport = !_isSupport;
    [self.tableView reloadData];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
