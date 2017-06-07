//
//  orderDetailViewController.m
//  LifeForMM
//
//  Created by 时元尚品 on 15/7/23.
//  Copyright (c) 2015年 时元尚品. All rights reserved.
//

#import "orderDetailViewController.h"
#import "Header.h"
#import "detailViewCell.h"
#import "orderMoreArginController.h"
#import "orderAgnVisitorViewController.h"
#import "orderDetailModel.h"
#import "shopController.h"
#import "ReceiveBenefitsView.h"
#import "MaskView.h"
#import "FuliModel.h"
#import "AFNetworking.h"
#import "ShareRedPackView.h"
#import "DetailTableHeadView.h"
#import "DetailTableFootView.h"
#import "DetailSectionHeaderView.h"
@interface orderDetailViewController ()<UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource,MBProgressHUDDelegate,ReceiveBenefitsViewDelegate,ShareRedPackViewDelegate,DetailSectionHeaderViewDelegate>
{
    UITableView *detailTableView;
    ShareRedPackView *shareRedPack;//分享红包弹框
    UIImageView *redPack;
    NSMutableArray *dataAry;
    NSMutableArray *orderMessageAry;
    NSMutableArray *fuliAry;
    
    NSInteger cellNum;
    ReceiveBenefitsView *receiveBenefits;
    MaskView *mask;
    orderDetailModel *model;
}
@end

@implementation orderDetailViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:txtColors(4, 196, 153, 1)];
    mainController *main = (mainController *)self.tabBarController;
    [main showOrHiddenTabBarView:YES];
    
    [self reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if (_isOrderAgn) {
        __weak typeof (self) weakSelf = self;
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
            self.navigationController.interactivePopGestureRecognizer.delegate = weakSelf;
        }
    }
    else
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    dataAry = [[NSMutableArray alloc]init];
    orderMessageAry = [[NSMutableArray alloc]init];
    fuliAry = [NSMutableArray array];
    [self initNavigation];
    [self initTableView];
    [self maskView];
    [self initPopView];
    [self initNewAddressPop];
}

