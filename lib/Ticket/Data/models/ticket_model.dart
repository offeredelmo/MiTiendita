

import 'package:hive_flutter/adapters.dart';
import 'package:mi_tiendita/Ticket/Domain/ticket.entity.dart';

part 'ticket_model.g.dart';

class TicketModel {
  final String companyName;

  TicketModel({required this.companyName});
  
  factory TicketModel.fromEntity(TicketEntity ticketEntity) {
    return TicketModel(companyName: ticketEntity.companyName);
  }

  TicketEntity toEntity(){
    return TicketEntity(companyName: companyName);
  }

}

@HiveType(typeId: 4)
class TicketModelHive extends HiveObject{

  @HiveField(0)
  String companyName;

  TicketModelHive({required this.companyName});

  factory TicketModelHive.fromModel(TicketModel ticketModel){
    return TicketModelHive(companyName: ticketModel.companyName);
  }

  static fromEntity(TicketEntity ticketEntity){
    return TicketModelHive(companyName: ticketEntity.companyName);
  }
  TicketEntity toEntity() {
    return TicketEntity(companyName: companyName);
  }

}