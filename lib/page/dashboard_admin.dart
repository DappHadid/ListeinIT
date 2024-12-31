import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class DashboardAdmin extends StatefulWidget {
  @override
  _DashboardAdminState createState() => _DashboardAdminState();
}

class _DashboardAdminState extends State<DashboardAdmin> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _deleteSong(String id) {
    _firestore.collection('songs').doc(id).delete().then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Song deleted successfully!')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete song: $error')),
      );
    });
  }

  void _editSong(
      String id, String currentTitle, String currentArtist, String currentUrl) {
    final titleController = TextEditingController(text: currentTitle);
    final artistController = TextEditingController(text: currentArtist);
    final urlController = TextEditingController(text: currentUrl);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Song'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: artistController,
                decoration: InputDecoration(labelText: 'Artist'),
              ),
              TextField(
                controller: urlController,
                decoration: InputDecoration(labelText: 'URL'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _firestore.collection('songs').doc(id).update({
                  'title': titleController.text,
                  'artist': artistController.text,
                  'url': urlController.text,
                }).then((_) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Song updated successfully!')),
                  );
                }).catchError((error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to update song: $error')),
                  );
                });
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Admin Dashboard nih yakali ga dengerin',
          style: GoogleFonts.openSans(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, Colors.grey[800]!],
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: _firestore.collection('songs').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(color: Colors.green),
              );
            }

            final songs = snapshot.data!.docs;

            if (songs.isEmpty) {
              return Center(
                child: Text(
                  'No songs available.',
                  style: GoogleFonts.openSans(
                    fontSize: 18.0,
                    color: Colors.white,
                  ),
                ),
              );
            }

            return ListView.builder(
              itemCount: songs.length,
              itemBuilder: (context, index) {
                final songData = songs[index].data() as Map<String, dynamic>;
                final id = songs[index].id;
                final title = songData['title'] ?? 'Unknown Title';
                final artist = songData['artist'] ?? 'Unknown Artist';
                final url = songData['url'] ?? '';

                return Card(
                  margin:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                  color: Colors.grey[900],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ListTile(
                    leading: Icon(
                      FontAwesomeIcons.music,
                      color: Colors.green,
                    ),
                    title: Text(
                      title,
                      style: GoogleFonts.openSans(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    subtitle: Text(
                      artist,
                      style: GoogleFonts.openSans(
                        fontSize: 14.0,
                        color: Colors.grey[400],
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            FontAwesomeIcons.edit,
                            color: Colors.blue,
                          ),
                          onPressed: () => _editSong(id, title, artist, url),
                        ),
                        IconButton(
                          icon: Icon(
                            FontAwesomeIcons.trash,
                            color: Colors.red,
                          ),
                          onPressed: () => _deleteSong(id),
                        ),
                      ],
                    ),
                    onTap: () async {
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Could not play the song'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
