//
//  HomeMileageViewController.m
//  ChehuluHybrid
//
//  Created by 高婷婷 on 2017/4/21.
//  Copyright © 2017年 GT mac. All rights reserved.
//

#import "HomeMileageViewController.h"
#import "MileageView.h"

@interface HomeMileageViewController (){
    NSArray *arrayMonth;//
    MileageView *mileageView;
    NSDictionary *dicMonth;
    int maxMile;//当前最大刻度
}
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation HomeMileageViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [super navigationTypeWhite:@"我的里程宝"];
    [super addRightButtonForImage:@"benefits"];
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
    
    arrayMonth = [[NSArray alloc] init];
    dicMonth = [[NSDictionary alloc] init];
}

- (void)initView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -20, gtWIDTH,gtHEIGHT) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.scrollEnabled = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"MileageTableViewCell"];
    [self.view addSubview:self.tableView];
}

#pragma mark -- UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 145;
        }else{
            return 90;
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
        return 2;
    }else{
        return arrayMonth.count +1;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"MineTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    if (!cell) {
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [mileageView showViewWithView:self.view dic:[super nullToEmptyString:dicMonth]];
        }else{
            UILabel *labDetail = [[UILabel alloc] init];
//            labDetail.text = [NSString stringWithFormat:@"%@-%@累计里程小于"];
        }
    }else{
        if (indexPath.row == 0) {
            
        }else{
            
        }
    }
    return cell;
}

- (void)doClickRightButton :(UIButton *)sender{
    
}

- (void)InfoCallBackDic:(NSMutableDictionary *)dic :(NSString *)cmd{
    NSLog(@"dic == %@",dic);
    NSLog(@"cmd == %@",cmd);
    if ([cmd isEqualToString:@"CarMileMonthing"]) {
        if ([[dic objectForKey:@"status"] intValue] == 1) {
            dicMonth = [dic objectForKey:@"info"];
        }else{
            [super alert:[dic objectForKey:@"info"]];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
