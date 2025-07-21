# services/assistant.py
import os
from langchain_community.embeddings import OpenAIEmbeddings
from langchain_community.vectorstores import FAISS
from langchain_openai import OpenAIEmbeddings, ChatOpenAI
from langchain.chains import RetrievalQA
from sqlalchemy.orm import Session
from models.assistant import Assistant

def get_assistant_by_id(db: Session, assistant_id: int) -> Assistant | None:
    return db.query(Assistant).filter(Assistant.id == assistant_id).first()

async def load_vectorstore_for_assistant(db: Session, assistant_id: int):
    assistant = get_assistant_by_id(db, assistant_id)
    if not assistant:
        raise FileNotFoundError(f"Assistant with ID {assistant_id} not found in database.")

    faiss_path = assistant.faiss_url.replace("\\", "/")
    base_path = os.path.dirname(faiss_path)

    if not os.path.exists(faiss_path):
        raise FileNotFoundError(f"FAISS file not found at {faiss_path}")

    embed = OpenAIEmbeddings(model="text-embedding-3-small")
    vectorstore = FAISS.load_local(base_path, embed, allow_dangerous_deserialization=True)
    retriever = vectorstore.as_retriever(search_type="similarity", search_kwargs={"k": 3})
    qa_chain = RetrievalQA.from_chain_type(llm=ChatOpenAI(model="gpt-3.5-turbo"), retriever=retriever)

    return qa_chain, retriever