import 'package:hive_flutter/adapters.dart';
import 'package:mi_tiendita/Ticket/Data/models/ticket_model.dart';
import 'package:mi_tiendita/core/error/failures.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../Domain/ticket.entity.dart';

abstract class TicketLocalDataSource {
  Future<TicketEntity> getInfoCompany();
  Future<TicketEntity> updateInfoTicket(TicketEntity ticketEntity);
}

class TicketLocalDataSourceImpl implements TicketLocalDataSource {
  static const String _boxName = 'companyconfiguration';
  static const int idConfigiration = 1;

  @override
  Future<TicketEntity> getInfoCompany() async {
    try {
      final box = await Hive.openBox<TicketModelHive>(_boxName);
      final getConfigurations = box.get(idConfigiration);
      if (getConfigurations == null) {
        //si la configuracion no existe, retornamos un objeto vacio, esto es para la primera vez
        return TicketEntity(companyName: "", companyAddress: "");
      }
      {
        //Si la configuracion existe, la retornamos
        return getConfigurations.toEntity();
      }
    } catch (e) {
      throw LocalFailure();
    }
  }

  @override
  Future<TicketEntity> updateInfoTicket(TicketEntity ticketEntity) async {
    try {
      final box = await Hive.openBox<TicketModelHive>(_boxName);
      final getConfigurations = box.get(idConfigiration);

      if (getConfigurations == null) {
        // Si no existe la configuracion, la creamos. esto es para la primera vez
        final TicketModelHive newTicketConfig =
            await TicketModelHive.fromEntity(ticketEntity);
        await box.put(idConfigiration, newTicketConfig);
        return ticketEntity;
      } else {
        //si existe la configuracion, la actualizamos
        getConfigurations.companyName = ticketEntity.companyName;
        getConfigurations.companyAddress = ticketEntity.companyAddress;
        await getConfigurations.save();
        return getConfigurations.toEntity();
      }
      // Otros procesos o retornos si necesitas
    } catch (e) {
      throw LocalFailure();
    }
  }
}
