//
//  subCarVIewController.m
//  LifeForMM
//
//  Created by HUI on 15/9/15.
//  Copyright (c) 2015年 时元尚品. All rights reserved.
//

#import "subCarVIewController.h"
#import "mainController.h"
#import "carViewCell.h"
#import "Header.h"
#import "lifeCityViewController.h"
#import "SureOrderViewController.h"
#import "UserOrderViewController.h"
@interface subCarViewController ()<UITableViewDataSource,UITableViewDelegate,carCellViewDelegate,MBProgressHUDDelegate>
{
    UILabel *coupon,*moneyLabel;//以优惠  总价钱
    UIButton *goToOrder;//去下单
    CGFloat countMoney;
    UIView *deleatView;
    NSMutableArray *isOrNoSelectArray;//商品是否选中
    CGFloat numMony;//总价
    NSMutableArray *moneyArray;//所有单元格总价
    NSInteger sumCell;//单元格总数
    NSMutableArray *listDataAry;//数据数组
    NSMutableArray *goodNumAry;//存放商品的数量
    NSMutableArray *initGoodNumAry;//最初商品数量
    NSMutableArray *endIdAry;//存放最终数量发生改变商品id
    NSMutableArray *endNumAry;//存放最终数量发生改变商品数量
    NSInteger lastGoodNumAryCount;
    NSMutableArray *selectStateAry;//商品是否选中
}
@end

