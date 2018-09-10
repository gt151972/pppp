//
//  ServideViewController.m
//  InKeLive
//
//  Created by 高婷婷 on 2018/8/31.
//  Copyright © 2018年 jh. All rights reserved.
//

#import "ServideViewController.h"

@interface ServideViewController ()<UITableViewDelegate, UITableViewDataSource>{
    NSArray *arrayTitle;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ServideViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        arrayTitle = @[@"QQ客服",@"招聘主播",@"技术支持",@"联系电话"];
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = @"客服中心";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back"] style:UIBarButtonItemStyleDone target:self action:@selector(btnBackClicked)];
    self.navigationItem.leftBarButtonItem.tintColor = RGB(110, 110, 110);
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 55;
    _tableView.sectionIndexColor = [UIColor whiteColor];
    _tableView.separatorColor = RGB(239, 239, 239);
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellWithIdentifier = @"EditInfoTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellWithIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [arrayTitle objectAtIndex:indexPath.row];
    cell.textLabel.textColor = RGB(32, 32, 32);
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    
    UIButton *btnQQ = [[UIButton alloc] init];
    [btnQQ setBackgroundColor:RGB(81, 131, 215)];
    btnQQ.layer.cornerRadius = 3;
    btnQQ.layer.masksToBounds = YES;
    [btnQQ setTitle:@"QQ交流" forState:UIControlStateNormal];
    btnQQ.titleLabel.font = [UIFont systemFontOfSize:12];
    [btnQQ setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnQQ setImage:[UIImage imageNamed:@"btn_qq_icon_white"] forState:UIControlStateNormal];
    [btnQQ setTag:200+indexPath.row];
    [cell.contentView addSubview:btnQQ];
    [btnQQ mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@75);
        make.height.equalTo(@27);
        make.right.equalTo(cell.contentView).offset(-13);
        make.centerY.equalTo(cell.contentView);
    }];
    
    if (indexPath.row == 3) {
        btnQQ.hidden = YES;
        
        UILabel *labTel = [[UILabel alloc] init];
        labTel.text = @"15125821546";
        labTel.textColor = MAIN_COLOR;
        labTel.textAlignment = NSTextAlignmentRight;
        labTel.font = [UIFont systemFontOfSize:10];
        [cell.contentView addSubview:labTel];
        
        
        UIButton *btnGo = [[UIButton alloc] init];
        [btnGo setImage:[UIImage imageNamed:@"btn_go"] forState:UIControlStateNormal];
        [cell.contentView addSubview:btnGo];
        [btnGo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView);
            make.width.equalTo(@11);
            make.height.equalTo(@17);
            make.right.equalTo(cell.contentView).offset(-13);
        }];
        [labTel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cell.contentView).offset(-28);
            make.centerY.equalTo(cell.contentView);
            make.width.equalTo(@150);
            make.height.equalTo(@10);
            
        }];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row == 0) {
        
    }else if (indexPath.row == 1){
        
    }else if (indexPath.row == 2){
        
    }else if (indexPath.row == 3){
        UIWebView *webView = [[UIWebView alloc]init];
        NSURL *url = [NSURL URLWithString:@"tel://15125821546"];
        [webView loadRequest:[NSURLRequest requestWithURL:url ]];
        [[UIApplication sharedApplication].keyWindow addSubview:webView];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark  Action
- (void)btnBackClicked{
    [self.navigationController popViewControllerAnimated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