-(void)reloadData
{
    [dataAry removeAllObjects];
    MBProgressHUD *Hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    Hud.mode = MBProgressHUDModeIndeterminate;
    Hud.delegate = self;
    Hud.labelText = @"请稍等...";
    [Hud show:YES];
    NSMutableDictionary *pram = [NSMutableDictionary dictionaryWithDictionary:@{@"userid":user_id,@"dindan.danhao":_dingdanId}];
    [HTTPTool getWithUrl:@"finddingdanxiangqing3.action" params:pram success:^(id json) {
        [Hud hide:YES];
        NSLog(@"大法师打发的说法都是对方%@",json);
        
        
        NSDictionary *dic = [json valueForKey:@"dingdanxp"];
        model = [[orderDetailModel alloc]init];
        [model setValuesForKeysWithDictionary:dic];
        [dataAry addObject:model];
        //            orderDetailModel *model = dataAry[0];
        NSString *dingdanhao = model.dingdanhao; //订单号
        [orderMessageAry addObject:dingdanhao];
        NSString *shouhuoren = model.shouhuoren;//收货人
        [orderMessageAry addObject:shouhuoren];
        NSString *tel = model.tel; //电话
        [orderMessageAry addObject:tel];
        NSString *address = model.shouhuodizhi; //收货地址
        [orderMessageAry addObject:address];
        NSString *zhifustyle;
        if ([model.zhifufangshi isEqualToString:@"1"]) {
            zhifustyle = @"货到付款";
        }
        else if ([model.zhifufangshi isEqualToString:@"2"]){
            zhifustyle = @"在线支付";
        }
        else
            zhifustyle = @"余额支付";
        [orderMessageAry addObject:zhifustyle];
        NSString *xiadanTime = model.yuyuesongda; //下单时间
        if([xiadanTime isEqualToString:@"0"]){
            [orderMessageAry addObject:@"立即配送"];
        }
        else
            [orderMessageAry addObject:xiadanTime];
        NSString *fptt = model.fapiaotaitou;
        [orderMessageAry addObject:fptt]; //发票抬头
        [self tabelHeadView];
        [self tableFootView];
        [self initFootView];
        [detailTableView reloadData];
        NSString *sbid = [NSString stringWithFormat:@"%@",userSheBei_id];
        NSString *usid = [NSString stringWithFormat:@"%@",user_id];
        if ([[dic valueForKey:@"youhuiquanstatus"]integerValue]==0 && ![sbid isEqualToString:usid]) {
            [self redPackets];
        }
        if ([[NSString stringWithFormat:@"%@",model.dindanzhuangtai] isEqualToString:@"1"]) {
            [self reloadDataWithFuli];
        }
        //dianpustate            //店铺跳转（0：不跳）
    } failure:^(NSError *error) {
        [Hud hide:YES];
        MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        bud.mode = MBProgressHUDModeCustomView;
        bud.labelText = @"网络连接错误1";
        [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }];
}
-(void)reloadDataWithFuli
{
    MBProgressHUD *Hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    Hud.mode = MBProgressHUDModeIndeterminate;
    Hud.delegate = self;
    Hud.labelText = @"请稍等...";
    [Hud show:YES];
    NSMutableDictionary *pram = [NSMutableDictionary dictionaryWithDictionary:@{@"dindan.danhao":_dingdanId}];
    [HTTPTool getWithUrl:@"showFuli.action" params:pram success:^(id json) {
        [Hud hide:YES];
        if ([json integerForKey:@"message"] == 1) {
            NSArray *fuliArr = [json valueForKey:@"fulishop"];
            for (NSDictionary *dic in  fuliArr) {
                FuliModel *fuliModel = [[FuliModel alloc]init];
                [fuliModel setValuesForKeysWithDictionary:dic];
                [fuliAry addObject:fuliModel];
            }
            [receiveBenefits reloadDataFromArray:fuliAry AndDanhao:_dingdanId];
            [UIView animateWithDuration:0.3 animations:^{
                mask.alpha = 1;
                [self .view addSubview:mask];
                receiveBenefits.alpha = 0.95;
                [self.view addSubview:receiveBenefits];
            }];
        }
    } failure:^(NSError *error) {
        [Hud hide:YES];
        MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        bud.mode = MBProgressHUDModeCustomView;
        bud.labelText = @"网络连接错误2";
        [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }];
}
//弹框遮罩
-(void)maskView
{
    mask = [[MaskView alloc]initWithFrame:CGRectMake(0, 64, kDeviceWidth, kDeviceHeight-64)];
    mask.alpha = 0;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(maskDisMiss)];
    [mask addGestureRecognizer:tap];
    [self.view addSubview:mask];
}
-(void)maskDisMiss
{
    [UIView animateWithDuration:0.3 animations:^{
        mask.alpha = 0;
        [mask removeFromSuperview];
        receiveBenefits.alpha = 0;
        [self.view endEditing:YES];
        [receiveBenefits removeFromSuperview];
    }];
}
//使用新地址
-(void)initNewAddressPop
{
    receiveBenefits = [[ReceiveBenefitsView alloc]initWithFrame:CGRectMake(30*MCscale, 150*MCscale, kDeviceWidth- 60*MCscale,300*MCscale)];
    receiveBenefits.alpha = 0;
    receiveBenefits.receiveBenefitsdelegate = self;
}
#pragma mark ReceiveBenefitsdelegate
-(void)reloadDataWithFuliName
{
    [UIView animateWithDuration:0.3 animations:^{
        mask.alpha = 0;
        [mask removeFromSuperview];
        receiveBenefits.alpha = 0;
        [receiveBenefits removeFromSuperview];
    }];
    [self reloadData];
    [detailTableView reloadData];
}
-(void)initNavigation
{
    self.navigationItem.title = @"订单详情";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:MLwordFont_2],NSFontAttributeName,nil]];
    UIButton *leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftbutton.frame = CGRectMake(0, 0, NVbtnWight, NVbtnWight);
    [leftbutton setBackgroundImage:[UIImage imageNamed:@"返回按钮"] forState:UIControlStateNormal];
    [leftbutton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    leftbutton.tag = 1001;
    UIBarButtonItem *leftbarBtn = [[UIBarButtonItem alloc]initWithCustomView:leftbutton];
    self.navigationItem.leftBarButtonItem =leftbarBtn;
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, NVbtnWight, NVbtnWight);
    [rightButton setImage:[UIImage imageNamed:@"主页"] forState:UIControlStateNormal];
    rightButton.tag = 1002;
    [rightButton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
}
-(void)initTableView
{
    detailTableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    detailTableView.delegate = self;
    detailTableView.dataSource = self;
    detailTableView.backgroundColor = [UIColor whiteColor];
    detailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:detailTableView];
}
-(void)tabelHeadView
{
    NSString *zhuangt = [NSString stringWithFormat:@"%@",model.dindanzhuangtai];
    DetailTableHeadView *headView = [[DetailTableHeadView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 90*MCscale) AndString:zhuangt];
    detailTableView.tableHeaderView = headView;
}
-(void)tableFootView
{
    DetailTableFootView *footView = [[DetailTableFootView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 189) AndString:model.dindanbeizhu];
    detailTableView.tableFooterView = footView;
}
-(void)initFootView
{
    BOOL isTh = 0;
    NSArray *ary = model.shoplist;
    for (NSDictionary *dic in ary) {
        NSString *shuxing = [NSString stringWithFormat:@"%@",[dic valueForKey:@"shopshuxing"]];
        if ([shuxing isEqualToString:@"5"]) {
            isTh =1;
        }
    }
    if (_isOrderAgn && !isTh) {
        UIView *fotView = [[UIView alloc]initWithFrame:CGRectMake(0, kDeviceHeight-49, kDeviceWidth, 49)];
        fotView.userInteractionEnabled = YES;
        fotView.backgroundColor = txtColors(67, 205, 166, 1);
        UIButton *orderAgain = [UIButton buttonWithType:UIButtonTypeCustom];
        orderAgain.frame = CGRectMake(kDeviceWidth/2.0 -50*MCscale, 9*MCscale, 100*MCscale, 32*MCscale);
        [orderAgain setTintColor:[UIColor whiteColor]];
        [orderAgain setTitle:@"再来一单" forState:UIControlStateNormal];
        orderAgain.titleLabel.font = [UIFont boldSystemFontOfSize:MLwordFont_11];
        [orderAgain setBackgroundColor:txtColors(249, 54, 73, 1)];
        orderAgain.tag = 1007;
        [orderAgain addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        orderAgain.layer.masksToBounds = YES;
        orderAgain.layer.cornerRadius = 3.0;
        [fotView addSubview:orderAgain];
        [self.view addSubview:fotView];
    }
}
-(void)redPackets
{
    redPack = [[UIImageView alloc]initWithFrame:CGRectMake(kDeviceWidth*4/7.0, kDeviceHeight/2.0, 76*MCscale, 80*MCscale)];
    redPack.backgroundColor = [UIColor clearColor];
    redPack.image = [UIImage imageNamed:@"红包"];
    redPack.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapRedPack)];
    [redPack addGestureRecognizer:tap];
    [self.view addSubview:redPack];
}
-(void)initPopView
{
    shareRedPack = [[ShareRedPackView alloc]initWithFrame:CGRectMake(kDeviceWidth/10.0, 150*MCscale, kDeviceWidth*4/5.0, 250*MCscale)];
    shareRedPack.shareRedPackDelegate = self;
}

