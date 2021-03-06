//
//  MessageCell.h
//  MessageLivingDemo
//
//  Created by jianqiangzhang on 16/5/12.
//  Copyright © 2016年 jianqiangzhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageModel.h"
#import "TYAttributedLabel.h"

@interface MessageCell : UITableViewCell

@property (nonatomic, assign)BOOL isShowLevel;
@property (nonatomic, strong)UIView *viewLevel;

@property (nonatomic, weak, readonly) TYAttributedLabel *label;
@property (nonatomic, weak, readonly) UIView *viewBg;

@property (nonatomic,strong)MessageModel *model;
- (void)addLable:(MessageModel *)model;
- (CGFloat)height: (MessageModel *)model;
@end
