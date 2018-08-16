//
//  SecondInfoAlertSheet.h
//  ChehuluHybrid
//
//  Created by 高天的Mac on 2017/3/12.
//  Copyright © 2017年 GT mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "IndexRequestDAL.h"

@protocol SecondInfoAlertSheetDelegate <NSObject>

@required
- (void)didChosePayDays:(NSString *)days;

@end


@interface SecondInfoAlertSheet : UIView<UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate,IndexRequestDelegate>
{
    NSMutableArray *checkBtnArray;
    NSInteger selectBtnIndex;
    UITableView *tableView;
    NSIndexPath *selectIndexPath;
    IndexRequestDAL *indexDal;
    NSMutableArray *dataArray;
}

@property (nonatomic, strong) UIView *backGroundView;
@property (nonatomic, assign) id<SecondInfoAlertSheetDelegate>delegate;

- (id)initWithData:(NSArray *)array;
- (void)showInView:(UIView *)view;

@end
