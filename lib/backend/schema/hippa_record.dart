import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';

class HippaRecord extends FirestoreRecord {
  HippaRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  // "date" field.
  DateTime? _date;
  DateTime? get date => _date;
  bool hasDate() => _date != null;

  // "signature" field.
  String? _signature;
  String get signature => _signature ?? '';
  bool hasSignature() => _signature != null;

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  bool hasName() => _name != null;

  void _initializeFields() {
    _date = snapshotData['date'] as DateTime?;
    _signature = snapshotData['signature'] as String?;
    _name = snapshotData['name'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('hippa');

  static Stream<HippaRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => HippaRecord.fromSnapshot(s));

  static Future<HippaRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => HippaRecord.fromSnapshot(s));

  static HippaRecord fromSnapshot(DocumentSnapshot snapshot) => HippaRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static HippaRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      HippaRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'HippaRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is HippaRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createHippaRecordData({
  DateTime? date,
  String? signature,
  String? name,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'date': date,
      'signature': signature,
      'name': name,
    }.withoutNulls,
  );

  return firestoreData;
}

class HippaRecordDocumentEquality implements Equality<HippaRecord> {
  const HippaRecordDocumentEquality();

  @override
  bool equals(HippaRecord? e1, HippaRecord? e2) {
    return e1?.date == e2?.date &&
        e1?.signature == e2?.signature &&
        e1?.name == e2?.name;
  }

  @override
  int hash(HippaRecord? e) =>
      const ListEquality().hash([e?.date, e?.signature, e?.name]);

  @override
  bool isValidKey(Object? o) => o is HippaRecord;
}
