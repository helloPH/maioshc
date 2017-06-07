//
//  MakeMoneyViewController.h
//  LifeForMM
//
//  Created by MIAO on 2016/12/22.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MakeMoneyViewControllerDelegate <NSObject>

-(void)gotoLogin;

@end
@interface MakeMoneyViewController : UIViewController

@property(nonatomic,strong)id<MakeMoneyViewControllerDelegate>moneyDelegate;
@end
