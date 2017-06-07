//
//  MyInvitationView.h
//  LifeForMM
//
//  Created by MIAO on 2016/12/23.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"
@interface MyInvitationView : UITableView<UITableViewDelegate,UITableViewDataSource,MBProgressHUDDelegate>

-(void)reloadMyInviteData;
@end
