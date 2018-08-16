//
//  CarBrandViewController.m
//  ChehuluHybrid
//
//  Created by 高婷婷 on 2017/3/1.
//  Copyright © 2017年 GT mac. All rights reserved.
//

#import "CarBrandViewController.h"

@interface CarBrandViewController ()<UITableViewDelegate, UITableViewDataSource>{
    NSDictionary *dicBrand;
    NSMutableDictionary *dicSeries;
    
    NSArray *arrayRow;
    
    NSString *strCarSeries;
    NSString *strBrandID;
    NSString *strbrandName;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITableView *tableViewSeries;
@property (nonatomic, strong) UIView *viewSeries;
@end

@implementation CarBrandViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [super navigationTypeWhite:@"品牌车系"];
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
    dicBrand = [[NSDictionary alloc] init];
    dicSeries = [[NSMutableDictionary alloc] init];
    arrayRow = [[NSArray alloc] init];
    strCarSeries = @"";
    strBrandID = @"";
    strbrandName = @"";
    
    indexDAL = [[IndexRequestDAL alloc] init];
    indexDAL.delegate = self;
    [indexDAL getCarBrand];
}

- (void)initView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, gtWIDTH,gtHEIGHT - 64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.scrollEnabled = YES;
    self.tableView.tag = 501;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CarBrandTableViewCell"];
    [self.view addSubview:_tableView];
}

#pragma mark -- UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 501) {
        return 60;
    }else{
        return 50;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView.tag == 501) {
        return 46;
    }else{
        return 0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (tableView.tag == 501) {
        NSArray *arrBrand = [[NSArray alloc] initWithArray:[dicBrand objectForKey:@"info"]];
        int num = 0;
        for (int index = 0; index < indexPath.section; index ++ ) {
            num = num + [[arrayRow objectAtIndex:index] intValue];
        }
        strBrandID = [[arrBrand objectAtIndex:indexPath.row+num] objectForKey:@"brand_id"];
        strbrandName = [[arrBrand objectAtIndex:indexPath.row+num] objectForKey:@"brand_name"];
        [indexDAL getCarSeriesWithBrandID:[[arrBrand objectAtIndex:indexPath.row+num] objectForKey:@"brand_id"]];
        UITableViewCell *cell1 = [tableView cellForRowAtIndexPath:indexPath];
        static NSString *cellIdentifier = @"CarBrandTableViewCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell != cell1) {
            cell.backgroundColor = COLOR_BG_GRAY;
        }else{
            cell.backgroundColor = [UIColor whiteColor];
        }
    }else{
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        strCarSeries = [[[dicSeries objectForKey:@"info"] objectAtIndex:indexPath.row]objectForKey:@"series_name"];
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:strBrandID, @"brand_id", strCarSeries, @"car_series", strbrandName, @"brand_name", nil];
        [center postNotificationName:@"carSeries"  object:@"" userInfo:dic];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 501) {
        NSArray *array = [dicBrand objectForKey:@"info"];
        int num = 0;//section
        int row = 1;
        NSMutableArray *arrR = [[NSMutableArray alloc] init];
        for (int index = 1; index < array.count; index ++ ) {
            NSString *str1 = [[array objectAtIndex:index-1] objectForKey:@"brand_alpha"];
            NSString *str2 = [[array objectAtIndex:index] objectForKey:@"brand_alpha"];
            if (![str2 isEqualToString:str1]) {
                num ++;
                [arrR addObject:[NSString stringWithFormat:@"%d",row]];
                row = 1;
            }else{
                row ++;
            }
        }
        arrayRow = arrR;
        return [[arrR objectAtIndex:section] intValue];
    }else{
        return [[dicSeries objectForKey:@"info"] count];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView.tag == 501) {
        NSArray *array = [dicBrand objectForKey:@"info"];
        int num = 0;
        for (int index = 1; index < array.count; index ++ ) {
            NSString *str1 = [[array objectAtIndex:index-1] objectForKey:@"brand_alpha"];
            NSString *str2 = [[array objectAtIndex:index] objectForKey:@"brand_alpha"];
            if (![str1 isEqualToString:str2]) {
                num ++;
            }
        }
        return num;
    }else{
        return 1;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (tableView.tag == 501) {
        NSArray *array = [dicBrand objectForKey:@"info"];
        int num = 0;//section
        NSMutableArray *arrR = [[NSMutableArray alloc] init];
        for (int index = 1; index < array.count; index ++ ) {
            NSString *str1 = [[array objectAtIndex:index-1] objectForKey:@"brand_alpha"];
            NSString *str2 = [[array objectAtIndex:index] objectForKey:@"brand_alpha"];
            if (![str2 isEqualToString:str1]) {
                num ++;
                [arrR addObject:[NSString stringWithFormat:@"%@",str1]];
            }
        }
        return [arrR objectAtIndex:section];
    }else{
        return @"";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"indexPath");
    if (tableView.tag == 501) {
        static NSString *cellIdentifier = @"CarBrandTableViewCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (!cell) {
        }
        NSArray *arrBrand = [[NSArray alloc] initWithArray:[dicBrand objectForKey:@"info"]];
        int num = 0;
        for (int index = 0; index < indexPath.section; index ++ ) {
            num = num + [[arrayRow objectAtIndex:index] intValue];
        }
        
        NSString *strUrl =  [[arrBrand objectAtIndex:indexPath.row+num] objectForKey:@"brand_logo"];
        UIImageView *imageViewIcon = [[UIImageView alloc] init];
        if (![strUrl isEqualToString:@""]) {
            imageViewIcon.image = [super getImageForUrl:strUrl];
        }else{
            imageViewIcon.image = [UIImage imageNamed:@"carLogo"];
        }
        [cell.contentView addSubview:imageViewIcon];
        [imageViewIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(35, 35));
            make.centerY.equalTo(cell.contentView);
            make.left.mas_equalTo(20);
        }];
        
        UILabel *labTitle = [[UILabel alloc] initWithFrame:CGRectMake(75, 0, gtWIDTH - 100, 60)];
        labTitle.text = [[arrBrand objectAtIndex:indexPath.row+num] objectForKey:@"brand_name"];
        labTitle.textColor = [UIColor blackColor];
        labTitle.font = [UIFont systemFontOfSize:14];
        [cell.contentView addSubview:labTitle];
        return cell;
    }else{
        static NSString *cellIdentifier = @"CarSeriesTableViewCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        if (!cell) {
        }
        NSLog(@"text == %@",[[[dicSeries objectForKey:@"info"] objectAtIndex:indexPath.row] objectForKey:@"series_name"]);
        cell.textLabel.text = [[[dicSeries objectForKey:@"info"] objectAtIndex:indexPath.row] objectForKey:@"series_name"];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        return cell;
    }
}

