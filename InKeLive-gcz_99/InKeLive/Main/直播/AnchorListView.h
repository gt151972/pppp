//
//  AnchorListView.h
//  InKeLive
//
//  Created by 高婷婷 on 2018/9/5.
//  Copyright © 2018年 jh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClientUserModel.h"

@interface AnchorListView : UIView
@property (nonatomic, strong) UIButton *btnRoomName;//房间名按钮
@property (nonatomic, strong) UILabel *labRoomId;
@property (nonatomic, strong) NSArray *arrayAnchor;
@property (nonatomic, strong) NSDictionary *dicAnchor;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ClientUserModel *model;
@end
