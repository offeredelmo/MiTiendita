import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/metrics/metrics_bloc.dart';

class Metrics extends StatefulWidget {
  const Metrics({super.key});

  @override
  State<Metrics> createState() => _MetricsState();
}

class _MetricsState extends State<Metrics> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<MetricsBloc>().add(GetMonthSales(month: DateTime.now()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Métricas"),
      ),
      body: const BodyMetrics(),
    );
  }
}

class BodyMetrics extends StatefulWidget {
  const BodyMetrics({super.key});

  @override
  State<BodyMetrics> createState() => _BodyMetricsState();
}

class _BodyMetricsState extends State<BodyMetrics> {
  String selectedMonth = months[DateTime.now().month - 1];
  String selectedYear = DateTime.now().year.toString();

  static const List<String> months = [
    "Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio",
    "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"
  ];

  static const List<String> years = [
    "2020", "2021", "2022", "2023", "2024", "2025",
    "2026", "2027", "2028", "2029", "2030", "2031"
  ];

  double _totoalMonth(List<double> totalSales) {
    return totalSales.fold(0.0, (a, b) => a + b);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          CustomDropdown(
            selectedValueMonth: selectedMonth,
            selectedValueYear: selectedYear,
            months: months,
            years: years,
            onMonthChanged: (String? newValueMonth) {
              setState(() {
                selectedMonth = newValueMonth!;
                int indexMonth = months.indexOf(selectedMonth);
                DateTime date = DateTime(int.parse(selectedYear), indexMonth + 1);
                context.read<MetricsBloc>().add(GetMonthSales(month: date));
              });
            },
            onYearChanged: (String? newValueYear) {
              setState(() {
                selectedYear = newValueYear!;
                int indexMonth = months.indexOf(selectedMonth);
                DateTime date = DateTime(int.parse(selectedYear), indexMonth + 1);
                context.read<MetricsBloc>().add(GetMonthSales(month: date));
              });
            },
          ),
          const SizedBox(height: 18),
          BlocConsumer<MetricsBloc, MetricsState>(
            listener: (context, state) {},
            builder: (context, state) {
              if (state is SalesGetMonthSalesLoading) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              } else if (state is SalesGetMonthSalesSucces) {
                return Column(
                  children: [
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      color: Colors.deepPurple.shade100,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.calendar_month, color: Colors.deepPurple, size: 28),
                            const SizedBox(width: 12),
                            Text(
                              "Total del mes:",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurple.shade700),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "\$${_totoalMonth(state.totalSales).toStringAsFixed(2)}",
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green.shade700),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.totalSales.length,
                      itemBuilder: (context, index) {
                        final double daySale = state.totalSales[index];
                        final bool noSale = daySale == 0.0;
                        return Card(
                          elevation: noSale ? 1 : 4,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          color: noSale
                              ? Colors.grey.shade200
                              : Colors.green.shade100,
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: noSale ? Colors.grey.shade400 : Colors.green.shade400,
                              child: Icon(
                                noSale ? Icons.remove_circle_outline : Icons.attach_money,
                                color: Colors.white,
                              ),
                            ),
                            title: Text(
                              "Día ${index + 1} de $selectedMonth $selectedYear",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: noSale ? Colors.grey : Colors.green.shade900,
                              ),
                            ),
                            subtitle: Text(
                              noSale ? "Sin ventas" : "Total: \$${daySale.toStringAsFixed(2)}",
                              style: TextStyle(
                                color: noSale ? Colors.grey : Colors.green.shade800,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                );
              } else {
                return const Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Text("Ha ocurrido un error, intenta después", style: TextStyle(color: Colors.red)),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class CustomDropdown extends StatelessWidget {
  final String selectedValueMonth;
  final String selectedValueYear;
  final List<String> months;
  final List<String> years;
  final ValueChanged<String?> onMonthChanged;
  final ValueChanged<String?> onYearChanged;

  const CustomDropdown({
    required this.selectedValueMonth,
    required this.selectedValueYear,
    required this.months,
    required this.years,
    required this.onMonthChanged,
    required this.onYearChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.40,
          child: DropdownButtonFormField<String>(
            value: selectedValueMonth,
            decoration: InputDecoration(
              labelText: "Selecciona un mes",
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            items: months.map<DropdownMenuItem<String>>((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList(),
            onChanged: onMonthChanged, // Maneja el cambio de mes
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.1,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.40,
          child: DropdownButtonFormField<String>(
            value: selectedValueYear,
            decoration: InputDecoration(
              labelText: "Selecciona un año",
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            items: years.map<DropdownMenuItem<String>>((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList(),
            onChanged: onYearChanged, // Maneja el cambio de año
          ),
        ),
      ],
    );
  }
}
