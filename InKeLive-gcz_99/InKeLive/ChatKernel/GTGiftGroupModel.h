//
//  GTGiftGroupModel.h
//  InKeLive
//
//  Created by 高婷婷 on 2018/8/16.
//  Copyright © 2018年 jh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GTGiftGroupModel : NSObject

@property (nonatomic, assign) int giftId;
@property (nonatomic, assign) int order;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) int display;
@property (nonatomic, copy) NSArray *list;
@end
