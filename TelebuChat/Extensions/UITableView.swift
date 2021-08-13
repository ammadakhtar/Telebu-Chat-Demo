//
//  UITableView.swift
//  TelebuChat
//
//  Created by Ammad on 12/08/2021.
//

import UIKit

protocol Identificable   { static var  identifier: String { get } }
protocol NibInstanciable { static func nib() -> UINib }
extension UITableViewCell      : Identificable, NibInstanciable {}
extension Identificable {
    static var identifier: String { return String.init(describing: Self.self) }
}

extension UITableView {

    func scrollToBottom(){
        DispatchQueue.main.async {
            let indexPath = IndexPath( row: self.numberOfRows(inSection:  self.numberOfSections-1) - 1,
                                       section: self.numberOfSections - 1)
            self.scrollToRow(at: indexPath, at: .bottom, animated: false)
        }
    }
    
    func register<T: UITableViewCell>(cellType: T.Type)  {
        self.register(cellType.nib(), forCellReuseIdentifier: cellType.identifier)
    }
    
    func dequeue<T:UITableViewCell>(cellType: T.Type) -> T {
        return self.dequeueReusableCell(withIdentifier: cellType.identifier) as! T
    }
}

extension NibInstanciable where Self: Identificable {
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
}
