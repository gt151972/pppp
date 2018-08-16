//
//  RecommendViewController.m
//  InKeLive
//
//  Created by 高婷婷 on 2018/8/3.
//  Copyright © 2018年 jh. All rights reserved.
//

#import "RecommendViewController.h"
#import "SDCycleScrollView.h"
#import "LiveViewController.h"
@interface RecommendViewController ()<SDCycleScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITableViewCell *cell;
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
@end

@implementation RecommendViewController{
    NSArray *_imagesURLStrings;
    SDCycleScrollView *_customCellScrollViewDemo;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self tableView];
}

- (UITableView *)tableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -40, SCREEN_WIDTH, SCREEN_HEIGHT-49) style:UITableViewStyleGrouped];
    //2.设置属性(行高, 分割线, 表头, 表尾)
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.separatorColor = [UIColor whiteColor];
    _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.sectionHeaderHeight = 0;
    _tableView.sectionFooterHeight = 0;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];

    return _tableView;
}

/**
 轮播图数组

 @return <#return value description#>
 */
- (NSArray *)imagesURLStrings{
    return @[
             @"http://b.hiphotos.baidu.com/image/pic/item/d52a2834349b033bda94010519ce36d3d439bdd5.jpg",
             @"http://h.hiphotos.baidu.com/image/pic/item/5243fbf2b2119313b705987069380cd790238daf.jpg",
             @"http://h.hiphotos.baidu.com/image/pic/item/267f9e2f07082838304837cfb499a9014d08f1a0.jpg"
             ];
}


/**
 轮播图
 */
- (void)viewpager{
    // 网络加载 --- 创建带标题的图片轮播器
    _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 78*SCREEN_WIDTH/320) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
//    cycleScrollView2.titlesGroup = titles;
    _cycleScrollView.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    [_cell.contentView addSubview:_cycleScrollView];
    
    //         --- 模拟加载延迟
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_cycleScrollView setImageURLStringsGroup:[self imagesURLStrings]];
    });
    
//     block监听点击方式
    
     _cycleScrollView.clickItemOperationBlock = ^(NSInteger index) {
     NSLog(@">>>>>  %ld", (long)index);
     };
     
     
}

#pragma mark -- UITableViewDataSource
//UITableViewDataSource中方法
//@required 必须要实现的两个方法1.和 2.

//1.设置行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else{
        return 2;
    }
}
//2.UITableViewCell, 单元格类, 继承于UIView, 用于在UITableView上显示内容
//注:会执行多次, 每走一次, 创建一个cell; 第一次只创建出一个屏幕能够显示的cell,如果滚动tableView, 会再走这个方法,再次创建cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Recommend";
    _cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!_cell) {
        _cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }else{
        while ([_cell.contentView.subviews lastObject] != nil) {
            [(UIView*)[_cell.contentView.subviews lastObject] removeFromSuperview];  //删除并进行重新分配
        }
    }
    if (indexPath.section == 0) {
        [self viewpager];
    }else{
        if (indexPath.row == 0) {
            UIImageView *imageViewHead = [[UIImageView alloc] initWithFrame:CGRectMake(13, 3, 36, 36)];
            [imageViewHead sd_setImageWithURL:[NSURL URLWithString:@"http://e.hiphotos.baidu.com/image/pic/item/42a98226cffc1e17461390ed4690f603728de9ba.jpg"]];
            imageViewHead.layer.cornerRadius = 18.0;
            imageViewHead.layer.masksToBounds = YES;
            [_cell.contentView addSubview:imageViewHead];
            
            NSString *str1 = @"美女世家";
            NSString *str2 = @"123456";
            UILabel *labName = [[UILabel alloc] initWithFrame:CGRectMake(51, 3, SCREEN_WIDTH, 36)];
            labName.text = [NSString stringWithFormat:@"%@(%@)",str1,str2];
            labName.textColor = TEXT_COLOR;
            labName.textAlignment = NSTextAlignmentLeft;
            labName.font = [UIFont systemFontOfSize:14];
            [_cell.contentView addSubview:labName];
            
        }else{
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(7, 0, SCREEN_WIDTH-14, SCREEN_WIDTH*245/312)];
            [imageView sd_setImageWithURL:[NSURL URLWithString:@"http://e.hiphotos.baidu.com/image/pic/item/42a98226cffc1e17461390ed4690f603728de9ba.jpg"]];
            [_cell.contentView addSubview:imageView];
        }
    }
    return _cell;
}

//@optional  UITableViewDataSource 中不必实现但是经常用到的方法
//1.设置分组个数section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 20;
}

#pragma mark - UITableViewDelegate

//4.设置每行间隔的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 78*SCREEN_WIDTH/320;
    }else{
        if (indexPath.row == 0) {
            return 44;
        }else{
            return 7+SCREEN_WIDTH*245/312;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

//5.选择哪一section的哪一行
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LiveViewController *liveVC = [[LiveViewController alloc] init];
    [self.navigationController pushViewController:liveVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
