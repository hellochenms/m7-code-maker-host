//
//  SingletonMaker.swift
//  m7-code-maker
//
//  Created by Chen,Meisong on 2018/10/10.
//  Copyright © 2018年 xyz.chenms. All rights reserved.
//

import Cocoa
import XcodeKit

class SingletonMaker: NSObject , XCSourceEditorCommand {
    
    struct Constant {
        static let template = """
                              + (instancetype)sharedInstance {
                                  static classNamePlaceHolder *instance = nil;
                                  static dispatch_once_t onceToken;
                                  dispatch_once(&onceToken, ^{
                                      instance = [self new];
                                  });
                              
                                  return instance;
                              }
                              """
        static let classNamePlaceHolder  = "classNamePlaceHolder"
    }
    
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
        // Implement your command here, invoking the completion handler when done. Pass it nil on success, and an NSError on failure.
        
        var className:String?
        var lineIndex = 0
        for (index, line) in invocation.buffer.lines.enumerated() {
            let regex = try! NSRegularExpression(pattern: "@implementation\\s*([^\\s]+)", options: NSRegularExpression.Options.init(rawValue: 0))
            let lineString = line as! String
            let firstMatch = regex.firstMatch(in: lineString, options: NSRegularExpression.MatchingOptions.init(rawValue: 0), range: NSMakeRange(0, lineString.count))
            if let firstMatch = firstMatch {
                let range = firstMatch.range(at: 1)
                className = (line as! NSString).substring(with: range)
                lineIndex = index
                break
            }
        }
        
        if let className = className {
            let texts = Constant.template.replacingOccurrences(of: Constant.classNamePlaceHolder, with: className).components(separatedBy: .newlines)
            
            // 插入代码
            invocation.buffer.lines.insert(texts, at: IndexSet(integersIn: lineIndex + 1 ... lineIndex + 1 + texts.count - 1))
        }
        
        completionHandler(nil)
    }
    
}
