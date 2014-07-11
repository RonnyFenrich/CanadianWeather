//
//  WeatherDataForecastConditions.h
//  CanadianWeather
//
//  Created by Ronny Fenrich on 2014-07-10.
//  Copyright (c) 2014 Ronny Fenrich. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherDataForecastConditions : NSObject

@property (strong, nonatomic) NSString *forecastIssueTime;

@property (strong, nonatomic) NSArray *forecasts;    // of WeatherDataForecastCondition

@end
