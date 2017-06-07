//
//  feedbackViewController.m
//  LifeForMM
//
//  Created by 时元尚品 on 15/7/22.
//  Copyright (c) 2015年 时元尚品. All rights reserved.
//

#import "feedbackViewController.h"
#import "Header.h"
@interface feedbackViewController ()<UITextViewDelegate,UITextFieldDelegate>
{
    UIView *maskView;
    UIImageView *selectImage;//选中图片
    UILabel *label;//提示label
    UITextView *opinionTextView;//意见
    UITextField *num; //电话号码
    BOOL isChooseNum;
    UIButton *submit;
    CGRect numFrame;
}
@end

@implementation feedbackViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:txtColors(4, 196, 153, 1)];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
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
    isChooseNum = 0;
    [self initNavigation];
    [self initSubViews];
    [self initMaskView];
}
-(void)initNavigation
{
    self.navigationItem.title = @"意见反馈";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:MLwordFont_2],NSFontAttributeName,nil]];
    UIButton *leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftbutton.frame = CGRectMake(0, 0, NVbtnWight, NVbtnWight);
    [leftbutton setBackgroundImage:[UIImage imageNamed:@"返回按钮"] forState:UIControlStateNormal];
    [leftbutton addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    leftbutton.tag = 1001;
    UIBarButtonItem *leftbarBtn = [[UIBarButtonItem alloc]initWithCustomView:leftbutton];
    self.navigationItem.leftBarButtonItem =leftbarBtn;
}
-(void)initSubViews
{
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 190*MCscale,kDeviceWidth , 1)];
    line1.backgroundColor = txtColors(88, 89, 90, 0.5);
    [self.view addSubview:line1];
    
    opinionTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, line1.bottom, kDeviceWidth, 120)];
    opinionTextView.text= @"     请留下您的宝贵意见和建议，我们将努力改进";
    opinionTextView.textColor = txtColors(182, 183, 184, 1);
    opinionTextView.delegate = self;
    opinionTextView.font = [UIFont systemFontOfSize:MLwordFont_5];
    opinionTextView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:opinionTextView];
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, opinionTextView.bottom+5,kDeviceWidth , 5)];
    line2.backgroundColor = txtColors(234, 235, 236, 1);
    [self.view addSubview:line2];
    
    selectImage = [[UIImageView alloc]initWithFrame:CGRectMake(30, line2.bottom+10, 24*MCscale, 24*MCscale)];
    selectImage.backgroundColor = [UIColor clearColor];
    selectImage.image = [UIImage imageNamed:@"选中"];
    selectImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bangdingNumAction)];
    [selectImage addGestureRecognizer:imageTap];
    [self.view addSubview:selectImage];
    
    label = [[UILabel alloc]initWithFrame:CGRectMake(selectImage.right+10, selectImage.top, 180, 20)];
    label.textAlignment = NSTextAlignmentLeft;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    label.text = @"使用账号绑定手机号联系";
    label.font = [UIFont systemFontOfSize:MLwordFont_5];
    label.userInteractionEnabled = YES;
    UITapGestureRecognizer *labTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bangdingNumAction)];
    [label addGestureRecognizer:labTap];
    [self.view addSubview:label];
    
    num = [[UITextField alloc]initWithFrame:CGRectMake(0, selectImage.bottom+10, kDeviceWidth, 40)];
    num.backgroundColor = txtColors(236, 237, 239, 1);
    num.delegate = self;
    num.textAlignment = NSTextAlignmentCenter;
    num.font = [UIFont systemFontOfSize:MLwordFont_2];
    num.keyboardType = UIKeyboardTypeNumberPad;
    //    num.clearButtonMode = UITextFieldViewModeAlways;
    num.placeholder = @"请输入有效手机号 以便我们联系您";
    numFrame = num.frame;
    
