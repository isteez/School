//
//  City.m
//  CS470_Project4
//
//  Created by Stephen Kyles on 3/25/14.
//  Copyright (c) 2014 Stephen Kyles. All rights reserved.
//

#import "City.h"

@interface City()

@property(nonatomic) NSMutableDictionary *cityAttrs;

@end

@implementation City

-(id) initWithDictionary: (NSDictionary *) dictionary
{
	if( (self = [super init]) == nil )
		return nil;
	self.cityAttrs = [NSMutableDictionary dictionaryWithDictionary: dictionary];
	return self;
}

- (NSString *)cityName
{
    return [self.cityAttrs objectForKey:@"cityName"];
}

- (void) print
{
    NSLog(@"%@", self.cityAttrs);
}

@end
