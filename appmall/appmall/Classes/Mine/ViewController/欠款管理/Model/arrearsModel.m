//
//	arrearsModel.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "arrearsModel.h"

NSString *const karrearsModelItems = @"items";
NSString *const karrearsModelNo = @"no";
NSString *const karrearsModelOrdermoney = @"ordermoney";

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
	if(![dictionary[karrearsModelNo] isKindOfClass:[NSNull class]]){
		self.no = dictionary[karrearsModelNo];
	}	
	if(![dictionary[karrearsModelOrdermoney] isKindOfClass:[NSNull class]]){
		self.ordermoney = dictionary[karrearsModelOrdermoney];
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
	if(self.no != nil){
		dictionary[karrearsModelNo] = self.no;
	}
	if(self.ordermoney != nil){
		dictionary[karrearsModelOrdermoney] = self.ordermoney;
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
	if(self.items != nil){
		[aCoder encodeObject:self.items forKey:karrearsModelItems];
	}
	if(self.no != nil){
		[aCoder encodeObject:self.no forKey:karrearsModelNo];
	}
	if(self.ordermoney != nil){
		[aCoder encodeObject:self.ordermoney forKey:karrearsModelOrdermoney];
	}

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.items = [aDecoder decodeObjectForKey:karrearsModelItems];
	self.no = [aDecoder decodeObjectForKey:karrearsModelNo];
	self.ordermoney = [aDecoder decodeObjectForKey:karrearsModelOrdermoney];
	return self;

}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
	arrearsModel *copy = [arrearsModel new];

	copy.items = [self.items copy];
	copy.no = [self.no copy];
	copy.ordermoney = [self.ordermoney copy];

	return copy;
}
@end