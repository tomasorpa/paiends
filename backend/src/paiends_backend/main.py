from fastapi import FastAPI

app=FastAPI()


async def get_health():
    return {
        "status":"ok"
    }