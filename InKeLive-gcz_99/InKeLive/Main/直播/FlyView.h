//
//  FlyView.h
//  InKeLive
//
//  Created by 高婷婷 on 2018/9/4.
//  Copyright © 2018年 jh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JhtMarquee/JhtHorizontalMarquee.h>
@interface FlyView : UIView
@property(nonatomic, copy)NSString *strSrcName;
@property(nonatomic, copy)NSString *strToName;
@property(nonatomic, assign)int giftNum;
@property(nonatomic, copy)NSString *strGiftName;
@property(nonatomic, strong)JhtHorizontalMarquee *horizontalMarquee;
@property(nonatomic, strong)UILabel *labInfo;
-(void)paomadeng;
-(void)hide;
@end
