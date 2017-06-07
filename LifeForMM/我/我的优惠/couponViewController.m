//
//  couponViewController.m
//  LifeForMM
//
//  Created by 时元尚品 on 15/7/23.
//  Copyright (c) 2015年 时元尚品. All rights reserved.
//

#import "couponViewController.h"
#import "Header.h"
#import "coupTableViewCell.h"
#import "UseDirectionViewController.h"
#import "myYouhModel.h"
@interface couponViewController ()<UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate>
{
    UITableView *listTabel;
    NSMutableArray *dataAry;
    MBProgressHUD *Hud;
}
@end

@implementation couponViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController.navigationBar setBarTintColor:txtColors(4, 196, 153, 1)];
    mainController *main = (mainController *)self.tabBarController;
    [main showOrHiddenTabBarView:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    __weak typeof (self) weakSelf = self;
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = weakSelf;
    }
    dataAry = [[NSMutableArray alloc]init];
    [self initNavigation];
    [self initTableView];
    [self reloadData];
//    [self upAryDataTesting];
}

-(void)initNavigation
{
    self.navigationItem.title = @"我的优惠";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:MLwordFont_2],NSFontAttributeName,nil]];
    UIButton *leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftbutton.frame = CGRectMake(0, 0, NVbtnWight, NVbtnWight);
    [leftbutton setBackgroundImage:[UIImage imageNamed:@"返回按钮"] forState:UIControlStateNormal];
    [leftbutton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    leftbutton.tag = 1001;
    UIBarButtonItem *leftbarBtn = [[UIBarButtonItem alloc]initWithCustomView:leftbutton];
    self.navigationItem.leftBarButtonItem =leftbarBtn;
}
-(void)reloadData
{
    Hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    Hud.mode = MBProgressHUDModeIndeterminate;
    Hud.delegate = self;
    Hud.labelText = @"请稍等...";
    [Hud show:YES];
    NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"userid":userName_tel}];
    [HTTPTool getWithUrl:@"myyouhui.action" params:pram success:^(id json) {
        [Hud hide:YES];
        NSArray *ary = [json valueForKey:@"youhui"];
        if (ary.count > 0) {
            for(NSDictionary *dic in ary){
                myYouhModel *modl = [[myYouhModel alloc]initWithContent:dic];
                [dataAry addObject:modl];
            }
            listTabel.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"白底.jpg"]];
        }
        else{
            listTabel.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"无优惠券"]];
        }
        [listTabel reloadData];
    } failure:^(NSError *error) {
        [Hud hide:YES];
        MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        bud.mode = MBProgressHUDModeCustomView;
        bud.labelText = @"网络连接错误";
        [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }];
}
//表
-(void)initTableView
{
    listTabel = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    listTabel.backgroundColor = [UIColor whiteColor];
    listTabel.delegate = self;
    listTabel.dataSource = self;
    listTabel.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,kDeviceWidth , 40)];
    headView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(kDeviceWidth/3.0, 10, 22*MCscale_1, 22*MCscale_1)];
    image.backgroundColor = [UIColor clearColor];
    image.image = [UIImage imageNamed:@"叹号"];
    [headView addSubview:image];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(image.right+5, 10, 100, 20)];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"优惠券使用说明";
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = textColors;
    label.font = [UIFont systemFontOfSize:MLwordFont_7];
    [headView addSubview:label];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = headView.bounds;
    btn.backgroundColor = [UIColor clearColor];
    btn.tag = 1002;
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:btn];
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 39, kDeviceWidth,1)];
    line1.backgroundColor = txtColors(193, 194, 196, 1);
    [headView addSubview:line1];
    listTabel.tableHeaderView = headView;
    [self.view addSubview:listTabel];
}
#pragma mark UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataAry.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    coupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[coupTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
    cell.model = dataAry[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140*MCscale;
}
#pragma mark btnAction
-(void)btnAction:(UIButton *)btn
{
    if (btn.tag == 1001) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        mainController *main = (mainController *)self.tabBarController;
        [main showOrHiddenTabBarView:NO];
    }
    if (btn.tag ==1002) {
        UseDirectionViewController *agr = [[UseDirectionViewController alloc]init];
        agr.pageUrl = [NSString stringWithFormat:@"%@gonggao/yhqshiyong.jsp",HTTPHEADER];
        agr.titStr = @"优惠券使用说明";
        [self.navigationController pushViewController:agr animated:YES];
    }
}
-(void)myTask
{
    sleep(1.5);
}
@end
