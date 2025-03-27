//
//  HomeViewController.swift
//  Calculadora
//
//  Created by Javier Cardenas Perdomo on 25/3/25.
//

import UIKit

final class HomeViewController: UIViewController {
    
    
    // MARK: OUTLETS
    
    // Resultado
    @IBOutlet private weak var resultLabel: UILabel!
    
    // Numeros
    @IBOutlet private weak var number0: UIButton!
    @IBOutlet private weak var number1: UIButton!
    @IBOutlet private weak var number2: UIButton!
    @IBOutlet private weak var number3: UIButton!
    @IBOutlet private weak var number4: UIButton!
    @IBOutlet private weak var number5: UIButton!
    @IBOutlet private weak var number6: UIButton!
    @IBOutlet private weak var number7: UIButton!
    @IBOutlet private weak var number8: UIButton!
    @IBOutlet private weak var number9: UIButton!
    @IBOutlet private weak var numberDecimal: UIButton!
    
    
    // Operadores
    @IBOutlet private weak var opAc: UIButton!
    @IBOutlet private weak var opPlusMenus: UIButton!
    @IBOutlet private weak var opPorcent: UIButton!
    @IBOutlet private weak var opDiv: UIButton!
    @IBOutlet private weak var opMulti: UIButton!
    @IBOutlet private weak var opRest: UIButton!
    @IBOutlet private weak var opPlus: UIButton!
    @IBOutlet private weak var opResult: UIButton!
    
    
    // MARK: VARIABLES
    
    private var total: Double = 0 // almacena el total
    private var temp: Double = 0  // valor que se muestra en pantalla
    private var operating = false // indica si hay un operador seleccionado
    private var decimal = false   // indica si es decimal
    private var operation: OperationType = .none //operacion actual
    
    // MARK: CONSTANTES
    
    private let decimalSeparator = Locale.current.decimalSeparator!
    private let maxlength = 9
    private let maxValue: Double = 999999999
    private let minValue: Double = 0.00000001
    private let ktotal = "total"
    
    private enum OperationType {
        case none,add,sub,mul,div,por
    }
    
