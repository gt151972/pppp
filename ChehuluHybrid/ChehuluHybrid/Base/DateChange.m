//
//  DateChange.m
//  ChehuluHybrid
//
//  Created by 高天的Mac on 2017/3/17.
//  Copyright © 2017年 GT mac. All rights reserved.
//

#import "DateChange.h"

@implementation DateChange

/**
 *  获取当前 年 月 日
 *
 *  @return <#return value description#>
 */
- (NSDictionary *)todayData{
    NSDate *now = [NSDate date];
    //    NSLog(@"now == %@",now);
    NSDictionary *dicToday;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY"];
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"MM"];
    NSDateFormatter *dateFormatter3 = [[NSDateFormatter alloc] init];
    [dateFormatter3 setDateFormat:@"dd"];
    NSString *year = [dateFormatter stringFromDate:now];
    NSString *month = [dateFormatter2 stringFromDate:now];
    NSString *day = [dateFormatter3 stringFromDate:now];
    dicToday = [NSDictionary dictionaryWithObjectsAndKeys:year, @"year", month, @"month", day, @"day", nil];
//    NSLog(@"dicToday == %@",dicToday);
    return dicToday;
}

/**
 *  星期
 *
 *  @return <#return value description#>
 */
- (NSInteger)getNowWeekday{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDate *now;
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags =NSYearCalendarUnit | NSMonthCalendarUnit |NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit |NSMinuteCalendarUnit | NSSecondCalendarUnit;
    now=[NSDate date];
    comps = [calendar components:unitFlags fromDate:now];
    //    NSLog(@"now == %@",now);
    //    NSLog(@"comps == %ld",(long)[comps weekday]);
    return [comps weekday];
}

/**
 *  日期换算
 *
 *  @param strDate <#strDate description#>
 *
 *  @return <#return value description#>
 */
- (NSDictionary *)dateChange: (NSString *)strDate{
    NSDictionary *dicDate;
    NSString *year = [strDate substringWithRange:NSMakeRange(0, 4)];
    NSString *month = [strDate substringWithRange:NSMakeRange(5, 2)];
    NSString *day = [strDate substringWithRange:NSMakeRange(8, 2)];
    dicDate = [NSDictionary dictionaryWithObjectsAndKeys:year, @"year", month, @"month", day, @"day", nil];
    return dicDate;
}

- (int)weekChange: (NSString *)strDay{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:strDay];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger unitFlags =NSYearCalendarUnit | NSMonthCalendarUnit |NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit |NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    comps = [calendar components:unitFlags fromDate:date];
    int week = [[NSString stringWithFormat:@"%ld",(long)[comps weekday]] intValue];
    //    NSLog(@"weekday = %d",week);
    return week;
}


@end
