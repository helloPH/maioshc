//
//  NewAddresPopView.h
//  LifeForMM
//
//  Created by HUI on 16/3/21.
//  Copyright © 2016年 时元尚品. All rights reserved.
//新增地址

#import <UIKit/UIKit.h>
#import "Header.h"
@class NewAddresPopView;
@protocol newAddresPopDelegate <NSObject>

@optional
-(void)newAddressView:(NewAddresPopView *)popView Andvalue:(NSInteger )index;

@end
@interface NewAddresPopView : UIView<MBProgressHUDDelegate,UITextFieldDelegate,UITextViewDelegate,BMKGeoCodeSearchDelegate>
@property (nonatomic,retain)UITextField *receiver;//收货人
@property (nonatomic,retain)UITextField *receiVerTel; //收货人姓名
@property (nonatomic,retain)UITextView *addresTextView;//收货地址
@property (nonatomic,retain)UITextField *houseNum;//收货地址门牌号
@property (nonatomic,assign)BOOL isWoman; //是女人
@property (nonatomic,weak)id<newAddresPopDelegate>addresPopdelegate;
@end
