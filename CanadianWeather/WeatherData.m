//
//  WeatherData.m
//  CanadianWeather
//
//  Created by Ronny Fenrich on 2014-06-30.
//  Copyright (c) 2014 Ronny Fenrich. All rights reserved.
//

#import "WeatherData.h"

@implementation WeatherData

- (NSString *)description {
    // debug output for WeatherData object
    NSString *result = @"";
    result = [result stringByAppendingFormat:@"\n"];
    result = [result stringByAppendingFormat:@"Last local update: %@\n", self.updateTime];
    result = [result stringByAppendingFormat:@"Location: %@\n", self.locationName];

    if (self.current) {
        result = [result stringByAppendingFormat:@"\n"];
        result = [result stringByAppendingFormat:@"Current conditions\n"];
        result = [result stringByAppendingFormat:@"Station name: %@\n", self.current.stationName];
        result = [result stringByAppendingFormat:@"Observation time: %@\n", self.current.observationTime];
        result = [result stringByAppendingFormat:@"Condition: %@\n", self.current.condition];
        result = [result stringByAppendingFormat:@"Temperature: %@\n", self.current.temperature];
        result = [result stringByAppendingFormat:@"Dewpoint: %@\n", self.current.dewpoint];
        result = [result stringByAppendingFormat:@"Pressure: %@\n", self.current.pressure];
        result = [result stringByAppendingFormat:@"Visibility: %@\n", self.current.visibility];
        result = [result stringByAppendingFormat:@"Humidity: %@\n", self.current.relativeHumidity];
        result = [result stringByAppendingFormat:@"Windspeed: %@\n", self.current.windSpeed];
    }

    if (self.forecast) {
        result = [result stringByAppendingFormat:@"\n"];
        result = [result stringByAppendingFormat:@"Forecast\n"];
        result = [result stringByAppendingFormat:@"Forecast issue time: %@\n", self.forecast.forecastIssueTime];

        for (WeatherDataForecastCondition *fc in self.forecast.forecasts) {
            result = [result stringByAppendingFormat:@"\n"];
            result = [result stringByAppendingFormat:@"%@ - %@\n", fc.periodName, fc.periodDescription];
            result = [result stringByAppendingFormat:@"Summary: %@\n", fc.summary];
            if (fc.pop) {
                result = [result stringByAppendingFormat:@"POP: %@, %@\n", fc.pop, fc.popTextSummary];
            }
            if (fc.temperatureHigh) {
                result = [result stringByAppendingFormat:@"Temp High: %@\n", fc.temperatureHigh];
            }
            if (fc.temperatureLow) {
                result = [result stringByAppendingFormat:@"Temp Low: %@\n", fc.temperatureLow];
            }
        }
    }

    return result;
}

@end
