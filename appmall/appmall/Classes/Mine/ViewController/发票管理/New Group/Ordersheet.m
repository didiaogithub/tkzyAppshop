//
//	Ordersheet.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "Ordersheet.h"

NSString *const kOrdersheetCount = @"count";
NSString *const kOrdersheetImgurl = @"imgurl";
NSString *const kOrdersheetItemid = @"itemid";
NSString *const kOrdersheetItemno = @"itemno";
NSString *const kOrdersheetItemspec = @"itemspec";
NSString *const kOrdersheetName = @"name";
NSString *const kOrdersheetPrice = @"price";

@interface Ordersheet ()
@end
@implementation Ordersheet




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kOrdersheetCount] isKindOfClass:[NSNull class]]){
		self.count = dictionary[kOrdersheetCount];
	}	
	if(![dictionary[kOrdersheetImgurl] isKindOfClass:[NSNull class]]){
		self.imgurl = dictionary[kOrdersheetImgurl];
	}	
	if(![dictionary[kOrdersheetItemid] isKindOfClass:[NSNull class]]){
		self.itemid = dictionary[kOrdersheetItemid];
	}	
	if(![dictionary[kOrdersheetItemno] isKindOfClass:[NSNull class]]){
		self.itemno = dictionary[kOrdersheetItemno];
	}	
	if(![dictionary[kOrdersheetItemspec] isKindOfClass:[NSNull class]]){
		self.itemspec = dictionary[kOrdersheetItemspec];
	}	
	if(![dictionary[kOrdersheetName] isKindOfClass:[NSNull class]]){
		self.name = dictionary[kOrdersheetName];
	}	
	if(![dictionary[kOrdersheetPrice] isKindOfClass:[NSNull class]]){
		self.price = dictionary[kOrdersheetPrice];
	}	
	return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	if(self.count != nil){
		dictionary[kOrdersheetCount] = self.count;
	}
	if(self.imgurl != nil){
		dictionary[kOrdersheetImgurl] = self.imgurl;
	}
	if(self.itemid != nil){
		dictionary[kOrdersheetItemid] = self.itemid;
	}
	if(self.itemno != nil){
		dictionary[kOrdersheetItemno] = self.itemno;
	}
	if(self.itemspec != nil){
		dictionary[kOrdersheetItemspec] = self.itemspec;
	}
	if(self.name != nil){
		dictionary[kOrdersheetName] = self.name;
	}
	if(self.price != nil){
		dictionary[kOrdersheetPrice] = self.price;
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
	if(self.count != nil){
		[aCoder encodeObject:self.count forKey:kOrdersheetCount];
	}
	if(self.imgurl != nil){
		[aCoder encodeObject:self.imgurl forKey:kOrdersheetImgurl];
	}
	if(self.itemid != nil){
		[aCoder encodeObject:self.itemid forKey:kOrdersheetItemid];
	}
	if(self.itemno != nil){
		[aCoder encodeObject:self.itemno forKey:kOrdersheetItemno];
	}
	if(self.itemspec != nil){
		[aCoder encodeObject:self.itemspec forKey:kOrdersheetItemspec];
	}
	if(self.name != nil){
		[aCoder encodeObject:self.name forKey:kOrdersheetName];
	}
	if(self.price != nil){
		[aCoder encodeObject:self.price forKey:kOrdersheetPrice];
	}

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.count = [aDecoder decodeObjectForKey:kOrdersheetCount];
	self.imgurl = [aDecoder decodeObjectForKey:kOrdersheetImgurl];
	self.itemid = [aDecoder decodeObjectForKey:kOrdersheetItemid];
	self.itemno = [aDecoder decodeObjectForKey:kOrdersheetItemno];
	self.itemspec = [aDecoder decodeObjectForKey:kOrdersheetItemspec];
	self.name = [aDecoder decodeObjectForKey:kOrdersheetName];
	self.price = [aDecoder decodeObjectForKey:kOrdersheetPrice];
	return self;

}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
	Ordersheet *copy = [Ordersheet new];

	copy.count = [self.count copy];
	copy.imgurl = [self.imgurl copy];
	copy.itemid = [self.itemid copy];
	copy.itemno = [self.itemno copy];
	copy.itemspec = [self.itemspec copy];
	copy.name = [self.name copy];
	copy.price = [self.price copy];

	return copy;
}
@end