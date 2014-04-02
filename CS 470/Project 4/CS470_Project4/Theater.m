//
//  Theater.m
//  TableViewDemoPart1
//
//  Created by AAK on 3/8/14.
//  Copyright (c) 2014 Ali Kooshesh. All rights reserved.
//

#import "Theater.h"

@interface Theater ()

@property(nonatomic) NSMutableDictionary *theaterAttrs;

@end


@implementation Theater

-(id) initWithDictionary: (NSDictionary *) dictionary
{
	if( (self = [super init]) == nil )
		return nil;
	self.theaterAttrs = [NSMutableDictionary dictionaryWithDictionary: dictionary];
	return self;
}

- (NSString *) theaterName
{
    return [self.theaterAttrs objectForKey:@"theaterName"];
}

- (NSString *) line1address
{
    return [self.theaterAttrs objectForKey:@"address"];
}

- (NSString *) cityName
{
    return [self.theaterAttrs objectForKey:@"cityName"];
}

- (NSString *) zipCode
{
    return [self.theaterAttrs objectForKey:@"zipCode"];
}

- (NSString *) state
{
    return [self.theaterAttrs objectForKey:@"state"];
}

- (void) print
{
    NSLog(@"%@", self.theaterAttrs);
}

@end