@implementation subCarViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:4.0/255.0 green:196.0/255.0 blue:153.0/255.0 alpha:1]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadListData) name:@"carAddGoods" object:nil];
//    mainController *main = (mainController *)self.tabBarController;
//    [main showOrHiddenTabBarView:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    isOrNoSelectArray = [[NSMutableArray alloc]init];
    moneyArray = [[NSMutableArray alloc]init];
    listDataAry = [[NSMutableArray alloc]init];
    goodNumAry = [[NSMutableArray alloc]init];
    initGoodNumAry = [[NSMutableArray alloc]init];
    endIdAry = [[NSMutableArray alloc]init];
    endNumAry = [[NSMutableArray alloc]init];
    selectStateAry = [[NSMutableArray alloc]init];
    numMony = 0;
    [self loadListData];
    [self initNavigation];
    [self loadTableView];
    [self loadFootView];
}
#pragma mark -- 购物车数据
-(void)loadListData
{
    //192.168.1.99:8080/oa/security/shop!findCar.action
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    NSMutableDictionary *pram = [NSMutableDictionary dictionaryWithDictionary:@{@"userId":userId}];
    [HTTPTool postWithUrl:@"shop!findCar.action" params:pram success:^(id json) {
        NSLog(@"网络请求成功");
        NSLog(@"-----++ ----%@",json);
        NSArray *ary = (NSArray * )json;
        [listDataAry removeAllObjects];
        [initGoodNumAry removeAllObjects];
        numMony = 0.0;
        if (ary.count >0) {
            NSLog(@"数据获取成功");
            _table.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"白底.jpg"]];
            for(NSDictionary *dic in ary)
            {
                carDataModel *carModel = [[carDataModel alloc]initWithContent:dic];
                [listDataAry addObject:carModel];
            }
            sumCell = listDataAry.count;
            [_table reloadData];
        }
        else
        {
            _table.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"购物车无数据.jpg"]];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"网络请求失败");
        NSLog(@"--------%@",error);
    }];
}
-(void)initNavigation
{
    self.navigationItem.title = @"购物车";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:MLwordFont_2],NSFontAttributeName,nil]];
    UIButton *leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftbutton.frame = CGRectMake(0, 0, NVbtnWight, NVbtnWight);
    [leftbutton setBackgroundImage:[UIImage imageNamed:@"返回按钮"] forState:UIControlStateNormal];
    [leftbutton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    leftbutton.tag = 1001;
    UIBarButtonItem *leftbarBtn = [[UIBarButtonItem alloc]initWithCustomView:leftbutton];
    self.navigationItem.leftBarButtonItem =leftbarBtn;
}
-(void)loadTableView
{
    _table = [[UITableView alloc]initWithFrame:CGRectMake(0, -35,kDeviceWidth, kDeviceHeight+35) style:UITableViewStyleGrouped];
    _table.delegate = self;
    _table.dataSource = self;
    _table.backgroundColor = [UIColor clearColor];
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_table];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return listDataAry.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [NSString stringWithFormat:@"Cell%ld%ld", indexPath.section, indexPath.row];
    carViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[carViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        UIView *btnView = [[UIView alloc]initWithFrame:CGRectMake(kDeviceWidth, 0, 200, 100*SCscale)];
        btnView.backgroundColor = txtColors(206, 207, 208, 1);
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(18/SCscale, 35*SCscale, 35*SCscale, 35*SCscale)];
        image.image = [UIImage imageNamed:@"红色删除"];
        [btnView addSubview:image];
        [cell.contentView addSubview:btnView];
    }
    cell.carModel = listDataAry[indexPath.row];
    cell.isFirst = 0;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.selectBool = 1;
    if (goodNumAry.count>indexPath.row) {
        cell.goodNum.text = goodNumAry[indexPath.row];
    }
    if (selectStateAry.count < listDataAry.count) {
        NSString *sel = @"1";
        [selectStateAry addObject:sel];
    }
    if ([selectStateAry[indexPath.row] isEqualToString:@"1"]) {
        cell.selectBool = 1;
        cell.selectImageView.image = [UIImage imageNamed:@"选中"];
    }
    else{
        cell.selectBool = 0;
        cell.selectImageView.image = [UIImage imageNamed:@"选择"];
    }
    cell.delegate = self;
    cell.tag = indexPath.row;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SCcellHeight;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",indexPath.row);
    [self delData:indexPath.row];
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
#pragma footView
-(void)loadFootView
{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, kDeviceHeight-49, kDeviceWidth, 49)];
    footView.backgroundColor = [UIColor colorWithRed:25.0/255.0 green:182.0/255.0 blue:133.0/255.0 alpha:0.8];
    
    moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 10, 120, 30)];
    moneyLabel.textColor = [UIColor colorWithRed:237.0/255.0 green:58.0/255.0 blue:76.0/255.0 alpha:1];
    moneyLabel.textAlignment = NSTextAlignmentLeft;
    //    moneyLabel.text = @"";
    moneyLabel.backgroundColor = [UIColor clearColor];
    moneyLabel.font = [UIFont systemFontOfSize:21];
    [footView addSubview:moneyLabel];
    
    goToOrder = [UIButton buttonWithType:UIButtonTypeCustom];
    goToOrder.frame = CGRectMake(kDeviceWidth-120, 10, 100, 30);
    goToOrder.backgroundColor = [UIColor clearColor];
    [goToOrder setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [goToOrder setTitle:@"去下单" forState:UIControlStateNormal];
    [goToOrder setBackgroundImage:[UIImage imageNamed:@"去下单"] forState:UIControlStateNormal];
    [goToOrder addTarget:self action:@selector(goToCheck) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:goToOrder];
    [self.view addSubview:footView];
}
#pragma mark -- carViewCellDelegate
//改变数据
-(void)carViewCell:(carViewCell *)cellView atIndex:(NSInteger)index addoOrCut:(NSInteger)bol numMoney:(CGFloat)money cellSelect:(BOOL)sel
{
    
    if (sel == 0) {
        [selectStateAry replaceObjectAtIndex:index withObject:@"0"];
    }
    else
        [selectStateAry replaceObjectAtIndex:index withObject:@"1"];
    
    NSInteger num = [goodNumAry[index] integerValue];
    if(sel == 1)
    {
        if (bol == 0) {
            numMony -=money;
            num--;
        }
        else if (bol== 1)
        {
            numMony+=money;
            num++;
        }
        else
        {
            numMony +=money;
        }
    }
    else
    {
        if (bol == 0) {
            num--;
        }
        else if (bol==1)
        {
            num++;
        }
        else
        {
            numMony-=money;
        }
    }
    
    NSString *strNum = [NSString stringWithFormat:@"%ld",num];
    [goodNumAry replaceObjectAtIndex:index withObject:strNum];
    moneyLabel.text = [NSString stringWithFormat:@"¥%.2f",numMony];
}

