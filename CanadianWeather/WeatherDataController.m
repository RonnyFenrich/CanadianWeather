//
//  WeatherDataController.m
//  CanadianWeather
//
//  Created by Ronny Fenrich on 2014-06-30.
//  Copyright (c) 2014 Ronny Fenrich. All rights reserved.
//

#import "WeatherDataController.h"
#import "XMLDictionary.h"


#define URL_BASEDATA    @"http://dd.weather.gc.ca/citypage_weather/xml/"


@interface WeatherDataController()


@end



@implementation WeatherDataController


// returns list of weather locations (cached when loaded from csv webservice)
- (NSArray *)weatherDataLocations; {



    return nil;
}


- (void)refreshLocalDataWithForce:(BOOL)forceRefresh {

    // refresh?


    // retrieve data...
    NSString *weatherUrl = @"http://dd.weather.gc.ca/citypage_weather/xml/AB/s0000045_e.xml";

    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:weatherUrl]
            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                // handle response

                if (error)
                {
                    NSLog(@"%@", error);
                    return;
                }

                // parse XML data...
//                NSString *xmlData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                [self parseXmlWeatherData:data];

            }] resume];
}


- (void)parseXmlWeatherData:(NSData *)xmlData; {

    // trying to convert xml to json
    NSDictionary *data = [NSDictionary dictionaryWithXMLData:xmlData];

    if (!data) {
        return;
    }

    WeatherData *wd = [[WeatherData alloc] init];
    wd.updateTime = [NSDate date];
    wd.locationName = [data valueForKeyPath:@"location.name.__text"];

    // current conditions
    wd.current = [[WeatherDataCurrentCondition alloc] init];
    wd.current.stationName = [data valueForKeyPath:@"currentConditions.station.__text"];
    NSArray *observationTimes = [data valueForKeyPath:@"currentConditions.dateTime"];
    wd.current.observationTime = [self getLocalDateFromArray:observationTimes];

    wd.current.condition = [data valueForKeyPath:@"currentConditions.condition"];
    wd.current.iconCode = [data valueForKeyPath:@"currentConditions.iconCode.__text"];
    wd.current.iconFormat = [data valueForKeyPath:@"currentConditions.iconCode._format"];

    NSDictionary *temperatureData = [data valueForKeyPath:@"currentConditions.temperature"];
    wd.current.temperature = [self getDataPointFromDictionary:temperatureData];
    NSDictionary *dewpointData = [data valueForKeyPath:@"currentConditions.dewpoint"];
    wd.current.dewpoint = [self getDataPointFromDictionary:dewpointData];
    NSDictionary *pressureData = [data valueForKeyPath:@"currentConditions.pressure"];
    wd.current.pressure = [self getDataPointFromDictionary:pressureData];
    NSDictionary *visibilityData = [data valueForKeyPath:@"currentConditions.visibility"];
    wd.current.visibility = [self getDataPointFromDictionary:visibilityData];
    NSDictionary *relativeHumidityData = [data valueForKeyPath:@"currentConditions.relativeHumidity"];
    wd.current.relativeHumidity = [self getDataPointFromDictionary:relativeHumidityData];
    NSDictionary *windSpeedData = [data valueForKeyPath:@"currentConditions.wind.speed"];
    wd.current.windSpeed = [self getDataPointFromDictionary:windSpeedData];

    // forcast
    wd.forecast = [[WeatherDataForecastConditions alloc] init];

    NSArray *forecastIssueTimes = [data valueForKeyPath:@"forecastGroup.dateTime"];
    wd.forecast.forecastIssueTime = [self getLocalDateFromArray:forecastIssueTimes];

    NSArray *allForecasts = [data valueForKeyPath:@"forecastGroup.forecast"];

    if (allForecasts && [allForecasts isKindOfClass:[NSArray class]]) {

        NSMutableArray *forecasts = [[NSMutableArray alloc] init];
        for (NSDictionary *aForecast in allForecasts) {

            WeatherDataForecastCondition *fc = [[WeatherDataForecastCondition alloc] init];
            fc.periodName = [aForecast valueForKeyPath:@"period._textForecastName"];
            fc.periodDescription = [aForecast valueForKeyPath:@"period.__text"];

            fc.summary = [aForecast valueForKeyPath:@"textSummary"];

            fc.iconCode = [aForecast valueForKeyPath:@"abbreviatedForecast.iconCode.__text"];
            fc.iconFormat = [aForecast valueForKeyPath:@"abbreviatedForecast.iconCode._format"];

            NSDictionary *popData = [data valueForKeyPath:@"abbreviatedForecast.pop"];
            fc.pop = [self getDataPointFromDictionary:popData];
            fc.popTextSummary = [aForecast valueForKeyPath:@"abbreviatedForecast.textSummary"];

            // search for High and Low temparature information
            NSObject *tempData = [aForecast valueForKeyPath:@"temperatures.temperature"];
            if ([tempData isKindOfClass:[NSDictionary class]]) {
                // just one value for this forecast period
                WeatherDataPoint *dp = [[WeatherDataPoint alloc] init];
                dp.value = [(NSDictionary *)tempData valueForKey:@"__text"];
                dp.units = [(NSDictionary *)tempData valueForKey:@"_units"];
                if ([[(NSDictionary *)tempData valueForKeyPath:@"_class"] isEqualToString:@"high"]) {
                    fc.temperatureHigh = dp;
                }
                if ([[(NSDictionary *)tempData valueForKeyPath:@"_class"] isEqualToString:@"low"]) {
                    fc.temperatureLow = dp;
                }
            }
            else if ([tempData isKindOfClass:[NSArray class]]) {
                // more than one temp
                for (NSDictionary *td in (NSArray * )tempData) {
                    WeatherDataPoint *dp = [[WeatherDataPoint alloc] init];
                    dp.value = [td valueForKey:@"__text"];
                    dp.units = [td valueForKey:@"_units"];

                    if ([[td valueForKeyPath:@"_class"] isEqualToString:@"high"]) {
                        fc.temperatureHigh = dp;
                    }
                    if ([[td valueForKeyPath:@"_class"] isEqualToString:@"low"]) {
                        fc.temperatureLow = dp;
                    }
                }
            }

            [forecasts addObject:fc];
        }
        wd.forecast.forecasts = forecasts;
    }

    NSLog(@"%@", wd);

}


// --------------------------------------------------------------------------------------

- (NSString *)getLocalDateFromArray:(NSArray *)anArray {

    for (NSDictionary *record in anArray)
    {
        NSString *timeZone = [record valueForKey:@"_zone"];
        if (timeZone && ![timeZone isEqualToString:@"UTC"])
        {
            // should be the local time zone
            return [record valueForKey:@"textSummary"];
        }
    }

    return nil;
}

- (WeatherDataPoint *)getDataPointFromDictionary:(NSDictionary *)data; {

    WeatherDataPoint *dp = [[WeatherDataPoint alloc] init];
    dp.value = [data valueForKey:@"__text"];
    dp.units = [data valueForKey:@"_units"];

    if (!dp.value) {
        return nil;
    }
    return dp;
}


@end
