#import <UIKit/UIKit.h>
#import "Item.h"

@interface arrearsModel : NSObject

@property (nonatomic, strong) NSArray * items;
@property (nonatomic, assign) NSInteger limittime;
@property (nonatomic, strong) NSString * orderid;
@property (nonatomic, strong) NSString * ordermoney;
@property (nonatomic, strong) NSString * orderno;
@property (nonatomic, strong) NSString * paybacktime;
@property (nonatomic, assign) NSInteger serviceCharge;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSString * statusLabel;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end
