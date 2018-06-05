//
//	OpenInvoiceModel.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "OpenInvoiceModel.h"

NSString *const kOpenInvoiceModelAddress = @"address";
NSString *const kOpenInvoiceModelAllprice = @"allprice";
NSString *const kOpenInvoiceModelBankname = @"bankname";
NSString *const kOpenInvoiceModelCardno = @"cardno";
NSString *const kOpenInvoiceModelContent = @"content";
NSString *const kOpenInvoiceModelInvoiceheadtype = @"invoiceheadtype";
NSString *const kOpenInvoiceModelInvoicetype = @"invoicetype";
NSString *const kOpenInvoiceModelIssuingoffice = @"issuingoffice";
NSString *const kOpenInvoiceModelMobile = @"mobile";
NSString *const kOpenInvoiceModelNumber = @"number";
NSString *const kOpenInvoiceModelOrderno = @"orderno";
NSString *const kOpenInvoiceModelProve = @"prove";
NSString *const kOpenInvoiceModelTempid = @"tempid";

@interface OpenInvoiceModel ()
@end
@implementation OpenInvoiceModel




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kOpenInvoiceModelAddress] isKindOfClass:[NSNull class]]){
		self.address = dictionary[kOpenInvoiceModelAddress];
	}	
	if(![dictionary[kOpenInvoiceModelAllprice] isKindOfClass:[NSNull class]]){
		self.allprice = dictionary[kOpenInvoiceModelAllprice];
	}	
	if(![dictionary[kOpenInvoiceModelBankname] isKindOfClass:[NSNull class]]){
		self.bankname = dictionary[kOpenInvoiceModelBankname];
	}	
	if(![dictionary[kOpenInvoiceModelCardno] isKindOfClass:[NSNull class]]){
		self.cardno = dictionary[kOpenInvoiceModelCardno];
	}	
	if(![dictionary[kOpenInvoiceModelContent] isKindOfClass:[NSNull class]]){
		self.content = dictionary[kOpenInvoiceModelContent];
	}	
	if(![dictionary[kOpenInvoiceModelInvoiceheadtype] isKindOfClass:[NSNull class]]){
		self.invoiceheadtype = dictionary[kOpenInvoiceModelInvoiceheadtype];
	}	
	if(![dictionary[kOpenInvoiceModelInvoicetype] isKindOfClass:[NSNull class]]){
		self.invoicetype = dictionary[kOpenInvoiceModelInvoicetype];
	}	
	if(![dictionary[kOpenInvoiceModelIssuingoffice] isKindOfClass:[NSNull class]]){
		self.issuingoffice = dictionary[kOpenInvoiceModelIssuingoffice];
	}	
	if(![dictionary[kOpenInvoiceModelMobile] isKindOfClass:[NSNull class]]){
		self.mobile = dictionary[kOpenInvoiceModelMobile];
	}	
	if(![dictionary[kOpenInvoiceModelNumber] isKindOfClass:[NSNull class]]){
		self.number = dictionary[kOpenInvoiceModelNumber];
	}	
	if(![dictionary[kOpenInvoiceModelOrderno] isKindOfClass:[NSNull class]]){
		self.orderno = dictionary[kOpenInvoiceModelOrderno];
	}	
	if(![dictionary[kOpenInvoiceModelProve] isKindOfClass:[NSNull class]]){
		self.prove = dictionary[kOpenInvoiceModelProve];
	}	
	if(![dictionary[kOpenInvoiceModelTempid] isKindOfClass:[NSNull class]]){
		self.tempid = dictionary[kOpenInvoiceModelTempid];
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
		dictionary[kOpenInvoiceModelAddress] = self.address;
	}
	if(self.allprice != nil){
		dictionary[kOpenInvoiceModelAllprice] = self.allprice;
	}
	if(self.bankname != nil){
		dictionary[kOpenInvoiceModelBankname] = self.bankname;
	}
	if(self.cardno != nil){
		dictionary[kOpenInvoiceModelCardno] = self.cardno;
	}
	if(self.content != nil){
		dictionary[kOpenInvoiceModelContent] = self.content;
	}
	if(self.invoiceheadtype != nil){
		dictionary[kOpenInvoiceModelInvoiceheadtype] = self.invoiceheadtype;
	}
	if(self.invoicetype != nil){
		dictionary[kOpenInvoiceModelInvoicetype] = self.invoicetype;
	}
	if(self.issuingoffice != nil){
		dictionary[kOpenInvoiceModelIssuingoffice] = self.issuingoffice;
	}
	if(self.mobile != nil){
		dictionary[kOpenInvoiceModelMobile] = self.mobile;
	}
	if(self.number != nil){
		dictionary[kOpenInvoiceModelNumber] = self.number;
	}
	if(self.orderno != nil){
		dictionary[kOpenInvoiceModelOrderno] = self.orderno;
	}
	if(self.prove != nil){
		dictionary[kOpenInvoiceModelProve] = self.prove;
	}
	if(self.tempid != nil){
		dictionary[kOpenInvoiceModelTempid] = self.tempid;
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
		[aCoder encodeObject:self.address forKey:kOpenInvoiceModelAddress];
	}
	if(self.allprice != nil){
		[aCoder encodeObject:self.allprice forKey:kOpenInvoiceModelAllprice];
	}
	if(self.bankname != nil){
		[aCoder encodeObject:self.bankname forKey:kOpenInvoiceModelBankname];
	}
	if(self.cardno != nil){
		[aCoder encodeObject:self.cardno forKey:kOpenInvoiceModelCardno];
	}
	if(self.content != nil){
		[aCoder encodeObject:self.content forKey:kOpenInvoiceModelContent];
	}
	if(self.invoiceheadtype != nil){
		[aCoder encodeObject:self.invoiceheadtype forKey:kOpenInvoiceModelInvoiceheadtype];
	}
	if(self.invoicetype != nil){
		[aCoder encodeObject:self.invoicetype forKey:kOpenInvoiceModelInvoicetype];
	}
	if(self.issuingoffice != nil){
		[aCoder encodeObject:self.issuingoffice forKey:kOpenInvoiceModelIssuingoffice];
	}
	if(self.mobile != nil){
		[aCoder encodeObject:self.mobile forKey:kOpenInvoiceModelMobile];
	}
	if(self.number != nil){
		[aCoder encodeObject:self.number forKey:kOpenInvoiceModelNumber];
	}
	if(self.orderno != nil){
		[aCoder encodeObject:self.orderno forKey:kOpenInvoiceModelOrderno];
	}
	if(self.prove != nil){
		[aCoder encodeObject:self.prove forKey:kOpenInvoiceModelProve];
	}
	if(self.tempid != nil){
		[aCoder encodeObject:self.tempid forKey:kOpenInvoiceModelTempid];
	}

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.address = [aDecoder decodeObjectForKey:kOpenInvoiceModelAddress];
	self.allprice = [aDecoder decodeObjectForKey:kOpenInvoiceModelAllprice];
	self.bankname = [aDecoder decodeObjectForKey:kOpenInvoiceModelBankname];
	self.cardno = [aDecoder decodeObjectForKey:kOpenInvoiceModelCardno];
	self.content = [aDecoder decodeObjectForKey:kOpenInvoiceModelContent];
	self.invoiceheadtype = [aDecoder decodeObjectForKey:kOpenInvoiceModelInvoiceheadtype];
	self.invoicetype = [aDecoder decodeObjectForKey:kOpenInvoiceModelInvoicetype];
	self.issuingoffice = [aDecoder decodeObjectForKey:kOpenInvoiceModelIssuingoffice];
	self.mobile = [aDecoder decodeObjectForKey:kOpenInvoiceModelMobile];
	self.number = [aDecoder decodeObjectForKey:kOpenInvoiceModelNumber];
	self.orderno = [aDecoder decodeObjectForKey:kOpenInvoiceModelOrderno];
	self.prove = [aDecoder decodeObjectForKey:kOpenInvoiceModelProve];
	self.tempid = [aDecoder decodeObjectForKey:kOpenInvoiceModelTempid];
	return self;

}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
	OpenInvoiceModel *copy = [OpenInvoiceModel new];

	copy.address = [self.address copy];
	copy.allprice = [self.allprice copy];
	copy.bankname = [self.bankname copy];
	copy.cardno = [self.cardno copy];
	copy.content = [self.content copy];
	copy.invoiceheadtype = [self.invoiceheadtype copy];
	copy.invoicetype = [self.invoicetype copy];
	copy.issuingoffice = [self.issuingoffice copy];
	copy.mobile = [self.mobile copy];
	copy.number = [self.number copy];
	copy.orderno = [self.orderno copy];
	copy.prove = [self.prove copy];
	copy.tempid = [self.tempid copy];

	return copy;
}
@end