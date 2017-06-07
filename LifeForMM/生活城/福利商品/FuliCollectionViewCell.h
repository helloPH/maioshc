//
//  FuliCollectionViewCell.h
//  LifeForMM
//
//  Created by MIAO on 2016/12/22.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FuliCollectionViewCell : UICollectionViewCell

-(void)reloadDataWithIndexpath:(NSIndexPath *)indexPath AndArray:(NSArray *)array;
@end
