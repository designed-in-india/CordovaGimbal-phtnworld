//
//  Beacon.m
//  CustomPlugin
//
//  Created by Leo on 26/03/15.
//
//

#import "Beacon.h"
#import <Gimbal/Gimbal.h>

@interface Beacon()<GMBLPlaceManagerDelegate, GMBLCommunicationManagerDelegate,GMBLBeaconManagerDelegate,GMBLApplicationStatusDelegate>

@property (nonatomic) GMBLPlaceManager *placeManager;
@property (nonatomic) GMBLBeaconManager* beaconManager;
@property (nonatomic) GMBLCommunicationManager *communicationManager;
@property (assign) BOOL checkInAlertDisplayed;

@end


@implementation Beacon

# pragma mark - Gimbal PlaceManager delegate methods

- (void)placeManager:(GMBLPlaceManager *)manager didBeginVisit:(GMBLVisit *)visit
{
    if ([visit.place.name isEqualToString:@"Reception"] || [visit.place.name isEqualToString:@"Photon World 2"]) {
        [self displayWelcomeMsgAlert];
    }
}

- (void)placeManager:(GMBLPlaceManager *)manager didEndVisit:(GMBLVisit *)visit
{
    if ([visit.place.name isEqualToString:@"Reception"] || [visit.place.name isEqualToString:@"Photon World 2"]) {
        [self displayExitMsgAlert];
    }
}

- (void)placeManager:(GMBLPlaceManager *)manager didReceiveBeaconSighting:(GMBLBeaconSighting *)sighting forVisits:(NSArray *)visits{
    
    /*for (GMBLVisit* visitPlace in visits) {
     if ([visitPlace.place.name isEqualToString:@"Reception"] || [visitPlace.place.name isEqualToString:@"Photon World 2"]) {
     
     if (!self.checkInAlertDisplayed) {
     
     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
     NSString *checkIn = [defaults objectForKey:@"CheckIn"];
     if ([checkIn isEqualToString:@"YES"]) {
     self.checkInAlertDisplayed = YES;
     return;
     }
     self.checkInAlertDisplayed = YES;
     [self displayCheckinAlert];
     }
     }
     
     }*/
}

- (void)beaconManager:(GMBLBeaconManager *)manager didReceiveBeaconSighting:(GMBLBeaconSighting *)sighting{
    
    if ([sighting.beacon.name isEqualToString:@"Reception"] || [sighting.beacon.name isEqualToString:@"Photon World 2"]) {
        
        if (!self.checkInAlertDisplayed) {
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *checkIn = [defaults objectForKey:@"CheckIn"];
            if ([checkIn isEqualToString:@"YES"]) {
                self.checkInAlertDisplayed = YES;
                return;
            }
            self.checkInAlertDisplayed = YES;
            [self displayCheckinAlert];
        }
    }
}

#pragma mark - Cordova Methods

- (void) open:(CDVInvokedUrlCommand*)command
{
    NSLog(@"");
}

- (void)initializeBeacon:(CDVInvokedUrlCommand*)command
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CheckInCallback) name:@"CheckInCallback" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DemoCallback) name:@"DemoInCallback" object:nil];
    
    [self copyFileFromBundle:nil];
    
    [self writeErrorLog:@"\n 1"];
    [self registerNotifications];
    [self writeErrorLog:@"\n 2"];
    
    [Gimbal setAPIKey:@"d1c5ea32-a1ee-405b-9bd8-88255ea574cc" options:nil];
    [self writeErrorLog:@"\n 3"];
    
    self.beaconManager = [GMBLBeaconManager new];
    [self.beaconManager startListening];
    self.beaconManager.delegate = self;
    [self writeErrorLog:@"\n 4"];
    
    self.placeManager = [GMBLPlaceManager new];
    self.placeManager.delegate = self;
    [self writeErrorLog:@"\n 5"];
    
    self.communicationManager = [GMBLCommunicationManager new];
    self.communicationManager.delegate = self;
    [self writeErrorLog:@"\n 6"];
    
    [GMBLPlaceManager startMonitoring];
    [GMBLCommunicationManager startReceivingCommunications];
    [self writeErrorLog:@"\n 7"];
    
    //[self checkBluetoothStatus];
    //[self checkLocationServiceStatus];
}

# pragma mark - Custom Methods

