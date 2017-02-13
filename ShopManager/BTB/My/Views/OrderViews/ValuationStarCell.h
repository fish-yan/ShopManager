//
//  ValuationStarCell.h
//  BTB
//
//  Created by 薛焱 on 16/2/17.
//  Copyright © 2016年 薛焱. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RatingBar.h"
@interface ValuationStarCell : UITableViewCell<RatingBarDelegate>
@property (weak, nonatomic) IBOutlet RatingBar *starView;


@end