    // formateo de valores aux
    private let auxFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        let locale = Locale.current
        formatter.groupingSeparator = ""
        formatter.decimalSeparator = locale.decimalSeparator
        formatter.numberStyle = .decimal
        formatter.maximumIntegerDigits = 100
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 100
        return formatter
    }()
    
    // formateo de valores aux para totales
    private let auxTotalFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = ""
        formatter.decimalSeparator = ""
        formatter.numberStyle = .decimal
        formatter.maximumIntegerDigits = 100
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 100
        return formatter
    }()
    
    // formateo de valores por pantalla por defecto
    private let printFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        let locale = Locale.current
        formatter.groupingSeparator = locale.groupingSeparator
        formatter.decimalSeparator = locale.decimalSeparator
        formatter.numberStyle = .decimal
        formatter.maximumIntegerDigits = 9
        formatter.maximumFractionDigits = 8
        formatter.minimumFractionDigits = 0
        return formatter
    }()
    
    // formateo de valores por pantalla formato cientifico
    private let printScientificFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .scientific
        formatter.maximumFractionDigits = 3
        formatter.exponentSymbol = "e"
        return formatter
    }()

    
    
    // MARK: INICIALIZADOR
    
    init() {  // inicia el controlador con el xib que tiene asociado
        super.init(nibName:"HomeViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Ciclo de vida
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Aplicar Redondeo
        number0.round()
        number1.round()
        number2.round()
        number3.round()
        number4.round()
        number5.round()
        number6.round()
        number7.round()
        number8.round()
        number9.round()
        numberDecimal.round()
        opAc.round()
        opPlusMenus.round()
        opPorcent.round()
        opDiv.round()
        opMulti.round()
        opRest.round()
        opPlus.round()
        opResult.round()
        
        // adaptar separador decimal segun localizacion
        numberDecimal.setTitle(decimalSeparator, for: .normal)
        
        //guardar resultado en memoria
        total = UserDefaults.standard.double(forKey: ktotal)

        // mostrar 0 en pantalla al iniciar
        result()
        
        
    }
    
    // MARK: Accion de los botones
    
    // Operadores
    @IBAction func opAcAction(_ sender: UIButton) {
        clear()
        sender.shine()
    }
    
    @IBAction func opPlusMenusAction(_ sender: UIButton) {
        temp = temp * (-1)
        resultLabel.text = printFormatter.string(from: NSNumber(value:  temp))
        sender.shine()
    }
    
    @IBAction func opPorcentAction(_ sender: UIButton) {
        operating = true
        operation = .por
        result()
        sender.shine()
    }
    
    @IBAction func opDivAction(_ sender: UIButton) {
        if operation != .por {
            result()
        }
        operating = true
        operation = .div
        sender.selectOperation(true)
        sender.shine()
    }
    
    @IBAction func opMultiAction(_ sender: UIButton) {
        if operation != .por {
            result()
        }
        operating = true
        operation = .mul
        sender.selectOperation(true)
        sender.shine()
    }
    
    @IBAction func opRestAction(_ sender: UIButton) {
        if operation != .por {
            result()
        }
        operating = true
        operation = .sub
        sender.selectOperation(true)
        sender.shine()
    }
    
    @IBAction func opPlusAction(_ sender: UIButton) {
        if operation != .por {
            result()
        }
        operating = true
        operation = .add
        sender.selectOperation(true)
        sender.shine()
    }
    
    @IBAction func opResultAction(_ sender: UIButton) {
        result()
        sender.shine()
    }
    
    
    // Numeros
    @IBAction func numberDecimalAction(_ sender: UIButton) {
        let currentTemp = auxTotalFormatter.string(from: NSNumber(value: temp))!
        if !operating && currentTemp.count > maxlength {
            return
        }
        resultLabel.text = resultLabel.text! + decimalSeparator
        decimal = true
        selectVisualOperation()
        sender.shine()
    }
    
    @IBAction func numberAction(_ sender: UIButton) {
        opAc.setTitle("C", for: .normal )
        var currentTemp = auxTotalFormatter.string(from: NSNumber(value: temp))!
        if !operating && currentTemp.count > maxlength {
            return
        }
         currentTemp = auxFormatter.string(from: NSNumber(value: temp))!

            // op seleccionada
        if operating {
            total = total == 0 ? temp : total
            resultLabel.text = ""
            currentTemp = ""
            operating = false
        }
        
            // op valores decimales
        if decimal {
            currentTemp = "\(currentTemp)\(decimalSeparator)"
            decimal = false
        }
        
            // asociar numero al temporal
        let number = sender.tag
        temp = Double(currentTemp + String(number))!
        resultLabel.text = printFormatter.string(from: NSNumber(value: temp))

        
        selectVisualOperation()
        sender.shine()
    }
    
    
    // MARK: METODOS
    
    private func clear() { // limpia los valores
        operation = .none
        opAc.setTitle("AC", for: .normal)
        if temp != 0 {
            temp = 0
            resultLabel.text = "0"
        } else {
            total = 0
        }
    }
    
    
    private func result() { // obtiene el resultado final
        switch operation {
        case .none: // no hacemos nada
            break
        case .add:
            total = total + temp
            break
        case .sub:
            total = total - temp
            break
        case .mul:
            total = total * temp
            break
        case .div:
            total = total / temp
            break
        case .por:
            total = temp / 100
            total = temp
            break
        }
        // formateo en pantalla
        if let currentTotal = auxTotalFormatter.string(from: NSNumber(value: total)), currentTotal.count > maxlength {
                   resultLabel.text = printScientificFormatter.string(from: NSNumber(value: total))
               } else {
                   resultLabel.text = printFormatter.string(from: NSNumber(value: total))
               }
            
        operation = .none
        selectVisualOperation()
        UserDefaults.standard.set(total, forKey: ktotal)
        print("TOAL: \(total)")
    }
    
        // muestra de forma visual la operacion seleccionada
    private func selectVisualOperation() {
        if !operating { // no estamos operando
            opPlus.selectOperation(false)
            opRest.selectOperation(false)
            opMulti.selectOperation(false)
            opDiv.selectOperation(false)
        } else {
            switch operation {
            case .none, .por:
                opPlus.selectOperation(false)
                opRest.selectOperation(false)
                opMulti.selectOperation(false)
                opDiv.selectOperation(false)
                break
            case .add:
                opPlus.selectOperation(true)
                opRest.selectOperation(false)
                opMulti.selectOperation(false)
                opDiv.selectOperation(false)
                break
            case .sub:
                opPlus.selectOperation(false)
                opRest.selectOperation(true)
                opMulti.selectOperation(false)
                opDiv.selectOperation(false)
                break
            case .mul:
                opPlus.selectOperation(false)
                opRest.selectOperation(false)
                opMulti.selectOperation(true)
                opDiv.selectOperation(false)
                break
            case .div:
                opPlus.selectOperation(false)
                opRest.selectOperation(false)
                opMulti.selectOperation(false)
                opDiv.selectOperation(true)
                break
            }
        }
    }
}


