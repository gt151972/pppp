//
//  PersonViewController.h
//  InKeLive
//
//  Created by 1 on 2016/12/12.
//  Copyright © 2016年 jh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonHeadView.h"
#import "PersonHeadView2.h"

@interface PersonViewController : UIViewController

@property (nonatomic,strong)UITableView *personTableView;

//@property (nonatomic,strong)PersonHeadView *personHeadView;
@property (nonatomic,strong)PersonHeadView2 *personHeadView2;

@property (nonatomic,strong)NSArray *titleArr; //几个选项标题?

@end
