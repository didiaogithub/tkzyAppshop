//
//	arrearsModel.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "arrearsModel.h"

NSString *const karrearsModelItems = @"items";
NSString *const karrearsModelLimittime = @"limittime";
NSString *const karrearsModelOrderid = @"orderid";
NSString *const karrearsModelOrdermoney = @"ordermoney";
NSString *const karrearsModelOrderno = @"orderno";
NSString *const karrearsModelPaybacktime = @"paybacktime";
NSString *const karrearsModelServiceCharge = @"service_charge";
NSString *const karrearsModelStatus = @"status";
NSString *const karrearsModelStatusLabel = @"statusLabel";

@interface arrearsModel ()
@end
@implementation arrearsModel




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(dictionary[karrearsModelItems] != nil && [dictionary[karrearsModelItems] isKindOfClass:[NSArray class]]){
		NSArray * itemsDictionaries = dictionary[karrearsModelItems];
		NSMutableArray * itemsItems = [NSMutableArray array];
		for(NSDictionary * itemsDictionary in itemsDictionaries){
			Item * itemsItem = [[Item alloc] initWithDictionary:itemsDictionary];
			[itemsItems addObject:itemsItem];
		}
		self.items = itemsItems;
	}
    if(![dictionary[karrearsModelLimittime] isKindOfClass:[NSNull class]]){
        self.limittime = [dictionary[karrearsModelLimittime] integerValue];
    }

	if(![dictionary[karrearsModelOrderid] isKindOfClass:[NSNull class]]){
		self.orderid = dictionary[karrearsModelOrderid];
	}	
	if(![dictionary[karrearsModelOrdermoney] isKindOfClass:[NSNull class]]){
		self.ordermoney = dictionary[karrearsModelOrdermoney];
	}	
	if(![dictionary[karrearsModelOrderno] isKindOfClass:[NSNull class]]){
		self.orderno = dictionary[karrearsModelOrderno];
	}	
	if(![dictionary[karrearsModelPaybacktime] isKindOfClass:[NSNull class]]){
		self.paybacktime = dictionary[karrearsModelPaybacktime];
	}	
	if(![dictionary[karrearsModelServiceCharge] isKindOfClass:[NSNull class]]){
		self.serviceCharge = [dictionary[karrearsModelServiceCharge] integerValue];
	}

	if(![dictionary[karrearsModelStatus] isKindOfClass:[NSNull class]]){
		self.status = [dictionary[karrearsModelStatus] integerValue];
	}

	if(![dictionary[karrearsModelStatusLabel] isKindOfClass:[NSNull class]]){
		self.statusLabel = dictionary[karrearsModelStatusLabel];
	}	
	return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	if(self.items != nil){
		NSMutableArray * dictionaryElements = [NSMutableArray array];
		for(Item * itemsElement in self.items){
			[dictionaryElements addObject:[itemsElement toDictionary]];
		}
		dictionary[karrearsModelItems] = dictionaryElements;
	}
        dictionary[karrearsModelLimittime] = @(self.limittime);
	if(self.orderid != nil){
		dictionary[karrearsModelOrderid] = self.orderid;
	}
	if(self.ordermoney != nil){
		dictionary[karrearsModelOrdermoney] = self.ordermoney;
	}
	if(self.orderno != nil){
		dictionary[karrearsModelOrderno] = self.orderno;
	}
	if(self.paybacktime != nil){
		dictionary[karrearsModelPaybacktime] = self.paybacktime;
	}
	dictionary[karrearsModelServiceCharge] = @(self.serviceCharge);
	dictionary[karrearsModelStatus] = @(self.status);
	if(self.statusLabel != nil){
		dictionary[karrearsModelStatusLabel] = self.statusLabel;
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
    [aCoder encodeObject:@(self.limittime) forKey:karrearsModelLimittime];
	if(self.items != nil){
		[aCoder encodeObject:self.items forKey:karrearsModelItems];
	}
	if(self.orderid != nil){
		[aCoder encodeObject:self.orderid forKey:karrearsModelOrderid];
	}
	if(self.ordermoney != nil){
		[aCoder encodeObject:self.ordermoney forKey:karrearsModelOrdermoney];
	}
	if(self.orderno != nil){
		[aCoder encodeObject:self.orderno forKey:karrearsModelOrderno];
	}
	if(self.paybacktime != nil){
		[aCoder encodeObject:self.paybacktime forKey:karrearsModelPaybacktime];
	}
	[aCoder encodeObject:@(self.serviceCharge) forKey:karrearsModelServiceCharge];	[aCoder encodeObject:@(self.status) forKey:karrearsModelStatus];	if(self.statusLabel != nil){
		[aCoder encodeObject:self.statusLabel forKey:karrearsModelStatusLabel];
	}

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.items = [aDecoder decodeObjectForKey:karrearsModelItems];
    self.limittime = [[aDecoder decodeObjectForKey:karrearsModelLimittime] integerValue];
	self.orderid = [aDecoder decodeObjectForKey:karrearsModelOrderid];
	self.ordermoney = [aDecoder decodeObjectForKey:karrearsModelOrdermoney];
	self.orderno = [aDecoder decodeObjectForKey:karrearsModelOrderno];
	self.paybacktime = [aDecoder decodeObjectForKey:karrearsModelPaybacktime];
	self.serviceCharge = [[aDecoder decodeObjectForKey:karrearsModelServiceCharge] integerValue];
	self.status = [[aDecoder decodeObjectForKey:karrearsModelStatus] integerValue];
	self.statusLabel = [aDecoder decodeObjectForKey:karrearsModelStatusLabel];
	return self;

}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
	arrearsModel *copy = [arrearsModel new];

	copy.items = [self.items copy];
    copy.limittime = self.limittime;
	copy.orderid = [self.orderid copy];
	copy.ordermoney = [self.ordermoney copy];
	copy.orderno = [self.orderno copy];
	copy.paybacktime = [self.paybacktime copy];
	copy.serviceCharge = self.serviceCharge;
	copy.status = self.status;
	copy.statusLabel = [self.statusLabel copy];

	return copy;
}
@end
