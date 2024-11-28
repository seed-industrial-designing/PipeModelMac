//
// PipeModelMac
// Copyright © 2015-2024 Seed Industrial Designing Co., Ltd. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software
// and associated documentation files (the “Software”), to deal in the Software without
// restriction, including without limitation the rights to use, copy, modify, merge, publish,
// distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom
// the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or
// substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

#ifdef OBJC_AVAILABLE

#import "PipeIOKitError.h"
#import "PipeError.h"

#if TARGET_OS_IPHONE
//Not Available for iOS.
#else
@import IOKit;
@import IOKit.usb.IOUSBLib;

NSString* const PipeIOKitErrorDomain = @"DeviceControllerIOKitError";

NSError* MakeNSErrorWithIOReturn(IOReturn ret)
{
	switch (ret) {
		case kIOReturnSuccess:
			return nil;
		case kIOReturnNoDevice:
			return PipeErrorMakeWithCode(PipeErrorCodeNoDevice);
		case kIOUSBTransactionTimeout:
		case kIOReturnTimeout:
			return PipeErrorMakeWithCode(PipeErrorCodeTimeout);
		default:
			break;
	}
	NSString* reason;
	char* returnStringCharacters = mach_error_string(ret);
	if (returnStringCharacters) {
		reason = [NSString stringWithCString: returnStringCharacters encoding: NSUTF8StringEncoding];
	} else {
		reason = @"Unknown reason";
	}
	
	NSString* table = @"PipeModel";
	NSLog(@"IOKit error: %@\n%@", reason, [NSThread callStackSymbols]);
	NSBundle* bundle = SWIFTPM_MODULE_BUNDLE;
	return [NSError errorWithDomain: PipeIOKitErrorDomain code: ret userInfo: @{
		NSLocalizedDescriptionKey: [NSString stringWithFormat: [bundle localizedStringForKey: @"Error_ioKit" value: nil table: table], reason, ret],
		NSLocalizedRecoverySuggestionErrorKey: [bundle localizedStringForKey: @"Error_ioKit_recoverySuggestion" value: nil table: table]
	}];
}
#endif

#endif
