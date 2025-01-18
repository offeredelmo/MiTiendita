

import 'package:hive_flutter/adapters.dart';
import 'package:mi_tiendita/Ticket/Domain/ticket.entity.dart';

part 'ticket_model.g.dart';

class TicketModel {
  final String companyName;
  final String companyAddress;

  TicketModel({
    required this.companyName,
    required this.companyAddress
    });
  
  factory TicketModel.fromEntity(TicketEntity ticketEntity) {
    return TicketModel(
      companyName: ticketEntity.companyName, 
      companyAddress: ticketEntity.companyAddress
      );
  }

  TicketEntity toEntity(){
    return TicketEntity(
    companyName: companyName, 
    companyAddress: companyAddress
    );
  }

}

@HiveType(typeId: 4)
class TicketModelHive extends HiveObject{

  @HiveField(0)
  String companyName;

  @HiveField(1)
  String companyAddress;

  TicketModelHive({
    required this.companyName,
    required this.companyAddress
    });

  factory TicketModelHive.fromModel(TicketModel ticketModel){
    return TicketModelHive(
      companyName: ticketModel.companyName,
      companyAddress: ticketModel.companyAddress
      );
  }

  static fromEntity(TicketEntity ticketEntity){
    return TicketModelHive(
      companyName: ticketEntity.companyName,
      companyAddress: ticketEntity.companyAddress
      );
  }
  TicketEntity toEntity() {
    return TicketEntity(
      companyName: companyName,
      companyAddress: companyAddress
      );
  }

}