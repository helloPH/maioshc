//
//  SpecialViewController.m
//  LifeForMM
//
//  Created by MIAO on 2016/12/21.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import "SpecialViewController.h"
#import "Header.h"
#import "shopCollectionViewCell.h"
#import "GoodDetailViewController.h"
#import "UserOrderViewController.h"
#import "CarViewController.h"
#import "SureOrderViewController.h"
#import "NewAddresPopView.h"
#import "MBPrompt.h"
#import "OrderPromptView.h"
#import "userAddressModel.h"
@interface SpecialViewController ()<UIGestureRecognizerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,MBProgressHUDDelegate,newAddresPopDelegate,OrderPromptViewDelegate,CAAnimationDelegate>
@end

@implementation SpecialViewController
{
    UICollectionView *mainCollecView;//商品列表
    UIView *fotView;//底部视图
    NSInteger goodNumInCar; //加入购物数量
    NSMutableArray *btnArray; //c存放所有加入购物车按钮
    CALayer  *anmiatorlayer; //贝塞尔曲线 加入购物车动画
    NSMutableArray *goodAry;
    UILabel *totlMoney;//总钱数
    UILabel *numLabel;//购物车物品数量
    NSString *godId;//商品id 用户id
    CGFloat tolMoney;//总价
    NSInteger shuliang;//从服务器获取的购物车数量
    CGFloat total;//从服务器获取的购物车总价
    BOOL isRefresh,isBotom;
    NSInteger loadType;
    int pageNum,lastPage;
    
    UILabel *youhuiLabel;//优惠价格
    MBProgressHUD *mbHud;
    NewAddresPopView *newAddressPop;//新地址
    OrderPromptView *orderPrompt;//提示信息
    NSMutableArray *minPageAry; //数组第一条数据所在页
    NSMutableArray *maxPageAry; //数组最后一条数据所在页
    NSMutableArray *allDataAry; //所有数据
    UIImageView *chooseBtnView;//选好了按钮
    UIImageView *whiteCar;//底部购物车
    UILabel *carEmptyLab; //购物车-空
    UIImageView *carEmptyImg;//
    UIView *maskView;
    NSString *dianpuId;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController.navigationBar setBarTintColor:txtColors(4, 196, 153, 1)];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notafitionAction) name:@"goodPageAddGoods" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(relodCarData) name:@"changeGoodsAnying" object:nil];//goodPageAddGoods
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notafitionAction) name:@"cardelNotification" object:nil];
    mainController *main = (mainController *)self.tabBarController;
    [main showOrHiddenTabBarView:YES];
    //    [self onlyLognUser];
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
    dianpuId = @"0";
    goodNumInCar  = tolMoney = isRefresh =0;
    pageNum = 1;
    isRefresh =0;
    isBotom = 1;
    btnArray = [[NSMutableArray alloc]init];
    goodAry = [[NSMutableArray alloc]init];
    allDataAry = [[NSMutableArray alloc]init];
    minPageAry = [[NSMutableArray alloc]init];
    maxPageAry = [[NSMutableArray alloc]init];
    [self initNavigation];
    [self initCollectionView];
    [self initfootView];//底部视图
    [self refresh];//刷新
    [self initNewAddressPop];
    [self loadListData];
    [self initMaskView];//遮罩
}
-(void)initNavigation
{
    self.navigationItem.title = @"特价专区";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:MLwordFont_2],NSFontAttributeName,nil]];
    UIButton *leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftbutton.frame = CGRectMake(0, 0, NVbtnWight, NVbtnWight);
    [leftbutton setBackgroundImage:[UIImage imageNamed:@"返回按钮"] forState:UIControlStateNormal];
    [leftbutton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    leftbutton.tag = 1001;
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftbutton];
    self.navigationItem.leftBarButtonItem = leftItem;
}
#pragma mark -- 详情页添加数据/购物车删除数据
-(void)notafitionAction
{
    [self carNumData];
    [self relodCarData];
}

