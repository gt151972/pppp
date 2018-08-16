//
//  BaseView.h
//  ChehuluHybrid
//
//  Created by 高婷婷 on 2017/3/20.
//  Copyright © 2017年 GT mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry.h>
#import "CommendFile.h"
#import "LableColor.h"
#import "BaseButton.h"
#import <UIImageView+WebCache.h>

@interface BaseView : UIView
- (UIColor *)colorWithHexString:(NSString *)stringToConvert;

/**
 *  通过URL从网上获取图片
 *
 *  @param strUrl
 */
- (UIImage *)getImageForUrl: (NSString *)strUrl;

/**
 *  图片存入沙盒
 *
 *  @param tempImage 存入图片
 *  @param imageName 图片名称
 */
- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName;

/**
 *  从沙盒获取图片
 *
 *  @param imageName 图片名称
 */
- (UIImage *)getImageWithName:(NSString *)imageName;

/**
 *  接口获取失败吼弹出的alert
 *
 *  @param strTitle
 */
- (void)alert: (NSString *)strTitle;
@end
