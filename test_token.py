from openai import OpenAI
import tiktoken

client = OpenAI(api_key="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")

messages = [
    {"role": "system", "content": "تو یک دستیار هوشمند هستی."},
    {"role": "user", "content": "لطفاً یک شعر کوتاه در مورد خورشید بگو."}
]

model_name = "gpt-4o"

# 1️⃣ محاسبه ورودی با tiktoken
encoding = tiktoken.encoding_for_model(model_name)

def num_tokens_from_messages(messages, encoding):
    tokens_per_message = 3
    tokens_per_name = 1
    num_tokens = 0
    for msg in messages:
        num_tokens += tokens_per_message
        for key, value in msg.items():
            num_tokens += len(encoding.encode(value))
            if key == "name":
                num_tokens += tokens_per_name
    num_tokens += 3
    return num_tokens

predicted_input_tokens = num_tokens_from_messages(messages, encoding)
print(f"📌 پیش‌بینی tiktoken (ورودی): {predicted_input_tokens}")

# 2️⃣ درخواست واقعی به OpenAI
response = client.chat.completions.create(
    model=model_name,
    messages=messages
)

prompt_tokens = response.usage.prompt_tokens
completion_tokens = response.usage.completion_tokens
total_tokens = response.usage.total_tokens

print(f"📝 گزارش OpenAI:")
print(f"   ورودی: {prompt_tokens}")
print(f"   خروجی: {completion_tokens}")
print(f"   مجموع: {total_tokens}")

# 3️⃣ مقایسه
diff_input = prompt_tokens - predicted_input_tokens
print(f"📊 اختلاف پیش‌بینی با واقعی: {diff_input} توکن")

# چاپ پاسخ (در فایل برای جلوگیری از مشکل فارسی در ترمینال)
with open("output.txt", "w", encoding="utf-8") as f:
    f.write(response.choices[0].message.content)
print("✅ پاسخ در output.txt ذخیره شد")