//初始化
-(void)carviewCell:(carViewCell *)cellView countMoney:(CGFloat)sumMoney goodNum:(NSInteger)labNum
{
    NSString *str = [NSString stringWithFormat:@"%.2lf",sumMoney];
    if (moneyArray.count < listDataAry.count) {
        [moneyArray addObject:str];
    }
    NSIndexPath *indePat = [_table indexPathForCell:cellView];
    if (sumCell>0) {
        sumCell--;
        numMony += sumMoney;
        moneyLabel.text = [NSString stringWithFormat:@"¥%.2f",numMony];
        NSString *num = [NSString stringWithFormat:@"%ld",labNum];
        [goodNumAry addObject:num];
        [initGoodNumAry addObject:num];//最初购物车物品数量
    }
    //    cellView.goodNum.text = [NSString stringWithFormat:@"%ld",labNum];
    if (indePat.row<goodNumAry.count) {
        cellView.goodNum.text = goodNumAry[indePat.row];
    }
}
-(void)goToCheck
{
    NSLog(@"去下单");
    if (listDataAry.count >0) {
        //        [self checkChangeData];
        //    [initGoodNumAry removeAllObjects];
        SureOrderViewController *sureOrderVc = [[SureOrderViewController alloc]init];
        [self.navigationController pushViewController:sureOrderVc animated:YES];
        //        UserOrderViewController *vc = [[UserOrderViewController alloc]init];
        //        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.delegate = self;
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"购物车还是空的!先加件商品再试试!";
        [hud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }
}
#pragma mark -- 返回时上传改变数据
-(void)backChangeData
{
    NSString *godId = [endIdAry componentsJoinedByString:@","];
    NSString *shuliang = [endNumAry componentsJoinedByString:@","];
    NSMutableDictionary *pram = [NSMutableDictionary dictionaryWithDictionary:@{@"id":godId,@"shuliang":shuliang}];
    [HTTPTool postWithUrl:@"shop!updateCar.action" params:pram success:^(id json) {
        NSLog(@"网络请求成功");
        NSLog(@"-----返回时上传改变数据----%@",json);
        NSArray *ary = (NSArray * )json;
        NSString *message = [NSString stringWithFormat:@"%@",[ary[0] valueForKey:@"message"]];
        if ([message isEqualToString:@"1"]) {
            NSLog(@"数据改变,上传成功");
            NSNotification *notification = [NSNotification notificationWithName:@"subCarGoodsChange" object:nil];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            [[NSNotificationCenter defaultCenter] removeObserver:self];
        }
    } failure:^(NSError *error) {
        NSLog(@"网络请求失败");
        NSLog(@"--------%@",error);
    }];
}
#pragma mark -- 确认下单上传数据
-(void)checkChangeData
{
    //192.168.1.99:8080/oa/security/shop!updateCar.action
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    NSMutableDictionary *pram = [NSMutableDictionary dictionaryWithDictionary:@{@"userId":userId}];
    [HTTPTool postWithUrl:@"shop!findCar.action" params:pram success:^(id json) {
        NSLog(@"网络请求成功");
        NSLog(@"-----确认下单上传数据----%@",json);
        NSArray *ary = (NSArray * )json;
        if (ary.count >0) {
            NSLog(@"数据获取成功");
        }
    } failure:^(NSError *error) {
        NSLog(@"网络请求失败");
        NSLog(@"--------%@",error);
    }];
}
#pragma mark -- 删除数据
-(void)delData:(NSInteger)index
{
    carDataModel *carModel = listDataAry[index];
    NSString *goid = carModel.goodId;
    NSMutableDictionary *pram = [NSMutableDictionary dictionaryWithDictionary:@{@"id":goid}];
    [HTTPTool postWithUrl:@"shop!deleteCar.action" params:pram success:^(id json) {
        NSLog(@"网络请求成功");
        NSLog(@"-----删除数据----%@",json);
        NSArray *ary = (NSArray * )json;
        NSString *massage = [NSString stringWithFormat:@"%@",[ary[0] valueForKey:@"massage"]];
        if ([massage isEqualToString:@"1"]) {
            [listDataAry removeObjectAtIndex:index];
            if(listDataAry.count <= 0)
            {
                _table.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"购物车无数据.jpg"]];
            }
            NSNotification *shopPageNotificat = [NSNotification notificationWithName:@"subCarDeleatGoods" object:nil];
            [[NSNotificationCenter defaultCenter]postNotification:shopPageNotificat];
            [[NSNotificationCenter defaultCenter] removeObserver:self];
            lastGoodNumAryCount = goodNumAry.count;
            [goodNumAry removeObjectAtIndex:index];
            [initGoodNumAry removeObjectAtIndex:index];
            
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
            carViewCell *cell = (carViewCell *)[_table cellForRowAtIndexPath:indexPath];
            NSString *jiage = [cell.moneyNum.text substringFromIndex:1];
            NSString *shuliang = cell.goodNum.text;
            CGFloat jig = [jiage floatValue];
            NSInteger shl = [shuliang integerValue];
            if([selectStateAry[index] isEqualToString:@"1"])
            {
                numMony =numMony - jig*shl;
                moneyLabel.text = [NSString stringWithFormat:@"¥%.2f",numMony];
            }
            [selectStateAry removeObjectAtIndex:index];
            [_table reloadData];
        }
    } failure:^(NSError *error) {
        NSLog(@"网络请求失败");
        NSLog(@"--------%@",error);
    }];
}
-(void)btnAction:(UIButton *)btn
{
    [self numChange];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)numChange
{
    [endNumAry removeAllObjects];
    [endIdAry removeAllObjects];
    //    [initGoodNumAry removeAllObjects];
    for (int i = 0 ; i<initGoodNumAry.count; i++) {
        carDataModel *carModel = listDataAry[i];
        NSString *goId = carModel.goodId;
        if (![goodNumAry[i] isEqualToString:initGoodNumAry[i]]) {
            [endIdAry addObject:goId];
            [endNumAry addObject:goodNumAry[i]];
            [initGoodNumAry replaceObjectAtIndex:i withObject:goodNumAry[i]];
        }
    }
    if (endNumAry.count > 0) {
        [self backChangeData];
    }
}
-(void)startOrder
{
    ///192.168.1.99:8080/oa/security/shop!PlaceCar.action?userId=93
    NSString *userId = [[NSUserDefaults standardUserDefaults] valueForKey:@"userId"];
    NSMutableDictionary *pram = [NSMutableDictionary dictionaryWithDictionary:@{@"userId":userId}];
    [HTTPTool postWithUrl:@"shop!PlaceCar.action" params:pram success:^(id json) {
        NSLog(@"网络请求成功");
        NSLog(@"-----下单----%@",json);
        NSArray *ary = (NSArray * )json;
        if (ary.count >0) {
            NSLog(@"数据获取成功");
        }
    } failure:^(NSError *error) {
        NSLog(@"网络请求失败");
        NSLog(@"--------%@",error);
    }];
}
- (void)myTask {
    // Do something usefull in here instead of sleeping ...
    sleep(1.5);
}
@end

