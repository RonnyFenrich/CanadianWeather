//
//  WeatherDataForecastCondition.h
//  CanadianWeather
//
//  Created by Ronny Fenrich on 2014-06-30.
//  Copyright (c) 2014 Ronny Fenrich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeatherDataPoint.h"

@interface WeatherDataForecastCondition : NSObject


@property (strong, nonatomic) NSString *periodName;
@property (strong, nonatomic) NSString *periodDescription;

@property (strong, nonatomic) NSString *summary;

@property (strong, nonatomic) NSString *iconCode;
@property (strong, nonatomic) NSString *iconFormat;

@property (strong, nonatomic) WeatherDataPoint *pop;
@property (strong, nonatomic) NSString *popTextSummary;

@property (strong, nonatomic) WeatherDataPoint *temperatureHigh;
@property (strong, nonatomic) WeatherDataPoint *temperatureLow;

@end
