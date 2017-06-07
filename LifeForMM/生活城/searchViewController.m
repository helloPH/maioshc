//
//  searchViewController.m
//  LifeForMM
//
//  Created by 时元尚品 on 15/7/22.
//  Copyright (c) 2015年 时元尚品. All rights reserved.
//

#import "searchViewController.h"
#import "Header.h"
#import "searchCell.h"
#import "GoodDetailViewController.h"
@interface searchViewController ()<UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate,UITextFieldDelegate>
{
    UITextField *searchFiled; // 搜索框
    NSString *filedTextValue;
    UITableView *searchTable;
    NSMutableArray *dataAry;
    UIView *line3;
    UIView *backView;
}
@end

@implementation searchViewController
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
    dataAry = [[NSMutableArray alloc]init];
    
    [self initNavigation];
    [self loadHeadView];
    [self loadTableView];
    if (self.viewTag == 1) {
        [self getShequDefaultShangpin];
    }
    else
    {
        [self getDianpuDefaultShangpin];
    }
}
-(void)initNavigation
{
    self.navigationItem.title = @"搜索商品";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:MLwordFont_2],NSFontAttributeName,nil]];
    UIButton *leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftbutton.frame = CGRectMake(0, 0, NVbtnWight, NVbtnWight);
    [leftbutton setBackgroundImage:[UIImage imageNamed:@"返回按钮"] forState:UIControlStateNormal];
    [leftbutton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    leftbutton.tag = 1001;
    UIBarButtonItem *leftbarBtn = [[UIBarButtonItem alloc]initWithCustomView:leftbutton];
    self.navigationItem.leftBarButtonItem =leftbarBtn;
}
#pragma mark 获取社区默认商品
-(void)getShequDefaultShangpin
{
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"请稍等...";
    [HUD show:YES];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"shequid":userShequ_id}];
        [HTTPTool getWithUrl:@"findbyshequrenxiao.action" params:pram success:^(id json) {
            [HUD hide:YES];
            [dataAry removeAllObjects];
            NSLog(@"默认商品%@",json);
            
            NSArray *ary = [json valueForKey:@"shop"];
            if([[json valueForKey:@"massages"]integerValue]==1){
                if (ary.count >0) {
                    searchTable.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"白底"]];
                    for(NSDictionary *dc in ary){
                        searchGoodModel *model = [[searchGoodModel alloc]initWithContent:dc];
                        [dataAry addObject:model];
                    }
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [searchTable reloadData];
            });
        } failure:^(NSError *error) {
            [HUD hide:YES];
            MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            bud.mode = MBProgressHUDModeCustomView;
            bud.labelText = @"网络连接错误";
            [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
        }];
    });
}

#pragma mark 获取店铺默认商品
-(void)getDianpuDefaultShangpin
{
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"请稍等...";
    [HUD show:YES];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
    NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"dianpuid":_dianpuId}];
    [HTTPTool getWithUrl:@"findbydianpurexiao.action" params:pram success:^(id json) {
        [HUD hide:YES];
        [dataAry removeAllObjects];
        NSLog(@"店铺默认商品%@",json);
        NSArray *ary = [json valueForKey:@"shop"];
        if([[json valueForKey:@"massages"]integerValue]==1){
            if (ary.count >0) {
                searchTable.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"白底"]];
                for(NSDictionary *dc in ary){
                    searchGoodModel *model = [[searchGoodModel alloc]initWithContent:dc];
                    [dataAry addObject:model];
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [searchTable reloadData];
        });
    } failure:^(NSError *error) {
        [HUD hide:YES];
        MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        bud.mode = MBProgressHUDModeCustomView;
        bud.labelText = @"网络连接错误";
        [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }];
         });
}