#pragma mark ShareRedPackViewDelegate
-(void)reloadDataFromShareRedPackWithTag:(NSInteger)tag
{
    [UIView animateWithDuration:0.3 animations:^{
        shareRedPack.alpha = 0;
        [shareRedPack removeFromSuperview];
    }];
}

-(void)reloadDataFromShareRedPackWithIndex:(NSInteger)index
{
    if (index < 0) {
        MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        mbHud.mode = MBProgressHUDModeText;
        mbHud.labelText = @"分享失败";
        [mbHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }
    else
    {
        MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        mbHud.mode = MBProgressHUDModeText;
        mbHud.labelText = @"分享成功";
        [mbHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }
}
#pragma mark UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (dataAry.count>0) {
        //        orderDetailModel *modl = dataAry[0];
        NSArray *ary = model.shoplist;
        if (ary.count > 0) {
            if (section == 0) {
                if (![model.fapiaotaitou isEqualToString:@"0"]) {
                    return 7;
                }
                else
                    return 6;
            }
            else{
                if ([model.youhuis floatValue]>0) {
                    if([model.fujiafei floatValue]>0){
                        cellNum = ary.count+4;
                        return ary.count+4;
                    }
                    else{
                        cellNum = ary.count+3;
                        return ary.count+3;
                    }
                }
                else{
                    if ([model.fujiafei floatValue]>0) {
                        cellNum = ary.count+3;
                        return ary.count+3;
                    }
                    else{
                        cellNum = ary.count+2;
                        return ary.count+2;
                    }
                }
            }
        }
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *detailCell= @"detailCell";
    static NSString *cellList = @"cellList";
    //    orderDetailModel *modl = dataAry[0];
    NSArray *ary = model.shoplist;
    if (indexPath.section == 1 && indexPath.row < ary.count){
        detailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:detailCell];
        if (cell==nil) {
            cell = [[detailViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:detailCell];
            UIView *line = [[UIView alloc]initWithFrame:CGRectZero];
            line.backgroundColor = txtColors(193, 194, 196, 0.5);
            line.tag =103;
            [cell.contentView addSubview:line];
        }
        cell.backgroundColor = [UIColor whiteColor];
        if (ary.count == 1) {
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 1)];
            line.backgroundColor = lineColor;
            [cell addSubview:line];
            
            [cell.line removeFromSuperview];
            UIView *line1 = (UIView *)[cell viewWithTag:103];
            line1.frame = CGRectMake(0,65*MCscale, kDeviceWidth, 1);
        }
        else{
            if (indexPath.row == 0) {
                UIView *line = (UIView *)[cell viewWithTag:103];
                line.frame = CGRectMake(0, 0, kDeviceWidth, 1);
            }
            else if (indexPath.row == ary.count-1 )
            {
                [cell.line removeFromSuperview];
                UIView *line = (UIView *)[cell viewWithTag:103];
                line.frame = CGRectMake(0,65*MCscale, kDeviceWidth, 1);
            }
        }
        NSDictionary *dc = ary[indexPath.row];
        cell.detailDics = dc;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellList];
        NSArray *tit = @[@"订单号:",@"收货人:",@"手机号码:",@"收货地址:",@"支付方式:",@"送达时间:",@"发票抬头:"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellList];
            UILabel *title = [[UILabel alloc]initWithFrame:CGRectZero];
            title.textAlignment = NSTextAlignmentLeft;
            title.textColor = txtColors(89, 90, 91, 1);
            title.font = [UIFont boldSystemFontOfSize:MLwordFont_5];
            title.backgroundColor = [UIColor clearColor];
            title.tag = 101;
            [cell.contentView addSubview:title];
            
            UILabel *content = [[UILabel alloc]initWithFrame:CGRectZero];
            content.textAlignment = NSTextAlignmentLeft;
            content.tag =102;
            content.font = [UIFont systemFontOfSize:MLwordFont_5];
            content.backgroundColor = [UIColor clearColor];
            content.textColor = textBlackColor;
            [cell.contentView addSubview:content];
            
            UIView *line = [[UIView alloc]initWithFrame:CGRectZero];
            line.backgroundColor = txtColors(193, 194, 196, 1);
            line.tag =103;
            line.alpha = 0;
            [cell.contentView addSubview:line];
        }
        if (indexPath.section == 0) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel *label = (UILabel *)[cell viewWithTag:101];
            label.text = tit[indexPath.row];
            if (indexPath.row == 0) {
                label.frame = CGRectMake(30*MCscale, 5*MCscale, 80*MCscale, 20*MCscale);
            }
            else {
                label.frame = CGRectMake(30*MCscale, 0, 80*MCscale, 20*MCscale);
            }
            UILabel *content = (UILabel *)[cell viewWithTag:102];
            content.text = orderMessageAry[indexPath.row];
            CGSize conSize =[content.text boundingRectWithSize:CGSizeMake(200*MCscale, 20*MCscale) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:MLwordFont_5],NSFontAttributeName, nil] context:nil].size;
            content.frame = CGRectMake(label.right+5, label.top, conSize.width, 20*MCscale);
        }
        if (indexPath.section == 1 && indexPath.row >ary.count-1) {
            NSArray *tltAry = [[NSArray alloc]init];
            NSString *fuj = @"附加费:";
            if (![model.youhuis isEqual:NULL] && [model.youhuis floatValue]>0) {
                if ([model.fujiafei floatValue]>0) {
                    if(![model.fujiafeiname isEqualToString:@"0"]){
                        fuj = [NSString stringWithFormat:@"%@:",model.fujiafeiname];
                    }
                    tltAry = @[@"优惠:",fuj,@"配送费",@"实付款:"];
                }
                else
                    tltAry = @[@"优惠:",@"配送费",@"实付款:"];
            }
            else
                if ([model.fujiafei floatValue]>0) {
                    if(![model.fujiafeiname isEqualToString:@"0"]){
                        fuj = [NSString stringWithFormat:@"%@:",model.fujiafeiname];
                    }
                    tltAry = @[fuj,@"配送费",@"实付款:"];
                }
                else
                    tltAry = @[@"配送费",@"实付款:"];
            UILabel *title = (UILabel *)[cell viewWithTag:101];
            UILabel *content = (UILabel *)[cell viewWithTag:102];
            title.text = tltAry[indexPath.row-ary.count];
            if (tltAry.count==3) {
                if (indexPath.row== ary.count) {
                    if ([model.youhuis floatValue]>0) {
                        UIView *line = (UIView *)[cell viewWithTag:103];
                        line.alpha =0;
                        title.frame = CGRectMake(30*MCscale, 5*MCscale, 60*MCscale, 20*MCscale);
                        content.frame = CGRectMake(kDeviceWidth-100*MCscale, 5*MCscale, 80*MCscale, 20*MCscale);
                        NSString *youh =@"0";
                        if ([model.youhuis isEqual:NULL]) {
                            youh = @"0";
                        }
                        else
                            youh = model.youhuis;
                        content.text = [NSString stringWithFormat:@"¥%.2f",[youh floatValue]];
                    }
                    else{
                        UIView *line = (UIView *)[cell viewWithTag:103];
                        line.alpha =0;
                        title.frame = CGRectMake(30*MCscale, 5*MCscale, 60*MCscale, 20*MCscale);
                        content.frame = CGRectMake(kDeviceWidth-100*MCscale, 5*MCscale, 80*MCscale, 20*MCscale);
                        NSString *fujiafei =@"0";
                        if ([model.fujiafei floatValue]==0) {
                            fujiafei = @"0";
                        }
                        else
                        {
                            fujiafei = [NSString stringWithFormat:@"￥%@",model.fujiafei];
                        content.text = fujiafei;
                        }
                    }
                }
                else if (indexPath.row == ary.count+1){
                    title.frame = CGRectMake(30*MCscale, 0, 60*MCscale, 20*MCscale);
                    content.frame = CGRectMake(kDeviceWidth-100*MCscale, 0, 80*MCscale, 20*MCscale);
                    NSString *peis =@"0";
                    if ([model.peisongshishou isEqual:NULL]) {
                        peis = @"0";
                    }
                    else
                        peis = model.peisongshishou;
                    content.text = [NSString stringWithFormat:@"¥%.f",[peis floatValue]];
                }
                else{
                    if (![model.dindanbeizhu isEqualToString:@""] && ![model.dindanbeizhu isEqualToString:@"0"]){
                        UIView *line = (UIView *)[cell viewWithTag:103];
                        line.alpha =1;
                        line.frame = CGRectMake(0, 29*MCscale, kDeviceWidth, 1);
                    }
                    title.frame = CGRectMake(30*MCscale, 0, 60*MCscale, 20*MCscale);
                    content.frame = CGRectMake(kDeviceWidth-100*MCscale, 0, 80*MCscale, 20*MCscale);
                    content.text = [NSString stringWithFormat:@"¥%.2f",[model.yingfujines floatValue]];
                }
            }
            else if (ary.count == 4){
                if (indexPath.row== ary.count) {
                    UIView *line = (UIView *)[cell viewWithTag:103];
                    line.alpha =0;
                    title.frame = CGRectMake(30*MCscale, 5*MCscale, 60*MCscale, 20*MCscale);
                    content.frame = CGRectMake(kDeviceWidth-100*MCscale, 5*MCscale, 80*MCscale, 20*MCscale);
                    NSString *youh =@"0";
                    if ([model.youhuis isEqual:NULL]) {
                        youh = @"0";
                    }
                    else
                        youh = model.youhuis;
                    content.text = [NSString stringWithFormat:@"¥%.2f",[youh floatValue]];
                }
                else if (indexPath.row == ary.count+2){
                    title.frame = CGRectMake(30*MCscale, 0, 60*MCscale, 20*MCscale);
                    content.frame = CGRectMake(kDeviceWidth-100*MCscale, 0, 80*MCscale, 20*MCscale);
                    NSString *peis =@"0";
                    if ([model.peisongshishou isEqual:NULL]) {
                        peis = @"0";
                    }
                    else
                        peis = model.peisongshishou;
                    content.text = [NSString stringWithFormat:@"¥%.f",[peis floatValue]];
                }
                else if (indexPath.row == ary.count+1){
                    title.frame = CGRectMake(30*MCscale, 0, 60*MCscale, 20*MCscale);
                    content.frame = CGRectMake(kDeviceWidth-100*MCscale, 0, 80*MCscale, 20*MCscale);
                    NSString *fujiafei =@"0";
                    if ([model.fujiafei floatValue]==0) {
                        fujiafei = @"0";
                    }
                    else
                        fujiafei = [NSString stringWithFormat:@"%@",model.fujiafei];
                    content.text = [NSString stringWithFormat:@"¥%.f",[fujiafei floatValue]];
                }
                else{
                    if (![model.dindanbeizhu isEqualToString:@""] && ![model.dindanbeizhu isEqualToString:@"0"]){
                        UIView *line = (UIView *)[cell viewWithTag:103];
                        line.alpha =1;
                        line.frame = CGRectMake(0, 29*MCscale, kDeviceWidth, 1);
                    }
                    
                    title.frame = CGRectMake(30*MCscale, 0, 60*MCscale, 20*MCscale);
                    content.frame = CGRectMake(kDeviceWidth-100*MCscale, 0, 80*MCscale, 20*MCscale);
                    content.text = [NSString stringWithFormat:@"¥%.2f",[model.yingfujines floatValue]];
                }
            }
            else{
                if (indexPath.row == ary.count){
                    UIView *line = (UIView *)[cell viewWithTag:103];
                    line.alpha =0;
                    title.frame = CGRectMake(30*MCscale, 5*MCscale, 60*MCscale, 20*MCscale);
                    content.frame = CGRectMake(kDeviceWidth-100*MCscale, 5*MCscale, 80*MCscale, 20*MCscale);
                    NSString *peis =@"0";
                    if ([model.youhuis isEqual:NULL]) {
                        peis = @"0";
                    }
                    else
                        peis = model.peisongshishou;
                    content.text = [NSString stringWithFormat:@"¥%.f",[peis floatValue]];
                }
                else{
                    if (![model.dindanbeizhu isEqualToString:@""] && ![model.dindanbeizhu isEqualToString:@"0"]){
                        UIView *line = (UIView *)[cell viewWithTag:103];
                        line.alpha =1;
                        line.frame = CGRectMake(0, 29*MCscale, kDeviceWidth, 1);
                    }
                    
                    title.frame = CGRectMake(30*MCscale, 0, 60*MCscale, 20*MCscale);
                    content.frame = CGRectMake(kDeviceWidth-100*MCscale, 0, 80*MCscale, 20*MCscale);
                    content.text = [NSString stringWithFormat:@"¥%.2f",[model.yingfujines floatValue]];
                }
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 1){
        return 35;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 5*MCscale;
    }
    return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section >= 1 && dataAry.count > 0){
        DetailSectionHeaderView *headerView = [[DetailSectionHeaderView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 35*MCscale) AndString:model.dinapuname];
        headerView.headerDelegate = self;
        return headerView;
    }
    return nil;
}
#pragma mark DetailSectionHeaderViewDelegate
-(void)gotoDianpuFirst
{
    if ([model.dianpustate integerValue] != 0) {
        shopController *shop = [[shopController alloc]init];
        shop.shopId = model.dianpuid;
        shop.shopName = model.dinapuname;
        [self.navigationController pushViewController:shop animated:YES];
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 5*MCscale)];
        view.backgroundColor = txtColors(234, 235, 236, 1);
        return view;
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    orderDetailModel *modl = dataAry[0];
    NSInteger lasCellRow = 5;
    if (![model.fapiaotaitou isEqualToString:@"0"]) {
        lasCellRow = 6;
    }
    NSArray *ary = model.shoplist;
    if (indexPath.section == 0) {
        if (indexPath.row==0 || indexPath.row == lasCellRow) {
            return 25*MCscale;
        }
        return 20*MCscale;
    }
    else{
        if (indexPath.row <ary.count) {
            return 70*MCscale;
        }
        else{
            if(indexPath.row ==ary.count || indexPath.row==cellNum-1){
                return 25*MCscale;
            }
            else
                return 20*MCscale;
        }
    }
}

