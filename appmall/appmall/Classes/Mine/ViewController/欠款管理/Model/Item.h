#import <UIKit/UIKit.h>

@interface Item : NSObject

@property (nonatomic, strong) NSString * batch;
@property (nonatomic, strong) NSString * count;
@property (nonatomic, strong) NSString * itemid;
@property (nonatomic, strong) NSString * itemno;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * path1;
@property (nonatomic, strong) NSString * price;
@property (nonatomic, strong) NSString * spec;


-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end
