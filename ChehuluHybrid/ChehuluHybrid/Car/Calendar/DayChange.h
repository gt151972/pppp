//
//  DayChange.h
//  ChehuluHybrid
//
//  Created by 高婷婷 on 2017/1/12.
//  Copyright © 2017年 GT mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DayChange : NSObject
/**
 *  获取当前 年 月 日
 *
 *  @return <#return value description#>
 */
- (NSDictionary *)todayData;

/**
 *  星期
 *
 *  @return <#return value description#>
 */
- (NSInteger)getNowWeekday;

/**
 *  日期换算
 *
 *  @param strDate <#strDate description#>
 *
 *  @return <#return value description#>
 */
- (NSDictionary *)dateChange: (NSString *)strDate;


- (int)weekChange: (NSString *)strDay;
@end
