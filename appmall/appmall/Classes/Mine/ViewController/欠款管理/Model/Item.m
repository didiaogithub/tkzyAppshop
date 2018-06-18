//
//	Item.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "Item.h"

NSString *const kItemBatch = @"batch";
NSString *const kItemCount = @"count";
NSString *const kItemItemid = @"itemid";
NSString *const kItemItemno = @"itemno";
NSString *const kItemName = @"name";
NSString *const kItemPath1 = @"path1";
NSString *const kItemPrice = @"price";
NSString *const kItemSpec = @"spec";

@interface Item ()
@end
@implementation Item




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kItemBatch] isKindOfClass:[NSNull class]]){
		self.batch = dictionary[kItemBatch];
	}	
	if(![dictionary[kItemCount] isKindOfClass:[NSNull class]]){
		self.count = dictionary[kItemCount];
	}	
	if(![dictionary[kItemItemid] isKindOfClass:[NSNull class]]){
		self.itemid = dictionary[kItemItemid];
	}	
	if(![dictionary[kItemItemno] isKindOfClass:[NSNull class]]){
		self.itemno = dictionary[kItemItemno];
	}	
	if(![dictionary[kItemName] isKindOfClass:[NSNull class]]){
		self.name = dictionary[kItemName];
	}	
	if(![dictionary[kItemPath1] isKindOfClass:[NSNull class]]){
		self.path1 = dictionary[kItemPath1];
	}	
	if(![dictionary[kItemPrice] isKindOfClass:[NSNull class]]){
		self.price = dictionary[kItemPrice];
	}	
	if(![dictionary[kItemSpec] isKindOfClass:[NSNull class]]){
		self.spec = dictionary[kItemSpec];
	}	
	return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	if(self.batch != nil){
		dictionary[kItemBatch] = self.batch;
	}
	if(self.count != nil){
		dictionary[kItemCount] = self.count;
	}
	if(self.itemid != nil){
		dictionary[kItemItemid] = self.itemid;
	}
	if(self.itemno != nil){
		dictionary[kItemItemno] = self.itemno;
	}
	if(self.name != nil){
		dictionary[kItemName] = self.name;
	}
	if(self.path1 != nil){
		dictionary[kItemPath1] = self.path1;
	}
	if(self.price != nil){
		dictionary[kItemPrice] = self.price;
	}
	if(self.spec != nil){
		dictionary[kItemSpec] = self.spec;
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
	if(self.batch != nil){
		[aCoder encodeObject:self.batch forKey:kItemBatch];
	}
	if(self.count != nil){
		[aCoder encodeObject:self.count forKey:kItemCount];
	}
	if(self.itemid != nil){
		[aCoder encodeObject:self.itemid forKey:kItemItemid];
	}
	if(self.itemno != nil){
		[aCoder encodeObject:self.itemno forKey:kItemItemno];
	}
	if(self.name != nil){
		[aCoder encodeObject:self.name forKey:kItemName];
	}
	if(self.path1 != nil){
		[aCoder encodeObject:self.path1 forKey:kItemPath1];
	}
	if(self.price != nil){
		[aCoder encodeObject:self.price forKey:kItemPrice];
	}
	if(self.spec != nil){
		[aCoder encodeObject:self.spec forKey:kItemSpec];
	}

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.batch = [aDecoder decodeObjectForKey:kItemBatch];
	self.count = [aDecoder decodeObjectForKey:kItemCount];
	self.itemid = [aDecoder decodeObjectForKey:kItemItemid];
	self.itemno = [aDecoder decodeObjectForKey:kItemItemno];
	self.name = [aDecoder decodeObjectForKey:kItemName];
	self.path1 = [aDecoder decodeObjectForKey:kItemPath1];
	self.price = [aDecoder decodeObjectForKey:kItemPrice];
	self.spec = [aDecoder decodeObjectForKey:kItemSpec];
	return self;

}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
	Item *copy = [Item new];

	copy.batch = [self.batch copy];
	copy.count = [self.count copy];
	copy.itemid = [self.itemid copy];
	copy.itemno = [self.itemno copy];
	copy.name = [self.name copy];
	copy.path1 = [self.path1 copy];
	copy.price = [self.price copy];
	copy.spec = [self.spec copy];

	return copy;
}
@end