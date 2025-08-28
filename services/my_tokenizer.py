import tiktoken
from deepseek_tokenizer import ds_token

def num_tokens_from_messages(messages, model_name):
    encoding = tiktoken.encoding_for_model(model_name)
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



messages = [
    {"role": "system", "content": ""},
    {"role": "user", "content": "hello hello hello"}
]

input_token = num_tokens_from_messages(messages, 'gpt-4o')
print(f"tiktoken: {input_token}")


token_ids = ds_token.encode("hello hello hello")
print("Token IDs:", token_ids)
print("Number of tokens:", len(token_ids))
