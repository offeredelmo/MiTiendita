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
      selectedDate = null; // <-- Esto resetea el selector de fecha
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
                icon: const Icon(Icons.add))
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
      backgroundColor: Colors.transparent,
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
              context
                  .read<GetTotalExpensesByMonthBloc>()
                  .add(GetExpensesByMonthEvent(date: DateTime.now()));
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
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Container(
                  width: constraints.maxWidth,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(24)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.07),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Agregar gasto",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 18),
                      TextFormField(
                        controller: descriptionController,
                        focusNode: descriptionFocus,
                        decoration: InputDecoration(
                          labelText: "Descripción",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                BorderSide(color: Colors.deepPurple.shade400),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                BorderSide(color: Colors.deepPurple.shade400),
                          ),
                          prefixIcon: Icon(Icons.description,
                              color: Colors.deepPurple.shade400),
                        ),
                        onTapOutside: (_) => descriptionFocus.unfocus(),
                      ),
                      const SizedBox(height: 18),
                      TextFormField(
                        controller: amountController,
                        focusNode: amountFocus,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Monto",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                BorderSide(color: Colors.deepPurple.shade400),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                BorderSide(color: Colors.deepPurple.shade400),
                          ),
                          prefixIcon: Icon(Icons.attach_money,
                              color: Colors.deepPurple.shade400),
                        ),
                        onTapOutside: (_) => amountFocus.unfocus(),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          icon: const Icon(Icons.add),
                          label: const Text("Agregar gasto",
                              style: TextStyle(fontSize: 16)),
                          onPressed: () {
                            BlocProvider.of<CreateExpenseBloc>(context).add(
                                CreateExpenseEvent(
                                    expense: ExpenseEntity(
                                        id: 0,
                                        amount:
                                            double.parse(amountController.text),
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
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class ExpensesByDateBody extends StatelessWidget {
  ExpensesByDateBody({
    super.key,
    required this.selectedDate,
    required this.getExpensesToday,
    required this.getExpensesYesterday,
    required this.getExpensesByDate,
  });

  final DateTime? selectedDate;
  final Function getExpensesToday;
  final Function getExpensesYesterday;
  final Function getExpensesByDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
      locale: const Locale('es', 'ES'),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      getExpensesByDate(pickedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple.shade50,
                  foregroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => getExpensesToday(),
                icon: const Icon(Icons.today),
                label: const Text("Hoy"),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple.shade50,
                  foregroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => getExpensesYesterday(),
                icon: const Icon(Icons.history),
                label: const Text("Ayer"),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple.shade50,
                  foregroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => _selectDate(context),
                icon: const Icon(Icons.calendar_month),
                label: selectedDate == null
                    ? const Text("Fecha")
                    : Text(
                        "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Expanded(
            child: BlocBuilder<GetExpensesBloc, GetExpensesState>(
              builder: (context, state) {
                if (state is GetExpensesLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is GetExpensesSucces) {
                  if (state.expenses.isEmpty) {
                    return const Center(
                        child: Text("No hay gastos registrados",
                            style: TextStyle(color: Colors.grey)));
                  }
                  return ListView.separated(
                    itemCount: state.expenses.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final expense = state.expenses[index];
                      return Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        color: Colors.white,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.deepPurple.shade100,
                            child: Icon(Icons.money_off,
                                color: Colors.deepPurple.shade700),
                          ),
                          title: Text(
                            expense.description,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Monto: \$${expense.amount.toStringAsFixed(2)}",
                                style: TextStyle(
                                  color: Colors.deepPurple.shade700,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                "Fecha: ${expense.date.day}/${expense.date.month}/${expense.date.year}",
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 13),
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              BlocProvider.of<DeleteExpenseByIdBloc>(context)
                                  .add(DeleteExpenseByIdEvent(id: expense.id));
                              if (selectedDate == null) {
                                Future.delayed(const Duration(seconds: 1), () {
                                  getExpensesToday();
                                });
                              } else {
                                getExpensesByDate(selectedDate!);
                              }
                            },
                          ),
                        ),
                      );
                    },
                  );
                }
                return const Center(
                    child: Text("Error al cargar gastos",
                        style: TextStyle(color: Colors.red)));
              },
            ),
          ),
        ],
      ),
    );
  }
}
