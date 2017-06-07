//
//  ReductionViewController.m
//  LifeForMM
//
//  Created by MIAO on 2016/12/23.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import "ReductionViewController.h"
#import "ActivityModel.h"
#import "ActivityCell.h"
#import "shopController.h"
#import "Header.h"
@interface ReductionViewController ()<UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource,MBProgressHUDDelegate>

@end

@implementation ReductionViewController
{
    UITableView *mainTableView;
    NSMutableArray *huodongArray;
}
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
    __weak typeof (self) weakSelf = self;
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = weakSelf;
    }
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    huodongArray = [NSMutableArray arrayWithCapacity:0];
    [self initNavigation];
    [self initSubViews];
    [self getYouhuiData];
}
-(void)initNavigation
{
    self.navigationItem.title = @"任性减";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:MLwordFont_2],NSFontAttributeName,nil]];
    UIButton *leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftbutton.frame = CGRectMake(0, 0, NVbtnWight, NVbtnWight);
    [leftbutton setBackgroundImage:[UIImage imageNamed:@"返回按钮"] forState:UIControlStateNormal];
    [leftbutton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    leftbutton.tag = 1001;
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftbutton];
    self.navigationItem.leftBarButtonItem = leftItem;
}

-(void)initSubViews
{
    mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kDeviceWidth, kDeviceHeight - 64) style:UITableViewStylePlain];
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:mainTableView];
}

#pragma mark 获取优惠数据
-(void)getYouhuiData
{
    MBProgressHUD *md = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    md.mode = MBProgressHUDModeIndeterminate;
    md.delegate = self;
    md.labelText = @"请稍等...";
    [md show:YES];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableDictionary *pram = [NSMutableDictionary dictionaryWithDictionary:@{@"id":userShequ_id}];
        [HTTPTool getWithUrl:@"findbyshequdianpuhuodong.action" params:pram success:^(id json) {
            [md hide:YES];
            NSLog(@"优惠 %@",json);
            if ([[json valueForKey:@"massages"]integerValue]==1) {
                NSDictionary *dc = (NSDictionary *)json;
                NSArray *shoplist = [dc valueForKey:@"list"];
                for (NSDictionary *dict in shoplist) {
                    ActivityModel *model = [[ActivityModel alloc]init];
                    [model setValuesForKeysWithDictionary:dict];
                    [huodongArray addObject:model];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [mainTableView reloadData];
                });
            }
            else
            {
                mainTableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"任性减"]];
            }
        } failure:^(NSError *error) {
            [md hide:YES];
            [self requestNetworkWrong:@"网络连接错误3"];
        }];
    });
}
#pragma mark UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return huodongArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    ActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[ActivityCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell reloadDataWithIndexPath:indexPath AndArray:huodongArray];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    shopController *shop = [[shopController alloc]init];
        ActivityModel *model = huodongArray[indexPath.row];
        shop.shopId = model.dianpuid;
        shop.shopName = model.dianpuname;
//        NSString *shopState = [NSString stringWithFormat:@"%@",model.zhuangtaipaihu];
//        if ([shopState isEqualToString:@"3"]) {
//            shop.isReset = 1;
//        }
//        else
//            shop.isReset = 0;
        shop.isHuodong = @"1";
        [self.navigationController pushViewController:shop animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ActivityModel *model = huodongArray[indexPath.row];
    CGFloat height = model.huodngs.count * 30*MCscale +55*MCscale;
    return height;
}

-(void)btnAction:(UIButton *)button
{
    if (button.tag == 1001) {
        mainController *main = (mainController *)self.tabBarController;
        [main showOrHiddenTabBarView:NO];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
//错误提示
-(void)requestNetworkWrong:(NSString *)wrongStr
{
    MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    bud.mode = MBProgressHUDModeText;
    bud.labelText = wrongStr;
    [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
}
- (void)myTask {
    // Do something usefull in here instead of sleeping ...
    sleep(1.5);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
