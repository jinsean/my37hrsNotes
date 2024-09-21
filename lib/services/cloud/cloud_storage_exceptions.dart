class CloudStorageExceptions implements Exception {
  const CloudStorageExceptions();
}

class CouldNotCreateNoteException extends CloudStorageExceptions{}

class CouldNotGetNotesException extends CloudStorageExceptions{}

class CouldNotUpdateNoteException extends CloudStorageExceptions{}

class CouldNotDeleteNoteException extends CloudStorageExceptions{}

class CouldNotGetAllNotesException extends CloudStorageExceptions{}