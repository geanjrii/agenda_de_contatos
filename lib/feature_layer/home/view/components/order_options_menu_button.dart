import 'package:agenda_de_contatos/feature_layer/home/cubit/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum OrderOptions { orderaz, orderza }

class OrderOptionsMenuButton extends StatelessWidget {
  const OrderOptionsMenuButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<OrderOptions>(
      itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
        const PopupMenuItem<OrderOptions>(
          value: OrderOptions.orderaz,
          child: Text('Ordenar de A-Z'),
        ),
        const PopupMenuItem<OrderOptions>(
          value: OrderOptions.orderza,
          child: Text('Ordenar de Z-A'),
        ),
      ],
      onSelected: (OrderOptions result) {
        switch (result) {
          case OrderOptions.orderaz:
            context.read<HomeCubit>().onOrderazRequested();
            break;
          case OrderOptions.orderza:
            context.read<HomeCubit>().onOrderzaRequested();
            break;
        }
      },
    );
  }
}