////显示每组标题索引
//
//-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
//    
//}
//
////返回每个索引的内容
//
//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    
//}
//
////响应点击索引时的委托方法
//
//-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString*)title atIndex:(NSInteger)index{
//    
//}
- (void)addCarSeriesView:(NSArray *)array{
    _viewSeries = [[UIView alloc] initWithFrame:CGRectMake(75, 0, gtWIDTH-75, gtHEIGHT - 64)];
    [self.view addSubview:_viewSeries];
    self.tableViewSeries = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, gtWIDTH-75,gtHEIGHT - 64) style:UITableViewStylePlain];
    self.tableViewSeries.delegate = self;
    self.tableViewSeries.dataSource = self;
    self.tableViewSeries.backgroundColor = [UIColor whiteColor];
    self.tableViewSeries.scrollEnabled = YES;
    self.tableViewSeries.tag = 502;
    self.tableViewSeries.separatorStyle = NO;
    [self.tableViewSeries registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CarSeriesTableViewCell"];
    [_viewSeries addSubview:_tableViewSeries];
}

- (void)InfoCallBackDic:(NSMutableDictionary *)dic :(NSString *)cmd{
    NSLog(@"dic == %@",dic);
    NSLog(@"cmd == %@",cmd);
    int state = [[dic objectForKey:@"status"] intValue];
    if ([cmd isEqualToString:@"CarBrand"]) {
        if (state == 1) {
            dicBrand = dic;
            NSLog(@"dicBrand == %@",dicBrand);
            NSArray *arrayBrand = [dicBrand objectForKey:@"info"];
            [self splitBrand:arrayBrand];
            [self.tableView reloadData];
        }else{
            [super alert:[dic objectForKey:@"info"]];
        }
    }else if ([cmd isEqualToString:@"CarSeries"]){
        if (state == 1) {
            dicSeries = dic;
            NSLog(@"dicSeries == %@",dicSeries);
            [self addCarSeriesView:[dicSeries objectForKey:@"info"]];
        }else{
            [super alert:[dic objectForKey:@"info"]];
        }

    }
}

- (void)splitBrand: (NSArray *)array{
    for (int index = 0; index < array.count; index ++ ) {
        NSString *strHead = [[array objectAtIndex:index] objectForKey:@"brand_alpha"];

    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
