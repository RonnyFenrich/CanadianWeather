//
//  WeatherDataPoint.m
//  CanadianWeather
//
//  Created by Ronny Fenrich on 2014-06-30.
//  Copyright (c) 2014 Ronny Fenrich. All rights reserved.
//

#import "WeatherDataPoint.h"

@implementation WeatherDataPoint

-(NSString *)description {
    // for debug output
    NSString *result = [NSString stringWithFormat:@"%@%@", self.value, self.units];
    return result;
}

@end
