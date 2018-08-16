//
//  CarShareView.m
//  ChehuluHybrid
//
//  Created by 高婷婷 on 2017/6/13.
//  Copyright © 2017年 GT mac. All rights reserved.
//
#define WIDTH gtWIDTH*0.8
#define HEIGHT(h) (WIDTH*h/667)*gtHEIGHT/gtWIDTH
#import "CarShareView.h"
#import "CommendFile.h"



@implementation CarShareView

/**
 状态分享
// 
 @param arrayHead 上collect数据
 @param arrayfooter 下collect数据
 @param date 日期
 @param superView 父视图
 */
- (void)initViewStatuesWithArrayHead: (NSArray *)arrayHead arrayFooter: (NSArray *)arrayfooter date: (NSString *)date surperView: (UIView *)superView{
//    NSLog(@"arrayHead == %@",arrayHead);
    _arrayHead = [NSArray arrayWithArray:arrayHead];
    _arrayFooter = [NSArray arrayWithArray:arrayfooter];
    UIView *viewBg = [[UIView alloc] initWithFrame:CGRectMake((gtWIDTH- WIDTH)/2, gtHEIGHT - HEIGHT(667)-49, WIDTH, HEIGHT(667))];
    
    viewBg.backgroundColor = COLOR_BG_GRAY;
    [superView addSubview:viewBg];
    
    UIImage *imageHead = [UIImage imageNamed:@"shareCarBg"];
    UIImageView *imageViewHead = [[UIImageView alloc] initWithImage:imageHead];
    imageViewHead.frame = CGRectMake(0, 0, WIDTH, HEIGHT( imageHead.size.height));
    [viewBg addSubview:imageViewHead];
    
    UILabel *labTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, WIDTH - 40, HEIGHT(16))];
//    gtDicMyInfo
    labTitle.text = [NSString stringWithFormat:@"~来自%@的座驾~",[gtDicMyInfo objectForKey:@"nickname"]];
    labTitle.textColor = [UIColor whiteColor];
    labTitle.textAlignment = NSTextAlignmentLeft;
    labTitle.font = [UIFont systemFontOfSize:16];
    [viewBg addSubview:labTitle];
    
    UILabel *labDate = [[UILabel alloc] initWithFrame:CGRectMake(gtWIDTH - 20, 30,  WIDTH- 40, HEIGHT(16))];
    labDate.text = date;
    labDate.textColor = [UIColor whiteColor];
    labDate.textAlignment = NSTextAlignmentRight;
    labDate.font = [UIFont systemFontOfSize:16];
    [viewBg addSubview:labDate];
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 0;//间距
    flowLayout.minimumLineSpacing = 1;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, imageViewHead.frame.origin.y + imageViewHead.frame.size.height, WIDTH , HEIGHT(290)) collectionViewLayout:flowLayout];
//    self.automaticallyAdjustsScrollViewInsets = false;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.scrollEnabled = NO;
    self.collectionView.backgroundColor = [UIColor blackColor];
    self.collectionView.tag = 402;
    [self.collectionView setBackgroundColor:COLOR_BG_GRAY2];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"collectionViewCell"];
    [viewBg addSubview:self.collectionView];
//    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(imageViewHead.mas_bottom);
//    }];
    
    UICollectionViewFlowLayout *flowLayout1=[[UICollectionViewFlowLayout alloc] init];
    flowLayout1.minimumInteritemSpacing = 0;//间距
    flowLayout1.minimumLineSpacing = 1;
    self.collectionViewFooter = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.collectionView.frame.origin.y + self.collectionView.frame.size.height, WIDTH , HEIGHT(169)) collectionViewLayout:flowLayout];
    //    self.automaticallyAdjustsScrollViewInsets = false;
    self.collectionViewFooter.delegate = self;
    self.collectionViewFooter.dataSource = self;
    self.collectionViewFooter.scrollEnabled = NO;
    self.collectionViewFooter.tag = 403;
    [self.collectionViewFooter setBackgroundColor:COLOR_BG_GRAY2];
    [self.collectionViewFooter registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"collectionFooterCell"];
    [viewBg addSubview:self.collectionViewFooter];
