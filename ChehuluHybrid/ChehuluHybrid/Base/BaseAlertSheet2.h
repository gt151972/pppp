//
//  BaseAlertSheet2.h
//  ChehuluHybrid
//  有顶部按钮
//  Created by 高婷婷 on 2017/3/31.
//  Copyright © 2017年 GT mac. All rights reserved.
//

#import "BaseView.h"
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@protocol BaseActionSheet2Delegate <NSObject>

@required
- (void)alertSheet2:(int)index name:(NSString*)name;

@end

@interface BaseAlertSheet2 : BaseView<UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray *checkBtnArray;
    NSInteger selectBtnIndex;
    UITableView *tableView;
    int selectIndexRow;
    NSArray *dataArray;
    NSMutableArray *imageArray;
    NSString *alertName;
    NSString *strButtonTitle;
}
@property (nonatomic, strong) UIView *backGroundView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) id<BaseActionSheet2Delegate>delegate;



/**
 *  初始化数据
 *
 *  @param array       文字数组
 *  @param arrayImage  图片数组(可为空)
 *  @param name        识别名
 *  @param selectIndex 选中行()
 @param buttonTitle 按钮title
 */
- (void)initWithArray:(NSArray *)array ArrayImage:(NSArray *)arrayImage name:(NSString *)name selectIndex:(int)selectIndex buttonTitle:(NSString *)buttonTitle;
- (void)showInView:(UIView *)view;
@end
