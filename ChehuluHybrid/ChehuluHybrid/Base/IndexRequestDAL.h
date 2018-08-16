//
//  IndexRequestDAL.h
//  ChehuluHybrid
//
//  Created by GT mac on 16/5/30.
//  Copyright © 2016年 GT mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import <AFHTTPSessionManager.h>
#import <AFNetworkReachabilityManager.h>
@protocol IndexRequestDelegate <NSObject>
@optional
-(void)InfoCallBackDic:(NSMutableDictionary *)dic :(NSString *)cmd;

@end

typedef void (^ABlock)(void);
@interface IndexRequestDAL :  NSObject
{
    NSString *currResult;
}
@property (nonatomic, strong) AFHTTPSessionManager *manager;
@property(nonatomic,assign) id<IndexRequestDelegate> delegate;
@property(nonatomic,assign) BOOL isoverLay;

#pragma mark -- 登陆界面

- (void)addHttpsCer;

/**
 * 用户获取验证码
 *
 *  @param mobile 手机号码
 */
-(void)getVerifyCode:(NSString *)mobile;

/**
 *  登录
 *
 *  @param mobile    手机号
 *  @param verfycode 验证码
 */
- (void)loginWithMobile:(NSString *)mobile verfycode:(NSString *)verfycode;

/**
 *  登录
 */
- (void)loginToken;
#pragma mark -- 个人中心
/**
 *  个人信息获取
 */
- (void)getInfo;

/**
 *  车币查询
 */
- (void)MoneyInfo;

/**
 * 上传图片
 *
 *  @param picture 待上传图片(base64)
 */
- (void)uploadimgWithPicture:(NSString *)picture;

/**
 * 更新用户信息
 *
 *  @param headImg 待上传头像ID
  *  @param sex 性别(0:女 1:男)
  *  @param realname 真实姓名
 */
- (void)updateWithHeadImgID:(NSString *)headImg sex:(NSString *)sex realname: (NSString *)realname;

/**
 * 获取省份列表
 *
 *  @param searchType 查询类型
 *  @param gpsProvince 定位所在省份
 */
- (void)getProvinceWithSearchType:(NSString *)searchType gpsProvince:(NSString *)gpsProvince;

/**
 * 获取城市列表
 *
 *  @param searchType 查询类型
 *  @param gpsProvince 定位所在城市
 */
- (void)getAreaWithSeachType:(NSString *)searchType gpsArea:(NSString *)gpsArea;

/**
 * 用户车辆列表
 *
 *  @param p 页码
 */
- (void)getCarIndexWithPage: (NSString *)p;

/**
 * 车辆首页数据
 *
 *  @param carNo 车牌号
 *  @param date 日期
 *  @param isFake 是否是假数据(1-是 0-否)
 */
- (void)getCarDayLogWithCarNo: (NSString *)carNo date: (NSString *)date isFake: (NSString *)isFake; 

/**
 * C端车辆故障数量
 *
 *  @param obdID OBD编号
 *  @param carNum 车牌号
 */
- (void)getFaultNumWithObdId: (NSString *)obdID carNum: (NSString *)carNum;

/**
 * 当前故障检测
 *
 *  @param carID 车辆id
 */
- (void)getCarStatusWithCarId: (NSString *)carID;

/**
 * 车辆历史故障
 *
 *  @param CarNo 车辆号
 *  @param page 第几页
 *  @param limit 一页几个
 *  @param start 第几个开始
 */
- (void)getHistoryFalteWithCarNo: (NSString *)CarNo page: (NSString *)page limit: (NSString *)limit start: (NSString *)start;

/**
 * 车辆耗油详情
 *
 *  @param obdID OBD编号
 *  @param date 日期（默认今天)
 *  @param carNO 车牌号
 */
- (void)getObdOilWithObdID: (NSString *)obdID date: (NSString *)date carNO: (NSString *)carNO;

/**
 * 车辆行驶轨迹周数据
 *
 *  @param carID 车牌ID
 *  @param date 日期（默认今天)
 *  @param isFake 是否假数据
 
 */
- (void)getWeekLogWithCarID: (NSString *)carID date: (NSString *)date isFake: (NSString *)isFake;

/**
 * 车辆月数据
 *
 *  @param carID 车牌ID
 *  @param month 日期（默认今天)
 */
- (void)getMonthLogWithCarNo: (NSString *)carNo month: (NSString *)month isFake: (NSString *)isFake;

/**
 C端车辆列表
 
 @param page 第几页（默认第1页）
 @param limit 一页显示几个 （默认10个
 @param listType 列表类型（1-违章代办 2-年检代办 3-人工购险模块 4-车况列表，默认为空显示全部）
 @param provinceId 省份ID(可为空)
 @param areaId 城市ID(可为空)
 @param isFake 是否是假数据(1-是 0-否，可为空，默认为否)
 */