#pragma mark -- 获取列表数据
-(void)loadListData
{
    MBProgressHUD *md = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    md.mode = MBProgressHUDModeIndeterminate;
    md.delegate = self;
    md.labelText = @"请稍等...";
    if (!isRefresh) {
        [md show:YES];
    }
    NSMutableDictionary *pram = [NSMutableDictionary dictionaryWithDictionary:@{@"id":userShequ_id,@"pageNum":[NSString stringWithFormat:@"%d",pageNum],@"userid":user_id}];
    [HTTPTool getWithUrl:@"findbytejia.action" params:pram success:^(id json) {
        [md hide:YES];
        NSLog(@"特价商品 %@",json);
        
        if (isRefresh) {
            [self endRefresh:loadType];
        }
        if (lastPage == pageNum) {
            [allDataAry removeAllObjects];
        }
        lastPage = pageNum;
        NSDictionary *dc = (NSDictionary *)json;
        NSArray *shoplist = [dc valueForKey:@"shoplist"];
        if (shoplist.count >0) {
            for (NSDictionary *dict in shoplist) {
                shopModel *shModel = [[shopModel alloc]initWithContent:dict];
                [allDataAry addObject:shModel];
            }
            [self relodCarData];
            [mainCollecView reloadData];
            isBotom = 0;
            [self loadFootView];
        }
        else
        {
            if (lastPage == 1) {
                mainCollecView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"特价"]];
            }
            else
            {
                isBotom = 1;
                [self loadFootView];
            }
        }
    } failure:^(NSError *error) {
        [md hide:YES];
        [self endRefresh:loadType];
        MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        bud.mode = MBProgressHUDModeCustomView;
        bud.labelText = @"网络连接错误3";
        [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }];
}
-(void)carNumData
{
    NSMutableDictionary *pramDic = [[NSMutableDictionary alloc]initWithDictionary:@{@"userid":user_id,@"shequid":userShequ_id}];
    [HTTPTool getWithUrl:@"findbyuseridsid.action" params:pramDic success:^(id json) {
        if ([[json valueForKey:@"massage"]integerValue]==1) {//没商品
            [self footViewState:0];
        }
        else{
            [self footViewState:1];
        }
    } failure:^(NSError *error) {
        MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        bud.mode = MBProgressHUDModeCustomView;
        bud.labelText = @"网络连接错误7";
        [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }];
}
-(void)footViewState:(NSInteger)state
{
    if (!state) {
        whiteCar.image = [UIImage imageNamed:@"购物车-无"];
        whiteCar.userInteractionEnabled = NO;
        carEmptyImg.alpha = 1;
        numLabel.alpha = 0;
        totlMoney.alpha = 0;
        youhuiLabel.alpha = 0;
        chooseBtnView.image = [UIImage imageNamed:@"选好了灰色"];
        chooseBtnView.userInteractionEnabled = NO;
    }
    else{
        whiteCar.image = [UIImage imageNamed:@"购物车-有"];
        whiteCar.userInteractionEnabled = YES;
        carEmptyImg.alpha = 0;
        numLabel.alpha = 1;
        totlMoney.alpha = 1;
        youhuiLabel.alpha = 1;
        chooseBtnView.image = [UIImage imageNamed:@"选好了红色"];
        chooseBtnView.userInteractionEnabled = YES;
    }
}
//获取购物车数量 及总价
-(void)relodCarData
{
    NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"userid":user_id,@"shequid":userShequ_id,@"car.dianpuid":dianpuId}];
    [HTTPTool getWithUrl:@"dianpuprice.action" params:pram success:^(id json) {
        numLabel.text =[NSString stringWithFormat:@"%@",[json valueForKey:@"shuliangs"]];
        totlMoney.text = [NSString stringWithFormat:@"¥%.2f",[[json valueForKey:@"totalPrice"] floatValue]];
        CGSize tolSize = [totlMoney.text boundingRectWithSize:CGSizeMake(100, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:MLwordFont_15], NSFontAttributeName,nil] context:nil].size;
        totlMoney.frame = CGRectMake(95*MCscale, 10, tolSize.width, 30);
        if ([[json valueForKey:@"jianmoneys"] integerValue]==0) {
            if ([[json valueForKey:@"cha"] integerValue]==0) {
                youhuiLabel.alpha = 0;
            }
            else
                if ([[json valueForKey:@"totalPrice"] floatValue]<=0) {
                    youhuiLabel.alpha = 0;
                }
                else{
                    youhuiLabel.alpha = 1;
                    youhuiLabel.text = [NSString stringWithFormat:@"还差¥%@",[json valueForKey:@"cha"]];
                }
        }
        else{
            youhuiLabel.alpha = 1;
            youhuiLabel.text = [NSString stringWithFormat:@"优惠¥%@",[json valueForKey:@"jianmoneys"]];
        }
        CGSize yhSize = [youhuiLabel.text boundingRectWithSize:CGSizeMake(100, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:MLwordFont_7], NSFontAttributeName,nil] context:nil].size;
        youhuiLabel.frame = CGRectMake(totlMoney.right+2, 17, yhSize.width, 20);
    } failure:^(NSError *error) {
        MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        bud.mode = MBProgressHUDModeCustomView;
        bud.labelText = @"网络连接错误8";
        [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }];
}
-(void)initCollectionView
{
    UICollectionViewFlowLayout *flowLayout1 = [[UICollectionViewFlowLayout alloc]init];
    [flowLayout1 setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout1.headerReferenceSize = CGSizeMake(kDeviceWidth, 15);
    
    mainCollecView =[[UICollectionView alloc]initWithFrame:CGRectMake(0,64, kDeviceWidth, kDeviceHeight - 64*MCscale-49*MCscale) collectionViewLayout:flowLayout1];
    //左侧
    mainCollecView.delegate = self;
    mainCollecView.dataSource = self;
    mainCollecView.alwaysBounceVertical = YES;
    mainCollecView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:mainCollecView];
    [mainCollecView registerClass:[shopCollectionViewCell class] forCellWithReuseIdentifier:@"cell1"];
}
//初始化底部视图
-(void)initfootView
{
    fotView = [[UIView alloc]initWithFrame:CGRectMake(0, kDeviceHeight-49, kDeviceWidth, 49)];
    fotView.backgroundColor = txtColors(25, 182, 133, 0.8);
    [self.view addSubview:fotView];
    whiteCar = [[UIImageView alloc]initWithFrame:CGRectMake(30*MCscale, -15, 60*MCscale, 60*MCscale)];
    whiteCar.backgroundColor = [UIColor clearColor];
    whiteCar.image = [UIImage imageNamed:@"购物车-无"];
    whiteCar.tag = 1001;
    whiteCar.userInteractionEnabled = NO;
    [fotView addSubview:whiteCar];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(whiteCarAction)];
    [whiteCar addGestureRecognizer:tap];
    
    numLabel = [[UILabel alloc]initWithFrame:CGRectMake(43*MCscale, 14*MCscale, 16*MCscale, 16*MCscale)];
    numLabel.tag = 1002;
    numLabel.backgroundColor = txtColors(237, 58, 76, 1);
    numLabel.layer.cornerRadius = 8.0;
    numLabel.textColor = [UIColor whiteColor];
    numLabel.text = @"0";
    numLabel.alpha = 0;
    numLabel.textAlignment = NSTextAlignmentCenter;
    numLabel.font = [UIFont systemFontOfSize:MLwordFont_9];
    numLabel.layer.masksToBounds = YES;
    [whiteCar addSubview:numLabel];
    //购物车无商品
    carEmptyImg = [[UIImageView alloc]initWithFrame:CGRectMake(whiteCar.right, 15, 150*MCscale, 20)];
    carEmptyImg.alpha = 0;
    carEmptyImg.backgroundColor = [UIColor clearColor];
    carEmptyImg.image = [UIImage imageNamed:@"empty"];
    [fotView addSubview:carEmptyImg];
    
    totlMoney = [[UILabel alloc]initWithFrame:CGRectZero];
    totlMoney.backgroundColor = [UIColor clearColor];
    totlMoney.textColor = txtColors(237, 58, 76, 1);
    totlMoney.textAlignment = NSTextAlignmentLeft;
    totlMoney.alpha = 0;
    totlMoney.font = [UIFont systemFontOfSize:MLwordFont_15];
    [fotView addSubview:totlMoney];
    //优惠
    youhuiLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    youhuiLabel.text = @"";
    youhuiLabel.alpha = 0;
    youhuiLabel.textAlignment = NSTextAlignmentLeft;
    youhuiLabel.textColor = textBlackColor;
    youhuiLabel.font = [UIFont systemFontOfSize:MLwordFont_7];
    [fotView addSubview:youhuiLabel];
    
    chooseBtnView = [[UIImageView alloc]initWithFrame:CGRectMake(kDeviceWidth-120*MCscale, 10, 100*MCscale, 30*MCscale)];
    chooseBtnView.backgroundColor = [UIColor clearColor];
    chooseBtnView.image = [UIImage imageNamed:@"选好了灰色"];
    chooseBtnView.userInteractionEnabled = YES;
    [fotView addSubview:chooseBtnView];
    UITapGestureRecognizer *chosetap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseAction)];
    [chooseBtnView addGestureRecognizer:chosetap];
    [self carNumData];
}
#pragma mark --UICollectionViewDelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (allDataAry.count>0) {
        return allDataAry.count;
    }
    else
        return 0;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell1";
    shopCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    [cell sizeToFit];
    if(allDataAry.count>0){
        shopModel *shModel = allDataAry[indexPath.row];
        [cell.goodImage sd_setImageWithURL:[NSURL URLWithString:shModel.canpinpic] placeholderImage:[UIImage imageNamed:@"placeHolder"] options:SDWebImageRefreshCached];
        NSString *biaoq = [NSString stringWithFormat:@"%@",shModel.biaoqian];
        if (![biaoq isEqualToString:@"1"] && ![biaoq isEqualToString:@""]) {
            MyLog(@"--- 111 --- ");
            [cell.shangbiao sd_setImageWithURL:[NSURL URLWithString:shModel.biaoqian]];
        }
        
        NSString *zhuangtai = [NSString stringWithFormat:@"%@",shModel.zhuangtai];
        NSLog(@"状态%@",zhuangtai);
        
        if (zhuangtai.length > 11) {
            cell.tishiLabel.text = zhuangtai;
            cell.tishiLabel.backgroundColor = [UIColor grayColor];
            cell.goinShopCar.hidden = YES;
        }
        else {
            if([zhuangtai isEqualToString:@"A"])
            {
                
            }
            else if ([zhuangtai integerValue] < 1) {
                cell.tishiLabel.text = @"已售完";
                cell.tishiLabel.backgroundColor = [UIColor grayColor];
                cell.goinShopCar.hidden = YES;
            }
        }
        
        cell.goodTitle.text = shModel.shangpinname;
        NSString *pric = [NSString stringWithFormat:@"%.2f",[shModel.xianjia floatValue]];
        cell.nowPrice.text =[NSString stringWithFormat:@"¥%@",pric] ;
        cell.oldPrice.text = [NSString stringWithFormat:@"原价:%.1f",[shModel.yuanjia floatValue]];
        if ([shModel.yuanjia floatValue] >0) {
            cell.oldPrice .alpha =1;
        }
        else
            cell.oldPrice.alpha = 0;
        CGSize size = [cell.oldPrice.text boundingRectWithSize:CGSizeMake(70, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:MLwordFont_9],NSFontAttributeName, nil] context:nil].size;
        cell.oldPrice.size = CGSizeMake(size.width, 20);
        
        [cell.goinShopCar addTarget:self action:@selector(goinShoppingCar:) forControlEvents:UIControlEventTouchUpInside];
        cell.goinShopCar.tag = indexPath.row;
        [btnArray addObject:cell.goinShopCar];
        cell.backgroundColor = [UIColor whiteColor];
    }
    else{
        MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        bud.mode = MBProgressHUDModeCustomView;
        bud.labelText = @"5网络连接错误";
        [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }
    return cell;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kDeviceWidth/2-6, SCLHeight);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(1, 1, 1, 1);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    GoodDetailViewController *goodDetail = [[GoodDetailViewController alloc]init];
    if (allDataAry.count > 0) {
        shopModel *shModel = allDataAry[indexPath.row];
        goodDetail.goodId = shModel.shanpinid;
        goodDetail.dianpuId = shModel.dinapuid;
        goodDetail.godShequid = userShequ_id;
        goodDetail.goodtag = shModel.biaoqian;
        goodDetail.zhuangtai = shModel.zhuangtai;
        [self.navigationController pushViewController:goodDetail animated:YES];
    }
}
#pragma mark -- btnAction
-(void)btnAction:(UIButton *)btn
{
    if (btn.tag == 1001) {
        mainController *main = (mainController *)self.tabBarController;
        [main showOrHiddenTabBarView:NO];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
//加入购物车
-(void)goinShoppingCar:(UIButton *)btn
{
    shopModel *shModel = allDataAry[btn.tag];
    dianpuId = [NSString stringWithFormat:@"%@",shModel.dinapuid];
    NSString *goodId = [NSString stringWithFormat:@"%@",shModel.shanpinid];
    NSString *label = [NSString stringWithFormat:@"%@",shModel.biaoqian];
    if ([label isEqualToString:@"1"] || [label isEqualToString:@""]) {
        [self addcardAnimation:btn];
    }
    else{
        NSString *cutLabelStr = [label substringFromIndex:45];
        MyLog(@"%@",cutLabelStr);
        if ([cutLabelStr isEqualToString:@"tehui.png"]) {
            NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"userid":user_id,@"shangpinid":goodId}];
            [HTTPTool getWithUrl:@"findbycarshop.action" params:pram success:^(id json) {
                NSString *massage = [NSString stringWithFormat:@"%@",[json valueForKey:@"massage"]];
                if ([massage isEqualToString:@"3"]){//已存在该商品
                    MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    bud.mode = MBProgressHUDModeCustomView;
                    bud.labelText = @"该特惠商品购物车已存在";
                    [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
                }
                else{
                    [self addcardAnimation:btn];
                }
            } failure:^(NSError *error) {
                MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                bud.mode = MBProgressHUDModeCustomView;
                bud.labelText = @"网络连接错误";
                [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
            }];
        }
        else{
            [self addcardAnimation:btn];
        }
    }
}
-(void)addcardAnimation:(UIButton *)btn
{
    for (UIButton *btns in btnArray) {
        btns.userInteractionEnabled = NO;
    }
    [self addDataInCar:btn.tag];
    NSString *str = [NSString stringWithFormat:@"%ld",(long)btn.tag];
    [goodAry addObject:str];
    CGRect rc = [btn.superview convertRect:btn.frame toView:self.view];
    CGPoint stPoint = rc.origin;
    CGPoint startPoint = CGPointMake(stPoint.x+12, stPoint.y+12);
    CGPoint endpoint = CGPointMake(80, kDeviceHeight-40);
    UIImageView *imageView=[[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"购物车圆点"];
    imageView.contentMode=UIViewContentModeScaleToFill;
    imageView.frame=CGRectMake(0, 0, 10, 10);
    imageView.hidden=YES;
    
    anmiatorlayer =[[CALayer alloc]init];
    anmiatorlayer.contents=imageView.layer.contents;
    anmiatorlayer.frame=imageView.frame;
    anmiatorlayer.opacity=1;
    [self.view.layer addSublayer:anmiatorlayer];
    UIBezierPath *path=[UIBezierPath bezierPath];
    [path moveToPoint:startPoint];
    //贝塞尔曲线中间点
    float sx=startPoint.x;
    float sy=startPoint.y;
    float ex=endpoint.x;
    float ey=endpoint.y;
    float x=sx+(ex-sx)/3;
    float y=sy+(ey-sy)*0.5-400;
    CGPoint centerPoint=CGPointMake(x,y);
    [path addQuadCurveToPoint:endpoint controlPoint:centerPoint];
    CAKeyframeAnimation *animation=[CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = path.CGPath;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.duration=1;
    animation.delegate=self;
    animation.autoreverses= NO;
    [animation setValue:@"yingmeiji_buy" forKey:@"MyAnimationType_yingmeiji"];
    [anmiatorlayer addAnimation:animation forKey:@"yingmiejibuy"];
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    NSString* value = [anim valueForKey:@"MyAnimationType_yingmeiji"];
    if ([value isEqualToString:@"yingmeiji_buy"]){
        [anmiatorlayer removeAnimationForKey:@"yingmiejibuy"];
        [anmiatorlayer removeFromSuperlayer];
        anmiatorlayer.hidden=YES;
        for (UIButton *btns in btnArray) {
            btns.userInteractionEnabled = YES;
        }
    }
}
#pragma mark -- 加入购物车数据
-(void)addDataInCar:(NSInteger )index
{
    shopModel *shModel = allDataAry[index];
    
    godId = shModel.shanpinid;
    dianpuId = [NSString stringWithFormat:@"%@",shModel.dinapuid];
    NSMutableDictionary *pram = [NSMutableDictionary dictionaryWithDictionary:@{@"shangpinid":godId,@"userid":user_id,@"shequid":userShequ_id,@"car.dianpuid":dianpuId}];
    
    [HTTPTool getWithUrl:@"addcarone.action" params:pram success:^(id json) {
        if ([[json valueForKey:@"massages"]integerValue]==0) {
            MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            bud.mode = MBProgressHUDModeCustomView;
            bud.labelText = @"添加失败";
            [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
        }
        else if ([[json valueForKey:@"massages"]integerValue]==1 || [[json valueForKey:@"massages"]integerValue]==2) {
            [self relodCarData];
            [self footViewState:1];
            NSNotification *shopNotification = [NSNotification notificationWithName:@"shopAddGoods" object:nil];
            [[NSNotificationCenter defaultCenter] postNotification:shopNotification];
            [[NSNotificationCenter defaultCenter] removeObserver:self name:@"shopAddGoods" object:nil];
        }
        //        else if ([[json valueForKey:@"massages"]integerValue]==2) {
        //
        //        }
        else if ([[json valueForKey:@"massages"]integerValue]==3) {
            MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            bud.mode = MBProgressHUDModeCustomView;
            bud.labelText = @"当前商品库存不足";
            [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
        }
        else {
            MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            bud.mode = MBProgressHUDModeCustomView;
            bud.labelText = @"当前数量已达到活动上限";
            [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
        }
    } failure:^(NSError *error) {
        MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        bud.mode = MBProgressHUDModeCustomView;
        bud.labelText = @"网络连接错误";
        [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }];
}
///选好了按钮事件
-(void)chooseAction
{
    MBProgressHUD *Hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    Hud.mode = MBProgressHUDModeIndeterminate;
    Hud.delegate = self;
    Hud.labelText = @"请稍等...";
    [Hud show:YES];
    NSMutableDictionary *pramDic = [[NSMutableDictionary alloc]initWithDictionary:@{@"userid":user_id,@"shequid":userShequ_id}];
    [HTTPTool getWithUrl:@"findbyuseridsid.action" params:pramDic success:^(id json) {
        [Hud hide:YES];
        if ([[json valueForKey:@"massage"]integerValue]==1) {
            MBProgressHUD *mud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            mud.mode = MBProgressHUDModeText;
            mud.labelText = @"购物车还是空的!先加件商品再试试!";
            [mud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
        }
        else if ([[json valueForKey:@"massage"]integerValue]==2){
            
            NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"address.shequid":userShequ_id,@"address.tel":user_id}];
            
            [HTTPTool getWithUrl:@"defaultAddress.action" params:pram success:^(id json) {
                
                if (![[json valueForKey:@"address"]isEqual:[NSNull null]]) {
                    
                    NSArray *ary = [json valueForKey:@"address"];
                    
                    userAddressModel * addressModel = [[userAddressModel  alloc]init];
                    NSDictionary *addDic = ary[0];
                    [addressModel setValuesForKeysWithDictionary:addDic];
                    addressModel.qiehuan = [json valueForKey:@"qiehuan"];
                    [UIView animateWithDuration:0.3 animations:^{
                        maskView.alpha = 0;
                        [maskView removeFromSuperview];
                        newAddressPop.alpha = 0;
                        [newAddressPop removeFromSuperview];
                    }];
                    if ([user_id isEqualToString:userSheBei_id]) {
                        SureOrderViewController *vc = [[SureOrderViewController alloc]init];
                        vc.shequ_id = userShequ_id;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                    else{
                        UserOrderViewController *vc = [[UserOrderViewController alloc]init];
                        vc.shequ_id = userShequ_id;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                }
                else{
                    [UIView animateWithDuration:0.3 animations:^{
                        maskView.alpha = 1;
                        [self .view addSubview:maskView];
                        newAddressPop.alpha = 0.95;
                        [self.view addSubview:newAddressPop];
                    }];
                }
            } failure:^(NSError *error) {
                MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                bud.mode = MBProgressHUDModeCustomView;
                bud.labelText = @"网络连接错误";
                [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
            }];
        }
        else if ([[json valueForKey:@"massage"]integerValue]==4){
            MBProgressHUD *mud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            mud.mode = MBProgressHUDModeText;
            mud.labelText = @"商品收藏到购物车,商家休息中无法接收订单";
            [mud showWhileExecuting:@selector(showTask) onTarget:self withObject:nil animated:YES];
        }
        else{
            MBProgressHUD *mud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            mud.mode = MBProgressHUDModeText;
            mud.labelText = @"购物车暂无当前社区商品!";
            [mud showWhileExecuting:@selector(showTask) onTarget:self withObject:nil animated:YES];
        }
    } failure:^(NSError *error) {
        [Hud hide:YES];
        MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        bud.mode = MBProgressHUDModeCustomView;
        bud.labelText = @"网络连接错误";
        [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }];
}
//使用新地址
-(void)initNewAddressPop
{
    newAddressPop = [[NewAddresPopView alloc]initWithFrame:CGRectMake(kDeviceWidth/20.0, 120*MCscale, kDeviceWidth*9/10.0,340*MCscale)];
    newAddressPop.alpha = 0;
    newAddressPop.addresPopdelegate = self;
    //    [self.view addSubview:newAddressPop];
}
#pragma mark -- NewAddresDelegate
-(void)newAddressView:(NewAddresPopView *)popView Andvalue:(NSInteger)index
{
    if (index == 2) {
        MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hub.mode = MBProgressHUDModeText;
        hub.labelText = @"地址添加成功";
        [hub showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
        
        [UIView animateWithDuration:0.3 animations:^{
            maskView.alpha = 0;
            [maskView removeFromSuperview];
            newAddressPop.alpha = 0;
            [newAddressPop removeFromSuperview];
        }];
        if ([user_id isEqualToString:userSheBei_id]) {
            SureOrderViewController *vc = [[SureOrderViewController alloc]init];
            vc.shequ_id = userShequ_id;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else{
            UserOrderViewController *vc = [[UserOrderViewController alloc]init];
            vc.shequ_id = userShequ_id;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else if (index == 3)
    {
        [UIView animateWithDuration:0.3 animations:^{
            maskView.alpha = 1;
            [self .view addSubview:maskView];
            orderPrompt.alpha = 0.95;
            orderPrompt = [[OrderPromptView alloc]initWithFrame:CGRectMake(kDeviceWidth/25.0, 170*MCscale, kDeviceWidth*9/11.0,155*MCscale)];
            orderPrompt.center =  CGPointMake(kDeviceWidth/2.0,270*MCscale);
            orderPrompt.cancalBtn.hidden = YES;
            orderPrompt.line2.hidden = YES;
            orderPrompt.orderPromptViewDelegate = self;
            [self.view addSubview:orderPrompt];
        }];
    }
    else if (index == 4)
    {
        [UIView animateWithDuration:0.3 animations:^{
            maskView.alpha = 1;
            [self .view addSubview:maskView];
            orderPrompt.alpha = 0.95;
            orderPrompt = [[OrderPromptView alloc]initWithFrame:CGRectMake(kDeviceWidth/25.0, 170*MCscale, kDeviceWidth*9/11.0,220*MCscale)];
            orderPrompt.center =  CGPointMake(kDeviceWidth/2.0,270*MCscale);
            //                    orderPrompt.alpha = 0;
            orderPrompt.orderPromptViewDelegate = self;
            [self.view addSubview:orderPrompt];
        }];
    }
}
//弹框遮罩
-(void)initMaskView
{
    maskView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, kDeviceWidth, kDeviceHeight-64)];
    maskView.alpha = 0;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(maskViewDisMiss)];
    [maskView addGestureRecognizer:tap];
}
-(void)maskViewDisMiss
{
    [UIView animateWithDuration:0.3 animations:^{
        maskView.alpha = 0;
        [maskView removeFromSuperview];
        newAddressPop.alpha = 0;
        orderPrompt.alpha = 0;
        [self.view endEditing:YES];
        [newAddressPop removeFromSuperview];
        [orderPrompt removeFromSuperview];
    }];
}
#pragma mark -- UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.tag == 10001) {
        if (textView.text.length >50) {
            textView.text = [textView.text substringToIndex:50];
        }
    }
}

//点击底部白色购物车 进入购物车
-(void)whiteCarAction
{
    CarViewController *car = [[CarViewController alloc]init];
    [self.navigationController pushViewController:car animated:YES];
}
- (void)myTask {
    // Do something usefull in here instead of sleeping ...
    sleep(1.5);
}
-(void)showTask
{
    sleep(2.5);
}
-(void)refresh
{
    //下拉刷新
    [mainCollecView addHeaderWithTarget:self action:@selector(headReFreshing)];
    //上拉加载
    [mainCollecView addFooterWithTarget:self action:@selector(footRefreshing)];
    mainCollecView.headerPullToRefreshText = @"下拉刷新数据";
    mainCollecView.headerReleaseToRefreshText = @"松开刷新";
    mainCollecView.headerRefreshingText = @"拼命加载中";
    mainCollecView.footerPullToRefreshText = @"上拉加载数据";
    mainCollecView.footerReleaseToRefreshText = @"松开加载数据";
    mainCollecView.footerRefreshingText = @"拼命加载中";
}
//下拉
-(void)headReFreshing
{
    isRefresh = 1;
    loadType = 0;
    lastPage = 1;
    pageNum = 1;
    [self loadListData];
}
-(void)footRefreshing
{
    isRefresh = 1;
    loadType = 1;
    pageNum ++;
    [self loadListData];
}

-(void)endRefresh:(BOOL)bolType
{
    if (bolType) {
        [mainCollecView footerEndRefreshing];
    }
    else{
        [mainCollecView headerEndRefreshing];
    }
}
-(void)loadFootView
{
    if (isBotom == 1) {
        MBProgressHUD *mHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        mHud.mode = MBProgressHUDModeCustomView;
        mHud.labelText = @"已经到底了";
        mHud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
        [mHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }
}

#pragma mark OrderPromptViewDelegate
-(void)OrderPromptView:(OrderPromptView *)orderView AndButton:(UIButton *)button
{
    if (button == orderView.sureBtn) {
        [UIView animateWithDuration:0.3 animations:^{
            maskView.alpha = 0;
            [maskView removeFromSuperview];
            newAddressPop.alpha = 0;
            orderPrompt.alpha = 0;
            [newAddressPop removeFromSuperview];
            [orderPrompt removeFromSuperview];
        }];
    }
    else
    {
        //2.1  修改购物车中特惠商品选中状态
        NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"address.tel":user_id}];
        [HTTPTool postWithUrl:@"changeCarTehui.action" params:pram success:^(id json) {
            if ([[json valueForKey:@"message"]integerValue]==1) {
                MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hub.mode = MBProgressHUDModeText;
                hub.labelText = @"地址添加成功";
                [hub showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
                [UIView animateWithDuration:0.3 animations:^{
                    maskView.alpha = 0;
                    [maskView removeFromSuperview];
                    newAddressPop.alpha = 0;
                    [orderPrompt removeFromSuperview];
                    [newAddressPop removeFromSuperview];
                }];
                NSNotification *newAddressPopSave = [NSNotification notificationWithName:@"newAddressPop" object:nil];
                [[NSNotificationCenter defaultCenter]postNotification:newAddressPopSave];
                [[NSNotificationCenter defaultCenter]removeObserver:self name:@"newAddressPop" object:nil];
            }
        } failure:^(NSError *error) {
            MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            bud.mode = MBProgressHUDModeCustomView;
            bud.labelText = @"网络连接错误";
            [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
        }];
    }
}

@end