#pragma mark 搜索社区商品
-(void)loadData
{
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"请稍等...";
    [HUD show:YES];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"shequid":userShequ_id,@"shangpinname":filedTextValue}];
        [HTTPTool getWithUrl:@"findShopByName.action" params:pram success:^(id json) {
            [HUD hide:YES];
            NSLog(@"搜索社区商品%@",json);
            backView.hidden = YES;
            searchTable.frame= CGRectMake(0, searchFiled.bottom+10*MCscale, kDeviceWidth, kDeviceHeight-searchFiled.bottom-10);
            [dataAry removeAllObjects];
            NSArray *ary = [json valueForKey:@"shop"];
            if([json valueForKey:@"massages"]){
                searchTable.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"搜索无数据.jpg"]];
                MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                mbHud.mode = MBProgressHUDModeText;
                mbHud.labelText = @"没有搜索到相关物品";
                [mbHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
            }
            else{
                searchTable.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"白底"]];
                for(NSDictionary *dc in ary){
                    searchGoodModel *model = [[searchGoodModel alloc]initWithContent:dc];
                    [dataAry addObject:model];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [searchTable reloadData];
            });
        } failure:^(NSError *error) {
            [HUD hide:YES];
            MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            bud.mode = MBProgressHUDModeCustomView;
            bud.labelText = @"网络连接错误";
            [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
        }];
    });
}

