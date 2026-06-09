# FreeQwenApi — Руководство пользователя

> Локальный OpenAI-compatible прокси к Qwen Chat. Fork от [ForgetMeAI](https://t.me/forgetmeai).

---

## Что это такое

FreeQwenApi превращает ваш веб-аккаунт Qwen Chat в локальный API-эндпоинт:

```
http://localhost:3264/api
```

Это **не** локальная модель на видеокарте и **не** официальный API Alibaba. Это browser-based прокси: вы авторизуетесь в Qwen Chat, проект сохраняет сессию и даёт локальный API совместимый с OpenAI SDK.

---

## Быстрый старт

```bash
# 1. Установить зависимости
npm install

# 2. Добавить аккаунт (откроется браузер)
npm run auth

# 3. Обновить список моделей
npm run models:sync

# 4. Запустить сервер
SKIP_ACCOUNT_MENU=true npm start
```

Проверить:
```bash
curl http://localhost:3264/api/health
```

---

## Авторизация аккаунтов

### Добавить аккаунт
```bash
npm run auth -- --add
```
Откроется Chromium. Войдите в Qwen Chat, дождитесь полной загрузки страницы, нажмите ENTER в консоли. Токен сохранится в `session/`.

### Управление аккаунтами
```bash
npm run auth -- --list        # список аккаунтов и статусов
npm run auth -- --relogin     # перезайти в существующий аккаунт
npm run auth -- --remove      # удалить аккаунт
```

### Статусы аккаунтов
| Статус | Значение |
|--------|----------|
| `OK`   | Активен, готов к работе |
| `WAIT` | Токен истекает, нужен перелогин |
| `INVALID` | Токен невалиден, нужен перелогин |

### Мультиаккаунты
При нескольких аккаунтах используется round-robin ротация: при достижении лимита запросов на одном аккаунте автоматически берётся следующий.

---

## Основные API-эндпоинты

### Health check
```bash
curl http://localhost:3264/api/health
```
Возвращает количество моделей, аккаунтов, статус сервиса.

### Список моделей
```bash
curl http://localhost:3264/api/models
```
Обновить: `npm run models:sync`

### Чат (Chat Completions)
```bash
curl http://localhost:3264/api/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "qwen3.7-max",
    "messages": [
      {"role": "user", "content": "Привет!"}
    ],
    "stream": false
  }'
```

**Streaming:**
```bash
curl http://localhost:3264/api/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "qwen3.7-max",
    "messages": [{"role": "user", "content": "Расскажи что-нибудь"}],
    "stream": true
  }'
```

### Генерация изображений
```bash
curl http://localhost:3264/api/images/generations \
  -H "Content-Type: application/json" \
  -d '{
    "prompt": "Кинематографичный робот в неоновом Токио",
    "model": "qwen3-vl-plus",
    "size": "16:9"
  }'
```

Поддерживаемые форматы: `16:9`, `9:16`, `1:1`, `4:3`, `1024x1024`, `1792x1024`, `1024x1792`.

### Генерация видео
```bash
# Создать видео и ждать результат
curl http://localhost:3264/api/videos/generations \
  -H "Content-Type: application/json" \
  -d '{
    "prompt": "Камера медленно приближается к футуристическому городу",
    "size": "16:9",
    "wait": true
  }'

# Или получить task_id и опрашивать отдельно
curl http://localhost:3264/api/videos/generations \
  -H "Content-Type: application/json" \
  -d '{
    "prompt": "Робот идёт под дождём",
    "size": "16:9",
    "wait": false
  }'

# Проверить статус задачи
curl http://localhost:3264/api/tasks/status/TASK_ID
```

---

## Подключение к инструментам

### OpenAI SDK (JavaScript)
```js
import OpenAI from 'openai';

const openai = new OpenAI({
  baseURL: 'http://localhost:3264/api',
  apiKey: 'dummy-key'
});

const response = await openai.chat.completions.create({
  model: 'qwen3.7-max',
  messages: [{ role: 'user', content: 'Привет!' }]
});

console.log(response.choices[0].message.content);
```

### OpenAI SDK (Python)
```python
from openai import OpenAI

client = OpenAI(
    base_url="http://localhost:3264/api",
    api_key="dummy-key"
)

response = client.chat.completions.create(
    model="qwen3.7-max",
    messages=[{"role": "user", "content": "Привет!"}]
)

print(response.choices[0].message.content)
```

### Open WebUI
```
Base URL: http://localhost:3264/api
API Key: dummy-key
Model: qwen3.7-max
```

Для Docker Open WebUI:
```
Base URL: http://host.docker.internal:3264/api
API Key: dummy-key
```

### Hermes Agent (config.yaml)
```yaml
custom_providers:
  - name: qwen-free
    base_url: http://localhost:3264/api
    model: qwen3.7-max
    api_key: dummy-key
```

### LiteLLM (для Claude Code)
```yaml
model_list:
  - model_name: qwen3.7-max
    litellm_params:
      model: openai/qwen3.7-max
      api_base: http://localhost:3264/api
      api_key: dummy-key
```

---

## Рекомендуемые модели

| Модель | Назначение |
|--------|-----------|
| `qwen3.7-max` | Основной чат / агенты |
| `qwen3.7-plus` | Быстрее и легче |
| `qwen3-coder-plus` | Кодинг |
| `qwen3-vl-plus` | Изображения / видео |

---

## Полезные команды

```bash
npm run auth                  # управление аккаунтами
npm run models:sync           # обновить список моделей
npm run smoke                 # быстрая проверка API
SKIP_ACCOUNT_MENU=true npm start  # запустить сервер
```

### Ручные проверки
```bash
curl http://localhost:3264/api/health
curl http://localhost:3264/api/status
curl http://localhost:3264/api/models
curl http://localhost:3264/api/images/status
curl http://localhost:3264/api/videos/status
```

---

## Docker

Сначала авторизуйтесь локально (`npm run auth`), затем:

```bash
docker compose up --build -d
```

Важно в `docker-compose.yml`:
```yaml
volumes:
  - ./session:/app/session
  - ./logs:/app/logs
  - ./uploads:/app/uploads
```

---

## Ограничения и предупреждения

⚠️ **Это неофициальный browser-based прокси.** Qwen может менять внутренний API.

- Аккаунты Qwen Chat могут ловить лимиты — используйте несколько аккаунтов
- Токены истекают — используйте `npm run auth -- --relogin`
- URL сгенерированных медиа могут быть временными
- Для production использовать с осторожностью

---

## Безопасность

**Никогда не коммитьте:**
- `session/` — токены и cookies
- `session/tokens.json`
- `session/accounts/**/token.txt`
- `.env`
- `Authorization.txt`
- `.gitignore` уже исключает эти файлы

---

## Диагностика

### Сервер не запускается
```bash
# Проверить порт
netstat -ano | findstr :3264

# Проверить токены
cat session/tokens.json
```

### Аккаунт в статусе INVALID/WAIT
```bash
npm run auth -- --relogin
```

### Все аккаунты невалидны
```bash
npm run auth -- --remove   # удалить проблемный
npm run auth -- --add      # добавить новый
```

### Тестовый запрос
```bash
npm run smoke
```

---

_Fork от [ForgetMeAI](https://t.me/forgetmeai). Если помог — подпишитесь._
