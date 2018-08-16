//
//  PrivateChatView.h
//  InKeLive
//
//  Created by 高婷婷 on 2018/8/13.
//  Copyright © 2018年 jh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PrivateChatView : UIView
@property (weak, nonatomic) IBOutlet UILabel *labNameAndID;
@property (weak, nonatomic) IBOutlet UITableView *HeadTableView;
@property (weak, nonatomic) IBOutlet UITableView *chatTableView;

@property (nonatomic, strong) NSArray *arrHead;
@property (nonatomic, strong) NSArray *arrChatMessage;

//弹出窗口
- (void)popShow;

-(void)hide ;
@end
