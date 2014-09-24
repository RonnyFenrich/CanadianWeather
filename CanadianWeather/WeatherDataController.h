//
//  WeatherDataController.h
//  CanadianWeather
//
//  Created by Ronny Fenrich on 2014-06-30.
//  Copyright (c) 2014 Ronny Fenrich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeatherData.h"

@interface WeatherDataController : NSObject

// Singleton pattern
+ (instancetype)sharedInstance;

@property (nonatomic) BOOL hasData;
@property (strong, nonatomic) WeatherData *currentWeatherData;

- (NSArray *)weatherDataLocations;                          // of WeatherLocation
- (void)refreshLocalDataWithForce:(BOOL)forceRefresh callback:(void(^)())callback;       // retrieve updated results if expired or forced

@end
