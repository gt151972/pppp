#import "SecurityUtil.h"
#import "GTMBase64.h"
#import "NSData+NSData_AES.h"
#import "AESCrypt.h"


@implementation SecurityUtil

#pragma mark - base64
+ (NSString*)encodeBase64String:(NSString * )input {
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    data = [GTMBase64 encodeData:data];
    NSString *base64String = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    return base64String;
}

+ (NSString*)decodeBase64String:(NSString * )input {
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    data = [GTMBase64 decodeData:data];
    NSString *base64String = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    return base64String;
}

+ (NSString*)encodeBase64Data:(NSData *)data {
    data = [GTMBase64 encodeData:data];
    NSString *base64String = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    return base64String;
}

+ (NSString*)decodeBase64Data:(NSData *)data {
    data = [GTMBase64 decodeData:data];
    NSString *base64String = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    return base64String;
}

#pragma mark - AES加密
//将string转成带密码的data
+(NSString*)encryptAESData:(NSString*)string app_key:(NSString*)key
{
    //将nsstring转化为nsdata
    NSData *data = [@"User/getVerifyCode," dataUsingEncoding:NSUTF8StringEncoding];
    //使用密码对nsdata进行加密
    NSData *encryptedData = [data AES128EncryptWithKey:@"QoWGcVZjC2qCXuTLqua/bg=="];
    NSLog(@"加密后的字符串 :%@",[encryptedData base64Encoding]);

    NSLog(@"encrypt: %@", [AESCrypt encrypt:@"User/getVerifyCode," password:@"QoWGcVZjC2qCXuTLqua/bg=="]);
    NSLog(@"decrypt: %@", [AESCrypt decrypt:@"User/getVerifyCode," password:@"QoWGcVZjC2qCXuTLqua/bg=="]);
    
    
    [AESCrypt encryptText:string];
    
    NSLog(@"jiamia:%@",[AESCrypt encrypt:@"User/getVerifyCode," password:@"QoWGcVZjC2qCXuTLqua/bg=="]
          );
    //(NSString *)encrypt:(NSString *)message password:(NSString *)password;

    
    
    //[AESCrypt encrypt:@"User/getVerifyCode," password:@"QoWGcVZjC2qCXuTLqua/bg==];
    //+ (NSString *)encrypt:(NSString *)message password:(NSString *)password
    
    return [encryptedData base64Encoding];
}

#pragma mark - AES解密
//将带密码的data转成string
+(NSString*)decryptAESData:(NSData*)data  app_key:(NSString*)key
{
    //使用密码对data进行解密
    NSData *decryData = [data AES128DecryptWithKey:key];
    //将解了密码的nsdata转化为nsstring
    NSString *str = [[NSString alloc] initWithData:decryData encoding:NSUTF8StringEncoding];
    NSLog(@"解密后的字符串 :%@",str);
    return [str autorelease];
}

@end
