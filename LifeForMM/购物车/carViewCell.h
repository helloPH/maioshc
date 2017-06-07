//
//  carViewCell.h
//  LifeForMM
//
//  Created by 时元尚品 on 15/7/21.
//  Copyright (c) 2015年 时元尚品. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "carDataModel.h"
@class carViewCell;
@protocol carCellViewDelegate <NSObject>

@optional
-(void)carViewCell:(carViewCell *)cellView atIndex:(NSInteger)index addoOrCut:(NSInteger)bol numCount:(NSInteger)num cellSelect:(NSInteger)sel;
-(void)carViewcell:(carViewCell *)cellView shooseGood:(NSInteger)chbol;
@end



@interface carViewCell : UITableViewCell
@property(nonatomic,retain)UIImageView *selectImageView,*goodImageView,*changeNumImageView; // 选中 商品图片 加减
@property(nonatomic,retain)UILabel *goodTitle,*moneyNum,*goodNum;
@property(nonatomic,retain)UIButton *addBtn,*subtractBtn;
@property(nonatomic,assign)NSInteger goodCount;
@property(nonatomic,assign)NSInteger selectBool;//是否选中
@property(nonatomic,assign)NSInteger addOrCutBol;// '1'代表加 '0'代表减 '2'代表 没有选中
@property(nonatomic,assign)CGFloat countMoney;
@property(nonatomic,retain)UILabel *goodColor,*goodStyle;//颜色 型号
@property(nonatomic,retain)carDataModel *carModel;
@property(nonatomic,assign)NSInteger selOrAdd; //'1'代表
@property(nonatomic,weak)id <carCellViewDelegate> delegate;
@property(nonatomic,assign)BOOL isFirst;
@end
