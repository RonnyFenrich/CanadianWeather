//
//  TodayViewController.m
//  CanadianWeatherTodayExtension
//
//  Created by Ronny Fenrich on 2014-09-19.
//  Copyright (c) 2014 Ronny Fenrich. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "CanadianWeatherCommon.h"
#import "UIImageView+AFNetworking.h"


@interface TodayViewController () <NCWidgetProviding>

@property (strong, nonatomic) IBOutlet UILabel *station;
@property (strong, nonatomic) IBOutlet UILabel *currentUpdateTime;

@property (strong, nonatomic) IBOutlet UILabel *currentTemp;

@property (strong, nonatomic) IBOutlet UILabel *currentCondition;
@property (strong, nonatomic) IBOutlet UILabel *currentPressure;
@property (strong, nonatomic) IBOutlet UILabel *currentVisibility;
@property (strong, nonatomic) IBOutlet UILabel *currentWind;

@property (strong, nonatomic) IBOutlet UIImageView *currentConditionImage;
@property (strong, nonatomic) IBOutlet UIWebView *currentConditionDisplay;

@end


@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];

//    [self refreshWidgetUI];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

//    WeatherDataController *weatherDataController = [WeatherDataController sharedInstance];
//    weatherDataController.currentWeatherData = nil;
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {

    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    WeatherDataController *weatherDataController = [WeatherDataController sharedInstance];
    [weatherDataController refreshLocalDataWithForce:NO callback:^(BOOL hasUpdatedInformation) {

        if (hasUpdatedInformation) {
            [self refreshWidgetUI];
            completionHandler(NCUpdateResultNewData);
        } else {
            completionHandler(NCUpdateResultNoData);
        }
    }];

}

- (void)refreshWidgetUI {

    WeatherDataController *weatherDataController = [WeatherDataController sharedInstance];
    if (weatherDataController.hasData) {
        dispatch_async(dispatch_get_main_queue(), ^{

            WeatherData *cwd = weatherDataController.currentWeatherData;
            self.station.text = cwd.current.stationName;
            self.currentUpdateTime.text = cwd.current.observationTime;

            self.currentTemp.text = cwd.current.temperature.description;

            self.currentCondition.text = cwd.current.condition;
            self.currentPressure.text = [NSString stringWithFormat:@"%@ (%@)", cwd.current.pressure.description, cwd.current.pressureTendency];
            self.currentVisibility.text = cwd.current.visibility.description;
            self.currentWind.text = [NSString stringWithFormat:@"%@ %@", cwd.current.windDirection, cwd.current.windSpeed.description];

//            NSString *iconUrl = [NSString stringWithFormat:@"http://weather.gc.ca/weathericons/%@.%@", cwd.current.iconCode, cwd.current.iconFormat];
//            [self.currentConditionImage setImageWithURL:[NSURL URLWithString:iconUrl]];

//            NSString *path = [[NSBundle mainBundle] pathForResource:@"Cloud-Download" ofType:@"svg"];
            NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingString:@"/SVG/Cloud-Download.svg"];
            NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:path];
            NSURLRequest *req = [NSURLRequest requestWithURL:fileURL];
            [self.currentConditionDisplay setScalesPageToFit:YES];
            [self.currentConditionDisplay loadRequest:req];

        });

    } else {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            self.station.text = @"";
//            self.currentUpdateTime.text = @"";
//
//            self.currentTemp.text = @"";
//
//            self.currentCondition.text = @"";
//            self.currentPressure.text = @"";
//            self.currentVisibility.text = @"";
//            self.currentWind.text = @"";
//
//
//            for (int i=1; i<=7; i++) {
//                int startIndex = 10 * i;
//                UILabel *dayLabel = (UILabel *)[self.view viewWithTag:startIndex];
////                UIImageView *dayIcon = (UIImageView *)[self.view viewWithTag:startIndex+1];
////                UILabel *dayPop = (UILabel *)[self.view viewWithTag:startIndex+2];
////                UILabel *dayTmpHigh = (UILabel *)[self.view viewWithTag:startIndex+3];
////                UILabel *dayTmpLow = (UILabel *)[self.view viewWithTag:startIndex+4];
//
//                dayLabel.text = [NSString stringWithFormat:@"Day%d", i];
//            }
//
//        });
    }

}


- (IBAction)startHostApp:(id)sender {
    [self.extensionContext openURL:[NSURL URLWithString:@"CanadianWeather://"] completionHandler:nil];
}


@end
