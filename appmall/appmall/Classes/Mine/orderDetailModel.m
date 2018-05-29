//
//	orderDetailModel.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "orderDetailModel.h"

NSString *const korderDetailModelAddress = @"address";
NSString *const korderDetailModelConsignee = @"consignee";
NSString *const korderDetailModelGoodss = @"goodss";
NSString *const korderDetailModelLogistics = @"logistics";
NSString *const korderDetailModelMoney = @"money";
NSString *const korderDetailModelOrderId = @"orderId";
NSString *const korderDetailModelOrderNo = @"orderNo";
NSString *const korderDetailModelOrderTime = @"orderTime";
NSString *const korderDetailModelPayTime = @"payTime";
NSString *const korderDetailModelPhone = @"phone";
NSString *const korderDetailModelStatus = @"status";
NSString *const korderDetailModelTime = @"time";
NSString *const korderDetailModelTotalFee = @"totalFee";

@interface orderDetailModel ()
@end
@implementation orderDetailModel




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[korderDetailModelAddress] isKindOfClass:[NSNull class]]){
		self.address = dictionary[korderDetailModelAddress];
	}	
	if(![dictionary[korderDetailModelConsignee] isKindOfClass:[NSNull class]]){
		self.consignee = dictionary[korderDetailModelConsignee];
	}	
	if(dictionary[korderDetailModelGoodss] != nil && [dictionary[korderDetailModelGoodss] isKindOfClass:[NSArray class]]){
		NSArray * goodssDictionaries = dictionary[korderDetailModelGoodss];
		NSMutableArray * goodssItems = [NSMutableArray array];
		for(NSDictionary * goodssDictionary in goodssDictionaries){
			Goods * goodssItem = [[Goods alloc] initWithDictionary:goodssDictionary];
			[goodssItems addObject:goodssItem];
		}
		self.goodss = goodssItems;
	}
	if(![dictionary[korderDetailModelLogistics] isKindOfClass:[NSNull class]]){
		self.logistics = dictionary[korderDetailModelLogistics];
	}	
	if(![dictionary[korderDetailModelMoney] isKindOfClass:[NSNull class]]){
		self.money = dictionary[korderDetailModelMoney];
	}	
	if(![dictionary[korderDetailModelOrderId] isKindOfClass:[NSNull class]]){
		self.orderId = dictionary[korderDetailModelOrderId];
	}	
	if(![dictionary[korderDetailModelOrderNo] isKindOfClass:[NSNull class]]){
		self.orderNo = dictionary[korderDetailModelOrderNo];
	}	
	if(![dictionary[korderDetailModelOrderTime] isKindOfClass:[NSNull class]]){
		self.orderTime = dictionary[korderDetailModelOrderTime];
	}	
	if(![dictionary[korderDetailModelPayTime] isKindOfClass:[NSNull class]]){
		self.payTime = dictionary[korderDetailModelPayTime];
	}	
	if(![dictionary[korderDetailModelPhone] isKindOfClass:[NSNull class]]){
		self.phone = dictionary[korderDetailModelPhone];
	}	
	if(![dictionary[korderDetailModelStatus] isKindOfClass:[NSNull class]]){
		self.status = dictionary[korderDetailModelStatus];
	}	
	if(![dictionary[korderDetailModelTime] isKindOfClass:[NSNull class]]){
		self.time = dictionary[korderDetailModelTime];
	}	
	if(![dictionary[korderDetailModelTotalFee] isKindOfClass:[NSNull class]]){
		self.totalFee = dictionary[korderDetailModelTotalFee];
	}	
	return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	if(self.address != nil){
		dictionary[korderDetailModelAddress] = self.address;
	}
	if(self.consignee != nil){
		dictionary[korderDetailModelConsignee] = self.consignee;
	}
	if(self.goodss != nil){
		NSMutableArray * dictionaryElements = [NSMutableArray array];
		for(Goods * goodssElement in self.goodss){
			[dictionaryElements addObject:[goodssElement toDictionary]];
		}
		dictionary[korderDetailModelGoodss] = dictionaryElements;
	}
	if(self.logistics != nil){
		dictionary[korderDetailModelLogistics] = self.logistics;
	}
	if(self.money != nil){
		dictionary[korderDetailModelMoney] = self.money;
	}
	if(self.orderId != nil){
		dictionary[korderDetailModelOrderId] = self.orderId;
	}
	if(self.orderNo != nil){
		dictionary[korderDetailModelOrderNo] = self.orderNo;
	}
	if(self.orderTime != nil){
		dictionary[korderDetailModelOrderTime] = self.orderTime;
	}
	if(self.payTime != nil){
		dictionary[korderDetailModelPayTime] = self.payTime;
	}
	if(self.phone != nil){
		dictionary[korderDetailModelPhone] = self.phone;
	}
	if(self.status != nil){
		dictionary[korderDetailModelStatus] = self.status;
	}
	if(self.time != nil){
		dictionary[korderDetailModelTime] = self.time;
	}
	if(self.totalFee != nil){
		dictionary[korderDetailModelTotalFee] = self.totalFee;
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
	if(self.address != nil){
		[aCoder encodeObject:self.address forKey:korderDetailModelAddress];
	}
	if(self.consignee != nil){
		[aCoder encodeObject:self.consignee forKey:korderDetailModelConsignee];
	}
	if(self.goodss != nil){
		[aCoder encodeObject:self.goodss forKey:korderDetailModelGoodss];
	}
	if(self.logistics != nil){
		[aCoder encodeObject:self.logistics forKey:korderDetailModelLogistics];
	}
	if(self.money != nil){
		[aCoder encodeObject:self.money forKey:korderDetailModelMoney];
	}
	if(self.orderId != nil){
		[aCoder encodeObject:self.orderId forKey:korderDetailModelOrderId];
	}
	if(self.orderNo != nil){
		[aCoder encodeObject:self.orderNo forKey:korderDetailModelOrderNo];
	}
	if(self.orderTime != nil){
		[aCoder encodeObject:self.orderTime forKey:korderDetailModelOrderTime];
	}
	if(self.payTime != nil){
		[aCoder encodeObject:self.payTime forKey:korderDetailModelPayTime];
	}
	if(self.phone != nil){
		[aCoder encodeObject:self.phone forKey:korderDetailModelPhone];
	}
	if(self.status != nil){
		[aCoder encodeObject:self.status forKey:korderDetailModelStatus];
	}
	if(self.time != nil){
		[aCoder encodeObject:self.time forKey:korderDetailModelTime];
	}
	if(self.totalFee != nil){
		[aCoder encodeObject:self.totalFee forKey:korderDetailModelTotalFee];
	}

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.address = [aDecoder decodeObjectForKey:korderDetailModelAddress];
	self.consignee = [aDecoder decodeObjectForKey:korderDetailModelConsignee];
	self.goodss = [aDecoder decodeObjectForKey:korderDetailModelGoodss];
	self.logistics = [aDecoder decodeObjectForKey:korderDetailModelLogistics];
	self.money = [aDecoder decodeObjectForKey:korderDetailModelMoney];
	self.orderId = [aDecoder decodeObjectForKey:korderDetailModelOrderId];
	self.orderNo = [aDecoder decodeObjectForKey:korderDetailModelOrderNo];
	self.orderTime = [aDecoder decodeObjectForKey:korderDetailModelOrderTime];
	self.payTime = [aDecoder decodeObjectForKey:korderDetailModelPayTime];
	self.phone = [aDecoder decodeObjectForKey:korderDetailModelPhone];
	self.status = [aDecoder decodeObjectForKey:korderDetailModelStatus];
	self.time = [aDecoder decodeObjectForKey:korderDetailModelTime];
	self.totalFee = [aDecoder decodeObjectForKey:korderDetailModelTotalFee];
	return self;

}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
	orderDetailModel *copy = [orderDetailModel new];

	copy.address = [self.address copy];
	copy.consignee = [self.consignee copy];
	copy.goodss = [self.goodss copy];
	copy.logistics = [self.logistics copy];
	copy.money = [self.money copy];
	copy.orderId = [self.orderId copy];
	copy.orderNo = [self.orderNo copy];
	copy.orderTime = [self.orderTime copy];
	copy.payTime = [self.payTime copy];
	copy.phone = [self.phone copy];
	copy.status = [self.status copy];
	copy.time = [self.time copy];
	copy.totalFee = [self.totalFee copy];

	return copy;
}
@end