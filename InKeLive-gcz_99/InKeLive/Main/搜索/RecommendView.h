//
//  RecommendView.h
//  InKeLive
//
//  Created by 1 on 2017/1/5.
//  Copyright © 2017年 jh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecommendView : UIView

//好声音、小清新、搞笑达人
@property (weak, nonatomic) IBOutlet UILabel *recommedTitle;

//更多
@property (weak, nonatomic) IBOutlet UIButton *recommendButton;

//点击回调函数
@property (nonatomic,copy)void (^recommdMoreClick)(NSString *str);

@end
