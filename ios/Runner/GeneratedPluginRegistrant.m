//
//  Generated file. Do not edit.
//

// clang-format off

#import "GeneratedPluginRegistrant.h"

#if __has_include(<emoji_picker_flutter/EmojiPickerFlutterPlugin.h>)
#import <emoji_picker_flutter/EmojiPickerFlutterPlugin.h>
#else
@import emoji_picker_flutter;
#endif

#if __has_include(<rive_common/RivePlugin.h>)
#import <rive_common/RivePlugin.h>
#else
@import rive_common;
#endif

#if __has_include(<shared_preferences_foundation/SharedPreferencesPlugin.h>)
#import <shared_preferences_foundation/SharedPreferencesPlugin.h>
#else
@import shared_preferences_foundation;
#endif

#if __has_include(<url_launcher_ios/URLLauncherPlugin.h>)
#import <url_launcher_ios/URLLauncherPlugin.h>
#else
@import url_launcher_ios;
#endif

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [EmojiPickerFlutterPlugin registerWithRegistrar:[registry registrarForPlugin:@"EmojiPickerFlutterPlugin"]];
  [RivePlugin registerWithRegistrar:[registry registrarForPlugin:@"RivePlugin"]];
  [SharedPreferencesPlugin registerWithRegistrar:[registry registrarForPlugin:@"SharedPreferencesPlugin"]];
  [URLLauncherPlugin registerWithRegistrar:[registry registrarForPlugin:@"URLLauncherPlugin"]];
}

@end
