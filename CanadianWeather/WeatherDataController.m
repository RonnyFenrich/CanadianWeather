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

    NSArray *updateTimes = [data valueForKeyPath:@"currentConditions.dateTime"];
    wd.observationTime = [self getDateFromArray:updateTimes];

    WeatherDataCurrentCondition *cc = [[WeatherDataCurrentCondition alloc] init];
    cc.stationName = [data valueForKeyPath:@"currentConditions.station.__text"];

    NSDictionary *temperatureData = [data valueForKeyPath:@"currentConditions.temperature"];
    cc.temperature = [self getDataPointFromDictionary:temperatureData];

    NSDictionary *dewpointData = [data valueForKeyPath:@"currentConditions.dewpoint"];
    cc.dewpoint = [self getDataPointFromDictionary:dewpointData];

    NSDictionary *pressureData = [data valueForKeyPath:@"currentConditions.pressure"];
    cc.pressure = [self getDataPointFromDictionary:pressureData];

    NSDictionary *visibilityData = [data valueForKeyPath:@"currentConditions.visibility"];
    cc.visibility = [self getDataPointFromDictionary:visibilityData];

    NSDictionary *relativeHumidityData = [data valueForKeyPath:@"currentConditions.relativeHumidity"];
    cc.relativeHumidity = [self getDataPointFromDictionary:relativeHumidityData];

    NSDictionary *windSpeedData = [data valueForKeyPath:@"currentConditions.wind.speed"];
    cc.windSpeed = [self getDataPointFromDictionary:windSpeedData];


}


// --------------------------------------------------------------------------------------

- (NSString *)getDateFromArray:(NSArray *)anArray {

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
    return dp;
}


@end
