//
//  MD5.m
//  万网
//
//  Created by Ibokan on 12-11-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MD5.h"
#import <CommonCrypto/CommonDigest.h>

@implementation MD5

//此处需要在我们已经写好的MD5类中添加⽅方法
+ (NSString *)md5Digest:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), result);
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3], result[4], result[5],
             result[6], result[7],
             result[8], result[9], result[10], result[11], result[12],
             result[13], result[14], result[15]
             ] uppercaseString];
}
//copy过去即可,别忘记再.h⽂文件中添加⽅方法声明 

@end
