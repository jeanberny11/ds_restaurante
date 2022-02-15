import 'package:ds_restaurante/app_data.dart';
import 'package:ds_restaurante/data/models/comanda_item.dart';
import 'package:ds_restaurante/data/models/detalle_comanda.dart';
import 'package:ds_restaurante/data/models/header_comanda.dart';
import 'package:ds_restaurante/data/models/mesa_ocupada.dart';
import 'package:ds_restaurante/data/models/mesas.dart';
import 'package:ds_restaurante/managers/comandas_manager.dart';
import 'package:ds_restaurante/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class OutJuntarMesas extends StatefulWidget {
  final int mesaActual;
  const OutJuntarMesas({Key? key, required this.mesaActual}) : super(key: key);

  @override
  State<OutJuntarMesas> createState() => _OutJuntarMesasState();
}

class _OutJuntarMesasState extends State<OutJuntarMesas> {
  late List<SelectedListItem<MesaOcupada>> _mesasDisponibles;
  bool _isloading = false;
  @override
  void initState() {
    super.initState();
    _mesasDisponibles = [];
    _loadMesasDisponibles();
  }

  void _loadMesasDisponibles() async {
    setState(() {
      _isloading = true;
    });
    try {
      final mesas = await context
          .read<ComandasManager>()
          .getMesasJunar(widget.mesaActual);
      setState(() {
        _mesasDisponibles = mesas;
        _isloading = false;
      });
    } catch (ex) {
      setState(() {
        _isloading = false;
      });
      mensaje(context, ex.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Junar Mesas'),
        actions: [
          IconButton(
              onPressed: () {
                final selectedmesas =
                    _mesasDisponibles.where((e) => e.isSelected).toList();
                if (selectedmesas.isEmpty) {
                  mensaje(context, 'No hay mesas seleccionadas para juntar');
                  return;
                }
                Navigator.pop(context,
                    selectedmesas.map<MesaOcupada>((e) => e.data).toList());
              },
              icon: const Icon(Icons.done))
        ],
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Builder(
          builder: (context) {
            if (_isloading) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }
            if (_mesasDisponibles.isEmpty) {
              return const Center(
                child: Text(
                  'No hay mesas disponibles para juntar',
                  textAlign: TextAlign.center,
                ),
              );
            } else {
              return ListView.builder(
                padding: const EdgeInsets.all(10.0),
                itemCount: _mesasDisponibles.length,
                itemBuilder: (context, index) {
                  final item = _mesasDisponibles[index];
                  return Card(
                    elevation: 8.0,
                    margin: const EdgeInsets.all(10.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                    child: ListTile(
                      onTap: () {
                        setState(() {
                          _mesasDisponibles[index].isSelected =
                              !item.isSelected;
                        });
                      },
                      leading: Image.asset('resources/mesaicon.png'),
                      title: Text(item.data.mesa),
                      subtitle: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Comanda No.: ${item.data.f_documento}'),
                                Text(
                                    'Monto: ${ntos(double.tryParse(item.data.f_monto) ?? 0)}'),
                                Text('Camarero: ${item.data.camarero}')
                              ],
                            ),
                            Switch(
                                value: item.isSelected, onChanged: (value) {})
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

class InSepararMesa extends StatefulWidget {
  final String documento, nombreCliente;
  final bool calcularley, itbisincluido;
  final Mesa mesa;
  final int clienteid;
  const InSepararMesa(
      {Key? key,
      required this.documento,
      required this.calcularley,
      required this.itbisincluido,
      required this.mesa,
      required this.clienteid,
      required this.nombreCliente})
      : super(key: key);

  @override
  _InSepararMesaState createState() => _InSepararMesaState();
}

class _InSepararMesaState extends State<InSepararMesa> {
  late List<SelectedListItem<ComandaItem>> _comandaItems;
  late String _documento, _nombreCliente;
  late double _subtotal, _montoexento, _baseimponible, _itbis, _ley, _total;
  late bool _calcularley, _itbisincluido;
  late Mesa _mesa;
  late int _clienteid;

  @override
  void initState() {
    super.initState();
    _comandaItems = [];
    _documento = widget.documento;
    _calcularley = widget.calcularley;
    _itbisincluido = widget.itbisincluido;
    _mesa = widget.mesa;
    _nombreCliente = widget.nombreCliente;
    _clienteid = widget.clienteid;
    _subtotal = 0;
    _montoexento = 0;
    _baseimponible = 0;
    _itbis = 0;
    _ley = 0;
    _total = 0;
    _loadDetalleComanda();
  }

  void _loadDetalleComanda() async {
    if (_documento.isEmpty) {
      mensaje(context, 'Debe suplir el documento de la comanda!');
      Navigator.of(context).pop();
      return;
    }
    final detallecomanda = await context
        .read<ComandasManager>()
        .getDetalleComandaSeparar(_documento);
    if (detallecomanda.isEmpty) {
      mensaje(context,
          'Esta comanda ya no tiene articulos disponibles para separar!');
      Navigator.of(context).pop();
      return;
    }
    final preferencia = await context.read<ComandasManager>().getPreferencia();
    for (final det in detallecomanda) {
      final prod =
          await context.read<ComandasManager>().getProducto(det.referencia);
      if (prod != null) {
        final item = ComandaItem(
            det.referencia,
            prod.f_descripcion,
            0,
            det.precio,
            double.tryParse(prod.f_ultimocosto) ?? 0,
            prod.f_idcategoria,
            double.tryParse(prod.f_impuesto) == null
                ? 0
                : double.parse(prod.f_impuesto) / 100,
            det.cantidad * det.precio,
            prod.f_tieneitbs,
            0,
            0,
            0,
            double.tryParse(preferencia!.f_ley) ?? 0,
            0,
            0,
            det.nota,
            det.orden,
            det.despachado,
            det.cantidad - det.cantidad2);
        _comandaItems.add(SelectedListItem(item));
      }
    }
    _calcular();
  }

  void _calcular() {
    double montobruto = 0,
        baseimponible = 0,
        montoexento = 0,
        itbis = 0,
        montoley = 0,
        montototal = 0;
    for (var item in _comandaItems) {
      final mb = item.data.cantidad * item.data.precio;
      double me = 0, imp = 0, bi = 0, mt = 0, ml = 0;
      if (item.data.tieneimpuesto) {
        if (_itbisincluido) {
          bi = mb / (1 + item.data.pimpuesto);
        } else {
          bi = mb;
        }
        imp = bi * item.data.pimpuesto;
      } else {
        me = mb;
      }
      if (_calcularley && item.data.pley > 0) {
        ml = (me + bi) * (item.data.pley / 100);
      }
      mt = me + bi + imp;
      _comandaItems[_comandaItems.indexOf(item)].data = item.data.copyWith(
          montobruto: mb,
          montoexento: me,
          baseimponible: bi,
          impuesto: imp,
          ley: ml,
          total: mt);
      montobruto += mb;
      baseimponible += bi;
      montoexento += me;
      itbis += imp;
      montoley += ml;
      montototal += mt;
    }
    setState(() {
      _subtotal = montobruto;
      _ley = montoley;
      _itbis = itbis;
      _total = montototal;
      _baseimponible = baseimponible;
      _montoexento = montoexento;
    });
  }

  void _salvar() async {
    if (_comandaItems.where((element) => element.isSelected).isEmpty) {
      mensaje(context, 'No hay articulos separados');
      return;
    }
    final confirm =
        await confirmaraviso(context, 'Desea salvar esta pre-cuenta?');
    if (!confirm) {
      return;
    }
    final header = HeaderComanda(
        '',
        0,
        '',
        _total,
        _itbis,
        DateTime.now(),
        AppData().currentUsuario!.f_codigo_usuario,
        _mesa.f_id,
        AppData().currentVendedor!.f_idvendedor,
        false,
        0,
        0,
        _clienteid,
        _nombreCliente,
        '',
        '',
        _ley,
        '',
        '',
        0,
        false,
        '');
    final detalles = _comandaItems
        .where((i) => i.isSelected)
        .map<DetalleComanda>((e) => DetalleComanda(
            '',
            0,
            '',
            e.data.referencia,
            e.data.precio,
            e.data.cantidad,
            DateTime.now(),
            e.data.total,
            '',
            e.data.orden,
            false,
            e.data.impuesto,
            e.data.ley,
            0,
            '',
            0,
            false,
            e.data.cantidad2,
            0,
            '',
            false))
        .toList();
    try {
      await context
          .read<ComandasManager>()
          .salvarComandaSeparada(_documento, header, detalles);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pre-cuenta guardada con exito')));
      Navigator.of(context).pop();
    } catch (ex) {
      mensaje(context, ex.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Separar Cuenta'),
        actions: [
          IconButton(
              onPressed: () {
                _salvar();
              },
              icon: const Icon(Icons.save))
        ],
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text('Sub-Total: '),
                      Text(
                        ntos(_subtotal),
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text('Monto Exento: '),
                      Text(
                        ntos(_montoexento),
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text('Base Imponible: '),
                      Text(
                        ntos(_baseimponible),
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text('Itbis: '),
                      Text(
                        ntos(_itbis),
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text('Ley: '),
                      Text(
                        ntos(_ley),
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text('Total: '),
                      Text(
                        ntos(_total),
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      )
                    ],
                  )
                ],
              ),
              Expanded(
                  child: ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: _comandaItems.length,
                itemBuilder: (contes, index) {
                  final item = _comandaItems[index];
                  return Slidable(
                    key: ValueKey(index),
                    endActionPane: ActionPane(
                      motion: const DrawerMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) async {
                            final cantidad = await numericInputDialog(context,
                                'Digite una cantidad', item.data.cantidad);
                            if (cantidad > 0 &&
                                cantidad <= item.data.cantidad2) {
                              _comandaItems[index].isSelected = true;
                              _comandaItems[index].data =
                                  item.data.copyWith(cantidad: cantidad);
                              _calcular();
                            }
                          },
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          icon: Icons.change_circle_outlined,
                          label: 'Cantidad',
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: Image.asset('resources/comida.png'),
                      onTap: () {
                        if (item.isSelected) {
                          _comandaItems[index].data =
                              item.data.copyWith(cantidad: 0);
                        } else {
                          _comandaItems[index].data =
                              item.data.copyWith(cantidad: item.data.cantidad2);
                        }
                        _comandaItems[index].isSelected = !item.isSelected;
                        _calcular();
                      },
                      title: Text(
                          'Producto: ${item.data.referencia} - ${item.data.descripcion}'),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Text('Cantidad disponible: '),
                                  Text(
                                    ntos(item.data.cantidad2),
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Text('Cantidad separada: '),
                                  Text(
                                    ntos(item.data.cantidad),
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Text('Precio: '),
                                  Text(
                                    ntos(item.data.precio),
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Text('Importe: '),
                                  Text(
                                    ntos(item.data.total),
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor),
                                  ),
                                ],
                              )
                            ],
                          ),
                          Switch(value: item.isSelected, onChanged: (value) {})
                        ],
                      ),
                    ),
                  );
                },
              ))
            ],
          ),
        ),
      ),
    );
  }
}
