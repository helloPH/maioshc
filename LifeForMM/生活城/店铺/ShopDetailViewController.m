//
//  ShopDetailViewController.m
//  LifeForMM
//
//  Created by HUI on 15/7/26.
//  Copyright (c) 2015年 时元尚品. All rights reserved.
//

#import "ShopDetailViewController.h"
#import "Header.h"
#import "RatingView.h"
#import "shopDetailModel.h"
@interface ShopDetailViewController ()<UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UITableView *shopDetailTabel;
    NSMutableArray *detailDataAry; //店铺相关信息
    NSArray *huodTitleAry;//活动标题
    NSArray *huodImageAry;//活动图片
    NSArray *shopMessageImgAry;//店铺信息图片数组
    NSInteger secCellCount;
}
@end

@implementation ShopDetailViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:txtColors(4, 196, 153, 1)];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof (self) weakSelf = self;
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = weakSelf;
    }
    self.view.backgroundColor = [UIColor whiteColor];
    huodImageAry = [[NSArray alloc]init];
    huodTitleAry = [[NSArray alloc]init];
    shopMessageImgAry = [[NSArray alloc]init];
    detailDataAry = [[NSMutableArray alloc]init];
    secCellCount = 0;
    [self initNavigation];
    [self initTableView];
    [self reloadData];
}
//初始化导航栏
-(void)initNavigation
{
    self.navigationItem.title = @"商家信息";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:MLwordFont_2],NSFontAttributeName,nil]];
    UIButton *leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftbutton.frame = CGRectMake(0, 0, NVbtnWight, NVbtnWight);
    [leftbutton setBackgroundImage:[UIImage imageNamed:@"返回按钮"] forState:UIControlStateNormal];
    [leftbutton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    leftbutton.tag = 1001;
    UIBarButtonItem *leftbarBtn = [[UIBarButtonItem alloc]initWithCustomView:leftbutton];
    self.navigationItem.leftBarButtonItem =leftbarBtn;
}
//获取数据
-(void)reloadData
{
    NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"dianpuid":_dianpuId,@"dindan.shequid":userShequ_id}];
    [HTTPTool getWithUrl:@"findbyshequdianpuid.action" params:pram success:^(id json) {
        secCellCount = 2;
        NSDictionary *dic = [json valueForKey:@"shangpinlist"];
        shopDetailModel *modl = [[shopDetailModel alloc]initWithContent:dic];
        [detailDataAry addObject:modl];
        //活动title
        huodTitleAry = (NSArray *)[json valueForKey:@"tatlelist"];
        //活动图片
        huodImageAry = (NSArray *)[json valueForKey:@"tupianlist"];
        //店铺信息图片
        shopMessageImgAry = (NSArray *)[json valueForKey:@"dianpuxiangqing"];
        [shopDetailTabel reloadData];
        [self initTableHeald];
    } failure:^(NSError *error) {
        MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        bud.mode = MBProgressHUDModeCustomView;
        bud.labelText = @"网络连接错误";
        [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }];
}
//初始化表格
-(void)initTableView
{
    shopDetailTabel = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight) style:UITableViewStyleGrouped];
    shopDetailTabel.delegate = self;
    shopDetailTabel.dataSource = self;
    shopDetailTabel.separatorStyle = UITableViewCellSeparatorStyleNone;
    shopDetailTabel.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:shopDetailTabel];
}
//表头
-(void)initTableHeald
{
    shopDetailModel *modl = detailDataAry[0];
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 160*MCscale_1)];
    headView.backgroundColor = [UIColor whiteColor];
    UIImageView *shopLogo = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 73*MCscale, 73*MCscale)];
    shopLogo.center = CGPointMake(kDeviceWidth/2.0, 46);
    [shopLogo sd_setImageWithURL:[NSURL URLWithString:modl.dianputupian] placeholderImage:[UIImage imageNamed:@"placeHolder"] options:SDWebImageRefreshCached];
    shopLogo.backgroundColor = [UIColor clearColor];
    [headView addSubview:shopLogo];
    UILabel *shopTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, shopLogo.bottom+5, kDeviceWidth, 20)];
    shopTitle.text = modl.dianpumingcheng;
    shopTitle.textAlignment = NSTextAlignmentCenter;
    shopTitle.textColor = textBlackColor;
    shopTitle.font = [UIFont systemFontOfSize:MLwordFont_4];
    shopTitle.backgroundColor = [UIColor clearColor];
    [headView addSubview:shopTitle];
    
    RatingView *rating = [[RatingView alloc]initWithFrame:CGRectMake(0, 0, 170*MCscale, 30*MCscale)];
    rating.ratingScore = [modl.pingja floatValue]*MCscale;
    rating.center = CGPointMake(kDeviceWidth/2.0, shopTitle.bottom+20);
    rating.backgroundColor = [UIColor clearColor];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 159*MCscale, kDeviceWidth, 1)];
    line.backgroundColor = lineColor;
    [headView addSubview:line];
    [headView addSubview:rating];
    shopDetailTabel.tableHeaderView = headView;
}
#pragma mark -- UiTableViewDeldegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return secCellCount;
    }
    else if (section == 1){
        return huodTitleAry.count;
    }
    else{
        if (shopMessageImgAry.count>0) {
            if ([shopMessageImgAry[0] isEqualToString:@""]) {
                return 0;
            }
            return shopMessageImgAry.count;
        }
        return 0;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [NSString stringWithFormat:@"%ld%ld",(long)indexPath.section,indexPath.row];
    NSArray *imageArray1 = @[@"营业时间",@"地址"];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectZero];
        image.tag = 101;
        image.backgroundColor = [UIColor clearColor];
        [cell addSubview:image];
        
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectZero];
        title.tag = 102;
        title.backgroundColor = [UIColor clearColor];
        title.textAlignment = NSTextAlignmentLeft;
        title.textColor = textBlackColor;
        title.font = [UIFont systemFontOfSize:MLwordFont_6];
        [cell addSubview:title];
        UIView *line = [[UIView alloc]initWithFrame:CGRectZero];
        line.tag = 103;
        line.backgroundColor = lineColor;
        [cell addSubview:line];
    }
    UILabel *title = (UILabel *)[cell viewWithTag:102];
    UIImageView *imageDisplay = (UIImageView *)[cell viewWithTag:101];
    UIView *line = (UIView *)[cell viewWithTag:103];
    shopDetailModel *model = detailDataAry[0];
    if(indexPath.section == 0){
        if(indexPath.row == 0){
            imageDisplay.frame = CGRectMake(20, 13, 23*MCscale, 23*MCscale);
            imageDisplay.image = [UIImage imageNamed:imageArray1[indexPath.row]];
            title.frame = CGRectMake(imageDisplay.right+10*MCscale, 10, 300*MCscale, 30*MCscale);
            title.text = [NSString stringWithFormat:@"营业时间:上午%@ 下午%@",model.amtime,model.pmtime];
            line.frame = CGRectMake(0, title.bottom+9, kDeviceWidth, 1);
        }
        else if (indexPath.row == 1){
            imageDisplay.frame = CGRectMake(20, 13, 23*MCscale, 23*MCscale);
            imageDisplay.image =[UIImage imageNamed:imageArray1[indexPath.row]];
            title.frame = CGRectMake(imageDisplay.right+10*MCscale, 10, 260, 30*MCscale);
            title.text = [NSString stringWithFormat:@"地址:%@",model.dianpudizhi];
        }
    }
    else if(indexPath.section == 1){
        imageDisplay.frame = CGRectMake(20, 13, 23*MCscale, 23*MCscale);
        [imageDisplay sd_setImageWithURL:[NSURL URLWithString:huodImageAry[indexPath.row]] placeholderImage:[UIImage imageNamed:@"placeHolder"] options:SDWebImageRefreshCached];
        title.frame = CGRectMake(imageDisplay.right+10*MCscale, 10, 260, 30*MCscale);
        title.text = [NSString stringWithFormat:@"%@",huodTitleAry[indexPath.row]];
        if (indexPath.row != huodTitleAry.count-1) {
            line.frame = CGRectMake(0, title.bottom+9, kDeviceWidth, 1);
        }
    }
    else{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:shopMessageImgAry[indexPath.row]]];
        UIImage *image = [UIImage imageWithData:data];
        CGSize imgSize = image.size;
        
      
        
        imageDisplay.frame = CGRectMake(0, 0, imgSize.width, 200*MCscale);
        [imageDisplay sd_setImageWithURL:[NSURL URLWithString:shopMessageImgAry[indexPath.row]] placeholderImage:[UIImage imageNamed:@"placeHolder"] options:SDWebImageRefreshCached];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 || indexPath.section == 1) {
        return 50*MCscale;
    }
    return 190*MCscale;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return CGFLOAT_MIN;
    }
    else
        return 8;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 5)];
    headView.backgroundColor = txtColors(233, 234, 235, 1);
    return headView;
}
//按钮事件
-(void)btnAction:(UIButton *)btn
{
    if (btn.tag == 1001) {
        [self.navigationController popViewControllerAnimated:YES];
        mainController *main = (mainController *)self.tabBarController;
        [main showOrHiddenTabBarView:NO];
    }
    if (btn.tag == 1002) {

    }
}
- (void)myTask {
    sleep(2);
}
@end
