//
//  Calender.m
//  ChehuluHybrid
//
//  Created by 高天的Mac on 2017/3/17.
//  Copyright © 2017年 GT mac. All rights reserved.
//

#import "Calender.h"
#import "CommendFile.h"
#import <Masonry.h>


#define ACTIONSHEET_BACKGROUNDCOLOR  [UIColor whiteColor]
#define WINDOW_COLOR                 [UIColor colorWithRed:0 green:0 blue:0 alpha:0.50]
#define ANIMATE_DURATION             0.25f
#define TEXT_GRAY_DEEP   [UIColor colorWithRed:45/255.0 green:47/255.0 blue:59/255.0 alpha:1.0]
#define MAIN_GREEN_DEEP   [UIColor colorWithRed:14/255.0 green:47/255.0 blue:59/255.0 alpha:1.0]

#define NAMEDATE @"chooseDate"
#define NAMEHISTORY @"allHistory"
@implementation Calender
- (id)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

- (void)initWithToday:(NSDictionary *)today{
    indexDal = [[IndexRequestDAL alloc] init];
    indexDal.delegate = self;
    dateChange = [[DateChange alloc] init];
    NSLog(@"today == %@",[dateChange todayData]);
    theYear = [[[dateChange todayData] objectForKey:@"year"] intValue];
    theMoon = [[[dateChange todayData] objectForKey:@"month"] intValue];
    dicToday = [NSDictionary dictionaryWithDictionary:today];
    [indexDal getMonthLogWithCarNo:[gtCarInfo objectForKey:@"car_no"] month:[NSString stringWithFormat:@"%d-%d-01",theYear, theMoon] isFake:GTisFake];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCancel)];
    tapGesture.delegate = self;
    [self initDate];
    [self initView];
}

- (void)initDate{
    dateChange = [[DateChange alloc] init];
    aYear = 0;
    aMonth = 0;
    aDay = 0;
    mon = [[[dateChange todayData] objectForKey:@"month"] intValue];
    dicCarStatus = [[NSDictionary alloc] init];
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


- (int)firstFrame: (NSString *)strDay{
    NSLog(@"strDay == %@",strDay);
    dateChange = [[DateChange alloc] init];
    NSLog(@"dic == %@",[dateChange dateChange:strDay]);
    int year = [[[dateChange dateChange:strDay] objectForKey:@"year"] intValue];
    int moon = [[[dateChange dateChange:strDay] objectForKey:@"month"] intValue];
    while (moon > 12) {
        moon = moon % 12;
        year ++;
    }
    NSString *strDayOne = [NSString stringWithFormat:@"%d-%d-01", year, moon];
    theMoon = moon;
    theYear = year;
    NSLog(@"moon == %d",moon);
    firstFrame = [dateChange weekChange:strDayOne];
    
    return firstFrame;
}

-(void)initView{
    self.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64);
    self.backgroundColor = WINDOW_COLOR;
    self.userInteractionEnabled = YES;
    UIButton *btnBg = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, gtWIDTH, gtHEIGHT-64)];
    [btnBg setBackgroundColor:[UIColor clearColor]];
    [btnBg addTarget:self action:@selector(tappedCancel) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnBg];
    self.backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0)];
    self.backGroundView.backgroundColor = ACTIONSHEET_BACKGROUNDCOLOR;
    [self.backGroundView.layer setShadowColor:[UIColor colorWithRed:0.00 green:0.00 blue:0.00 alpha:1.00].CGColor]; //000000
    [self.backGroundView.layer setShadowOffset:CGSizeMake(0, -0.05)];
    [self.backGroundView.layer setShadowOpacity:0.1];
    [self.backGroundView.layer setShadowPath:[UIBezierPath bezierPathWithRect:self.backGroundView.layer.bounds].CGPath];
    [self addSubview:self.backGroundView];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, gtWIDTH, 442) style:UITableViewStylePlain];
    _tableView.backgroundColor=[UIColor whiteColor];
    //    tableView.layer.borderColor=[UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1.0f].CGColor;
    //    tableView.layer.borderWidth=0.7f;
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.scrollEnabled=NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.backGroundView addSubview:_tableView];
    [UIView animateWithDuration:ANIMATE_DURATION animations:^{
//        if (scheduleItems.count < 3) {
//            [self.backGroundView setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - (60*scheduleItems.count), [UIScreen mainScreen].bounds.size.width, 60*scheduleItems.count)];
//        }else{
//            [self.backGroundView setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 180, [UIScreen mainScreen].bounds.size.width, 180)];
//        }
        [self.backGroundView setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 442)];
        
    } completion:^(BOOL finished) {
    }];

}

