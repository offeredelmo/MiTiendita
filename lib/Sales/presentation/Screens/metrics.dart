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
    "Enero",
    "Febrero",
    "Marzo",
    "Abril",
    "Mayo",
    "Junio",
    "Julio",
    "Agosto",
    "Septiembre",
    "Octubre",
    "Noviembre",
    "Diciembre"
  ];

  static const List<String> years = [
    "2020",
    "2021",
    "2022",
    "2023",
    "2024",
    "2025",
    "2026",
    "2027",
    "2028",
    "2029",
    "2030",
    "2031"
  ];

  _totoalMonth(List<double> totalSales) {
    double totalDaysSum = totalSales.reduce((a, b) => a + b);
    return totalDaysSum;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          CustomDropdown(
            selectedValueMonth: selectedMonth,
            selectedValueYear: selectedYear,
            months: months,
            years: years,
            onMonthChanged: (String? newValueMonth) {
              setState(() {
                selectedMonth = newValueMonth!;
                int indexMonth =
                    months.indexWhere((month) => month == selectedMonth);
                DateTime date =
                    DateTime(int.parse(selectedYear), indexMonth + 1);
                context.read<MetricsBloc>().add(GetMonthSales(month: date));
              });
            },
            onYearChanged: (String? newValueYear) {
              setState(() {
                selectedYear = newValueYear!;
                int indexMonth =
                    months.indexWhere((month) => month == selectedMonth);
                DateTime date =
                    DateTime(int.parse(selectedYear), indexMonth + 1);
                context.read<MetricsBloc>().add(GetMonthSales(month: date));
              });
            },
          ),
          BlocConsumer<MetricsBloc, MetricsState>(
              listener: (context, state) {},
              builder: (context, state) {
                if (state is SalesGetMonthSalesLoading) {
                  return const Text(
                      "Calculando datos ..... esto puede tardar un poco");
                } else if (state is SalesGetMonthSalesSucces) {
                  return Expanded(
                    child: Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          decoration: BoxDecoration(
                              color: Colors.green.shade300,
                              borderRadius: BorderRadius.circular(5)),
                          margin: const EdgeInsets.all(5),
                          padding: const EdgeInsets.all(5),
                          height: 40,
                          child: Text(
                            "Total del mes: ${_totoalMonth(state.totalSales)}",
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                              itemCount: state.totalSales.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                                  child: Container(
                                      width: MediaQuery.of(context).size.width * 0.9,
                                      padding: const EdgeInsets.all(5),
                                      height: 50,
                                      child: Row(
                                        children: [
                                          Text(
                                            "Fecha: ${index + 1} de $selectedMonth $selectedYear",
                                            style:
                                                const TextStyle(fontSize: 18),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "Total ${state.totalSales[index]}",
                                            style:
                                                const TextStyle(fontSize: 18),
                                          ),
                                        ],
                                      )),
                                );
                              }),
                        ),
                      ],
                    ),
                  );
                } else {
                  return const Text("a ocurrido un error intenta despues");
                }
              })
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
