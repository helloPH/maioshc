//
//  orderEvaluateViewController.m
//  LifeForMM
//  Created by 时元尚品 on 15/7/23.
//  Copyright (c) 2015年 时元尚品. All rights reserved.
//

#import "orderEvaluateViewController.h"
#import "Header.h"
#import "startView.h"
#import "orderPingjiaModel.h"
#import "MaskView.h"
#import "OnLinePayView.h"
#import "PaymentPasswordView.h"
@interface orderEvaluateViewController ()<UIGestureRecognizerDelegate,UIWebViewDelegate,OnLinePayViewDelegate,PaymentPasswordViewDelegate>
{
    startView *goodStar;
    startView *holderStart;
    UILabel *goodGrade,*holderGrade;
    NSMutableArray *imgAry;
    NSMutableArray *dataAry;
    NSInteger choosePingj;//选中管家评价
    NSMutableArray *chooseImgAry;//灰色对勾数组
    NSInteger lastChosePingj;//上次选中评价
    MaskView *mask;
    OnLinePayView *onLinePayView;//在线支付页面
    PaymentPasswordView *passPopView;
    MBProgressHUD *allBub;
    NSString *leimuName;//类目
    NSString *payMoney;//金额
    NSString *chooseIndex;
}
@end
@implementation orderEvaluateViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:txtColors(4, 196, 153, 1)];
    mainController *main = (mainController *)self.tabBarController;
    [main showOrHiddenTabBarView:YES];
    
     [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PaymentFailure) name:@"PaymentFailure" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLinePayViewHidden) name:@"onLinePayViewHidden" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wchatPayClick) name:@"wchatPayClick" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wxPayResult:) name:@"weixinzhifu" object:nil];
    [self maskDisMiss];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    __weak typeof (self) weakSelf = self;
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = weakSelf;
    }
    imgAry = [[NSMutableArray alloc]init];
    dataAry = [[NSMutableArray alloc]init];
    chooseImgAry = [[NSMutableArray alloc]init];
    choosePingj = 5;
    lastChosePingj = 0;
    chooseIndex = @"5";
    [self initNavigation];
    [self SubViews];
    [self reloadData];
    [self maskView];
    [self initOnLinePayView];
}
-(void)reloadData
{
    [HTTPTool getWithUrl:@"enterPingjiaPage.action" params:nil success:^(id json) {
        UIWebView *vb = (UIWebView *)[self.view viewWithTag:11011];
        
        [vb loadHTMLString:[self reSizeImageWithHTML:[json valueForKey:@"image"]] baseURL:nil];
        NSArray *ary = [json valueForKey:@"pingjia"];
        
        for (NSDictionary *dic in ary) {
            orderPingjiaModel *model = [[orderPingjiaModel alloc]initWithContent:dic];
            [dataAry addObject:model];
        }
        [self reldImageData];
    } failure:^(NSError *error) {
        MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        bud.mode = MBProgressHUDModeCustomView;
        bud.labelText = @"网络连接错误";
        [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }];
}
-(void)reldImageData
{
    for (int i = 0; i<5; i++) {
        UIImageView *img = imgAry[i];
        orderPingjiaModel *mod = dataAry[i];
        [img sd_setImageWithURL:[NSURL URLWithString:mod.logo] placeholderImage:[UIImage imageNamed:@"placeHolder"] options:SDWebImageRefreshCached];
    }
}
-(void)initNavigation
{
    self.navigationItem.title = @"订单评价";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:MLwordFont_2],NSFontAttributeName,nil]];
    UIButton *leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftbutton.frame = CGRectMake(0, 0, NVbtnWight, NVbtnWight);
    [leftbutton setBackgroundImage:[UIImage imageNamed:@"返回按钮"] forState:UIControlStateNormal];
    [leftbutton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    leftbutton.tag = 1001;
    UIBarButtonItem *leftbarBtn = [[UIBarButtonItem alloc]initWithCustomView:leftbutton];
    self.navigationItem.leftBarButtonItem =leftbarBtn;
}
-(void)SubViews
{
    UIWebView *vb = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 280*MCscale)];
    vb.userInteractionEnabled = NO;
    vb.tag = 11011;
    vb.backgroundColor = [UIColor whiteColor];
    vb.opaque = NO;
    vb.delegate = self;
    [self.view addSubview:vb];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, vb.bottom,kDeviceWidth,2)];
    line.backgroundColor = lineColor;
    [self.view addSubview:line];
    
    UIImageView *pingjiaImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, line.bottom+5, kDeviceWidth, 145*MCscale)];
    pingjiaImg.userInteractionEnabled = YES;
    pingjiaImg.image = [UIImage imageNamed:@"综合评价"];
    pingjiaImg.backgroundColor = [UIColor whiteColor];
    pingjiaImg.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:pingjiaImg];
    
    goodStar = [[startView alloc]initWithFrame:CGRectMake(80*MCscale, 50*MCscale, 170*MCscale, 30*MCscale)];
    goodStar.clipsToBounds = YES;
    goodStar.backgroundColor = [UIColor clearColor];
    UIPanGestureRecognizer *goodStratPan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(goodPanAction:)];
    [goodStar addGestureRecognizer:goodStratPan];
    UITapGestureRecognizer *goodTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goodTapAction:)];
    [goodStar addGestureRecognizer:goodTap];
    
    [pingjiaImg addSubview:goodStar];
    goodGrade = [[UILabel alloc]initWithFrame:CGRectMake(goodStar.right+20, goodStar.top+5, 30*MCscale, 20*MCscale)];
    goodGrade.backgroundColor = [UIColor clearColor];
    goodGrade.text = @"100";
    goodGrade.textColor = txtColors(249, 54, 73, 1);
    goodGrade.textAlignment = NSTextAlignmentCenter;
    goodGrade.font = [UIFont systemFontOfSize:MLwordFont_6];
    [pingjiaImg addSubview:goodGrade];
    
    for (int i = 0; i<5; i++) {
        UIImageView *mgVie = [[UIImageView alloc]initWithFrame:CGRectMake(15+(kDeviceWidth-50)/5.0*i+5*i, pingjiaImg.bottom+12, (kDeviceWidth-50)/5.0, (kDeviceWidth-50)/5.0)];
        mgVie.backgroundColor = [UIColor clearColor];
        mgVie.tag = i+1;
        mgVie.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(guanjTap:)];
        [mgVie addGestureRecognizer:tap];
        [imgAry addObject:mgVie];
        [self.view addSubview:mgVie];
        
        UIImageView *choseImg = [[UIImageView alloc]initWithFrame:CGRectMake(20+(kDeviceWidth-50)/5.0*i+5*i, pingjiaImg.bottom+20, (kDeviceWidth-50)/6.0, (kDeviceWidth-50)/6.0)];
        choseImg.image = [UIImage imageNamed:@"对勾"];
        choseImg.alpha = 0;
        choseImg.backgroundColor = [UIColor clearColor];
        [chooseImgAry addObject:choseImg];
        [self.view addSubview:choseImg];
    }
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, pingjiaImg.bottom+(kDeviceWidth-50)/5.0+25, kDeviceWidth, 1.5)];
    line1.backgroundColor = lineColor;
    [self.view addSubview:line1];
    UIButton *submit = [UIButton buttonWithType:UIButtonTypeCustom];
    submit.frame = CGRectMake(15, kDeviceHeight-60*MCscale, kDeviceWidth-30*MCscale, 48*MCscale);
    submit.backgroundColor = txtColors(249, 54, 73, 1);
    [submit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submit.tag = 101;
    [submit setTitle:@"提交评价" forState:UIControlStateNormal];
    submit.titleLabel.font = [UIFont boldSystemFontOfSize:MLwordFont_2];
    [submit addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    submit.layer.cornerRadius = 5.0;
    submit.layer.masksToBounds = YES;
    [self.view addSubview:submit];
}
//管家评价 获取图片
-(void)guanjTap:(UITapGestureRecognizer *)tap
{
    NSInteger tapTg = tap.view.tag;
    choosePingj = tapTg-1;
    NSString *sfe = [NSString stringWithFormat:@"%ld",choosePingj];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"chooseIndex"];
    [[NSUserDefaults standardUserDefaults] setValue:sfe forKey:@"chooseIndex"];
    orderPingjiaModel *model = dataAry[tapTg-1];
    UIImageView *img = chooseImgAry[lastChosePingj];
    img.alpha = 0;
    UIImageView *nImg = chooseImgAry[tapTg-1];
    nImg.alpha = 1;
    lastChosePingj = tapTg-1;
    NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"id":model.pingj_id}];
    [HTTPTool getWithUrl:@"getPingjiaImage.action" params:pram success:^(id json) {
        UIWebView *vb = (UIWebView *)[self.view viewWithTag:11011];
        [vb loadHTMLString:[self reSizeImageWithHTML:[json valueForKey:@"image"]] baseURL:nil];
    } failure:^(NSError *error) {
        MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        bud.mode = MBProgressHUDModeCustomView;
        bud.labelText = @"网络连接错误";
        [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }];
    
    if (choosePingj == 0 || choosePingj == 1) {
        chooseIndex = @"5";
        NSUserDefaults *sdf = [NSUserDefaults standardUserDefaults];
        if ([sdf integerForKey:@"isLogin"]==1)
        {
            NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"userid":user_id,@"money":model.guanjia}];
            [HTTPTool getWithUrl:@"checkZhifuYue.action" params:pram success:^(id json) {
                if ([[json valueForKey:@"message"]integerValue]==1) {
                    [UIView animateWithDuration:0.3 animations:^{
                        mask.alpha = 1;
                        [self .view addSubview:mask];
                        onLinePayView = [[OnLinePayView alloc]initWithFrame:CGRectMake(30*MCscale, 150*MCscale, kDeviceWidth- 60*MCscale,240*MCscale)];
                        onLinePayView.onLinePayDelegate = self;
                        onLinePayView.isFrom = 0;
                        [onLinePayView.promptInformationLabel removeFromSuperview];
                        [onLinePayView.moneyTextFiled removeFromSuperview];
                        onLinePayView.alpha = 0.95;
                        [self getPaymentInformation];
                        [self.view addSubview:onLinePayView];
                    }];
                }
                else
                {
                    [UIView animateWithDuration:0.3 animations:^{
                        mask.alpha = 1;
                        [self .view addSubview:mask];
                        onLinePayView = [[OnLinePayView alloc]initWithFrame:CGRectMake(30*MCscale, 150*MCscale, kDeviceWidth- 60*MCscale,180*MCscale)];
                        onLinePayView.onLinePayDelegate = self;
                        onLinePayView.isFrom = 0;
                        [onLinePayView.promptInformationLabel removeFromSuperview];
                        [onLinePayView.moneyTextFiled removeFromSuperview];
                        [onLinePayView.line3 removeFromSuperview];
                        [onLinePayView.moreView removeFromSuperview];
                        onLinePayView.alpha = 0.95;
                        [self getPaymentInformation];
                        [self.view addSubview:onLinePayView];
                    }];
                }
                
            } failure:^(NSError *error) {
                MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                bud.mode = MBProgressHUDModeCustomView;
                bud.labelText = @"网络连接错误";
                [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
            }];
        }
        else{
            [UIView animateWithDuration:0.3 animations:^{
                mask.alpha = 1;
                [self .view addSubview:mask];
                onLinePayView = [[OnLinePayView alloc]initWithFrame:CGRectMake(30*MCscale, 150*MCscale, kDeviceWidth- 60*MCscale,180*MCscale)];
                onLinePayView.onLinePayDelegate = self;
                onLinePayView.isFrom = 0;
                [onLinePayView.promptInformationLabel removeFromSuperview];
                [onLinePayView.moneyTextFiled removeFromSuperview];
                [onLinePayView.line3 removeFromSuperview];
                [onLinePayView.moreView removeFromSuperview];
                onLinePayView.alpha = 0.95;
                [self getPaymentInformation];
                [self.view addSubview:onLinePayView];
            }];
        }
    }
    else
    {
        chooseIndex = [[NSUserDefaults standardUserDefaults] valueForKey:@"chooseIndex"];
    }
}
//得到支付信息
-(void)getPaymentInformation
{
    orderPingjiaModel *model = dataAry[choosePingj];
    NSString *payMoney1 = model.guanjia;
    NSString *body = [NSString stringWithFormat:@"妙生活城+%@%@",self.danhao,model.name];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyMMddHHmmss"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    NSString *danhaoStr = [NSString stringWithFormat:@"%@%@",userShequ_id,dateTime];
    [onLinePayView reloadDataFromDanhao:danhaoStr AndMoney:payMoney1 AndBody:body AndLeiming:model.name];
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
        onLinePayView.alpha = 0;
        passPopView.alpha = 0;
        [self.view endEditing:YES];
        [onLinePayView removeFromSuperview];
        [passPopView removeFromSuperview];
        UIImageView *img = chooseImgAry[lastChosePingj];
        img.alpha = 0;
        choosePingj = 5;
        NSString *sfe = [NSString stringWithFormat:@"%ld",choosePingj];
        [[NSUserDefaults standardUserDefaults] setValue:sfe forKey:@"chooseIndex"];
        chooseIndex = [[NSUserDefaults standardUserDefaults]valueForKey:@"chooseIndex"];
    }];
}
//订单评价支付
-(void)initOnLinePayView
{
    //支付密码
    passPopView = [[PaymentPasswordView alloc]initWithFrame:CGRectMake(kDeviceWidth/20.0, 180*MCscale, kDeviceWidth*9/10.0, 360*MCscale)];
    passPopView.paymentPasswordDelegate = self;
    passPopView.alpha = 0;
}

