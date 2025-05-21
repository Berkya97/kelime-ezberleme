import json
import os

# 1. Dosya yolları
old_path = 'assets/data/words.json'
new_path = 'assets/data/new_words.json'

# 2. Eski ve yeni JSON'ları oku
with open(old_path, encoding='utf-8') as f:
    old_list = json.load(f)

with open(new_path, encoding='utf-8') as f:
    new_list = json.load(f)

# 3. ID çatışması olmaması için
max_id = max(item['id'] for item in old_list) if old_list else 0
for i, item in enumerate(new_list, start=1):
    item['id'] = max_id + i

# 4. Birleştir ve yaz
merged = old_list + new_list
with open(old_path, 'w', encoding='utf-8') as f:
    json.dump(merged, f, ensure_ascii=False, indent=2)

print(f"✅ Birleştirildi: {len(old_list)} + {len(new_list)} -> {len(merged)} kayıt")
