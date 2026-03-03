class CloudStorageExceptions implements Exception {
  const CloudStorageExceptions();
}

// C
class CouldNotCreateNoteException extends CloudStorageExceptions {}

// R
class CouldNotGetAllNotesException extends CloudStorageExceptions {}

// U
class CouldNotUpdateNoteException extends CloudStorageExceptions {}

// D
class CouldNotDeleteNoteException extends CloudStorageExceptions {}
