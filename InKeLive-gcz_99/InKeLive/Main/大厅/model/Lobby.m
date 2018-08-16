//
//  Lobby.m
//  InKeLive
//
//  Created by 高婷婷 on 2018/8/3.
//  Copyright © 2018年 jh. All rights reserved.
//

#import "Lobby.h"

@implementation Lobby
/**
 pageView的title
 
 @return <#return value description#>
 */
+ (NSArray *)arrayTitle{
    return @[@"推荐",
             @"手机",
             @"房间",
             @"客服"];
}


/**
 pageView的目标界面
 
 @return <#return value description#>
 */
+ (NSArray *)arrayPageView{
    return @[@"RecommendViewController",
             @"MobileViewController",
             @"RoomViewController",
             @"ServiceViewController"];
}
@end
