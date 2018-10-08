//
//  ChangeScore.h
//  InKeLive
//
//  Created by 高婷婷 on 2018/9/11.
//  Copyright © 2018年 jh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangeScore : UIView
@property (nonatomic, copy)void (^allChangeClick)();//全部兑换
@property (nonatomic, copy)void (^commendChangeClick)(int score);//确定兑换
@property(nonatomic, strong) UILabel *labNowGold;
@property(nonatomic, strong) UILabel *labNowScore;
//@property (nonatomic, assign) int nowScore;
//@property (nonatomic, assign) int nowGold;

- (void)popShow;
- (void)hide ;
- (void)updateUserMoney:(long long)nk NB:(long long)nb;
@end
