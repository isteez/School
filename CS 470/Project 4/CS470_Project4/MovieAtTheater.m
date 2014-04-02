//
//  MovieAtTheater.m
//  TableViewDemoPart1
//
//  Created by AAK on 3/9/14.
//  Copyright (c) 2014 Ali Kooshesh. All rights reserved.
//

#import "MovieAtTheater.h"

@interface MovieAtTheater()
@property(nonatomic) NSMutableDictionary *movieAtTheaterAttrs;
@end

@implementation MovieAtTheater

-(instancetype) initWithDictionary: (NSDictionary *) dictionary
{
	if( (self = [super init]) == nil )
		return nil;
	self.movieAtTheaterAttrs = [NSMutableDictionary dictionaryWithDictionary: dictionary];
	return self;
}

- (NSString *) movieName
{
    return [self.movieAtTheaterAttrs valueForKey:@"movieTitle"];
}

- (NSString *) theaterName
{
    return [self.movieAtTheaterAttrs valueForKey:@"theaterName"];
}

- (NSString *) cityName
{
    return [self.movieAtTheaterAttrs valueForKey:@"cityName"];
}

- (void) print
{
    NSLog(@"%@", self.movieAtTheaterAttrs);
}

@end
