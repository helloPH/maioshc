//
//  balanceCell.h
//  LifeForMM
//
//  Created by HUI on 15/12/21.
//  Copyright © 2015年 时元尚品. All rights reserved.
//

#import "blanceModel.h"
#import <UIKit/UIKit.h>

@interface balanceCell : UITableViewCell
@property (nonatomic,retain)UILabel *titleLab; //收支情况
@property (nonatomic,retain)UILabel *enabelLabel; //余额
@property (nonatomic,retain)UILabel *timeLabel; //时间
@property (nonatomic,retain)UILabel *spendLabel; //收支金额
@property (nonatomic,retain)UILabel *dingdanhao; //订单号
@property (nonatomic,retain)blanceModel *bModel;
@property (nonatomic,retain)UIView *line;
@end