#pragma mark 按钮Action
-(void)btnAction:(UIButton *)btn
{
    if (btn.tag == 1001) {
        mainController *main = (mainController *)self.tabBarController;
        main.controlShowStyle = 2;
        [main showOrHiddenTabBarView:NO];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    if (btn.tag == 1002) {
        mainController *main = (mainController *)self.tabBarController;
        main.controlShowStyle = 1;
        [main showOrHiddenTabBarView:NO];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    if (btn.tag == 1007) {
        if ([user_id isEqualToString:userSheBei_id]) {
            orderAgnVisitorViewController *vc = [[orderAgnVisitorViewController alloc]init];
            vc.danhao = _dingdanId;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else{
            orderMoreArginController *orderVc = [[orderMoreArginController alloc]init];
            orderVc.danhao = _dingdanId;
            [self.navigationController pushViewController:orderVc animated:YES];
        }
    }
}
-(void)tapRedPack
{
    //    orderDetailModel *model = dataAry[0];
    //    NSString *sheqid = [NSString stringWithFormat:@"%@",model.shequid];
    NSString *dianpId = [NSString stringWithFormat:@"%@",model.dianpuid];
    
    NSMutableDictionary *pram = [NSMutableDictionary dictionaryWithDictionary:@{@"userid":user_id,@"dianpuid":dianpId,@"shequid":@"0",@"hongbaotype":@"1"}];
    
    [HTTPTool getWithUrl:@"fahongbao.action" params:pram success:^(id json) {
        //            if(([json integerForKey:@"message"]==1)){
        NSArray *ary = [json valueForKey:@"fahongbao"];
        NSDictionary *dic = ary[0];
        NSString *urlls= [NSString stringWithFormat:@"%@",[dic valueForKey:@"hongbaourl"]];
        NSString *imagePath = [NSString stringWithFormat:@"%@",[dic valueForKey:@"imgurl"]];
        NSString *hongMessage = [dic valueForKey:@"shuoming"];
        
        NSString *totlhongbao = [dic valueForKey:@"totalcount"];
        UILabel *lb = [shareRedPack viewWithTag:10110];
        lb.text = [NSString stringWithFormat:@"恭喜获得%@个红包",totlhongbao];
        [UIView animateWithDuration:0.3 animations:^{
            redPack.alpha = 0;
            [redPack removeFromSuperview];
            shareRedPack.alpha = 0.95;
            [shareRedPack loadDataWithDanhao:_dingdanId AndTitle:hongMessage AndImage:imagePath AndUrl:urlls AndDianpuId:dianpId];
            [self.view addSubview:shareRedPack];
        }];
        //            }
        //            else{
        //                MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        //                bud.mode = MBProgressHUDModeCustomView;
        //                bud.labelText = @"红包分享失败";
        //                [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
        //            }
    } failure:^(NSError *error) {
        MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        bud.mode = MBProgressHUDModeCustomView;
        bud.labelText = @"网络连接错误3";
        [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }];
}
- (void)myTask {
    sleep(1.5);
}
@end
