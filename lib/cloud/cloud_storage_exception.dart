class CloudStorageException implements Exception {
  const CloudStorageException();
}

//CREATE
class CloudNotCreatedException extends CloudStorageException {}

//READ
class CloudNotReadException extends CloudStorageException {}

//UPDATE
class CloudNotUpdateException extends CloudStorageException {}

//DELETE
class CloudNotDeleteException extends CloudStorageException {}
