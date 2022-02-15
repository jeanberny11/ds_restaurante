import 'package:ds_restaurante/app_data.dart';
import 'package:ds_restaurante/data/models/categorias.dart';
import 'package:ds_restaurante/data/models/cliente.dart';
import 'package:ds_restaurante/data/models/comanda_item.dart';
import 'package:ds_restaurante/data/models/detalle_comanda.dart';
import 'package:ds_restaurante/data/models/header_comanda.dart';
import 'package:ds_restaurante/data/models/mesa_ocupada.dart';
import 'package:ds_restaurante/data/models/mesas.dart';
import 'package:ds_restaurante/data/models/ncf.dart';
import 'package:ds_restaurante/data/models/preferencia.dart';
import 'package:ds_restaurante/data/models/productos.dart';
import 'package:ds_restaurante/utils/app_utils.dart';
import 'package:ds_restaurante/views/comanda/comanda_utils.dart';
import 'package:ds_restaurante/views/comanda/cubit/in_comanda_cubit.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class InComanda extends StatefulWidget {
  final String documento;
  const InComanda({Key? key, required this.documento}) : super(key: key);

  @override
  _InComandaState createState() => _InComandaState();
}

class _InComandaState extends State<InComanda> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class InComandaPortrait extends StatefulWidget {
  final Mesa mesa;
  final String documento;
  const InComandaPortrait(
      {Key? key, required this.mesa, required this.documento})
      : super(key: key);

  @override
  _InComandaPortraitState createState() => _InComandaPortraitState();
}

class _InComandaPortraitState extends State<InComandaPortrait> {
  late List<Categorias> _categorias;
  late Mesa _mesa;
  late TextEditingController _clienteidController,
      _nombreclienteController,
      _rncController;
  late int _ncfid;
  late double _subtotal,
      _montoexento,
      _baseimponible,
      _itbis,
      _ley,
      _total,
      _montodelivery;
  late bool _calcularley, _delivery, _deli1, _deli2;
  late FocusNode _clienteidFocus, _nombreClienteFocus, _rncFocus, _ncfFocus;
  late List<Ncf> _ncfs;
  late List<Productos> _productos;
  late List<ComandaItem> _comandaItems;
  late Preferencia _preferencia;
  late String _documento;
  late List<MesaOcupada> _mesasJuntas;

  @override
  void initState() {
    super.initState();
    _categorias = [];
    _ncfs = [];
    _productos = [];
    _comandaItems = [];
    _mesasJuntas = [];
    _loadCategorias();
    _loadncfs();
    _loadPreferencia();
    _mesa = widget.mesa;
    _clienteidController = TextEditingController(text: '');
    _nombreclienteController = TextEditingController(text: '');
    _rncController = TextEditingController(text: '');
    _ncfid = 1;
    _subtotal = 0;
    _itbis = 0;
    _ley = 0;
    _total = 0;
    _montoexento = 0;
    _baseimponible = 0;
    _montodelivery = 0;
    _calcularley = true;
    _delivery = false;
    _deli1 = false;
    _deli2 = false;
    _clienteidFocus = FocusNode();
    _nombreClienteFocus = FocusNode();
    _rncFocus = FocusNode();
    _ncfFocus = FocusNode();
    _documento = '';
    if (widget.documento.isNotEmpty) {
      _loadComanda(widget.documento);
    }
  }

  void _loadCategorias() async {
    final categorias = await context.read<InComandaCubit>().getAllCategorias;
    setState(() {
      _categorias = categorias;
    });
    if (_categorias.isNotEmpty && _productos.isEmpty) {
      _loadProductos(_categorias.first.f_idcategoria);
    }
  }

  void _loadncfs() async {
    final ncfs = await context.read<InComandaCubit>().getAllNcfs;
    setState(() {
      _ncfs = ncfs;
    });
  }

  void _loadProductos(int categoriaid) async {
    final productos =
        await context.read<InComandaCubit>().getProductosCategoria(categoriaid);
    setState(() {
      _productos = productos;
    });
  }

  void _loadPreferencia() async {
    _preferencia = (await context.read<InComandaCubit>().getPreferencia)!;
  }

