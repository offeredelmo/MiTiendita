import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mi_tiendita/expenses/presentation/block/get_expense.dart';
import 'package:mi_tiendita/expenses/presentation/block/get_expenses_by_month_bloc.dart';

import '../../domain/expense_entity.dart';
import '../block/delete_expense_by_id_bloc.dart';
import '../block/create_expense_bloc.dart';

class ExpensesByDateScreen extends StatefulWidget {
  const ExpensesByDateScreen({super.key});

  @override
  State<ExpensesByDateScreen> createState() => _ExpensesByDateScreenState();
}

class _ExpensesByDateScreenState extends State<ExpensesByDateScreen> {
  DateTime? selectedDate;
  getExpensesToday() {
    print("getExpensesToday");
    setState(() {
      BlocProvider.of<GetExpensesBloc>(context)
          .add(GetExpensesEvent(day: DateTime.now()));
    });
  }

  getExpensesYesterday() {
    print("getExpensesYesterday");
    setState(() {
      selectedDate = DateTime.now().subtract(const Duration(days: 1));
      BlocProvider.of<GetExpensesBloc>(context)
          .add(GetExpensesEvent(day: selectedDate!));
    });
  }

  getExpensesByDate(DateTime date) {
    print("getExpensesByDate");
    setState(() {
      selectedDate = date;
      BlocProvider.of<GetExpensesBloc>(context)
          .add(GetExpensesEvent(day: selectedDate!));
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    BlocProvider.of<GetExpensesBloc>(context)
        .add(GetExpensesEvent(day: DateTime.now()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Gastos'),
          actions: [
            TextButton.icon(
                onPressed: () {
                  modalAddExpense(context);
                },
                label: Text("Agregar un gasto"),
                icon: Icon(Icons.add))
          ],
        ),
        body: ExpensesByDateBody(
          selectedDate: selectedDate,
          getExpensesToday: getExpensesToday,
          getExpensesYesterday: getExpensesYesterday,
          getExpensesByDate: getExpensesByDate,
        ));
  }

  Future<dynamic> modalAddExpense(BuildContext context) {
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController amountController = TextEditingController();
    final FocusNode amountFocus = FocusNode();
    final FocusNode descriptionFocus = FocusNode();

    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return BlocListener<CreateExpenseBloc, CreateExpenseState>(
            listener: (context, state) {
              if (state is CreateExpenseSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Gasto agregado correctamente'),
                    backgroundColor: Colors.green,
                  ),
                );
                context.read<GetTotalExpensesByMonthBloc>().add(GetExpensesByMonthEvent(date: DateTime.now()));
              }
              if (state is CreateExpenseFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Error al agregar el gasto'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: Container(
              height: MediaQuery.of(context).size.height * 0.7,
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text("Agrega la descripción y el monto del gasto"),
                  const SizedBox(height: 20),
                  TextField(
                    controller: descriptionController,
                    focusNode: descriptionFocus,
                    onTapOutside: (event) {
                      descriptionFocus.unfocus();
                    },
                    decoration: const InputDecoration(
                      labelText: "Descripción",
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: amountController,
                    focusNode: amountFocus,
                    onTapOutside: (event) {
                      amountFocus.unfocus();
                    },
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Monto",
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                      onPressed: () {
                        BlocProvider.of<CreateExpenseBloc>(context).add(
                            CreateExpenseEvent(
                                expense: ExpenseEntity(
                                    id: 0,
                                    amount: double.parse(amountController.text),
                                    description: descriptionController.text,
                                    date: DateTime.now())));
                        //si el dia seleccionado es igual a hoy se actualiza la lista de gastos, o null ya que no se a seleccionado fecha, se muestra por predeterminado los gastos de hoy
                        if (selectedDate == null) {
                          Future.delayed(const Duration(seconds: 1), () {
                            getExpensesToday();
                          });
                        } else {
                          if (selectedDate!.day == DateTime.now().day) {
                            Future.delayed(const Duration(seconds: 1), () {
                              getExpensesToday();
                            });
                          }
                        }
                        //Salir del modal
                        Navigator.of(context).pop();
                      },
                      child: const Text("Agregar"))
                ],
              ),
            ));
      },
    );
  }
}

class ExpensesByDateBody extends StatelessWidget {
  ExpensesByDateBody(
      {super.key,
      required this.selectedDate,
      required this.getExpensesToday,
      required this.getExpensesYesterday,
      required this.getExpensesByDate});

  final DateTime? selectedDate;
  final Function getExpensesToday;
  final Function getExpensesYesterday;
  final Function getExpensesByDate;
  // Función para mostrar el DatePicker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Fecha inicial (actual)
      firstDate: DateTime(2024), // Fecha mínima
      lastDate: DateTime(2030), // Fecha máxima
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      getExpensesByDate(pickedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  onPressed: () {
                    getExpensesToday();
                  },
                  child: const Text("Hoy")),
              ElevatedButton(
                  onPressed: () {
                    getExpensesYesterday();
                  },
                  child: const Text("Ayer")),
              ElevatedButton(
                  onPressed: () {
                    _selectDate(context);
                  },
                  child: selectedDate == null
                      ? const Text("Seleccionar fecha")
                      : Text(
                          "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}")),
            ],
          ),
        ),
        BlocBuilder<GetExpensesBloc, GetExpensesState>(
          builder: (context, state) {
            print("stado: ${state}");
            if (state is GetExpensesLoading) {
              return const CircularProgressIndicator();
            }
            if (state is GetExpensesSucces) {
              return state.expenses.isEmpty
                  ? const Text("No hay gastos")
                  : Expanded(
                      child: ListView.builder(
                        itemCount: state.expenses.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(state.expenses[index].description),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("gasto: ${state.expenses[index].amount}"),
                                Text(
                                    "fecha:${state.expenses[index].date.day}/${state.expenses[index].date.month}/${state.expenses[index].date.year}"),
                                IconButton(
                                    onPressed: () {
                                      BlocProvider.of<DeleteExpenseByIdBloc>(
                                              context)
                                          .add(DeleteExpenseByIdEvent(
                                              id: state.expenses[index].id));
                                      if (selectedDate == null) {
                                        Future.delayed(
                                            const Duration(seconds: 1), () {
                                          getExpensesToday();
                                        });
                                      } else {
                                        getExpensesByDate(selectedDate!);
                                      }
                                      Future.delayed(const Duration(seconds: 1),
                                          () {
                                        getExpensesToday();
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ))
                              ],
                            ),
                          );
                        },
                      ),
                    );
            } else {
              return const Text("Error");
            }
          },
        )
      ],
    );
  }
}
