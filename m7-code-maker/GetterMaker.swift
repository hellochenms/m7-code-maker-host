//
//  GetterMaker.swift
//  m7-code-maker
//
//  Created by Chen,Meisong on 2019/5/15.
//  Copyright © 2019 xyz.chenms. All rights reserved.
//

import Cocoa
import XcodeKit

class GetterMaker: NSObject, XCSourceEditorCommand {
    struct Constant {
        static let template =
"""
- (classNamePlaceHolder *)variableNamePlaceHolder {
    if (!_variableNamePlaceHolder) {
        _variableNamePlaceHolder = [classNamePlaceHolder new];
    }
    
    return _variableNamePlaceHolder;
}
"""
        static let classNamePlaceHolder  = "classNamePlaceHolder"
        static let variableNamePlaceHolder  = "variableNamePlaceHolder"
    }
    
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
        // Implement your command here, invoking the completion handler when done. Pass it nil on success, and an NSError on failure.
        
        invocation.buffer.selections.forEach { (textRange) in
            guard let textRange = textRange as? XCSourceTextRange else { return }
            for line in textRange.start.line ... textRange.end.line {
                guard let text = invocation.buffer.lines[line] as? String, text.hasPrefix("@property") else {
                    continue
                }
                
                let className = getClassName(from: text)
                let property = getProperty(from: text)
                let texts = Constant.template.replacingOccurrences(of: Constant.classNamePlaceHolder,with: className)
                    .replacingOccurrences(of: Constant.variableNamePlaceHolder, with: property)
                    .components(separatedBy: .newlines)
                
                if texts.count >= 1{
                    let lines = invocation.buffer.lines
                    let start = lines.count - 1
                    lines.insert(texts, at: IndexSet(integersIn: start ... start + texts.count - 1))
                }
            }
        }
        
        completionHandler(nil)
    }
    
    func getProperty(from lineText:String) -> String {
        return lineText.components(separatedBy: "*").last!
            .components(separatedBy: ";").first!
            .trimmingCharacters(in: .whitespaces)
    }
    
    func getClassName(from lineText:String) -> String{
        return lineText.components(separatedBy: "*").first!
            .components(separatedBy: ")").last!
            .trimmingCharacters(in: .whitespaces)
    }
}
