#import <UIKit/UIKit.h>

@interface Goods : NSObject

@property (nonatomic, assign) NSInteger feedback;
@property (nonatomic, strong) NSString * isgift;
@property (nonatomic, strong) NSString * itemid;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * number;
@property (nonatomic, strong) NSString * picture;
@property (nonatomic, strong) NSString * price;
@property (nonatomic, strong) NSString * specification;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end