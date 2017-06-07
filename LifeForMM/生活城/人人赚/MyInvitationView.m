//
//  MyInvitationView.m
//  LifeForMM
//
//  Created by MIAO on 2016/12/23.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import "MyInvitationView.h"
#import "MyInvitationCell.h"
#import "MyInviteModel.h"
@implementation MyInvitationView
{
    NSMutableArray *inviteArray;
}
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        inviteArray= [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}
-(void)reloadMyInviteData
{
    if ([isLogin integerValue]==1) {
    [inviteArray removeAllObjects];
    MBProgressHUD *dbud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    dbud.delegate = self;
    dbud.mode = MBProgressHUDModeIndeterminate;
    dbud.labelText = @"请稍等...";
    [dbud show:YES];
    NSMutableDictionary *pram = [NSMutableDictionary dictionaryWithDictionary:@{@"userid":user_id}];
    [HTTPTool getWithUrl:@"myInvite.action" params:pram success:^(id json) {
        [dbud hide:YES];
        NSLog(@"我的邀请%@",json);
        if ([[json valueForKey:@"message"]integerValue] == 1) {
            NSArray *shoplist = [json valueForKey:@"hongbaoinfo"];
            for (NSDictionary *dict in shoplist) {
                MyInviteModel *model = [[MyInviteModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                [inviteArray addObject:model];
            }
            [self reloadData];
        }
        else
        {
            self.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"haoyoupng"]];
        }
    } failure:^(NSError *error) {
        [dbud hide:YES];
        [self requestNetworkWrong:@"网络连接错误"];
    }];
    }
    else
    {
        self.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"haoyoupng"]];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return inviteArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    MyInvitationCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MyInvitationCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell reloadDataWithIndexpath:indexPath AndArray:inviteArray];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70*MCscale;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//错误提示
-(void)requestNetworkWrong:(NSString *)wrongStr
{
    MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    bud.mode = MBProgressHUDModeText;
    bud.labelText = wrongStr;
    [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
}
- (void)myTask {
    // Do something usefull in here instead of sleeping ...
    sleep(1.5);
}
@end
