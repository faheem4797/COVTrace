import 'dart:io';
import "package:flutter/material.dart";
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:file_picker/file_picker.dart';
import 'dashboard.dart';

class AdminPublications extends StatefulWidget {
  @override
  _AdminPublicationsState createState() => _AdminPublicationsState();
}

class _AdminPublicationsState extends State<AdminPublications> {
  String urlPDFPath;
  String documentFileName;
  bool spinner = false;

  final CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('publications');
  final firestore = FirebaseFirestore.instance;

  File sampleDoc;
  String fileName;
  bool fileExist = false;

  Future<void> _getDocument() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      PlatformFile fileDetails = result.files.first;
      setState(() {
        sampleDoc = File(result.files.single
            .path); //This stores the path of file from the local storage like /data/user/0/com.faheem.covtrace_authentication/cache/file_picker/The Hobbit ( PDFDrive ).pdf
        setState(() {
          fileName = fileDetails.name;
        });
      });
    } else {
      print('User canceled the picker');
    }
  }

  Future<String> uploadFile(String destination, File file) async {
    try {
      await firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .putFile(file);

      String tempDownloadURL = await firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .getDownloadURL();

      return tempDownloadURL;
    } on FirebaseException catch (e) {
      print(e);
      return null;
    }
  }

  Future<File> getFileFromUrl(String url) async {
    setState(() {
      spinner = true;
    });
    try {
      final data = await http.get(Uri.parse(url));
      var bytes = data.bodyBytes;
      var dir = await getExternalStorageDirectory();
      final filename = basename(url);
      File file = File('${dir.path}/$filename');
      File urlFile = await file.writeAsBytes(bytes);
      print(1);
      setState(() {
        spinner = false;
      });
      return urlFile;
    } catch (e) {
      print(7);
      throw Exception("Error opening url file");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.redAccent.shade100,
      appBar: AppBar(
        title: Text('Health Publications'),
        backgroundColor: Colors.redAccent,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () async {
              print('here 0');
              await _getDocument();

              await collectionReference
                  .get()
                  .then((QuerySnapshot querySnapshot) {
                querySnapshot.docs.forEach((doc) {
                  if (doc['name'] == fileName || fileName == null) {
                    print(fileName);
                    print(doc['name']);
                    setState(() {
                      fileExist = true;
                    });
                  }
                });
              });
              if (fileExist == false) {
                setState(() {
                  spinner = true;
                });
                try {
                  String temp = await uploadFile(fileName, sampleDoc);
                  await firestore.collection('publications').add(
                    {'name': fileName, 'url': temp},
                  );
                  setState(() {
                    spinner = false;
                    fileName = null;
                  });
                } catch (e) {
                  print(e);
                }
              } else {
                print('error 0000');
                setState(() {
                  fileExist = false;
                });
              }
            },
          )
        ],
      ),
      drawer: AdminDrawerBuilder(),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Expanded(
                child: StreamBuilder(
              stream: collectionReference.snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  return ModalProgressHUD(
                    inAsyncCall: spinner,
                    child: Container(
                      child: ListView(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 50),
                        children: snapshot.data.docs
                            .map((currentDoc) => Column(
                                  children: [
                                    ListTile(
                                      onLongPress: () {
                                        collectionReference
                                            .doc(currentDoc.id)
                                            .delete();
                                      },
                                      onTap: () async {
                                        await getFileFromUrl(currentDoc['url'])
                                            .then((f) {
                                          setState(() {
                                            try {
                                              urlPDFPath = f.path;
                                              documentFileName =
                                                  currentDoc['name'];
                                              print(urlPDFPath);
                                            } catch (e) {
                                              print(e);
                                            }
                                          });
                                        });
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => PdfViewPage(
                                                path: urlPDFPath,
                                                filename: documentFileName),
                                          ),
                                        );
                                      },
                                      title: Text(currentDoc['name'],
                                          style: TextStyle(
                                            color: Colors.white,
                                          )),
                                    ),
                                    Divider(
                                      color: Colors.black26,
                                      thickness: 2,
                                    )
                                  ],
                                ))
                            .toList(),
                      ),
                    ),
                  );
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ))
          ],
        ),
      ),
    );
  }
}

class PdfViewPage extends StatefulWidget {
  final String path;
  final String filename;

  const PdfViewPage({this.path, this.filename});
  @override
  _PdfViewPageState createState() => _PdfViewPageState();
}

class _PdfViewPageState extends State<PdfViewPage> {
  bool pdfReady = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.redAccent.shade100,
      appBar: AppBar(
        title: Text(widget.filename),
        backgroundColor: Colors.redAccent,
      ),
      body: Stack(
        children: <Widget>[
          PDFView(
            filePath: widget.path,
            autoSpacing: true,
            enableSwipe: true,
            pageSnap: true,
            swipeHorizontal: true,
            nightMode: false,
            onError: (e) {
              print(e);
            },
            onRender: (_pages) {
              setState(() {
                pdfReady = true;
              });
            },
            onPageChanged: (int page, int total) {
              setState(() {});
            },
            onPageError: (page, e) {},
          ),
          !pdfReady
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Offstage()
        ],
      ),
    );
  }
}
