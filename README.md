# 📱 Flutter App - TodoApp

Aplicativo desenvolvido em Flutter para Gerenciamento de Tarefas.

<img width=300 src="./assets/iScreen%20Shoter%20-%2020250703194042825.png" />

<p align="center">
  Preview da tela inicial do app.
</p>

---

## ✅ Tecnologias utilizadas

- Flutter 3.x
- Dart
- Shared Preferences (para armazenar o token JWT)
- HTTP
- FlutterToast
- ImagePicker

---

## 📁 Estrutura do Projeto

```
lib/
├── main.dart
├── model/
├── service/
├── screens/
├── widgets/
├── providers/ (opcional)
└── utils/
```

---

## ▶️ Como rodar o projeto

### 1. Instale as dependências

```bash
flutter pub get
```

### 2. Execute o app

```bash
flutter run
```

> Certifique-se de que há um emulador Android/iOS aberto ou um dispositivo conectado.

---

## 🧪 Rodando testes

```bash
flutter test
```

---

## 📱 Build para produção

```bash
flutter build apk --release
```

Para web:

```bash
flutter build web
```

---

## 🧩 Dependências comuns

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^0.13.6
  shared_preferences: ^2.1.0
  provider: ^6.1.0
  image_picker: ^1.0.4
  fluttertoast: ^8.2.2
```

---

## 📄 Licença

Este projeto está licenciado sob a [MIT License](LICENSE).
