#import <UIKit/UIKit.h>
#import "Item.h"

@interface arrearsModel : NSObject

@property (nonatomic, strong) NSArray <Item *>* items;
@property (nonatomic, strong) NSString * no;
@property (nonatomic, strong) NSString * ordermoney;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end
