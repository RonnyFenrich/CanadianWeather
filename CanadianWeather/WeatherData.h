//
//  WeatherData.h
//  CanadianWeather
//
//  Created by Ronny Fenrich on 2014-06-30.
//  Copyright (c) 2014 Ronny Fenrich. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherData : NSObject

@property (strong, nonatomic) NSDate *updateTime;   // date when app retrieved information

@property (strong, nonatomic) NSString *locationName;

@property (strong, nonatomic) WeatherDataCurrentCondition *current;
@property (strong, nonatomic) WeatherDataForecastConditions *forecast;

@end
