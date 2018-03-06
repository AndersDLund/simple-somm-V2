/*
 Copyright 2016-present the Material Components for iOS authors. All Rights Reserved.

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

// This file was automatically generated by running ./scripts/sync_icons.sh
// Do not modify directly.

#import "MaterialIcons+ic_check.h"

static NSString *const kBundleName = @"MaterialIcons_ic_check";
static NSString *const kIconName = @"ic_check";

// Export a nonsense symbol to suppress a libtool warning when this is linked alone in a static lib.
__attribute__((visibility("default"))) char MDCIconsExportToSuppressLibToolWarning_ic_check = 0;

@implementation MDCIcons (ic_check)

+ (nonnull NSString *)pathFor_ic_check {
  return [self pathForIconName:kIconName withBundleName:kBundleName];
}

+ (nullable UIImage *)imageFor_ic_check {
  NSBundle *bundle = [self bundleNamed:kBundleName];
  return [UIImage imageNamed:kIconName
                    inBundle:bundle
      compatibleWithTraitCollection:nil];
}

@end
