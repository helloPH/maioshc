//
//  LognPopView.h
//  LifeForMM
//
//  Created by HUI on 16/3/21.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"
@class LognPopView;
@protocol LognPopDeldgate <NSObject>

@optional
-(void)lognPopView:(LognPopView *)lognPop btnIndex:(NSInteger)index;

-(void)loginSuccessWithDict:(NSDictionary *)dict;
/* index:
     103 账号删除
     106 是否自动登录 Img 107 自动登录lab
     108 忘记密码
     109 登录
     111 用户协议
     113 注册
 */
@end
@interface LognPopView : UIView<MBProgressHUDDelegate,UITextFieldDelegate>
@property (nonatomic,retain)UITextField *tleTextFile;//电话号码
@property (nonatomic,retain)UITextField *pasTextFile;//密码
@property (nonatomic,retain)UIButton *forgetPas;//忘记密码btn
@property (nonatomic,retain)UIButton *logonBtn;//登录
@property (nonatomic,retain)UIButton *registBtn;//注册
@property (nonatomic,retain)UILabel *remainLabel;//计时label
@property (nonatomic,assign)NSInteger seconds;//计时
@property (nonatomic,retain)UIImageView *isAutoImage;//是否自动登录选择
@property (nonatomic,weak)id<LognPopDeldgate>delegate;
@end
