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

import Foundation
#if os(macOS)
import IOKit
#endif
import PipeModelObjC

extension NSError
{
	#if os(macOS)
	final public var ioReturn: IOReturn?
	{
		if (domain == PipeIOKitErrorDomain) {
			return IOReturn(code)
		} else {
			return nil
		}
	}
	#endif
	public var pipeErrorCode: PipeErrorCode?
	{
		if (domain == PipeErrorDomain) {
			return PipeErrorCode(rawValue: code)
		} else {
			return nil
		}
	}
	public convenience init(deviceErrorCode: PipeErrorCode) { self.init(domain: PipeErrorDomain, code: deviceErrorCode.rawValue) }
}

extension Error
{
	#if os(macOS)
	public var ioReturn: IOReturn? { (self as NSError).ioReturn }
	#endif
	
	public var pipeErrorCode: PipeErrorCode? { (self as NSError).pipeErrorCode }
	
	public init(deviceErrorCode: PipeErrorCode) where Self == NSError
	{
		self = NSError(deviceErrorCode: deviceErrorCode)
	}
}
