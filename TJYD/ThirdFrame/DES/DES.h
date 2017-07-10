//
//  DES.h
//  TJYD
//
//  Created by 吴定如 on 17/4/5.
//  Copyright © 2017年 Dist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DES : NSObject

+ (NSString *)decryptUseDES:(NSString *)cipherText key:(NSString *)key ;
+ (NSString *)encryptUseDES:(NSString *)clearText key:(NSString *)key ;

@end
