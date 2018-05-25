#import <UIKit/UIKit.h>

@interface Stag : NSObject

@property (nonatomic, strong) NSString * fee;
@property (nonatomic, strong) NSString * ordermoney;
@property (nonatomic, strong) NSString * paybackTime;
@property (nonatomic, strong) NSString * paymethod;
@property (nonatomic, strong) NSString * paymoney;
@property (nonatomic, strong) NSString * paystatus;
@property (nonatomic, strong) NSString * paytime;
@property (nonatomic, strong) NSString * paytn;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end