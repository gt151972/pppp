//
//  OilViewController.m
//  ChehuluHybrid
//
//  Created by GT mac on 16/8/5.
//  Copyright © 2016年 GT mac. All rights reserved.
//

#import "OilViewController.h"
#import "OilView.h"

@interface OilViewController ()<UITableViewDelegate, UITableViewDataSource>{
    NSDictionary *dicData;
    NSDictionary *dicDataBar;
    OilView *oilView;
    UIScrollView *scrollView;
    BOOL isSelect;
    int selectNum;
}

@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)CAShapeLayer *layer;
@property(nonatomic, strong)UIBezierPath *path;
@property(nonatomic, strong)CAGradientLayer *gradientLayer;

@end

@implementation OilViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initView];
}

- (void)initData{
    indexDAL = [[IndexRequestDAL alloc] init];
    indexDAL.delegate = self;
    dicData = [[NSDictionary alloc] init];
    dicDataBar = [[NSDictionary alloc] init];
    NSLog(@"_strDate == %@",_strDate);
    if ([gtCarInfo objectForKey:@"obd_id"]) {
        [indexDAL getObdOilWithObdID:[gtCarInfo objectForKey:@"obd_id"] date:_strDate carNO:[gtCarInfo objectForKey:@"car_no"]];
    }else{
        [indexDAL getObdOilWithObdID:@"" date:_strDate carNO:[gtCarInfo objectForKey:@"car_no"]];
    }

//    [indexDAL getOilListsWithObdId:[gtCarInfo objectForKey:@"obd_id"] date:_strDate carNo:[gtCarInfo objectForKey:@"car_no"] listsType:@"2"];
    oilView = [[OilView alloc] init];
    isSelect = 0;
}

- (void)initView{
    [self headView];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    NSLog(@"%f",_tableView.contentOffset.y);
    if (_tableView.contentOffset.y <= 100) {
        _tableView.bounces = NO;
    }
    else
    {
        _tableView.bounces = YES;
    }
}

- (void)headView{
    UIView *viewNav = [[UIView alloc] initWithFrame:CGRectMake(0, 0, gtWIDTH, 64)];
    viewNav.backgroundColor = COLOR_BG_BLACK_DEEP;
    [self.view addSubview:viewNav];
    
    UIButton *btnBack = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, 44, 44)];
    [btnBack setImage:[UIImage imageNamed:@"btnBackNormal"] forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(btnBackClicked) forControlEvents:UIControlEventTouchUpInside];
    [viewNav addSubview:btnBack];
    
    UIButton *btnRight = [[UIButton alloc] initWithFrame:CGRectMake(gtWIDTH - 64, 20, 44, 44)];
    [btnRight setImage:[UIImage imageNamed:@"moreWhite"] forState:UIControlStateNormal];
    [btnRight setTag:201];
    [btnRight addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [viewNav addSubview:btnRight];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, gtWIDTH, gtHEIGHT - 64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = COLOR_BG_BLACK_DEEP;
    self.tableView.separatorColor = COLOR_BG_BLACK;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.allowsSelection = NO;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CarStatusTableViewCell"];
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
    
}

- (void)btnClicked :(UIButton *)button{
    if (button.tag == 201) {
        //更多
    }
}

#pragma mark -- UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 266;
        }else{
            return 60;
        }
    }else{
        return 60;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else{
        return 8;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
    }else{
        return 2;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"OilTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    if (!cell) {
    }
    
    NSArray *arrTitle = [[NSArray alloc] initWithObjects:@"今日", @"今日", @"累计", @"累计", nil];
    NSArray *arrExplain = [[NSArray alloc] initWithObjects:@"油耗", @"花费", @"油耗", @"花费'", nil];
    NSArray *arrData = [[NSArray alloc] initWithObjects:@"3.5", @"120", @"25", @"258", nil];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.backgroundColor = COLOR_BG_BLACK_DEEP;
           
            NSArray *arrWeek = [NSArray arrayWithObjects:@"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
            scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 45, gtWIDTH, 221)];
            [scrollView setBackgroundColor:[UIColor clearColor]];
            [scrollView setCanCancelContentTouches:NO];
            scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
            scrollView.clipsToBounds = YES;     // default is NO, we want to restrict drawing within our scrollview
            scrollView.scrollEnabled = YES;
            scrollView.pagingEnabled = YES;
            scrollView.delegate = self;
            scrollView.tag = 1;
            scrollView.showsHorizontalScrollIndicator = NO;
            if ([[dicDataBar objectForKey:@"detail"] count]*51 > gtWIDTH) {
                scrollView.frame = CGRectMake(0, 45, [[dicDataBar objectForKey:@"detail"] count]*51, 221);
            }
            
            [cell.contentView addSubview:scrollView];
            UIButton *btnDay = [[UIButton alloc] initWithFrame:CGRectMake(16, 13, 30, 30)];
            [btnDay setImage:[UIImage imageNamed:@"dayNormal"] forState:UIControlStateNormal];
            [btnDay setImage:[UIImage imageNamed:@"daySelect"] forState:UIControlStateSelected];
            [btnDay addTarget:self action:@selector(btnOilClicked:) forControlEvents:UIControlEventTouchUpInside];
            [btnDay setTag:201];
            [cell.contentView addSubview:btnDay];
            
            UIButton *btnMonth = [[UIButton alloc] initWithFrame:CGRectMake(78, 13, 30, 30)];
            [btnMonth setImage:[UIImage imageNamed:@"mouthNormal"] forState:UIControlStateNormal];
            [btnMonth setImage:[UIImage imageNamed:@"mouthSelect"] forState:UIControlStateSelected];
            [btnMonth addTarget:self action:@selector(btnOilClicked:) forControlEvents:UIControlEventTouchUpInside];
            [btnMonth setTag:202];
            [cell.contentView addSubview:btnMonth];
            if (isSelect == 0) {
                btnDay.selected = YES;
                btnMonth.selected = NO;
            }else{
                btnDay.selected = NO;
                btnMonth.selected = YES;
            }

            float max = [[dicDataBar objectForKey:@"max_oil"] floatValue];
            NSLog(@"%lu",[[dicDataBar objectForKey:@"detail"] count]);
