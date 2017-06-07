//
//  md5_password.h
//  LifeForMM
//
//  Created by HUI on 16/3/15.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface md5_password : NSObject
+(NSString *)encryptionPassword:(NSString *)pas userTel:(NSString *)tel;
+(NSString *)encryptionPassword:(NSString *)pas userId:(NSString *)uid;
@end
