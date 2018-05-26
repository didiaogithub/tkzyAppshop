//
//	AmortizationLoan.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "AmortizationLoan.h"

NSString *const kAmortizationLoanNo = @"no";
NSString *const kAmortizationLoanOrderid = @"orderid";
NSString *const kAmortizationLoanStagCount = @"stag_count";
NSString *const kAmortizationLoanStagRemainTime = @"stag_remain_time";
NSString *const kAmortizationLoanStags = @"stags";

@interface AmortizationLoan ()
@end
@implementation AmortizationLoan




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kAmortizationLoanNo] isKindOfClass:[NSNull class]]){
		self.no = dictionary[kAmortizationLoanNo];
	}	
	if(![dictionary[kAmortizationLoanOrderid] isKindOfClass:[NSNull class]]){
		self.orderid = dictionary[kAmortizationLoanOrderid];
	}	
	if(![dictionary[kAmortizationLoanStagCount] isKindOfClass:[NSNull class]]){
		self.stagCount = dictionary[kAmortizationLoanStagCount];
	}	
	if(![dictionary[kAmortizationLoanStagRemainTime] isKindOfClass:[NSNull class]]){
		self.stagRemainTime = dictionary[kAmortizationLoanStagRemainTime];
	}	
	if(dictionary[kAmortizationLoanStags] != nil && [dictionary[kAmortizationLoanStags] isKindOfClass:[NSArray class]]){
		NSArray * stagsDictionaries = dictionary[kAmortizationLoanStags];
		NSMutableArray * stagsItems = [NSMutableArray array];
		for(NSDictionary * stagsDictionary in stagsDictionaries){
			Stag * stagsItem = [[Stag alloc] initWithDictionary:stagsDictionary];
			[stagsItems addObject:stagsItem];
		}
		self.stags = stagsItems;
	}
	return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	if(self.no != nil){
		dictionary[kAmortizationLoanNo] = self.no;
	}
	if(self.orderid != nil){
		dictionary[kAmortizationLoanOrderid] = self.orderid;
	}
	if(self.stagCount != nil){
		dictionary[kAmortizationLoanStagCount] = self.stagCount;
	}
	if(self.stagRemainTime != nil){
		dictionary[kAmortizationLoanStagRemainTime] = self.stagRemainTime;
	}
	if(self.stags != nil){
		NSMutableArray * dictionaryElements = [NSMutableArray array];
		for(Stag * stagsElement in self.stags){
			[dictionaryElements addObject:[stagsElement toDictionary]];
		}
		dictionary[kAmortizationLoanStags] = dictionaryElements;
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
	if(self.no != nil){
		[aCoder encodeObject:self.no forKey:kAmortizationLoanNo];
	}
	if(self.orderid != nil){
		[aCoder encodeObject:self.orderid forKey:kAmortizationLoanOrderid];
	}
	if(self.stagCount != nil){
		[aCoder encodeObject:self.stagCount forKey:kAmortizationLoanStagCount];
	}
	if(self.stagRemainTime != nil){
		[aCoder encodeObject:self.stagRemainTime forKey:kAmortizationLoanStagRemainTime];
	}
	if(self.stags != nil){
		[aCoder encodeObject:self.stags forKey:kAmortizationLoanStags];
	}

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.no = [aDecoder decodeObjectForKey:kAmortizationLoanNo];
	self.orderid = [aDecoder decodeObjectForKey:kAmortizationLoanOrderid];
	self.stagCount = [aDecoder decodeObjectForKey:kAmortizationLoanStagCount];
	self.stagRemainTime = [aDecoder decodeObjectForKey:kAmortizationLoanStagRemainTime];
	self.stags = [aDecoder decodeObjectForKey:kAmortizationLoanStags];
	return self;

}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
	AmortizationLoan *copy = [AmortizationLoan new];

	copy.no = [self.no copy];
	copy.orderid = [self.orderid copy];
	copy.stagCount = [self.stagCount copy];
	copy.stagRemainTime = [self.stagRemainTime copy];
	copy.stags = [self.stags copy];

	return copy;
}
@end