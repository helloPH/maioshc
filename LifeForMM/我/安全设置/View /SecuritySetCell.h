//
//  SecuritySetCell.h
//  LifeForMM
//
//  Created by MIAO on 16/8/5.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecuritySetCell : UITableViewCell

-(void)loadDataWithIndexPath:(NSIndexPath *)indexpath AndIsSheBei:(BOOL)isSheBei AndsetingArray:(NSMutableArray *)setingDataAry AndphoneArray:(NSMutableArray *)phoneLbaelAry AndsafeDataArray:(NSMutableArray *)safeData AndemailArray:(NSMutableArray *)emailLabelAry AndisRenZhen:(BOOL)isrenzhen;
@end