#pragma mark 搜索店铺商品
-(void)loadDianpuData
{
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"请稍等...";
    [HUD show:YES];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
    NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"dianpuid":_dianpuId,@"shangpinname":filedTextValue}];
    [HTTPTool getWithUrl:@"findbydinapushopname.action" params:pram success:^(id json) {
        [HUD hide:YES];
        backView.hidden = YES;
        searchTable.frame= CGRectMake(0, searchFiled.bottom+10*MCscale, kDeviceWidth, kDeviceHeight-searchFiled.bottom-10);
        [dataAry removeAllObjects];
        NSLog(@"店铺搜索%@",json);
        NSArray *ary = [json valueForKey:@"shop"];
        if([[json valueForKey:@"massages"]integerValue]==0){
            searchTable.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"搜索无数据.jpg"]];
            MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            mbHud.mode = MBProgressHUDModeText;
            mbHud.labelText = @"没有搜索到相关物品";
            [mbHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
        }
        else{
            searchTable.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"白底"]];
            for(NSDictionary *dc in ary){
                searchGoodModel *model = [[searchGoodModel alloc]initWithContent:dc];
                [dataAry addObject:model];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [searchTable reloadData];
        });
    } failure:^(NSError *error) {
        [HUD hide:YES];
        MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        bud.mode = MBProgressHUDModeCustomView;
        bud.labelText = @"网络连接错误";
        [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }];
    });
}
-(void)loadHeadView
{
    searchFiled = [[UITextField alloc]initWithFrame:CGRectMake(kDeviceWidth/10.0, 84, SEtxtfiledWidth, 30)];
    searchFiled.placeholder = @"请输入商品名称";
    searchFiled.textAlignment = NSTextAlignmentLeft;
    filedTextValue = searchFiled.text;
    searchFiled.textColor = [UIColor blackColor];
    searchFiled.delegate = self;
    searchFiled.font = [UIFont systemFontOfSize:MLwordFont_4];
    searchFiled.backgroundColor = [UIColor clearColor];
    searchFiled.returnKeyType = UIReturnKeyDone;
    [self .view addSubview:searchFiled];
    
    UIView *btview = [[UIView alloc]initWithFrame:CGRectMake(searchFiled.right+20, SEbtnSpace, 60*MCscale, 25*SCscale)];
    btview.userInteractionEnabled = YES;
    btview.backgroundColor = [UIColor clearColor];
    [self.view addSubview:btview];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(searchAction)];
    [btview addGestureRecognizer:tap];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 25*SCscale, 25*SCscale);
    btn.backgroundColor = [UIColor clearColor];
    [btn setBackgroundImage:[UIImage imageNamed:@"灰色搜索"] forState:UIControlStateNormal];
    btn.tag = 1002;
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [btview addSubview:btn];
    
    UIView *line0 = [[UIView alloc]initWithFrame:CGRectMake(searchFiled.left-5, searchFiled.bottom, searchFiled.width+10, 1)];
    line0.backgroundColor = txtColors(25, 182, 133, 1);
    [self.view addSubview:line0];
    UIView *line1 =[[UIView alloc]initWithFrame:CGRectMake(line0.left, searchFiled.bottom-2, 1, 3)];
    line1.backgroundColor = txtColors(25, 182, 133, 1);
    [self.view addSubview:line1];
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(line0.right, searchFiled.bottom-2, 1, 3)];
    line2.backgroundColor = txtColors(25, 182, 133, 1);
    [self.view addSubview:line2];
    line3 = [[UIView alloc]initWithFrame:CGRectMake(0, searchFiled.bottom+9, kDeviceWidth, 1)];
    line3.backgroundColor = lineColor;
    [self.view addSubview:line3];
}
-(void)loadTableView
{
    backView = [[UIView alloc]initWithFrame:CGRectMake(0,line3.bottom,kDeviceWidth,25*MCscale)];
    backView.backgroundColor = [UIColor clearColor];//txtColors(242, 242, 242, 1)
    [self.view addSubview:backView];
    
    UILabel *fenleiLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,0, 70*MCscale, 20*MCscale)];
    fenleiLabel.center = CGPointMake(backView.width/2.0, 15*MCscale);
    fenleiLabel.textAlignment = NSTextAlignmentCenter;
    fenleiLabel.text = @"最新热销";
    fenleiLabel.textColor = txtColors(173, 173, 173, 1);
    fenleiLabel.font = [UIFont systemFontOfSize:MLwordFont_5];
    [backView addSubview:fenleiLabel];
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(70*MCscale,15*MCscale,(kDeviceWidth-230*MCscale)/2.0,0.5)];
    line1.backgroundColor = txtColors(173, 173, 173, 1);
    [backView addSubview:line1];
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(fenleiLabel.right +10*MCscale, 15*MCscale,(kDeviceWidth-230*MCscale)/2.0,0.5)];
    line2.backgroundColor = txtColors(173, 173, 173, 1);
    [backView addSubview:line2];
    
    searchTable = [[UITableView alloc]initWithFrame:CGRectMake(0, backView.bottom, kDeviceWidth, kDeviceHeight-searchFiled.bottom-10) style:UITableViewStyleGrouped];
    searchTable.dataSource = self;
    searchTable.delegate = self;
    searchTable.backgroundColor = [UIColor whiteColor];
    searchTable.separatorInset = UIEdgeInsetsMake(0, 0, 0, 30);
    searchTable.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"白底"]];
    [self.view addSubview:searchTable];
}
#pragma mark --UITableviewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataAry.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.separatorStyle = UITableViewCellStyleDefault;
    static NSString *identifier = @"cell";
    searchCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[searchCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.secmodel = dataAry[indexPath.row];
    cell.userInteractionEnabled = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (![dataAry[indexPath.row] isEqual:nil]) {
        searchGoodModel *modl = dataAry[indexPath.row];
        GoodDetailViewController *vc = [[GoodDetailViewController alloc]init];
        vc.goodId = modl.god_id;
        vc.dianpuId = modl.dianpuid;
        vc.godShequid = userShequ_id;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (dataAry.count == 0) {
        return 40*MCscale;
    }
    return 80*MCscale;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
-(void)btnAction:(UIButton *)btn
{
    if (btn.tag == 1001) {
        mainController *main = (mainController *)self.tabBarController;
        [main showOrHiddenTabBarView:NO];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    if (btn.tag == 1002) {
        if ([searchFiled.text isEqualToString:@""]) {
            MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            mbHud.mode = MBProgressHUDModeText;
            mbHud.labelText = @"关键字不能为空!";
            [mbHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
        }
        else{
            [self.view endEditing:YES];
            filedTextValue = searchFiled.text;
            if (self.viewTag == 1) {
                [self loadData];
            }
            else
            {
                [self loadDianpuData];
            }
        }
    }
}
-(void)searchAction
{
    if ([searchFiled.text isEqualToString:@""]) {
        MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        mbHud.mode = MBProgressHUDModeText;
        mbHud.labelText = @"关键字不能为空!";
        [mbHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }
    else{
        [self.view endEditing:YES];
        filedTextValue = searchFiled.text;
        if (self.viewTag == 1) {
            [self loadData];
        }
        else
        {
            [self loadDianpuData];
        }
        
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self searchAction];
    [searchFiled resignFirstResponder];
    return YES;
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [searchFiled resignFirstResponder];
}
-(void)viewWillDisappear:(BOOL)animated
{
    //    mainController *main = (mainController *)self.tabBarController;
    //    [main showOrHiddenTabBarView:NO];
}
- (void)myTask {
    // Do something usefull in here instead of sleeping ...
    sleep(1.5);
}
@end
