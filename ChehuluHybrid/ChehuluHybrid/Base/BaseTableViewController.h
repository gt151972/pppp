//
//  BaseTableViewController.h
//  ChehuluHybrid
//
//  Created by 高婷婷 on 2017/5/25.
//  Copyright © 2017年 GT mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IndexRequestDAL.h"
#import "CommendFile.h"
#import <STableViewController.h>

@interface BaseTableViewController : STableViewController<IndexRequestDelegate>{
    IndexRequestDAL *indexDAL;
}

+(instancetype)sharedManager;

/**
 *  白色导航栏
 *
 *  @param strTitle 导航栏标题
 */
- (void)navigationTypeWhite: (NSString *)strTitle;

/**
 *  接口获取失败吼弹出的alert
 *
 *  @param strTitle
 */
- (void)alert: (NSString *)strTitle;

/**
 *  颜色
 *
 *  @param stringToConvert 十六进制色
 *
 *  @return RGB
 */
- (UIColor *)colorWithHexString:(NSString *)stringToConvert;
@end
