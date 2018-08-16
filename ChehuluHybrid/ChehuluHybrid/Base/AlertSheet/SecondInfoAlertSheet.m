//
//  SecondInfoAlertSheet.m
//  ChehuluHybrid
//
//  Created by 高天的Mac on 2017/3/12.
//  Copyright © 2017年 GT mac. All rights reserved.
//

#import "SecondInfoAlertSheet.h"
#import "CommendFile.h"
#import "MBProgressHUD.h"
#import "Toast+UIView.h"


#define ACTIONSHEET_BACKGROUNDCOLOR  [UIColor whiteColor]
#define WINDOW_COLOR                 [UIColor colorWithRed:0 green:0 blue:0 alpha:0.50]
#define COLOR_5D5D5D                 [UIColor colorWithRed:0.36 green:0.36 blue:0.36 alpha:1.00]
#define COLOR_TEXT                 ([UIColor colorWithRed:56.0/255 green:170/255.0 blue:121/255.0alpha:1])
#define TextColor ([UIColor colorWithRed:123/255.0 green:123/255.0 blue:123/255.0 alpha:1])

#define ANIMATE_DURATION             0.25f

@implementation SecondInfoAlertSheet

#pragma mark - Public set

- (id)initWithData:(NSArray *)array
{
    self = [super init];
    if (self) {
        indexDal=[[IndexRequestDAL alloc]init];
        indexDal.delegate=self;
        //初始化背景视图，添加手势
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        self.backgroundColor = WINDOW_COLOR;
        self.userInteractionEnabled = YES;
        
        dataArray =[NSMutableArray arrayWithArray:array];
        
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCancel)];
        tapGesture.delegate = self;
        //[self addGestureRecognizer:tapGesture];
        [self initView:array];
    }
    
    return self;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (touch.view == self.backGroundView)
    {
        return NO;
    }
    return YES;
}

- (void)showInView:(UIView *)view
{
    [[UIApplication sharedApplication].delegate.window addSubview:self];
}

- (void)initView:(NSArray *)scheduleItems
{
    self.backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 0)];
    self.backGroundView.backgroundColor = ACTIONSHEET_BACKGROUNDCOLOR;
    [self.backGroundView.layer setShadowColor:[UIColor colorWithRed:0.00 green:0.00 blue:0.00 alpha:1.00].CGColor]; //000000
    [self.backGroundView.layer setShadowOffset:CGSizeMake(0, -0.05)];
    [self.backGroundView.layer setShadowOpacity:0.1];
    [self.backGroundView.layer setShadowPath:[UIBezierPath bezierPathWithRect:self.backGroundView.layer.bounds].CGPath];
    [self addSubview:self.backGroundView];
    
    [self createButtons:scheduleItems];
    
    [UIView animateWithDuration:ANIMATE_DURATION animations:^{
        if (scheduleItems.count < 3) {
            [self.backGroundView setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - (60*scheduleItems.count), [UIScreen mainScreen].bounds.size.width, 60*scheduleItems.count)];
        }else{
            [self.backGroundView setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 180, [UIScreen mainScreen].bounds.size.width, 180)];
        }
        
    } completion:^(BOOL finished) {
    }];
}

- (void)createButtons:(NSArray *)scheduleItems
{
    
    tableView = [[UITableView alloc] init];
    if (dataArray.count<3) {
        tableView.frame = CGRectMake(0, 0, gtWIDTH, 60*dataArray.count);
    }else{
        tableView.frame = CGRectMake(0, 0, gtWIDTH, 180);
    }
    tableView.backgroundColor=[UIColor whiteColor];
    //    tableView.layer.borderColor=[UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1.0f].CGColor;
    //    tableView.layer.borderWidth=0.7f;
    tableView.delegate=self;
    tableView.dataSource=self;
    tableView.scrollEnabled=YES;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.backGroundView addSubview:tableView];
}


#pragma mark - UITableView
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return [dataArray count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0f;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"";
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"firstCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType =  UITableViewCellAccessoryNone;
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(20, 0, gtWIDTH-20, 60)];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextColor:TextColor];
        label.font=[UIFont systemFontOfSize:14.0f];
        label.tag=1002;
        [cell addSubview:label];
    }
    UILabel *label=(UILabel *)[cell viewWithTag:1002];
    label.text=[dataArray objectAtIndex:indexPath.row];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    selectIndexPath=indexPath;
    [self tappedChoose];
}

#pragma mark - actions

- (void)tappedCancel
{
    
    [UIView animateWithDuration:ANIMATE_DURATION animations:^{
        [self.backGroundView setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 0)];
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

- (void)tappedChoose
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didChosePayDays:)])
    {
        [self.delegate didChosePayDays:[dataArray objectAtIndex:selectIndexPath.row]];
    }
    
    [self tappedCancel];
}

@end