  void _calcular() {
    double montobruto = 0,
        baseimponible = 0,
        montoexento = 0,
        itbis = 0,
        montoley = 0,
        montototal = 0;
    for (var item in _comandaItems) {
      final mb = item.cantidad * item.precio;
      double me = 0, imp = 0, bi = 0, mt = 0, ml = 0;
      if (item.tieneimpuesto) {
        if (_preferencia.f_itbis_incluido) {
          bi = mb / (1 + item.pimpuesto);
        } else {
          bi = mb;
        }
        imp = bi * item.pimpuesto;
      } else {
        me = mb;
      }
      if (_calcularley && item.pley > 0) {
        ml = (me + bi) * (item.pley / 100);
      }
      mt = me + bi + imp;
      _comandaItems[_comandaItems.indexOf(item)] = item.copyWith(
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

  void _salvarComanda() async {
    if (_comandaItems.isEmpty) {
      mensaje(context, 'No existen Productos para esta Factura...!!');
      return;
    }
    if ((double.tryParse(_clienteidController.text) ?? 0) > 0 &&
        _ncfid > 0 &&
        _ncfid != 1 &&
        _ncfid != 11) {
      if (_rncController.text.isEmpty) {
        mensaje(context, 'Debe digitar el rnc del cliente');
        return;
      }

      if (_rncController.text.length < 9) {
        mensaje(context, 'Rnc o cedula invalido');
        return;
      }
    }

    final confirm = await confirmaraviso(context, 'Desea salvar esta comanda?');
    if (!confirm) {
      return;
    }

    final header = HeaderComanda(
        _documento,
        0,
        'OP',
        _total,
        _itbis,
        DateTime.now(),
        AppData().currentUsuario!.f_codigo_usuario,
        _mesa.f_id,
        AppData().currentVendedor!.f_idvendedor,
        false,
        AppData().currentUsuario!.f_codigo_usuario,
        0,
        int.tryParse(_clienteidController.text) ?? 0,
        _nombreclienteController.text,
        '',
        '',
        _ley,
        '',
        '',
        _montodelivery,
        false,
        _rncController.text);
    final detalles = _comandaItems
        .map<DetalleComanda>((e) => DetalleComanda(
            _documento,
            0,
            'OP',
            e.referencia,
            e.precio,
            e.cantidad,
            DateTime.now(),
            e.total,
            '',
            e.orden,
            false,
            e.impuesto,
            e.ley,
            0,
            '',
            0,
            false,
            0,
            0,
            '',
            e.despachado))
        .toList();
    try {
      await context
          .read<InComandaCubit>()
          .salvarComanda(_documento.isEmpty, header, detalles, _mesasJuntas);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Comanda guardad con exito')));
      Navigator.of(context).pop();
    } catch (ex) {
      mensaje(context, ex.toString());
    }
  }

  void _loadComanda(String documento) async {
    try {
      final header = await context.read<InComandaCubit>().getComanda(documento);
      if (header == null) {
        mensaje(context, "No se encontro la comanda solicitada");
        return;
      }
      final detalles =
          await context.read<InComandaCubit>().getDetalleComanda(documento);
      _documento = header.documento;
      _clienteidController.text = header.clienteid.toString();
      _nombreclienteController.text = header.nombrecliente;
      _rncController.text = header.rnc;
      _subtotal = header.monto;
      _itbis = header.itbis;
      _ley = header.ley;
      _total = header.monto;
      _montodelivery = header.delivery;
      _delivery = header.delivery > 0;
      _comandaItems.clear();
      for (final det in detalles) {
        final prod =
            await context.read<InComandaCubit>().getProducto(det.referencia);
        if (prod != null) {
          final item = ComandaItem(
              det.referencia,
              prod.f_descripcion,
              det.cantidad,
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
              double.tryParse(_preferencia.f_ley) ?? 0,
              0,
              0,
              det.nota,
              det.orden,
              det.despachado,
              det.cantidad2);
          _comandaItems.add(item);
        }
      }
      _comandaItems.sort(
        (a, b) => a.orden.compareTo(b.orden),
      );
      _calcular();
    } catch (ex) {
      mensaje(context, ex.toString());
    }
  }

  void _juntarMesas() async {
    final result = await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => OutJuntarMesas(mesaActual: _mesa.f_id),
    ));
    if (result != null) {
      final mesasjuntas = result as List<MesaOcupada>;
      for (final mesa in mesasjuntas) {
        _mesasJuntas.add(mesa);
        final detalles = await context
            .read<InComandaCubit>()
            .getDetalleComanda(mesa.f_documento);
        for (final det in detalles) {
          final prod =
              await context.read<InComandaCubit>().getProducto(det.referencia);
          if (prod != null) {
            final item = ComandaItem(
                det.referencia,
                prod.f_descripcion,
                det.cantidad,
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
                double.tryParse(_preferencia.f_ley) ?? 0,
                0,
                0,
                det.nota,
                det.orden,
                det.despachado,
                det.cantidad2);
            _comandaItems.add(item);
          }
        }
        _comandaItems.sort(
          (a, b) => a.orden.compareTo(b.orden),
        );
      }
      _calcular();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Realizar Comanda'),
        actions: [
          TextButton.icon(
              onPressed: () {
                _salvarComanda();
              },
              icon: const Icon(
                Icons.save,
                color: Colors.white,
              ),
              label: const Text(
                'Salvar Comanda',
                style: TextStyle(color: Colors.white),
              )),
          TextButton.icon(
              onPressed: () {
                if (_documento.isEmpty) {
                  mensaje(context, 'Debe guardar la comanda primero');
                  return;
                }
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => InSepararMesa(
                        documento: _documento,
                        calcularley: _calcularley,
                        itbisincluido: _preferencia.f_itbis_incluido,
                        mesa: _mesa,
                        clienteid: int.tryParse(_clienteidController.text) ?? 0,
                        nombreCliente: _nombreclienteController.text)));
              },
              icon: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Image.asset('resources/separar.png')),
              label: const Text(
                'Separar Cuenta',
                style: TextStyle(color: Colors.white),
              )),
          TextButton.icon(
              onPressed: () {
                _juntarMesas();
              },
              icon: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Image.asset('resources/juntar.png')),
              label: const Text(
                'Juntar Cuenta',
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: ListView(
          padding: const EdgeInsets.all(10.0),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 30.0.w,
                  height: 45.0.h,
                  padding: const EdgeInsets.all(10.0),
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 240, 181, 187)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text('Categorias'),
                      Expanded(
                        child: GridView.builder(
                            itemCount: _categorias.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 8,
                                    mainAxisSpacing: 8),
                            itemBuilder: (context, index) {
                              final cat = _categorias[index];
                              return GestureDetector(
                                onTap: () {
                                  _loadProductos(cat.f_idcategoria);
                                },
                                child: Card(
                                  elevation: 5.0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(20.0)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                            'resources/categoriaicon.png'),
                                        const SizedBox(
                                          height: 3.0,
                                        ),
                                        Text(
                                          cat.f_descripcion,
                                          style: TextStyle(fontSize: 4.0.sp),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                      )
                    ],
                  ),
                ),
                Expanded(
                    child: Container(
                  height: 45.0.h,
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(color: Colors.green[100]),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text('Productos'),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Expanded(
                        child: GridView.builder(
                            itemCount: _productos.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4,
                                    childAspectRatio: 0.80,
                                    crossAxisSpacing: 4,
                                    mainAxisSpacing: 4),
                            itemBuilder: (context, index) {
                              final prod = _productos[index];
                              return GestureDetector(
                                onTap: () {
                                  final findex = _comandaItems.indexWhere(
                                      (element) => (element.referencia ==
                                          prod.f_referencia));

                                  if (findex == -1) {
                                    var comandaitem = ComandaItem(
                                        prod.f_referencia,
                                        prod.f_descripcion,
                                        1,
                                        double.tryParse(prod.f_precio) ?? 0,
                                        double.tryParse(prod.f_ultimocosto) ??
                                            0,
                                        prod.f_idcategoria,
                                        double.tryParse(prod.f_impuesto) == null
                                            ? 0
                                            : double.parse(prod.f_impuesto) /
                                                100,
                                        double.tryParse(prod.f_precio) ?? 0,
                                        prod.f_tieneitbs,
                                        0,
                                        0,
                                        0,
                                        double.tryParse(_preferencia.f_ley) ??
                                            0,
                                        0,
                                        0,
                                        '',
                                        1,
                                        false,
                                        0);
                                    setState(() {
                                      _comandaItems.add(comandaitem);
                                    });
                                  } else {
                                    final existitem = _comandaItems[findex];
                                    setState(() {
                                      _comandaItems[findex] =
                                          existitem.copyWith(
                                              cantidad: existitem.cantidad + 1,
                                              precio: double.tryParse(
                                                      prod.f_precio) ??
                                                  0,
                                              tieneimpuesto: prod.f_tieneitbs);
                                    });
                                  }
                                  _calcular();
                                },
                                child: Card(
                                  elevation: 5.0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(20.0)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Image.asset('resources/comida.png'),
                                        const SizedBox(
                                          height: 5.0,
                                        ),
                                        Text(
                                          prod.f_descripcion,
                                          style: TextStyle(fontSize: 5.0.sp),
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          "Precio: ${ntos(double.tryParse(prod.f_precio) ?? 0)}",
                                          style: TextStyle(fontSize: 5.0.sp),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                      )
                    ],
                  ),
                ))
              ],
            ),
            const SizedBox(
              height: 15.0,
            ),
            SizedBox(
              width: 100.0.w,
              height: 25.0.h,
              child: ListView.builder(
                  padding: const EdgeInsets.all(10.0),
                  itemCount: _comandaItems.length,
                  itemBuilder: (context, index) {
                    final item = _comandaItems[index];
                    return Slidable(
                      key: ValueKey(index),
                      endActionPane: ActionPane(
                        motion: const DrawerMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (context) async {
                              final nota = await memoInputDialog(
                                  context, 'Digite un comentario');
                              if (nota.isNotEmpty) {
                                _comandaItems[index] =
                                    item.copyWith(nota: nota);
                                _calcular();
                              }
                            },
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                            icon: Icons.monetization_on_outlined,
                            label: 'Precio',
                          ),
                          SlidableAction(
                            onPressed: (context) async {
                              final precio = await numericInputDialog(
                                  context, 'Digite el precio', item.precio);
                              if (precio > 0) {
                                _comandaItems[index] =
                                    item.copyWith(precio: precio);
                                _calcular();
                              }
                            },
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                            icon: Icons.monetization_on_outlined,
                            label: 'Precio',
                          ),
                          SlidableAction(
                            onPressed: (context) async {
                              final cantidad = await numericInputDialog(context,
                                  'Digite una cantidad', item.cantidad);
                              if (cantidad > 0) {
                                _comandaItems[index] =
                                    item.copyWith(cantidad: cantidad);
                                _calcular();
                              }
                            },
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            icon: Icons.change_circle_outlined,
                            label: 'Cantidad',
                          ),
                          if (!item.despachado)
                            SlidableAction(
                              onPressed: (context) {
                                _comandaItems.remove(item);
                                _calcular();
                              },
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: 'Eliminar',
                            ),
                        ],
                      ),
                      child: ListTile(
                        leading: Image.asset('resources/comida.png'),
                        title: Text(
                            'Producto: ${item.referencia} - ${item.descripcion}'),
                        subtitle: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Text('Cantidad: '),
                                Text(
                                  ntos(item.cantidad),
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                const Text('Precio: '),
                                Text(
                                  ntos(item.precio),
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                const Text('Importe: '),
                                Text(
                                  ntos(item.total),
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  }),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Camarero ${AppData().currentVendedor!.f_nombre} ${AppData().currentVendedor!.f_apellido}',
                  style: TextStyle(fontSize: 7.sp),
                ),
                const SizedBox(
                  width: 30,
                ),
                Text('Mesa: ${_mesa.f_descripcion}',
                    style: TextStyle(fontSize: 7.sp))
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                    width: 30.w,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text('Id Cliente'),
                            const SizedBox(
                              width: 10,
                            ),
                            IconButton(
                                onPressed: () async {
                                  final res = await showSearch<Cliente?>(
                                      context: context,
                                      delegate: ClienteSearch(
                                          context.read<InComandaCubit>()));
                                  if (res != null) {
                                    setState(() {
                                      _clienteidController.text =
                                          res.f_id.toString();
                                      _nombreclienteController.text =
                                          res.f_nombre!;
                                      _rncController.text = res.f_rif!;
                                      _ncfid = res.f_tipo_comprobante ?? 1;
                                    });
                                  }
                                },
                                icon: const Icon(Icons.search))
                          ],
                        ),
                        TextField(
                          controller: _clienteidController,
                          textInputAction: TextInputAction.search,
                          keyboardType: TextInputType.number,
                          focusNode: _clienteidFocus,
                          onSubmitted: (value) {},
                          decoration: const InputDecoration(
                            hintText: 'Id Cliente',
                          ),
                        )
                      ],
                    )),
                const SizedBox(
                  width: 10.0,
                ),
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Nombre Cliente'),
                    TextField(
                      controller: _nombreclienteController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      focusNode: _nombreClienteFocus,
                      onSubmitted: (value) {
                        _nombreClienteFocus.unfocus();
                        FocusScope.of(context).requestFocus(_rncFocus);
                      },
                      decoration: const InputDecoration(
                        hintText: 'Nombre Cliente',
                      ),
                    )
                  ],
                ))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Flexible(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Rnc Cliente'),
                    TextField(
                      controller: _rncController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _rncFocus,
                      onSubmitted: (value) {
                        _rncFocus.unfocus();
                        FocusScope.of(context).requestFocus(_ncfFocus);
                      },
                      decoration: const InputDecoration(
                        hintText: 'Rnc Cliente',
                      ),
                    )
                  ],
                )),
                const SizedBox(
                  width: 10,
                ),
                Flexible(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Ncf'),
                    DropdownButton<int>(
                      value: _ncfid,
                      items: _ncfs
                          .map<DropdownMenuItem<int>>((e) => DropdownMenuItem(
                                value: e.f_codigo,
                                child: Text(e.f_descripcion),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _ncfid = value!;
                        });
                      },
                    )
                  ],
                ))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text('Delivery'),
                    Checkbox(
                        value: _delivery,
                        onChanged: (value) {
                          setState(() {
                            _delivery = value!;
                          });
                        })
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text('Calcular % ley'),
                    Checkbox(
                        value: _calcularley,
                        onChanged: (value) {
                          setState(() {
                            _calcularley = value!;
                          });
                        })
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text('Deli. 1'),
                    Checkbox(
                        value: _deli1,
                        onChanged: (value) {
                          setState(() {
                            _deli1 = value!;
                          });
                        })
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text('Deli. 2'),
                    Checkbox(
                        value: _deli2,
                        onChanged: (value) {
                          setState(() {
                            _deli2 = value!;
                          });
                        })
                  ],
                )
              ],
            ),
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
          ],
        ),
      ),
    );
  }
}

