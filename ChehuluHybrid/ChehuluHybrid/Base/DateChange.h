//
//  DateChange.h
//  ChehuluHybrid
//
//  Created by 高天的Mac on 2017/3/17.
//  Copyright © 2017年 GT mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateChange : NSObject
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
 *  @param strDate 2016-11-12
 *
 *  @return <#return value description#>
 */
- (NSDictionary *)dateChange: (NSString *)strDate;

/**
 *  yyyy-MM-dd ->weekday
 *
 *  @param strDay <#strDay description#>
 *
 *  @return <#return value description#>
 */
- (int)weekChange: (NSString *)strDay;
@end
