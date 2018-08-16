//
//  ClientGiftModel.h
//  InKeLive
//
//  Created by gu  on 17/8/23.
//  Copyright © 2017年 jh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClientGiftModel : NSObject

//@property(nonatomic, assign)int giftId;//礼物id
//@property(nonatomic, copy) NSString* giftName;//礼物名称
//@property(nonatomic, assign)int effectType;//分类
//@property(nonatomic, assign)int coins;//礼物价格
//@property(nonatomic, assign)int experience;//(礼物说明)
//@property(nonatomic, assign)int fullscreen;
//@property(nonatomic, copy)NSString* icon;//礼物图片
//@property(nonatomic, assign)int isLan;
//@property(nonatomic, assign)int isSelect;
//@property(nonatomic, assign)int isSupport;

@property(nonatomic, assign)int ctype;//类型
@property(nonatomic, assign)int flag;//
@property(nonatomic, assign)int giftId;//礼物id(原接口为id)
@property(nonatomic, copy)NSString *name;//礼物名
@property(nonatomic, copy)NSString *note;//说明
@property(nonatomic, copy)NSString *pic_original;//大图
@property(nonatomic, copy)NSString *pic_s;//动图效果
@property(nonatomic, copy)NSString *pic_thumb;//小图
@property(nonatomic, assign)int price;//价格
@property(nonatomic, copy)NSString *sname;//分组名字;
@property(nonatomic, assign)int sort;//礼物排序
@property(nonatomic, assign)int ssort;//分组排序(共6个)
@property(nonatomic, assign)int stype;//分组类型
@end
