//
//  ShowTime.m
//  TableViewDemoPart1
//
//  Created by AAK on 3/8/14.
//  Copyright (c) 2014 Ali Kooshesh. All rights reserved.
//

#import "Showtime.h"

@interface Showtime ()

@property(nonatomic) NSMutableDictionary *showtimeAttrs;

@end

@implementation Showtime

-(id) initWithDictionary: (NSDictionary *) dictionary
{
	if( (self = [super init]) == nil )
		return nil;
	self.showtimeAttrs = [NSMutableDictionary dictionaryWithDictionary: dictionary];
	return self;
}

- (NSString *) theaterName
{
    return [self.showtimeAttrs objectForKey:@"theaterName"];
}

- (NSString *) time
{
    return [self.showtimeAttrs objectForKey:@"time"];
}

- (NSString *) movieTitle
{
    return [self.showtimeAttrs objectForKey:@"movieTitle"];
}

- (void) print
{
    NSLog(@"%@", self.showtimeAttrs);
}

@end
