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

#import "PipeError.h"

NSString* const PipeErrorDomain = @"DeviceError";

NSError* PipeErrorMakeWithCode(PipeErrorCode code)
{
	NSDictionary<NSNumber*, NSString*>* identifiers = @{
#define P_(identifier) @(PipeErrorCode##identifier): @(#identifier),
		P_(Timeout)
		P_(CouldNotOpen)
		P_(CouldNotReopen)
		P_(CouldNotGetEnoughData)
		P_(NoDevice)
		P_(NoWifiDevice)
		P_(MultipleDevicesFound)
		P_(CouldNotSendData)
#undef P_
	};
	NSString* identifier = [identifiers objectForKey: @(code)];
	NSString* descriptionLocalizedKey =  (identifier ? [NSString stringWithFormat: @"Error_pipe_%@", identifier] : @"");
	NSString* recoverySuggestionLocalizedKey = (identifier ? [NSString stringWithFormat: @"Error_pipe_%@_recoverySuggestion", identifier] : @"");
	
	NSLog(@"%@\n%@", descriptionLocalizedKey, [NSThread callStackSymbols]);
	NSMutableDictionary* userInfo = [NSMutableDictionary dictionaryWithCapacity: 2]; {
		NSBundle* bundle = SWIFTPM_MODULE_BUNDLE;
		NSString* table = @"PipeModel";
		[userInfo setObject: [bundle localizedStringForKey: descriptionLocalizedKey value: nil table: table] forKey: NSLocalizedDescriptionKey];
		if (recoverySuggestionLocalizedKey.length) {
			[userInfo setObject: [bundle localizedStringForKey: recoverySuggestionLocalizedKey value: nil table: table] forKey: NSLocalizedRecoverySuggestionErrorKey];
		}
	}
	return [NSError errorWithDomain: PipeErrorDomain code: code userInfo: userInfo];
}
