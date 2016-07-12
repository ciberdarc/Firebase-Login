//
//  TextInputTableView.swift
//  LoginApp
//
//  Created by Alexis Araujo on 7/11/16.
//  Copyright © 2016 Alexis Araujo. All rights reserved.
//

import UIKit

//Creacion de class public para controlar el TextField que cree anteriormente y lo asocie al textfield
public class TextInputTableView: UITableViewCell {
    
    @IBOutlet weak var myTextField: UITextField!
    
    public func configure(text:String?, placeholder:String?) {
        myTextField.text = text
        myTextField.placeholder = placeholder
    }
}
