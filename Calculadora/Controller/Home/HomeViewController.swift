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
    @IBOutlet private weak var opMulti2: UIButton!
    @IBOutlet private weak var opDiv2: UIButton!
    
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
  
    // Purple colors (numbers)
    private let darkPurple = UIColor(red: 0.8, green: 0.4, blue: 0.7, alpha: 1.0)
    private let lightPurple = UIColor(red: 0.8, green: 0.4, blue: 0.7, alpha: 1.0)
    
    // Blue colors (basic operations)
    private let darkBlue = UIColor(red: 0.2, green: 0.6, blue: 0.9, alpha: 1.0)
    private let lightBlue = UIColor(red: 0.2, green: 0.6, blue: 0.9, alpha: 1.0)
    
    // Green colors (x2, /2)
    private let darkGreen = UIColor(red: 0.2, green: 0.8, blue: 0.4, alpha: 1.0)
    private let lightGreen = UIColor(red: 0.2, green: 0.8, blue: 0.4, alpha: 1.0)
    
    // Yellow colors (AC, +/-, %)
    private let darkYellow = UIColor(red: 0.9, green: 0.8, blue: 0.2, alpha: 1.0)
    private let lightYellow = UIColor(red: 0.9, green: 0.8, blue: 0.2, alpha: 1.0)
    
    
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
        
        // Cambios de tema
                NotificationCenter.default.addObserver(self,
                                                     selector: #selector(themeChanged),
                                                     name: UIApplication.didBecomeActiveNotification,
                                                     object: nil)
                
                // Aplicar tema inicial
                applyTheme()
        
        
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
        opMulti2.round()
        opDiv2.round()
        
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
        resultLabel.text = printFormatter.string(from: NSNumber(value: temp))
        sender.shine()
    }
    
    @IBAction func opPorcentAction(_ sender: UIButton) {
        if operation == .none {
            temp = temp / 100
        } else {
            temp = (total * temp) / 100
        }
        resultLabel.text = printFormatter.string(from: NSNumber(value: temp))
        sender.shine()
    }
    

    @IBAction func opDivAction(_ sender: UIButton) {
        if operation != .por && !operating {
            result()
        }
        operating = true
        operation = .div
        sender.selectOperation(true)
        sender.shine()
    }
    
    @IBAction func opMultiAction(_ sender: UIButton) {
        if operation != .por && !operating {
            result()
        }
        operating = true
        operation = .mul
        sender.selectOperation(true)
        sender.shine()
    }
    
    @IBAction func opRestAction(_ sender: UIButton) {
         if operation != .por && !operating {
             result()
         }
         operating = true
         operation = .sub
         sender.selectOperation(true)
         sender.shine()
     }
    
    @IBAction func opPlusAction(_ sender: UIButton) {
        if operation != .por && !operating {
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
    
    
    @IBAction func opMulti2Action(_ sender: UIButton) {
        temp = temp * 2
        total = temp
        resultLabel.text = printFormatter.string(from: NSNumber(value: temp))
        operating = false
        operation = .none
        selectVisualOperation()
        sender.shine()
    }
    
    @IBAction func opDiv2Action(_ sender: UIButton) {
        temp = temp / 2
        total = temp
        resultLabel.text = printFormatter.string(from: NSNumber(value: temp))
        operating = false
        operation = .none
        selectVisualOperation()
        sender.shine()
    }
    
    
    
    // Numeros
    @IBAction func numberDecimalAction(_ sender: UIButton) {
        let currentTemp = auxTotalFormatter.string(from: NSNumber(value: temp))!
        if !operating && currentTemp.count > maxlength {
            return
        }
        
        if !resultLabel.text!.contains(decimalSeparator) {
            resultLabel.text = resultLabel.text! + decimalSeparator
            decimal = true
        }
        
        selectVisualOperation()
        sender.shine()
    }
    
    @IBAction func numberAction(_ sender: UIButton) {
           opAc.setTitle("C", for: .normal)
           
           // Si estamos operando o después de una operación, reiniciar temp
           if operating {
               total = temp  // Guardamos el valor anterior
               temp = 0
               resultLabel.text = "0"
               operating = false
           }
           
           let number = Double(sender.tag)
           
           // Manejar decimales
           if decimal {
               let currentText = resultLabel.text ?? "0"
               if !currentText.contains(decimalSeparator) {
                   resultLabel.text = currentText + decimalSeparator
               }
               resultLabel.text = resultLabel.text! + String(Int(number))
               temp = Double(resultLabel.text!.replacingOccurrences(of: decimalSeparator, with: ".")) ?? 0
           } else {
               temp = (temp * 10) + number
               resultLabel.text = printFormatter.string(from: NSNumber(value: temp))
           }
           
           selectVisualOperation()
           sender.shine()
       }
    
    // MARK: METODOS
    
    @objc private func themeChanged() {
           applyTheme()
       }
    
    
    private func applyTheme() {
        let isDarkMode = traitCollection.userInterfaceStyle == .dark
        
        // Configurar color de fondo
        view.backgroundColor = isDarkMode ? .black : .white
        
        // Configurar color de texto
        resultLabel.textColor = isDarkMode ? .white : .black
        
        // Configurar colores de botones numéricos
                let numberColor = isDarkMode ? darkPurple : lightPurple
                [number0, number1, number2, number3, number4,
                 number5, number6, number7, number8, number9, numberDecimal].forEach { button in
                    button?.backgroundColor = numberColor
                    button?.setTitleColor(.white, for: .normal) // Siempre blanco
                }
        
        // Configurar colores de botones de operación básica
                let operationColor = isDarkMode ? darkBlue : lightBlue
                [opDiv, opMulti, opRest, opPlus, opResult].forEach { button in
                    button?.backgroundColor = operationColor
                    button?.setTitleColor(.white, for: .normal) // Siempre blanco
                }
        
        // Configurar colores de botones especiales (x2, /2)
        let specialColor = isDarkMode ? darkGreen : lightGreen
        [opMulti2, opDiv2].forEach { button in
            button?.backgroundColor = specialColor
            button?.setTitleColor(isDarkMode ? .white : .black, for: .normal)
        }
        
        // Configurar colores de botones de función
        let functionColor = isDarkMode ? darkYellow : lightYellow
        [opAc, opPlusMenus, opPorcent].forEach { button in
            button?.backgroundColor = functionColor
            button?.setTitleColor(isDarkMode ? .white : .black, for: .normal)
        }
        
        // Asegurar que AC y decimal tengan texto blanco
        opAc.setTitleColor(.white, for: .normal)
        numberDecimal.setTitleColor(.white, for: .normal)
    }
       
       override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
           super.traitCollectionDidChange(previousTraitCollection)
           applyTheme()
       }
    
    
    
    private func clear() { // limpia los valores
        if operation == .none {
            total = 0
            temp = 0
        } else {
            temp = 0
        }
        operation = .none
        operating = false
        decimal = false
        opAc.setTitle("AC", for: .normal)
        resultLabel.text = "0"
        
        // Resetear la persistencia cuando se limpia todo
        if total == 0 {
            UserDefaults.standard.set(0, forKey: ktotal)
        }
        
        selectVisualOperation()
    }
    
    
  
    private func result() {
        if temp == 0 && operation == .div {
            return
        }
        
        switch operation {
        case .none:
            total = temp
        case .add:
            total = total + temp
        case .sub:
            total = total - temp
        case .mul:
            total = total * temp
        case .div:
            total = total / temp
            // Formateo especial para división: redondear a 2 decimales
            let roundedTotal = round(total * 100) / 100
            resultLabel.text = printFormatter.string(from: NSNumber(value: roundedTotal))
            
            temp = total  // Mantenemos el valor exacto en temp
            operation = .none
            operating = true
            decimal = false
            
            selectVisualOperation()
            UserDefaults.standard.set(total, forKey: ktotal)
            return // Salimos para evitar el formateo estándar
        case .por:
            return
        }
        
        // formateo en pantalla (para todas las operaciones excepto división)
        if let currentTotal = auxTotalFormatter.string(from: NSNumber(value: total)), currentTotal.count > maxlength {
            resultLabel.text = printScientificFormatter.string(from: NSNumber(value: total))
        } else {
            resultLabel.text = printFormatter.string(from: NSNumber(value: total))
        }
        
        temp = total  // Guardamos el total para la siguiente operación
        operation = .none
        operating = true
        decimal = false
        
        selectVisualOperation()
        UserDefaults.standard.set(total, forKey: ktotal)
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