- (void)addCellView: (int)Tag{
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 0;//间距
    flowLayout.minimumLineSpacing = 1;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, gtWIDTH , gtHEIGHT-143) collectionViewLayout:flowLayout];
    if (Tag == 401) {
        //星期
        self.collectionView.frame = CGRectMake(0, 0, gtWIDTH, 40);
        [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"gtWeekCollectionViewCell"];
    }else{
        self.collectionView.frame = CGRectMake(0, 0, gtWIDTH, 293);
        [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"gtMoonCollectionViewCell"];
    }
//    self.automaticallyAdjustsScrollViewInsets = false;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.scrollEnabled = NO;
    self.collectionView.tag = Tag;
    [self.collectionView setBackgroundColor:[UIColor whiteColor]];
    [cell.contentView addSubview:self.collectionView];
    //右划
    UISwipeGestureRecognizer *swipeGesture=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeGesture:)];
     [cell.contentView addGestureRecognizer:swipeGesture];
     //左划
     UISwipeGestureRecognizer *swipeLeftGesture=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeGesture:)];
     swipeGesture.direction=UISwipeGestureRecognizerDirectionLeft;//不设置黑夜是右
   [cell.contentView addGestureRecognizer:swipeLeftGesture];
}
#pragma mark - UITableView
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 40;
    }else if (indexPath.section == 1){
        return 40;
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            return 264;
        }else{
            return 29;
        }
    }else{
        return 60;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    if (sectionIndex == 2) {
        return 2;
    }else{
        return 1;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 3;
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
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType =  UITableViewCellAccessoryNone;

    }
    if (indexPath.section == 0) {
        //年月
        UILabel *labMouth = [[UILabel alloc] init];
       labMouth.text = [NSString stringWithFormat:@"%d年%d月",theYear,theMoon];
        labMouth.textAlignment = NSTextAlignmentCenter;
        labMouth.textColor = TEXT_GRAY_DEEP;
        labMouth.tag = 199;
        labMouth.font = [UIFont systemFontOfSize:16];
        [cell.contentView addSubview:labMouth];
        [labMouth mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(cell.contentView);
            make.size.mas_equalTo(CGSizeMake(gtWIDTH, 16));
        }];
        
        UIImage *imgClose = [UIImage imageNamed:@"btnClose"];
        UIButton *btnClose = [[UIButton alloc] init];
        [btnClose setImage:imgClose forState:UIControlStateNormal];
        [btnClose setTag:201];
        [btnClose addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btnClose];
        [btnClose mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(imgClose.size);
            make.centerY.equalTo(cell.contentView);
            make.right.mas_equalTo(-17);
        }];
    }else if (indexPath.section == 1){
        //星期
        [self addCellView:401];
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            //日历
            [self addCellView:402];
        }else{
            //pageController
        }
    }else{
        //历史总览
        UIButton *btnHistory = [[UIButton alloc] init];
        [btnHistory setImage:[UIImage imageNamed:@"historyAll"] forState:UIControlStateNormal];
        [btnHistory setTitle:@"历史总览" forState:UIControlStateNormal];
        [btnHistory setTitleColor:TEXT_GRAY_DEEP forState:UIControlStateNormal];
        [btnHistory setTag:202];
        [btnHistory addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btnHistory];
        [btnHistory mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.and.width.equalTo(cell.contentView);
            make.height.mas_equalTo(22);
        }];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    selectIndexRow = (int)indexPath.row;
    NSLog(@"index == %ld",(long)indexPath.row);

    [self tappedChoose];
}

