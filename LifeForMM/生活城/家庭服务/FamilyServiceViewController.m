//
//  FamilyServiceViewController.m
//  LifeForMM
//
//  Created by MIAO on 2016/12/21.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import "FamilyServiceViewController.h"
#import "Header.h"
@interface FamilyServiceViewController ()<UIGestureRecognizerDelegate,MBProgressHUDDelegate>

@end

@implementation FamilyServiceViewController
{
    UIImageView *topImage;
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
    [self initNavigation];
    [self initSubViews];
    [self initData];
    
}
-(void)initNavigation
{
    self.navigationItem.title = @"家庭服务";
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
    [rightButton setImage:[UIImage imageNamed:@"客服-空白"] forState:UIControlStateNormal];
    rightButton.tag = 102;
    [rightButton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
}

-(void)btnAction:(UIButton *)button
{
    if (button.tag == 1001) {
        mainController *main = (mainController *)self.tabBarController;
        [main showOrHiddenTabBarView:NO];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else
    {
        [self requestNetworkWrong:@"正在内测中,敬请期待"];
    }
}

#pragma mark -- 列表数据
-(void)initData
{
    MBProgressHUD *dbud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dbud.delegate = self;
    dbud.mode = MBProgressHUDModeIndeterminate;
    dbud.labelText = @"请稍等...";
    [dbud show:YES];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
    [HTTPTool getWithUrl:@"domesticService.action" params:nil success:^(id json) {
        [dbud hide:YES];
        NSLog(@"家庭服务 %@",json);
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *dict = (NSDictionary *)json;
            NSArray *imageArray1 = @[[dict valueForKey:@"picture1"],[dict valueForKey:@"picture2"],[dict valueForKey:@"picture3"]];
            NSArray *titleArray = @[[dict valueForKey:@"info1"],[dict valueForKey:@"info3"],[dict valueForKey:@"info2"]];
            NSArray *imageArray2 = @[[dict valueForKey:@"image1"],[dict valueForKey:@"image2"],[dict valueForKey:@"image3"],[dict valueForKey:@"image4"],[dict valueForKey:@"image5"],[dict valueForKey:@"image6"],[dict valueForKey:@"image7"],[dict valueForKey:@"image8"]];
            
            for (int i = 0; i<3; i++) {
                UIImageView *imageView = (UIImageView *)[self.view viewWithTag:200+i];
                [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",imageArray1[i]] ] placeholderImage:[UIImage imageNamed:@""]];
                UILabel *label =(UILabel *)[self.view viewWithTag:300+i];
                label.text = titleArray[i];
            }
            
            [topImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dict valueForKey:@"top"]]] placeholderImage:[UIImage imageNamed:@""]];
            
            for (int i = 0; i<8; i++) {
                UIImageView *imageView = (UIImageView *)[self.view viewWithTag:400+i];
                [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",imageArray2[i]]] placeholderImage:[UIImage imageNamed:@""]];
            }
        });
        } failure:^(NSError *error) {
            [dbud hide:YES];
            [self requestNetworkWrong:@"网络连接错误"];
        }];
    });
}
-(void)initSubViews
{
    topImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, kDeviceWidth,150*MCscale)];
    topImage.userInteractionEnabled = YES;
    [self.view addSubview:topImage];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    [topImage addGestureRecognizer:tap];
    
    UIView *backView1 = [[UIView alloc]initWithFrame:CGRectMake(0, topImage.bottom, kDeviceWidth, 40*MCscale)];
    backView1.backgroundColor = [UIColor clearColor];
    [self.view addSubview:backView1];
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(20*MCscale, 5*MCscale, 200*MCscale, 30*MCscale)];
    label1.textColor = textColors;
    label1.text = @"专业保洁   CLEAN";
    [backView1 addSubview:label1];
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(backView1.width -60*MCscale, 5*MCscale, 1, 30*MCscale)];
    line1.backgroundColor = lineColor;
    [backView1 addSubview:line1];
    
    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    moreBtn.frame = CGRectMake(backView1.width -60*MCscale, 10*MCscale, 60*MCscale, 20*MCscale);
    [moreBtn setTitleColor:textColors forState:UIControlStateNormal];
    moreBtn.titleLabel.font = [UIFont systemFontOfSize:MLwordFont_7];
    [moreBtn setTitle:@"更多" forState:UIControlStateNormal];
    [moreBtn addTarget:self action:@selector(moreBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [backView1 addSubview:moreBtn];
    CGFloat imageWidth = (kDeviceWidth-30*MCscale)/3.0;
    for (int i = 0; i<3; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((imageWidth+5*MCscale)*i + 10*MCscale, backView1.bottom, imageWidth, imageWidth)];
        imageView.tag = 200+i;
        imageView.userInteractionEnabled = YES;
        [self.view addSubview:imageView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
        [imageView addGestureRecognizer:tap];
        
        UILabel *label =[[UILabel alloc]initWithFrame:CGRectMake(imageView.left, imageView.bottom, imageWidth, 30*MCscale)];
        label.textColor= textColors;
        label.tag = 300+i;
        label.font = [UIFont systemFontOfSize:MLwordFont_7];
        label.backgroundColor = [UIColor clearColor];
        [self.view addSubview:label];
    }
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, backView1.bottom +30*MCscale+imageWidth, kDeviceWidth, 5*MCscale)];
    lineView.backgroundColor = lineColor;
    [self.view addSubview:lineView];
    
    UIView *backView2 = [[UIView alloc]initWithFrame:CGRectMake(0, lineView.bottom, kDeviceWidth, 40*MCscale)];
    backView2.backgroundColor = [UIColor clearColor];
    [self.view addSubview:backView2];
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(20*MCscale, 5*MCscale, 200*MCscale, 30*MCscale)];
    label2.textColor = textColors;
    label2.text = @"热门服务   CATEGORY";
    [backView2 addSubview:label2];
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(backView2.width -80*MCscale, 5*MCscale, 1, 30*MCscale)];
    line2.backgroundColor = lineColor;
    [backView2 addSubview:line2];
    
    UIButton *allBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    allBtn.frame = CGRectMake(backView2.width -80*MCscale, 10*MCscale, 80*MCscale, 20*MCscale);
    [allBtn setTitleColor:textColors forState:UIControlStateNormal];
    allBtn.titleLabel.font = [UIFont systemFontOfSize:MLwordFont_7];
    [allBtn setTitle:@"全部分类" forState:UIControlStateNormal];
    [allBtn addTarget:self action:@selector(moreBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [backView2 addSubview:allBtn];
    CGFloat imageWidth1 = (kDeviceWidth-30*MCscale)/4.0;

    CGFloat imageHeight = (kDeviceHeight - backView2.bottom-10*MCscale)/2.0;
    for (int i = 0; i<2; i++) {
        for (int j = 0; j<4; j++) {
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((imageWidth1+2.5*MCscale)*j + 10*MCscale,(imageHeight +5)*i+ backView2.bottom, imageWidth1, imageHeight)];
            imageView.tag = 400+j*2+i;
            imageView.userInteractionEnabled = YES;
            [self.view addSubview:imageView];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
            [imageView addGestureRecognizer:tap];
        }
    }
}
-(void)moreBtnClick
{
    [self requestNetworkWrong:@"正在内测中,敬请期待"];
}

-(void)tapClick:(UITapGestureRecognizer *)tap
{
    [self requestNetworkWrong:@"正在内测中,敬请期待"];
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
