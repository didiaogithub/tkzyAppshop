#import <UIKit/UIKit.h>
#import "Ordersheet.h"

@interface InvoicesManagerModel : NSObject

@property (nonatomic, strong) NSString * orderType;
@property (nonatomic, strong) NSString * orderid;
@property (nonatomic, strong) NSString * ordermoney;
@property (nonatomic, strong) NSString * orderno;
@property (nonatomic, strong) NSString * orderpaymoney;
@property (nonatomic, strong) NSArray * ordersheet;
@property (nonatomic, strong) NSString * ordertime;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end