//    //自定制清除按钮
//    UIButton *button  = [[UIButton alloc]initWithFrame:CGRectMake(num.right - 35, 5, 30, 30)];
//    
////    button.backgroundColor = [UIColor greenColor];
//    [button setImage:[UIImage imageNamed:@"删除png"] forState:UIControlStateNormal];
//    
//    [button addTarget:self action:@selector(clearButtonClick) forControlEvents:UIControlEventTouchUpInside];
//    
//    [num addSubview:button];
    
    submit = [UIButton buttonWithType:UIButtonTypeCustom];
    submit.frame = CGRectMake(kDeviceWidth/10.0, selectImage.bottom+44, kDeviceWidth*4/5.0, 48*MCscale);
    submit.backgroundColor = txtColors(249, 54, 73, 1);
    [submit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submit setTitle:@"提交" forState:UIControlStateNormal];
    submit.titleLabel.font = [UIFont boldSystemFontOfSize:MLwordFont_2];
    [submit addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
    submit.layer.cornerRadius = 5.0;
    submit.layer.masksToBounds = YES;
    [self.view addSubview:submit];
    
    NSUserDefaults *sdf = [NSUserDefaults standardUserDefaults];
    if ([sdf integerForKey:@"isLogin"]==0)
    {
        selectImage.hidden = YES;
        label.hidden = YES;
        
        num.frame =CGRectMake(0, selectImage.center.y, kDeviceWidth, 40);
        numFrame = num.frame;
        [self.view addSubview:num];
        
        CGRect fram = submit.frame;
        fram.origin.y +=40;
        submit.frame = fram;
    }
}

//-(void)clearButtonClick
//{
//    num.text = @"";
//    [num resignFirstResponder];
//}
//手势遮罩
-(void)initMaskView
{
    maskView = [[UIView alloc]initWithFrame:self.view.bounds];
    maskView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [maskView addGestureRecognizer:tap];
}
-(void)btnAction
{
    [self.navigationController popViewControllerAnimated:YES];
    //    mainController *main = (mainController *)self.tabBarController;
    //    [main showOrHiddenTabBarView:NO];
}
-(void)tapAction:(UITapGestureRecognizer *)tap
{
    [self.view endEditing:YES];
}
#pragma mark UITextViewDelegate
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqual:@"     请留下您的宝贵意见和建议，我们将努力改进"]) {
        textView.textColor = [UIColor blackColor];
        textView.text = @"";
    }
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqual:@""]) {
        textView.text = @"     请留下您的宝贵意见和建议，我们将努力改进";
        textView.textColor = txtColors(182, 183, 184, 1);
    }
}

