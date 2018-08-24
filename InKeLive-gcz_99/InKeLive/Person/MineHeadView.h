//
//  MineHeadView.h
//  InKeLive
//
//  Created by 高婷婷 on 2018/8/15.
//  Copyright © 2018年 jh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineHeadView : UIView
@property (nonatomic, strong)NSArray *arrayInfo;
@property (weak, nonatomic) IBOutlet UIImageView *imgHead;
@property (weak, nonatomic) IBOutlet UILabel *labName;
@property (weak, nonatomic) IBOutlet UILabel *labUserId;
@property (weak, nonatomic) IBOutlet UILabel *labMoney;
@property (weak, nonatomic) IBOutlet UILabel *labMoneyUp;
@property (weak, nonatomic) IBOutlet UIButton *btnRecharge;
@end