- (void) registerNotifications{
    
    [self writeErrorLog:@"\n 1.1"];

    if ([[UIApplication sharedApplication] respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
    {
        UIUserNotificationType types = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
    }
    [self writeErrorLog:@"\n 1.2"];

    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeSound
                                                                                                              categories:nil]];
    }
    [self writeErrorLog:@"\n 1.3"];
}

- (void) checkBluetoothStatus{
    
    if ([GMBLApplicationStatus bluetoothStatus] == (GMBLBluetoothStatusAdminRestricted | GMBLBluetoothStatusPoweredOff)) {
        //Display alert
    }
}

- (void) checkLocationServiceStatus{
    if ([GMBLApplicationStatus locationStatus] == (GMBLLocationStatusAdminRestricted | GMBLLocationStatusNotAuthorizedAlways)) {
        //Display alert
    }
}

- (void) displayWelcomeMsgAlert{
    
    UILocalNotification * notification = [[UILocalNotification alloc] init];
    notification.alertBody = @"Welcome to the Photon World 2015 Conference !!!";
    
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}

- (void) displayExitMsgAlert{
    
    UILocalNotification * notification = [[UILocalNotification alloc] init];
    notification.alertBody = @"Thank you for support";
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}

- (void) displayDemoAlert{
    
    UILocalNotification * notification = [[UILocalNotification alloc] init];
    notification.alertBody = @"Would you like to see the demo ?";
    notification.alertAction = @"Demo";
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}

- (void) displayCheckinAlert{
    
    UILocalNotification * notification = [[UILocalNotification alloc] init];
    notification.alertBody = @"Would you like to Check-In using QR ?";
    notification.alertAction = @"CheckIn";
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}

- (void) writeErrorLog:(NSString *)error {
    
    NSString* documentsDirectory = [NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* fileName = [documentsDirectory stringByAppendingPathComponent:@"ErrorLog.txt"];
    
    //Create new file if it doesn't exist
    if(![[NSFileManager defaultManager] fileExistsAtPath:fileName])
        [[NSFileManager defaultManager] createFileAtPath:fileName contents:nil attributes:nil];
    
    //Append error log to file
    NSFileHandle* file = [NSFileHandle fileHandleForUpdatingAtPath:fileName];
    [file seekToEndOfFile];
    [file writeData:[error dataUsingEncoding:NSUTF8StringEncoding]];
    [file closeFile];
}

- (void) copyFileFromBundle:(CDVInvokedUrlCommand *)command{
    
    NSError* error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths firstObject];
    
    NSString *gimbalPath = [documentsDirectoryPath stringByAppendingPathComponent:@"/Gimbal"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:gimbalPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:gimbalPath withIntermediateDirectories:NO attributes:nil error:&error];
    
    NSString* gimbalFilePath = [NSString stringWithFormat:@"%@/application-properties.plist",gimbalPath];

    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:gimbalFilePath];
    
    if (!fileExists) {
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"application-properties" ofType:@"plist"];        
        if([[NSFileManager defaultManager] copyItemAtPath:path toPath:gimbalFilePath error:&error]){
            NSLog(@"Default file successfully copied over.");
        } else {
            NSLog(@"Error");
        }
    }
}

- (void) CheckInCallback{
    [super writeJavascript:@"CheckInCallbackFromNative()"];

}

- (void) DemoCallback{
    [super writeJavascript:@"DemoCallbackFromNative()"];

}
@end

@implementation AppDelegate (Beacon)

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
    if ([notification.alertAction isEqualToString:@"CheckIn"]) {
        
        // Store the data
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@"YES" forKey:@"CheckIn"];
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Photon World" message:notification.alertBody delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
        alert.tag = 111;
        [alert show];
        
    }else if ([notification.alertAction isEqualToString:@"Demo"]) {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Photon World" message:notification.alertBody delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
        alert.tag = 222;
        [alert show];
        
    }else{
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Photon World" message:notification.alertBody delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
        if (alertView.tag == 111) {
        
            [[NSNotificationCenter defaultCenter]postNotificationName:@"CheckInCallback" object:nil];
        }else if (alertView.tag == 222){
            [[NSNotificationCenter defaultCenter]postNotificationName:@"DemoInCallback" object:nil];
        }
    }
}


@end
