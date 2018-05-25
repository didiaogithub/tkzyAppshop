//
//	InvoicesManagerModel.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "InvoicesManagerModel.h"

NSString *const kInvoicesManagerModelOrderType = @"order_type";
NSString *const kInvoicesManagerModelOrderid = @"orderid";
NSString *const kInvoicesManagerModelOrdermoney = @"ordermoney";
NSString *const kInvoicesManagerModelOrderno = @"orderno";
NSString *const kInvoicesManagerModelOrderpaymoney = @"orderpaymoney";
NSString *const kInvoicesManagerModelOrdersheet = @"ordersheet";

@interface InvoicesManagerModel ()
@end
@implementation InvoicesManagerModel




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kInvoicesManagerModelOrderType] isKindOfClass:[NSNull class]]){
		self.orderType = dictionary[kInvoicesManagerModelOrderType];
	}	
	if(![dictionary[kInvoicesManagerModelOrderid] isKindOfClass:[NSNull class]]){
		self.orderid = dictionary[kInvoicesManagerModelOrderid];
	}	
	if(![dictionary[kInvoicesManagerModelOrdermoney] isKindOfClass:[NSNull class]]){
		self.ordermoney = dictionary[kInvoicesManagerModelOrdermoney];
	}	
	if(![dictionary[kInvoicesManagerModelOrderno] isKindOfClass:[NSNull class]]){
		self.orderno = dictionary[kInvoicesManagerModelOrderno];
	}	
	if(![dictionary[kInvoicesManagerModelOrderpaymoney] isKindOfClass:[NSNull class]]){
		self.orderpaymoney = dictionary[kInvoicesManagerModelOrderpaymoney];
	}	
	if(dictionary[kInvoicesManagerModelOrdersheet] != nil && [dictionary[kInvoicesManagerModelOrdersheet] isKindOfClass:[NSArray class]]){
		NSArray * ordersheetDictionaries = dictionary[kInvoicesManagerModelOrdersheet];
		NSMutableArray * ordersheetItems = [NSMutableArray array];
		for(NSDictionary * ordersheetDictionary in ordersheetDictionaries){
			Ordersheet * ordersheetItem = [[Ordersheet alloc] initWithDictionary:ordersheetDictionary];
			[ordersheetItems addObject:ordersheetItem];
		}
		self.ordersheet = ordersheetItems;
	}
	return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	if(self.orderType != nil){
		dictionary[kInvoicesManagerModelOrderType] = self.orderType;
	}
	if(self.orderid != nil){
		dictionary[kInvoicesManagerModelOrderid] = self.orderid;
	}
	if(self.ordermoney != nil){
		dictionary[kInvoicesManagerModelOrdermoney] = self.ordermoney;
	}
	if(self.orderno != nil){
		dictionary[kInvoicesManagerModelOrderno] = self.orderno;
	}
	if(self.orderpaymoney != nil){
		dictionary[kInvoicesManagerModelOrderpaymoney] = self.orderpaymoney;
	}
	if(self.ordersheet != nil){
		NSMutableArray * dictionaryElements = [NSMutableArray array];
		for(Ordersheet * ordersheetElement in self.ordersheet){
			[dictionaryElements addObject:[ordersheetElement toDictionary]];
		}
		dictionary[kInvoicesManagerModelOrdersheet] = dictionaryElements;
	}
	return dictionary;

}

/**
 * Implementation of NSCoding encoding method
 */
/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
- (void)encodeWithCoder:(NSCoder *)aCoder
{
	if(self.orderType != nil){
		[aCoder encodeObject:self.orderType forKey:kInvoicesManagerModelOrderType];
	}
	if(self.orderid != nil){
		[aCoder encodeObject:self.orderid forKey:kInvoicesManagerModelOrderid];
	}
	if(self.ordermoney != nil){
		[aCoder encodeObject:self.ordermoney forKey:kInvoicesManagerModelOrdermoney];
	}
	if(self.orderno != nil){
		[aCoder encodeObject:self.orderno forKey:kInvoicesManagerModelOrderno];
	}
	if(self.orderpaymoney != nil){
		[aCoder encodeObject:self.orderpaymoney forKey:kInvoicesManagerModelOrderpaymoney];
	}
	if(self.ordersheet != nil){
		[aCoder encodeObject:self.ordersheet forKey:kInvoicesManagerModelOrdersheet];
	}

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.orderType = [aDecoder decodeObjectForKey:kInvoicesManagerModelOrderType];
	self.orderid = [aDecoder decodeObjectForKey:kInvoicesManagerModelOrderid];
	self.ordermoney = [aDecoder decodeObjectForKey:kInvoicesManagerModelOrdermoney];
	self.orderno = [aDecoder decodeObjectForKey:kInvoicesManagerModelOrderno];
	self.orderpaymoney = [aDecoder decodeObjectForKey:kInvoicesManagerModelOrderpaymoney];
	self.ordersheet = [aDecoder decodeObjectForKey:kInvoicesManagerModelOrdersheet];
	return self;

}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
	InvoicesManagerModel *copy = [InvoicesManagerModel new];

	copy.orderType = [self.orderType copy];
	copy.orderid = [self.orderid copy];
	copy.ordermoney = [self.ordermoney copy];
	copy.orderno = [self.orderno copy];
	copy.orderpaymoney = [self.orderpaymoney copy];
	copy.ordersheet = [self.ordersheet copy];

	return copy;
}
@end