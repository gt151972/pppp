//
//  BaseAlertSheet.h
//  PopTest
//  无顶部按钮
//  Created by 高天的Mac on 2017/3/16.
//  Copyright © 2017年 高天的Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BaseView.h"

@protocol BaseActionSheetDelegate <NSObject>

@required
- (void)didChoseIndex:(int)index name:(NSString*)name;

@end

@interface BaseAlertSheet : BaseView<UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray *checkBtnArray;
    NSInteger selectBtnIndex;
    UITableView *tableView;
    int selectIndexRow;
    NSMutableArray *dataArray;
    NSMutableArray *imageArray;
    NSString *alertName;
}
@property (nonatomic, strong) UIView *backGroundView;
@property (nonatomic, assign) id<BaseActionSheetDelegate>delegate;

/**
 *  初始化数据
 *
 *  @param array       文字数组
 *  @param arrayImage  图片数组(可为空)
 *  @param name        识别名
 *  @param selectIndex 选中行
 */
- (void)initWithArray:(NSArray *)array ArrayImage:(NSArray *)arrayImage name:(NSString *)name selectIndex:(int)selectIndex;

- (void)showInView:(UIView *)view;

@end