//
            for (int index = 0; index < [[dicDataBar objectForKey:@"detail"] count]; index ++) {
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(51*index, 0, 51, 221)];
//                view.backgroundColor = [UIColor redColor];
                [scrollView addSubview:view];
                if (btnDay.selected) {
                    [view addSubview:[oilView initView:view oil:[[[[dicDataBar objectForKey:@"detail"] objectAtIndex:index] objectForKey:@"oil_use"] floatValue] date:[arrWeek objectAtIndex:index] max:max]];
                }else{
                    [view addSubview:[oilView initView:view oil:[[[[dicDataBar objectForKey:@"detail"] objectAtIndex:index] objectForKey:@"oil_use"] floatValue] date:[NSString stringWithFormat:@"%d月",index+1] max:max]];
                }
                
                
                UIButton *btnSelect = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 51, 221)];
                [btnSelect setBackgroundColor:[UIColor colorWithRed:45/255.0 green:47/255.0 blue:59/255.0 alpha:0.5]];
                [btnSelect setTag:210+index];
                if (btnSelect.tag == selectNum) {
                    [btnSelect setBackgroundColor:[UIColor clearColor]];
                }
                [btnSelect addTarget:self action:@selector(btnOilClicked:) forControlEvents:UIControlEventTouchUpInside];
                [view addSubview:btnSelect];
            }
            UIView *viewLine = [[UIView alloc] initWithFrame:CGRectMake(0, 248, gtWIDTH, 1)];
            viewLine.backgroundColor = COLOR_MAIN_GREEN;
            [cell.contentView addSubview:viewLine];
            //注解
            UILabel * labAnnotate = [[UILabel alloc] initWithFrame:CGRectMake(100, 5, gtWIDTH-115, 12)];
            labAnnotate.text = @"油耗L/100km";
            labAnnotate.textAlignment = NSTextAlignmentRight;
            labAnnotate.textColor = COLOR_SHADE_BLUE_DEEP;
            labAnnotate.font = [UIFont systemFontOfSize:12];
            [cell.contentView addSubview:labAnnotate];
            
                    }else{
            NSArray *arrTitle = [NSArray arrayWithObjects:@"当日油耗", @"当日油费", nil];
            cell.backgroundColor = [UIColor whiteColor];
            cell.textLabel.text = [arrTitle objectAtIndex:indexPath.row-1];
            cell.textLabel.font = [UIFont systemFontOfSize:16];
            cell.textLabel.textColor = COLOR_TEXT_GARY_DEEP;
            if (dicData) {
                if (indexPath.row == 1) {
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@L",[dicData objectForKey:@"oil_today"]];
                }else{
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"¥%@",[dicData objectForKey:@"cost_today"]];
                }
            }else{
                if (indexPath.row == 1) {
                    cell.detailTextLabel.text = @"0L";
                }else{
                    cell.detailTextLabel.text = @"¥0";
                }
            }
           
            cell.detailTextLabel.font = [UIFont systemFontOfSize:16];
            cell.detailTextLabel.textColor = COLOR_TEXT_GARY_DEEP;

        }
    }else if (indexPath.section == 1) {
        NSArray *arrTitle = [NSArray arrayWithObjects:@"本周油耗", @"本周油费", nil];
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.text = [arrTitle objectAtIndex:indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.textLabel.textColor = COLOR_TEXT_GARY_DEEP;
        if (dicData) {
            if (indexPath.row == 0) {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@L",[dicData objectForKey:@"oil_week"]];
            }else{
                cell.detailTextLabel.text = [NSString stringWithFormat:@"¥%@",[dicData objectForKey:@"cost_week"]];
            }
        }else{
            if (indexPath.row == 0) {
                cell.detailTextLabel.text = @"0L";
            }else{
                cell.detailTextLabel.text = @"¥0";
            }
        }
//        cell.detailTextLabel.text = [NSString stringWithFormat:@"¥%@",[arrData objectAtIndex:indexPath.row]];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:16];
        cell.detailTextLabel.textColor = COLOR_TEXT_GARY_DEEP;
    }else{
        NSArray *arrTitle = [NSArray arrayWithObjects:@"本月油耗", @"本月油费", nil];
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.text = [arrTitle objectAtIndex:indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.textLabel.textColor = COLOR_TEXT_GARY_DEEP;
        if (dicData) {
            if (indexPath.row == 0) {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@L",[dicData objectForKey:@"oil_total"]];
            }else{
                cell.detailTextLabel.text = [NSString stringWithFormat:@"¥%@",[dicData objectForKey:@"cost_total"]];
            }
        }else{
            if (indexPath.row == 0) {
                cell.detailTextLabel.text = @"0L";
            }else{
                cell.detailTextLabel.text = @"¥0";
            }
        }
//        cell.detailTextLabel.text = [NSString stringWithFormat:@"¥%@",[arrData objectAtIndex:indexPath.row]];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:16];
        cell.detailTextLabel.textColor = COLOR_TEXT_GARY_DEEP;
    }

    return cell;
}

- (UIBezierPath *)path : (int)height :(float)x{
    _path = [UIBezierPath bezierPath];
    [_path moveToPoint:CGPointMake(x, 248)];
    [_path addLineToPoint:CGPointMake(x, 248 - height)];
    _path.lineWidth = 1.0;
    UIColor *fillColor = [UIColor grayColor];
    [fillColor set];
    [_path fill];
    return _path;
}


#pragma mark -- Action
- (void)btnOilClicked: (UIButton *)btn{
    if (btn.tag == 201) {
        //天
        if (btn.selected == NO) {
            btn.selected = YES;
            if ([gtCarInfo objectForKey:@"obd_id"]) {
                [indexDAL getOilListsWithObdId:[gtCarInfo objectForKey:@"obd_id"] date:_strDate carNo:[gtCarInfo objectForKey:@"car_no"] listsType:@"1"];
            }else{
                [indexDAL getOilListsWithObdId:@"" date:_strDate carNo:[gtCarInfo objectForKey:@"car_no"] listsType:@"1"];
            }
            
             [btn setImage:[UIImage imageNamed:@"daySelect"]forState:UIControlStateSelected];
            UIButton *btn2 = (UIButton *)[self.tableView viewWithTag:202];
            btn2.selected = NO;
            isSelect = 0;
        }
    }else if (btn.tag == 202){
        //月
        if (btn.selected == NO) {
            btn.selected = YES;
            if ([gtCarInfo objectForKey:@"obd_id"]) {
                [indexDAL getOilListsWithObdId:[gtCarInfo objectForKey:@"obd_id"] date:_strDate carNo:[gtCarInfo objectForKey:@"car_no"] listsType:@"2"];
            }else{
                [indexDAL getOilListsWithObdId:@"" date:_strDate carNo:[gtCarInfo objectForKey:@"car_no"] listsType:@"2"];
            }
            [btn setImage:[UIImage imageNamed:@"mouthSelect"]forState:UIControlStateSelected];
            UIButton *btn2 = (UIButton *)[self.tableView viewWithTag:201];
            btn2.selected = NO;
            isSelect = 1;
        }
    }else{
//        selectNum = (int)btn.tag;
        UIButton *btn1 = (UIButton *)[self.tableView viewWithTag:selectNum];
        [btn1 setBackgroundColor:[UIColor colorWithRed:45/255.0 green:47/255.0 blue:59/255.0 alpha:0.5]];
        [btn setBackgroundColor:[UIColor clearColor]];
        selectNum  = (int)btn.tag;
    }
}

- (void)InfoCallBackDic:(NSMutableDictionary *)dic :(NSString *)cmd{
    NSLog(@"dic == %@",dic);
    NSLog(@"cmd == %@",cmd);
    if ([cmd isEqualToString:@"CarOilLists"]) {
        if ([[dic objectForKey:@"status"] intValue] == 1) {
            dicDataBar = [NSDictionary dictionaryWithDictionary:[dic objectForKey:@"info"]];
            selectNum = 210+ (int)[dicDataBar count];
        }else{
            [super alert:[dic objectForKey:@"info"]];
        }
        NSIndexPath *indexPathA = [NSIndexPath indexPathForRow:0 inSection:0]; //刷新第0段第2行
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPathA ,nil]  withRowAnimation:UITableViewRowAnimationNone];
        
    }else if ([cmd isEqualToString:@"CarObdOil"]){
        if ([[dic objectForKey:@"status"] intValue] == 1) {
            dicData = [NSDictionary dictionaryWithDictionary:[dic objectForKey:@"info"]];
        }else{
            [super alert:[dic objectForKey:@"info"]];
        }
        [_tableView reloadData];
        [indexDAL getOilListsWithObdId:[gtCarInfo objectForKey:@"obd_id"] date:_strDate carNo:[gtCarInfo objectForKey:@"car_no"] listsType:@"2"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