- (void)getCarListsWithPage: (NSString *)page limit: (NSString *)limit listType: (NSString *)listType provinceId: (NSString *)provinceId areaId: (NSString *)areaId isFake: (NSString *)isFake;

/**
 * C端根据车辆ID查询车辆详情
 *
 *  @param carID 车辆ID
 *  @param isVio 是否查询违章车辆 （1-是 0-否，可为空，默认为否）
 *  @param isMot 是否查询年检代办车辆 （1-是 0-否，可为空，默认为否）
 *  @param casualty 上年是否有人员伤亡（1-是 0-否，可为空，默认为否）
 */
- (void)getCarDetailWithCarID: (NSString *)carID isVio: (NSString *)isVio isMot: (NSString *)isMot casualty: (NSString *)casualty;


/**
 C端更新车辆信息

 @param carID 车辆ID（若修改则不能为空）
 @param carNo 车牌号（不能为空,若更换默认车辆可为空）
 @param drvOwner 车主姓名（不能为空,若更换默认车辆可为空）
 @param vhlFrm 车架号（不能为空,若更换默认车辆可为空）
 @param engNo 发动机号（不能为空,若更换默认车辆可为空）
 @param fstRegDte 初登日期(格式：年-月-日，不能为空，若更换默认车辆可为空)
 @param operating 是否是营运车辆（string 1-是 0-否，若更换默认车辆可为空）
 @param brandId 车辆品牌ID（可为空，若更换默认车辆可为空）
 @param carSeries 车系名称(可为空，若更换默认车辆可为空)
 @param img 行驶证正面图片ID（可为空，若更换默认车辆可为空）
 @param updateType 更新方式（1-车辆信息更新 2-更换默认车辆 3-添加默认车辆 4-更新加油型号,可为空，默认为1）
 */
- (void)postCarUpdateWithCarID: (NSString *)carID carNo: (NSString *)carNo drvOwner: (NSString *)drvOwner vhlFrm: (NSString *)vhlFrm engNo: (NSString *)engNo fstRegDte: (NSString *)fstRegDte operating: (NSString *)operating brandId: (NSString *)brandId carSeries: (NSString *)carSeries img: (NSString *)img updateType: (NSString *)updateType;

/**
 * C端模块移动车辆
 *
 *  @param carIDs 车辆IDs(多个车辆逗号分隔)
 *  @param carType 车辆类型（不能为空 1-年检代办 2-违章代办）
 *  @param status 状态（1-有效 0-无效 -1-删除)
 */
- (void)postCarMoveWithCarIDs: (NSString *)carIDs carType: (NSString *)carType status: (NSString *)status;

/**
 * C端获取保单期间内的OBD信息
 *
 *  @param policyid 购险订单ID（若未购险，则传0）
 *  @param carNo 车牌号
 */
- (void)postCarPolicyObdInfoWithPolicyid: (NSString *)policyid carNo: (NSString *)carNo;

/**
 * C端保险订单详情
 *
 *  @param policyid 购险订单ID
 */
- (void)postOrderDetailWithPolicyid: (NSString *)policyid;


/**
 *  C端获取车辆品牌列表
 */
- (void)getCarBrand;

/**
 * C端获取车辆车系列表
 *
 *  @param brandID 品牌ID
 */
- (void)getCarSeriesWithBrandID: (NSString *)brandID;

/**
 * 首页业务模块列表
 *
 *  @param areaID 城市id(可为空)（string）
 *  @param provinceId 省份ID(可为空)（string）
 *  @param showType 展示类型 (1-首页业务模块 2-首页购险模块)
 *  @param source 来源（1-车险模块 2-维修保养 3-商城 4-违章代办 5-年检代办）
 */
- (void)getIndexBusWithAreaID: (NSString *)areaID provinceId:(NSString *)provinceId showType:(NSString *)showType source:(NSString *)source;


/**
 轮播图列表

 @param source 轮播图来源(1-环境宝 2-首页 3-商城首页 4-商城广告位轮播 5-APP开机图片)
 @param provinceId 定位省份ID(可为空)
 @param areaId 定位城市id(可为空)
 */
- (void)getSlidesImagesLists: (NSString *)source provinceId: (NSString *)provinceId areaId: (NSString *)areaId;

/**
 * 商城首页最新商品
 *
 *  @param provinceID 定位省份ID(可为空)
 *  @param areaID 定位城市id(可为空)
 */
