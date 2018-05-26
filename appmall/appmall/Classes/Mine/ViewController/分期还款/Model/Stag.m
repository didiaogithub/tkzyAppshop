//
//	Stag.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "Stag.h"

NSString *const kStagFee = @"fee";
NSString *const kStagOrdermoney = @"ordermoney";
NSString *const kStagPaybackTime = @"payback_time";
NSString *const kStagPaymethod = @"paymethod";
NSString *const kStagPaymoney = @"paymoney";
NSString *const kStagPaystatus = @"paystatus";
NSString *const kStagPaytime = @"paytime";
NSString *const kStagPaytn = @"paytn";

@interface Stag ()
@end
@implementation Stag




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kStagFee] isKindOfClass:[NSNull class]]){
		self.fee = dictionary[kStagFee];
	}	
	if(![dictionary[kStagOrdermoney] isKindOfClass:[NSNull class]]){
		self.ordermoney = dictionary[kStagOrdermoney];
	}	
	if(![dictionary[kStagPaybackTime] isKindOfClass:[NSNull class]]){
		self.paybackTime = dictionary[kStagPaybackTime];
	}	
	if(![dictionary[kStagPaymethod] isKindOfClass:[NSNull class]]){
		self.paymethod = dictionary[kStagPaymethod];
	}	
	if(![dictionary[kStagPaymoney] isKindOfClass:[NSNull class]]){
		self.paymoney = dictionary[kStagPaymoney];
	}	
	if(![dictionary[kStagPaystatus] isKindOfClass:[NSNull class]]){
		self.paystatus = dictionary[kStagPaystatus];
	}	
	if(![dictionary[kStagPaytime] isKindOfClass:[NSNull class]]){
		self.paytime = dictionary[kStagPaytime];
	}	
	if(![dictionary[kStagPaytn] isKindOfClass:[NSNull class]]){
		self.paytn = dictionary[kStagPaytn];
	}	
	return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	if(self.fee != nil){
		dictionary[kStagFee] = self.fee;
	}
	if(self.ordermoney != nil){
		dictionary[kStagOrdermoney] = self.ordermoney;
	}
	if(self.paybackTime != nil){
		dictionary[kStagPaybackTime] = self.paybackTime;
	}
	if(self.paymethod != nil){
		dictionary[kStagPaymethod] = self.paymethod;
	}
	if(self.paymoney != nil){
		dictionary[kStagPaymoney] = self.paymoney;
	}
	if(self.paystatus != nil){
		dictionary[kStagPaystatus] = self.paystatus;
	}
	if(self.paytime != nil){
		dictionary[kStagPaytime] = self.paytime;
	}
	if(self.paytn != nil){
		dictionary[kStagPaytn] = self.paytn;
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
	if(self.fee != nil){
		[aCoder encodeObject:self.fee forKey:kStagFee];
	}
	if(self.ordermoney != nil){
		[aCoder encodeObject:self.ordermoney forKey:kStagOrdermoney];
	}
	if(self.paybackTime != nil){
		[aCoder encodeObject:self.paybackTime forKey:kStagPaybackTime];
	}
	if(self.paymethod != nil){
		[aCoder encodeObject:self.paymethod forKey:kStagPaymethod];
	}
	if(self.paymoney != nil){
		[aCoder encodeObject:self.paymoney forKey:kStagPaymoney];
	}
	if(self.paystatus != nil){
		[aCoder encodeObject:self.paystatus forKey:kStagPaystatus];
	}
	if(self.paytime != nil){
		[aCoder encodeObject:self.paytime forKey:kStagPaytime];
	}
	if(self.paytn != nil){
		[aCoder encodeObject:self.paytn forKey:kStagPaytn];
	}

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.fee = [aDecoder decodeObjectForKey:kStagFee];
	self.ordermoney = [aDecoder decodeObjectForKey:kStagOrdermoney];
	self.paybackTime = [aDecoder decodeObjectForKey:kStagPaybackTime];
	self.paymethod = [aDecoder decodeObjectForKey:kStagPaymethod];
	self.paymoney = [aDecoder decodeObjectForKey:kStagPaymoney];
	self.paystatus = [aDecoder decodeObjectForKey:kStagPaystatus];
	self.paytime = [aDecoder decodeObjectForKey:kStagPaytime];
	self.paytn = [aDecoder decodeObjectForKey:kStagPaytn];
	return self;

}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
	Stag *copy = [Stag new];

	copy.fee = [self.fee copy];
	copy.ordermoney = [self.ordermoney copy];
	copy.paybackTime = [self.paybackTime copy];
	copy.paymethod = [self.paymethod copy];
	copy.paymoney = [self.paymoney copy];
	copy.paystatus = [self.paystatus copy];
	copy.paytime = [self.paytime copy];
	copy.paytn = [self.paytn copy];

	return copy;
}
@end