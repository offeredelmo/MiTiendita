import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:mi_tiendita/Sales/data/models/sele_model.dart';
import 'package:mi_tiendita/Sales/domain/sales.entity.dart';
import 'package:mi_tiendita/core/error/failures.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:objectid/objectid.dart';

import '../../../Products/data/models/product_model.dart';

abstract class SaleLocalDataSource {
  Future<List<SalesEntity>> getSales();
  Future<List<SalesEntity>> getSalesByDay(DateTime day);
  Future<List<double>> getSalesByMonth(DateTime month);
  Future<bool> addSell(SalesEntity salesEntity);
  Future<double> getTotalSaleByDay(DateTime day);
}

class SaleLocalDatasourceImpl implements SaleLocalDataSource {
  static const String _boxName = 'sales';

  @override
  Future<bool> addSell(SalesEntity salesEntity) async {
    try {
      final box = await Hive.openBox<SaleDto>(_boxName);
      final id = ObjectId().toString();
      final newSale = SaleModel.fromEntity(
          SalesEntity(
              id: id, saleDate: DateTime.now(), items: salesEntity.items),
          totalsale: salesEntity.totalsale ?? 0);
      await box.put(id, SaleDto.fromModel(newSale));

      final boxProducts = await Hive.openBox<ProductDto>("products");

      for (var element in salesEntity.items) {
        final existingProductDto = boxProducts.get(element.product.id);
        if (existingProductDto!.stock > 0) {
          existingProductDto.stock = existingProductDto.stock - element.quantity;
          if(existingProductDto.stock < 0){
            existingProductDto.stock = 0;
          }
          await existingProductDto.save();
        }
      }

      return true;
    } catch (e) {
      debugPrint("erorrrrr: ${e}");
      throw LocalFailure();
    }
  }

  @override
  Future<List<SalesEntity>> getSales() async {
    // Filtrar las ventas que ocurren hoy

    throw UnimplementedError();
  }

  @override
  Future<List<SalesEntity>> getSalesByDay(DateTime day) async {
    try {
      final box = await Hive.openBox<SaleDto>(_boxName);
      final salesByDay = box.values.where((sale) {
        return (sale.saleDate.year == day.year &&
            sale.saleDate.month == day.month &&
            sale.saleDate.day == day.day);
      }).toList();
      final listOrder = salesByDay.map((o) => o.toModel().toEntity()).toList();
      return listOrder;
    } catch (e) {
      throw LocalFailure();
    }
  }

  @override
  Future<List<double>> getSalesByMonth(DateTime month) async {
    try {
      final List<double> result = [];
      final box = await Hive.openBox<SaleDto>(_boxName);

      var nextMonth = (month.month % 12) + 1;
      var nextMonthYear = (month.month == 12) ? month.year + 1 : month.year;
      var lastDayOfMonth = DateTime(nextMonthYear, nextMonth, 1)
          .subtract(const Duration(days: 1));

      for (var i = 0; i < lastDayOfMonth.day; i++) {
        final salesByDay = box.values.where((sale) {
          return (sale.saleDate.year == month.year &&
              sale.saleDate.month == month.month &&
              sale.saleDate.day == i + 1);
        }).toList();
        double sumaTotal = 0.0;
        for (var elemento in salesByDay) {
          sumaTotal += elemento.totalsale;
        }
        result.add(sumaTotal);
      }
      return result;
    } catch (e) {
      debugPrint("error desde al local datasorce: ${e}");
      throw LocalFailure();
    }
  }

  @override
  Future<double> getTotalSaleByDay(DateTime day) async {
    try {
      final box = await Hive.openBox<SaleDto>(_boxName);
      final salesByDay = box.values.where((sale) {
        return (sale.saleDate.year == day.year &&
            sale.saleDate.month == day.month &&
            sale.saleDate.day == day.day);
      }).toList();
      double sumaTotal = 0.0;
      for (var elemento in salesByDay) {
        sumaTotal += elemento.totalsale;
      }
      return sumaTotal;
    } catch (e) {
      debugPrint("error desde al local datasorce: ${e}");
      throw LocalFailure();
    }
  }
}
