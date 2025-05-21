library settings_service;

/// Sınavda kaç yeni kelime sorulacağını tutar.
int newWordsCount = 10;

/// Ayarı güncellemek için çağrılır.
void setNewWordsCount(int count) {
  newWordsCount =count;
}