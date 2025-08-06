import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class HomePage extends StatelessWidget {
  const HomePage ({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 60, bottom: 0, left: 20, right: 20 ),
      child: Column( mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.start, spacing: 20,
        children: [
          Row(
            children: [
              Image.asset( 'lib/images/plant_logo.png', width: 40, height: 40,),
              const SizedBox(width: 8),
              const Text( 'Plant Identifier',
                style: TextStyle( fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green
                ),
              )
            ],
          ),
          TextField( decoration: InputDecoration(
              hintText: 'Search for plants...',
              filled: true, fillColor: Colors.white10,
              prefixIcon: Padding( padding: EdgeInsets.only(left: 10), child: Icon(LucideIcons.search300)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              border: OutlineInputBorder( borderRadius: BorderRadius.circular(30), borderSide: BorderSide(color: Colors.white),
              ),
            ),
          ),
          Visibility( visible: false,
            child: Expanded(
              child: ClipRRect( borderRadius: BorderRadius.circular(12), // Entire ListView radius
                child: MediaQuery.removePadding( context: context, removeTop: true,
                  child: ListView.builder( itemCount: 10,
                    itemBuilder: (context, index) {
                      return Card( margin: const EdgeInsets.only(bottom: 10),
                        child: ListTile( contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          leading: Image.asset( 'lib/images/plant_logo.png', width: 60, height: 60, fit: BoxFit.cover,),
                          title: Text('Plant name $index'),
                          subtitle: const Text('Scientific name'),
                          onTap: () {
                            // Handle tap
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          Offstage( offstage: false,
            child: Padding( padding: const EdgeInsets.only(top: 50),
              child: Container( padding: const EdgeInsets.all(16), alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [ Colors.green, Colors.grey,
                    ],
                  ),
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Welcome to Plant Identifier! Discover and identify plants from around the world.',
                  style: TextStyle(fontSize: 20, color: Colors.white), textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}