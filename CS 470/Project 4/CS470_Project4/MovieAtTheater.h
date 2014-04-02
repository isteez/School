//
//  MovieAtTheater.h
//  TableViewDemoPart1
//
//  Created by AAK on 3/9/14.
//  Copyright (c) 2014 Ali Kooshesh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MovieAtTheater : NSObject

-(instancetype) initWithDictionary: (NSDictionary *) dictionary;

- (NSString *) movieName;
- (NSString *) theaterName;
- (NSString *) cityName;
- (void) print;

@end
