//
//	Goods.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "Goods.h"

NSString *const kGoodsFeedback = @"feedback";
NSString *const kGoodsIsgift = @"isgift";
NSString *const kGoodsItemid = @"itemid";
NSString *const kGoodsName = @"name";
NSString *const kGoodsNumber = @"number";
NSString *const kGoodsPicture = @"picture";
NSString *const kGoodsPrice = @"price";
NSString *const kGoodsSpecification = @"specification";

@interface Goods ()
@end
@implementation Goods




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kGoodsFeedback] isKindOfClass:[NSNull class]]){
		self.feedback = [dictionary[kGoodsFeedback] integerValue];
	}

	if(![dictionary[kGoodsIsgift] isKindOfClass:[NSNull class]]){
		self.isgift = dictionary[kGoodsIsgift];
	}	
	if(![dictionary[kGoodsItemid] isKindOfClass:[NSNull class]]){
		self.itemid = dictionary[kGoodsItemid];
	}	
	if(![dictionary[kGoodsName] isKindOfClass:[NSNull class]]){
		self.name = dictionary[kGoodsName];
	}	
	if(![dictionary[kGoodsNumber] isKindOfClass:[NSNull class]]){
		self.number = dictionary[kGoodsNumber];
	}	
	if(![dictionary[kGoodsPicture] isKindOfClass:[NSNull class]]){
		self.picture = dictionary[kGoodsPicture];
	}	
	if(![dictionary[kGoodsPrice] isKindOfClass:[NSNull class]]){
		self.price = dictionary[kGoodsPrice];
	}	
	if(![dictionary[kGoodsSpecification] isKindOfClass:[NSNull class]]){
		self.specification = dictionary[kGoodsSpecification];
	}	
	return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	dictionary[kGoodsFeedback] = @(self.feedback);
	if(self.isgift != nil){
		dictionary[kGoodsIsgift] = self.isgift;
	}
	if(self.itemid != nil){
		dictionary[kGoodsItemid] = self.itemid;
	}
	if(self.name != nil){
		dictionary[kGoodsName] = self.name;
	}
	if(self.number != nil){
		dictionary[kGoodsNumber] = self.number;
	}
	if(self.picture != nil){
		dictionary[kGoodsPicture] = self.picture;
	}
	if(self.price != nil){
		dictionary[kGoodsPrice] = self.price;
	}
	if(self.specification != nil){
		dictionary[kGoodsSpecification] = self.specification;
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
	[aCoder encodeObject:@(self.feedback) forKey:kGoodsFeedback];	if(self.isgift != nil){
		[aCoder encodeObject:self.isgift forKey:kGoodsIsgift];
	}
	if(self.itemid != nil){
		[aCoder encodeObject:self.itemid forKey:kGoodsItemid];
	}
	if(self.name != nil){
		[aCoder encodeObject:self.name forKey:kGoodsName];
	}
	if(self.number != nil){
		[aCoder encodeObject:self.number forKey:kGoodsNumber];
	}
	if(self.picture != nil){
		[aCoder encodeObject:self.picture forKey:kGoodsPicture];
	}
	if(self.price != nil){
		[aCoder encodeObject:self.price forKey:kGoodsPrice];
	}
	if(self.specification != nil){
		[aCoder encodeObject:self.specification forKey:kGoodsSpecification];
	}

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.feedback = [[aDecoder decodeObjectForKey:kGoodsFeedback] integerValue];
	self.isgift = [aDecoder decodeObjectForKey:kGoodsIsgift];
	self.itemid = [aDecoder decodeObjectForKey:kGoodsItemid];
	self.name = [aDecoder decodeObjectForKey:kGoodsName];
	self.number = [aDecoder decodeObjectForKey:kGoodsNumber];
	self.picture = [aDecoder decodeObjectForKey:kGoodsPicture];
	self.price = [aDecoder decodeObjectForKey:kGoodsPrice];
	self.specification = [aDecoder decodeObjectForKey:kGoodsSpecification];
	return self;

}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
	Goods *copy = [Goods new];

	copy.feedback = self.feedback;
	copy.isgift = [self.isgift copy];
	copy.itemid = [self.itemid copy];
	copy.name = [self.name copy];
	copy.number = [self.number copy];
	copy.picture = [self.picture copy];
	copy.price = [self.price copy];
	copy.specification = [self.specification copy];

	return copy;
}
@end