#pragma mark -- UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView.tag == 401) {
        return 7;
    }else{
        return 42;
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell2;
    if (collectionView.tag == 401) {
        cell2 = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"gtWeekCollectionViewCell" forIndexPath:indexPath];
        NSArray *arrayDay = [NSArray arrayWithObjects:@"日",@"一", @"二", @"三", @"四", @"五", @"六", nil];
        
        UILabel *labDay = [[UILabel alloc] init];
        labDay.text = [arrayDay objectAtIndex:indexPath.row];
        if ([dateChange getNowWeekday] == indexPath.row) {
            labDay.textColor = MAIN_GREEN_DEEP;
        }else{
            labDay.textColor = TEXT_GRAY_DEEP;
        }
        labDay.textAlignment = NSTextAlignmentCenter;
        labDay.font = [UIFont systemFontOfSize:14];
        [cell2.contentView addSubview:labDay];
        [labDay mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(cell2.contentView);
            make.size.mas_equalTo(CGSizeMake(14, 14));
        }];
    }else{
        cell2 = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"gtMoonCollectionViewCell" forIndexPath:indexPath];
        NSArray *arrBigMonth = @[@"1",@"3",@"5",@"7",@"8",@"10",@"12"];
        NSArray *arrSmallMonth = @[@"4",@"6",@"9",@"11"];
        
        dateChange = [[DateChange alloc] init];
        NSLog(@"today == %@",[dateChange todayData]);
//        theYear = [[[dateChange todayData] objectForKey:@"year"] intValue];
//        int theMonth = [[[dateChange todayData] objectForKey:@"month"] intValue];
        int dayNO;
        //非大月
        if ([arrBigMonth indexOfObject:[NSString stringWithFormat:@"%d",theMoon]] == NSNotFound) {
            dayNO = 30;
            if ([arrSmallMonth indexOfObject:[NSString stringWithFormat:@"%d",theMoon]] == NSNotFound) {
                //2月
                if (theYear%400 == 0) {
                    dayNO = 29;
                }else if (theYear%100 != 0 && theYear%4 == 0){
                    dayNO = 29;
                }else{
                    dayNO = 28;
                }
            }
        }else{
            //大月
            dayNO = 31;
        }
        
        int day = [[NSString stringWithFormat:@"%ld",(long)indexPath.row] intValue];
        NSString *strMonth;
        if (theMoon<10) {
            strMonth = [NSString stringWithFormat:@"0%d",theMoon];
        }else{
            strMonth = [NSString stringWithFormat:@"%d",theMoon];
        }
//        int firstFrame =
        [self firstFrame:[NSString stringWithFormat:@"%d-%@-01",theYear,strMonth]];
//        NSLog(@"firstFrame == %d",firstFrame);
//        NSLog(@"dayNO == %d",dayNO);
        int number = day-firstFrame+2;
        if (indexPath.row >= firstFrame-1 &&  number-1 < dayNO) {
            int todayYear = [[[dateChange todayData] objectForKey:@"year"] intValue];
            int todayMonth = [[[dateChange todayData] objectForKey:@"month"] intValue];
            int todayDay = [[[dateChange todayData] objectForKey:@"day"] intValue];
            if (theYear == todayYear && theMoon == todayMonth && todayDay == (day - firstFrame +2)) {//今天
                viewPoint = [[UIView alloc] init];
                if (aYear != 0) {
                    viewPoint.backgroundColor = COLOR_BG_GRAY2;
                }else{
                    viewPoint.backgroundColor = COLOR_MAIN_GREEN;
                }
                viewPoint.layer.masksToBounds = YES;
                viewPoint.layer.cornerRadius = 20;
                viewPoint.tag = indexPath.row + 1000;
                [cell2.contentView addSubview:viewPoint];
                [viewPoint mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(40, 40));
                    make.center.equalTo(cell2.contentView);
                }];
                
                labDay = [[UILabel alloc] init];
                labDay.text = [NSString stringWithFormat:@"%d",day-firstFrame+2];
                labDay.textColor = [UIColor whiteColor];
                labDay.textAlignment = NSTextAlignmentCenter;
                labDay.font = [UIFont systemFontOfSize:16];
                labDay.tag = indexPath.row + 100;
                [cell2.contentView addSubview:labDay];
                [labDay mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.size.and.top.and.left.equalTo(cell2.contentView);
                }];
                
            }else{
                viewPoint = [[UIView alloc] init];
                viewPoint.backgroundColor = [UIColor clearColor];
                viewPoint.layer.masksToBounds = YES;
                viewPoint.layer.cornerRadius = 20;
                viewPoint.tag = indexPath.row + 1000;
                [cell2.contentView addSubview:viewPoint];
                [viewPoint mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(40, 40));
                    make.center.equalTo(cell2.contentView);
                }];
                //日期
                labDay = [[UILabel alloc] init];
                labDay.text = [NSString stringWithFormat:@"%d",day-firstFrame+2];
                labDay.textColor = TEXT_GRAY_DEEP;
                labDay.textAlignment = NSTextAlignmentCenter;
                labDay.font = [UIFont systemFontOfSize:16];
                labDay.tag = indexPath.row + 100;
                [cell2.contentView addSubview:labDay];
                [labDay mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.size.and.top.and.left.equalTo(cell2.contentView);
                }];
                if (theYear == aYear && theMoon == aMonth && aDay == day-firstFrame+2) {
                    viewPoint.backgroundColor = COLOR_MAIN_GREEN;
                    labDay.textColor = [UIColor whiteColor];
                }
