#import <UIKit/UIKit.h>

@interface Ordersheet : NSObject

@property (nonatomic, strong) NSString * count;
@property (nonatomic, strong) NSString * imgurl;
@property (nonatomic, strong) NSString * itemid;
@property (nonatomic, strong) NSString * itemno;
@property (nonatomic, strong) NSString * itemspec;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * price;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end