#pragma mark UITextfiledDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField == num ){
        NSInteger leng = textField.text.length;
        NSInteger selectLeng = range.length;
        NSInteger replaceLeng = string.length;
        if (leng - selectLeng + replaceLeng > 11){
            return NO;
        }
        else
            return YES;
    }
    return YES;
}
-(void)submitAction:(UIButton *)btn
{
    NSString *textViewValue;
    NSString *numString;
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9])|(14[7,5])|(17[0,6,7,8]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    BOOL isMatch = [phoneTest evaluateWithObject:num.text];
    BOOL isOk = 0;
    BOOL isMesg = 0;
    if (![opinionTextView.text isEqualToString:@"     请留下您的宝贵意见和建议，我们将努力改进"]) {
        textViewValue = opinionTextView.text;
        isMesg = 1;
    }
    else{
        MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        mbHud.mode = MBProgressHUDModeText;
        mbHud.labelText = @"反馈意见不能为空!";
        [mbHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
        isMesg = 0;
    }
    NSMutableDictionary *pram;
    NSUserDefaults *sdf = [NSUserDefaults standardUserDefaults];
    if ([sdf integerForKey:@"isLogin"]==1) {
        if(isChooseNum){
            if (isMatch) {
                numString = num.text;
                isOk = 1;
            }
            else{
                MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                mbHud.mode = MBProgressHUDModeText;
                mbHud.labelText = @"手机格式错误!";
                [mbHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
            }
        }
        else{
            numString = userName_tel;
            isOk = 1;
        }
        if (isOk && isMesg) {
            btn.enabled = NO;
            [btn setBackgroundColor:[UIColor grayColor]];
            
            MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            mbHud.mode = MBProgressHUDModeIndeterminate;
            mbHud.labelText = @"努力提交中....";
            [mbHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
            
            pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"yiJianFanKui.city":location_city,@"yiJianFanKui.shequ":userShequ_id,@"yiJianFanKui.username":user_id,@"yiJianFanKui.mobile":numString,@"yiJianFanKui.fankuineirong":opinionTextView.text}];
            
            [HTTPTool postWithUrl:@"yiJianFanKui.action" params:pram success:^(id json) {
                NSString *message =[NSString stringWithFormat:@"%@",[json valueForKey:@"message"]];
                if ([message isEqualToString:@"1"]) {
                    mbHud.mode = MBProgressHUDModeCustomView;
                    mbHud.labelText = @"提交成功";
                    mbHud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
                    [mbHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
                    [self performSelector:@selector(btnAction) withObject:self afterDelay:1.5];
                }
                else{
                    mbHud.mode = MBProgressHUDModeText;
                    mbHud.labelText = @"意见反馈失败!请稍后再试";
                    [mbHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
                }
                btn.enabled = YES;
                btn.backgroundColor = txtColors(249, 54, 73, 1);
            } failure:^(NSError *error) {
                MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                bud.mode = MBProgressHUDModeCustomView;
                bud.labelText = @"网络连接错误";
                [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
            }];
        }
    }
    else{
        if (isMatch) {
            numString = num.text;
            isOk = 1;
        }
        else{
            MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            mbHud.mode = MBProgressHUDModeText;
            mbHud.labelText = @"手机格式错误!";
            [mbHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
        }
        if (isOk && isMesg) {
            btn.enabled = NO;
            [btn setBackgroundColor:[UIColor grayColor]];
            
            MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            mbHud.mode = MBProgressHUDModeIndeterminate;
            mbHud.labelText = @"努力提交中....";
            [mbHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
            
            NSString *strSysName = [[UIDevice currentDevice].identifierForVendor UUIDString];
            
            MyLog(@"%@",strSysName);
            pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"yiJianFanKui.city":location_city,@"yiJianFanKui.shequ":userShequ_id,@"yiJianFanKui.username":strSysName,@"yiJianFanKui.mobile":numString,@"yiJianFanKui.fankuineirong":opinionTextView.text}];
            
            [HTTPTool postWithUrl:@"yiJianFanKui.action" params:pram success:^(id json) {
                NSString *message =[NSString stringWithFormat:@"%@",[json valueForKey:@"message"]];
                if ([message isEqualToString:@"1"]) {
                    mbHud.mode = MBProgressHUDModeCustomView;
                    mbHud.labelText = @"提交成功";
                    mbHud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
                    [mbHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
                    [self performSelector:@selector(btnAction) withObject:self afterDelay:1.5];
                }
                else{
                    mbHud.mode = MBProgressHUDModeText;
                    mbHud.labelText = @"意见反馈失败!请稍后再试";
                    [mbHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
                }
                btn.enabled = YES;
                btn.backgroundColor = txtColors(249, 54, 73, 1);
            } failure:^(NSError *error) {
                MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                bud.mode = MBProgressHUDModeCustomView;
                bud.labelText = @"网络连接错误";
                [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
            }];
        }
        
    }
}
-(void)bangdingNumAction
{
    if(isChooseNum == 0){
        selectImage.image = [UIImage imageNamed:@"选择"];
        isChooseNum = 1;
        [self.view addSubview:num];
        CGRect fram = submit.frame;
        fram.origin.y +=40;
        submit.frame = fram;
    }
    else{
        selectImage.image = [UIImage imageNamed:@"选中"];
        isChooseNum = 0 ;
        [num removeFromSuperview];
        CGRect fram = submit.frame;
        fram.origin.y -=40;
        submit.frame = fram;
    }
}
#pragma mark 键盘弹出与隐藏
//键盘弹出
-(void)keyboardWillShow:(NSNotification *)notifaction
{
    NSDictionary *userInfo = [notifaction userInfo];
    NSValue *userValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [userValue CGRectValue];
    NSTimeInterval animationDuration = [[[notifaction userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView setAnimationDuration:animationDuration];
    CGRect nframe = num.frame;
    if(nframe.origin.y>keyboardRect.origin.y-40){
        nframe.origin.y = keyboardRect.origin.y-40;
    }
    num.frame = nframe;
    [self.view addSubview:maskView];
}
- (void)myTask {
    // Do something usefull in here instead of sleeping ...
    sleep(1.5);
}

//键盘隐藏
-(void)keyboardWillHide:(NSNotification *)notifaction
{
    num.frame = numFrame;
    [maskView removeFromSuperview];
}
@end
