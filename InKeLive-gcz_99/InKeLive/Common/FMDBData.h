//
//  FMDBData.h
//  InKeLive
//
//  Created by 高天的Mac on 2018/8/18.
//  Copyright © 2018年 jh. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GTGiftListModel;
@interface FMDBData : NSObject
@property (nonatomic, strong)GTGiftListModel *giftList;

+ (instancetype)sharedDataBase;

#pragma 礼物列表
- (void)addGiftList:(GTGiftListModel *)objects;
- (void)deleteGiftList: (GTGiftListModel *)objects;
- (void)updateGiftList: (GTGiftListModel *)objects;
- (NSMutableArray *)getAllGift;

@end
