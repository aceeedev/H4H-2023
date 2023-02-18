import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    GMSServices.provideAPIKey("AIzaSyAGt-YPeA2uWyGM4ne36bRinQSpVrEWxDs")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

// #include "AppDelegate.h"
// #include "GeneratedPluginRegistrant.h"
// #import "GoogleMaps/GoogleMaps.h"

// @implementation AppDelegate

// - (BOOL)application:(UIApplication *)application
//     didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//   [GMSServices provideAPIKey:@"AIzaSyAGt-YPeA2uWyGM4ne36bRinQSpVrEWxDs"];
//   [GeneratedPluginRegistrant registerWithRegistry:self];
//   return [super application:application didFinishLaunchingWithOptions:launchOptions];
// }
// @end