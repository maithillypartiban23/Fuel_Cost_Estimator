import 'package:flutter/material.dart';

class FuelCostCalcScreen extends StatefulWidget {
  const FuelCostCalcScreen({super.key});

  @override
  State<FuelCostCalcScreen> createState() => _FuelCostCalcScreenState();
}

class _FuelCostCalcScreenState extends State<FuelCostCalcScreen> 
{
  String fueltype = 'Diesel';
  TextEditingController distanceController = TextEditingController();
  TextEditingController efficiencyController = TextEditingController();
  
  double fuelcost = 0.0;
  FocusNode distanceFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: Colors.purple[100],
      appBar: AppBar(
        title: Text('Trip Fuel Cost Estimator', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 153, 52, 148),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16.0),
            margin: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(9.0),
              color: const Color.fromARGB(255, 179, 145, 241),
            ),
            width: 350,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Fuel Type Dropdown
                Row(
                  children: [
                    SizedBox(width: 100, child: Text('Fuel Type')),
                    DropdownButton<String>(
                      value: fueltype,
                      items: <String>['Diesel', 'RON95', 'RON97', 'Electric'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        fueltype = newValue!;
                        setState(() {});
                      },
                    ),
                  ],
                ),
                SizedBox(height: 10),

                //Distance
                Row(
                  children: [
                    SizedBox(width: 100, child: Text('Distance')),
                    SizedBox(
                      width: 200,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        focusNode: distanceFocusNode,
                        controller: distanceController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Distance (km)',
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),

                //Efficency
                Row(
                  children: [
                    SizedBox(width: 100, child: Text('Efficency')),
                    SizedBox(
                      width: 200,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: efficiencyController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Efficiency (km/L)',
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
            
                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                       onPressed: () => calculateFuelCost(fueltype),
                      child: Text('Calculate Fuel Cost'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        distanceController.clear();
                        efficiencyController.clear();
                        fueltype = 'Diesel';
                      

                        FocusScope.of(context).requestFocus(distanceFocusNode);
                        distanceFocusNode.requestFocus();

                        fuelcost = 0.0;
                        setState(() {});
                      },
                      child: Text('Reset'),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                
                //Result
                Text(
                   'Estimated Fuel Cost: RM ${fuelcost.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

    
 // Auto fuel price calculation based on Malaysian pricing 
  void calculateFuelCost(String fuelType) {
    double? distance = double.tryParse(distanceController.text);
    double? efficiency = double.tryParse(efficiencyController.text);

// If no input is entered by the user
    if (distance == null || efficiency == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Please enter valid numbers for distance and efficiency.'),
          backgroundColor: Color.fromARGB(255, 238, 118, 109),
          duration: Duration(seconds: 2),
        ),
      );

      setState(() {
        fuelcost = 0.0;
      });
      return;
    }

    if (distance <= 0 || efficiency <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Values must be greater than zero.'),
          backgroundColor: Color.fromARGB(255, 238, 118, 109),
          duration: Duration(seconds: 2),
        ),
      );
      setState(() {
        fuelcost = 0.0;
      });
      return;
    }

    // Automatically set Malaysian fuel prices
    // Reference : https://ringgitplus.com/en/blog/sponsored/petrol-price-malaysia-live-updates-ron95-ron97-diesel.html
    
    double price = 0.0;
    if (fuelType == 'RON95') {
      price = 2.60; // RM per litre
    } else if (fuelType == 'RON97') {
      price = 3.14;
    } else if (fuelType == 'Diesel') {
      price = 2.89;
    } else if (fuelType == 'Electric') {
      price = 0.70; 
    }

    // Calculate cost
    double cost = (distance / efficiency) * price;

    setState(() {
      fuelcost = cost;
    });
  }
}