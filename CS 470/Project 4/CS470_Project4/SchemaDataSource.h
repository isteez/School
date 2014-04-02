//
//  SchemaDataSource.h
//  TableViewDemoPart1
//
//  Created by AAK on 3/8/14.
//  Copyright (c) 2014 Ali Kooshesh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MoviesDataSource.h"
#import "TheatersDataSource.h"
#import "ShowtimesDataSource.h"
#import "DownloadAssistant.h"
#import "MoviesAtTheatersDataSource.h"
#import "CityDataSource.h"

@protocol DataSourceReadyForUseDelegate;

@interface SchemaDataSource : NSObject<WebDataReadyDelegate>

@property (nonatomic) id<DataSourceReadyForUseDelegate> delegate;

@property(nonatomic) MoviesDataSource * moviesDataSource;
@property(nonatomic) TheatersDataSource * theatersDataSource;
@property(nonatomic) ShowtimesDataSource *showtimesDataSource;
@property(nonatomic) MoviesAtTheatersDataSrouce *moviesAtTheatersDataSource;
@property(nonatomic) CityDataSource *cityDataSource;

@property(nonatomic) BOOL dataSourceReady;

+(SchemaDataSource *) sharedInstance;

@end

@protocol DataSourceReadyForUseDelegate <NSObject>

@optional

-(void) dataSourceReadyForUse: (SchemaDataSource *) dataSource;

@end