//    [self.collectionViewFooter mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.collectionView.mas_bottom);
//    }];
    
    //头像
    UIButton *btnHead = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH/2 - HEIGHT(30), 61, HEIGHT(60), HEIGHT(60))];
    btnHead.layer.masksToBounds = YES;
    btnHead.layer.cornerRadius = 18;
    //        btnHead.backgroundColor = [super colorWithHexString:@"#d8ede4"];
    [btnHead setBackgroundImage:[UIImage imageNamed:@"defaultHead"] forState:UIControlStateNormal];
    UIImage *imgHead = [super getImageWithName:@"head"];
    if (imgHead) {
        [btnHead setImage:imgHead forState:UIControlStateNormal];
    }
    [viewBg addSubview:btnHead];
    
    UIImage *imageBottom = [UIImage imageNamed:@"circle"];
    UIImageView *imageViewBottom = [[UIImageView alloc] initWithImage:imageBottom];
    [viewBg addSubview:imageViewBottom];
    [imageViewBottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(imageBottom.size);
        make.bottom.and.right.equalTo(viewBg);
    }];

    
    UIImage *imageQRCode = [UIImage imageNamed:@"QRcode"];
    UIImageView *imageViewQRCode = [[UIImageView alloc] initWithImage:imageQRCode];
    [viewBg addSubview:imageViewQRCode];
    [imageViewQRCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(viewBg);
        make.size.mas_equalTo(CGSizeMake(HEIGHT(60), HEIGHT(60)));
        make.bottom.mas_equalTo(25);
    }];
    
    UILabel *labDetail = [[UILabel alloc] init];
    labDetail.text = @"长按识别二维码  下载车葫芦APP";
    labDetail.textAlignment = NSTextAlignmentCenter;
    labDetail.textColor = COLOR_TEXT_GARY;
    labDetail.font = [UIFont systemFontOfSize:10];
    [viewBg addSubview:labDetail];
    [labDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(WIDTH, 10));
        make.top.equalTo(imageViewQRCode.mas_bottom).offset(5);
        make.centerX.equalTo(viewBg);
    }];
}

