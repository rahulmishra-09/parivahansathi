import 'package:flutter/material.dart';

class ProductDetails extends StatefulWidget {
  final Map<String, dynamic> ? existingData;
  const ProductDetails({super.key, this.existingData});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  final productName = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? products;
  String? weights;

  @override
  void initState() {
  super.initState();
  if (widget.existingData != null) {
    productName.text = widget.existingData!['name'] as String;
    products = widget.existingData!['number'] as String?;
    weights = widget.existingData!['weight'] as String?;
  }
}

  @override
  Widget build(BuildContext context) {
    var textStyle = TextStyle(
        fontSize: 14, color: Colors.black, fontWeight: FontWeight.w500);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Product Details',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(14),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Product Name', style: textStyle),
                const SizedBox(
                  height: 4,
                ),
                TextFormField(
                  controller: productName,
                  textCapitalization: TextCapitalization.characters,
                  style: TextStyle(color: Colors.black),
                  cursorColor: Colors.black,
                  autofocus: false,
                  maxLength: 23,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                    hintText: 'Enter Product Name',
                    counterText: '',
                    hintStyle: TextStyle(color: Colors.black, fontSize: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter Product Name!!";
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Text('Number of Product', style: textStyle),
                const SizedBox(
                  height: 4,
                ),
                DropdownButtonFormField(
                    decoration: InputDecoration(
                      hintText: 'Select Product',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                    value: products,
                    items: ['1', '2', '3']
                        .map((product) => DropdownMenuItem(
                            value: product,
                            child: Text(product,
                                style: TextStyle(color: Colors.grey[800]))))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        products = value;
                      });

                    },
                    validator: (value) {
                    if (value== null) {
                      return "Select Numbers Of Product";
                    } else {
                      return null;
                    }
                  },
                    ),
                const SizedBox(
                  height: 20,
                ),
                Text('Weight of Product', style: textStyle),
                const SizedBox(
                  height: 4,
                ),
                DropdownButtonFormField(
                    decoration: InputDecoration(
                      hintText: 'Select Weight Product!!',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                    value: weights,
                    items: [
                      '100 - 140 KG',
                      '141 - 200 KG',
                      '201 - 350 KG',
                      '350 - above'
                    ].map((weight) {
                      return DropdownMenuItem(value: weight, child: Text(weight));
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        weights = value;
                      });
                    },
                    validator: (value) {
                    if (value == null) {
                      return "Enter Product's Weight!!";
                    } else {
                      return null;
                    }
                  },
                    ),
                const SizedBox(
                  height: 20,
                ),
                Text('Describe About Your Product', style: textStyle),
                const SizedBox(
                  height: 4,
                ),
                Container(
                  height: 100,
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(
                      color: Colors.blue,
                    ),
                  ),
                  child: Center(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: TextField(
                        textAlign: TextAlign.center,
                        maxLines: null,
                        maxLength: 100,
                        keyboardType: TextInputType.multiline,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                            counterText: '',
                            hintText: "Content(Optional)",
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30,),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {
                        if(_formKey.currentState!.validate()){
                          if(productName.text.isNotEmpty || products != null || weights != null ) {
                          Navigator.of(context).pop({
                            'name': productName.text.trim(),
                            "weight": weights,
                            'number': products,
                            'isChecked': widget.existingData ?['isChecked'] ?? true,
                        });
                        }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          padding: EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.0))),
                      child: Text(
                        'Save',
                        style: TextStyle(color: Colors.white, fontSize: 17),
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
