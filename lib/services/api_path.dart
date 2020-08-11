class APIPath{
  static String collection(String uid, String collectionId) => 'users/$uid/collections/$collectionId';
  static String collections(String uid) => 'users/$uid/collections';
  static String entry(String uid, String entryId) => 'users/$uid/entries/$entryId';
  static String entries(String uid) => 'users/$uid/entries';

}