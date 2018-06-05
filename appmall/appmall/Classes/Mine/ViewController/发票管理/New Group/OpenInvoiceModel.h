#import <UIKit/UIKit.h>

@interface OpenInvoiceModel : NSObject

@property (nonatomic, strong) NSString * address;
@property (nonatomic, strong) NSString * allprice;
@property (nonatomic, strong) NSString * bankname;
@property (nonatomic, strong) NSString * cardno;
@property (nonatomic, strong) NSString * content;
@property (nonatomic, strong) NSString * invoiceheadtype;
@property (nonatomic, strong) NSString * invoicetype;
@property (nonatomic, strong) NSString * issuingoffice;
@property (nonatomic, strong) NSString * mobile;
@property (nonatomic, strong) NSString * number;
@property (nonatomic, strong) NSString * orderno;
@property (nonatomic, strong) NSString * prove;
@property (nonatomic, strong) NSString * tempid;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end