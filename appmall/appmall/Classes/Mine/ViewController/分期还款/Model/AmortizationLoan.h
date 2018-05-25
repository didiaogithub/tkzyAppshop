#import <UIKit/UIKit.h>
#import "Stag.h"

@interface AmortizationLoan : NSObject

@property (nonatomic, strong) NSString * no;
@property (nonatomic, strong) NSString * orderid;
@property (nonatomic, strong) NSString * stagCount;
@property (nonatomic, strong) NSString * stagRemainTime;
@property (nonatomic, strong) NSArray * stags;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end