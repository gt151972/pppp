//
//  BaseAlertSheet2.m
//  ChehuluHybrid
//
//  Created by 高婷婷 on 2017/3/31.
//  Copyright © 2017年 GT mac. All rights reserved.
//

#import "BaseAlertSheet2.h"
#import "CommendFile.h"


#define ACTIONSHEET_BACKGROUNDCOLOR  [UIColor whiteColor]
#define WINDOW_COLOR                 [UIColor colorWithRed:0 green:0 blue:0 alpha:0.50]
#define COLOR_5D5D5D                 [UIColor colorWithRed:0.36 green:0.36 blue:0.36 alpha:1.00]
#define COLOR_TEXT                 ([UIColor colorWithRed:56.0/255 green:170/255.0 blue:121/255.0alpha:1])
#define TextColor ([UIColor colorWithRed:123/255.0 green:123/255.0 blue:123/255.0 alpha:1])

#define ANIMATE_DURATION             0.25f

@implementation BaseAlertSheet2
- (id)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

#pragma mark - Public set

/**
 *  初始化数据
 *
 *  @param array       文字数组
 *  @param arrayImage  图片数组(可为空)
 *  @param name        识别名
 *  @param selectIndex 选中行()
 *  @param buttonTitle 按钮title
 */
- (void)initWithArray:(NSArray *)array ArrayImage:(NSArray *)arrayImage name:(NSString *)name selectIndex:(int)selectIndex buttonTitle:(NSString *)buttonTitle
{
    //        indexDal=[[IndexRequestDAL alloc]init];
    //        indexDal.delegate=self;
    //初始化背景视图，添加手势
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    self.backgroundColor = WINDOW_COLOR;
    self.userInteractionEnabled = YES;
    
    dataArray =[NSArray arrayWithArray:array];
    NSLog(@"dataArray == %@",dataArray);
    alertName = name;
    selectIndexRow = selectIndex;
    imageArray = [NSMutableArray arrayWithArray:arrayImage];
    strButtonTitle = buttonTitle;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCancel)];
    tapGesture.delegate = self;
    //[self addGestureRecognizer:tapGesture];
    [self initView:array];
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
    UIButton *btnBg = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, gtWIDTH, gtHEIGHT)];
    [btnBg setBackgroundColor:[UIColor clearColor]];
    [btnBg addTarget:self action:@selector(tappedCancel) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnBg];
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
            [self.backGroundView setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - (60*scheduleItems.count +40), [UIScreen mainScreen].bounds.size.width, 60*scheduleItems.count+40)];
        }else{
            [self.backGroundView setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 220, [UIScreen mainScreen].bounds.size.width, 220)];
        }
        
    } completion:^(BOOL finished) {
    }];
    
}

- (void)createButtons:(NSArray *)scheduleItems
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, gtWIDTH, 40)];
    view.backgroundColor = COLOR_MAIN_WHITE;
    [self.backGroundView addSubview:view];
    UIButton *btnItem = [[UIButton alloc] initWithFrame:CGRectMake(gtWIDTH*2/3, 0, gtWIDTH/3, 40)];
    [btnItem.titleLabel setTextAlignment:NSTextAlignmentRight];
    [btnItem.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [btnItem setTitle:strButtonTitle forState:UIControlStateNormal];
    [btnItem setTitleColor:COLOR_MAIN_GREEN forState:UIControlStateNormal];
    [btnItem setTag:201];
    [btnItem addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.backGroundView addSubview:btnItem];
    
    UIView *viewLine = [[UIView alloc] initWithFrame:CGRectMake(10, 38, gtWIDTH-20, 2)];
    viewLine.backgroundColor = COLOR_BG_GRAY2;
    [view addSubview:viewLine];
    _tableView = [[UITableView alloc] init];
    if (dataArray.count<3) {
        _tableView.frame = CGRectMake(0, 40, gtWIDTH, 60*dataArray.count);
    }else{
        _tableView.frame = CGRectMake(0, 40, gtWIDTH, 180);
    }
    _tableView.backgroundColor=[UIColor whiteColor];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.scrollEnabled=YES;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.backGroundView addSubview:_tableView];
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
    }
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType =  UITableViewCellAccessoryNone;
        if (imageArray.count != 0) {
            cell.imageView.image = [UIImage imageNamed:[imageArray objectAtIndex:indexPath.row]];
        }
        cell.textLabel.text = [dataArray objectAtIndex:indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        if (indexPath.row == selectIndexRow) {
            cell.textLabel.textColor = COLOR_MAIN_GREEN;
        }else{
            cell.textLabel.textColor = TextColor;
        }
        NSLog(@"cell.textLabel.text1 == %@ \n index == %ld",cell.textLabel.text,(long)indexPath.row
              );
    
    //        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(20, 0, gtWIDTH-20, 60)];
    //        [label setBackgroundColor:[UIColor clearColor]];
    //        if (indexPath.row == selectIndexRow) {
    //            label.textColor = [UIColor redColor];
    //        }else{
    //            [label setTextColor:TextColor];
    //        }
    //        label.font=[UIFont systemFontOfSize:14.0f];
    //        label.tag=1002;
    //        [cell addSubview:label];
    //    }
    //    UILabel *label=(UILabel *)[cell viewWithTag:1002];
    //    label.text=[dataArray objectAtIndex:indexPath.row];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    selectIndexRow = (int)indexPath.row;
    NSLog(@"index == %ld",(long)indexPath.row);
    //    [_delegate didChoseIndex:(int)indexPath.row name:alertName];
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
    if (self.delegate && [self.delegate respondsToSelector:@selector(alertSheet2:name:)])
    {
        [self.delegate alertSheet2:selectIndexRow name:alertName];
    }
    
    [self tappedCancel];
}

- (void)btnClicked: (UIButton *)button{
    if (button.tag == 201) {
        [self.delegate alertSheet2:-1 name:alertName];
    }
}

@end