//                NSLog(@"today == %d",todayDay);
//                NSLog(@"day == %@",[dicCarStatus allKeys]);
                if ([[dicCarStatus objectForKey:[NSString stringWithFormat:@"%d",day-firstFrame+2]] intValue] == 2) {
                    labDay.textColor = [UIColor blackColor];
                }else if ([[dicCarStatus objectForKey:[NSString stringWithFormat:@"%d",day-firstFrame+2]] intValue] == 1){
                    labDay.textColor = [UIColor redColor];
                }else{
                    labDay.textColor = COLOR_TEXT_GARY;
                }

            }
//            NSLog(@"%@ == %@",indexPath.row, cell2.text)
        }

    }
    return cell2;
}

#pragma mark -- UICollectionDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView.tag == 401) {
        return CGSizeMake(gtWIDTH/7, 35);
    }else{
        return CGSizeMake(gtWIDTH/7, 44);
    }
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark -- UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    if (collectionView.tag == 401) {
        //header
    }else{
//        UIView *viewPoint1 = (UIView *)[cell viewWithTag:indexPath.row + 1000];
//        viewPoint1.backgroundColor = COLOR_MAIN_GREEN;
//        UILabel *labDay1 = (UILabel *)[cell viewWithTag:indexPath.row + 100];
//        labDay1.textColor = [UIColor whiteColor];
        aYear = theYear;
        aMonth = theMoon;
        aDay = (int)indexPath.row-firstFrame+2;
        NSString *strDate = [NSString stringWithFormat:@"%d-%d-%ld",theYear, theMoon, (long)indexPath.row-firstFrame+2];
        NSLog(@"strDate == %@",strDate);
        if ([[dicCarStatus objectForKey:[NSString stringWithFormat:@"%d",aDay]] intValue] == 2) {
            [_delegate calenderChooseDate:strDate name:NAMEDATE];
            [self tappedChoose];
        }else if ([[dicCarStatus objectForKey:[NSString stringWithFormat:@"%d",aDay]] intValue] == 1) {
            [_delegate calenderChooseDate:strDate name:NAMEDATE];
            [self tappedChoose];
        }
    }
}

#pragma mark - actions

- (void)tappedCancel
{
    
    [UIView animateWithDuration:ANIMATE_DURATION animations:^{
        [self.backGroundView setFrame:CGRectMake(0, 64, gtWIDTH*7/8, 0)];
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}
                                                                                   

- (void)tappedChoose
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(calenderChooseDate:name:)])
    {
//        [self.delegate didChoseIndex:selectIndexRow name:alertName];
    }
    
    [self tappedCancel];
}

