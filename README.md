# Conecta Fácil

Aplicativo Flutter responsivo para Web e Mobile, com autenticação e serviços usando Firebase.

## Tecnologias
- Flutter (Web, Android, iOS)
- Firebase (Auth, Firestore, Storage)
- Clean Architecture + BLoC
- Responsividade

## Como rodar (Web)
1. Instale as dependências:
   ```sh
   flutter pub get
   ```
2. Configure o Firebase para Web:
   - Adicione o app Web no console do Firebase.
   - Rode:
     ```sh
     flutterfire configure
     ```
   - Isso irá gerar o arquivo `lib/firebase_options.dart`.
3. Rode o app:
   ```sh
   flutter run -d chrome
   ```

## Estrutura do projeto
- `lib/` - Código principal
- `features/` - Features organizadas por domínio
- `core/` - Temas, helpers, configs globais
- `shared/` - Widgets e utilitários compartilhados

---

> Para rodar em Android/iOS, adicione os arquivos de configuração do Firebase para cada plataforma. 