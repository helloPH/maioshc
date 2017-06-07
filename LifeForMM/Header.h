//
//  Header.h
//  LifeForMM
//
//  Created by 时元尚品 on 15/7/14.
//  Copyright (c) 2015年 时元尚品. All rights .
//

#ifndef LifeForMM_Header_h
#define LifeForMM_Header_h
#endif

#import "UIViewExt.h"
#import "homePageCell.h"
#import "myCollectViewController.h"
#import "securitySetViewController.h"
#import "lifeCityViewController.h"
#import "HTTPTool.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageManager.h"
#import "MJRefresh.h"
#import "MBProgressHUD.h"
#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
#import "JSONKit.h"
#import <AlipaySDK/AlipaySDK.h>
//#import <AMapSearchKit/AMapSearchAPI.h>
//#import <MAMapKit/MAMapKit.h>
#import "MBPrompt.h"
#import "md5_password.h"
#import "Masonry.h"
#import "mainController.h"
#import "AFNetworking.h"
#import "MaskView.h"
#import <CommonCrypto/CommonDigest.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件
#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件
#import <CoreLocation/CoreLocation.h>

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#ifdef DEBUG
//调试
#define MyLog(...) NSLog(__VA_ARGS__)
#else
//发布
#define MyLog(...)
#endif
//屏幕大小
#define kDeviceHeight [UIScreen mainScreen].bounds.size.height
#define kDeviceWidth [UIScreen mainScreen].bounds.size.width
#define IPHONE_5 ((kDeviceHeight < 667.0)? (YES):(NO))
#define IPHONE_6 ((kDeviceHeight == 667.0)? (YES):(NO))
#define IPHONE_Plus ((kDeviceHeight > 667.0)? (YES):(NO))

#define userName_tel [[NSUserDefaults standardUserDefaults]valueForKey:@"userTel"]
//#define userLsatName_tel [[NSUserDefaults standardUserDefaults]valueForKey:@"userLastTel"]
#define userPass_pas [[NSUserDefaults standardUserDefaults]valueForKey:@"userPass"]
#define userShequ_id [[NSUserDefaults standardUserDefaults]valueForKey:@"userShequid"]
#define userShequ_Name [[NSUserDefaults standardUserDefaults]valueForKey:@"userShequName"]
#define user_id [[NSUserDefaults standardUserDefaults]valueForKey:@"userId"]
#define userLastAddress [[NSUserDefaults standardUserDefaults]valueForKey:@"addressName"]
#define userLongitude [[NSUserDefaults standardUserDefaults]valueForKey:@"longitude"]
#define userLatitude [[NSUserDefaults standardUserDefaults]valueForKey:@"latitude"]
#define isLogin [[NSUserDefaults standardUserDefaults]valueForKey:@"isLogin"]

#define userSheBei_id [[UIDevice currentDevice].identifierForVendor UUIDString]
#define chooseSq_id [[NSUserDefaults standardUserDefaults]valueForKey:@"choosePayShequid"]
#define location_city [[NSUserDefaults standardUserDefaults]valueForKey:@"locationShequCity"]
#define stor_url @"https://itunes.apple.com/us/app/miao-sheng-huo-cheng-she-qu/id1078254389?l=zh&ls=1&mt=8"

//更改内外网请将此处三个网址全部更改,更改内外网的时候请将APP卸载之后重装(测试机或者模拟器)
// http://192.168.1.99:8080/Mshc/   //内网
//http://www.m1ao.com/Mshc/     //外网
#define HTTPHEADER @"http://www.m1ao.com/Mshc/"

//http://192.168.1.99:8080/MshcWeb/
//http://www.m1ao.com/MshcWeb/
#define HTTPWeb @"http://www.m1ao.com/MshcWeb/"

//http://192.168.1.99:8080/Mshc_Guanjia/
//http://www.m1ao.com/Guanjia
#define HTTPPush @"http://www.m1ao.com/Guanjia"

//字体大小
#define MLwordFont_14 (IPHONE_5 ? 26 : 30)
#define MLwordFont_1 (IPHONE_5 ? 22 : 25)
#define MLwordFont_11 (IPHONE_5 ? 19 : 22)
#define MLwordFont_15 (IPHONE_5 ? 19 : 21)
#define MLwordFont_2 (IPHONE_5 ? 18 : 20)
#define MLwordFont_3 (IPHONE_5 ? 17 : 19)
#define MLwordFont_4 (IPHONE_5 ? 16 : 18)
#define MLwordFont_12 (IPHONE_5 ? 15 : 17)
#define MLwordFont_5 (IPHONE_5 ? 14 : 16)
#define MLwordFont_6 (IPHONE_5 ? 13 : 15)
#define MLwordFont_7 (IPHONE_5 ? 12 : 14)
#define MLwordFont_8 (IPHONE_5 ? 12 : 13)
#define MLwordFont_9 (IPHONE_5 ? 11 : 12)
#define MLwordFont_10 (IPHONE_5 ? 10 : 11)
#define MLwordFont_13 (IPHONE_5 ? 9 : 10)

//店铺
#define SCLHeight (IPHONE_5 ? 143.0 : 168.0) //单元格高度
#define SCLimageHeigh (IPHONE_5 ? 80 : 105) //商品高度
#define SCLgoinCarHeight (IPHONE_5 ? 30 : 40) //按钮大小
#define SCLgoinCarSpace (IPHONE_5 ? 50 : 60) //间距
#define SCTypeHeight (IPHONE_5 ? 30 : 35) //分类高度
//导航栏
#define NVbtnWight (IPHONE_5 ? 22 : 25) //导航栏按钮大小
//购物车
#define SCselectImgWidth (IPHONE_5 ? 25 : 30) //选中图片
#define SCgoodImgWidth (IPHONE_5 ? 70 : 90) //商品logo
#define SCscale (IPHONE_5 ? 0.8 : 1) //加减框缩放比例
#define SCscale1 (IPHONE_5 ? 0.65 : 1)
#define SCtitleWidth (IPHONE_5 ? 180 : 200) //商品名长度
#define SCcellHeight (IPHONE_5 ? 80 : 100)
//搜索
#define SEtxtfiledWidth (IPHONE_5 ? 200 : 240) //搜索框长度
#define SEbtnSpace (IPHONE_5 ? 90 : 84)
//个人中心
#define MCheadViewHeight (IPHONE_5 ? 162 : 190)
#define MCscale (IPHONE_5 ? 0.85 : 1)
#define MCshareImgWidth (IPHONE_5 ? 98 : 110)
#define MCbtnHeight (IPHONE_5 ? 35 : 42)//余额提现按钮高度
#define MCscale_1 (IPHONE_5 ? 0.9 : 1)
//颜色
#define txtColors(r,g,b,alp) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:alp]
#define textColors txtColors(109.0,109.0,109.0,1)
#define placeHolderColor txtColors(194, 195, 196, 1)  //占位符字体颜色
#define textBlackColor txtColors(72, 73, 74, 0.9)
#define lineColor txtColors(74, 75, 76, 0.2) //画线的颜色
#define redTextColor txtColors(237, 58, 76, 1) //红色字体颜色