-(IBAction)handleSwipeGesture:(UIGestureRecognizer*)sender{
      //划动的方向
      UISwipeGestureRecognizerDirection direction=[(UISwipeGestureRecognizer*) sender direction];
      //判断是上下左右
      switch (direction) {
          case UISwipeGestureRecognizerDirectionUp:
              break;
          case UISwipeGestureRecognizerDirectionDown:{
              NSLog(@"down");
              [self tappedCancel];
          }
              break;
          case UISwipeGestureRecognizerDirectionLeft:{
              NSLog(@"left");
              if (theMoon>=12) {
                  theMoon = 1;
                  theYear ++;
              }else{
                  theMoon ++;
              }
              [indexDal getMonthLogWithCarNo:[gtCarInfo objectForKey:@"car_no"] month:[NSString stringWithFormat:@"%d-%d-01",theYear, theMoon] isFake:GTisFake];
          }
              break;
          case UISwipeGestureRecognizerDirectionRight:{
              NSLog(@"right");
              if (theMoon<=1) {
                  theMoon = 12;
                  theYear --;
              }else{
                  theMoon --;
              }
               [indexDal getMonthLogWithCarNo:[gtCarInfo objectForKey:@"car_no"] month:[NSString stringWithFormat:@"%d-%d-01",theYear, theMoon] isFake:GTisFake];
              
          }
              break;
          default:
              break;
      }
//    NSLog(@"theMoon == %d",theMoon);
//    NSLog(@"theYear == %d",theYear);
}

- (void)btnClicked: (UIButton*)button{
    if (button.tag == 201) {
        //close
    }else if (button.tag == 202){
        //历史总览
        [_delegate calenderChooseDate:@"" name:NAMEHISTORY];
    }
    [self tappedCancel];
}


- (void)InfoCallBackDic:(NSMutableDictionary *)dic :(NSString *)cmd{
//    NSLog(@"dic == %@, cmd == %@",dic, cmd);
    if ([cmd isEqualToString:@"CarMonthLog"]) {
        NSMutableDictionary *dicData = [[NSMutableDictionary alloc] init];
        if ([[dic objectForKey:@"status"] intValue] == 1) {
//            NSMutableArray *arrayStatus = [[NSMutableArray alloc] init];
            for (int index = 0; index < [[dic objectForKey:@"info"] count]; index ++ ) {
//                [arrayStatus addObject:[[[dic objectForKey:@"info"] objectAtIndex:index] objectForKey:@"car_status"]];
                NSString *strKey = [NSString stringWithFormat:@"%@", [[[dic objectForKey:@"info"] objectAtIndex:index] objectForKey:@"pdate"]];
                strKey = [strKey substringFromIndex:8];
                int key = [strKey intValue];
                int value = [[[[dic objectForKey:@"info"] objectAtIndex:index] objectForKey:@"car_status"] intValue] +1;
                [dicData setObject:[NSString stringWithFormat:@"%d",value] forKey:[NSString stringWithFormat:@"%d",key]];
            }
            dicCarStatus = [NSDictionary dictionaryWithDictionary:dicData];

            if ([[dic objectForKey:@"info"] count] != 0) {
                NSIndexPath *indexPathA = [NSIndexPath indexPathForRow:0 inSection:2]; //刷新第0段第2行
                
                UILabel *lab = (UILabel *)[self viewWithTag:199];
                lab.text = [NSString stringWithFormat:@"%d年%d月",theYear,theMoon];
                //        NSLog(@"lab == %@",lab.text);
                if ((theMoon > mon &&(theMoon != 12 && mon != 1)) || (theMoon == 1 && mon == 12)) {
                    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPathA ,nil] withRowAnimation:UITableViewRowAnimationLeft];
                }else if ((theMoon < mon && (theMoon != 12 && mon != 1)) || (theMoon == 12 && mon == 1)){
                    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPathA ,nil] withRowAnimation:UITableViewRowAnimationRight];
                }else{
                    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPathA ,nil] withRowAnimation:UITableViewRowAnimationNone];
                }
                mon = theMoon;
            }else{
                theMoon = mon;
            }
        }else{
            [super alert:[dic objectForKey:@"info"]];
        }
           }
}
@end