#pragma  mark OnLinePayViewDelegate
-(void)PaymentPasswordViewWithDanhao:(NSString *)danhao AndLeimu:(NSString *)leimu AndMoney:(NSString *)money
{
    [UIView animateWithDuration:0.3 animations:^{
        mask.alpha = 1;
        [self .view addSubview:mask];
        passPopView.alpha = 0.95;
        [self.view addSubview:passPopView];
    }];
    leimuName = leimu;
    payMoney = money;
}
#pragma  mark PaymentPasswordViewDeledate
-(void)PaymentSuccess
{
    [UIView animateWithDuration:0.3 animations:^{
        mask.alpha = 0;
        [mask removeFromSuperview];
        passPopView.alpha = 0;
        [passPopView removeFromSuperview];
    }];
    
    NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"userid":user_id,@"dindan.danhao":self.danhao,@"dindan.jine":payMoney,@"leimu":leimuName}];
    
    [HTTPTool getWithUrl:@"savepingjia.action" params:pram success:^(id json) {
        [allBub hide:YES];
        NSString *message =[NSString stringWithFormat:@"%@",[json valueForKey:@"massages"]] ;
        if ([message isEqualToString:@"1"]) {
            [UIView animateWithDuration:0.3 animations:^{
                mask.alpha = 0;
                [mask removeFromSuperview];
                onLinePayView.alpha = 0;
                [onLinePayView removeFromSuperview];
            }];
            chooseIndex = [[NSUserDefaults standardUserDefaults] valueForKey:@"chooseIndex"];
            [self coluserStar];
        }
        else
        {
            MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            bud.mode = MBProgressHUDModeCustomView;
            bud.labelText = @"评价失败";
            [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
        }
    } failure:^(NSError *error) {
        [allBub hide:YES];
        MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        bud.mode = MBProgressHUDModeCustomView;
        bud.labelText = @"网络连接错误10";
        [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }];
}
-(void)wchatPayClick
{
    UIImageView *img = chooseImgAry[lastChosePingj];
    img.alpha = 0;
    choosePingj = 5;
}

-(void)wxPayResult:(NSNotification *)notifaction
{
        PayResp *resp = notifaction.object;
        NSLog(@"resp.errCode===%d",resp.errCode);
        if (resp.errCode == WXSuccess) {
            [self pingjiaGuanjiaForMoney];
        }
        else{
            [self PaymentFailure];
        }
}

//接受来自支付成功的通知实现方法
-(void)pingjiaGuanjiaForMoney
{
    MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    bud.mode = MBProgressHUDModeCustomView;
    bud.labelText = @"支付成功";
    [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    [UIView animateWithDuration:0.3 animations:^{
        mask.alpha = 0;
        [mask removeFromSuperview];
        onLinePayView.alpha = 0;
        [onLinePayView removeFromSuperview];
    }];
    chooseIndex = [[NSUserDefaults standardUserDefaults] valueForKey:@"chooseIndex"];
    [self coluserStar];
}

-(void)PaymentFailure
{
    MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    bud.mode = MBProgressHUDModeCustomView;
    bud.labelText = @"支付失败";
    [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    UIImageView *img = chooseImgAry[lastChosePingj];
    img.alpha = 0;
    choosePingj = 5;
    NSString *sfe = [NSString stringWithFormat:@"%ld",choosePingj];
    [[NSUserDefaults standardUserDefaults] setValue:sfe forKey:@"chooseIndex"];
    chooseIndex = [[NSUserDefaults standardUserDefaults]valueForKey:@"chooseIndex"];
}

//接收隐藏弹框的通知
-(void)onLinePayViewHidden
{
    [UIView animateWithDuration:0.3 animations:^{
        mask.alpha = 0;
        [mask removeFromSuperview];
        onLinePayView.alpha = 0;
        [onLinePayView removeFromSuperview];
    }];
}
- (NSString *)reSizeImageWithHTML:(NSString *)html
{
    return [NSString stringWithFormat:@"<head><style>img{text-align:center;max-width:375px;max-height:206px}</style></head><img src='%@'/>",html];
}
-(void)goodPanAction:(UIPanGestureRecognizer *)pan
{
    if (pan.state == UIGestureRecognizerStateChanged) {
        CGPoint endPoin = [pan locationInView:goodStar];
        NSInteger mark;
        CGRect redFram = goodStar.redView.frame;
        if (endPoin.x >= 0 && endPoin.x <15*MCscale) {
            redFram.size.width = 15*MCscale;
            mark =10;
        }
        else if (endPoin.x <=35*MCscale){
            redFram.size.width = 30*MCscale;
            mark =20;
        }
        else if (endPoin.x <=50*MCscale){
            redFram.size.width = 50*MCscale;
            mark =30;
        }
        else if (endPoin.x <=70*MCscale){
            redFram.size.width = 65*MCscale;
            mark =40;
        }
        else if (endPoin.x <=85*MCscale){
            redFram.size.width = 85*MCscale;
            mark =50;
        }
        else if (endPoin.x <=105*MCscale){
            redFram.size.width = 100*MCscale;
            mark =60;
        }
        else if (endPoin.x <=120*MCscale){
            redFram.size.width = 120*MCscale;
            mark =70;
        }
        else if (endPoin.x <=140*MCscale){
            redFram.size.width = 135*MCscale;
            mark =80;
        }
        else if (endPoin.x <=155*MCscale){
            redFram.size.width = 155*MCscale;
            mark =90;
        }
        else{
            redFram.size.width = 170*MCscale;
            mark =100;
        }
        goodStar.redView.frame = redFram;
        goodGrade.text = [NSString stringWithFormat:@"%ld",(long)mark];
    }
}
-(void)holderPanAction:(UIPanGestureRecognizer *)pan
{
    if (pan.state == UIGestureRecognizerStateChanged) {
        CGPoint endPoin = [pan locationInView:holderStart];
        NSInteger mark;
        CGRect redFram = holderStart.redView.frame;
        if (endPoin.x >= 0 && endPoin.x <15*MCscale) {
            redFram.size.width = 15*MCscale;
            mark =10;
        }
        else if (endPoin.x <=35*MCscale){
            redFram.size.width = 30*MCscale;
            mark =20;
        }
        else if (endPoin.x <=50*MCscale){
            redFram.size.width = 50*MCscale;
            mark =30;
        }
        else if (endPoin.x <=70*MCscale){
            redFram.size.width = 65*MCscale;
            mark =40;
        }
        else if (endPoin.x <=85*MCscale){
            redFram.size.width = 85*MCscale;
            mark =50;
        }
        else if (endPoin.x <=105*MCscale){
            redFram.size.width = 100*MCscale;
            mark =60;
        }
        else if (endPoin.x <=120*MCscale){
            redFram.size.width = 120*MCscale;
            mark =70;
        }
        else if (endPoin.x <=140*MCscale){
            redFram.size.width = 135*MCscale;
            mark =80;
        }
        else if (endPoin.x <=155*MCscale){
            redFram.size.width = 155*MCscale;
            mark =90;
        }
        else{
            redFram.size.width = 170*MCscale;
            mark =100;
        }
        holderStart.redView.frame = redFram;
        holderGrade.text = [NSString stringWithFormat:@"%ld",(long)mark];
    }
}
-(void)holderTapAction:(UITapGestureRecognizer *)tap
{
    CGPoint tapPoint = [tap locationInView:holderStart];
    NSInteger mark;
    CGRect redFram = holderStart.redView.frame;
    if (tapPoint.x >= 0 && tapPoint.x <15*MCscale) {
        redFram.size.width = 15*MCscale;
        mark =10;
    }
    else if (tapPoint.x <=35*MCscale){
        redFram.size.width = 30*MCscale;
        mark =20;
    }
    else if (tapPoint.x <=50*MCscale){
        redFram.size.width = 50*MCscale;
        mark =30;
    }
    else if (tapPoint.x <=70*MCscale){
        redFram.size.width = 65*MCscale;
        mark =40;
    }
    else if (tapPoint.x <=85*MCscale){
        redFram.size.width = 85*MCscale;
        mark =50;
    }
    else if (tapPoint.x <=105*MCscale){
        redFram.size.width = 100*MCscale;
        mark =60;
    }
    else if (tapPoint.x <=120*MCscale){
        redFram.size.width = 120*MCscale;
        mark =70;
    }
    else if (tapPoint.x <=140*MCscale){
        redFram.size.width = 135*MCscale;
        mark =80;
    }
    else if (tapPoint.x <=155*MCscale){
        redFram.size.width = 155*MCscale;
        mark =90;
    }
    else{
        redFram.size.width = 170*MCscale;
        mark =100;
    }
    holderStart.redView.frame = redFram;
    holderGrade.text = [NSString stringWithFormat:@"%ld",(long)mark];
}
-(void)goodTapAction:(UITapGestureRecognizer *)tap
{
    CGPoint tapPoint = [tap locationInView:goodStar];
    NSInteger mark;
    CGRect redFram = goodStar.redView.frame;
    if (tapPoint.x >= 0 && tapPoint.x <15*MCscale) {
        redFram.size.width = 15*MCscale;
        mark =10;
    }
    else if (tapPoint.x <=35*MCscale){
        redFram.size.width = 30*MCscale;
        mark =20;
    }
    else if (tapPoint.x <=50*MCscale){
        redFram.size.width = 50*MCscale;
        mark =30;
    }
    else if (tapPoint.x <=70*MCscale){
        redFram.size.width = 65*MCscale;
        mark =40;
    }
    else if (tapPoint.x <=85*MCscale){
        redFram.size.width = 85*MCscale;
        mark =50;
    }
    else if (tapPoint.x <=105*MCscale){
        redFram.size.width = 100*MCscale;
        mark =60;
    }
    else if (tapPoint.x <=120*MCscale){
        redFram.size.width = 120*MCscale;
        mark =70;
    }
    else if (tapPoint.x <=140*MCscale){
        redFram.size.width = 135*MCscale;
        mark =80;
    }
    else if (tapPoint.x <=155*MCscale){
        redFram.size.width = 155*MCscale;
        mark =90;
    }
    else{
        redFram.size.width = 170*MCscale;
        mark =100;
    }
    goodStar.redView.frame = redFram;
    goodGrade.text = [NSString stringWithFormat:@"%ld",(long)mark];
}
-(void)btnAction:(UIButton *)btn
{
    if (btn.tag == 1001) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        mainController *main = (mainController *)self.tabBarController;
        [main showOrHiddenTabBarView:NO];
    }
    if (btn.tag == 101) {
        [self coluserStar];
    }
}
//订单评价
-(void)coluserStar
{
    if (chooseIndex.integerValue == 5) {
        MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        bud.mode = MBProgressHUDModeCustomView;
        bud.labelText = @"请评价后提交";
        [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }
    else
    {
        NSLog(@"self.danhao ====== %@",self.danhao);
        
        orderPingjiaModel *model = dataAry[chooseIndex.integerValue];
        NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"orderid":self.danhao,@"pingjianame":model.name,@"pingjiavalue":model.guanjia,@"shequvalue":model.guanjia,@"pingfen":goodGrade.text}];
        [HTTPTool postWithUrl:@"savePingjiaInfo.action" params:pram success:^(id json) {
            NSString *mesage = [NSString stringWithFormat:@"%@",[json valueForKey:@"message"]];
            if ([mesage isEqualToString:@"1"]) {
                MBProgressHUD *huub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                huub.mode = MBProgressHUDModeText;
                huub.labelText = @"评价成功!";
                [huub showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
                [self performSelector:@selector(pingjaSuccess) withObject:self afterDelay:1.5];
                NSNotification *notification = [NSNotification notificationWithName:@"orderPingjiaNotfic" object:nil];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
                [[NSNotificationCenter defaultCenter] removeObserver:self name:@"orderPingjiaNotfic" object:nil];
            }
            else{
                MBProgressHUD *huub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                huub.mode = MBProgressHUDModeText;
                huub.labelText = @"评价失败!请稍后重试";
                [huub showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
            }
        } failure:^(NSError *error) {
            MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            bud.mode = MBProgressHUDModeCustomView;
            bud.labelText = @"网络连接错误";
            [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
        }];
    }
}
-(void)pingjaSuccess
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    mainController *main = (mainController *)self.tabBarController;
    [main showOrHiddenTabBarView:NO];
}
- (void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)myTask
{
    sleep(1.5);
}
@end
