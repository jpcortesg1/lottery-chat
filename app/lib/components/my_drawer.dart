import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Drawer(
        backgroundColor: Theme.of(context).colorScheme.surface,
        child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
        Column(
          children: [
            DrawerHeader(
                child: Center(
              child: Icon(
                Icons.message,
                color: Theme.of(context).colorScheme.primary,
                size: 40
              ),
            )),
        
            //home list title
            Padding(
              padding: const EdgeInsets.only(left: 25.0),
              child: ListTile(
                title: Text("INICIO"),
                leading: Icon(Icons.home),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
        
            //settings
             Padding(
              padding: const EdgeInsets.only(left: 25.0),
              child: ListTile(
                title: Text("CONFIGURACIÓN"),
                leading: Icon(Icons.settings),
                onTap: () {},
              ),
            ),
        
            //logout
             Padding(
              padding: const EdgeInsets.only(left: 25.0, bottom: 25),
              child: ListTile(
                title: Text("CERRAR SESIÓN"),
                leading: Icon(Icons.logout),
                onTap: () {},
              ),
            )
          ],
        ),
      ],
        ));
  }
}
