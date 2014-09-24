//
//  WeatherDataCurrentCondition.h
//  CanadianWeather
//
//  Created by Ronny Fenrich on 2014-06-30.
//  Copyright (c) 2014 Ronny Fenrich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeatherDataPoint.h"

@interface WeatherDataCurrentCondition : NSObject

@property (strong, nonatomic) NSString *stationName;
@property (strong, nonatomic) NSString *observationTime;

@property (strong, nonatomic) NSString *condition;
@property (strong, nonatomic) NSString *iconCode;
@property (strong, nonatomic) NSString *iconFormat;

@property (strong, nonatomic) WeatherDataPoint *temperature;
@property (strong, nonatomic) WeatherDataPoint *dewpoint;
@property (strong, nonatomic) WeatherDataPoint *pressure;
@property (strong, nonatomic) WeatherDataPoint *visibility;
@property (strong, nonatomic) WeatherDataPoint *relativeHumidity;
@property (strong, nonatomic) WeatherDataPoint *windSpeed;

@end
