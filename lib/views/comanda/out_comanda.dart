import 'dart:async';

import 'package:ds_restaurante/app_data.dart';
import 'package:ds_restaurante/data/models/mesa_ocupada.dart';
import 'package:ds_restaurante/managers/comandas_manager.dart';
import 'package:ds_restaurante/utils/app_utils.dart';
import 'package:ds_restaurante/utils/page_routes.dart';
import 'package:ds_restaurante/views/comanda/cubit/out_mesas_cubit.dart';
import 'package:ds_restaurante/views/comanda/cubit/out_zonas_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:visibility_detector/visibility_detector.dart';

class OutZonas extends StatelessWidget {
  const OutZonas({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OutZonasCubit, OutZonasState>(
      builder: ((context, state) {
        if (state is OutZonasLoading) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Zonas'),
            ),
            body: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  CircularProgressIndicator.adaptive(),
                  SizedBox(
                    height: 15.0,
                  ),
                  Text('Cargando las zonas')
                ],
              ),
            ),
          );
        } else if (state is OutZonasError) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Zonas'),
            ),
            body: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  TextButton(
                      onPressed: () {
                        context.read<OutZonasCubit>().loadZonas();
                      },
                      child: const Text('Reintentar'))
                ],
              ),
            ),
          );
        } else if (state is OutZonasInitial) {
          final zonas = state.zonas;
          if (zonas.isEmpty) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Zonas'),
              ),
              body: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: const Center(
                  child: Text('No se encontraron zonas creadas'),
                ),
              ),
            );
          } else {
            return DefaultTabController(
              length: zonas.length,
              child: Scaffold(
                bottomNavigationBar: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration:
                      BoxDecoration(color: Theme.of(context).primaryColor),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Camarero: ${AppData().currentVendedor!.f_nombre} ${AppData().currentVendedor!.f_apellido}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                body: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: NestedScrollView(
                      headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return [
                      SliverAppBar(
                        title: const Text('Meses Disponibles'),
                        pinned: true,
                        floating: true,
                        bottom: TabBar(
                            isScrollable: true,
                            tabs: zonas
                                .map<Widget>((e) => Tab(
                                      icon: const Icon(Icons.place),
                                      child: Text(e.f_descripcion!),
                                    ))
                                .toList()),
                      )
                    ];
                  }, body: Builder(
                    builder: (context) {
                      return TabBarView(
                          children: state.zonas
                              .map<Widget>((e) => BlocProvider<OutMesasCubit>(
                                    create: (context) => OutMesasCubit(
                                        context.read<ComandasManager>()),
                                    child: Outmesas(zonaid: e.f_id),
                                  ))
                              .toList());
                    },
                  )),
                ),
              ),
            );
          }
        }
        throw Exception('Unknow state');
      }),
    );
  }
}

class Outmesas extends StatefulWidget {
  final int zonaid;
  const Outmesas({Key? key, required this.zonaid}) : super(key: key);

  @override
  State<Outmesas> createState() => _OutmesasState();
}

class _OutmesasState extends State<Outmesas> {
  late List<MesaOcupada> _mensasocupadas;
  late Timer _timer;
  late double _visibilitypercent;
  @override
  void initState() {
    super.initState();
    _mensasocupadas = [];
    init();
    _timer = Timer.periodic(const Duration(seconds: 15), _timeraction);
    _visibilitypercent = 0;
  }

  void init() async {
    context.read<OutMesasCubit>().loadMesas(widget.zonaid);
    final mesas = await context.read<OutMesasCubit>().getMesasOcupadas;
    setState(() {
      _mensasocupadas = mesas;
    });
  }

  void _timeraction(Timer timer) async {
    final mesas = await context.read<OutMesasCubit>().getMesasOcupadas;
    if (_visibilitypercent > 90) {
      setState(() {
        _timer = timer;
        _mensasocupadas = mesas;
      });
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key('my-widget-key'),
      onVisibilityChanged: (info) {
        _visibilitypercent = info.visibleFraction * 100;
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.height,
        height: MediaQuery.of(context).size.height,
        child: BlocBuilder<OutMesasCubit, OutMesasState>(
          builder: (context, state) {
            if (state is OutMesasLoading) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            } else if (state is OutMesasError) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.oswald(color: Colors.red),
                  ),
                  TextButton(
                      onPressed: () {
                        context.read<OutMesasCubit>().loadMesas(widget.zonaid);
                      },
                      child: const Text('Reload'))
                ],
              );
            } else if (state is OutMesasInitial) {
              if (state.mesas.isEmpty) {
                return const Center(
                  child: Text('No hay mesas para esta zona!!!'),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: GridView.builder(
                      itemCount: state.mesas.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              MediaQuery.of(context).size.width ~/ 200,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 5),
                      itemBuilder: (context, index) {
                        final item = state.mesas[index];
                        return Builder(builder: (context) {
                          final resmesa = _mensasocupadas
                              .where((m) => m.f_mesa == item.f_id);
                          if (resmesa.isEmpty) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                    PageRoutes.incomanda,
                                    arguments: {'mesa': item, 'documento': ''});
                              },
                              child: Card(
                                elevation: 5.0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset('resources/mesaicon.png'),
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                    Text(
                                      item.f_descripcion!,
                                      style: const TextStyle(fontSize: 15),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(
                                      height: 5.0,
                                    ),
                                    const Text(
                                      'Disponible!',
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.lightGreen),
                                      textAlign: TextAlign.center,
                                    )
                                  ],
                                ),
                              ),
                            );
                          } else {
                            final mesa = resmesa.first;
                            return GestureDetector(
                              onTap: () {
                                if (AppData().currentVendedor!.f_idvendedor !=
                                    mesa.f_vendedor) {
                                  mensaje(context,
                                      'No puedes modificar la comanda de otro camarero!');
                                  return;
                                }
                                Navigator.of(context).pushNamed(
                                    PageRoutes.incomanda,
                                    arguments: {
                                      'mesa': item,
                                      'documento': mesa.f_documento
                                    });
                              },
                              child: Card(
                                elevation: 5.0,
                                color: const Color.fromARGB(255, 247, 189, 195),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset('resources/mesaicon.png'),
                                    const SizedBox(
                                      height: 3.0,
                                    ),
                                    Text(
                                      item.f_descripcion!,
                                      style: const TextStyle(fontSize: 14),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(
                                      'Mesero: ${mesa.camarero}',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    Text(
                                      'Cliente: ${mesa.f_nombre_cliente}',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    Text(
                                      'Monto: ${ntos(double.tryParse(mesa.f_monto) ?? 0)}',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    Text(
                                      '${mesa.hora} Hora ${mesa.minuto} Minutos',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 12),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }
                        });
                      }),
                );
              }
            }
            throw Exception('Unknow state');
          },
        ),
      ),
    );
  }
}
