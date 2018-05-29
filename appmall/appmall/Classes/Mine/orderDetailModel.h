#import <UIKit/UIKit.h>
#import "Goods.h"

@interface orderDetailModel : NSObject

@property (nonatomic, strong) NSString * address;
@property (nonatomic, strong) NSString * consignee;
@property (nonatomic, strong) NSArray * goodss;
@property (nonatomic, strong) NSString * logistics;
@property (nonatomic, strong) NSString * money;
@property (nonatomic, strong) NSString * orderId;
@property (nonatomic, strong) NSString * orderNo;
@property (nonatomic, strong) NSString * orderTime;
@property (nonatomic, strong) NSString * payTime;
@property (nonatomic, strong) NSString * phone;
@property (nonatomic, strong) NSString * status;
@property (nonatomic, strong) NSString * time;
@property (nonatomic, strong) NSString * totalFee;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end