class ClienteSearch extends SearchDelegate<Cliente?> {
  final InComandaCubit _cubit;
  ClienteSearch(this._cubit);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      if (query.isEmpty)
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            query = '*';
          },
        )
      else
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
          },
        )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<Cliente>>(
        future: _cubit.searchClientes(query),
        builder: (context, snp) {
          if (snp.connectionState == ConnectionState.done) {
            if (snp.hasError) {
              return Center(
                child: Text(snp.error.toString()),
              );
            } else {
              final clientes = snp.data!;
              if (clientes.isEmpty) {
                return const Center(
                  child: Text(
                      'No se encontraron clientes con las especificacion suministradas'),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.all(10.0),
                itemCount: clientes.length,
                itemBuilder: (context, index) {
                  final item = clientes[index];
                  return ListTile(
                    onTap: () {
                      close(context, item);
                    },
                    leading: const CircleAvatar(
                      child: Icon(Icons.person),
                    ),
                    title: Text("Cliente: ${item.f_id} - ${item.f_nombre}"),
                    subtitle: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Direccion: ${item.f_direccion}'),
                        Text('Cedula: ${item.f_rif}'),
                        Text('Telefono: ${item.f_telefono}'),
                      ],
                    ),
                  );
                },
              );
            }
          } else {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
