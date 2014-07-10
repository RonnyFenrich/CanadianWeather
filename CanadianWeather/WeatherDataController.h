//
//  WeatherDataController.h
//  CanadianWeather
//
//  Created by Ronny Fenrich on 2014-06-30.
//  Copyright (c) 2014 Ronny Fenrich. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherDataController : NSObject

- (NSArray *)weatherDataLocations;                          // of WeatherLocation
- (void)refreshLocalDataWithForce:(BOOL)forceRefresh;       // retrieve updated results if expired or forced

@end
