//
//  ContentView.swift
//  WeSplitReal
//
//  Created by Steven Gustason on 3/16/23.
//

import SwiftUI

struct ContentView: View {
    // State variable to track the check amount
    @State private var checkAmount = 0.0
    // State variable to track number of people
    @State private var numberOfPeople = 2
    // State variable to track the tip percent
    @State private var tipPercentage = 20
    // Array of tipping options
    let tipPercentages = [15, 20, 25, 30, 0]
    
    // Calculate the total per person
    var totalPerPerson: Double {
        // This counts from 0, but we're starting at 2, so adding 2 here
        let peopleCount = Double(numberOfPeople + 2)
        let tipSelection = Double(tipPercentage)
        
        // Calculating the tip value by multiple the tip selection by the check amount
        let tipValue = checkAmount * (tipSelection / 100)
        // Adding the tip to the check
        let grandTotal = checkAmount + tipValue
        // Finally, dividing total amount by number of people
        let amountPerPerson = grandTotal / peopleCount
        
        // Returning that amount per person
        return amountPerPerson
    }
    
    // Variable to store the total for our total bill field
    var totalAmount: Double {
        let totalAmount = totalPerPerson * Double(numberOfPeople)
        return totalAmount
    }
    
    // Storing the local currency formatting here so we don't have to type it out multiple times
    var localCurrency: FloatingPointFormatStyle<Double>.Currency {
        .currency(code: Locale.current.currency?.identifier ?? "USD")
    }
    
    // Creating a variable for the focus state
    @FocusState private var amountIsFocused: Bool
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    // Here's our first text field bound to a state variable for a user to type in the check amount
                    TextField("Amount", value: $checkAmount, format: localCurrency)
                    // Here we make sure the keyboard type is a decimal pad so it just has numbers and a decimal point instead of the full alpha keyboard
                        .keyboardType(.decimalPad)
                    // We also track focus here
                        .focused($amountIsFocused)
                    // Header for readability
                } header: {
                    Text("Amount")
                }
                // Here we create our text field for number of people - we use ForEach to dynamically create a picker form
                Section {
                    Picker("Number of people", selection: $numberOfPeople) {
                        ForEach(2..<30) {
                            Text("\($0) people")
                        }
                    }
                }
                // Here we utilize our array of tip percentages to create a segmented picker form
                Section {
                    Picker("Tip percentage", selection: $tipPercentage) {
                        ForEach(tipPercentages, id: \.self) {
                            Text($0, format: .percent)
                        }
                    }.pickerStyle(.segmented)
                    // We add a header here for readability as well
                } header: {
                    Text("How much tip do you want to leave?")
                }
                // Here we display the total amount with an appropriate header
                Section {
                    Text(totalAmount, format: localCurrency)
                } header: {
                    Text("Total amount (bill + tip)")
                }
                // And finally, the amount per person with a header
                Section {
                    Text(totalPerPerson, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                } header: {
                    Text("Amount per person")
                }
            }
            // Here we add a navigation title
            .navigationTitle("WeSplit")
            // And this allows us to modify our keyboard to have a Done button that removes focus from the field when the user presses it
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    
                    Button("Done") {
                        amountIsFocused = false
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
