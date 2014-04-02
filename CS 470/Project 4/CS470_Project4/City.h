//
//  City.h
//  CS470_Project4
//
//  Created by Stephen Kyles on 3/25/14.
//  Copyright (c) 2014 Stephen Kyles. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface City : NSObject

-(id) initWithDictionary: (NSDictionary *) dictionary;

- (NSString *) cityName;
- (void) print;

@end