- (void)getCarSeriesWithProvinceID: (NSString *)provinceID areaID: (NSString *)areaID;

/**
 * 获取默认车辆
 *
 */
- (void)getCarCheckDefault;


/**
 推荐商品列表

 @param provinceID 定位省份ID(可为空)
 @param areaID 定位城市id(可为空)
 */
- (void)getMallProductsProvinceID:(NSString *)provinceID areaID:(NSString *)areaID;


/**
 根据GPS获取定位

 @param lng 经度
 @param lat 纬度
 @param gpsType 经纬度标准(string，1-WGS-84(GPS) 2-GCJ-02(高德) 3-BD-09(百度))
 */
- (void)getUserLocationWithLng:(NSString *)lng lat:(NSString *)lat gpsType:(NSString *)gpsType;



/**
 推荐店铺列表

 @param provinceId 定位省份ID(可为空)
 @param areaId 定位城市id(可为空)
 @param type 门店类型（1-维修保养 2-救援门店 3-年检代办站点）
 */
- (void)getStoreFineStoresWithProvinceId: (NSString *)provinceId areaId: (NSString *)areaId type:(NSString *)type;


/**
 首页合作伙伴列表

 @param provinceID 定位省份ID(可为空)
 @param areaID 定位城市id(可为空)
 */
- (void)getIndexPartnersWithProvinceID:(NSString *)provinceID areaID:(NSString *)areaID;


/**
 车辆总数据统计

 @param carNo 车牌号
 */
- (void)getCarAllStatWithCarNo: (NSString *)carNo;


/**
 车辆行驶日数据统计

 @param date 日期(默认今天)
 @param carNo 车牌号
 @param page 第几页(默认第一页)
 @param limit 向上每页几日(默认7日)
 */
- (void)getCarDayStatWithDate: (NSString *)date carNo: (NSString *)carNo page: (NSString *)page limit: (NSString *)limit;


/**
 车辆行驶周数据

 @param date 日期(默认今天)
 @param carNo 车牌号
 @param page 第几页(默认第一页)
 @param limit 向上每页几日(默认4周)
 */
- (void)getCarWeekStatWithDate: (NSString *)date carNo: (NSString *)carNo page: (NSString *)page limit: (NSString *)limit;

/**
 车辆行驶月数据
 
 @param date 日期(默认今天)
 @param carNo 车牌号
 @param page 第几页(默认第一页)
 @param limit 向上每页几月(默认4月)
 */
- (void)getCarMonthStatWithDate: (NSString *)date carNo: (NSString *)carNo page: (NSString *)page limit: (NSString *)limit;

/**
 C端用户反馈

 @param type 1:车况反馈 2:个人中心
 @param msg 反馈信息(不可为空)
 */
- (void)postUserAdviseAddsWithType: (NSString *)type msg: (NSString *)msg;


/**
 车况检测

 @param carNo 车牌号
 */
- (void)getCarStatusWithCarNo: (NSString *)carNo;



/**
 车辆行驶轨迹

 @param obdId OBD编号（string）
 @param date 日期（默认今天）（string）
 @param carNo 车牌号（string
 */
- (void)getCarObdTravelWithObdId: (NSString *)obdId date: (NSString *)date carNo: (NSString *)carNo;

/**
 车辆行驶时间轨迹
 
 @param obdId OBD编号（string）
 @param date 日期（默认今天）（string）
 @param carNo 车牌号（string
 */
- (void)getCarObdTravelTimeWithObdId: (NSString *)obdId date: (NSString *)date carNo: (NSString *)carNo;


/**
 C端获取里程宝月信息

 @param carNo 车牌号
 @param startDate 开始日期
 */
- (void)getCarMileMonthingWithCarNo: (NSString *)carNo startDate:(NSString *)startDate;


/**
 车辆月碳排统计

 @param carId 车辆ID（string）
 @param month 日期（默认今天,格式：年-月-日）
 */
- (void)getMonthCarbonWithCarId: (NSString *)carId month: (NSString *)month;


/**
 车辆碳排节省

 @param carNo 车牌号
 */
- (void)getSaveCarbonWithCarNo: (NSString *)carNo;


/**
 车辆耗油分布统计

 @param obdId OBD编号（string）
 @param date 日期（默认今天）（string）
 @param carNo 车牌号（string
 @param listsType 列表类型（1-天 2-月，默认为1）
 */
- (void)getOilListsWithObdId: (NSString *)obdId date: (NSString *)date carNo: (NSString *)carNo listsType: (NSString *)listsType;


/**
 C端首页收益信息

 @param carNO 车牌号（string）
 */
- (void)getProfitCarInfoWithCarNo: (NSString *)carNo;
@end
