import 'package:flutter/material.dart';
import 'package:money_management_app/db/category/category_db.dart';
import 'package:money_management_app/db/transactions/transaction_db.dart';
import 'package:money_management_app/models/category/category_model.dart';
import 'package:money_management_app/models/transactions/transaction_model.dart';

class ScreenAddTransaction extends StatefulWidget {
  static const routeName = 'add-transaction';
  const ScreenAddTransaction({Key? key}) : super(key: key);
  @override
  State<ScreenAddTransaction> createState() => _ScreenAddTransactionState();
}

class _ScreenAddTransactionState extends State<ScreenAddTransaction> {
  DateTime? _selectedDate;
  categoryType? _selectedCategoryType;
  CategoryModel? _selectedCategorymodel;
  String? _selectedDropdown;

  final _purposeTextEditingController = TextEditingController();
  final _amountTextEditingController = TextEditingController();

  @override
  void initState() {
    _selectedCategoryType = categoryType.income;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //purpose

              TextFormField(
                controller: _purposeTextEditingController,
                decoration: const InputDecoration(
                  hintText: 'Purpose',
                ),
              ),

              //amount

              TextFormField(
                controller: _amountTextEditingController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Amount',
                ),
              ),
              const SizedBox(
                height: 20,
              ),

              //date

              TextButton.icon(
                onPressed: () async {
                  final _selectedDateTemp = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now().subtract(
                      const Duration(
                        days: 30,
                      ),
                    ),
                    lastDate: DateTime.now(),
                  );
                  if (_selectedDateTemp == null) {
                    return;
                  } else {
                    setState(() {
                      _selectedDate = _selectedDateTemp;
                    });
                  }
                },
                icon: const Icon(
                  Icons.calendar_today,
                  size: 20,
                  color: Colors.green,
                ),
                label: Text(
                  _selectedDate == null
                      ? 'Select Date'
                      : _selectedDate!.toString(),
                  style: const TextStyle(
                    color: Colors.green,
                  ),
                ),
              ),

              //type

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      Radio(
                        activeColor: Colors.green,
                        value: categoryType.income,
                        groupValue: _selectedCategoryType,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedCategoryType = categoryType.income;
                            _selectedDropdown = null;
                          });
                        },
                      ),
                      const Text('Income')
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        activeColor: Colors.green,
                        value: categoryType.expense,
                        groupValue: _selectedCategoryType,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedCategoryType = categoryType.expense;
                            _selectedDropdown = null;
                          });
                        },
                      ),
                      const Text('Expense')
                    ],
                  ),
                ],
              ),

              //category selection

              DropdownButton<String>(
                hint: const Text('Select Category'),
                value: _selectedDropdown,
                items: (_selectedCategoryType == categoryType.income
                        ? CategoryDB.instance.incomeCategoryListListener.value
                        : CategoryDB.instance.expenseCategoryListListener.value)
                    .map((e) {
                  return DropdownMenuItem(
                    value: e.id,
                    child: Text(e.name),
                    onTap: () {
                      _selectedCategorymodel = e;
                    },
                  );
                }).toList(),
                onChanged: (newvalue) {
                  setState(() {
                    _selectedDropdown = newvalue;
                  });
                },
              ),
              SizedBox(
                height: 20,
              ),
              //submit button

              ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.green),
                onPressed: () {
                  setState(() {
                    addTransaction();
                  });
                },
                child: const Text('Submit'),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> addTransaction() async {
    final _purposeText = _purposeTextEditingController.text;
    final _amountText = _amountTextEditingController.text;
    if (_purposeText.isEmpty) {
      return;
    }

    if (_selectedDate == null) {
      return;
    }
    if (_selectedDropdown == null) {
      return;
    }
    final _parsedAmount = double.tryParse(_amountText);
    if (_parsedAmount == null) {
      return;
    }
    if (_selectedCategorymodel == null) {
      return;
    }
    final _model = TransactionModel(
      purpose: _purposeText,
      amount: _parsedAmount,
      type: _selectedCategoryType!,
      date: _selectedDate!,
      category: _selectedCategorymodel!,
    );
    TransactionDb.instance.addTransaction(_model);
    print(_model);
    Navigator.pop(context);
    TransactionDb.instance.refresh();
  }
}
