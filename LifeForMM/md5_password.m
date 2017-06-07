//
//  md5_password.m
//  LifeForMM
//
//  Created by HUI on 16/3/15.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import "md5_password.h"
#import <CommonCrypto/CommonDigest.h>
@implementation md5_password
/*+(NSString *)encryptionPassword:(NSString *)pas userTel:(NSString *)tel
 {
 NSString *adstr = [tel substringFromIndex:8];
 NSString *pasdStr = [NSString stringWithFormat:@"%@%@",adstr,pas];
 const char *original_str = [pasdStr UTF8String];
 unsigned char result[CC_MD5_DIGEST_LENGTH];
 CC_MD5(original_str, strlen(original_str), result);
 NSMutableString *hash = [NSMutableString string];
 for (int i = 0; i < 16; i++){
 [hash appendFormat:@"%02X", result[i]];
 }
 NSString *mdfiveString = [hash lowercaseString];
 
 const char *original_str1 = [mdfiveString UTF8String];
 unsigned char result1[CC_MD5_DIGEST_LENGTH];
 CC_MD5(original_str1, strlen(original_str1), result1);
 NSMutableString *hash1 = [NSMutableString string];
 for (int i = 0; i < 16; i++){
 [hash1 appendFormat:@"%02X", result1[i]];
 }
 NSString *mdfiveString1 = [hash1 lowercaseString];
 return mdfiveString1;
 }
 +(NSString *)encryptionPassword:(NSString *)pas userId:(NSString *)uid
 {
 NSString *pasdStr = [NSString stringWithFormat:@"%@%@",uid,pas];
 const char *original_str = [pasdStr UTF8String];
 unsigned char result[CC_MD5_DIGEST_LENGTH];
 CC_MD5(original_str, strlen(original_str), result);
 NSMutableString *hash = [NSMutableString string];
 for (int i = 0; i < 16; i++){
 [hash appendFormat:@"%02X", result[i]];
 }
 NSString *mdfiveString = [hash lowercaseString];
 
 const char *original_str1 = [mdfiveString UTF8String];
 unsigned char result1[CC_MD5_DIGEST_LENGTH];
 CC_MD5(original_str1, strlen(original_str1), result1);
 NSMutableString *hash1 = [NSMutableString string];
 for (int i = 0; i < 16; i++){
 [hash1 appendFormat:@"%02X", result1[i]];
 }
 NSString *mdfiveString1 = [hash1 lowercaseString];
 return mdfiveString1;
 }*/

+(NSString *)encryptionPassword:(NSString *)pas userTel:(NSString *)tel
{
    const char *original_str = [pas UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++){
        [hash appendFormat:@"%02X", result[i]];
    }
    NSString *mdfiveString = [hash lowercaseString];
    
    NSString *adstr = [tel substringFromIndex:8];
    NSString *pasdStr = [NSString stringWithFormat:@"%@%@",adstr,mdfiveString];
    const char *original_str1 = [pasdStr UTF8String];
    unsigned char result1[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str1, strlen(original_str1), result1);
    NSMutableString *hash1 = [NSMutableString string];
    for (int i = 0; i < 16; i++){
        [hash1 appendFormat:@"%02X", result1[i]];
    }
    NSString *mdfiveString1 = [hash1 lowercaseString];
    return mdfiveString1;
}
+(NSString *)encryptionPassword:(NSString *)pas userId:(NSString *)uid
{
    const char *original_str = [pas UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++){
        [hash appendFormat:@"%02X", result[i]];
    }
    NSString *mdfiveString = [hash lowercaseString];
    
    NSString *pasdStr = [NSString stringWithFormat:@"%@%@",uid,mdfiveString];
    const char *original_str1 = [pasdStr UTF8String];
    unsigned char result1[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str1, strlen(original_str1), result1);
    NSMutableString *hash1 = [NSMutableString string];
    for (int i = 0; i < 16; i++){
        [hash1 appendFormat:@"%02X", result1[i]];
    }
    NSString *mdfiveString1 = [hash1 lowercaseString];
    return mdfiveString1;
}

@end