#pragma mark -- UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
     if (collectionView.tag == 402){
        return 4;
    }
    else{
        return 4;
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell;
    if (collectionView.tag == 402){
        cell.contentView.backgroundColor = [UIColor redColor];
        cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"collectionViewCell" forIndexPath:indexPath];
        NSArray *arrayImage = [NSArray arrayWithObjects:@"milleageBig", @"timeBig", @"oilBig", @"carbonBig", nil];
        NSArray *arrayUnit = [NSArray arrayWithObjects:@"km", @"h", @"L", @"kg", nil];
        NSArray *arrayDetail = [NSArray arrayWithObjects:@"里程", @"时间", @"油耗", @"碳排", nil];
        cell.contentView.backgroundColor = [UIColor redColor];
        UIImageView *imageViewIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[arrayImage objectAtIndex:indexPath.row]]];
        [cell.contentView addSubview:imageViewIcon];
        [imageViewIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(62, 62));
            make.top.mas_equalTo(21);
            make.centerX.equalTo(cell.contentView);
        }];
        
        UILabel *labData = [[UILabel alloc] init];
        
        labData.textColor = COLOR_TEXT_GARY_DEEP;
        labData.textAlignment = NSTextAlignmentCenter;
        labData.font = [UIFont systemFontOfSize:22];
        labData.tag = 101+indexPath.row;
        NSLog(@"tag = %ld",(long)labData.tag);
        [cell.contentView addSubview:labData];
        [labData mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imageViewIcon.mas_bottom).offset(5);
            make.centerX.and.width.equalTo(cell.contentView);
            make.height.mas_offset(22);
        }];
        
        UILabel *labDetail = [[UILabel alloc] init];
        labDetail.text = [arrayDetail objectAtIndex:indexPath.row];
        labDetail.textAlignment = NSTextAlignmentCenter;
        labDetail.textColor = COLOR_TEXT_GARY;
        labDetail.font = [UIFont systemFontOfSize:13];
        [cell.contentView addSubview:labDetail];
        [labDetail mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.and.width.equalTo(cell.contentView);
            make.top.equalTo(labData.mas_bottom).offset(7);
            make.height.mas_offset(13);
        }];
        if (_arrayHead.count == 0) {
            labData.text = [NSString stringWithFormat:@"0%@",[arrayUnit objectAtIndex:indexPath.row]];
        }else{
            labData.text = [NSString stringWithFormat:@"%.2f%@", [[_arrayHead objectAtIndex:indexPath.row] floatValue], [arrayUnit objectAtIndex:indexPath.row]];
            if ([[_arrayHead objectAtIndex:indexPath.row] floatValue] == 0) {
                labData.text = [NSString stringWithFormat:@"0%@", [arrayUnit objectAtIndex:indexPath.row]];
            }
            if (indexPath.row == 1) {
                float second = [[_arrayHead objectAtIndex:1] floatValue];
                //                NSLog(@"second == %d",second);
                NSString *strUnit = @"min";
                if (second>60 && second < 3600) {
                    second = second/60;
                    strUnit = @"min";
                }else if (second > 3600){
                    second = second / 3600;
                    strUnit = @"h";
                }else if (second > 0 && second < 60){
                    second = 1;
                }
                labData.text = [NSString stringWithFormat:@"%.1f%@", second, strUnit];
                if (second <= 0) {
                    labData.text = @"0min";
                }
            }
        }
    }
    else{
        cell = [self.collectionViewFooter dequeueReusableCellWithReuseIdentifier:@"collectionFooterCell" forIndexPath:indexPath];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        NSArray *arrayDetail = [[NSArray alloc] initWithObjects:@"平均油耗", @"急加速/减速/转弯", @"最高速度", @"平均速度", nil];
        
        UILabel *labDetail = [[UILabel alloc] init];
        labDetail.text = [arrayDetail objectAtIndex:indexPath.row];
        labDetail.textColor = [UIColor grayColor];
        labDetail.textAlignment = NSTextAlignmentCenter;
        labDetail.font = [UIFont systemFontOfSize:13];
        [cell.contentView addSubview:labDetail];
        [labDetail mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.and.width.equalTo(cell.contentView);
            make.height.mas_equalTo(13);
            make.top.mas_equalTo(46);
        }];
        UILabel *labDetailNumber = [[UILabel alloc] init];
        if (_arrayFooter.count != 0) {
            if ([[_arrayFooter objectAtIndex:indexPath.row] isEqualToString:@""]) {
                labDetailNumber.text = 0;
            }else{
                labDetailNumber.text = [_arrayFooter objectAtIndex:indexPath.row];
            }
        }else{
            
        }
        labDetailNumber.textColor = COLOR_TEXT_GARY_DEEP;
        labDetailNumber.textAlignment = NSTextAlignmentCenter;
        labDetailNumber.font = [UIFont systemFontOfSize:16];
        [cell.contentView addSubview:labDetailNumber];
        [labDetailNumber mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(labDetail);
            make.bottom.equalTo(labDetail.mas_top).offset(-8);
            make.size.mas_equalTo(CGSizeMake(WIDTH/2, 16));
        }];
        
    }
    return cell;
}
#pragma mark -- UICollectionDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if(collectionView.tag == 402){
        return CGSizeMake(WIDTH/2-1, HEIGHT(144));
    }else{
        return CGSizeMake(WIDTH/2-1, HEIGHT(79));
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (collectionView.tag == 402){
        return UIEdgeInsetsMake(0.5, 0.5, 0.5, 0.5);
    }else{
        return UIEdgeInsetsMake(0.5, 0.5, 0.5, 0.5);
    }
    
}

#pragma mark -- UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    
}

@end
