//
//  BaseView.m
//  ChehuluHybrid
//
//  Created by 高婷婷 on 2017/3/20.
//  Copyright © 2017年 GT mac. All rights reserved.
//

#import "BaseView.h"

@implementation BaseView
/**
 *  颜色
 *
 *  @param UIColor <#UIColor description#>
 *
 *  @return <#return value description#>
 */
#define DEFAULT_VOID_COLOR [UIColor whiteColor]
- (UIColor *)colorWithHexString:(NSString *)stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([cString length] < 6)
        return DEFAULT_VOID_COLOR;
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return DEFAULT_VOID_COLOR;
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

/**
 *  通过URL从网上获取图片
 *
 *  @param strUrl
 */
- (UIImage *)getImageForUrl: (NSString *)strUrl{
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:strUrl]];
    UIImage *image = [UIImage imageWithData:data];
    return image;
}

/**
 *  图片存入沙盒
 *
 *  @param tempImage 存入图片
 *  @param imageName 图片名称
 */
- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName{
    //将图片保存到沙盒
    //保存文件到沙盒
    //获取沙盒中Documents目录路径
    NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSLog(@"%@",documents);
    NSData* imageData = UIImagePNGRepresentation(tempImage);
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    // Now we get the full path to the file
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    // and then we write it out
    [imageData writeToFile:fullPathToFile atomically:NO];

}

/**
 *  从沙盒获取图片
 *
 *  @param imageName 图片名称
 */
- (UIImage *)getImageWithName:(NSString *)imageName{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *imageFilePath = [path stringByAppendingPathComponent:imageName];
    UIImage *imgHead = [UIImage imageWithData:[NSData dataWithContentsOfFile:imageFilePath]];
    return imgHead;
}

/**
 *  接口获取失败吼弹出的alert
 *
 *  @param strTitle
 */
- (void)alert: (NSString *)strTitle{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}
@end
