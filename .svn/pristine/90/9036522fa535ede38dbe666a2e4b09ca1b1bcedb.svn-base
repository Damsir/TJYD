//
//  DES.m
//  TJYD
//
//  Created by 吴定如 on 17/4/5.
//  Copyright © 2017年 Dist. All rights reserved.
//

#import "DES.h"
#import "GTMBase64.h"
#include <CommonCrypto/CommonCryptor.h>

@implementation DES

#pragma mark -- 加密
+ (NSString *)encryptUseDES:(NSString *)clearText key:(NSString *)key
{
    NSData *data = [clearText dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    unsigned char buffer[1024*10];
    memset(buffer, 0, sizeof(char));
    size_t numBytesEncrypted = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,  kCCAlgorithmDES, kCCOptionPKCS7Padding | kCCOptionECBMode, [key UTF8String], kCCKeySizeDES, nil, [data bytes], [data length], buffer, 1024*10, &numBytesEncrypted);
    
    NSString *plainText = nil;
    if (cryptStatus == kCCSuccess) {
        NSData *dataTemp = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        plainText = [GTMBase64 stringByEncodingData:dataTemp];
    }else{
        NSLog(@"DES加密失败");
    }
    return plainText;
}

#pragma mark -- 解密
+ (NSString *)decryptUseDES:(NSString *)cipherText key:(NSString *)key {
    // 利用 GTMBase64 解碼 Base64 字串
    NSData *cipherData = [GTMBase64 decodeString:cipherText];
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesDecrypted = 0;
    
    // IV 偏移量不需使用
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmDES, kCCOptionPKCS7Padding | kCCOptionECBMode,[key UTF8String], kCCKeySizeDES, nil, [cipherData bytes], [cipherData length], buffer, 1024, &numBytesDecrypted);
    NSString *plainText = nil;
    if (cryptStatus == kCCSuccess) {
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesDecrypted];
        plainText = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return plainText;
}


@end
